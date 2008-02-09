Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Feb 2008 22:15:00 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m196ErX8006954
	for <xfs@oss.sgi.com>; Fri, 8 Feb 2008 22:14:56 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AFED5B9E63
	for <xfs@oss.sgi.com>; Fri,  8 Feb 2008 22:15:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 7adBOhtTebN1FR31 for <xfs@oss.sgi.com>; Fri, 08 Feb 2008 22:15:14 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 584DE18004487
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2008 00:14:43 -0600 (CST)
Message-ID: <47AD44D3.4060503@sandeen.net>
Date: Sat, 09 Feb 2008 00:14:43 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove shouting-indirection macros from xfs_sb.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Some day I'll get them all...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -732,7 +732,7 @@ xfs_ioctl(
 		 * Only allow the sys admin to reserve space unless
 		 * unwritten extents are enabled.
 		 */
-		if (!XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) &&
+		if (!xfs_sb_version_hasextflgbit(&mp->m_sb) &&
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
Index: linux-2.6/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm.c
+++ linux-2.6/fs/xfs/quota/xfs_qm.c
@@ -1405,13 +1405,13 @@ xfs_qm_qino_alloc(
 #if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
 		unsigned oldv = mp->m_sb.sb_versionnum;
 #endif
-		ASSERT(!XFS_SB_VERSION_HASQUOTA(&mp->m_sb));
+		ASSERT(!xfs_sb_version_hasquota(&mp->m_sb));
 		ASSERT((sbfields & (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
 				   XFS_SB_GQUOTINO | XFS_SB_QFLAGS)) ==
 		       (XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO |
 			XFS_SB_GQUOTINO | XFS_SB_QFLAGS));
 
-		XFS_SB_VERSION_ADDQUOTA(&mp->m_sb);
+		xfs_sb_version_addquota(&mp->m_sb);
 		mp->m_sb.sb_uquotino = NULLFSINO;
 		mp->m_sb.sb_gquotino = NULLFSINO;
 
@@ -1954,7 +1954,7 @@ xfs_qm_init_quotainos(
 	/*
 	 * Get the uquota and gquota inodes
 	 */
-	if (XFS_SB_VERSION_HASQUOTA(&mp->m_sb)) {
+	if (xfs_sb_version_hasquota(&mp->m_sb)) {
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
Index: linux-2.6/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm_bhv.c
+++ linux-2.6/fs/xfs/quota/xfs_qm_bhv.c
@@ -118,7 +118,7 @@ xfs_qm_newmount(
 	*quotaflags = 0;
 	*needquotamount = B_FALSE;
 
-	quotaondisk = XFS_SB_VERSION_HASQUOTA(&mp->m_sb) &&
+	quotaondisk = xfs_sb_version_hasquota(&mp->m_sb) &&
 				(mp->m_sb.sb_qflags & XFS_ALL_QUOTA_ACCT);
 
 	if (quotaondisk) {
Index: linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm_syscalls.c
+++ linux-2.6/fs/xfs/quota/xfs_qm_syscalls.c
@@ -377,7 +377,7 @@ xfs_qm_scall_trunc_qfiles(
 	if (!capable(CAP_SYS_ADMIN))
 		return XFS_ERROR(EPERM);
 	error = 0;
-	if (!XFS_SB_VERSION_HASQUOTA(&mp->m_sb) || flags == 0) {
+	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		qdprintk("qtrunc flags=%x m_qflags=%x\n", flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
@@ -522,7 +522,7 @@ xfs_qm_scall_getqstat(
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
-	if (! XFS_SB_VERSION_HASQUOTA(&mp->m_sb)) {
+	if (! xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
 		return (0);
Index: linux-2.6/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr_leaf.c
+++ linux-2.6/fs/xfs/xfs_attr_leaf.c
@@ -227,10 +227,10 @@ STATIC void
 xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 {
 	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    !(XFS_SB_VERSION_HASATTR2(&mp->m_sb))) {
+	    !(xfs_sb_version_hasattr2(&mp->m_sb))) {
 		spin_lock(&mp->m_sb_lock);
-		if (!XFS_SB_VERSION_HASATTR2(&mp->m_sb)) {
-			XFS_SB_VERSION_ADDATTR2(&mp->m_sb);
+		if (!xfs_sb_version_hasattr2(&mp->m_sb)) {
+			xfs_sb_version_addattr2(&mp->m_sb);
 			spin_unlock(&mp->m_sb_lock);
 			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
 		} else
Index: linux-2.6/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap.c
+++ linux-2.6/fs/xfs/xfs_bmap.c
@@ -4047,17 +4047,17 @@ xfs_bmap_add_attrfork(
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
 		goto error2;
-	if (!XFS_SB_VERSION_HASATTR(&mp->m_sb) ||
-	   (!XFS_SB_VERSION_HASATTR2(&mp->m_sb) && version == 2)) {
+	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
+	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
 
 		spin_lock(&mp->m_sb_lock);
-		if (!XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
-			XFS_SB_VERSION_ADDATTR(&mp->m_sb);
+		if (!xfs_sb_version_hasattr(&mp->m_sb)) {
+			xfs_sb_version_addattr(&mp->m_sb);
 			sbfields |= XFS_SB_VERSIONNUM;
 		}
-		if (!XFS_SB_VERSION_HASATTR2(&mp->m_sb) && version == 2) {
-			XFS_SB_VERSION_ADDATTR2(&mp->m_sb);
+		if (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2) {
+			xfs_sb_version_addattr2(&mp->m_sb);
 			sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
 		}
 		if (sbfields) {
@@ -5043,7 +5043,7 @@ xfs_bmapi(
 			 * A wasdelay extent has been initialized, so
 			 * shouldn't be flagged as unwritten.
 			 */
-			if (wr && XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb)) {
+			if (wr && xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 				if (!wasdelay && (flags & XFS_BMAPI_PREALLOC))
 					got.br_state = XFS_EXT_UNWRITTEN;
 			}
@@ -5483,7 +5483,7 @@ xfs_bunmapi(
 			 * get rid of part of a realtime extent.
 			 */
 			if (del.br_state == XFS_EXT_UNWRITTEN ||
-			    !XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb)) {
+			    !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 				/*
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
@@ -5535,7 +5535,7 @@ xfs_bunmapi(
 			} else if ((del.br_startoff == start &&
 				    (del.br_state == XFS_EXT_UNWRITTEN ||
 				     xfs_trans_get_block_res(tp) == 0)) ||
-				   !XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb)) {
+				   !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 				/*
 				 * Can't make it unwritten.  There isn't
 				 * a full extent here so just skip it.
Index: linux-2.6/fs/xfs/xfs_bmap_btree.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_bmap_btree.h
+++ linux-2.6/fs/xfs/xfs_bmap_btree.h
@@ -120,7 +120,7 @@ typedef enum {
  * Extent state and extent format macros.
  */
 #define XFS_EXTFMT_INODE(x)	\
-	(XFS_SB_VERSION_HASEXTFLGBIT(&((x)->i_mount->m_sb)) ? \
+	(xfs_sb_version_hasextflgbit(&((x)->i_mount->m_sb)) ? \
 		XFS_EXTFMT_HASSTATE : XFS_EXTFMT_NOSTATE)
 #define ISUNWRITTEN(x)	((x)->br_state == XFS_EXT_UNWRITTEN)
 
Index: linux-2.6/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2.c
+++ linux-2.6/fs/xfs/xfs_dir2.c
@@ -49,7 +49,7 @@ void
 xfs_dir_mount(
 	xfs_mount_t	*mp)
 {
-	ASSERT(XFS_SB_VERSION_HASDIRV2(&mp->m_sb));
+	ASSERT(xfs_sb_version_hasdirv2(&mp->m_sb));
 	ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
 	       XFS_MAX_BLOCKSIZE);
 	mp->m_dirblksize = 1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog);
Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c
+++ linux-2.6/fs/xfs/xfs_fsops.c
@@ -77,36 +77,36 @@ xfs_fs_geometry(
 	if (new_version >= 3) {
 		geo->version = XFS_FSOP_GEOM_VERSION;
 		geo->flags =
-			(XFS_SB_VERSION_HASATTR(&mp->m_sb) ?
+			(xfs_sb_version_hasattr(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
-			(XFS_SB_VERSION_HASNLINK(&mp->m_sb) ?
+			(xfs_sb_version_hasnlink(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_NLINK : 0) |
-			(XFS_SB_VERSION_HASQUOTA(&mp->m_sb) ?
+			(xfs_sb_version_hasquota(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_QUOTA : 0) |
-			(XFS_SB_VERSION_HASALIGN(&mp->m_sb) ?
+			(xfs_sb_version_hasalign(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
-			(XFS_SB_VERSION_HASDALIGN(&mp->m_sb) ?
+			(xfs_sb_version_hasdalign(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
-			(XFS_SB_VERSION_HASSHARED(&mp->m_sb) ?
+			(xfs_sb_version_hasshared(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SHARED : 0) |
-			(XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb) ?
+			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
-			(XFS_SB_VERSION_HASDIRV2(&mp->m_sb) ?
+			(xfs_sb_version_hasdirv2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_DIRV2 : 0) |
-			(XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
+			(xfs_sb_version_hassector(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
 			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
-			(XFS_SB_VERSION_HASATTR2(&mp->m_sb) ?
+			(xfs_sb_version_hasattr2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0);
-		geo->logsectsize = XFS_SB_VERSION_HASSECTOR(&mp->m_sb) ?
+		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
 		geo->rtsectsize = mp->m_sb.sb_blocksize;
 		geo->dirblocksize = mp->m_dirblksize;
 	}
 	if (new_version >= 4) {
 		geo->flags |=
-			(XFS_SB_VERSION_HASLOGV2(&mp->m_sb) ?
+			(xfs_sb_version_haslogv2(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
 		geo->logsunit = mp->m_sb.sb_logsunit;
 	}
Index: linux-2.6/fs/xfs/xfs_ialloc.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_ialloc.c
+++ linux-2.6/fs/xfs/xfs_ialloc.c
@@ -191,7 +191,7 @@ xfs_ialloc_ag_alloc(
 			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
-		} else if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
+		} else if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
 			   args.mp->m_sb.sb_inoalignmt >=
 			   XFS_B_TO_FSBT(args.mp,
 			  	XFS_INODE_CLUSTER_SIZE(args.mp)))
@@ -230,7 +230,7 @@ xfs_ialloc_ag_alloc(
 		args.agbno = be32_to_cpu(agi->agi_root);
 		args.fsbno = XFS_AGB_TO_FSB(args.mp,
 				be32_to_cpu(agi->agi_seqno), args.agbno);
-		if (XFS_SB_VERSION_HASALIGN(&args.mp->m_sb) &&
+		if (xfs_sb_version_hasalign(&args.mp->m_sb) &&
 			args.mp->m_sb.sb_inoalignmt >=
 			XFS_B_TO_FSBT(args.mp, XFS_INODE_CLUSTER_SIZE(args.mp)))
 				args.alignment = args.mp->m_sb.sb_inoalignmt;
@@ -271,7 +271,7 @@ xfs_ialloc_ag_alloc(
 	 * use the old version so that old kernels will continue to be
 	 * able to use the file system.
 	 */
-	if (XFS_SB_VERSION_HASNLINK(&args.mp->m_sb))
+	if (xfs_sb_version_hasnlink(&args.mp->m_sb))
 		version = XFS_DINODE_VERSION_2;
 	else
 		version = XFS_DINODE_VERSION_1;
Index: linux-2.6/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode.c
+++ linux-2.6/fs/xfs/xfs_inode.c
@@ -1147,7 +1147,7 @@ xfs_ialloc(
 	 * the inode version number now.  This way we only do the conversion
 	 * here rather than here and in the flush/logging code.
 	 */
-	if (XFS_SB_VERSION_HASNLINK(&tp->t_mountp->m_sb) &&
+	if (xfs_sb_version_hasnlink(&tp->t_mountp->m_sb) &&
 	    ip->i_d.di_version == XFS_DINODE_VERSION_1) {
 		ip->i_d.di_version = XFS_DINODE_VERSION_2;
 		/*
@@ -3434,9 +3434,9 @@ xfs_iflush_int(
 	 * has been updated, then make the conversion permanent.
 	 */
 	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
-	       XFS_SB_VERSION_HASNLINK(&mp->m_sb));
+	       xfs_sb_version_hasnlink(&mp->m_sb));
 	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
+		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
 			 */
Index: linux-2.6/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_inode_item.c
+++ linux-2.6/fs/xfs/xfs_inode_item.c
@@ -296,9 +296,9 @@ xfs_inode_item_format(
 	 */
 	mp = ip->i_mount;
 	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1 ||
-	       XFS_SB_VERSION_HASNLINK(&mp->m_sb));
+	       xfs_sb_version_hasnlink(&mp->m_sb));
 	if (ip->i_d.di_version == XFS_DINODE_VERSION_1) {
-		if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
+		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 			/*
 			 * Convert it back.
 			 */
Index: linux-2.6/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_itable.c
+++ linux-2.6/fs/xfs/xfs_itable.c
@@ -45,7 +45,7 @@ xfs_internal_inum(
 	xfs_ino_t	ino)
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
-		(XFS_SB_VERSION_HASQUOTA(&mp->m_sb) &&
+		(xfs_sb_version_hasquota(&mp->m_sb) &&
 		 (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino)));
 }
 
Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c
+++ linux-2.6/fs/xfs/xfs_log.c
@@ -1090,7 +1090,7 @@ xlog_get_iclog_buffer_size(xfs_mount_t	*
 			size >>= 1;
 		}
 
-		if (XFS_SB_VERSION_HASLOGV2(&mp->m_sb)) {
+		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
 			/* # headers = size / 32K
 			 * one header holds cycles from 32K of data
 			 */
@@ -1186,13 +1186,13 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_grant_reserve_cycle = 1;
 	log->l_grant_write_cycle = 1;
 
-	if (XFS_SB_VERSION_HASSECTOR(&mp->m_sb)) {
+	if (xfs_sb_version_hassector(&mp->m_sb)) {
 		log->l_sectbb_log = mp->m_sb.sb_logsectlog - BBSHIFT;
 		ASSERT(log->l_sectbb_log <= mp->m_sectbb_log);
 		/* for larger sector sizes, must have v2 or external log */
 		ASSERT(log->l_sectbb_log == 0 ||
 			log->l_logBBstart == 0 ||
-			XFS_SB_VERSION_HASLOGV2(&mp->m_sb));
+			xfs_sb_version_haslogv2(&mp->m_sb));
 		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
 	}
 	log->l_sectbb_mask = (1 << log->l_sectbb_log) - 1;
@@ -1247,7 +1247,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		memset(head, 0, sizeof(xlog_rec_header_t));
 		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 		head->h_version = cpu_to_be32(
-			XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
 		head->h_size = cpu_to_be32(log->l_iclog_size);
 		/* new fields */
 		head->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -1402,7 +1402,7 @@ xlog_sync(xlog_t		*log,
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
 	int		error;
-	int		v2 = XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb);
+	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
 
 	XFS_STATS_INC(xs_log_writes);
 	ASSERT(iclog->ic_refcnt == 0);
@@ -2881,7 +2881,7 @@ xlog_state_switch_iclogs(xlog_t		*log,
 	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
 
 	/* Round up to next log-sunit */
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) &&
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
 	    log->l_mp->m_sb.sb_logsunit > 1) {
 		__uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
 		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
@@ -3334,7 +3334,7 @@ xlog_ticket_get(xlog_t		*log,
 	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
 
 	/* for roundoff padding for transaction data and one for commit record */
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) &&
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
 	    log->l_mp->m_sb.sb_logsunit > 1) {
 		/* log su roundoff */
 		unit_bytes += 2*log->l_mp->m_sb.sb_logsunit;
Index: linux-2.6/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_priv.h
+++ linux-2.6/fs/xfs/xfs_log_priv.h
@@ -49,10 +49,10 @@ struct xfs_mount;
 #define XLOG_HEADER_SIZE	512
 
 #define XLOG_REC_SHIFT(log) \
-	BTOBB(1 << (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? \
+	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 #define XLOG_TOTAL_REC_SHIFT(log) \
-	BTOBB(XLOG_MAX_ICLOGS << (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? \
+	BTOBB(XLOG_MAX_ICLOGS << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
 
 
Index: linux-2.6/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log_recover.c
+++ linux-2.6/fs/xfs/xfs_log_recover.c
@@ -478,7 +478,7 @@ xlog_find_verify_log_record(
 	 * reset last_blk.  Only when last_blk points in the middle of a log
 	 * record do we update last_blk.
 	 */
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		uint	h_size = be32_to_cpu(head->h_size);
 
 		xhdrs = h_size / XLOG_HEADER_CYCLE_SIZE;
@@ -888,7 +888,7 @@ xlog_find_tail(
 	 * unmount record if there is one, so we pass the lsn of the
 	 * unmount record rather than the block after it.
 	 */
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		int	h_size = be32_to_cpu(rhead->h_size);
 		int	h_version = be32_to_cpu(rhead->h_version);
 
@@ -1101,7 +1101,7 @@ xlog_add_record(
 	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
 	recp->h_cycle = cpu_to_be32(cycle);
 	recp->h_version = cpu_to_be32(
-			XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb) ? 2 : 1);
+			xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? 2 : 1);
 	recp->h_lsn = cpu_to_be64(xlog_assign_lsn(cycle, block));
 	recp->h_tail_lsn = cpu_to_be64(xlog_assign_lsn(tail_cycle, tail_block));
 	recp->h_fmt = cpu_to_be32(XLOG_FMT);
@@ -3348,7 +3348,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		xhdr = (xlog_in_core_2_t *)&iclog->ic_header;
 		for ( ; i < BTOBB(size); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -3388,7 +3388,7 @@ xlog_unpack_data_checksum(
 			    be32_to_cpu(rhead->h_chksum), chksum);
 		    cmn_err(CE_DEBUG,
 "XFS: Disregard message if filesystem was created with non-DEBUG kernel");
-		    if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+		    if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 			    cmn_err(CE_DEBUG,
 				"XFS: LogR this is a LogV2 filesystem\n");
 		    }
@@ -3415,7 +3415,7 @@ xlog_unpack_data(
 		dp += BBSIZE;
 	}
 
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		xhdr = (xlog_in_core_2_t *)rhead;
 		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
 			j = i / (XLOG_HEADER_CYCLE_SIZE / BBSIZE);
@@ -3494,7 +3494,7 @@ xlog_do_recovery_pass(
 	 * Read the header of the tail block and get the iclog buffer size from
 	 * h_size.  Use this to tell how many sectors make up the log header.
 	 */
-	if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
 		/*
 		 * When using variable length iclogs, read first sector of
 		 * iclog header and extract the header size from it.  Get a
@@ -3838,7 +3838,7 @@ xlog_do_recover(
 	sbp = &log->l_mp->m_sb;
 	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
-	ASSERT(XFS_SB_GOOD_VERSION(sbp));
+	ASSERT(xfs_sb_good_version(sbp));
 	xfs_buf_relse(bp);
 
 	/* We've re-read the superblock so re-initialize per-cpu counters */
Index: linux-2.6/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_mount.c
+++ linux-2.6/fs/xfs/xfs_mount.c
@@ -225,7 +225,7 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EWRONGFS);
 	}
 
-	if (!XFS_SB_GOOD_VERSION(sbp)) {
+	if (!xfs_sb_good_version(sbp)) {
 		xfs_fs_mount_cmn_err(flags, "bad version");
 		return XFS_ERROR(EWRONGFS);
 	}
@@ -300,7 +300,7 @@ xfs_mount_validate_sb(
 	/*
 	 * Version 1 directory format has never worked on Linux.
 	 */
-	if (unlikely(!XFS_SB_VERSION_HASDIRV2(sbp))) {
+	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
 		xfs_fs_mount_cmn_err(flags,
 			"file system using version 1 directory format");
 		return XFS_ERROR(ENOSYS);
@@ -781,7 +781,7 @@ xfs_update_alignment(xfs_mount_t *mp, in
 		 * Update superblock with new values
 		 * and log changes
 		 */
-		if (XFS_SB_VERSION_HASDALIGN(sbp)) {
+		if (xfs_sb_version_hasdalign(sbp)) {
 			if (sbp->sb_unit != mp->m_dalign) {
 				sbp->sb_unit = mp->m_dalign;
 				*update_flags |= XFS_SB_UNIT;
@@ -792,7 +792,7 @@ xfs_update_alignment(xfs_mount_t *mp, in
 			}
 		}
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
-		    XFS_SB_VERSION_HASDALIGN(&mp->m_sb)) {
+		    xfs_sb_version_hasdalign(&mp->m_sb)) {
 			mp->m_dalign = sbp->sb_unit;
 			mp->m_swidth = sbp->sb_width;
 	}
@@ -869,7 +869,7 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
 STATIC void
 xfs_set_inoalignment(xfs_mount_t *mp)
 {
-	if (XFS_SB_VERSION_HASALIGN(&mp->m_sb) &&
+	if (xfs_sb_version_hasalign(&mp->m_sb) &&
 	    mp->m_sb.sb_inoalignmt >=
 	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
 		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
Index: linux-2.6/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_sb.h
+++ linux-2.6/fs/xfs/xfs_sb.h
@@ -271,7 +271,6 @@ typedef enum {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-#define	XFS_SB_GOOD_VERSION(sbp)	xfs_sb_good_version(sbp)
 #ifdef __KERNEL__
 static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 {
@@ -297,7 +296,6 @@ static inline int xfs_sb_good_version(xf
 }
 #endif /* __KERNEL__ */
 
-#define	XFS_SB_VERSION_TONEW(v)	xfs_sb_version_tonew(v)
 static inline unsigned xfs_sb_version_tonew(unsigned v)
 {
 	return ((((v) == XFS_SB_VERSION_1) ? \
@@ -308,7 +306,6 @@ static inline unsigned xfs_sb_version_to
 		XFS_SB_VERSION_4);
 }
 
-#define	XFS_SB_VERSION_TOOLD(v)	xfs_sb_version_toold(v)
 static inline unsigned xfs_sb_version_toold(unsigned v)
 {
 	return (((v) & (XFS_SB_VERSION_QUOTABIT | XFS_SB_VERSION_ALIGNBIT)) ? \
@@ -320,7 +317,6 @@ static inline unsigned xfs_sb_version_to
 				XFS_SB_VERSION_1)));
 }
 
-#define	XFS_SB_VERSION_HASATTR(sbp)	xfs_sb_version_hasattr(sbp)
 static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
 	return ((sbp)->sb_versionnum == XFS_SB_VERSION_2) || \
@@ -329,7 +325,6 @@ static inline int xfs_sb_version_hasattr
 		  ((sbp)->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
-#define	XFS_SB_VERSION_ADDATTR(sbp)	xfs_sb_version_addattr(sbp)
 static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = (((sbp)->sb_versionnum == XFS_SB_VERSION_1) ? \
@@ -339,7 +334,6 @@ static inline void xfs_sb_version_addatt
 			(XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT)));
 }
 
-#define	XFS_SB_VERSION_HASNLINK(sbp)	xfs_sb_version_hasnlink(sbp)
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
 	return ((sbp)->sb_versionnum == XFS_SB_VERSION_3) || \
@@ -347,7 +341,6 @@ static inline int xfs_sb_version_hasnlin
 		  ((sbp)->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
-#define	XFS_SB_VERSION_ADDNLINK(sbp)	xfs_sb_version_addnlink(sbp)
 static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = ((sbp)->sb_versionnum <= XFS_SB_VERSION_2 ? \
@@ -355,115 +348,63 @@ static inline void xfs_sb_version_addnli
 		((sbp)->sb_versionnum | XFS_SB_VERSION_NLINKBIT));
 }
 
-#define	XFS_SB_VERSION_HASQUOTA(sbp)	xfs_sb_version_hasquota(sbp)
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
-#define	XFS_SB_VERSION_ADDQUOTA(sbp)	xfs_sb_version_addquota(sbp)
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
 	(sbp)->sb_versionnum = \
 		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 ? \
 			((sbp)->sb_versionnum | XFS_SB_VERSION_QUOTABIT) : \
-			(XFS_SB_VERSION_TONEW((sbp)->sb_versionnum) | \
+			(xfs_sb_version_tonew((sbp)->sb_versionnum) | \
 			 XFS_SB_VERSION_QUOTABIT));
 }
 
-#define	XFS_SB_VERSION_HASALIGN(sbp)	xfs_sb_version_hasalign(sbp)
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
 }
 
-#define	XFS_SB_VERSION_SUBALIGN(sbp)	xfs_sb_version_subalign(sbp)
-static inline void xfs_sb_version_subalign(xfs_sb_t *sbp)
-{
-	(sbp)->sb_versionnum = \
-	 XFS_SB_VERSION_TOOLD((sbp)->sb_versionnum & ~XFS_SB_VERSION_ALIGNBIT);
-}
-
-#define XFS_SB_VERSION_HASDALIGN(sbp)	xfs_sb_version_hasdalign(sbp)
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
-#define XFS_SB_VERSION_ADDDALIGN(sbp)	xfs_sb_version_adddalign(sbp)
-static inline int xfs_sb_version_adddalign(xfs_sb_t *sbp)
-{
-	return (sbp)->sb_versionnum = \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_DALIGNBIT);
-}
-
-#define XFS_SB_VERSION_HASSHARED(sbp)	xfs_sb_version_hasshared(sbp)
 static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SHAREDBIT);
 }
 
-#define XFS_SB_VERSION_ADDSHARED(sbp)	xfs_sb_version_addshared(sbp)
-static inline int xfs_sb_version_addshared(xfs_sb_t *sbp)
-{
-	return (sbp)->sb_versionnum = \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_SHAREDBIT);
-}
-
-#define XFS_SB_VERSION_SUBSHARED(sbp)	xfs_sb_version_subshared(sbp)
-static inline int xfs_sb_version_subshared(xfs_sb_t *sbp)
-{
-	return (sbp)->sb_versionnum = \
-		((sbp)->sb_versionnum & ~XFS_SB_VERSION_SHAREDBIT);
-}
-
-#define XFS_SB_VERSION_HASDIRV2(sbp)	xfs_sb_version_hasdirv2(sbp)
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
 }
 
-#define XFS_SB_VERSION_HASLOGV2(sbp)   xfs_sb_version_haslogv2(sbp)
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
 }
 
-#define XFS_SB_VERSION_HASEXTFLGBIT(sbp)	xfs_sb_version_hasextflgbit(sbp)
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
 }
 
-#define XFS_SB_VERSION_ADDEXTFLGBIT(sbp)	xfs_sb_version_addextflgbit(sbp)
-static inline int xfs_sb_version_addextflgbit(xfs_sb_t *sbp)
-{
-	return (sbp)->sb_versionnum = \
-		((sbp)->sb_versionnum | XFS_SB_VERSION_EXTFLGBIT);
-}
-
-#define XFS_SB_VERSION_SUBEXTFLGBIT(sbp)	xfs_sb_version_subextflgbit(sbp)
-static inline int xfs_sb_version_subextflgbit(xfs_sb_t *sbp)
-{
-	return (sbp)->sb_versionnum = \
-		((sbp)->sb_versionnum & ~XFS_SB_VERSION_EXTFLGBIT);
-}
-
-#define XFS_SB_VERSION_HASSECTOR(sbp)   xfs_sb_version_hassector(sbp)
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
 		((sbp)->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
-#define XFS_SB_VERSION_HASMOREBITS(sbp)	xfs_sb_version_hasmorebits(sbp)
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4) && \
@@ -476,24 +417,22 @@ static inline int xfs_sb_version_hasmore
  * For example, for a bit defined as XFS_SB_VERSION2_FUNBIT, has a macro:
  *
  * SB_VERSION_HASFUNBIT(xfs_sb_t *sbp)
- *	((XFS_SB_VERSION_HASMOREBITS(sbp) &&
+ *	((xfs_sb_version_hasmorebits(sbp) &&
  *	 ((sbp)->sb_features2 & XFS_SB_VERSION2_FUNBIT)
  */
 
 static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_HASMOREBITS(sbp) &&	\
+	return (xfs_sb_version_hasmorebits(sbp) &&	\
 		((sbp)->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
 }
 
-#define XFS_SB_VERSION_HASATTR2(sbp)	xfs_sb_version_hasattr2(sbp)
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
-	return (XFS_SB_VERSION_HASMOREBITS(sbp)) &&	\
+	return (xfs_sb_version_hasmorebits(sbp)) &&	\
 		((sbp)->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
 }
 
-#define XFS_SB_VERSION_ADDATTR2(sbp)	xfs_sb_version_addattr2(sbp)
 static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
 {
 	((sbp)->sb_versionnum =	\
Index: linux-2.6/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_utils.c
+++ linux-2.6/fs/xfs/xfs_utils.c
@@ -339,10 +339,10 @@ xfs_bump_ino_vers2(
 	ip->i_d.di_onlink = 0;
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 	mp = tp->t_mountp;
-	if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
+	if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
 		spin_lock(&mp->m_sb_lock);
-		if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
-			XFS_SB_VERSION_ADDNLINK(&mp->m_sb);
+		if (!xfs_sb_version_hasnlink(&mp->m_sb)) {
+			xfs_sb_version_addnlink(&mp->m_sb);
 			spin_unlock(&mp->m_sb_lock);
 			xfs_mod_sb(tp, XFS_SB_VERSIONNUM);
 		} else {
Index: linux-2.6/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vfsops.c
+++ linux-2.6/fs/xfs/xfs_vfsops.c
@@ -349,7 +349,7 @@ xfs_finish_flags(
 		}
 	}
 
-	if (XFS_SB_VERSION_HASATTR2(&mp->m_sb)) {
+	if (xfs_sb_version_hasattr2(&mp->m_sb)) {
 		mp->m_flags |= XFS_MOUNT_ATTR2;
 	}
 
@@ -366,7 +366,7 @@ xfs_finish_flags(
 	 * check for shared mount.
 	 */
 	if (ap->flags & XFSMNT_SHARED) {
-		if (!XFS_SB_VERSION_HASSHARED(&mp->m_sb))
+		if (!xfs_sb_version_hasshared(&mp->m_sb))
 			return XFS_ERROR(EINVAL);
 
 		/*
@@ -512,7 +512,7 @@ xfs_mount(
 	if (!error && logdev && logdev != ddev) {
 		unsigned int	log_sector_size = BBSIZE;
 
-		if (XFS_SB_VERSION_HASSECTOR(&mp->m_sb))
+		if (xfs_sb_version_hassector(&mp->m_sb))
 			log_sector_size = mp->m_sb.sb_logsectsize;
 		error = xfs_setsize_buftarg(mp->m_logdev_targp,
 					    mp->m_sb.sb_blocksize,
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6/fs/xfs/xfs_vnodeops.c
@@ -4132,7 +4132,7 @@ xfs_free_file_space(
 	 * actually need to zero the extent edges.  Otherwise xfs_bunmapi
 	 * will take care of it for us.
 	 */
-	if (rt && !XFS_SB_VERSION_HASEXTFLGBIT(&mp->m_sb)) {
+	if (rt && !xfs_sb_version_hasextflgbit(&mp->m_sb)) {
 		nimap = 1;
 		error = xfs_bmapi(NULL, ip, startoffset_fsb,
 			1, 0, NULL, 0, &imap, &nimap, NULL, NULL);
