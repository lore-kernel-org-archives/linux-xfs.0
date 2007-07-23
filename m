Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jul 2007 01:44:26 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6N8iJbm020715
	for <xfs@oss.sgi.com>; Mon, 23 Jul 2007 01:44:21 -0700
Date: Mon, 23 Jul 2007 10:44:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] dinode endianess annotations
Message-ID: <20070723084419.GA1003@lst.de>
References: <20070720163026.GA6902@lst.de> <20070723002121.GK31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723002121.GK31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jul 23, 2007 at 10:21:21AM +1000, David Chinner wrote:
> This is a bit ugly - we typically use the "ic" prefix to indicate
> "in-core" e.g. "l_iclogbufs", "xfs_icsb_cnts_t".
> 
> Perhaps "xfs_ictimestamp_t" or "xfs_ictstamp_t" would be more
> consistent with other code. Not sure it really matters, but it would
> fix up some of the formatting issues such a long variable
> introduces....

I've done xfs_ictimestamp_t.

> So now we have:
> 
> 	- struct inode (linux in memory inode)
> 	- struct xfs_inode (xfs in memory inode)
> 	- struct xfs_dinode_incore (xfs in memory disk inode core)
> 	- struct xfs_dinode_core (xfs on disk inode core)

	- struct bhv_vnode

but I have some experimental patches to kill it..

> I think the xfs_dinode_incore is badly named, because the "core"
> part of xfs_dinode_core refers to the main part (or "core") of the
> on disk inode. i.e. the non-literal area of the inode. IOWs, "core"
> in this context has very different meaning to "incore" (see
> XFS_ILOG_CORE and friends, for example).
> 
> Perhaps "struct xfs_icdinode_core" as per the above?

I've renamed it to xfs_icdinode

Updated patch below:


Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-07-23 08:14:49.000000000 +0200
@@ -345,19 +345,17 @@ _xfs_dic2dmflags(
 
 STATIC uint
 xfs_ip2dmflags(
-	xfs_inode_t		*ip)
+	xfs_inode_t	*ip)
 {
-	xfs_dinode_core_t	*dic = &ip->i_d;
-
-	return _xfs_dic2dmflags(dic->di_flags) |
+	return _xfs_dic2dmflags(ip->i_d.di_flags) |
 			(XFS_CFORK_Q(dic) ? DM_XFLAG_HASATTR : 0);
 }
 
 STATIC uint
 xfs_dic2dmflags(
-	xfs_dinode_core_t	*dic)
+	xfs_dinode_t	*dip)
 {
-	return _xfs_dic2dmflags(INT_GET(dic->di_flags, ARCH_CONVERT)) |
+	return _xfs_dic2dmflags(be16_to_cpu(dip->di_core.di_flags)) |
 			(XFS_CFORK_Q_DISK(dic) ? DM_XFLAG_HASATTR : 0);
 }
 
@@ -387,32 +385,33 @@ xfs_dip_to_stat(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (INT_GET(dic->di_version, ARCH_CONVERT) == XFS_DINODE_VERSION_1) {
-		buf->dt_nlink = INT_GET(dic->di_onlink, ARCH_CONVERT);
+	if (dic->di_version == XFS_DINODE_VERSION_1) {
+		buf->dt_nlink = be16_to_cpu(dic->di_onlink);
 		/*buf->dt_xfs_projid = 0;*/
 	} else {
-		buf->dt_nlink = INT_GET(dic->di_nlink, ARCH_CONVERT);
-		/*buf->dt_xfs_projid = INT_GET(dic->di_projid, ARCH_CONVERT);*/
+		buf->dt_nlink = be32_to_cpu(dic->di_nlink);
+		/*buf->dt_xfs_projid = be16_to_cpu(dic->di_projid);*/
 	}
 	buf->dt_ino = ino;
 	buf->dt_dev = XFS_TO_HOST_DEVT(mp);
-	buf->dt_mode = INT_GET(dic->di_mode, ARCH_CONVERT);
-	buf->dt_uid = INT_GET(dic->di_uid, ARCH_CONVERT);
-	buf->dt_gid = INT_GET(dic->di_gid, ARCH_CONVERT);
-	buf->dt_size = INT_GET(dic->di_size, ARCH_CONVERT);
-	buf->dt_atime = INT_GET(dic->di_atime.t_sec, ARCH_CONVERT);
-	buf->dt_mtime = INT_GET(dic->di_mtime.t_sec, ARCH_CONVERT);
-	buf->dt_ctime = INT_GET(dic->di_ctime.t_sec, ARCH_CONVERT);
-	buf->dt_xfs_xflags = xfs_dic2dmflags(dic);
-	buf->dt_xfs_extsize = INT_GET(dic->di_extsize, ARCH_CONVERT) << mp->m_sb.sb_blocklog;
-	buf->dt_xfs_extents = INT_GET(dic->di_nextents, ARCH_CONVERT);
-	buf->dt_xfs_aextents = INT_GET(dic->di_anextents, ARCH_CONVERT);
-	buf->dt_xfs_igen = INT_GET(dic->di_gen, ARCH_CONVERT);
-	buf->dt_xfs_dmstate = INT_GET(dic->di_dmstate, ARCH_CONVERT);
+	buf->dt_mode = be16_to_cpu(dic->di_mode);
+	buf->dt_uid = be32_to_cpu(dic->di_uid);
+	buf->dt_gid = be32_to_cpu(dic->di_gid);
+	buf->dt_size = be64_to_cpu(dic->di_size);
+	buf->dt_atime = be32_to_cpu(dic->di_atime.t_sec);
+	buf->dt_mtime = be32_to_cpu(dic->di_mtime.t_sec);
+	buf->dt_ctime = be32_to_cpu(dic->di_ctime.t_sec);
+	buf->dt_xfs_xflags = xfs_dic2dmflags(dip);
+	buf->dt_xfs_extsize =
+		be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
+	buf->dt_xfs_extents = be32_to_cpu(dic->di_nextents);
+	buf->dt_xfs_aextents = be16_to_cpu(dic->di_anextents);
+	buf->dt_xfs_igen = be32_to_cpu(dic->di_gen);
+	buf->dt_xfs_dmstate = be16_to_cpu(dic->di_dmstate);
 
-	switch (INT_GET(dic->di_format, ARCH_CONVERT)) {
+	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
-		buf->dt_rdev = INT_GET(dip->di_u.di_dev, ARCH_CONVERT);
+		buf->dt_rdev = be32_to_cpu(dip->di_u.di_dev);
 		buf->dt_blksize = BLKDEV_IOSIZE;
 		buf->dt_blocks = 0;
 		break;
@@ -426,8 +425,8 @@ xfs_dip_to_stat(
 	case XFS_DINODE_FMT_BTREE:
 		buf->dt_rdev = 0;
 		buf->dt_blksize = mp->m_sb.sb_blocksize;
-		buf->dt_blocks = XFS_FSB_TO_BB(mp,
-				INT_GET(dic->di_nblocks, ARCH_CONVERT));
+		buf->dt_blocks =
+			XFS_FSB_TO_BB(mp, be64_to_cpu(dic->di_nblocks));
 		break;
 	}
 
@@ -439,8 +438,8 @@ xfs_dip_to_stat(
 	buf->dt_pers = 0;
 	buf->dt_change = 0;
 	buf->dt_nevents = DM_EVENT_MAX;
-	buf->dt_emask = INT_GET(dic->di_dmevmask, ARCH_CONVERT);
-	buf->dt_dtime = INT_GET(dic->di_ctime.t_sec, ARCH_CONVERT);
+	buf->dt_emask = be32_to_cpu(dic->di_dmevmask);
+	buf->dt_dtime = be32_to_cpu(dic->di_ctime.t_sec);
 	/* Set if one of READ, WRITE or TRUNCATE bits is set in emask */
 	buf->dt_pmanreg = (DMEV_ISSET(DM_EVENT_READ, buf->dt_emask) ||
 			DMEV_ISSET(DM_EVENT_WRITE, buf->dt_emask) ||
@@ -458,7 +457,7 @@ xfs_ip_to_stat(
 	xfs_inode_t		*ip,
 	dm_stat_t		*buf)
 {
-	xfs_dinode_core_t	*dic = &ip->i_d;
+	xfs_icdinode_t		*dic = &ip->i_d;
 	bhv_vnode_t		*vp = XFS_ITOV(ip);
 
 	buf->dt_ino = ino;
@@ -604,8 +603,7 @@ xfs_dm_inline_attr(
 	caddr_t		attr_buf,
 	int		*value_lenp)
 {
-	if (INT_GET(dip->di_core.di_aformat, ARCH_CONVERT) ==
-						XFS_DINODE_FMT_LOCAL) {
+	if (dip->di_core.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		xfs_attr_shortform_t	*sf;
 		xfs_attr_sf_entry_t	*sfe;
 		unsigned int		namelen = strlen(attr_name);
@@ -649,7 +647,7 @@ dm_dip_to_handle(
 	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
 	xfid->fid_pad = 0;
 	xfid->fid_ino = ino;
-        xfid->fid_gen = INT_GET(dip->di_core.di_gen, ARCH_CONVERT);
+        xfid->fid_gen = be32_to_cpu(dip->di_core.di_gen);
 
 	memcpy(&handlep->ha_fsid, fsid, sizeof(*fsid));
 	memcpy(&handlep->ha_fid, &fid, fid.dm_fid_len + sizeof(fid.dm_fid_len));
Index: linux-2.6-xfs/fs/xfs/xfs_dinode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dinode.h	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dinode.h	2007-07-23 08:07:50.000000000 +0200
@@ -33,16 +33,17 @@ struct xfs_mount;
  * with the last field expanding.  It is split into the core and "other"
  * because we only need the core part in the in-core inode.
  */
-typedef struct xfs_timestamp {
+
+typedef struct xfs_ictimestamp {
 	__int32_t	t_sec;		/* timestamp seconds */
 	__int32_t	t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+} xfs_ictimestamp_t;
 
 /*
- * Note: Coordinate changes to this structure with the XFS_DI_* #defines
- * below and the offsets table in xfs_ialloc_log_di().
+ * Incore dinode core.  Must match xfs_dinode_core except for endianess
+ * annotations.
  */
-typedef struct xfs_dinode_core
+typedef struct xfs_dinode_incore
 {
 	__uint16_t	di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__uint16_t	di_mode;	/* mode and type of file */
@@ -55,9 +56,9 @@ typedef struct xfs_dinode_core
 	__uint16_t	di_projid;	/* owner's project id */
 	__uint8_t	di_pad[8];	/* unused, zeroed space */
 	__uint16_t	di_flushiter;	/* incremented on flush */
-	xfs_timestamp_t	di_atime;	/* time last accessed */
-	xfs_timestamp_t	di_mtime;	/* time last modified */
-	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
+	xfs_ictimestamp_t di_atime;	/* time last accessed */
+	xfs_ictimestamp_t di_mtime;	/* time last modified */
+	xfs_ictimestamp_t di_ctime;	/* time created/inode modified */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_drfsbno_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
@@ -69,6 +70,43 @@ typedef struct xfs_dinode_core
 	__uint16_t	di_dmstate;	/* DMIG state info */
 	__uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 	__uint32_t	di_gen;		/* generation number */
+} xfs_icdinode_t;
+
+typedef struct xfs_timestamp {
+	__be32		t_sec;		/* timestamp seconds */
+	__be32		t_nsec;		/* timestamp nanoseconds */
+} xfs_timestamp_t;
+
+/*
+ * Note: Coordinate changes to this structure with the XFS_DI_* #defines
+ * below and the offsets table in xfs_ialloc_log_di().
+ */
+typedef struct xfs_dinode_core {
+	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
+	__be16		di_mode;	/* mode and type of file */
+	__u8		di_version;	/* inode version */
+	__u8		di_format;	/* format of di_c data */
+	__be16		di_onlink;	/* old number of links to file */
+	__be32		di_uid;		/* owner's user id */
+	__be32		di_gid;		/* owner's group id */
+	__be32		di_nlink;	/* number of links to file */
+	__be16		di_projid;	/* owner's project id */
+	__u8		di_pad[8];	/* unused, zeroed space */
+	__be16		di_flushiter;	/* incremented on flush */
+	xfs_timestamp_t	di_atime;	/* time last accessed */
+	xfs_timestamp_t	di_mtime;	/* time last modified */
+	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
+	__be64		di_size;	/* number of bytes in file */
+	__be64		di_nblocks;	/* # of direct & btree blocks used */
+	__be32		di_extsize;	/* basic/minimum extent size for file */
+	__be32		di_nextents;	/* number of extents in data fork */
+	__be16		di_anextents;	/* number of extents in attribute fork*/
+	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
+	__s8		di_aformat;	/* format of attr fork's data */
+	__be32		di_dmevmask;	/* DMIG event mask */
+	__be16		di_dmstate;	/* DMIG state info */
+	__be16		di_flags;	/* random flags, XFS_DIFLAG_... */
+	__be32		di_gen;		/* generation number */
 } xfs_dinode_core_t;
 
 #define DI_MAX_FLUSH 0xffff
@@ -81,13 +119,13 @@ typedef struct xfs_dinode
 	 * sure to update the macros like XFS_LITINO below and
 	 * XFS_BMAP_RBLOCK_DSIZE in xfs_bmap_btree.h.
 	 */
-	xfs_agino_t		di_next_unlinked;/* agi unlinked list ptr */
+	__be32			di_next_unlinked;/* agi unlinked list ptr */
 	union {
 		xfs_bmdr_block_t di_bmbt;	/* btree root block */
 		xfs_bmbt_rec_32_t di_bmx[1];	/* extent list */
 		xfs_dir2_sf_t	di_dir2sf;	/* shortform directory v2 */
 		char		di_c[1];	/* local contents */
-		xfs_dev_t	di_dev;		/* device for S_IFCHR/S_IFBLK */
+		__be32		di_dev;		/* device for S_IFCHR/S_IFBLK */
 		uuid_t		di_muuid;	/* mount point value */
 		char		di_symlink[1];	/* local symbolic link */
 	}		di_u;
@@ -175,8 +213,7 @@ typedef enum xfs_dinode_fmt
 #define	XFS_CFORK_Q_DISK(dcp)		    ((dcp)->di_forkoff != 0)
 
 #define XFS_CFORK_BOFF(dcp)                 ((int)((dcp)->di_forkoff << 3))
-#define	XFS_CFORK_BOFF_DISK(dcp) \
-	((int)(INT_GET((dcp)->di_forkoff, ARCH_CONVERT) << 3))
+#define	XFS_CFORK_BOFF_DISK(dcp)	    ((int)((dcp)->di_forkoff << 3))
 
 #define	XFS_CFORK_DSIZE_DISK(dcp,mp) \
 	(XFS_CFORK_Q_DISK(dcp) ? XFS_CFORK_BOFF_DISK(dcp) : XFS_LITINO(mp))
@@ -225,8 +262,8 @@ typedef enum xfs_dinode_fmt
 
 #define	XFS_CFORK_NEXTENTS_DISK(dcp,w) \
 	((w) == XFS_DATA_FORK ? \
-	 	INT_GET((dcp)->di_nextents, ARCH_CONVERT) : \
-	 	INT_GET((dcp)->di_anextents, ARCH_CONVERT))
+	 	be32_to_cpu((dcp)->di_nextents) : \
+	 	be16_to_cpu((dcp)->di_anextents))
 #define XFS_CFORK_NEXTENTS(dcp,w) \
 	((w) == XFS_DATA_FORK ? (dcp)->di_nextents : (dcp)->di_anextents)
 #define	XFS_DFORK_NEXTENTS(dip,w) XFS_CFORK_NEXTENTS_DISK(&(dip)->di_core, w)
Index: linux-2.6-xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_ialloc.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_ialloc.c	2007-07-23 08:07:11.000000000 +0200
@@ -293,9 +293,9 @@ xfs_ialloc_ag_alloc(
 		xfs_biozero(fbuf, 0, ninodes << args.mp->m_sb.sb_inodelog);
 		for (i = 0; i < ninodes; i++) {
 			free = XFS_MAKE_IPTR(args.mp, fbuf, i);
-			INT_SET(free->di_core.di_magic, ARCH_CONVERT, XFS_DINODE_MAGIC);
-			INT_SET(free->di_core.di_version, ARCH_CONVERT, version);
-			INT_SET(free->di_next_unlinked, ARCH_CONVERT, NULLAGINO);
+			free->di_core.di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			free->di_core.di_version = version;
+			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			xfs_ialloc_log_di(tp, fbuf, i,
 				XFS_DI_CORE_BITS | XFS_DI_NEXT_UNLINKED);
 		}
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-07-23 08:03:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-07-23 08:07:11.000000000 +0200
@@ -195,8 +195,8 @@ xfs_inotobp(
 	}
 	dip = (xfs_dinode_t *)xfs_buf_offset(bp, 0);
 	di_ok =
-		INT_GET(dip->di_core.di_magic, ARCH_CONVERT) == XFS_DINODE_MAGIC &&
-		XFS_DINODE_GOOD_VERSION(INT_GET(dip->di_core.di_version, ARCH_CONVERT));
+		be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
+		XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
 	if (unlikely(XFS_TEST_ERROR(!di_ok, mp, XFS_ERRTAG_ITOBP_INOTOBP,
 			XFS_RANDOM_ITOBP_INOTOBP))) {
 		XFS_CORRUPTION_ERROR("xfs_inotobp", XFS_ERRLEVEL_LOW, mp, dip);
@@ -340,8 +340,8 @@ xfs_itobp(
 
 		dip = (xfs_dinode_t *)xfs_buf_offset(bp,
 					(i << mp->m_sb.sb_inodelog));
-		di_ok = INT_GET(dip->di_core.di_magic, ARCH_CONVERT) == XFS_DINODE_MAGIC &&
-			    XFS_DINODE_GOOD_VERSION(INT_GET(dip->di_core.di_version, ARCH_CONVERT));
+		di_ok = be16_to_cpu(dip->di_core.di_magic) == XFS_DINODE_MAGIC &&
+			    XFS_DINODE_GOOD_VERSION(dip->di_core.di_version);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
@@ -355,7 +355,7 @@ xfs_itobp(
 					"daddr %lld #%d (magic=%x)",
 				XFS_BUFTARG_NAME(mp->m_ddev_targp),
 				(unsigned long long)imap.im_blkno, i,
-				INT_GET(dip->di_core.di_magic, ARCH_CONVERT));
+				be16_to_cpu(dip->di_core.di_magic));
 #endif
 			XFS_CORRUPTION_ERROR("xfs_itobp", XFS_ERRLEVEL_HIGH,
 					     mp, dip);
@@ -401,27 +401,26 @@ xfs_iformat(
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
 	error = 0;
 
-	if (unlikely(
-	    INT_GET(dip->di_core.di_nextents, ARCH_CONVERT) +
-		INT_GET(dip->di_core.di_anextents, ARCH_CONVERT) >
-	    INT_GET(dip->di_core.di_nblocks, ARCH_CONVERT))) {
+	if (unlikely(be32_to_cpu(dip->di_core.di_nextents) +
+		     be16_to_cpu(dip->di_core.di_anextents) >
+		     be64_to_cpu(dip->di_core.di_nblocks))) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, extent total = %d, nblocks = %Lu.",
 			(unsigned long long)ip->i_ino,
-			(int)(INT_GET(dip->di_core.di_nextents, ARCH_CONVERT)
-			    + INT_GET(dip->di_core.di_anextents, ARCH_CONVERT)),
+			(int)(be32_to_cpu(dip->di_core.di_nextents) +
+			      be16_to_cpu(dip->di_core.di_anextents)),
 			(unsigned long long)
-			INT_GET(dip->di_core.di_nblocks, ARCH_CONVERT));
+				be64_to_cpu(dip->di_core.di_nblocks));
 		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
-	if (unlikely(INT_GET(dip->di_core.di_forkoff, ARCH_CONVERT) > ip->i_mount->m_sb.sb_inodesize)) {
+	if (unlikely(dip->di_core.di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
 		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 			"corrupt dinode %Lu, forkoff = 0x%x.",
 			(unsigned long long)ip->i_ino,
-			(int)(INT_GET(dip->di_core.di_forkoff, ARCH_CONVERT)));
+			dip->di_core.di_forkoff);
 		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
 		return XFS_ERROR(EFSCORRUPTED);
@@ -432,25 +431,25 @@ xfs_iformat(
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		if (unlikely(INT_GET(dip->di_core.di_format, ARCH_CONVERT) != XFS_DINODE_FMT_DEV)) {
+		if (unlikely(dip->di_core.di_format != XFS_DINODE_FMT_DEV)) {
 			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
 			return XFS_ERROR(EFSCORRUPTED);
 		}
 		ip->i_d.di_size = 0;
 		ip->i_size = 0;
-		ip->i_df.if_u2.if_rdev = INT_GET(dip->di_u.di_dev, ARCH_CONVERT);
+		ip->i_df.if_u2.if_rdev = be32_to_cpu(dip->di_u.di_dev);
 		break;
 
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		switch (INT_GET(dip->di_core.di_format, ARCH_CONVERT)) {
+		switch (dip->di_core.di_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			/*
 			 * no local regular files yet
 			 */
-			if (unlikely((INT_GET(dip->di_core.di_mode, ARCH_CONVERT) & S_IFMT) == S_IFREG)) {
+			if (unlikely((be16_to_cpu(dip->di_core.di_mode) & S_IFMT) == S_IFREG)) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
 					"(local format for regular file).",
@@ -461,7 +460,7 @@ xfs_iformat(
 				return XFS_ERROR(EFSCORRUPTED);
 			}
 
-			di_size = INT_GET(dip->di_core.di_size, ARCH_CONVERT);
+			di_size = be64_to_cpu(dip->di_core.di_size);
 			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
 				xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
 					"corrupt inode %Lu "
@@ -503,7 +502,7 @@ xfs_iformat(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
 	ip->i_afp->if_ext_max =
 		XFS_IFORK_ASIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
-	switch (INT_GET(dip->di_core.di_aformat, ARCH_CONVERT)) {
+	switch (dip->di_core.di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
 		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		size = be16_to_cpu(atp->hdr.totsize);
@@ -711,70 +710,74 @@ xfs_iformat_btree(
 	return 0;
 }
 
-/*
- * xfs_xlate_dinode_core - translate an xfs_inode_core_t between ondisk
- * and native format
- *
- * buf  = on-disk representation
- * dip  = native representation
- * dir  = direction - +ve -> disk to native
- *                    -ve -> native to disk
- */
 void
-xfs_xlate_dinode_core(
-	xfs_caddr_t		buf,
-	xfs_dinode_core_t	*dip,
-	int			dir)
-{
-	xfs_dinode_core_t	*buf_core = (xfs_dinode_core_t *)buf;
-	xfs_dinode_core_t	*mem_core = (xfs_dinode_core_t *)dip;
-	xfs_arch_t		arch = ARCH_CONVERT;
-
-	ASSERT(dir);
-
-	INT_XLATE(buf_core->di_magic, mem_core->di_magic, dir, arch);
-	INT_XLATE(buf_core->di_mode, mem_core->di_mode, dir, arch);
-	INT_XLATE(buf_core->di_version,	mem_core->di_version, dir, arch);
-	INT_XLATE(buf_core->di_format, mem_core->di_format, dir, arch);
-	INT_XLATE(buf_core->di_onlink, mem_core->di_onlink, dir, arch);
-	INT_XLATE(buf_core->di_uid, mem_core->di_uid, dir, arch);
-	INT_XLATE(buf_core->di_gid, mem_core->di_gid, dir, arch);
-	INT_XLATE(buf_core->di_nlink, mem_core->di_nlink, dir, arch);
-	INT_XLATE(buf_core->di_projid, mem_core->di_projid, dir, arch);
-
-	if (dir > 0) {
-		memcpy(mem_core->di_pad, buf_core->di_pad,
-			sizeof(buf_core->di_pad));
-	} else {
-		memcpy(buf_core->di_pad, mem_core->di_pad,
-			sizeof(buf_core->di_pad));
-	}
-
-	INT_XLATE(buf_core->di_flushiter, mem_core->di_flushiter, dir, arch);
+xfs_dinode_from_disk(
+	xfs_icdinode_t		*to,
+	xfs_dinode_core_t	*from)
+{
+	to->di_magic = be16_to_cpu(from->di_magic);
+	to->di_mode = be16_to_cpu(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = be16_to_cpu(from->di_onlink);
+	to->di_uid = be32_to_cpu(from->di_uid);
+	to->di_gid = be32_to_cpu(from->di_gid);
+	to->di_nlink = be32_to_cpu(from->di_nlink);
+	to->di_projid = be16_to_cpu(from->di_projid);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	to->di_atime.t_sec = be32_to_cpu(from->di_atime.t_sec);
+	to->di_atime.t_nsec = be32_to_cpu(from->di_atime.t_nsec);
+	to->di_mtime.t_sec = be32_to_cpu(from->di_mtime.t_sec);
+	to->di_mtime.t_nsec = be32_to_cpu(from->di_mtime.t_nsec);
+	to->di_ctime.t_sec = be32_to_cpu(from->di_ctime.t_sec);
+	to->di_ctime.t_nsec = be32_to_cpu(from->di_ctime.t_nsec);
+	to->di_size = be64_to_cpu(from->di_size);
+	to->di_nblocks = be64_to_cpu(from->di_nblocks);
+	to->di_extsize = be32_to_cpu(from->di_extsize);
+	to->di_nextents = be32_to_cpu(from->di_nextents);
+	to->di_anextents = be16_to_cpu(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat	= from->di_aformat;
+	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
+	to->di_flags	= be16_to_cpu(from->di_flags);
+	to->di_gen	= be32_to_cpu(from->di_gen);
+}
 
-	INT_XLATE(buf_core->di_atime.t_sec, mem_core->di_atime.t_sec,
-			dir, arch);
-	INT_XLATE(buf_core->di_atime.t_nsec, mem_core->di_atime.t_nsec,
-			dir, arch);
-	INT_XLATE(buf_core->di_mtime.t_sec, mem_core->di_mtime.t_sec,
-			dir, arch);
-	INT_XLATE(buf_core->di_mtime.t_nsec, mem_core->di_mtime.t_nsec,
-			dir, arch);
-	INT_XLATE(buf_core->di_ctime.t_sec, mem_core->di_ctime.t_sec,
-			dir, arch);
-	INT_XLATE(buf_core->di_ctime.t_nsec, mem_core->di_ctime.t_nsec,
-			dir, arch);
-	INT_XLATE(buf_core->di_size, mem_core->di_size, dir, arch);
-	INT_XLATE(buf_core->di_nblocks, mem_core->di_nblocks, dir, arch);
-	INT_XLATE(buf_core->di_extsize, mem_core->di_extsize, dir, arch);
-	INT_XLATE(buf_core->di_nextents, mem_core->di_nextents, dir, arch);
-	INT_XLATE(buf_core->di_anextents, mem_core->di_anextents, dir, arch);
-	INT_XLATE(buf_core->di_forkoff, mem_core->di_forkoff, dir, arch);
-	INT_XLATE(buf_core->di_aformat, mem_core->di_aformat, dir, arch);
-	INT_XLATE(buf_core->di_dmevmask, mem_core->di_dmevmask, dir, arch);
-	INT_XLATE(buf_core->di_dmstate, mem_core->di_dmstate, dir, arch);
-	INT_XLATE(buf_core->di_flags, mem_core->di_flags, dir, arch);
-	INT_XLATE(buf_core->di_gen, mem_core->di_gen, dir, arch);
+void
+xfs_dinode_to_disk(
+	xfs_dinode_core_t	*to,
+	xfs_icdinode_t		*from)
+{
+	to->di_magic = cpu_to_be16(from->di_magic);
+	to->di_mode = cpu_to_be16(from->di_mode);
+	to->di_version = from ->di_version;
+	to->di_format = from->di_format;
+	to->di_onlink = cpu_to_be16(from->di_onlink);
+	to->di_uid = cpu_to_be32(from->di_uid);
+	to->di_gid = cpu_to_be32(from->di_gid);
+	to->di_nlink = cpu_to_be32(from->di_nlink);
+	to->di_projid = cpu_to_be16(from->di_projid);
+	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
+	to->di_flushiter = cpu_to_be16(from->di_flushiter);
+	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
+	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
+	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
+	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
+	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
+	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	to->di_size = cpu_to_be64(from->di_size);
+	to->di_nblocks = cpu_to_be64(from->di_nblocks);
+	to->di_extsize = cpu_to_be32(from->di_extsize);
+	to->di_nextents = cpu_to_be32(from->di_nextents);
+	to->di_anextents = cpu_to_be16(from->di_anextents);
+	to->di_forkoff = from->di_forkoff;
+	to->di_aformat = from->di_aformat;
+	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmstate = cpu_to_be16(from->di_dmstate);
+	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_gen = cpu_to_be32(from->di_gen);
 }
 
 STATIC uint
@@ -821,7 +824,7 @@ uint
 xfs_ip2xflags(
 	xfs_inode_t		*ip)
 {
-	xfs_dinode_core_t	*dic = &ip->i_d;
+	xfs_icdinode_t		*dic = &ip->i_d;
 
 	return _xfs_dic2xflags(dic->di_flags) |
 				(XFS_CFORK_Q(dic) ? XFS_XFLAG_HASATTR : 0);
@@ -831,7 +834,7 @@ uint
 xfs_dic2xflags(
 	xfs_dinode_core_t	*dic)
 {
-	return _xfs_dic2xflags(INT_GET(dic->di_flags, ARCH_CONVERT)) |
+	return _xfs_dic2xflags(be16_to_cpu(dic->di_flags)) |
 				(XFS_CFORK_Q_DISK(dic) ? XFS_XFLAG_HASATTR : 0);
 }
 
@@ -901,14 +904,14 @@ xfs_iread(
 	 * If we got something that isn't an inode it means someone
 	 * (nfs or dmi) has a stale handle.
 	 */
-	if (INT_GET(dip->di_core.di_magic, ARCH_CONVERT) != XFS_DINODE_MAGIC) {
+	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC) {
 		kmem_zone_free(xfs_inode_zone, ip);
 		xfs_trans_brelse(tp, bp);
 #ifdef DEBUG
 		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_iread: "
 				"dip->di_core.di_magic (0x%x) != "
 				"XFS_DINODE_MAGIC (0x%x)",
-				INT_GET(dip->di_core.di_magic, ARCH_CONVERT),
+				be16_to_cpu(dip->di_core.di_magic),
 				XFS_DINODE_MAGIC);
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
@@ -922,8 +925,7 @@ xfs_iread(
 	 * Otherwise, just get the truly permanent information.
 	 */
 	if (dip->di_core.di_mode) {
-		xfs_xlate_dinode_core((xfs_caddr_t)&dip->di_core,
-		     &(ip->i_d), 1);
+		xfs_dinode_from_disk(&ip->i_d, &dip->di_core);
 		error = xfs_iformat(ip, dip);
 		if (error)  {
 			kmem_zone_free(xfs_inode_zone, ip);
@@ -936,10 +938,10 @@ xfs_iread(
 			return error;
 		}
 	} else {
-		ip->i_d.di_magic = INT_GET(dip->di_core.di_magic, ARCH_CONVERT);
-		ip->i_d.di_version = INT_GET(dip->di_core.di_version, ARCH_CONVERT);
-		ip->i_d.di_gen = INT_GET(dip->di_core.di_gen, ARCH_CONVERT);
-		ip->i_d.di_flushiter = INT_GET(dip->di_core.di_flushiter, ARCH_CONVERT);
+		ip->i_d.di_magic = be16_to_cpu(dip->di_core.di_magic);
+		ip->i_d.di_version = dip->di_core.di_version;
+		ip->i_d.di_gen = be32_to_cpu(dip->di_core.di_gen);
+		ip->i_d.di_flushiter = be16_to_cpu(dip->di_core.di_flushiter);
 		/*
 		 * Make sure to pull in the mode here as well in
 		 * case the inode is released without being used.
@@ -1961,8 +1963,7 @@ xfs_iunlink(
 		if (error) {
 			return error;
 		}
-		ASSERT(INT_GET(dip->di_next_unlinked, ARCH_CONVERT) == NULLAGINO);
-		ASSERT(dip->di_next_unlinked);
+		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
 		/* both on-disk, don't endian flip twice */
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
 		offset = ip->i_boffset +
@@ -2073,10 +2074,10 @@ xfs_iunlink_remove(
 				error, mp->m_fsname);
 			return error;
 		}
-		next_agino = INT_GET(dip->di_next_unlinked, ARCH_CONVERT);
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
 		ASSERT(next_agino != 0);
 		if (next_agino != NULLAGINO) {
-			INT_SET(dip->di_next_unlinked, ARCH_CONVERT, NULLAGINO);
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
@@ -2120,7 +2121,7 @@ xfs_iunlink_remove(
 					error, mp->m_fsname);
 				return error;
 			}
-			next_agino = INT_GET(last_dip->di_next_unlinked, ARCH_CONVERT);
+			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
 			ASSERT(next_agino != NULLAGINO);
 			ASSERT(next_agino != 0);
 		}
@@ -2135,11 +2136,11 @@ xfs_iunlink_remove(
 				error, mp->m_fsname);
 			return error;
 		}
-		next_agino = INT_GET(dip->di_next_unlinked, ARCH_CONVERT);
+		next_agino = be32_to_cpu(dip->di_next_unlinked);
 		ASSERT(next_agino != 0);
 		ASSERT(next_agino != agino);
 		if (next_agino != NULLAGINO) {
-			INT_SET(dip->di_next_unlinked, ARCH_CONVERT, NULLAGINO);
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 			offset = ip->i_boffset +
 				offsetof(xfs_dinode_t, di_next_unlinked);
 			xfs_trans_inode_buf(tp, ibp);
@@ -2152,7 +2153,7 @@ xfs_iunlink_remove(
 		/*
 		 * Point the previous inode on the list to the next inode.
 		 */
-		INT_SET(last_dip->di_next_unlinked, ARCH_CONVERT, next_agino);
+		last_dip->di_next_unlinked = cpu_to_be32(next_agino);
 		ASSERT(next_agino != 0);
 		offset = last_offset + offsetof(xfs_dinode_t, di_next_unlinked);
 		xfs_trans_inode_buf(tp, last_ibp);
@@ -3011,7 +3012,7 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_DEV:
 		if (iip->ili_format.ilf_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			INT_SET(dip->di_u.di_dev, ARCH_CONVERT, ip->i_df.if_u2.if_rdev);
+			dip->di_u.di_dev = cpu_to_be32(ip->i_df.if_u2.if_rdev);
 		}
 		break;
 
@@ -3360,11 +3361,11 @@ xfs_iflush_int(
 	 */
 	xfs_synchronize_atime(ip);
 
-	if (XFS_TEST_ERROR(INT_GET(dip->di_core.di_magic,ARCH_CONVERT) != XFS_DINODE_MAGIC,
+	if (XFS_TEST_ERROR(be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC,
 			       mp, XFS_ERRTAG_IFLUSH_1, XFS_RANDOM_IFLUSH_1)) {
 		xfs_cmn_err(XFS_PTAG_IFLUSH, CE_ALERT, mp,
 		    "xfs_iflush: Bad inode %Lu magic number 0x%x, ptr 0x%p",
-			ip->i_ino, (int) INT_GET(dip->di_core.di_magic, ARCH_CONVERT), dip);
+			ip->i_ino, be16_to_cpu(dip->di_core.di_magic), dip);
 		goto corrupt_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_magic != XFS_DINODE_MAGIC,
@@ -3427,7 +3428,7 @@ xfs_iflush_int(
 	 * because if the inode is dirty at all the core must
 	 * be.
 	 */
-	xfs_xlate_dinode_core((xfs_caddr_t)&(dip->di_core), &(ip->i_d), -1);
+	xfs_dinode_to_disk(&dip->di_core, &ip->i_d);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
 	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
@@ -3447,7 +3448,7 @@ xfs_iflush_int(
 			 * Convert it back.
 			 */
 			ASSERT(ip->i_d.di_nlink <= XFS_MAXLINK_1);
-			INT_SET(dip->di_core.di_onlink, ARCH_CONVERT, ip->i_d.di_nlink);
+			dip->di_core.di_onlink = cpu_to_be16(ip->i_d.di_nlink);
 		} else {
 			/*
 			 * The superblock version has already been bumped,
@@ -3455,7 +3456,7 @@ xfs_iflush_int(
 			 * format permanent.
 			 */
 			ip->i_d.di_version = XFS_DINODE_VERSION_2;
-			INT_SET(dip->di_core.di_version, ARCH_CONVERT, XFS_DINODE_VERSION_2);
+			dip->di_core.di_version =  XFS_DINODE_VERSION_2;
 			ip->i_d.di_onlink = 0;
 			dip->di_core.di_onlink = 0;
 			memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2007-07-23 08:12:29.000000000 +0200
@@ -57,7 +57,7 @@ xfs_bulkstat_one_iget(
 	xfs_bstat_t	*buf,		/* return buffer */
 	int		*stat)		/* BULKSTAT_RV_... */
 {
-	xfs_dinode_core_t *dic;		/* dinode core info pointer */
+	xfs_icdinode_t	*dic;	/* dinode core info pointer */
 	xfs_inode_t	*ip;		/* incore inode pointer */
 	bhv_vnode_t	*vp;
 	int		error;
@@ -151,37 +151,37 @@ xfs_bulkstat_one_dinode(
 	 * the new format. We don't change the version number so that we
 	 * can distinguish this from a real new format inode.
 	 */
-	if (INT_GET(dic->di_version, ARCH_CONVERT) == XFS_DINODE_VERSION_1) {
-		buf->bs_nlink = INT_GET(dic->di_onlink, ARCH_CONVERT);
+	if (dic->di_version == XFS_DINODE_VERSION_1) {
+		buf->bs_nlink = be16_to_cpu(dic->di_onlink);
 		buf->bs_projid = 0;
 	} else {
-		buf->bs_nlink = INT_GET(dic->di_nlink, ARCH_CONVERT);
-		buf->bs_projid = INT_GET(dic->di_projid, ARCH_CONVERT);
+		buf->bs_nlink = be32_to_cpu(dic->di_nlink);
+		buf->bs_projid = be16_to_cpu(dic->di_projid);
 	}
 
 	buf->bs_ino = ino;
-	buf->bs_mode = INT_GET(dic->di_mode, ARCH_CONVERT);
-	buf->bs_uid = INT_GET(dic->di_uid, ARCH_CONVERT);
-	buf->bs_gid = INT_GET(dic->di_gid, ARCH_CONVERT);
-	buf->bs_size = INT_GET(dic->di_size, ARCH_CONVERT);
-	buf->bs_atime.tv_sec = INT_GET(dic->di_atime.t_sec, ARCH_CONVERT);
-	buf->bs_atime.tv_nsec = INT_GET(dic->di_atime.t_nsec, ARCH_CONVERT);
-	buf->bs_mtime.tv_sec = INT_GET(dic->di_mtime.t_sec, ARCH_CONVERT);
-	buf->bs_mtime.tv_nsec = INT_GET(dic->di_mtime.t_nsec, ARCH_CONVERT);
-	buf->bs_ctime.tv_sec = INT_GET(dic->di_ctime.t_sec, ARCH_CONVERT);
-	buf->bs_ctime.tv_nsec = INT_GET(dic->di_ctime.t_nsec, ARCH_CONVERT);
+	buf->bs_mode = be16_to_cpu(dic->di_mode);
+	buf->bs_uid = be32_to_cpu(dic->di_uid);
+	buf->bs_gid = be32_to_cpu(dic->di_gid);
+	buf->bs_size = be64_to_cpu(dic->di_size);
+	buf->bs_atime.tv_sec = be32_to_cpu(dic->di_atime.t_sec);
+	buf->bs_atime.tv_nsec = be32_to_cpu(dic->di_atime.t_nsec);
+	buf->bs_mtime.tv_sec = be32_to_cpu(dic->di_mtime.t_sec);
+	buf->bs_mtime.tv_nsec = be32_to_cpu(dic->di_mtime.t_nsec);
+	buf->bs_ctime.tv_sec = be32_to_cpu(dic->di_ctime.t_sec);
+	buf->bs_ctime.tv_nsec = be32_to_cpu(dic->di_ctime.t_nsec);
 	buf->bs_xflags = xfs_dic2xflags(dic);
-	buf->bs_extsize = INT_GET(dic->di_extsize, ARCH_CONVERT) << mp->m_sb.sb_blocklog;
-	buf->bs_extents = INT_GET(dic->di_nextents, ARCH_CONVERT);
-	buf->bs_gen = INT_GET(dic->di_gen, ARCH_CONVERT);
+	buf->bs_extsize = be32_to_cpu(dic->di_extsize) << mp->m_sb.sb_blocklog;
+	buf->bs_extents = be32_to_cpu(dic->di_nextents);
+	buf->bs_gen = be32_to_cpu(dic->di_gen);
 	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
-	buf->bs_dmevmask = INT_GET(dic->di_dmevmask, ARCH_CONVERT);
-	buf->bs_dmstate = INT_GET(dic->di_dmstate, ARCH_CONVERT);
-	buf->bs_aextents = INT_GET(dic->di_anextents, ARCH_CONVERT);
+	buf->bs_dmevmask = be32_to_cpu(dic->di_dmevmask);
+	buf->bs_dmstate = be16_to_cpu(dic->di_dmstate);
+	buf->bs_aextents = be16_to_cpu(dic->di_anextents);
 
-	switch (INT_GET(dic->di_format, ARCH_CONVERT)) {
+	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
-		buf->bs_rdev = INT_GET(dip->di_u.di_dev, ARCH_CONVERT);
+		buf->bs_rdev = be32_to_cpu(dip->di_u.di_dev);
 		buf->bs_blksize = BLKDEV_IOSIZE;
 		buf->bs_blocks = 0;
 		break;
@@ -195,7 +195,7 @@ xfs_bulkstat_one_dinode(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = INT_GET(dic->di_nblocks, ARCH_CONVERT);
+		buf->bs_blocks = be64_to_cpu(dic->di_nblocks);
 		break;
 	}
 
@@ -290,16 +290,15 @@ xfs_bulkstat_use_dinode(
 		return 1;
 	dip = (xfs_dinode_t *)
 			xfs_buf_offset(bp, clustidx << mp->m_sb.sb_inodelog);
-	if (INT_GET(dip->di_core.di_magic, ARCH_CONVERT) != XFS_DINODE_MAGIC ||
-	    !XFS_DINODE_GOOD_VERSION(
-			INT_GET(dip->di_core.di_version, ARCH_CONVERT)))
+	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC ||
+	    !XFS_DINODE_GOOD_VERSION(dip->di_core.di_version))
 		return 0;
 	if (flags & BULKSTAT_FG_QUICK) {
 		*dipp = dip;
 		return 1;
 	}
 	/* BULKSTAT_FG_INLINE: if attr fork is local, or not there, use it */
-	aformat = INT_GET(dip->di_core.di_aformat, ARCH_CONVERT);
+	aformat = dip->di_core.di_aformat;
 	if ((XFS_CFORK_Q(&dip->di_core) == 0) ||
 	    (aformat == XFS_DINODE_FMT_LOCAL) ||
 	    (aformat == XFS_DINODE_FMT_EXTENTS && !dip->di_core.di_anextents)) {
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2007-07-23 08:07:11.000000000 +0200
@@ -2245,7 +2245,7 @@ xlog_recover_do_inode_trans(
 	int			error;
 	int			attr_index;
 	uint			fields;
-	xfs_dinode_core_t	*dicp;
+	xfs_icdinode_t		*dicp;
 	int			need_free = 0;
 
 	if (pass == XLOG_RECOVER_PASS1) {
@@ -2309,7 +2309,7 @@ xlog_recover_do_inode_trans(
 	 * Make sure the place we're flushing out to really looks
 	 * like an inode!
 	 */
-	if (unlikely(INT_GET(dip->di_core.di_magic, ARCH_CONVERT) != XFS_DINODE_MAGIC)) {
+	if (unlikely(be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
 			"xfs_inode_recover: Bad inode magic number, dino ptr = 0x%p, dino bp = 0x%p, ino = %Ld",
@@ -2319,7 +2319,7 @@ xlog_recover_do_inode_trans(
 		error = EFSCORRUPTED;
 		goto error;
 	}
-	dicp = (xfs_dinode_core_t*)(item->ri_buf[1].i_addr);
+	dicp = (xfs_icdinode_t *)(item->ri_buf[1].i_addr);
 	if (unlikely(dicp->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_buf_relse(bp);
 		xfs_fs_cmn_err(CE_ALERT, mp,
@@ -2332,15 +2332,13 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* Skip replay when the on disk inode is newer than the log one */
-	if (dicp->di_flushiter <
-	    INT_GET(dip->di_core.di_flushiter, ARCH_CONVERT)) {
+	if (dicp->di_flushiter < be16_to_cpu(dip->di_core.di_flushiter)) {
 		/*
 		 * Deal with the wrap case, DI_MAX_FLUSH is less
 		 * than smaller numbers
 		 */
-		if ((INT_GET(dip->di_core.di_flushiter, ARCH_CONVERT)
-							== DI_MAX_FLUSH) &&
-		    (dicp->di_flushiter < (DI_MAX_FLUSH>>1))) {
+		if (be16_to_cpu(dip->di_core.di_flushiter) == DI_MAX_FLUSH &&
+		    dicp->di_flushiter < (DI_MAX_FLUSH >> 1)) {
 			/* do nothing */
 		} else {
 			xfs_buf_relse(bp);
@@ -2411,8 +2409,8 @@ xlog_recover_do_inode_trans(
 	}
 
 	/* The core is in in-core format */
-	xfs_xlate_dinode_core((xfs_caddr_t)&dip->di_core,
-			      (xfs_dinode_core_t*)item->ri_buf[1].i_addr, -1);
+	xfs_dinode_to_disk(&dip->di_core,
+		(xfs_icdinode_t *)item->ri_buf[1].i_addr);
 
 	/* the rest is in on-disk format */
 	if (item->ri_buf[1].i_len > sizeof(xfs_dinode_core_t)) {
@@ -2424,8 +2422,7 @@ xlog_recover_do_inode_trans(
 	fields = in_f->ilf_fields;
 	switch (fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
 	case XFS_ILOG_DEV:
-		INT_SET(dip->di_u.di_dev, ARCH_CONVERT, in_f->ilf_u.ilfu_rdev);
-
+		dip->di_u.di_dev = cpu_to_be32(in_f->ilf_u.ilfu_rdev);
 		break;
 	case XFS_ILOG_UUID:
 		dip->di_u.di_muuid = in_f->ilf_u.ilfu_uuid;
@@ -3234,8 +3231,8 @@ xlog_recover_process_iunlinks(
 					ASSERT(ip->i_d.di_nlink == 0);
 
 					/* setup for the next pass */
-					agino = INT_GET(dip->di_next_unlinked,
-							ARCH_CONVERT);
+					agino = be32_to_cpu(
+							dip->di_next_unlinked);
 					xfs_buf_relse(ibp);
 					/*
 					 * Prevent any DMAPI event from
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-07-23 08:07:11.000000000 +0200
@@ -232,7 +232,7 @@ static char *	xfs_fmtsize(size_t i);
 static char *	xfs_fmtuuid(uuid_t *);
 static void	xfs_inode_item_print(xfs_inode_log_item_t *ilip, int summary);
 static void	xfs_inodebuf(xfs_buf_t *bp);
-static void	xfs_prdinode_core(xfs_dinode_core_t *dip);
+static void	xfs_prdinode_incore(xfs_icdinode_t *dip);
 static void	xfs_qoff_item_print(xfs_qoff_logitem_t *lip, int summary);
 static void	xfs_xexlist_fork(xfs_inode_t *ip, int whichfork);
 static void	xfs_xnode_fork(char *name, xfs_ifork_t *f);
@@ -3828,7 +3828,7 @@ static void
 xfs_inodebuf(xfs_buf_t *bp)
 {
 	xfs_dinode_t *di;
-	xfs_dinode_core_t dic;
+	xfs_icdinode_t dic;
 	int n, i;
 
 	n = XFS_BUF_COUNT(bp) >> 8;
@@ -3836,11 +3836,10 @@ xfs_inodebuf(xfs_buf_t *bp)
 		di = (xfs_dinode_t *)xfs_buf_offset(bp,
 					i * 256);
 
-		xfs_xlate_dinode_core((xfs_caddr_t)&di->di_core, &dic, 1);
-		xfs_prdinode_core(&dic);
+		xfs_dinode_from_disk(&dic, &di->di_core);
+		xfs_prdinode_incore(&dic);
 		kdb_printf("next_unlinked 0x%x u@0x%p\n",
-			   INT_GET(di->di_next_unlinked, ARCH_CONVERT),
-			   &di->di_u);
+			   be32_to_cpu(di->di_next_unlinked), &di->di_u);
 	}
 }
 
@@ -3981,7 +3980,7 @@ xfs_inval_cached_trace_entry(ktrace_entr
  * Print disk inode core.
  */
 static void
-xfs_prdinode_core(xfs_dinode_core_t *dip)
+xfs_prdinode_incore(xfs_icdinode_t *dip)
 {
 	static char *diflags[] = {
 		"realtime",		/* XFS_DIFLAG_REALTIME */
@@ -5059,7 +5058,7 @@ xfsidbg_xbuf_real(xfs_buf_t *bp, int sum
 			kdb_printf("buf 0x%p dir/attr node 0x%p\n", bp, node);
 			xfsidbg_xdanode(node);
 		}
-	} else if (INT_GET((di = d)->di_core.di_magic, ARCH_CONVERT) == XFS_DINODE_MAGIC) {
+	} else if (be16_to_cpu((di = d)->di_core.di_magic) == XFS_DINODE_MAGIC) {
 		if (summary) {
 			kdb_printf("Disk Inode (at 0x%p)\n", di);
 		} else {
@@ -6907,7 +6906,7 @@ xfsidbg_xnode(xfs_inode_t *ip)
 	xfs_xnode_fork("data", &ip->i_df);
 	xfs_xnode_fork("attr", ip->i_afp);
 	kdb_printf("\n");
-	xfs_prdinode_core(&ip->i_d);
+	xfs_prdinode_incore(&ip->i_d);
 }
 
 static void
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-07-23 08:07:11.000000000 +0200
@@ -325,7 +325,7 @@ EXPORT_SYMBOL(xfs_vfsops);
 EXPORT_SYMBOL(xfs_vnodeops);
 EXPORT_SYMBOL(xfs_vtoi);
 EXPORT_SYMBOL(xfs_write_clear_setuid);
-EXPORT_SYMBOL(xfs_xlate_dinode_core);
+EXPORT_SYMBOL(xfs_dinode_from_disk);
 EXPORT_SYMBOL(xfs_xlatesb);
 EXPORT_SYMBOL(xfs_zero_eof);
 EXPORT_SYMBOL(xlog_recover_process_iunlinks);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-07-23 08:03:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-07-23 08:11:33.000000000 +0200
@@ -282,7 +282,7 @@ typedef struct xfs_inode {
 	unsigned int		i_gen;		/* generation count */
 	unsigned int		i_delayed_blks;	/* count of delay alloc blks */
 
-	xfs_dinode_core_t	i_d;		/* most of ondisk inode */
+	xfs_icdinode_t		i_d;		/* most of ondisk inode */
 	xfs_chashlist_t		*i_chash;	/* cluster hash list header */
 	struct xfs_inode	*i_cnext;	/* cluster hash link forward */
 	struct xfs_inode	*i_cprev;	/* cluster hash link backward */
@@ -514,8 +514,11 @@ int		xfs_iread_extents(struct xfs_trans 
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
 			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
 			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
-void		xfs_xlate_dinode_core(xfs_caddr_t, struct xfs_dinode_core *,
-					int);
+void		xfs_dinode_from_disk(xfs_icdinode_t *,
+				     xfs_dinode_core_t *);
+void		xfs_dinode_to_disk(xfs_dinode_core_t *,
+				   xfs_icdinode_t *);
+
 uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode_core *);
 int		xfs_ifree(struct xfs_trans *, xfs_inode_t *,
