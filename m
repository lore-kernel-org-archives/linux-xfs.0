Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:26:34 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8Q8QRbo032044
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:26:31 -0700
Date: Wed, 26 Sep 2007 10:26:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] kill xfs_statvfs
Message-ID: <20070926082625.GB32719@lst.de>
References: <20070925194741.GB1818@lst.de> <46F9C09B.1060503@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9C09B.1060503@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Sep 26, 2007 at 12:14:51PM +1000, Timothy Shimmin wrote:
> I think I'd prefer:
>   > +	XFS_QM_DQSTATVFS(XFS_I(dentry->d_inode), statp);
> instead of:
>   > +	XFS_QM_DQSTATVFS(xfs_vtoi(dentry->d_inode), statp);
> 
> which I found confusing.

I agree, here's an updated version:


Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-09-26 10:13:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-09-26 10:23:38.000000000 +0200
@@ -664,8 +664,44 @@ xfs_fs_statfs(
 	struct dentry		*dentry,
 	struct kstatfs		*statp)
 {
-	return -xfs_statvfs(XFS_M(dentry->d_sb), statp,
-				vn_from_inode(dentry->d_inode));
+	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
+	xfs_sb_t		*sbp = &mp->m_sb;
+	__uint64_t		fakeinos, id;
+	xfs_extlen_t		lsize;
+
+	statp->f_type = XFS_SB_MAGIC;
+	statp->f_namelen = MAXNAMELEN - 1;
+
+	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
+	statp->f_fsid.val[0] = (u32)id;
+	statp->f_fsid.val[1] = (u32)(id >> 32);
+
+	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
+
+	spin_lock(&mp->m_sb_lock);
+	statp->f_bsize = sbp->sb_blocksize;
+	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
+	statp->f_blocks = sbp->sb_dblocks - lsize;
+	statp->f_bfree = statp->f_bavail =
+				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+	fakeinos = statp->f_bfree << sbp->sb_inopblog;
+#if XFS_BIG_INUMS
+	fakeinos += mp->m_inoadd;
+#endif
+	statp->f_files =
+	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
+	if (mp->m_maxicount)
+#if XFS_BIG_INUMS
+		if (!mp->m_inoadd)
+#endif
+			statp->f_files = min_t(typeof(statp->f_files),
+						statp->f_files,
+						mp->m_maxicount);
+	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
+	spin_unlock(&mp->m_sb_lock);
+
+	XFS_QM_DQSTATVFS(XFS_I(dentry->d_inode), statp);
+	return 0;
 }
 
 STATIC int
@@ -768,7 +804,6 @@ xfs_fs_fill_super(
 	struct inode		*rootvp;
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
-	struct kstatfs		statvfs;
 	int			error;
 
 	mp = xfs_mount_init();
@@ -796,14 +831,10 @@ xfs_fs_fill_super(
 	if (error)
 		goto fail_vfsop;
 
-	error = xfs_statvfs(mp, &statvfs, NULL);
-	if (error)
-		goto fail_unmount;
-
 	sb->s_dirt = 1;
-	sb->s_magic = statvfs.f_type;
-	sb->s_blocksize = statvfs.f_bsize;
-	sb->s_blocksize_bits = ffs(statvfs.f_bsize) - 1;
+	sb->s_magic = XFS_SB_MAGIC;
+	sb->s_blocksize = mp->m_sb.sb_blocksize;
+	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-09-26 10:14:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-09-26 10:22:32.000000000 +0200
@@ -839,59 +839,6 @@ xfs_root(
 }
 
 /*
- * xfs_statvfs
- *
- * Fill in the statvfs structure for the given file system.  We use
- * the superblock lock in the mount structure to ensure a consistent
- * snapshot of the counters returned.
- */
-int
-xfs_statvfs(
-	xfs_mount_t	*mp,
-	bhv_statvfs_t	*statp,
-	bhv_vnode_t	*vp)
-{
-	__uint64_t	fakeinos;
-	xfs_extlen_t	lsize;
-	xfs_sb_t	*sbp;
-
-	sbp = &(mp->m_sb);
-
-	statp->f_type = XFS_SB_MAGIC;
-
-	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
-	spin_lock(&mp->m_sb_lock);
-	statp->f_bsize = sbp->sb_blocksize;
-	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
-	statp->f_bfree = statp->f_bavail =
-				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
-	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-#if XFS_BIG_INUMS
-	fakeinos += mp->m_inoadd;
-#endif
-	statp->f_files =
-	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
-	if (mp->m_maxicount)
-#if XFS_BIG_INUMS
-		if (!mp->m_inoadd)
-#endif
-			statp->f_files = min_t(typeof(statp->f_files),
-						statp->f_files,
-						mp->m_maxicount);
-	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_statvfs_fsid(statp, mp);
-	statp->f_namelen = MAXNAMELEN - 1;
-
-	if (vp)
-		XFS_QM_DQSTATVFS(xfs_vtoi(vp), statp);
-	return 0;
-}
-
-
-/*
  * xfs_sync flushes any pending I/O to file system vfsp.
  *
  * This routine is called by vfs_sync() to make sure that things make it
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-09-26 10:13:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-09-26 10:22:32.000000000 +0200
@@ -14,8 +14,6 @@ int xfs_unmount(struct xfs_mount *mp, in
 int xfs_mntupdate(struct xfs_mount *mp, int *flags,
 		struct xfs_mount_args *args);
 int xfs_root(struct xfs_mount *mp, bhv_vnode_t **vpp);
-int xfs_statvfs(struct xfs_mount *mp, struct kstatfs *statp,
-		bhv_vnode_t *vp);
 int xfs_sync(struct xfs_mount *mp, int flags);
 int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct xfs_fid *xfid);
 int xfs_parseargs(struct xfs_mount *mp, char *options,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-09-26 10:13:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2007-09-26 10:22:32.000000000 +0200
@@ -212,10 +212,6 @@
 #define xfs_stack_trace()	dump_stack()
 #define xfs_itruncate_data(ip, off)	\
 	(-vmtruncate(vn_to_inode(XFS_ITOV(ip)), (off)))
-#define xfs_statvfs_fsid(statp, mp)	\
-	({ u64 id = huge_encode_dev((mp)->m_ddev_targp->bt_dev); \
-	   __kernel_fsid_t *fsid = &(statp)->f_fsid;	\
-	(fsid->val[0] = (u32)id, fsid->val[1] = (u32)(id >> 32)); })
 
 
 /* Move the kernel do_div definition off to one side */
