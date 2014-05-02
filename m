Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADBA47F55
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 02:01:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30619AC003
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 00:01:00 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	pTpTMGiYPdeN0oNH for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 00:00:57 -0700 (PDT)
Date: Fri, 2 May 2014 17:00:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs: truncate_setsize should be outside transactions
Message-ID: <20140502070054.GC26353@dastard>
References: <1398983979-23696-1-git-send-email-david@fromorbit.com>
	<20140502045443.GA8867@infradead.org>
	<20140502050053.GA17578@infradead.org>
	<20140502064700.GB26353@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140502064700.GB26353@dastard>
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
that we can't change the file size until after we are in the
transaction context and the operation will either succeed or shut
down the filesystem on failure. Hence we have to split
truncate_setsize() back into a pagecache operation that occurs
before the transaction context, and a i_size_write() call that
happens within the transaction context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ef1ca01..ab2dc47 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -808,22 +808,27 @@ xfs_setattr_size(
 	 */
 	inode_dio_wait(inode);
 
+	/*
+	 * Do all the page cache truncate work outside the transaction
+	 * context as the "lock" order is page lock->log space reservation.
+	 * i.e. locking pages inside the transaction can ABBA deadlock with
+	 * writeback. We have to do the inode size update inside the
+	 * transaction, however, as xfs_trans_reserve() can fail with ENOMEM
+	 * and we can't make user visible changes on non-fatal errors.
+	 */
 	error = -block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
 	if (error)
 		return error;
+	truncate_pagecache(inode, newsize);
 
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
@@ -856,6 +861,7 @@ xfs_setattr_size(
 	 * they get written to.
 	 */
 	ip->i_d.di_size = newsize;
+	i_size_write(inode, newsize);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (newsize <= oldsize) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
