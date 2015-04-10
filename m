Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B912A7FA7
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 08:38:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88B18304048
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 06:38:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jESpU4IKETkzrtot for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 06:38:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YgZ8E-0001Ph-5c
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YgZ8E-00068m-4z
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: DIO write completion size updates race
Date: Fri, 10 Apr 2015 23:37:58 +1000
Message-Id: <1428673080-23052-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1428673080-23052-1-git-send-email-david@fromorbit.com>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_end_io_direct_write() can race with other IO completions when
updating the in-core inode size. The IO completion processing is not
serialised for direct IO - they are done either under the
IOLOCK_SHARED for non-AIO DIO, and without any IOLOCK held at all
during AIO DIO completion. Hence the non-atomic test-and-set update
of the in-core inode size is racy and can result in the in-core
inode size going backwards if the race if hit just right.

If the inod size goes backwards, this can trigger the EOF zeroing
code to run incorrectly on the next IO, which then will zero data
that has successfully been written to disk by a previous DIO.

To fix this bug, we need to serialise the test/set updates of the
in-core inode size. This first patch introduces locking around the
relevant updates and checks in the DIO path. Because we now have an
ioend in xfs_end_io_direct_write(), we know exactly then we are
doing an IO that requires an in-core EOF update, and we know that
they are not running in interrupt context. As such, we do not need to
use irqsave() spinlock variants to protect against interrupts while
the lock is held.

Hence we can use an existing spinlock in the inode to do this
serialisation and so not need to grow the struct xfs_inode just to
work around this problem.

This patch does not address the test/set EOF update in
generic_file_write_direct() for various reasons - that will be done
as a followup with separate explanation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 17 ++++++++++++-----
 fs/xfs/xfs_file.c | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 52c7e46..aafd54c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1616,21 +1616,28 @@ xfs_end_io_direct_write(
 	/*
 	 * The ioend tells us whether we are doing unwritten extent conversion
 	 * or an append transaction that updates the on-disk file size. These
-	 * cases are the only cases where we should *potentially* be needing
-	 * to update the VFS inode size. When the ioend indicates this, we
-	 * are *guaranteed* to be running in non-interrupt context.
+	 * cases are the only cases where we should *potentially* be needing to
+	 * update the VFS inode size. When the ioend indicates this, we are
+	 * *guaranteed* to be running in non-interrupt context.
 	 *
 	 * We need to update the in-core inode size here so that we don't end up
 	 * with the on-disk inode size being outside the in-core inode size.
 	 * While we can do this in the process context after the IO has
-	 * completed, this does not work for AIO and hence we always update
-	 * the in-core inode size here if necessary.
+	 * completed, this does not work for AIO and hence we always update the
+	 * in-core inode size here if necessary.
+	 *
+	 * We need to lock the test/set EOF update as we can be racing with
+	 * other IO completions here to update the EOF. Failing to serialise
+	 * here can result in EOF moving backwards and Bad Things Happen when
+	 * that occurs.
 	 */
+	spin_lock(&ip->i_flags_lock);
 	if (ioend->io_type == XFS_IO_UNWRITTEN || ioend->io_append_trans) {
 		if (offset + size > i_size_read(inode))
 			i_size_write(inode, offset + size);
 	} else
 		ASSERT(offset + size <= i_size_read(inode));
+	spin_unlock(&ip->i_flags_lock);
 
 	/* Ugh. No way to propagate errors, so ignore them. */
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dc5f609..38ff356 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -569,10 +569,20 @@ restart:
 	 * write.  If zeroing is needed and we are currently holding the
 	 * iolock shared, we need to update it to exclusive which implies
 	 * having to redo all checks before.
+	 *
+	 * We need to serialise against EOF updates that occur in IO
+	 * completions here. We want to make sure that nobody is changing the
+	 * size while we do this check until we have placed an IO barrier (i.e.
+	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
+	 * The spinlock effectively forms a memory barrier once we have the
+	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
+	 * and hence be able to correctly determine if we need to run zeroing.
 	 */
+	spin_lock(&ip->i_flags_lock);
 	if (*pos > i_size_read(inode)) {
 		bool	zero = false;
 
+		spin_unlock(&ip->i_flags_lock);
 		if (*iolock == XFS_IOLOCK_SHARED) {
 			xfs_rw_iunlock(ip, *iolock);
 			*iolock = XFS_IOLOCK_EXCL;
@@ -582,7 +592,8 @@ restart:
 		error = xfs_zero_eof(ip, *pos, i_size_read(inode), &zero);
 		if (error)
 			return error;
-	}
+	} else
+		spin_unlock(&ip->i_flags_lock);
 
 	/*
 	 * Updating the timestamps will grab the ilock again from
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
