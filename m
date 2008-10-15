Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 23:18:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F6I4ko013306
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 23:18:04 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AB5F4FD7CB
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 23:19:45 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 08y0BkOhHnkleYA0 for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 23:19:45 -0700 (PDT)
Date: Wed, 15 Oct 2008 17:19:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: crash with latest code drop.
Message-ID: <20081015061917.GC25906@disturbed>
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F584B8.8060907@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 15, 2008 at 03:50:48PM +1000, Peter Leckie wrote:
> Dave Chinner wrote:
>> Update below.
>>
>> Cheers,
>>
>> Dave.
>>   
> The original patch appeared to fix the issue, however the latest one  
> Oops as follows:

Well, I think the problem dhould be obvious - it's the same as
the first report - deferencing the linux inode without first having
a refernce on it.

FWIW, if you apply the "combine linux/xfs inode" patch series,
this failure will go away.

Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

XFS: avoid all reclaimable inodes in xfs_sync_inodes_ag

If we are syncing data in xfs_sync_inodes_ag(), the VFS
inode must still be referencable as the dirty data state
is carried on the VFS inode. hence if we can't get a
reference via igrab(), the inode must be in reclaim which
implies that it has no dirty data attached.

Leave such inodes to the reclaim code to flush the dirty
inode state to disk and so avoid attempting to access the
VFS inode when it may not exist in xfs_sync_inodes_ag().

Version 4:
o don't reference liinux inode untiil after igrab() succeeds

Version 3:
o converted unlock/rele to an xfs_iput() call.

Version 2:
o change igrab logic to be more linear
o remove initial reclaimable inode check now that we are using
  igrab() failure to find reclaimable inodes
o assert that igrab failure occurs only on reclaimable inodes
o clean up inode locking - only grab the iolock if we are doing
  a SYNC_DELWRI call and we have a dirty inode.
---
 fs/xfs/linux-2.6/xfs_sync.c |   75 ++++++++++--------------------------------
 1 files changed, 18 insertions(+), 57 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 08b2acf..39ed7f3 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -63,25 +63,16 @@ xfs_sync_inodes_ag(
 	int		error = 0;
 	int		last_error = 0;
 	int		fflag = XFS_B_ASYNC;
-	int		lock_flags = XFS_ILOCK_SHARED;
 
 	if (flags & SYNC_DELWRI)
 		fflag = XFS_B_DELWRI;
 	if (flags & SYNC_WAIT)
 		fflag = 0;		/* synchronous overrides all */
 
-	if (flags & SYNC_DELWRI) {
-		/*
-		 * We need the I/O lock if we're going to call any of
-		 * the flush/inval routines.
-		 */
-		lock_flags |= XFS_IOLOCK_SHARED;
-	}
-
 	do {
 		struct inode	*inode;
-		boolean_t	inode_refed;
 		xfs_inode_t	*ip = NULL;
+		int		lock_flags = XFS_ILOCK_SHARED;
 
 		/*
 		 * use a gang lookup to find the next inode in the tree
@@ -109,22 +100,6 @@ xfs_sync_inodes_ag(
 			break;
 		}
 
-		/*
-		 * skip inodes in reclaim. Let xfs_syncsub do that for
-		 * us so we don't need to worry.
-		 */
-		if (xfs_iflags_test(ip, (XFS_IRECLAIM|XFS_IRECLAIMABLE))) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
-
-		/* bad inodes are dealt with elsewhere */
-		inode = VFS_I(ip);
-		if (is_bad_inode(inode)) {
-			read_unlock(&pag->pag_ici_lock);
-			continue;
-		}
-
 		/* nothing to sync during shutdown */
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			read_unlock(&pag->pag_ici_lock);
@@ -132,42 +107,34 @@ xfs_sync_inodes_ag(
 		}
 
 		/*
-		 * If we can't get a reference on the VFS_I, the inode must be
-		 * in reclaim. If we can get the inode lock without blocking,
-		 * it is safe to flush the inode because we hold the tree lock
-		 * and xfs_iextract will block right now. Hence if we lock the
-		 * inode while holding the tree lock, xfs_ireclaim() is
-		 * guaranteed to block on the inode lock we now hold and hence
-		 * it is safe to reference the inode until we drop the inode
-		 * locks completely.
+		 * If we can't get a reference on the inode, it must be
+		 * in reclaim. Leave it for the reclaim code to flush.
 		 */
-		inode_refed = B_FALSE;
-		if (igrab(inode)) {
-			read_unlock(&pag->pag_ici_lock);
-			xfs_ilock(ip, lock_flags);
-			inode_refed = B_TRUE;
-		} else {
-			if (!xfs_ilock_nowait(ip, lock_flags)) {
-				/* leave it to reclaim */
-				read_unlock(&pag->pag_ici_lock);
-				continue;
-			}
+		inode = VFS_I(ip);
+		if (!igrab(inode)) {
 			read_unlock(&pag->pag_ici_lock);
+			continue;
+		}
+		read_unlock(&pag->pag_ici_lock);
+
+		/* bad inodes are dealt with elsewhere */
+		if (is_bad_inode(inode)) {
+			IRELE(ip);
+			continue;
 		}
 
 		/*
 		 * If we have to flush data or wait for I/O completion
-		 * we need to drop the ilock that we currently hold.
-		 * If we need to drop the lock, insert a marker if we
-		 * have not already done so.
+		 * we need to hold the iolock.
 		 */
 		if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			xfs_ilock(ip, XFS_IOLOCK_SHARED);
+			lock_flags |= XFS_IOLOCK_SHARED;
 			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
 			if (flags & SYNC_IOWAIT)
 				vn_iowait(ip);
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
 
 		if ((flags & SYNC_ATTR) && !xfs_inode_clean(ip)) {
 			if (flags & SYNC_WAIT) {
@@ -183,13 +150,7 @@ xfs_sync_inodes_ag(
 					xfs_ifunlock(ip);
 			}
 		}
-
-		if (lock_flags)
-			xfs_iunlock(ip, lock_flags);
-
-		if (inode_refed) {
-			IRELE(ip);
-		}
+		xfs_iput(ip, lock_flags);
 
 		if (error)
 			last_error = error;
