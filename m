Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SH9rfW175910 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 12:09:53 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id C1497382BC6
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 10:13:03 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with SMTP id NfMVL1EPLWmMdGLo for <xfs@oss.sgi.com>;
	Mon, 28 Mar 2011 10:13:03 -0700 (PDT)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfs: cleanup duplicate initializations
Date: Mon, 28 Mar 2011 19:12:53 +0200
Message-Id: <1301332373-24914-1-git-send-email-dsterba@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: David Sterba <dsterba@suse.cz>, aelder@sgi.com

follow these guidelines:
- leave initialization in the declaration block if it fits the line
- move to the code where it's more suitable ('for' init block)

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/xfs/xfs_dfrag.c      |    6 +-----
 fs/xfs/xfs_inode_item.c |    1 -
 fs/xfs/xfs_mount.c      |    2 +-
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index be62867..9a84a85 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -202,7 +202,7 @@ xfs_swap_extents(
 	xfs_inode_t	*tip,	/* tmp inode */
 	xfs_swapext_t	*sxp)
 {
-	xfs_mount_t	*mp;
+	xfs_mount_t	*mp = ip->i_mount;
 	xfs_trans_t	*tp;
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
@@ -212,16 +212,12 @@ xfs_swap_extents(
 	int		taforkblks = 0;
 	__uint64_t	tmp;
 
-	mp = ip->i_mount;
-
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = XFS_ERROR(ENOMEM);
 		goto out;
 	}
 
-	sbp = &sxp->sx_stat;
-
 	/*
 	 * we have to do two separate lock calls here to keep lockdep
 	 * happy. If we try to get all the locks in one call, lock will
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 46cc401..c64458b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -957,7 +957,6 @@ xfs_iflush_abort(
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
-	iip = ip->i_itemp;
 	if (iip) {
 		struct xfs_ail	*ailp = iip->ili_item.li_ailp;
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bb3f9a7..08de13d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1900,7 +1900,7 @@ xfs_mod_incore_sb_batch(
 	uint			nmsb,
 	int			rsvd)
 {
-	xfs_mod_sb_t		*msbp = &msb[0];
+	xfs_mod_sb_t		*msbp;
 	int			error = 0;
 
 	/*
-- 
1.7.4.1.176.g501cc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
