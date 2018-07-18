Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37670 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730436AbeGRQam (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 12:30:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6IFnFGT008861
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:07 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2k9yjgj8xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:07 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFq6lj005452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:06 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFq6qT032541
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:06 GMT
Subject: [PATCH 7/8] xfs: shorten struct xfs_scrub_context to struct
 xfs_scrub
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 08:52:05 -0700
Message-ID: <153192912513.31685.7038718845923992485.stgit@magnolia>
In-Reply-To: <153192902811.31685.11590100183112248407.stgit@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Shorten the name of the online fsck context structure.  Whitespace
damage will be fixed by a subsequent patch.  There are no functional
changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader.c        |   32 +++++++--------
 fs/xfs/scrub/agheader_repair.c |    2 -
 fs/xfs/scrub/alloc.c           |   14 +++---
 fs/xfs/scrub/attr.c            |   10 ++---
 fs/xfs/scrub/bmap.c            |   22 +++++-----
 fs/xfs/scrub/btree.c           |   14 +++---
 fs/xfs/scrub/btree.h           |   12 +++--
 fs/xfs/scrub/common.c          |   62 ++++++++++++++--------------
 fs/xfs/scrub/common.h          |   88 ++++++++++++++++++++--------------------
 fs/xfs/scrub/dabtree.c         |    6 +--
 fs/xfs/scrub/dabtree.h         |    4 +-
 fs/xfs/scrub/dir.c             |   18 ++++----
 fs/xfs/scrub/ialloc.c          |   22 +++++-----
 fs/xfs/scrub/inode.c           |   22 +++++-----
 fs/xfs/scrub/parent.c          |    8 ++--
 fs/xfs/scrub/quota.c           |   12 +++--
 fs/xfs/scrub/refcount.c        |   16 ++++---
 fs/xfs/scrub/repair.c          |   36 ++++++++--------
 fs/xfs/scrub/repair.h          |   38 +++++++++--------
 fs/xfs/scrub/rmap.c            |   16 ++++---
 fs/xfs/scrub/rtbitmap.c        |   10 ++---
 fs/xfs/scrub/scrub.c           |   10 ++---
 fs/xfs/scrub/scrub.h           |   78 ++++++++++++++++++-----------------
 fs/xfs/scrub/symlink.c         |    4 +-
 fs/xfs/scrub/trace.h           |   32 +++++++--------
 25 files changed, 294 insertions(+), 294 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index c0625ec16d63..14ba4189ae8f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -29,7 +29,7 @@
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_superblock_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*bp)
 {
 	struct xfs_owner_info		oinfo;
@@ -66,7 +66,7 @@ xchk_superblock_xref(
  */
 int
 xchk_superblock(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_buf			*bp;
@@ -365,7 +365,7 @@ xchk_agf_record_bno_lengths(
 /* Check agf_freeblks */
 static inline void
 xchk_agf_xref_freeblks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	xfs_extlen_t			blocks = 0;
@@ -385,7 +385,7 @@ xchk_agf_xref_freeblks(
 /* Cross reference the AGF with the cntbt (freespace by length btree) */
 static inline void
 xchk_agf_xref_cntbt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	xfs_agblock_t			agbno;
@@ -417,7 +417,7 @@ xchk_agf_xref_cntbt(
 /* Check the btree block counts in the AGF against the btrees. */
 STATIC void
 xchk_agf_xref_btreeblks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	struct xfs_mount		*mp = sc->mp;
@@ -463,7 +463,7 @@ xchk_agf_xref_btreeblks(
 /* Check agf_refcount_blocks against tree size */
 static inline void
 xchk_agf_xref_refcblks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_agf			*agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
 	xfs_agblock_t			blocks;
@@ -482,7 +482,7 @@ xchk_agf_xref_refcblks(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agf_xref(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
@@ -514,7 +514,7 @@ xchk_agf_xref(
 /* Scrub the AGF. */
 int
 xchk_agf(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agf			*agf;
@@ -602,13 +602,13 @@ struct xchk_agfl_info {
 	unsigned int			sz_entries;
 	unsigned int			nr_entries;
 	xfs_agblock_t			*entries;
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 };
 
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agfl_block_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	struct xfs_owner_info		*oinfo)
 {
@@ -629,7 +629,7 @@ xchk_agfl_block(
 	void				*priv)
 {
 	struct xchk_agfl_info		*sai = priv;
-	struct xfs_scrub_context	*sc = sai->sc;
+	struct xfs_scrub	*sc = sai->sc;
 	xfs_agnumber_t			agno = sc->sa.agno;
 
 	if (xfs_verify_agbno(mp, agno, agbno) &&
@@ -660,7 +660,7 @@ xchk_agblock_cmp(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agfl_xref(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
@@ -691,7 +691,7 @@ xchk_agfl_xref(
 /* Scrub the AGFL. */
 int
 xchk_agfl(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_agfl_info		sai;
 	struct xfs_agf			*agf;
@@ -768,7 +768,7 @@ xchk_agfl(
 /* Check agi_count/agi_freecount */
 static inline void
 xchk_agi_xref_icounts(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_agi			*agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
 	xfs_agino_t			icount;
@@ -789,7 +789,7 @@ xchk_agi_xref_icounts(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_agi_xref(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = sc->mp;
@@ -818,7 +818,7 @@ xchk_agi_xref(
 /* Scrub the AGI. */
 int
 xchk_agi(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_agi			*agi;
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 631940f3ca4d..2457968482f8 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -29,7 +29,7 @@
 /* Repair the superblock. */
 int
 xrep_superblock(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_buf			*bp;
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 1f6e3a6a1fdd..653d80b3aa39 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -29,7 +29,7 @@
  */
 int
 xchk_setup_ag_allocbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_ag_btree(sc, ip, false);
@@ -42,7 +42,7 @@ xchk_setup_ag_allocbt(
  */
 STATIC void
 xchk_allocbt_xref_other(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
@@ -82,7 +82,7 @@ xchk_allocbt_xref_other(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_allocbt_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
@@ -123,7 +123,7 @@ xchk_allocbt_rec(
 /* Scrub the freespace btrees for some AG. */
 STATIC int
 xchk_allocbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_btnum_t			which)
 {
 	struct xfs_owner_info		oinfo;
@@ -136,14 +136,14 @@ xchk_allocbt(
 
 int
 xchk_bnobt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_allocbt(sc, XFS_BTNUM_BNO);
 }
 
 int
 xchk_cntbt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_allocbt(sc, XFS_BTNUM_CNT);
 }
@@ -151,7 +151,7 @@ xchk_cntbt(
 /* xref check that the extent is not free */
 void
 xchk_xref_is_used_space(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 0068bebddf3e..6650fb3010b6 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -33,7 +33,7 @@
 /* Set us up to scrub an inode's extended attributes. */
 int
 xchk_setup_xattr(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	size_t				sz;
@@ -57,7 +57,7 @@ xchk_setup_xattr(
 
 struct xchk_xattr {
 	struct xfs_attr_list_context	context;
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 };
 
 /*
@@ -127,7 +127,7 @@ xchk_xattr_listent(
  */
 STATIC bool
 xchk_xattr_set_map(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	unsigned long			*map,
 	unsigned int			start,
 	unsigned int			len)
@@ -155,7 +155,7 @@ xchk_xattr_set_map(
  */
 STATIC bool
 xchk_xattr_check_freemap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	unsigned long			*map,
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
@@ -405,7 +405,7 @@ xchk_xattr_rec(
 /* Scrub the extended attribute metadata. */
 int
 xchk_xattr(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_xattr		sx;
 	struct attrlist_cursor_kern	cursor = { 0 };
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 19cfbd3910a2..0e5166232b15 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -34,7 +34,7 @@
 /* Set us up with an inode's bmap. */
 int
 xchk_setup_inode_bmap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	int				error;
@@ -79,7 +79,7 @@ xchk_setup_inode_bmap(
  */
 
 struct xchk_bmap_info {
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	xfs_fileoff_t			lastoff;
 	bool				is_rt;
 	bool				is_shared;
@@ -391,7 +391,7 @@ xchk_bmapbt_rec(
 /* Scan the btree records. */
 STATIC int
 xchk_bmap_btree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	struct xchk_bmap_info		*info)
 {
@@ -409,7 +409,7 @@ xchk_bmap_btree(
 }
 
 struct xchk_bmap_check_rmap_info {
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	int				whichfork;
 	struct xfs_iext_cursor		icur;
 };
@@ -424,7 +424,7 @@ xchk_bmap_check_rmap(
 	struct xfs_bmbt_irec		irec;
 	struct xchk_bmap_check_rmap_info	*sbcri = priv;
 	struct xfs_ifork		*ifp;
-	struct xfs_scrub_context	*sc = sbcri->sc;
+	struct xfs_scrub	*sc = sbcri->sc;
 	bool				have_map;
 
 	/* Is this even the right fork? */
@@ -488,7 +488,7 @@ xchk_bmap_check_rmap(
 /* Make sure each rmap has a corresponding bmbt entry. */
 STATIC int
 xchk_bmap_check_ag_rmaps(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_agnumber_t			agno)
 {
@@ -522,7 +522,7 @@ xchk_bmap_check_ag_rmaps(
 /* Make sure each rmap has a corresponding bmbt entry. */
 STATIC int
 xchk_bmap_check_rmaps(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork)
 {
 	loff_t				size;
@@ -579,7 +579,7 @@ xchk_bmap_check_rmaps(
  */
 STATIC int
 xchk_bmap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork)
 {
 	struct xfs_bmbt_irec		irec;
@@ -694,7 +694,7 @@ xchk_bmap(
 /* Scrub an inode's data fork. */
 int
 xchk_bmap_data(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_bmap(sc, XFS_DATA_FORK);
 }
@@ -702,7 +702,7 @@ xchk_bmap_data(
 /* Scrub an inode's attr fork. */
 int
 xchk_bmap_attr(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_bmap(sc, XFS_ATTR_FORK);
 }
@@ -710,7 +710,7 @@ xchk_bmap_attr(
 /* Scrub an inode's CoW fork. */
 int
 xchk_bmap_cow(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	if (!xfs_is_reflink_inode(sc->ip))
 		return -ENOENT;
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 30fe9a147959..c4e1dce8c5b3 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -30,7 +30,7 @@
  */
 static bool
 __xchk_btree_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	int				*error,
@@ -65,7 +65,7 @@ __xchk_btree_process_error(
 
 bool
 xchk_btree_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	int				*error)
@@ -76,7 +76,7 @@ xchk_btree_process_error(
 
 bool
 xchk_btree_xref_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	int				*error)
@@ -88,7 +88,7 @@ xchk_btree_xref_process_error(
 /* Record btree block corruption. */
 static void
 __xchk_btree_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level,
 	__u32				errflag,
@@ -106,7 +106,7 @@ __xchk_btree_set_corrupt(
 
 void
 xchk_btree_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level)
 {
@@ -116,7 +116,7 @@ xchk_btree_set_corrupt(
 
 void
 xchk_btree_xref_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	int				level)
 {
@@ -583,7 +583,7 @@ xchk_btree_block_keys(
  */
 int
 xchk_btree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_btree_cur		*cur,
 	xchk_btree_rec_fn		scrub_fn,
 	struct xfs_owner_info		*oinfo,
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 598ac04a6c3e..a0b74b515b9b 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -9,20 +9,20 @@
 /* btree scrub */
 
 /* Check for btree operation errors. */
-bool xchk_btree_process_error(struct xfs_scrub_context *sc,
+bool xchk_btree_process_error(struct xfs_scrub *sc,
 		struct xfs_btree_cur *cur, int level, int *error);
 
 /* Check for btree xref operation errors. */
-bool xchk_btree_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_btree_xref_process_error(struct xfs_scrub *sc,
 				struct xfs_btree_cur *cur, int level,
 				int *error);
 
 /* Check for btree corruption. */
-void xchk_btree_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_btree_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_btree_cur *cur, int level);
 
 /* Check for btree xref discrepancies. */
-void xchk_btree_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_btree_xref_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_btree_cur *cur, int level);
 
 struct xchk_btree;
@@ -32,7 +32,7 @@ typedef int (*xchk_btree_rec_fn)(
 
 struct xchk_btree {
 	/* caller-provided scrub state */
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	struct xfs_btree_cur		*cur;
 	xchk_btree_rec_fn		scrub_rec;
 	struct xfs_owner_info		*oinfo;
@@ -45,7 +45,7 @@ struct xchk_btree {
 	bool				firstkey[XFS_BTREE_MAXLEVELS];
 	struct list_head		to_check;
 };
-int xchk_btree(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		    xchk_btree_rec_fn scrub_fn,
 		    struct xfs_owner_info *oinfo, void *private);
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index fa1c16063d17..81e8bb7d5486 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -69,7 +69,7 @@
 /* Check for operational errors. */
 static bool
 __xchk_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	int				*error,
@@ -99,7 +99,7 @@ __xchk_process_error(
 
 bool
 xchk_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	int				*error)
@@ -110,7 +110,7 @@ xchk_process_error(
 
 bool
 xchk_xref_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	int				*error)
@@ -122,7 +122,7 @@ xchk_xref_process_error(
 /* Check for operational errors for a file offset. */
 static bool
 __xchk_fblock_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
 	int				*error,
@@ -152,7 +152,7 @@ __xchk_fblock_process_error(
 
 bool
 xchk_fblock_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
 	int				*error)
@@ -163,7 +163,7 @@ xchk_fblock_process_error(
 
 bool
 xchk_fblock_xref_process_error(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset,
 	int				*error)
@@ -187,7 +187,7 @@ xchk_fblock_xref_process_error(
 /* Record a block which could be optimized. */
 void
 xchk_block_set_preen(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
@@ -201,7 +201,7 @@ xchk_block_set_preen(
  */
 void
 xchk_ino_set_preen(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
@@ -211,7 +211,7 @@ xchk_ino_set_preen(
 /* Record a corrupt block. */
 void
 xchk_block_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
@@ -221,7 +221,7 @@ xchk_block_set_corrupt(
 /* Record a corruption while cross-referencing. */
 void
 xchk_block_xref_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*bp)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
@@ -235,7 +235,7 @@ xchk_block_xref_set_corrupt(
  */
 void
 xchk_ino_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
@@ -245,7 +245,7 @@ xchk_ino_set_corrupt(
 /* Record a corruption while cross-referencing with an inode. */
 void
 xchk_ino_xref_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
@@ -255,7 +255,7 @@ xchk_ino_xref_set_corrupt(
 /* Record corruption in a block indexed by a file fork. */
 void
 xchk_fblock_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
@@ -266,7 +266,7 @@ xchk_fblock_set_corrupt(
 /* Record a corruption while cross-referencing a fork block. */
 void
 xchk_fblock_xref_set_corrupt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
@@ -280,7 +280,7 @@ xchk_fblock_xref_set_corrupt(
  */
 void
 xchk_ino_set_warning(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
@@ -290,7 +290,7 @@ xchk_ino_set_warning(
 /* Warn about a block indexed by a file fork that needs review. */
 void
 xchk_fblock_set_warning(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xfs_fileoff_t			offset)
 {
@@ -301,7 +301,7 @@ xchk_fblock_set_warning(
 /* Signal an incomplete scrub. */
 void
 xchk_set_incomplete(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
 	trace_xchk_incomplete(sc, __return_address);
@@ -345,7 +345,7 @@ xchk_count_rmap_ownedby_irec(
  */
 int
 xchk_count_rmap_ownedby_ag(
-	struct xfs_scrub_context		*sc,
+	struct xfs_scrub		*sc,
 	struct xfs_btree_cur			*cur,
 	struct xfs_owner_info			*oinfo,
 	xfs_filblks_t				*blocks)
@@ -371,7 +371,7 @@ xchk_count_rmap_ownedby_ag(
 /* Decide if we want to return an AG header read failure. */
 static inline bool
 want_ag_read_header_failure(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	unsigned int			type)
 {
 	/* Return all AG header read failures when scanning btrees. */
@@ -398,7 +398,7 @@ want_ag_read_header_failure(
  */
 int
 xchk_ag_read_headers(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agnumber_t			agno,
 	struct xfs_buf			**agi,
 	struct xfs_buf			**agf,
@@ -452,7 +452,7 @@ xchk_ag_btcur_free(
 /* Initialize all the btree cursors for an AG. */
 int
 xchk_ag_btcur_init(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xchk_ag		*sa)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -512,7 +512,7 @@ xchk_ag_btcur_init(
 /* Release the AG header context and btree cursors. */
 void
 xchk_ag_free(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xchk_ag		*sa)
 {
 	xchk_ag_btcur_free(sa);
@@ -544,7 +544,7 @@ xchk_ag_free(
  */
 int
 xchk_ag_init(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agnumber_t			agno,
 	struct xchk_ag		*sa)
 {
@@ -586,7 +586,7 @@ xchk_perag_get(
  */
 int
 xchk_trans_alloc(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	uint				resblks)
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
@@ -599,7 +599,7 @@ xchk_trans_alloc(
 /* Set us up with a transaction and an empty context. */
 int
 xchk_setup_fs(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	uint				resblks;
@@ -611,7 +611,7 @@ xchk_setup_fs(
 /* Set us up with AG headers and btree cursors. */
 int
 xchk_setup_ag_btree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip,
 	bool				force_log)
 {
@@ -658,7 +658,7 @@ xchk_checkpoint_log(
  */
 int
 xchk_get_inode(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip_in)
 {
 	struct xfs_imap			imap;
@@ -722,7 +722,7 @@ xchk_get_inode(
 /* Set us up to scrub a file's contents. */
 int
 xchk_setup_inode_contents(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip,
 	unsigned int			resblks)
 {
@@ -753,7 +753,7 @@ xchk_setup_inode_contents(
  */
 bool
 xchk_should_check_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				*error,
 	struct xfs_btree_cur		**curpp)
 {
@@ -788,7 +788,7 @@ xchk_should_check_xref(
 /* Run the structure verifiers on in-memory buffers to detect bad memory. */
 void
 xchk_buffer_recheck(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*bp)
 {
 	xfs_failaddr_t			fa;
@@ -814,7 +814,7 @@ xchk_buffer_recheck(
  */
 int
 xchk_metadata_inode_forks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	__u32				smtype;
 	bool				shared;
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5881cb2ecc26..c321230d32dc 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -13,7 +13,7 @@
  */
 static inline bool
 xchk_should_terminate(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				*error)
 {
 	if (fatal_signal_pending(current)) {
@@ -24,109 +24,109 @@ xchk_should_terminate(
 	return false;
 }
 
-int xchk_trans_alloc(struct xfs_scrub_context *sc, uint resblks);
-bool xchk_process_error(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
+bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
-bool xchk_fblock_process_error(struct xfs_scrub_context *sc, int whichfork,
+bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
-bool xchk_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_xref_process_error(struct xfs_scrub *sc,
 		xfs_agnumber_t agno, xfs_agblock_t bno, int *error);
-bool xchk_fblock_xref_process_error(struct xfs_scrub_context *sc,
+bool xchk_fblock_xref_process_error(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset, int *error);
 
-void xchk_block_set_preen(struct xfs_scrub_context *sc,
+void xchk_block_set_preen(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
-void xchk_ino_set_preen(struct xfs_scrub_context *sc, xfs_ino_t ino);
+void xchk_ino_set_preen(struct xfs_scrub *sc, xfs_ino_t ino);
 
-void xchk_block_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
-void xchk_ino_set_corrupt(struct xfs_scrub_context *sc, xfs_ino_t ino);
-void xchk_fblock_set_corrupt(struct xfs_scrub_context *sc, int whichfork,
+void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
+void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
 
-void xchk_block_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_block_xref_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
-void xchk_ino_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_ino_xref_set_corrupt(struct xfs_scrub *sc,
 		xfs_ino_t ino);
-void xchk_fblock_xref_set_corrupt(struct xfs_scrub_context *sc,
+void xchk_fblock_xref_set_corrupt(struct xfs_scrub *sc,
 		int whichfork, xfs_fileoff_t offset);
 
-void xchk_ino_set_warning(struct xfs_scrub_context *sc, xfs_ino_t ino);
-void xchk_fblock_set_warning(struct xfs_scrub_context *sc, int whichfork,
+void xchk_ino_set_warning(struct xfs_scrub *sc, xfs_ino_t ino);
+void xchk_fblock_set_warning(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
 
-void xchk_set_incomplete(struct xfs_scrub_context *sc);
+void xchk_set_incomplete(struct xfs_scrub *sc);
 int xchk_checkpoint_log(struct xfs_mount *mp);
 
 /* Are we set up for a cross-referencing check? */
-bool xchk_should_check_xref(struct xfs_scrub_context *sc, int *error,
+bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
 /* Setup functions */
-int xchk_setup_fs(struct xfs_scrub_context *sc, struct xfs_inode *ip);
-int xchk_setup_ag_allocbt(struct xfs_scrub_context *sc,
+int xchk_setup_fs(struct xfs_scrub *sc, struct xfs_inode *ip);
+int xchk_setup_ag_allocbt(struct xfs_scrub *sc,
 			       struct xfs_inode *ip);
-int xchk_setup_ag_iallocbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_iallocbt(struct xfs_scrub *sc,
 				struct xfs_inode *ip);
-int xchk_setup_ag_rmapbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_rmapbt(struct xfs_scrub *sc,
 			      struct xfs_inode *ip);
-int xchk_setup_ag_refcountbt(struct xfs_scrub_context *sc,
+int xchk_setup_ag_refcountbt(struct xfs_scrub *sc,
 				  struct xfs_inode *ip);
-int xchk_setup_inode(struct xfs_scrub_context *sc,
+int xchk_setup_inode(struct xfs_scrub *sc,
 			  struct xfs_inode *ip);
-int xchk_setup_inode_bmap(struct xfs_scrub_context *sc,
+int xchk_setup_inode_bmap(struct xfs_scrub *sc,
 			       struct xfs_inode *ip);
-int xchk_setup_inode_bmap_data(struct xfs_scrub_context *sc,
+int xchk_setup_inode_bmap_data(struct xfs_scrub *sc,
 				    struct xfs_inode *ip);
-int xchk_setup_directory(struct xfs_scrub_context *sc,
+int xchk_setup_directory(struct xfs_scrub *sc,
 			      struct xfs_inode *ip);
-int xchk_setup_xattr(struct xfs_scrub_context *sc,
+int xchk_setup_xattr(struct xfs_scrub *sc,
 			  struct xfs_inode *ip);
-int xchk_setup_symlink(struct xfs_scrub_context *sc,
+int xchk_setup_symlink(struct xfs_scrub *sc,
 			    struct xfs_inode *ip);
-int xchk_setup_parent(struct xfs_scrub_context *sc,
+int xchk_setup_parent(struct xfs_scrub *sc,
 			   struct xfs_inode *ip);
 #ifdef CONFIG_XFS_RT
-int xchk_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip);
 #else
 static inline int
-xchk_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+xchk_setup_rt(struct xfs_scrub *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
-int xchk_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+int xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip);
 #else
 static inline int
-xchk_setup_quota(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+xchk_setup_quota(struct xfs_scrub *sc, struct xfs_inode *ip)
 {
 	return -ENOENT;
 }
 #endif
 
-void xchk_ag_free(struct xfs_scrub_context *sc, struct xchk_ag *sa);
-int xchk_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
+int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		      struct xchk_ag *sa);
 void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
-int xchk_ag_read_headers(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 			      struct xfs_buf **agi, struct xfs_buf **agf,
 			      struct xfs_buf **agfl);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
-int xchk_ag_btcur_init(struct xfs_scrub_context *sc,
+int xchk_ag_btcur_init(struct xfs_scrub *sc,
 			    struct xchk_ag *sa);
-int xchk_count_rmap_ownedby_ag(struct xfs_scrub_context *sc,
+int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc,
 				    struct xfs_btree_cur *cur,
 				    struct xfs_owner_info *oinfo,
 				    xfs_filblks_t *blocks);
 
-int xchk_setup_ag_btree(struct xfs_scrub_context *sc,
+int xchk_setup_ag_btree(struct xfs_scrub *sc,
 			     struct xfs_inode *ip, bool force_log);
-int xchk_get_inode(struct xfs_scrub_context *sc, struct xfs_inode *ip_in);
-int xchk_setup_inode_contents(struct xfs_scrub_context *sc,
+int xchk_get_inode(struct xfs_scrub *sc, struct xfs_inode *ip_in);
+int xchk_setup_inode_contents(struct xfs_scrub *sc,
 				   struct xfs_inode *ip, unsigned int resblks);
-void xchk_buffer_recheck(struct xfs_scrub_context *sc, struct xfs_buf *bp);
+void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
 /*
  * Don't bother cross-referencing if we already found corruption or cross
@@ -138,7 +138,7 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
-int xchk_metadata_inode_forks(struct xfs_scrub_context *sc);
+int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index fee80f6ddfd7..7fc12d540ea6 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -40,7 +40,7 @@ xchk_da_process_error(
 	int				level,
 	int				*error)
 {
-	struct xfs_scrub_context	*sc = ds->sc;
+	struct xfs_scrub	*sc = ds->sc;
 
 	if (*error == 0)
 		return true;
@@ -75,7 +75,7 @@ xchk_da_set_corrupt(
 	struct xchk_da_btree		*ds,
 	int				level)
 {
-	struct xfs_scrub_context	*sc = ds->sc;
+	struct xfs_scrub	*sc = ds->sc;
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
@@ -474,7 +474,7 @@ xchk_da_btree_block(
 /* Visit all nodes and leaves of a da btree. */
 int
 xchk_da_btree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				whichfork,
 	xchk_da_btree_rec_fn	scrub_fn,
 	void				*private)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 80e4af0e2589..a15c03389e8f 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -13,7 +13,7 @@ struct xchk_da_btree {
 	xfs_dahash_t			hashes[XFS_DA_NODE_MAXDEPTH];
 	int				maxrecs[XFS_DA_NODE_MAXDEPTH];
 	struct xfs_da_state		*state;
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	void				*private;
 
 	/*
@@ -39,7 +39,7 @@ void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level,
 			    __be32 *hashp);
-int xchk_da_btree(struct xfs_scrub_context *sc, int whichfork,
+int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		       xchk_da_btree_rec_fn scrub_fn, void *private);
 
 #endif /* __XFS_SCRUB_DABTREE_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2ac07bb73478..194a3ef69a9f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -32,7 +32,7 @@
 /* Set us up to scrub directories. */
 int
 xchk_setup_directory(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_inode_contents(sc, ip, 0);
@@ -46,7 +46,7 @@ struct xchk_dir_ctx {
 	/* VFS fill-directory iterator */
 	struct dir_context		dir_iter;
 
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 };
 
 /* Check that an inode's mode matches a given DT_ type. */
@@ -289,7 +289,7 @@ xchk_dir_rec(
  */
 STATIC void
 xchk_directory_check_free_entry(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_dablk_t			lblk,
 	struct xfs_dir2_data_free	*bf,
 	struct xfs_dir2_data_unused	*dup)
@@ -314,7 +314,7 @@ xchk_directory_check_free_entry(
 /* Check free space info in a directory data block. */
 STATIC int
 xchk_directory_data_bestfree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_dablk_t			lblk,
 	bool				is_block)
 {
@@ -455,7 +455,7 @@ xchk_directory_data_bestfree(
  */
 STATIC void
 xchk_directory_check_freesp(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_dablk_t			lblk,
 	struct xfs_buf			*dbp,
 	unsigned int			len)
@@ -474,7 +474,7 @@ xchk_directory_check_freesp(
 /* Check free space info in a directory leaf1 block. */
 STATIC int
 xchk_directory_leaf1_bestfree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_da_args		*args,
 	xfs_dablk_t			lblk)
 {
@@ -572,7 +572,7 @@ xchk_directory_leaf1_bestfree(
 /* Check free space info in a directory freespace block. */
 STATIC int
 xchk_directory_free_bestfree(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_da_args		*args,
 	xfs_dablk_t			lblk)
 {
@@ -626,7 +626,7 @@ xchk_directory_free_bestfree(
 /* Check free space information in directories. */
 STATIC int
 xchk_directory_blocks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_bmbt_irec		got;
 	struct xfs_da_args		args;
@@ -770,7 +770,7 @@ xchk_directory_blocks(
 /* Scrub a whole directory. */
 int
 xchk_directory(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_dir_ctx		sdc = {
 		.dir_iter.actor = xchk_dir_actor,
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 69d652b7299c..6df8eba9f52b 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -36,7 +36,7 @@
  */
 int
 xchk_setup_ag_iallocbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_ag_btree(sc, ip, sc->try_harder);
@@ -51,7 +51,7 @@ xchk_setup_ag_iallocbt(
  */
 static inline void
 xchk_iallocbt_chunk_xref_other(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino)
 {
@@ -76,7 +76,7 @@ xchk_iallocbt_chunk_xref_other(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_iallocbt_chunk_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
 	xfs_agblock_t			agbno,
@@ -363,7 +363,7 @@ xchk_iallocbt_rec(
  */
 STATIC void
 xchk_iallocbt_xref_rmap_btreeblks(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				which)
 {
 	struct xfs_owner_info		oinfo;
@@ -403,7 +403,7 @@ xchk_iallocbt_xref_rmap_btreeblks(
  */
 STATIC void
 xchk_iallocbt_xref_rmap_inodes(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	int				which,
 	xfs_filblks_t			inode_blocks)
 {
@@ -427,7 +427,7 @@ xchk_iallocbt_xref_rmap_inodes(
 /* Scrub the inode btrees for some AG. */
 STATIC int
 xchk_iallocbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_btnum_t			which)
 {
 	struct xfs_btree_cur		*cur;
@@ -459,14 +459,14 @@ xchk_iallocbt(
 
 int
 xchk_inobt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_iallocbt(sc, XFS_BTNUM_INO);
 }
 
 int
 xchk_finobt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	return xchk_iallocbt(sc, XFS_BTNUM_FINO);
 }
@@ -474,7 +474,7 @@ xchk_finobt(
 /* See if an inode btree has (or doesn't have) an inode chunk record. */
 static inline void
 xchk_xref_inode_check(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
 	struct xfs_btree_cur		**icur,
@@ -496,7 +496,7 @@ xchk_xref_inode_check(
 /* xref check that the extent is not covered by inodes */
 void
 xchk_xref_is_not_inode_chunk(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
@@ -507,7 +507,7 @@ xchk_xref_is_not_inode_chunk(
 /* xref check that the extent is covered by inodes */
 void
 xchk_xref_is_inode_chunk(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index d85fbec39e52..6cc027983c13 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -38,7 +38,7 @@
  */
 int
 xchk_setup_inode(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	int				error;
@@ -77,7 +77,7 @@ xchk_setup_inode(
 /* Validate di_extsize hint. */
 STATIC void
 xchk_inode_extsize(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -99,7 +99,7 @@ xchk_inode_extsize(
  */
 STATIC void
 xchk_inode_cowextsize(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -118,7 +118,7 @@ xchk_inode_cowextsize(
 /* Make sure the di_flags make sense for the inode. */
 STATIC void
 xchk_inode_flags(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -163,7 +163,7 @@ xchk_inode_flags(
 /* Make sure the di_flags2 make sense for the inode. */
 STATIC void
 xchk_inode_flags2(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino,
 	uint16_t			mode,
@@ -206,7 +206,7 @@ xchk_inode_flags2(
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xchk_dinode(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip,
 	xfs_ino_t			ino)
 {
@@ -426,7 +426,7 @@ xchk_dinode(
  */
 static void
 xchk_inode_xref_finobt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	struct xfs_inobt_rec_incore	rec;
@@ -469,7 +469,7 @@ xchk_inode_xref_finobt(
 /* Cross reference the inode fields with the forks. */
 STATIC void
 xchk_inode_xref_bmap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_dinode		*dip)
 {
 	xfs_extnum_t			nextents;
@@ -503,7 +503,7 @@ xchk_inode_xref_bmap(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_inode_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino,
 	struct xfs_dinode		*dip)
 {
@@ -540,7 +540,7 @@ xchk_inode_xref(
  */
 static void
 xchk_inode_check_reflink_iflag(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			ino)
 {
 	struct xfs_mount		*mp = sc->mp;
@@ -564,7 +564,7 @@ xchk_inode_check_reflink_iflag(
 /* Scrub an inode. */
 int
 xchk_inode(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_dinode		di;
 	int				error = 0;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 0a78d8411f23..808459ad0c35 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -28,7 +28,7 @@
 /* Set us up to scrub parents. */
 int
 xchk_setup_parent(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_inode_contents(sc, ip, 0);
@@ -65,7 +65,7 @@ xchk_parent_actor(
 /* Count the number of dentries in the parent dir that point to this inode. */
 STATIC int
 xchk_parent_count_parent_dentries(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*parent,
 	xfs_nlink_t			*nlink)
 {
@@ -121,7 +121,7 @@ xchk_parent_count_parent_dentries(
  */
 STATIC int
 xchk_parent_validate(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_ino_t			dnum,
 	bool				*try_again)
 {
@@ -255,7 +255,7 @@ xchk_parent_validate(
 /* Scrub a parent pointer. */
 int
 xchk_parent(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	xfs_ino_t			dnum;
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d1b52dd7efcd..309ebeecfa5d 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -31,7 +31,7 @@
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 static inline uint
 xchk_quota_to_dqtype(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	switch (sc->sm->sm_type) {
 	case XFS_SCRUB_TYPE_UQUOTA:
@@ -48,7 +48,7 @@ xchk_quota_to_dqtype(
 /* Set us up to scrub a quota. */
 int
 xchk_setup_quota(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	uint				dqtype;
@@ -76,7 +76,7 @@ xchk_setup_quota(
 /* Quotas. */
 
 struct xchk_quota_info {
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	xfs_dqid_t			last_id;
 };
 
@@ -88,7 +88,7 @@ xchk_quota_item(
 	void				*priv)
 {
 	struct xchk_quota_info		*sqi = priv;
-	struct xfs_scrub_context	*sc = sqi->sc;
+	struct xfs_scrub	*sc = sqi->sc;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_disk_dquot		*d = &dq->q_core;
 	struct xfs_quotainfo		*qi = mp->m_quotainfo;
@@ -195,7 +195,7 @@ xchk_quota_item(
 /* Check the quota's data fork. */
 STATIC int
 xchk_quota_data_fork(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_bmbt_irec		irec = { 0 };
 	struct xfs_iext_cursor		icur;
@@ -234,7 +234,7 @@ xchk_quota_data_fork(
 /* Scrub all of a quota type's items. */
 int
 xchk_quota(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xchk_quota_info		sqi;
 	struct xfs_mount		*mp = sc->mp;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 274febc49b23..c1162d408987 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -29,7 +29,7 @@
  */
 int
 xchk_setup_ag_refcountbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_ag_btree(sc, ip, false);
@@ -79,7 +79,7 @@ struct xchk_refcnt_frag {
 };
 
 struct xchk_refcnt_check {
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	struct list_head		fragments;
 
 	/* refcount extent we're examining */
@@ -278,7 +278,7 @@ xchk_refcountbt_process_rmap_fragments(
 /* Use the rmap entries covering this extent to verify the refcount. */
 STATIC void
 xchk_refcountbt_xref_rmap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	xfs_nlink_t			refcount)
@@ -325,7 +325,7 @@ xchk_refcountbt_xref_rmap(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_refcountbt_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len,
 	xfs_nlink_t			refcount)
@@ -382,7 +382,7 @@ xchk_refcountbt_rec(
 /* Make sure we have as many refc blocks as the rmap says. */
 STATIC void
 xchk_refcount_xref_rmap(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_owner_info		*oinfo,
 	xfs_filblks_t			cow_blocks)
 {
@@ -417,7 +417,7 @@ xchk_refcount_xref_rmap(
 /* Scrub the refcount btree for some AG. */
 int
 xchk_refcountbt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			cow_blocks = 0;
@@ -437,7 +437,7 @@ xchk_refcountbt(
 /* xref check that a cow staging extent is marked in the refcountbt. */
 void
 xchk_xref_is_cow_staging(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
@@ -483,7 +483,7 @@ xchk_xref_is_cow_staging(
  */
 void
 xchk_xref_is_not_shared(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno,
 	xfs_extlen_t			len)
 {
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7e6a56a5f59d..29debd5649ac 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -43,7 +43,7 @@
 int
 xrep_attempt(
 	struct xfs_inode		*ip,
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	bool				*fixed)
 {
 	int				error = 0;
@@ -106,7 +106,7 @@ xrep_failure(
  */
 int
 xrep_probe(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	int				error = 0;
 
@@ -122,7 +122,7 @@ xrep_probe(
  */
 int
 xrep_roll_ag_trans(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	int				error;
 
@@ -179,7 +179,7 @@ xrep_ag_has_space(
  */
 xfs_extlen_t
 xrep_calc_ag_resblks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_scrub_metadata	*sm = sc->sm;
@@ -279,7 +279,7 @@ xrep_calc_ag_resblks(
 /* Allocate a block in an AG. */
 int
 xrep_alloc_ag_block(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_owner_info		*oinfo,
 	xfs_fsblock_t			*fsbno,
 	enum xfs_ag_resv_type		resv)
@@ -330,7 +330,7 @@ xrep_alloc_ag_block(
 /* Initialize a new AG btree root block with zero entries. */
 int
 xrep_init_btblock(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_fsblock_t			fsb,
 	struct xfs_buf			**bpp,
 	xfs_btnum_t			btnum,
@@ -385,7 +385,7 @@ xrep_init_btblock(
 /* Collect a dead btree extent for later disposal. */
 int
 xrep_collect_btree_extent(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xrep_extent_list		*exlist,
 	xfs_fsblock_t			fsbno,
 	xfs_extlen_t			len)
@@ -415,7 +415,7 @@ xrep_collect_btree_extent(
  */
 void
 xrep_cancel_btree_extents(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xrep_extent_list		*exlist)
 {
 	struct xrep_extent		*rex;
@@ -463,7 +463,7 @@ xrep_btree_extent_cmp(
 #define RIGHT_ALIGNED	(1 << 1)
 int
 xrep_subtract_extents(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xrep_extent_list		*exlist,
 	struct xrep_extent_list		*sublist)
 {
@@ -620,7 +620,7 @@ xrep_subtract_extents(
  */
 int
 xrep_invalidate_blocks(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xrep_extent_list		*exlist)
 {
 	struct xrep_extent		*rex;
@@ -658,7 +658,7 @@ xrep_invalidate_blocks(
 /* Ensure the freelist is the correct size. */
 int
 xrep_fix_freelist(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	bool				can_shrink)
 {
 	struct xfs_alloc_arg		args = {0};
@@ -678,7 +678,7 @@ xrep_fix_freelist(
  */
 STATIC int
 xrep_put_freelist(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			agbno)
 {
 	struct xfs_owner_info		oinfo;
@@ -714,7 +714,7 @@ xrep_put_freelist(
 /* Dispose of a single metadata block. */
 STATIC int
 xrep_dispose_btree_block(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_fsblock_t			fsbno,
 	struct xfs_owner_info		*oinfo,
 	enum xfs_ag_resv_type		resv)
@@ -788,7 +788,7 @@ xrep_dispose_btree_block(
 /* Dispose of btree blocks from an old per-AG btree. */
 int
 xrep_reap_btree_extents(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xrep_extent_list		*exlist,
 	struct xfs_owner_info		*oinfo,
 	enum xfs_ag_resv_type		type)
@@ -851,7 +851,7 @@ xrep_reap_btree_extents(
  */
 
 struct xrep_findroot {
-	struct xfs_scrub_context	*sc;
+	struct xfs_scrub	*sc;
 	struct xfs_buf			*agfl_bp;
 	struct xfs_agf			*agf;
 	struct xrep_find_ag_btree	*btree_info;
@@ -981,7 +981,7 @@ xrep_findroot_rmap(
 /* Find the roots of the per-AG btrees described in btree_info. */
 int
 xrep_find_ag_btree_roots(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_buf			*agf_bp,
 	struct xrep_find_ag_btree	*btree_info,
 	struct xfs_buf			*agfl_bp)
@@ -1016,7 +1016,7 @@ xrep_find_ag_btree_roots(
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	uint				dqtype)
 {
 	uint				flag;
@@ -1044,7 +1044,7 @@ xrep_force_quotacheck(
  */
 int
 xrep_ino_dqattach(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	int				error;
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 60d81294797b..677f4b73b5ec 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_SCRUB_REPAIR_H__
 #define __XFS_SCRUB_REPAIR_H__
 
-static inline int xrep_notsupported(struct xfs_scrub_context *sc)
+static inline int xrep_notsupported(struct xfs_scrub *sc)
 {
 	return -EOPNOTSUPP;
 }
@@ -15,17 +15,17 @@ static inline int xrep_notsupported(struct xfs_scrub_context *sc)
 
 /* Repair helpers */
 
-int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub_context *sc,
+int xrep_attempt(struct xfs_inode *ip, struct xfs_scrub *sc,
 		bool *fixed);
 void xrep_failure(struct xfs_mount *mp);
-int xrep_roll_ag_trans(struct xfs_scrub_context *sc);
+int xrep_roll_ag_trans(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
-xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub_context *sc);
-int xrep_alloc_ag_block(struct xfs_scrub_context *sc,
+xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
+int xrep_alloc_ag_block(struct xfs_scrub *sc,
 		struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
 		enum xfs_ag_resv_type resv);
-int xrep_init_btblock(struct xfs_scrub_context *sc, xfs_fsblock_t fsb,
+int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
 
@@ -48,18 +48,18 @@ xrep_init_extent_list(
 
 #define for_each_xrep_extent_safe(rbe, n, exlist) \
 	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
-int xrep_collect_btree_extent(struct xfs_scrub_context *sc,
+int xrep_collect_btree_extent(struct xfs_scrub *sc,
 		struct xrep_extent_list *btlist, xfs_fsblock_t fsbno,
 		xfs_extlen_t len);
-void xrep_cancel_btree_extents(struct xfs_scrub_context *sc,
+void xrep_cancel_btree_extents(struct xfs_scrub *sc,
 		struct xrep_extent_list *btlist);
-int xrep_subtract_extents(struct xfs_scrub_context *sc,
+int xrep_subtract_extents(struct xfs_scrub *sc,
 		struct xrep_extent_list *exlist,
 		struct xrep_extent_list *sublist);
-int xrep_fix_freelist(struct xfs_scrub_context *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub_context *sc,
+int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
+int xrep_invalidate_blocks(struct xfs_scrub *sc,
 		struct xrep_extent_list *btlist);
-int xrep_reap_btree_extents(struct xfs_scrub_context *sc,
+int xrep_reap_btree_extents(struct xfs_scrub *sc,
 		struct xrep_extent_list *exlist,
 		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
@@ -78,23 +78,23 @@ struct xrep_find_ag_btree {
 	unsigned int			height;
 };
 
-int xrep_find_ag_btree_roots(struct xfs_scrub_context *sc,
+int xrep_find_ag_btree_roots(struct xfs_scrub *sc,
 		struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info,
 		struct xfs_buf *agfl_bp);
-void xrep_force_quotacheck(struct xfs_scrub_context *sc, uint dqtype);
-int xrep_ino_dqattach(struct xfs_scrub_context *sc);
+void xrep_force_quotacheck(struct xfs_scrub *sc, uint dqtype);
+int xrep_ino_dqattach(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
-int xrep_probe(struct xfs_scrub_context *sc);
-int xrep_superblock(struct xfs_scrub_context *sc);
+int xrep_probe(struct xfs_scrub *sc);
+int xrep_superblock(struct xfs_scrub *sc);
 
 #else
 
 static inline int xrep_attempt(
 	struct xfs_inode		*ip,
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	bool				*fixed)
 {
 	return -EOPNOTSUPP;
@@ -104,7 +104,7 @@ static inline void xrep_failure(struct xfs_mount *mp) {}
 
 static inline xfs_extlen_t
 xrep_calc_ag_resblks(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	ASSERT(!(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR));
 	return 0;
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 4b75fc2f31f3..dc9c91a706ff 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -30,7 +30,7 @@
  */
 int
 xchk_setup_ag_rmapbt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	return xchk_setup_ag_btree(sc, ip, false);
@@ -41,7 +41,7 @@ xchk_setup_ag_rmapbt(
 /* Cross-reference a rmap against the refcount btree. */
 STATIC void
 xchk_rmapbt_xref_refc(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_rmap_irec		*irec)
 {
 	xfs_agblock_t			fbno;
@@ -72,7 +72,7 @@ xchk_rmapbt_xref_refc(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_rmapbt_xref(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_rmap_irec		*irec)
 {
 	xfs_agblock_t			agbno = irec->rm_startblock;
@@ -172,7 +172,7 @@ xchk_rmapbt_rec(
 /* Scrub the rmap btree for some AG. */
 int
 xchk_rmapbt(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_owner_info		oinfo;
 
@@ -184,7 +184,7 @@ xchk_rmapbt(
 /* xref check that the extent is owned by a given owner */
 static inline void
 xchk_xref_check_owner(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	struct xfs_owner_info		*oinfo,
@@ -207,7 +207,7 @@ xchk_xref_check_owner(
 /* xref check that the extent is owned by a given owner */
 void
 xchk_xref_is_owned_by(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	struct xfs_owner_info		*oinfo)
@@ -218,7 +218,7 @@ xchk_xref_is_owned_by(
 /* xref check that the extent is not owned by a given owner */
 void
 xchk_xref_is_not_owned_by(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	struct xfs_owner_info		*oinfo)
@@ -229,7 +229,7 @@ xchk_xref_is_not_owned_by(
 /* xref check that the extent has no reverse mapping at all */
 void
 xchk_xref_has_no_owner(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len)
 {
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 3f0fc83562ae..653a809bba34 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -26,7 +26,7 @@
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rt(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	int				error;
@@ -51,7 +51,7 @@ xchk_rtbitmap_rec(
 	struct xfs_rtalloc_rec		*rec,
 	void				*priv)
 {
-	struct xfs_scrub_context	*sc = priv;
+	struct xfs_scrub	*sc = priv;
 	xfs_rtblock_t			startblock;
 	xfs_rtblock_t			blockcount;
 
@@ -68,7 +68,7 @@ xchk_rtbitmap_rec(
 /* Scrub the realtime bitmap. */
 int
 xchk_rtbitmap(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	int				error;
 
@@ -88,7 +88,7 @@ xchk_rtbitmap(
 /* Scrub the realtime summary. */
 int
 xchk_rtsummary(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_inode		*rsumip = sc->mp->m_rsumip;
 	struct xfs_inode		*old_ip = sc->ip;
@@ -125,7 +125,7 @@ xchk_rtsummary(
 /* xref check that the extent is not free in the rtbitmap */
 void
 xchk_xref_is_used_rt_space(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	xfs_rtblock_t			fsbno,
 	xfs_extlen_t			len)
 {
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a6efede6e430..b3c6420ccae5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -151,7 +151,7 @@
  */
 static int
 xchk_probe(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	int				error = 0;
 
@@ -166,7 +166,7 @@ xchk_probe(
 /* Free all the resources and finish the transactions. */
 STATIC int
 xchk_teardown(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip_in,
 	int				error)
 {
@@ -447,7 +447,7 @@ xchk_validate_inputs(
 }
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
-static inline void xchk_postmortem(struct xfs_scrub_context *sc)
+static inline void xchk_postmortem(struct xfs_scrub *sc)
 {
 	/*
 	 * Userspace asked us to repair something, we repaired it, rescanned
@@ -460,7 +460,7 @@ static inline void xchk_postmortem(struct xfs_scrub_context *sc)
 		xrep_failure(sc->mp);
 }
 #else
-static inline void xchk_postmortem(struct xfs_scrub_context *sc)
+static inline void xchk_postmortem(struct xfs_scrub *sc)
 {
 	/*
 	 * Userspace asked us to scrub something, it's broken, and we have no
@@ -479,7 +479,7 @@ xfs_scrub_metadata(
 	struct xfs_inode		*ip,
 	struct xfs_scrub_metadata	*sm)
 {
-	struct xfs_scrub_context	sc;
+	struct xfs_scrub	sc;
 	struct xfs_mount		*mp = ip->i_mount;
 	bool				try_harder = false;
 	bool				already_fixed = false;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 0f59a47c4bb0..47c75d2f28da 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_SCRUB_SCRUB_H__
 #define __XFS_SCRUB_SCRUB_H__
 
-struct xfs_scrub_context;
+struct xfs_scrub;
 
 /* Type info and names for the scrub types. */
 enum xchk_type {
@@ -18,14 +18,14 @@ enum xchk_type {
 
 struct xchk_meta_ops {
 	/* Acquire whatever resources are needed for the operation. */
-	int		(*setup)(struct xfs_scrub_context *,
+	int		(*setup)(struct xfs_scrub *,
 				 struct xfs_inode *);
 
 	/* Examine metadata for errors. */
-	int		(*scrub)(struct xfs_scrub_context *);
+	int		(*scrub)(struct xfs_scrub *);
 
 	/* Repair or optimize the metadata. */
-	int		(*repair)(struct xfs_scrub_context *);
+	int		(*repair)(struct xfs_scrub *);
 
 	/* Decide if we even have this piece of metadata. */
 	bool		(*has)(struct xfs_sb *);
@@ -53,7 +53,7 @@ struct xchk_ag {
 	struct xfs_btree_cur		*refc_cur;
 };
 
-struct xfs_scrub_context {
+struct xfs_scrub {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
 	struct xfs_scrub_metadata	*sm;
@@ -70,71 +70,71 @@ struct xfs_scrub_context {
 };
 
 /* Metadata scrubbers */
-int xchk_tester(struct xfs_scrub_context *sc);
-int xchk_superblock(struct xfs_scrub_context *sc);
-int xchk_agf(struct xfs_scrub_context *sc);
-int xchk_agfl(struct xfs_scrub_context *sc);
-int xchk_agi(struct xfs_scrub_context *sc);
-int xchk_bnobt(struct xfs_scrub_context *sc);
-int xchk_cntbt(struct xfs_scrub_context *sc);
-int xchk_inobt(struct xfs_scrub_context *sc);
-int xchk_finobt(struct xfs_scrub_context *sc);
-int xchk_rmapbt(struct xfs_scrub_context *sc);
-int xchk_refcountbt(struct xfs_scrub_context *sc);
-int xchk_inode(struct xfs_scrub_context *sc);
-int xchk_bmap_data(struct xfs_scrub_context *sc);
-int xchk_bmap_attr(struct xfs_scrub_context *sc);
-int xchk_bmap_cow(struct xfs_scrub_context *sc);
-int xchk_directory(struct xfs_scrub_context *sc);
-int xchk_xattr(struct xfs_scrub_context *sc);
-int xchk_symlink(struct xfs_scrub_context *sc);
-int xchk_parent(struct xfs_scrub_context *sc);
+int xchk_tester(struct xfs_scrub *sc);
+int xchk_superblock(struct xfs_scrub *sc);
+int xchk_agf(struct xfs_scrub *sc);
+int xchk_agfl(struct xfs_scrub *sc);
+int xchk_agi(struct xfs_scrub *sc);
+int xchk_bnobt(struct xfs_scrub *sc);
+int xchk_cntbt(struct xfs_scrub *sc);
+int xchk_inobt(struct xfs_scrub *sc);
+int xchk_finobt(struct xfs_scrub *sc);
+int xchk_rmapbt(struct xfs_scrub *sc);
+int xchk_refcountbt(struct xfs_scrub *sc);
+int xchk_inode(struct xfs_scrub *sc);
+int xchk_bmap_data(struct xfs_scrub *sc);
+int xchk_bmap_attr(struct xfs_scrub *sc);
+int xchk_bmap_cow(struct xfs_scrub *sc);
+int xchk_directory(struct xfs_scrub *sc);
+int xchk_xattr(struct xfs_scrub *sc);
+int xchk_symlink(struct xfs_scrub *sc);
+int xchk_parent(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
-int xchk_rtbitmap(struct xfs_scrub_context *sc);
-int xchk_rtsummary(struct xfs_scrub_context *sc);
+int xchk_rtbitmap(struct xfs_scrub *sc);
+int xchk_rtsummary(struct xfs_scrub *sc);
 #else
 static inline int
-xchk_rtbitmap(struct xfs_scrub_context *sc)
+xchk_rtbitmap(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
 static inline int
-xchk_rtsummary(struct xfs_scrub_context *sc)
+xchk_rtsummary(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
 #endif
 #ifdef CONFIG_XFS_QUOTA
-int xchk_quota(struct xfs_scrub_context *sc);
+int xchk_quota(struct xfs_scrub *sc);
 #else
 static inline int
-xchk_quota(struct xfs_scrub_context *sc)
+xchk_quota(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
 #endif
 
 /* cross-referencing helpers */
-void xchk_xref_is_used_space(struct xfs_scrub_context *sc,
+void xchk_xref_is_used_space(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xchk_xref_is_not_inode_chunk(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xchk_xref_is_inode_chunk(struct xfs_scrub_context *sc,
+void xchk_xref_is_inode_chunk(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xchk_xref_is_owned_by(struct xfs_scrub_context *sc,
+void xchk_xref_is_owned_by(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len,
 		struct xfs_owner_info *oinfo);
-void xchk_xref_is_not_owned_by(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_owned_by(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len,
 		struct xfs_owner_info *oinfo);
-void xchk_xref_has_no_owner(struct xfs_scrub_context *sc,
+void xchk_xref_has_no_owner(struct xfs_scrub *sc,
 		xfs_agblock_t agbno, xfs_extlen_t len);
-void xchk_xref_is_cow_staging(struct xfs_scrub_context *sc,
+void xchk_xref_is_cow_staging(struct xfs_scrub *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
-void xchk_xref_is_not_shared(struct xfs_scrub_context *sc,
+void xchk_xref_is_not_shared(struct xfs_scrub *sc,
 		xfs_agblock_t bno, xfs_extlen_t len);
 #ifdef CONFIG_XFS_RT
-void xchk_xref_is_used_rt_space(struct xfs_scrub_context *sc,
+void xchk_xref_is_used_rt_space(struct xfs_scrub *sc,
 		xfs_rtblock_t rtbno, xfs_extlen_t len);
 #else
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index e2a288e34337..56c6347e9482 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -26,7 +26,7 @@
 /* Set us up to scrub a symbolic link. */
 int
 xchk_setup_symlink(
-	struct xfs_scrub_context	*sc,
+	struct xfs_scrub	*sc,
 	struct xfs_inode		*ip)
 {
 	/* Allocate the buffer without the inode lock held. */
@@ -41,7 +41,7 @@ xchk_setup_symlink(
 
 int
 xchk_symlink(
-	struct xfs_scrub_context	*sc)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_inode		*ip = sc->ip;
 	struct xfs_ifork		*ifp;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 96f3edda3e91..93db22c39b51 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -59,7 +59,7 @@ DEFINE_SCRUB_EVENT(xrep_attempt);
 DEFINE_SCRUB_EVENT(xrep_done);
 
 TRACE_EVENT(xchk_op_error,
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+	TP_PROTO(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		 xfs_agblock_t bno, int error, void *ret_ip),
 	TP_ARGS(sc, agno, bno, error, ret_ip),
 	TP_STRUCT__entry(
@@ -88,7 +88,7 @@ TRACE_EVENT(xchk_op_error,
 );
 
 TRACE_EVENT(xchk_file_op_error,
-	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
+	TP_PROTO(struct xfs_scrub *sc, int whichfork,
 		 xfs_fileoff_t offset, int error, void *ret_ip),
 	TP_ARGS(sc, whichfork, offset, error, ret_ip),
 	TP_STRUCT__entry(
@@ -120,7 +120,7 @@ TRACE_EVENT(xchk_file_op_error,
 );
 
 DECLARE_EVENT_CLASS(xchk_block_error_class,
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, void *ret_ip),
+	TP_PROTO(struct xfs_scrub *sc, xfs_daddr_t daddr, void *ret_ip),
 	TP_ARGS(sc, daddr, ret_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -154,7 +154,7 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
 
 #define DEFINE_SCRUB_BLOCK_ERROR_EVENT(name) \
 DEFINE_EVENT(xchk_block_error_class, name, \
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_daddr_t daddr, \
+	TP_PROTO(struct xfs_scrub *sc, xfs_daddr_t daddr, \
 		 void *ret_ip), \
 	TP_ARGS(sc, daddr, ret_ip))
 
@@ -162,7 +162,7 @@ DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_error);
 DEFINE_SCRUB_BLOCK_ERROR_EVENT(xchk_block_preen);
 
 DECLARE_EVENT_CLASS(xchk_ino_error_class,
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, void *ret_ip),
+	TP_PROTO(struct xfs_scrub *sc, xfs_ino_t ino, void *ret_ip),
 	TP_ARGS(sc, ino, ret_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -185,7 +185,7 @@ DECLARE_EVENT_CLASS(xchk_ino_error_class,
 
 #define DEFINE_SCRUB_INO_ERROR_EVENT(name) \
 DEFINE_EVENT(xchk_ino_error_class, name, \
-	TP_PROTO(struct xfs_scrub_context *sc, xfs_ino_t ino, \
+	TP_PROTO(struct xfs_scrub *sc, xfs_ino_t ino, \
 		 void *ret_ip), \
 	TP_ARGS(sc, ino, ret_ip))
 
@@ -194,7 +194,7 @@ DEFINE_SCRUB_INO_ERROR_EVENT(xchk_ino_preen);
 DEFINE_SCRUB_INO_ERROR_EVENT(xchk_ino_warning);
 
 DECLARE_EVENT_CLASS(xchk_fblock_error_class,
-	TP_PROTO(struct xfs_scrub_context *sc, int whichfork,
+	TP_PROTO(struct xfs_scrub *sc, int whichfork,
 		 xfs_fileoff_t offset, void *ret_ip),
 	TP_ARGS(sc, whichfork, offset, ret_ip),
 	TP_STRUCT__entry(
@@ -224,7 +224,7 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 
 #define DEFINE_SCRUB_FBLOCK_ERROR_EVENT(name) \
 DEFINE_EVENT(xchk_fblock_error_class, name, \
-	TP_PROTO(struct xfs_scrub_context *sc, int whichfork, \
+	TP_PROTO(struct xfs_scrub *sc, int whichfork, \
 		 xfs_fileoff_t offset, void *ret_ip), \
 	TP_ARGS(sc, whichfork, offset, ret_ip))
 
@@ -232,7 +232,7 @@ DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
 
 TRACE_EVENT(xchk_incomplete,
-	TP_PROTO(struct xfs_scrub_context *sc, void *ret_ip),
+	TP_PROTO(struct xfs_scrub *sc, void *ret_ip),
 	TP_ARGS(sc, ret_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -251,7 +251,7 @@ TRACE_EVENT(xchk_incomplete,
 );
 
 TRACE_EVENT(xchk_btree_op_error,
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		 int level, int error, void *ret_ip),
 	TP_ARGS(sc, cur, level, error, ret_ip),
 	TP_STRUCT__entry(
@@ -291,7 +291,7 @@ TRACE_EVENT(xchk_btree_op_error,
 );
 
 TRACE_EVENT(xchk_ifork_btree_op_error,
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		 int level, int error, void *ret_ip),
 	TP_ARGS(sc, cur, level, error, ret_ip),
 	TP_STRUCT__entry(
@@ -336,7 +336,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 );
 
 TRACE_EVENT(xchk_btree_error,
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		 int level, void *ret_ip),
 	TP_ARGS(sc, cur, level, ret_ip),
 	TP_STRUCT__entry(
@@ -372,7 +372,7 @@ TRACE_EVENT(xchk_btree_error,
 );
 
 TRACE_EVENT(xchk_ifork_btree_error,
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		 int level, void *ret_ip),
 	TP_ARGS(sc, cur, level, ret_ip),
 	TP_STRUCT__entry(
@@ -414,7 +414,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 );
 
 DECLARE_EVENT_CLASS(xchk_sbtree_class,
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		 int level),
 	TP_ARGS(sc, cur, level),
 	TP_STRUCT__entry(
@@ -451,7 +451,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 )
 #define DEFINE_SCRUB_SBTREE_EVENT(name) \
 DEFINE_EVENT(xchk_sbtree_class, name, \
-	TP_PROTO(struct xfs_scrub_context *sc, struct xfs_btree_cur *cur, \
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_btree_cur *cur, \
 		 int level), \
 	TP_ARGS(sc, cur, level))
 
@@ -459,7 +459,7 @@ DEFINE_SCRUB_SBTREE_EVENT(xchk_btree_rec);
 DEFINE_SCRUB_SBTREE_EVENT(xchk_btree_key);
 
 TRACE_EVENT(xchk_xref_error,
-	TP_PROTO(struct xfs_scrub_context *sc, int error, void *ret_ip),
+	TP_PROTO(struct xfs_scrub *sc, int error, void *ret_ip),
 	TP_ARGS(sc, error, ret_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)

