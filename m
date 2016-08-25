Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B36038160
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:49:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 681EE30404E
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Ra6eWAJ2XeBvCDon (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:49:27 -0700 (PDT)
Subject: [PATCH 27/71] xfs: introduce the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:49:22 -0700
Message-ID: <147216896243.4420.7348456039656197972.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Introduce a new in-core fork for storing copy-on-write delalloc
reservations and allocated extents that are in the process of being
written out.

v2: fix up bmapi_read so that we can query the CoW fork, and have it
return a "hole" extent if there's no CoW fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_inode.h     |    3 +++
 libxfs/rdwr.c           |    2 ++
 libxfs/xfs_bmap.c       |   27 ++++++++++++++++++++-------
 libxfs/xfs_bmap.h       |   22 +++++++++++++++++++---
 libxfs/xfs_bmap_btree.c |    1 +
 libxfs/xfs_inode_fork.c |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_inode_fork.h |   28 ++++++++++++++++++++++------
 libxfs/xfs_rmap.c       |   15 ++++++++-------
 libxfs/xfs_types.h      |    1 +
 9 files changed, 120 insertions(+), 26 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 3876fa6..b7623c0 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -50,6 +50,7 @@ typedef struct xfs_inode {
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 	struct xfs_buftarg	i_dev;		/* dev for this inode */
 	struct xfs_ifork	*i_afp;		/* attribute fork pointer */
+	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
 	struct xfs_trans	*i_transp;	/* ptr to owning transaction */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
@@ -58,6 +59,8 @@ typedef struct xfs_inode {
 	xfs_fsize_t		i_size;		/* in-memory size */
 	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
 	struct inode		i_vnode;
+	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
+	unsigned int		i_cformat;	/* format of cow fork */
 } xfs_inode_t;
 
 static inline struct inode *VFS_I(struct xfs_inode *ip)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index aa30522..533a064 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1372,6 +1372,8 @@ libxfs_idestroy(xfs_inode_t *ip)
 	}
 	if (ip->i_afp)
 		libxfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	if (ip->i_cowfp)
+		xfs_idestroy_fork(ip, XFS_COW_FORK);
 }
 
 void
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 011ac9b..3121f7f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -2916,6 +2916,7 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4051,12 +4052,11 @@ xfs_bmapi_read(
 	int			error;
 	int			eof;
 	int			n = 0;
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
-			   XFS_BMAPI_IGSTATE)));
+			   XFS_BMAPI_IGSTATE|XFS_BMAPI_COWFORK)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (unlikely(XFS_TEST_ERROR(
@@ -4074,6 +4074,16 @@ xfs_bmapi_read(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
+	/* No CoW fork?  Return a hole. */
+	if (whichfork == XFS_COW_FORK && !ifp) {
+		mval->br_startoff = bno;
+		mval->br_startblock = HOLESTARTBLOCK;
+		mval->br_blockcount = len;
+		mval->br_state = XFS_EXT_NORM;
+		*nmap = 1;
+		return 0;
+	}
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, whichfork);
 		if (error)
@@ -4426,8 +4436,7 @@ xfs_bmapi_convert_unwritten(
 	xfs_filblks_t		len,
 	int			flags)
 {
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4443,6 +4452,8 @@ xfs_bmapi_convert_unwritten(
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
 		return 0;
 
+	ASSERT(whichfork != XFS_COW_FORK);
+
 	/*
 	 * Modify (by adding) the state flag, if writing.
 	 */
@@ -4856,6 +4867,8 @@ xfs_bmap_del_extent(
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	else if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
@@ -5194,8 +5207,8 @@ __xfs_bunmapi(
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (unlikely(
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4b68e96..b7df7d4 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -107,6 +107,9 @@ struct xfs_extent_free_item
  */
 #define XFS_BMAPI_REMAP		0x100
 
+/* Map something in the CoW fork. */
+#define XFS_BMAPI_COWFORK	0x200
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -116,12 +119,23 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
 	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
-	{ XFS_BMAPI_REMAP,	"REMAP" }
+	{ XFS_BMAPI_REMAP,	"REMAP" }, \
+	{ XFS_BMAPI_COWFORK,	"COWFORK" }
 
 
 static inline int xfs_bmapi_aflag(int w)
 {
-	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK : 0);
+	return (w == XFS_ATTR_FORK ? XFS_BMAPI_ATTRFORK :
+	       (w == XFS_COW_FORK ? XFS_BMAPI_COWFORK : 0));
+}
+
+static inline int xfs_bmapi_whichfork(int bmapi_flags)
+{
+	if (bmapi_flags & XFS_BMAPI_COWFORK)
+		return XFS_COW_FORK;
+	else if (bmapi_flags & XFS_BMAPI_ATTRFORK)
+		return XFS_ATTR_FORK;
+	return XFS_DATA_FORK;
 }
 
 /*
@@ -142,13 +156,15 @@ static inline int xfs_bmapi_aflag(int w)
 #define BMAP_LEFT_VALID		(1 << 6)
 #define BMAP_RIGHT_VALID	(1 << 7)
 #define BMAP_ATTRFORK		(1 << 8)
+#define BMAP_COWFORK		(1 << 9)
 
 #define XFS_BMAP_EXT_FLAGS \
 	{ BMAP_LEFT_CONTIG,	"LC" }, \
 	{ BMAP_RIGHT_CONTIG,	"RC" }, \
 	{ BMAP_LEFT_FILLING,	"LF" }, \
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
-	{ BMAP_ATTRFORK,	"ATTR" }
+	{ BMAP_ATTRFORK,	"ATTR" }, \
+	{ BMAP_COWFORK,		"COW" }
 
 
 /*
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 906983e..3d1a02e 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -774,6 +774,7 @@ xfs_bmbt_init_cursor(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur;
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index eda590f..e65f633 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -202,9 +202,14 @@ xfs_iformat_fork(
 		XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW, ip->i_mount);
 		return -EFSCORRUPTED;
 	}
-	if (error) {
+	if (error)
 		return error;
+
+	if (xfs_is_reflink_inode(ip)) {
+		ASSERT(ip->i_cowfp == NULL);
+		xfs_ifork_init_cow(ip);
 	}
+
 	if (!XFS_DFORK_Q(dip))
 		return 0;
 
@@ -243,6 +248,9 @@ xfs_iformat_fork(
 	if (error) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+		if (ip->i_cowfp)
+			kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 		xfs_idestroy_fork(ip, XFS_DATA_FORK);
 	}
 	return error;
@@ -757,6 +765,9 @@ xfs_idestroy_fork(
 	if (whichfork == XFS_ATTR_FORK) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+	} else if (whichfork == XFS_COW_FORK) {
+		kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 	}
 }
 
@@ -944,6 +955,19 @@ xfs_iext_get_ext(
 	}
 }
 
+/* XFS_IEXT_STATE_TO_FORK() -- Convert BMAP state flags to an inode fork. */
+xfs_ifork_t *
+XFS_IEXT_STATE_TO_FORK(
+	struct xfs_inode	*ip,
+	int			state)
+{
+	if (state & BMAP_COWFORK)
+		return ip->i_cowfp;
+	else if (state & BMAP_ATTRFORK)
+		return ip->i_afp;
+	return &ip->i_df;
+}
+
 /*
  * Insert new item(s) into the extent records for incore inode
  * fork 'ifp'.  'count' new items are inserted at index 'idx'.
@@ -956,7 +980,7 @@ xfs_iext_insert(
 	xfs_bmbt_irec_t	*new,		/* items to insert */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	i;		/* extent record index */
 
 	trace_xfs_iext_insert(ip, idx, new, state, _RET_IP_);
@@ -1206,7 +1230,7 @@ xfs_iext_remove(
 	int		ext_diff,	/* number of extents to remove */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		new_size;	/* size of extents after removal */
 
@@ -1953,3 +1977,20 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
+
+/*
+ * Initialize an inode's copy-on-write fork.
+ */
+void
+xfs_ifork_init_cow(
+	struct xfs_inode	*ip)
+{
+	if (ip->i_cowfp)
+		return;
+
+	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
+				       KM_SLEEP | KM_NOFS);
+	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
+	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_cnextents = 0;
+}
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index f95e072..44d38eb 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -92,7 +92,9 @@ typedef struct xfs_ifork {
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
 		&(ip)->i_df : \
-		(ip)->i_afp)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_afp : \
+			(ip)->i_cowfp))
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
@@ -105,26 +107,38 @@ typedef struct xfs_ifork {
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
-		XFS_IFORK_ASIZE(ip))
+		((w) == XFS_ATTR_FORK ? \
+			XFS_IFORK_ASIZE(ip) : \
+			0))
 #define XFS_IFORK_FORMAT(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		(ip)->i_d.di_format : \
-		(ip)->i_d.di_aformat)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_d.di_aformat : \
+			(ip)->i_cformat))
 #define XFS_IFORK_FMT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
 		((ip)->i_d.di_format = (n)) : \
-		((ip)->i_d.di_aformat = (n)))
+		((w) == XFS_ATTR_FORK ? \
+			((ip)->i_d.di_aformat = (n)) : \
+			((ip)->i_cformat = (n))))
 #define XFS_IFORK_NEXTENTS(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		(ip)->i_d.di_nextents : \
-		(ip)->i_d.di_anextents)
+		((w) == XFS_ATTR_FORK ? \
+			(ip)->i_d.di_anextents : \
+			(ip)->i_cnextents))
 #define XFS_IFORK_NEXT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
 		((ip)->i_d.di_nextents = (n)) : \
-		((ip)->i_d.di_anextents = (n)))
+		((w) == XFS_ATTR_FORK ? \
+			((ip)->i_d.di_anextents = (n)) : \
+			((ip)->i_cnextents = (n))))
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
+xfs_ifork_t	*XFS_IEXT_STATE_TO_FORK(struct xfs_inode *ip, int state);
+
 int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
@@ -169,4 +183,6 @@ void		xfs_iext_irec_update_extoffs(struct xfs_ifork *, int, int);
 
 extern struct kmem_zone	*xfs_ifork_zone;
 
+extern void xfs_ifork_init_cow(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index b752fed..82c2597 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -1261,9 +1261,10 @@ out_cur:
  */
 static bool
 xfs_rmap_update_is_needed(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	int			whichfork)
 {
-	return xfs_sb_version_hasrmapbt(&mp->m_sb);
+	return xfs_sb_version_hasrmapbt(&mp->m_sb) && whichfork != XFS_COW_FORK;
 }
 
 /*
@@ -1309,7 +1310,7 @@ xfs_rmap_map_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_MAP, ip->i_ino,
@@ -1325,7 +1326,7 @@ xfs_rmap_unmap_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_UNMAP, ip->i_ino,
@@ -1341,7 +1342,7 @@ xfs_rmap_convert_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_CONVERT, ip->i_ino,
@@ -1360,7 +1361,7 @@ xfs_rmap_alloc_extent(
 {
 	struct xfs_bmbt_irec	bmap;
 
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
 		return 0;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
@@ -1384,7 +1385,7 @@ xfs_rmap_free_extent(
 {
 	struct xfs_bmbt_irec	bmap;
 
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
 		return 0;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 690d616..cf044c0 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -93,6 +93,7 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
  */
 #define	XFS_DATA_FORK	0
 #define	XFS_ATTR_FORK	1
+#define	XFS_COW_FORK	2
 
 /*
  * Min numbers of data/attr fork btree root pointers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
