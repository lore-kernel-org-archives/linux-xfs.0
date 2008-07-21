Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:46:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBjtnT021642
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:45:55 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91EA830D989
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id dUCkEfkeE6SEjbWv for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:03 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] XFS: Kill shouty XFS_ITOV() macro
Date: Mon, 21 Jul 2008 21:46:59 +1000
Message-Id: <1216640819-19924-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1216640819-19924-1-git-send-email-david@fromorbit.com>
References: <1216640819-19924-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

Replace XFS_ITOV() with the new VFS_I() inline.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_ioctl.c |    4 ++--
 fs/xfs/linux-2.6/xfs_iops.c  |    2 +-
 fs/xfs/linux-2.6/xfs_linux.h |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/quota/xfs_dquot.c     |    2 +-
 fs/xfs/xfs_bmap.c            |    2 +-
 fs/xfs/xfs_dfrag.c           |    4 ++--
 fs/xfs/xfs_inode.c           |    4 ++--
 fs/xfs/xfs_inode.h           |    1 -
 fs/xfs/xfs_itable.c          |    2 +-
 fs/xfs/xfs_utils.h           |    4 ++--
 fs/xfs/xfs_vfsops.c          |    8 ++++----
 fs/xfs/xfs_vnodeops.c        |   10 +++++-----
 13 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
index bae2e91..b6c0450 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -247,7 +247,7 @@ xfs_vget_fsop_handlereq(
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	*inode = XFS_ITOV(ip);
+	*inode = VFS_I(ip);
 	return 0;
 }
 
@@ -1162,7 +1162,7 @@ xfs_ioctl_setattr(
 				(mask & FSX_NONBLOCK) ? DM_FLAGS_NDELAY : 0);
 	}
 
-	vn_revalidate(XFS_ITOV(ip));	/* update flags */
+	vn_revalidate(VFS_I(ip));	/* update flags */
 	return 0;
 
  error_return:
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 5825ab4..7cdbd60 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -101,7 +101,7 @@ xfs_ichgtime(
 	xfs_inode_t	*ip,
 	int		flags)
 {
-	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
+	struct inode	*inode = VFS_I(ip);
 	timespec_t	tv;
 
 	nanotime(&tv);
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 4d45d93..a9cd6e4 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -180,7 +180,7 @@
 #define xfs_sort(a,n,s,fn)	sort(a,n,s,fn,NULL)
 #define xfs_stack_trace()	dump_stack()
 #define xfs_itruncate_data(ip, off)	\
-	(-vmtruncate(vn_to_inode(XFS_ITOV(ip)), (off)))
+	(-vmtruncate(vn_to_inode(VFS_I(ip)), (off)))
 
 
 /* Move the kernel do_div definition off to one side */
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a507762..74add64 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1132,7 +1132,7 @@ void
 xfs_flush_device(
 	xfs_inode_t	*ip)
 {
-	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
+	struct inode	*inode = VFS_I(ip);
 
 	igrab(inode);
 	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index fc9f3fb..68adc5f 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -431,7 +431,7 @@ xfs_qm_dqalloc(
 	 * when it unlocks the inode. Since we want to keep the quota
 	 * inode around, we bump the vnode ref count now.
 	 */
-	VN_HOLD(XFS_ITOV(quotip));
+	VN_HOLD(VFS_I(quotip));
 
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 	nmaps = 1;
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 3c4beb3..2f46b67 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4000,7 +4000,7 @@ xfs_bmap_add_attrfork(
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
-	VN_HOLD(XFS_ITOV(ip));
+	VN_HOLD(VFS_I(ip));
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	switch (ip->i_d.di_format) {
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 2211e88..9e75101 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -150,8 +150,8 @@ xfs_swap_extents(
 	}
 
 	sbp = &sxp->sx_stat;
-	vp = XFS_ITOV(ip);
-	tvp = XFS_ITOV(tip);
+	vp = VFS_I(ip);
+	tvp = VFS_I(tip);
 
 	/* Lock in i_ino order */
 	if (ip->i_ino < tip->i_ino) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ae19b05..92a054c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1077,7 +1077,7 @@ xfs_ialloc(
 	}
 	ASSERT(ip != NULL);
 
-	vp = XFS_ITOV(ip);
+	vp = VFS_I(ip);
 	ip->i_d.di_mode = (__uint16_t)mode;
 	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
@@ -1408,7 +1408,7 @@ xfs_itruncate_start(
 	       (flags == XFS_ITRUNC_MAYBE));
 
 	mp = ip->i_mount;
-	vp = XFS_ITOV(ip);
+	vp = VFS_I(ip);
 
 	/* wait for the completion of any pending DIOs */
 	if (new_size < ip->i_size)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5dd4796..ebaea3b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -271,7 +271,6 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 {
 	return (struct inode *)ip->i_vnode;
 }
-#define	XFS_ITOV(ip)		VFS_I(ip)
 
 /*
  * i_flags helper functions
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 9a3ef9d..4feda54 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -72,7 +72,7 @@ xfs_bulkstat_one_iget(
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_blkno != (xfs_daddr_t)0);
 
-	vp = XFS_ITOV(ip);
+	vp = VFS_I(ip);
 	dic = &ip->i_d;
 
 	/* xfs_iget returns the following without needing
diff --git a/fs/xfs/xfs_utils.h b/fs/xfs/xfs_utils.h
index f316cb8..7b533df 100644
--- a/fs/xfs/xfs_utils.h
+++ b/fs/xfs/xfs_utils.h
@@ -18,8 +18,8 @@
 #ifndef __XFS_UTILS_H__
 #define __XFS_UTILS_H__
 
-#define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
-#define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
+#define IRELE(ip)	VN_RELE(VFS_I(ip))
+#define IHOLD(ip)	VN_HOLD(VFS_I(ip))
 
 extern int xfs_truncate_file(xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index ff6a916..fe02272 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -128,7 +128,7 @@ xfs_unmount_flush(
 	xfs_inode_t	*rip = mp->m_rootip;
 	xfs_inode_t	*rbmip;
 	xfs_inode_t	*rsumip = NULL;
-	bhv_vnode_t	*rvp = XFS_ITOV(rip);
+	bhv_vnode_t	*rvp = VFS_I(rip);
 	int		error;
 
 	xfs_ilock(rip, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
@@ -146,7 +146,7 @@ xfs_unmount_flush(
 		if (error == EFSCORRUPTED)
 			goto fscorrupt_out;
 
-		ASSERT(vn_count(XFS_ITOV(rbmip)) == 1);
+		ASSERT(vn_count(VFS_I(rbmip)) == 1);
 
 		rsumip = mp->m_rsumip;
 		xfs_ilock(rsumip, XFS_ILOCK_EXCL);
@@ -157,7 +157,7 @@ xfs_unmount_flush(
 		if (error == EFSCORRUPTED)
 			goto fscorrupt_out;
 
-		ASSERT(vn_count(XFS_ITOV(rsumip)) == 1);
+		ASSERT(vn_count(VFS_I(rsumip)) == 1);
 	}
 
 	/*
@@ -360,7 +360,7 @@ xfs_sync_inodes_ag(
 				continue;
 			xfs_ilock(ip, lock_flags);
 
-			ASSERT(vp == XFS_ITOV(ip));
+			ASSERT(vp == VFS_I(ip));
 			ASSERT(ip->i_mount == mp);
 
 			vnode_refed = B_TRUE;
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 5d1b254..cca2871 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -705,7 +705,7 @@ xfs_fsync(
 		return XFS_ERROR(EIO);
 
 	/* capture size updates in I/O completion before writing the inode. */
-	error = filemap_fdatawait(vn_to_inode(XFS_ITOV(ip))->i_mapping);
+	error = filemap_fdatawait(vn_to_inode(VFS_I(ip))->i_mapping);
 	if (error)
 		return XFS_ERROR(error);
 
@@ -1151,7 +1151,7 @@ int
 xfs_release(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	bhv_vnode_t	*vp = VFS_I(ip);
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
 
@@ -1218,7 +1218,7 @@ int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	bhv_vnode_t	*vp = VFS_I(ip);
 	xfs_bmap_free_t	free_list;
 	xfs_fsblock_t	first_block;
 	int		committed;
@@ -2864,7 +2864,7 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	bhv_vnode_t	*vp = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
@@ -3326,7 +3326,7 @@ xfs_free_file_space(
 	xfs_trans_t		*tp;
 	int			need_iolock = 1;
 
-	vp = XFS_ITOV(ip);
+	vp = VFS_I(ip);
 	mp = ip->i_mount;
 
 	xfs_itrace_entry(ip);
-- 
1.5.6
