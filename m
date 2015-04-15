Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF01E7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 23:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A49C5304043
	for <xfs@oss.sgi.com>; Tue, 14 Apr 2015 21:52:01 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZjlEbhuK6H9nOS5w for <xfs@oss.sgi.com>;
	Tue, 14 Apr 2015 21:51:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YiFIo-00032X-9o
	for xfs@oss.sgi.com; Wed, 15 Apr 2015 14:51:54 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YiFIo-0005Ec-96
	for xfs@oss.sgi.com; Wed, 15 Apr 2015 14:51:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: DIO write completion size updates race
Date: Wed, 15 Apr 2015 14:51:49 +1000
Message-Id: <1429073512-20035-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1429073512-20035-1-git-send-email-david@fromorbit.com>
References: <1429073512-20035-1-git-send-email-david@fromorbit.com>
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

If the inode size goes backwards, this can trigger the EOF zeroing
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c |  7 +++++++
 fs/xfs/xfs_file.c | 13 ++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c02a474..598b259 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1582,9 +1582,16 @@ xfs_end_io_direct_write(
 	 * with the on-disk inode size being outside the in-core inode size. We
 	 * have no other method of updating EOF for AIO, so always do it here
 	 * if necessary.
+	 *
+	 * We need to lock the test/set EOF update as we can be racing with
+	 * other IO completions here to update the EOF. Failing to serialise
+	 * here can result in EOF moving backwards and Bad Things Happen when
+	 * that occurs.
 	 */
+	spin_lock(&ip->i_flags_lock);
 	if (offset + size > i_size_read(inode))
 		i_size_write(inode, offset + size);
+	spin_unlock(&ip->i_flags_lock);
 
 	/*
 	 * If we are doing an append IO that needs to update the EOF on disk,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c203839..5d5b4ba 100644
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
