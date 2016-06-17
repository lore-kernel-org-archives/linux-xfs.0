Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4109E8089
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C007BAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:12 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mcD9kusdpnRCXfbE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:10 -0700 (PDT)
Subject: [PATCH 013/145] xfs: convert list of extents to free into a regular
	list
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:32:06 -0700
Message-ID: <146612712636.16048.4965436384661239506.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

In struct xfs_bmap_free, convert the open-coded free extent list to
a regular list, then use list_sort to sort it prior to processing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/init.c        |    3 ++-
 libxfs/libxfs_priv.h |    3 +--
 libxfs/util.c        |   10 +++++-----
 libxfs/xfs_bmap.c    |   39 +++++++++++----------------------------
 libxfs/xfs_bmap.h    |   14 ++++++++------
 5 files changed, 27 insertions(+), 42 deletions(-)


diff --git a/libxfs/init.c b/libxfs/init.c
index e04b6e0..67c3b30 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -417,7 +417,8 @@ manage_zones(int release)
 	xfs_btree_cur_zone = kmem_zone_init(
 			sizeof(xfs_btree_cur_t), "xfs_btree_cur");
 	xfs_bmap_free_item_zone = kmem_zone_init(
-			sizeof(xfs_bmap_free_item_t), "xfs_bmap_free_item");
+			sizeof(struct xfs_bmap_free_item),
+			"xfs_bmap_free_item");
 	xfs_log_item_desc_zone = kmem_zone_init(
 			sizeof(struct xfs_log_item_desc), "xfs_log_item_desc");
 	xfs_dir_startup();
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ecd75e7..ba16544 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -466,8 +466,7 @@ struct xfs_buftarg;
 int xfs_attr_rmtval_get(struct xfs_da_args *);
 
 /* xfs_bmap.c */
-void xfs_bmap_del_free(struct xfs_bmap_free *, struct xfs_bmap_free_item *,
-			struct xfs_bmap_free_item *);
+void xfs_bmap_del_free(struct xfs_bmap_free *, struct xfs_bmap_free_item *);
 
 /* xfs_mount.c */
 int xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
diff --git a/libxfs/util.c b/libxfs/util.c
index 2e826c9..f37b396 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -480,20 +480,20 @@ libxfs_bmap_finish(
 	struct xfs_bmap_free	*flist,
 	struct xfs_inode	*ip)
 {
-	xfs_bmap_free_item_t	*free;	/* free extent list item */
-	xfs_bmap_free_item_t	*next;	/* next item on free list */
+	struct xfs_bmap_free_item	*free;	/* free extent list item */
 	int			error;
 
 	if (flist->xbf_count == 0)
 		return 0;
 
-	for (free = flist->xbf_first; free != NULL; free = next) {
-		next = free->xbfi_next;
+	while (!list_empty(&flist->xbf_flist)) {
+		free = list_first_entry(&flist->xbf_flist,
+				struct xfs_bmap_free_item, xbfi_list);
 		error = xfs_free_extent(*tp, free->xbfi_startblock,
 					free->xbfi_blockcount);
 		if (error)
 			return error;
-		xfs_bmap_del_free(flist, NULL, free);
+		xfs_bmap_del_free(flist, free);
 	}
 	return 0;
 }
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index c2a2c53..65de5ad 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -567,9 +567,7 @@ xfs_bmap_add_free(
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
@@ -589,17 +587,7 @@ xfs_bmap_add_free(
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
 
@@ -609,14 +597,10 @@ xfs_bmap_add_free(
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
@@ -626,17 +610,16 @@ xfs_bmap_del_free(
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 6485403..c165b2d 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
