Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13BDC7CA6
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DA6058F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KJKxQWyv5Ey3uctG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:54 -0700 (PDT)
Subject: [PATCH 009/119] xfs: convert list of extents to free into a regular
	list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:18:50 -0700
Message-ID: <146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

In struct xfs_bmap_free, convert the open-coded free extent list to
a regular list, then use list_sort to sort it prior to processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   39 +++++++++++----------------------------
 fs/xfs/libxfs/xfs_bmap.h |   14 ++++++++------
 fs/xfs/xfs_bmap_util.c   |   32 +++++++++++++++++++++++++-------
 fs/xfs/xfs_bmap_util.h   |    1 -
 fs/xfs/xfs_super.c       |    5 +++--
 5 files changed, 47 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ea7b3df..a5d207a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -575,9 +575,7 @@ xfs_bmap_add_free(
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len)		/* length of extent */
 {
-	xfs_bmap_free_item_t	*cur;		/* current (next) element */
-	xfs_bmap_free_item_t	*new;		/* new element */
-	xfs_bmap_free_item_t	*prev;		/* previous element */
+	struct xfs_bmap_free_item	*new;		/* new element */
 #ifdef DEBUG
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
@@ -597,17 +595,7 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
-	for (prev = NULL, cur = flist->xbf_first;
-	     cur != NULL;
-	     prev = cur, cur = cur->xbfi_next) {
-		if (cur->xbfi_startblock >= bno)
-			break;
-	}
-	if (prev)
-		prev->xbfi_next = new;
-	else
-		flist->xbf_first = new;
-	new->xbfi_next = cur;
+	list_add(&new->xbfi_list, &flist->xbf_flist);
 	flist->xbf_count++;
 }
 
@@ -617,14 +605,10 @@ xfs_bmap_add_free(
  */
 void
 xfs_bmap_del_free(
-	xfs_bmap_free_t		*flist,	/* free item list header */
-	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
-	xfs_bmap_free_item_t	*free)	/* list item to be freed */
+	struct xfs_bmap_free		*flist,	/* free item list header */
+	struct xfs_bmap_free_item	*free)	/* list item to be freed */
 {
-	if (prev)
-		prev->xbfi_next = free->xbfi_next;
-	else
-		flist->xbf_first = free->xbfi_next;
+	list_del(&free->xbfi_list);
 	flist->xbf_count--;
 	kmem_zone_free(xfs_bmap_free_item_zone, free);
 }
@@ -634,17 +618,16 @@ xfs_bmap_del_free(
  */
 void
 xfs_bmap_cancel(
-	xfs_bmap_free_t		*flist)	/* list of bmap_free_items */
+	struct xfs_bmap_free		*flist)	/* list of bmap_free_items */
 {
-	xfs_bmap_free_item_t	*free;	/* free list item */
-	xfs_bmap_free_item_t	*next;
+	struct xfs_bmap_free_item	*free;	/* free list item */
 
 	if (flist->xbf_count == 0)
 		return;
-	ASSERT(flist->xbf_first != NULL);
-	for (free = flist->xbf_first; free; free = next) {
-		next = free->xbfi_next;
-		xfs_bmap_del_free(flist, NULL, free);
+	while (!list_empty(&flist->xbf_flist)) {
+		free = list_first_entry(&flist->xbf_flist,
+				struct xfs_bmap_free_item, xbfi_list);
+		xfs_bmap_del_free(flist, free);
 	}
 	ASSERT(flist->xbf_count == 0);
 }
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 0b2f72c..0ef4c6b 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -62,12 +62,12 @@ struct xfs_bmalloca {
  * List of extents to be free "later".
  * The list is kept sorted on xbf_startblock.
  */
-typedef struct xfs_bmap_free_item
+struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
-	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
-} xfs_bmap_free_item_t;
+	struct list_head	xbfi_list;
+};
 
 /*
  * Header for free extent list.
@@ -85,7 +85,7 @@ typedef struct xfs_bmap_free_item
  */
 typedef	struct xfs_bmap_free
 {
-	xfs_bmap_free_item_t	*xbf_first;	/* list of to-be-free extents */
+	struct list_head	xbf_flist;	/* list of to-be-free extents */
 	int			xbf_count;	/* count of items on list */
 	int			xbf_low;	/* alloc in low mode */
 } xfs_bmap_free_t;
@@ -141,8 +141,10 @@ static inline int xfs_bmapi_aflag(int w)
 
 static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 {
-	((flp)->xbf_first = NULL, (flp)->xbf_count = 0, \
-		(flp)->xbf_low = 0, *(fbp) = NULLFSBLOCK);
+	INIT_LIST_HEAD(&flp->xbf_flist);
+	flp->xbf_count = 0;
+	flp->xbf_low = 0;
+	*fbp = NULLFSBLOCK;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 28c42fb..1aac0ba 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -79,6 +79,23 @@ xfs_zero_extent(
 		GFP_NOFS, true);
 }
 
+/* Sort bmap items by AG. */
+static int
+xfs_bmap_free_list_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xfs_mount	*mp = priv;
+	struct xfs_bmap_free_item	*ra;
+	struct xfs_bmap_free_item	*rb;
+
+	ra = container_of(a, struct xfs_bmap_free_item, xbfi_list);
+	rb = container_of(b, struct xfs_bmap_free_item, xbfi_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->xbfi_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->xbfi_startblock);
+}
+
 /*
  * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
  * caller.  Frees all the extents that need freeing, which must be done
@@ -99,14 +116,15 @@ xfs_bmap_finish(
 	int				error;	/* error return value */
 	int				committed;/* xact committed or not */
 	struct xfs_bmap_free_item	*free;	/* free extent item */
-	struct xfs_bmap_free_item	*next;	/* next item on free list */
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 	if (flist->xbf_count == 0)
 		return 0;
 
+	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);
+
 	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
-	for (free = flist->xbf_first; free; free = free->xbfi_next)
+	list_for_each_entry(free, &flist->xbf_flist, xbfi_list)
 		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
 			free->xbfi_blockcount);
 
@@ -136,15 +154,15 @@ xfs_bmap_finish(
 	 * on error.
 	 */
 	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
-	for (free = flist->xbf_first; free != NULL; free = next) {
-		next = free->xbfi_next;
-
+	while (!list_empty(&flist->xbf_flist)) {
+		free = list_first_entry(&flist->xbf_flist,
+				struct xfs_bmap_free_item, xbfi_list);
 		error = xfs_trans_free_extent(*tp, efd, free->xbfi_startblock,
 					      free->xbfi_blockcount);
 		if (error)
 			return error;
 
-		xfs_bmap_del_free(flist, NULL, free);
+		xfs_bmap_del_free(flist, free);
 	}
 
 	return 0;
@@ -797,7 +815,7 @@ xfs_bmap_punch_delalloc_range(
 		if (error)
 			break;
 
-		ASSERT(!flist.xbf_count && !flist.xbf_first);
+		ASSERT(!flist.xbf_count && list_empty(&flist.xbf_flist));
 next_block:
 		start_fsb++;
 		remaining--;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 1492348..f200714 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -41,7 +41,6 @@ int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
 
 /* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
 void	xfs_bmap_del_free(struct xfs_bmap_free *flist,
-			  struct xfs_bmap_free_item *prev,
 			  struct xfs_bmap_free_item *free);
 int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
 			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4700f09..09722a7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1692,8 +1692,9 @@ xfs_init_zones(void)
 	if (!xfs_log_ticket_zone)
 		goto out_free_ioend_bioset;
 
-	xfs_bmap_free_item_zone = kmem_zone_init(sizeof(xfs_bmap_free_item_t),
-						"xfs_bmap_free_item");
+	xfs_bmap_free_item_zone = kmem_zone_init(
+			sizeof(struct xfs_bmap_free_item),
+			"xfs_bmap_free_item");
 	if (!xfs_bmap_free_item_zone)
 		goto out_destroy_log_ticket_zone;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
