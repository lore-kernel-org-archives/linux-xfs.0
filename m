Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 00:23:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9O7N3aG005321
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 00:23:05 -0700
Date: Tue, 24 Oct 2006 17:22:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: [REVIEW 4 of 4] Fix race in xfs_iunpin
Message-ID: <20061024072214.GU11034@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: t-nagano@ah.jp.nec.com, xfs-dev@sgi.com


-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


Close a race condition in xfs_iunpin() -  we need to guarantee the
atomicity of the last unpin and the checking of the XFS_IRECLAIM*
flags otherwise pre-emption or interrupt can cause us to race with
xfs_iget_core() which would now see the inode as unpinned and hence
clear the XFS_IRECLAIMABLE flag.

---
 fs/xfs/xfs_inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-19 10:26:01.983441994 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-19 10:29:31.008384156 +1000
@@ -2741,7 +2741,7 @@ xfs_iunpin(
 {
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 
-	if (atomic_dec_and_test(&ip->i_pincount)) {
+	if (atomic_dec_and_lock(&ip->i_pincount, &ip->i_flags_lock)) {
 
 		/*
 		 * If the inode is currently being reclaimed, the link between
@@ -2760,7 +2760,6 @@ xfs_iunpin(
 		 * unpinned.
 		 */
 
-		spin_lock(&ip->i_flags_lock);
 		if (!__xfs_iflags_test(ip, XFS_IRECLAIM|XFS_IRECLAIMABLE)) {
 			bhv_vnode_t	*vp = XFS_ITOV_NULL(ip);
 			struct inode *inode = NULL;
