Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4B717F56
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 00:20:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C92D58F8033
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 22:20:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tvyMSJ2bBv4jye9S for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 22:19:59 -0700 (PDT)
Date: Mon, 5 May 2014 15:19:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V3] xfs: truncate_setsize should be outside transactions
Message-ID: <20140505051941.GU26353@dastard>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard> <20140502070054.GC26353@dastard>
	<20140502100802.GB14028@infradead.org>
	<20140502232339.GD26353@dastard>
	<20140503151601.GB28608@infradead.org>
	<20140504000618.GK26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140504000618.GK26353@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

truncate_setsize() removes pages from the page cache, and hence
requires page locks to be held. It is not valid to lock a page cache
page inside a transaction context as we can hold page locks when we
we reserve space for a transaction. If we do, then we expose an ABBA
deadlock between log space reservation and page locks.

That is, both the write path and writeback lock a page, then start a
transaction for block allocation, which means they can block waiting
for a log reservation with the page lock held. If we hold a log
reservation and then do something that locks a page (e.g.
truncate_setsize in xfs_setattr_size) then that page lock can block
on the page locked and waiting for a log reservation. If the
transaction that is waiting for the page lock is the only active
transaction in the system that can free log space via a commit,
then writeback will never make progress and so log space will never
free up.

This issue with xfs_setattr_size() was introduced back in 2010 by
commit fa9b227 ("xfs: new truncate sequence") which moved the page
cache truncate from outside the transaction context (what was
xfs_itruncate_data()) to inside the transaction context as a call to
truncate_setsize().

The reason truncate_setsize() was located where in this place was
that we can't shouldn't change the file size until after we are in
the transaction context and the operation will either succeed or
shut down the filesystem on failure. However, block_truncate_page()
already modifies the file contents before we enter the transaction
context, so we can't really fulfill this guarantee in any way. Hence
we may as well ensure that on success or failure, the in-memory
inode and data is truncated away and that the application cleans up
the mess appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---

V3 - revert back to original fix but expand the comment to explain
why the truncate is done this way.

 fs/xfs/xfs_iops.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ef1ca01..9ef6394 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -808,22 +808,34 @@ xfs_setattr_size(
 	 */
 	inode_dio_wait(inode);
 
+	/*
+	 * Do all the page cache truncate work outside the transaction context
+	 * as the "lock" order is page lock->log space reservation.  i.e.
+	 * locking pages inside the transaction can ABBA deadlock with
+	 * writeback. We have to do the VFS inode size update before we truncate
+	 * the pagecache, however, to avoid racing with page faults beyond the
+	 * new EOF they are not serialised against truncate operations except by
+	 * page locks and size updates.
+	 *
+	 * Hence we are in a situation where a truncate can fail with ENOMEM
+	 * from xfs_trans_reserve(), but having already truncated the in-memory
+	 * version of the file (i.e. made user visible changes). There's not
+	 * much we can do about this, except to hope that the caller sees ENOMEM
+	 * and retries the truncate operation.
+	 */
 	error = -block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
 	if (error)
 		return error;
+	truncate_setsize(inode, newsize);
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
 	if (error)
 		goto out_trans_cancel;
 
-	truncate_setsize(inode, newsize);
-
 	commit_flags = XFS_TRANS_RELEASE_LOG_RES;
 	lock_flags |= XFS_ILOCK_EXCL;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
