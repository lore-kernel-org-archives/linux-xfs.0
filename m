Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2I9fqPs224793 for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 04:42:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 806381A629D
	for <xfs@oss.sgi.com>; Wed, 18 Mar 2009 02:41:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bplHiFjCfNhGSQCP for
	<xfs@oss.sgi.com>; Wed, 18 Mar 2009 02:41:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LjsHE-0007eT-5V
	for xfs@oss.sgi.com; Wed, 18 Mar 2009 09:41:32 +0000
Message-Id: <20090318094132.076764000@bombadil.infradead.org>
Date: Wed, 18 Mar 2009 05:41:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: kill ino64 mount option
References: <20090318094119.561416000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-ino64
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

The ino64 mount option adds a fixed offset to 32bit inode numbers
to bring them into the 64bit range.  There's no need for this kind
of debug tool given that it's easy to produce real 64bit inode numbers
for testing.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2009-03-17 19:46:13.246882523 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2009-03-17 19:58:00.491978754 +0100
@@ -541,9 +541,6 @@ xfs_vn_getattr(
 	stat->uid = ip->i_d.di_uid;
 	stat->gid = ip->i_d.di_gid;
 	stat->ino = ip->i_ino;
-#if XFS_BIG_INUMS
-	stat->ino += mp->m_inoadd;
-#endif
 	stat->atime = inode->i_atime;
 	stat->mtime.tv_sec = ip->i_d.di_mtime.t_sec;
 	stat->mtime.tv_nsec = ip->i_d.di_mtime.t_nsec;
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-03-17 19:50:03.421854113 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-03-17 19:58:00.492978881 +0100
@@ -78,7 +78,6 @@ mempool_t *xfs_ioend_pool;
 #define MNTOPT_RTDEV	"rtdev"		/* realtime I/O device */
 #define MNTOPT_BIOSIZE	"biosize"	/* log2 of preferred buffered io size */
 #define MNTOPT_WSYNC	"wsync"		/* safe-mode nfs compatible mount */
-#define MNTOPT_INO64	"ino64"		/* force inodes into 64-bit range */
 #define MNTOPT_NOALIGN	"noalign"	/* turn off stripe alignment */
 #define MNTOPT_SWALLOC	"swalloc"	/* turn on stripe width allocation */
 #define MNTOPT_SUNIT	"sunit"		/* data volume stripe unit */
@@ -290,16 +289,6 @@ xfs_parseargs(
 			mp->m_flags |= XFS_MOUNT_OSYNCISOSYNC;
 		} else if (!strcmp(this_char, MNTOPT_NORECOVERY)) {
 			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-		} else if (!strcmp(this_char, MNTOPT_INO64)) {
-#if XFS_BIG_INUMS
-			mp->m_flags |= XFS_MOUNT_INO64;
-			mp->m_inoadd = XFS_INO64_OFFSET;
-#else
-			cmn_err(CE_WARN,
-				"XFS: %s option not allowed on this system",
-				this_char);
-			return EINVAL;
-#endif
 		} else if (!strcmp(this_char, MNTOPT_NOALIGN)) {
 			mp->m_flags |= XFS_MOUNT_NOALIGN;
 		} else if (!strcmp(this_char, MNTOPT_SWALLOC)) {
@@ -536,7 +525,6 @@ xfs_showargs(
 		/* the few simple ones we can get from the mount struct */
 		{ XFS_MOUNT_IKEEP,		"," MNTOPT_IKEEP },
 		{ XFS_MOUNT_WSYNC,		"," MNTOPT_WSYNC },
-		{ XFS_MOUNT_INO64,		"," MNTOPT_INO64 },
 		{ XFS_MOUNT_NOALIGN,		"," MNTOPT_NOALIGN },
 		{ XFS_MOUNT_SWALLOC,		"," MNTOPT_SWALLOC },
 		{ XFS_MOUNT_NOUUID,		"," MNTOPT_NOUUID },
@@ -1207,18 +1195,12 @@ xfs_fs_statfs(
 	statp->f_bfree = statp->f_bavail =
 				sbp->sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	fakeinos = statp->f_bfree << sbp->sb_inopblog;
-#if XFS_BIG_INUMS
-	fakeinos += mp->m_inoadd;
-#endif
 	statp->f_files =
 	    MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
 	if (mp->m_maxicount)
-#if XFS_BIG_INUMS
-		if (!mp->m_inoadd)
-#endif
-			statp->f_files = min_t(typeof(statp->f_files),
-						statp->f_files,
-						mp->m_maxicount);
+		statp->f_files = min_t(typeof(statp->f_files),
+					statp->f_files,
+					mp->m_maxicount);
 	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
 	spin_unlock(&mp->m_sb_lock);
 
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2009-02-11 20:49:46.773069530 +0100
+++ xfs/fs/xfs/xfs_dir2_block.c	2009-03-17 19:58:53.672855925 +0100
@@ -448,7 +448,6 @@ xfs_dir2_block_getdents(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
-	xfs_ino_t		ino;
 	xfs_off_t		cook;
 
 	mp = dp->i_mount;
@@ -509,16 +508,12 @@ xfs_dir2_block_getdents(
 
 		cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 					    (char *)dep - (char *)block);
-		ino = be64_to_cpu(dep->inumber);
-#if XFS_BIG_INUMS
-		ino += mp->m_inoadd;
-#endif
 
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
 		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
-			    ino, DT_UNKNOWN)) {
+			    be64_to_cpu(dep->inumber), DT_UNKNOWN)) {
 			*offset = cook & 0x7fffffff;
 			xfs_da_brelse(NULL, bp);
 			return 0;
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2009-03-15 15:52:46.814978815 +0100
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2009-03-17 19:59:39.331981439 +0100
@@ -780,7 +780,6 @@ xfs_dir2_leaf_getdents(
 	int			ra_index;	/* *map index for read-ahead */
 	int			ra_offset;	/* map entry offset for ra */
 	int			ra_want;	/* readahead count wanted */
-	xfs_ino_t		ino;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
@@ -1076,24 +1075,12 @@ xfs_dir2_leaf_getdents(
 			continue;
 		}
 
-		/*
-		 * Copy the entry into the putargs, and try formatting it.
-		 */
 		dep = (xfs_dir2_data_entry_t *)ptr;
-
 		length = xfs_dir2_data_entsize(dep->namelen);
 
-		ino = be64_to_cpu(dep->inumber);
-#if XFS_BIG_INUMS
-		ino += mp->m_inoadd;
-#endif
-
-		/*
-		 * Won't fit.  Return to caller.
-		 */
 		if (filldir(dirent, dep->name, dep->namelen,
 			    xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff,
-			    ino, DT_UNKNOWN))
+			    be64_to_cpu(dep->inumber), DT_UNKNOWN))
 			break;
 
 		/*
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2009-02-11 20:49:46.759069355 +0100
+++ xfs/fs/xfs/xfs_dir2_sf.c	2009-03-17 20:00:44.438859792 +0100
@@ -748,11 +748,7 @@ xfs_dir2_sf_getdents(
 	 * Put . entry unless we're starting past it.
 	 */
 	if (*offset <= dot_offset) {
-		ino = dp->i_ino;
-#if XFS_BIG_INUMS
-		ino += mp->m_inoadd;
-#endif
-		if (filldir(dirent, ".", 1, dot_offset & 0x7fffffff, ino, DT_DIR)) {
+		if (filldir(dirent, ".", 1, dot_offset & 0x7fffffff, dp->i_ino, DT_DIR)) {
 			*offset = dot_offset & 0x7fffffff;
 			return 0;
 		}
@@ -763,9 +759,6 @@ xfs_dir2_sf_getdents(
 	 */
 	if (*offset <= dotdot_offset) {
 		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
-#if XFS_BIG_INUMS
-		ino += mp->m_inoadd;
-#endif
 		if (filldir(dirent, "..", 2, dotdot_offset & 0x7fffffff, ino, DT_DIR)) {
 			*offset = dotdot_offset & 0x7fffffff;
 			return 0;
@@ -786,10 +779,6 @@ xfs_dir2_sf_getdents(
 		}
 
 		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
-#if XFS_BIG_INUMS
-		ino += mp->m_inoadd;
-#endif
-
 		if (filldir(dirent, sfep->name, sfep->namelen,
 			    off & 0x7fffffff, ino, DT_UNKNOWN)) {
 			*offset = off & 0x7fffffff;
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-03-17 19:50:03.418853801 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-03-17 19:58:00.501978351 +0100
@@ -211,9 +211,6 @@ typedef struct xfs_mount {
 	__uint64_t		m_maxioffset;	/* maximum inode offset */
 	__uint64_t		m_resblks;	/* total reserved blocks */
 	__uint64_t		m_resblks_avail;/* available reserved blocks */
-#if XFS_BIG_INUMS
-	xfs_ino_t		m_inoadd;	/* add value for ino64_offset */
-#endif
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	int			m_sinoalign;	/* stripe unit inode alignment */
@@ -255,7 +252,6 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
-#define XFS_MOUNT_INO64		(1ULL << 1)
 #define XFS_MOUNT_DMAPI		(1ULL << 2)	/* dmapi is enabled */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
