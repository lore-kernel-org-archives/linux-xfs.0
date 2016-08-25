Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A82587D9B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:35:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 77DA6304043
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mtcR2PtdsTe1YduM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:38 -0700 (PDT)
Subject: [PATCH 33/71] xfs: introduce the CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:35:33 -0700
Message-ID: <147216813367.867.9335678840922111140.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap.c       |   27 +++++++--
 fs/xfs/libxfs/xfs_bmap.h       |   22 +++++++-
 fs/xfs/libxfs/xfs_bmap_btree.c |    1 
 fs/xfs/libxfs/xfs_inode_fork.c |   47 +++++++++++++++-
 fs/xfs/libxfs/xfs_inode_fork.h |   28 ++++++++--
 fs/xfs/libxfs/xfs_rmap.c       |   15 +++--
 fs/xfs/libxfs/xfs_types.h      |    1 
 fs/xfs/xfs_icache.c            |    5 ++
 fs/xfs/xfs_inode.h             |    4 +
 fs/xfs/xfs_reflink.c           |  114 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h           |   23 ++++++++
 fs/xfs/xfs_trace.h             |    4 +
 13 files changed, 264 insertions(+), 28 deletions(-)
 create mode 100644 fs/xfs/xfs_reflink.c
 create mode 100644 fs/xfs/xfs_reflink.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6afb228..26ef195 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -90,6 +90,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index afedbc4..f745d7e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2924,6 +2924,7 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -4059,12 +4060,11 @@ xfs_bmapi_read(
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
@@ -4082,6 +4082,16 @@ xfs_bmapi_read(
 
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
@@ -4434,8 +4444,7 @@ xfs_bmapi_convert_unwritten(
 	xfs_filblks_t		len,
 	int			flags)
 {
-	int			whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-						XFS_ATTR_FORK : XFS_DATA_FORK;
+	int			whichfork = xfs_bmapi_whichfork(flags);
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	int			tmp_logflags = 0;
 	int			error;
@@ -4451,6 +4460,8 @@ xfs_bmapi_convert_unwritten(
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT))
 		return 0;
 
+	ASSERT(whichfork != XFS_COW_FORK);
+
 	/*
 	 * Modify (by adding) the state flag, if writing.
 	 */
@@ -4864,6 +4875,8 @@ xfs_bmap_del_extent(
 
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	else if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT((*idx >= 0) && (*idx < ifp->if_bytes /
@@ -5202,8 +5215,8 @@ __xfs_bunmapi(
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
-	whichfork = (flags & XFS_BMAPI_ATTRFORK) ?
-		XFS_ATTR_FORK : XFS_DATA_FORK;
+	whichfork = xfs_bmapi_whichfork(flags);
+	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (unlikely(
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 3b2a5b5..e686a1b 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
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
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cd85274..37f0d9d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -777,6 +777,7 @@ xfs_bmbt_init_cursor(
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur;
+	ASSERT(whichfork != XFS_COW_FORK);
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7699a03..d29954a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -206,9 +206,14 @@ xfs_iformat_fork(
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
 
@@ -247,6 +252,9 @@ xfs_iformat_fork(
 	if (error) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+		if (ip->i_cowfp)
+			kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 		xfs_idestroy_fork(ip, XFS_DATA_FORK);
 	}
 	return error;
@@ -761,6 +769,9 @@ xfs_idestroy_fork(
 	if (whichfork == XFS_ATTR_FORK) {
 		kmem_zone_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
+	} else if (whichfork == XFS_COW_FORK) {
+		kmem_zone_free(xfs_ifork_zone, ip->i_cowfp);
+		ip->i_cowfp = NULL;
 	}
 }
 
@@ -948,6 +959,19 @@ xfs_iext_get_ext(
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
@@ -960,7 +984,7 @@ xfs_iext_insert(
 	xfs_bmbt_irec_t	*new,		/* items to insert */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	i;		/* extent record index */
 
 	trace_xfs_iext_insert(ip, idx, new, state, _RET_IP_);
@@ -1210,7 +1234,7 @@ xfs_iext_remove(
 	int		ext_diff,	/* number of extents to remove */
 	int		state)		/* type of extent conversion */
 {
-	xfs_ifork_t	*ifp = (state & BMAP_ATTRFORK) ? ip->i_afp : &ip->i_df;
+	xfs_ifork_t	*ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 	xfs_extnum_t	nextents;	/* number of extents in file */
 	int		new_size;	/* size of extents after removal */
 
@@ -1955,3 +1979,20 @@ xfs_iext_irec_update_extoffs(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index f95e072..44d38eb 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 73d0540..1c40b85 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -1263,9 +1263,10 @@ out_cur:
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
@@ -1311,7 +1312,7 @@ xfs_rmap_map_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_MAP, ip->i_ino,
@@ -1327,7 +1328,7 @@ xfs_rmap_unmap_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_UNMAP, ip->i_ino,
@@ -1343,7 +1344,7 @@ xfs_rmap_convert_extent(
 	int			whichfork,
 	struct xfs_bmbt_irec	*PREV)
 {
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, whichfork))
 		return 0;
 
 	return __xfs_rmap_add(mp, dfops, XFS_RMAP_CONVERT, ip->i_ino,
@@ -1362,7 +1363,7 @@ xfs_rmap_alloc_extent(
 {
 	struct xfs_bmbt_irec	bmap;
 
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
 		return 0;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
@@ -1386,7 +1387,7 @@ xfs_rmap_free_extent(
 {
 	struct xfs_bmbt_irec	bmap;
 
-	if (!xfs_rmap_update_is_needed(mp))
+	if (!xfs_rmap_update_is_needed(mp, XFS_DATA_FORK))
 		return 0;
 
 	bmap.br_startblock = XFS_AGB_TO_FSB(mp, agno, bno);
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 690d616..cf044c0 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -93,6 +93,7 @@ typedef __int64_t	xfs_sfiloff_t;	/* signed block number in a file */
  */
 #define	XFS_DATA_FORK	0
 #define	XFS_ATTR_FORK	1
+#define	XFS_COW_FORK	2
 
 /*
  * Min numbers of data/attr fork btree root pointers.
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fb39a66..b5ccd20 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -76,6 +76,9 @@ xfs_inode_alloc(
 	ip->i_mount = mp;
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_afp = NULL;
+	ip->i_cowfp = NULL;
+	ip->i_cnextents = 0;
+	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(xfs_ifork_t));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
@@ -101,6 +104,8 @@ xfs_inode_free_callback(
 
 	if (ip->i_afp)
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
+	if (ip->i_cowfp)
+		xfs_idestroy_fork(ip, XFS_COW_FORK);
 
 	if (ip->i_itemp) {
 		ASSERT(!(ip->i_itemp->ili_item.li_flags & XFS_LI_IN_AIL));
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 7283db3..7b2e858 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -47,6 +47,7 @@ typedef struct xfs_inode {
 
 	/* Extent information. */
 	xfs_ifork_t		*i_afp;		/* attribute fork pointer */
+	xfs_ifork_t		*i_cowfp;	/* copy on write extents */
 	xfs_ifork_t		i_df;		/* data fork */
 
 	/* operations vectors */
@@ -65,6 +66,9 @@ typedef struct xfs_inode {
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
+	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
+	unsigned int		i_cformat;	/* format of cow fork */
+
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 } xfs_inode_t;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
new file mode 100644
index 0000000..7adbb83
--- /dev/null
+++ b/fs/xfs/xfs_reflink.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_inode_item.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_error.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ioctl.h"
+#include "xfs_trace.h"
+#include "xfs_log.h"
+#include "xfs_icache.h"
+#include "xfs_pnfs.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bit.h"
+#include "xfs_alloc.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+#include "xfs_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
+
+/*
+ * Copy on Write of Shared Blocks
+ *
+ * XFS must preserve "the usual" file semantics even when two files share
+ * the same physical blocks.  This means that a write to one file must not
+ * alter the blocks in a different file; the way that we'll do that is
+ * through the use of a copy-on-write mechanism.  At a high level, that
+ * means that when we want to write to a shared block, we allocate a new
+ * block, write the data to the new block, and if that succeeds we map the
+ * new block into the file.
+ *
+ * XFS provides a "delayed allocation" mechanism that defers the allocation
+ * of disk blocks to dirty-but-not-yet-mapped file blocks as long as
+ * possible.  This reduces fragmentation by enabling the filesystem to ask
+ * for bigger chunks less often, which is exactly what we want for CoW.
+ *
+ * The delalloc mechanism begins when the kernel wants to make a block
+ * writable (write_begin or page_mkwrite).  If the offset is not mapped, we
+ * create a delalloc mapping, which is a regular in-core extent, but without
+ * a real startblock.  (For delalloc mappings, the startblock encodes both
+ * a flag that this is a delalloc mapping, and a worst-case estimate of how
+ * many blocks might be required to put the mapping into the BMBT.)  delalloc
+ * mappings are a reservation against the free space in the filesystem;
+ * adjacent mappings can also be combined into fewer larger mappings.
+ *
+ * When dirty pages are being written out (typically in writepage), the
+ * delalloc reservations are converted into real mappings by allocating
+ * blocks and replacing the delalloc mapping with real ones.  A delalloc
+ * mapping can be replaced by several real ones if the free space is
+ * fragmented.
+ *
+ * We want to adapt the delalloc mechanism for copy-on-write, since the
+ * write paths are similar.  The first two steps (creating the reservation
+ * and allocating the blocks) are exactly the same as delalloc except that
+ * the mappings must be stored in a separate CoW fork because we do not want
+ * to disturb the mapping in the data fork until we're sure that the write
+ * succeeded.  IO completion in this case is the process of removing the old
+ * mapping from the data fork and moving the new mapping from the CoW fork to
+ * the data fork.  This will be discussed shortly.
+ *
+ * For now, unaligned directio writes will be bounced back to the page cache.
+ * Block-aligned directio writes will use the same mechanism as buffered
+ * writes.
+ *
+ * CoW remapping must be done after the data block write completes,
+ * because we don't want to destroy the old data fork map until we're sure
+ * the new block has been written.  Since the new mappings are kept in a
+ * separate fork, we can simply iterate these mappings to find the ones
+ * that cover the file blocks that we just CoW'd.  For each extent, simply
+ * unmap the corresponding range in the data fork, map the new range into
+ * the data fork, and remove the extent from the CoW fork.
+ *
+ * Since the remapping operation can be applied to an arbitrary file
+ * range, we record the need for the remap step as a flag in the ioend
+ * instead of declaring a new IO type.  This is required for direct io
+ * because we only have ioend for the whole dio, and we have to be able to
+ * remember the presence of unwritten blocks and CoW blocks with a single
+ * ioend structure.  Better yet, the more ground we can cover with one
+ * ioend, the better.
+ */
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
new file mode 100644
index 0000000..820b151
--- /dev/null
+++ b/fs/xfs/xfs_reflink.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_REFLINK_H
+#define __XFS_REFLINK_H 1
+
+#endif /* __XFS_REFLINK_H */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 57ef0fa..73d92be 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -269,10 +269,10 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		struct xfs_ifork	*ifp = (state & BMAP_ATTRFORK) ?
-						ip->i_afp : &ip->i_df;
+		struct xfs_ifork	*ifp;
 		struct xfs_bmbt_irec	r;
 
+		ifp = XFS_IEXT_STATE_TO_FORK(ip, state);
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &r);
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
