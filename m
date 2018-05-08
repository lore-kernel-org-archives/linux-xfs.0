Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755429AbeEHRWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 13:22:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A636A4E8BF
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73122608F2
        for <linux-xfs@vger.kernel.org>; Tue,  8 May 2018 17:22:32 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Date: Tue,  8 May 2018 13:22:29 -0400
Message-Id: <20180508172231.53570-2-bfoster@redhat.com>
In-Reply-To: <20180508172231.53570-1-bfoster@redhat.com>
References: <20180508172231.53570-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Freed extents are unconditionally discarded when online discard is
enabled. Define XFS_BMAPI_NODISCARD to allow callers to bypass
discards when unnecessary. For example, this will be useful for
eofblocks trimming.

This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 10 +++++++---
 fs/xfs/libxfs/xfs_alloc.h  | 27 +++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c   | 17 +++++++++++++----
 fs/xfs/libxfs/xfs_bmap.h   | 30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_trans.h         |  3 ++-
 fs/xfs/xfs_trans_extfree.c | 13 +++++++++----
 7 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4bcc095fe44a..06e4b0c47c01 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2949,18 +2949,20 @@ xfs_free_extent_fix_freelist(
  * after fixing up the freelist.
  */
 int				/* error */
-xfs_free_extent(
+__xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	struct xfs_owner_info	*oinfo,	/* extent owner */
-	enum xfs_ag_resv_type	type)	/* block reservation type */
+	enum xfs_ag_resv_type	type,	/* block reservation type */
+	bool			skip_discard)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
 	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
 	int			error;
+	unsigned int		busy_flags = 0;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
@@ -2984,7 +2986,9 @@ xfs_free_extent(
 	if (error)
 		goto err;
 
-	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
+	if (skip_discard)
+		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
+	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
 	return 0;
 
 err:
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index cbf789ea5a4e..4a8e8dcaf352 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -191,12 +191,35 @@ xfs_alloc_vextent(
  * Free an extent.
  */
 int				/* error */
-xfs_free_extent(
+__xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
 	struct xfs_owner_info	*oinfo,	/* extent owner */
-	enum xfs_ag_resv_type	type);	/* block reservation type */
+	enum xfs_ag_resv_type	type,	/* block reservation type */
+	bool			skip_discard);
+
+static inline int
+xfs_free_extent(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type	type)
+{
+	return __xfs_free_extent(tp, bno, len, oinfo, type, false);
+}
+
+static inline int
+xfs_free_extent_nodiscard(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo,
+	enum xfs_ag_resv_type	type)
+{
+	return __xfs_free_extent(tp, bno, len, oinfo, type, true);
+}
 
 int				/* error */
 xfs_alloc_lookup_le(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 040eeda8426f..dfec27b10e7a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -542,12 +542,13 @@ xfs_bmap_validate_ret(
  * The list is maintained sorted (by block number).
  */
 void
-xfs_bmap_add_free(
+__xfs_bmap_add_free(
 	struct xfs_mount		*mp,
 	struct xfs_defer_ops		*dfops,
 	xfs_fsblock_t			bno,
 	xfs_filblks_t			len,
-	struct xfs_owner_info		*oinfo)
+	struct xfs_owner_info		*oinfo,
+	bool				skip_discard)
 {
 	struct xfs_extent_free_item	*new;		/* new element */
 #ifdef DEBUG
@@ -574,6 +575,7 @@ xfs_bmap_add_free(
 		new->xefi_oinfo = *oinfo;
 	else
 		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
+	new->xefi_skip_discard = skip_discard;
 	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
 			XFS_FSB_TO_AGBNO(mp, bno), len);
 	xfs_defer_add(dfops, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
@@ -5104,9 +5106,16 @@ xfs_bmap_del_extent_real(
 			error = xfs_refcount_decrease_extent(mp, dfops, del);
 			if (error)
 				goto done;
-		} else
-			xfs_bmap_add_free(mp, dfops, del->br_startblock,
+		} else {
+			if (bflags & XFS_BMAPI_NODISCARD) {
+				xfs_bmap_add_free_nodiscard(mp, dfops,
+					del->br_startblock, del->br_blockcount,
+					NULL);
+			} else {
+				xfs_bmap_add_free(mp, dfops, del->br_startblock,
 					del->br_blockcount, NULL);
+			}
+		}
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 2b766b37096d..d8832e049636 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -68,6 +68,7 @@ struct xfs_extent_free_item
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
 	struct list_head	xefi_list;
 	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
+	bool			xefi_skip_discard;
 };
 
 #define	XFS_BMAP_MAX_NMAP	4
@@ -116,6 +117,9 @@ struct xfs_extent_free_item
 /* Only convert unwritten extents, don't allocate new blocks */
 #define XFS_BMAPI_CONVERT_ONLY	0x800
 
+/* Skip online discard of freed extents */
+#define XFS_BMAPI_NODISCARD	0x1000
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -192,9 +196,9 @@ void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 void	xfs_trim_extent_eof(struct xfs_bmbt_irec *, struct xfs_inode *);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
-void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
+void	__xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 			  xfs_fsblock_t bno, xfs_filblks_t len,
-			  struct xfs_owner_info *oinfo);
+			  struct xfs_owner_info *oinfo, bool skip_discard);
 void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
@@ -240,6 +244,28 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
 		int eof);
 
+static inline void
+xfs_bmap_add_free(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	__xfs_bmap_add_free(mp, dfops, bno, len, oinfo, false);
+}
+
+static inline void
+xfs_bmap_add_free_nodiscard(
+	struct xfs_mount		*mp,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			bno,
+	xfs_filblks_t			len,
+	struct xfs_owner_info		*oinfo)
+{
+	__xfs_bmap_add_free(mp, dfops, bno, len, oinfo, true);
+}
+
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
 	XFS_BMAP_UNMAP,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index b5b1e567b9f4..4735a31793b0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -542,7 +542,7 @@ xfs_efi_recover(
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		extp = &efip->efi_format.efi_extents[i];
 		error = xfs_trans_free_extent(tp, efdp, extp->ext_start,
-					      extp->ext_len, &oinfo);
+					      extp->ext_len, &oinfo, false);
 		if (error)
 			goto abort_error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9d542dfe0052..d5be3f6a3e8f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -228,7 +228,8 @@ struct xfs_efd_log_item	*xfs_trans_get_efd(struct xfs_trans *,
 				  uint);
 int		xfs_trans_free_extent(struct xfs_trans *,
 				      struct xfs_efd_log_item *, xfs_fsblock_t,
-				      xfs_extlen_t, struct xfs_owner_info *);
+				      xfs_extlen_t, struct xfs_owner_info *,
+				      bool);
 int		xfs_trans_commit(struct xfs_trans *);
 int		xfs_trans_roll(struct xfs_trans **);
 int		xfs_trans_roll_inode(struct xfs_trans **, struct xfs_inode *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index ab438647592a..dab8b3b7a9b8 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -68,7 +68,8 @@ xfs_trans_free_extent(
 	struct xfs_efd_log_item	*efdp,
 	xfs_fsblock_t		start_block,
 	xfs_extlen_t		ext_len,
-	struct xfs_owner_info	*oinfo)
+	struct xfs_owner_info	*oinfo,
+	bool			skip_discard)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	uint			next_extent;
@@ -79,8 +80,12 @@ xfs_trans_free_extent(
 
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno, ext_len);
 
-	error = xfs_free_extent(tp, start_block, ext_len, oinfo,
-			XFS_AG_RESV_NONE);
+	if (skip_discard)
+		error = xfs_free_extent_nodiscard(tp, start_block, ext_len,
+						  oinfo, XFS_AG_RESV_NONE);
+	else
+		error = xfs_free_extent(tp, start_block, ext_len, oinfo,
+					XFS_AG_RESV_NONE);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -195,7 +200,7 @@ xfs_extent_free_finish_item(
 	error = xfs_trans_free_extent(tp, done_item,
 			free->xefi_startblock,
 			free->xefi_blockcount,
-			&free->xefi_oinfo);
+			&free->xefi_oinfo, free->xefi_skip_discard);
 	kmem_free(free);
 	return error;
 }
-- 
2.14.3

