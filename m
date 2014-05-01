Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C18067F55
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 17:40:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE0678F8035
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 15:40:37 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	4ucC7wBH4bsecJml for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 15:40:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wfzdj-0006aO-Fv
	for xfs@oss.sgi.com; Fri, 02 May 2014 08:39:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wfzdj-0006Ao-Eo
	for xfs@oss.sgi.com; Fri, 02 May 2014 08:39:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: truncate_setsize should be outside transactions
Date: Fri,  2 May 2014 08:39:39 +1000
Message-Id: <1398983979-23696-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ef1ca01..84db577 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -808,22 +808,25 @@ xfs_setattr_size(
 	 */
 	inode_dio_wait(inode);
 
+	/*
+	 * Do all the page cache truncate work outside the transaction
+	 * context as the "lock" order is page lock->log space reservation.
+	 * i.e. locking pages inside the transaction can ABBA deadlock with
+	 * writeback.
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
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
