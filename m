Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeKII6C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 03:58:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wA8NJ3OF108546
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:10 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nh33ucawq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Nov 2018 23:20:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NK8GL015524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:09 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wA8NK8qP014954
        for <linux-xfs@vger.kernel.org>; Thu, 8 Nov 2018 23:20:08 GMT
Subject: [PATCH 1/5] xfs: const-ify xfs_owner_info arguments
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 08 Nov 2018 15:20:07 -0800
Message-ID: <154171920773.30818.10284610883734405907.stgit@magnolia>
In-Reply-To: <154171920164.30818.2178553842722589349.stgit@magnolia>
References: <154171920164.30818.2178553842722589349.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Only certain functions actually change the contents of an
xfs_owner_info; the rest can accept a const struct pointer.  This will
enable us to save stack space by hoisting static owner info types to
be const global variables.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    4 -
 fs/xfs/libxfs/xfs_alloc.h  |    4 -
 fs/xfs/libxfs/xfs_bmap.c   |    2 
 fs/xfs/libxfs/xfs_bmap.h   |    4 -
 fs/xfs/libxfs/xfs_rmap.c   |  212 ++++++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_rmap.h   |   12 +-
 fs/xfs/scrub/btree.c       |   45 +++++----
 fs/xfs/scrub/btree.h       |   22 ++---
 fs/xfs/scrub/common.c      |   14 +--
 fs/xfs/scrub/common.h      |    2 
 fs/xfs/scrub/refcount.c    |   11 +-
 fs/xfs/scrub/repair.c      |   50 +++++-----
 fs/xfs/scrub/repair.h      |    7 +
 fs/xfs/scrub/rmap.c        |   30 +++---
 fs/xfs/scrub/scrub.h       |    4 -
 fs/xfs/xfs_trace.h         |    4 -
 fs/xfs/xfs_trans.h         |    3 -
 fs/xfs/xfs_trans_extfree.c |    2 
 18 files changed, 218 insertions(+), 214 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e1c0c0d2f1b0..bce46fa0ee38 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1699,7 +1699,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type	type)
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -3013,7 +3013,7 @@ __xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
-	struct xfs_owner_info	*oinfo,	/* extent owner */
+	const struct xfs_owner_info	*oinfo,	/* extent owner */
 	enum xfs_ag_resv_type	type,	/* block reservation type */
 	bool			skip_discard)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 00cd5ec4cb6b..d6ed5d2c07c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -182,7 +182,7 @@ __xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
-	struct xfs_owner_info	*oinfo,	/* extent owner */
+	const struct xfs_owner_info	*oinfo,	/* extent owner */
 	enum xfs_ag_resv_type	type,	/* block reservation type */
 	bool			skip_discard);
 
@@ -191,7 +191,7 @@ xfs_free_extent(
 	struct xfs_trans	*tp,
 	xfs_fsblock_t		bno,
 	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type	type)
 {
 	return __xfs_free_extent(tp, bno, len, oinfo, type, false);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 74d7228e755b..60abaa2e8146 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -536,7 +536,7 @@ __xfs_bmap_add_free(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
-	struct xfs_owner_info		*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	bool				skip_discard)
 {
 	struct xfs_extent_free_item	*new;		/* new element */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 488dc8860fd7..09d3ea97cc15 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -186,7 +186,7 @@ int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
-		xfs_filblks_t len, struct xfs_owner_info *oinfo,
+		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool skip_discard);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
@@ -234,7 +234,7 @@ xfs_bmap_add_free(
 	struct xfs_trans		*tp,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
-	struct xfs_owner_info		*oinfo)
+	const struct xfs_owner_info	*oinfo)
 {
 	__xfs_bmap_add_free(tp, bno, len, oinfo, false);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 245af452840e..e7d06295338d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -458,21 +458,21 @@ xfs_rmap_free_check_owner(
  */
 STATIC int
 xfs_rmap_unmap(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	ltrec;
-	uint64_t		ltoff;
-	int			error = 0;
-	int			i;
-	uint64_t		owner;
-	uint64_t		offset;
-	unsigned int		flags;
-	bool			ignore_off;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		ltrec;
+	uint64_t			ltoff;
+	int				error = 0;
+	int				i;
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags;
+	bool				ignore_off;
 
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	ignore_off = XFS_RMAP_NON_INODE_OWNER(owner) ||
@@ -653,16 +653,16 @@ xfs_rmap_unmap(
  */
 int
 xfs_rmap_free(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_btree_cur	*cur;
-	int			error;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*cur;
+	int				error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -710,23 +710,23 @@ xfs_rmap_is_mergeable(
  */
 STATIC int
 xfs_rmap_map(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	ltrec;
-	struct xfs_rmap_irec	gtrec;
-	int			have_gt;
-	int			have_lt;
-	int			error = 0;
-	int			i;
-	uint64_t		owner;
-	uint64_t		offset;
-	unsigned int		flags = 0;
-	bool			ignore_off;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		ltrec;
+	struct xfs_rmap_irec		gtrec;
+	int				have_gt;
+	int				have_lt;
+	int				error = 0;
+	int				i;
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags = 0;
+	bool				ignore_off;
 
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	ASSERT(owner != 0);
@@ -890,16 +890,16 @@ xfs_rmap_map(
  */
 int
 xfs_rmap_alloc(
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_btree_cur	*cur;
-	int			error;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*cur;
+	int				error;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
@@ -929,16 +929,16 @@ xfs_rmap_alloc(
  */
 STATIC int
 xfs_rmap_convert(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	r[4];	/* neighbor extent entries */
-					/* left is 0, right is 1, prev is 2 */
-					/* new is 3 */
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		r[4];	/* neighbor extent entries */
+						/* left is 0, right is 1, */
+						/* prev is 2, new is 3 */
 	uint64_t		owner;
 	uint64_t		offset;
 	uint64_t		new_endoff;
@@ -1354,16 +1354,16 @@ xfs_rmap_convert(
  */
 STATIC int
 xfs_rmap_convert_shared(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	r[4];	/* neighbor extent entries */
-					/* left is 0, right is 1, prev is 2 */
-					/* new is 3 */
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		r[4];	/* neighbor extent entries */
+						/* left is 0, right is 1, */
+						/* prev is 2, new is 3 */
 	uint64_t		owner;
 	uint64_t		offset;
 	uint64_t		new_endoff;
@@ -1743,20 +1743,20 @@ xfs_rmap_convert_shared(
  */
 STATIC int
 xfs_rmap_unmap_shared(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	ltrec;
-	uint64_t		ltoff;
-	int			error = 0;
-	int			i;
-	uint64_t		owner;
-	uint64_t		offset;
-	unsigned int		flags;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		ltrec;
+	uint64_t			ltoff;
+	int				error = 0;
+	int				i;
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags;
 
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
@@ -1905,22 +1905,22 @@ xfs_rmap_unmap_shared(
  */
 STATIC int
 xfs_rmap_map_shared(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	bool			unwritten,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_rmap_irec	ltrec;
-	struct xfs_rmap_irec	gtrec;
-	int			have_gt;
-	int			have_lt;
-	int			error = 0;
-	int			i;
-	uint64_t		owner;
-	uint64_t		offset;
-	unsigned int		flags = 0;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_rmap_irec		ltrec;
+	struct xfs_rmap_irec		gtrec;
+	int				have_gt;
+	int				have_lt;
+	int				error = 0;
+	int				i;
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags = 0;
 
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	if (unwritten)
@@ -2459,18 +2459,18 @@ xfs_rmap_has_record(
  */
 int
 xfs_rmap_record_exists(
-	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo,
-	bool			*has_rmap)
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	bool				*has_rmap)
 {
-	uint64_t		owner;
-	uint64_t		offset;
-	unsigned int		flags;
-	int			has_record;
-	struct xfs_rmap_irec	irec;
-	int			error;
+	uint64_t			owner;
+	uint64_t			offset;
+	unsigned int			flags;
+	int				has_record;
+	struct xfs_rmap_irec		irec;
+	int				error;
 
 	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
 	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) ||
@@ -2530,7 +2530,7 @@ xfs_rmap_has_other_keys(
 	struct xfs_btree_cur		*cur,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
-	struct xfs_owner_info		*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	bool				*has_rmap)
 {
 	struct xfs_rmap_irec		low = {0};
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 157dc722ad35..00e38505037f 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -52,7 +52,7 @@ xfs_rmap_skip_owner_update(
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
-	struct xfs_owner_info	*oi)
+	const struct xfs_owner_info	*oi)
 {
 	return oi->oi_owner == XFS_RMAP_OWN_NULL;
 }
@@ -103,7 +103,7 @@ xfs_rmap_irec_offset_unpack(
 
 static inline void
 xfs_owner_info_unpack(
-	struct xfs_owner_info	*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	uint64_t		*owner,
 	uint64_t		*offset,
 	unsigned int		*flags)
@@ -137,10 +137,10 @@ xfs_owner_info_pack(
 
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		   struct xfs_owner_info *oinfo);
+		   const struct xfs_owner_info *oinfo);
 int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		  struct xfs_owner_info *oinfo);
+		  const struct xfs_owner_info *oinfo);
 
 int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, uint64_t owner, uint64_t offset,
@@ -218,10 +218,10 @@ int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
 int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 4ae959f7ad2c..6f94d1f7322d 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -583,31 +583,32 @@ xchk_btree_block_keys(
  */
 int
 xchk_btree(
-	struct xfs_scrub	*sc,
-	struct xfs_btree_cur	*cur,
-	xchk_btree_rec_fn	scrub_fn,
-	struct xfs_owner_info	*oinfo,
-	void			*private)
+	struct xfs_scrub		*sc,
+	struct xfs_btree_cur		*cur,
+	xchk_btree_rec_fn		scrub_fn,
+	const struct xfs_owner_info	*oinfo,
+	void				*private)
 {
-	struct xchk_btree	bs = { NULL };
-	union xfs_btree_ptr	ptr;
-	union xfs_btree_ptr	*pp;
-	union xfs_btree_rec	*recp;
-	struct xfs_btree_block	*block;
-	int			level;
-	struct xfs_buf		*bp;
-	struct check_owner	*co;
-	struct check_owner	*n;
-	int			i;
-	int			error = 0;
+	struct xchk_btree		bs = {
+		.cur			= cur,
+		.scrub_rec		= scrub_fn,
+		.oinfo			= oinfo,
+		.firstrec		= true,
+		.private		= private,
+		.sc			= sc,
+	};
+	union xfs_btree_ptr		ptr;
+	union xfs_btree_ptr		*pp;
+	union xfs_btree_rec		*recp;
+	struct xfs_btree_block		*block;
+	int				level;
+	struct xfs_buf			*bp;
+	struct check_owner		*co;
+	struct check_owner		*n;
+	int				i;
+	int				error = 0;
 
 	/* Initialize scrub state */
-	bs.cur = cur;
-	bs.scrub_rec = scrub_fn;
-	bs.oinfo = oinfo;
-	bs.firstrec = true;
-	bs.private = private;
-	bs.sc = sc;
 	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++)
 		bs.firstkey[i] = true;
 	INIT_LIST_HEAD(&bs.to_check);
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index aada763cd006..5572e475f8ed 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -31,21 +31,21 @@ typedef int (*xchk_btree_rec_fn)(
 
 struct xchk_btree {
 	/* caller-provided scrub state */
-	struct xfs_scrub	*sc;
-	struct xfs_btree_cur	*cur;
-	xchk_btree_rec_fn	scrub_rec;
-	struct xfs_owner_info	*oinfo;
-	void			*private;
+	struct xfs_scrub		*sc;
+	struct xfs_btree_cur		*cur;
+	xchk_btree_rec_fn		scrub_rec;
+	const struct xfs_owner_info	*oinfo;
+	void				*private;
 
 	/* internal scrub state */
-	union xfs_btree_rec	lastrec;
-	bool			firstrec;
-	union xfs_btree_key	lastkey[XFS_BTREE_MAXLEVELS];
-	bool			firstkey[XFS_BTREE_MAXLEVELS];
-	struct list_head	to_check;
+	union xfs_btree_rec		lastrec;
+	bool				firstrec;
+	union xfs_btree_key		lastkey[XFS_BTREE_MAXLEVELS];
+	bool				firstkey[XFS_BTREE_MAXLEVELS];
+	struct list_head		to_check;
 };
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
-		xchk_btree_rec_fn scrub_fn, struct xfs_owner_info *oinfo,
+		xchk_btree_rec_fn scrub_fn, const struct xfs_owner_info *oinfo,
 		void *private);
 
 #endif /* __XFS_SCRUB_BTREE_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 346b02abccf7..0c54ff55b901 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -313,8 +313,8 @@ xchk_set_incomplete(
  */
 
 struct xchk_rmap_ownedby_info {
-	struct xfs_owner_info	*oinfo;
-	xfs_filblks_t		*blocks;
+	const struct xfs_owner_info	*oinfo;
+	xfs_filblks_t			*blocks;
 };
 
 STATIC int
@@ -347,15 +347,15 @@ int
 xchk_count_rmap_ownedby_ag(
 	struct xfs_scrub		*sc,
 	struct xfs_btree_cur		*cur,
-	struct xfs_owner_info		*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	xfs_filblks_t			*blocks)
 {
-	struct xchk_rmap_ownedby_info	sroi;
+	struct xchk_rmap_ownedby_info	sroi = {
+		.oinfo			= oinfo,
+		.blocks			= blocks,
+	};
 
-	sroi.oinfo = oinfo;
 	*blocks = 0;
-	sroi.blocks = blocks;
-
 	return xfs_rmap_query_all(cur, xchk_count_rmap_ownedby_irec,
 			&sroi);
 }
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2d4324d12f9a..e26a430bd466 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -116,7 +116,7 @@ int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 void xchk_ag_btcur_free(struct xchk_ag *sa);
 int xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
-		struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
+		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
 
 int xchk_setup_ag_btree(struct xfs_scrub *sc, struct xfs_inode *ip,
 		bool force_log);
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index e8c82b026083..b7ade620acee 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -383,9 +383,9 @@ xchk_refcountbt_rec(
 STATIC void
 xchk_refcount_xref_rmap(
 	struct xfs_scrub	*sc,
-	struct xfs_owner_info	*oinfo,
 	xfs_filblks_t		cow_blocks)
 {
+	struct xfs_owner_info	oinfo;
 	xfs_extlen_t		refcbt_blocks = 0;
 	xfs_filblks_t		blocks;
 	int			error;
@@ -394,10 +394,11 @@ xchk_refcount_xref_rmap(
 		return;
 
 	/* Check that we saw as many refcbt blocks as the rmap knows about. */
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_REFC);
 	error = xfs_btree_count_blocks(sc->sa.refc_cur, &refcbt_blocks);
 	if (!xchk_btree_process_error(sc, sc->sa.refc_cur, 0, &error))
 		return;
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
 			&blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
@@ -405,8 +406,8 @@ xchk_refcount_xref_rmap(
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 
 	/* Check that we saw as many cow blocks as the rmap knows about. */
-	xfs_rmap_ag_owner(oinfo, XFS_RMAP_OWN_COW);
-	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, oinfo,
+	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_COW);
+	error = xchk_count_rmap_ownedby_ag(sc, sc->sa.rmap_cur, &oinfo,
 			&blocks);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
@@ -429,7 +430,7 @@ xchk_refcountbt(
 	if (error)
 		return error;
 
-	xchk_refcount_xref_rmap(sc, &oinfo, cow_blocks);
+	xchk_refcount_xref_rmap(sc, cow_blocks);
 
 	return 0;
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4fc0a5ea7673..90ae9e173de7 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -299,14 +299,14 @@ xrep_calc_ag_resblks(
 /* Allocate a block in an AG. */
 int
 xrep_alloc_ag_block(
-	struct xfs_scrub	*sc,
-	struct xfs_owner_info	*oinfo,
-	xfs_fsblock_t		*fsbno,
-	enum xfs_ag_resv_type	resv)
+	struct xfs_scrub		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			*fsbno,
+	enum xfs_ag_resv_type		resv)
 {
-	struct xfs_alloc_arg	args = {0};
-	xfs_agblock_t		bno;
-	int			error;
+	struct xfs_alloc_arg		args = {0};
+	xfs_agblock_t			bno;
+	int				error;
 
 	switch (resv) {
 	case XFS_AG_RESV_AGFL:
@@ -538,17 +538,17 @@ xrep_put_freelist(
 /* Dispose of a single block. */
 STATIC int
 xrep_reap_block(
-	struct xfs_scrub	*sc,
-	xfs_fsblock_t		fsbno,
-	struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type	resv)
+	struct xfs_scrub		*sc,
+	xfs_fsblock_t			fsbno,
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		resv)
 {
-	struct xfs_btree_cur	*cur;
-	struct xfs_buf		*agf_bp = NULL;
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
-	bool			has_other_rmap;
-	int			error;
+	struct xfs_btree_cur		*cur;
+	struct xfs_buf			*agf_bp = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	bool				has_other_rmap;
+	int				error;
 
 	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
@@ -612,15 +612,15 @@ xrep_reap_block(
 /* Dispose of every block of every extent in the bitmap. */
 int
 xrep_reap_extents(
-	struct xfs_scrub	*sc,
-	struct xfs_bitmap	*bitmap,
-	struct xfs_owner_info	*oinfo,
-	enum xfs_ag_resv_type	type)
+	struct xfs_scrub		*sc,
+	struct xfs_bitmap		*bitmap,
+	const struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type		type)
 {
-	struct xfs_bitmap_range	*bmr;
-	struct xfs_bitmap_range	*n;
-	xfs_fsblock_t		fsbno;
-	int			error = 0;
+	struct xfs_bitmap_range		*bmr;
+	struct xfs_bitmap_range		*n;
+	xfs_fsblock_t			fsbno;
+	int				error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 9de321eee4ab..f2fc18bb7605 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -21,8 +21,9 @@ int xrep_roll_ag_trans(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
-int xrep_alloc_ag_block(struct xfs_scrub *sc, struct xfs_owner_info *oinfo,
-		xfs_fsblock_t *fsbno, enum xfs_ag_resv_type resv);
+int xrep_alloc_ag_block(struct xfs_scrub *sc,
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t *fsbno,
+		enum xfs_ag_resv_type resv);
 int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
@@ -32,7 +33,7 @@ struct xfs_bitmap;
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
 int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xfs_bitmap *btlist);
 int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
-		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
+		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 struct xrep_find_ag_btree {
 	/* in: rmap owner of the btree we're looking for */
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 5e293c129813..8a5bf15d544d 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -184,14 +184,14 @@ xchk_rmapbt(
 /* xref check that the extent is owned by a given owner */
 static inline void
 xchk_xref_check_owner(
-	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo,
-	bool			should_have_rmap)
+	struct xfs_scrub		*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	bool				should_have_rmap)
 {
-	bool			has_rmap;
-	int			error;
+	bool				has_rmap;
+	int				error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
@@ -207,10 +207,10 @@ xchk_xref_check_owner(
 /* xref check that the extent is owned by a given owner */
 void
 xchk_xref_is_owned_by(
-	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_scrub		*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, true);
 }
@@ -218,10 +218,10 @@ xchk_xref_is_owned_by(
 /* xref check that the extent is not owned by a given owner */
 void
 xchk_xref_is_not_owned_by(
-	struct xfs_scrub	*sc,
-	xfs_agblock_t		bno,
-	xfs_extlen_t		len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_scrub		*sc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo)
 {
 	xchk_xref_check_owner(sc, bno, len, oinfo, false);
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index af323b229c4b..22f754fba8e5 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -122,9 +122,9 @@ void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 void xchk_xref_is_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
 void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo);
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
 void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
-		xfs_extlen_t len, struct xfs_owner_info *oinfo);
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
 void xchk_xref_has_no_owner(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
 void xchk_xref_is_cow_staging(struct xfs_scrub *sc, xfs_agblock_t bno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fe019ea231c1..ca4bd3417e7f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2402,7 +2402,7 @@ DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
-		 struct xfs_owner_info *oinfo),
+		 const struct xfs_owner_info *oinfo),
 	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -2437,7 +2437,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
-		 struct xfs_owner_info *oinfo), \
+		 const struct xfs_owner_info *oinfo), \
 	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
 
 /* simple AG-based error/%ip tracepoint class */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3ba14ebb7a3b..c6e1c5704a8c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -228,7 +228,8 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t, struct xfs_owner_info *,
+				      xfs_extlen_t,
+				      const struct xfs_owner_info *,
 				      bool);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 73b11ed6795e..5210f86a9114 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -57,7 +57,7 @@ xfs_trans_free_extent(
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
 	xfs_extlen_t		ext_len,
-	struct xfs_owner_info	*oinfo,
+	const struct xfs_owner_info	*oinfo,
 	bool			skip_discard)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
