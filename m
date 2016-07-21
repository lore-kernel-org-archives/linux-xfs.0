Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 728647D22
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 00:00:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C09130404E
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MnBJDhJdGjDcMLOH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 22:00:33 -0700 (PDT)
Subject: [PATCH 40/47] xfs: enable the xfs_defer mechanism to process rmaps
	to update
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 22:00:29 -0700
Message-ID: <146907722925.25461.2811549111055669475.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Connect the xfs_defer mechanism with the pieces that we'll need to
handle deferred rmap updates.  We'll wire up the existing code to
our new deferred mechanism later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.h |    1 
 fs/xfs/xfs_super.c        |    1 
 fs/xfs/xfs_trans.h        |   11 +---
 fs/xfs/xfs_trans_rmap.c   |  131 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 134 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index b9b5a92..cc3981c 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -51,6 +51,7 @@ struct xfs_defer_pending {
  * find all the space it needs.
  */
 enum xfs_defer_ops_type {
+	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5c28072..b8d4473 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1880,6 +1880,7 @@ init_xfs_fs(void)
 			 XFS_BUILD_OPTIONS " enabled\n");
 
 	xfs_extent_free_init_defer_op();
+	xfs_rmap_update_init_defer_op();
 
 	xfs_dir_startup();
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index fd2dfc0..e9e5766 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -33,6 +33,8 @@ struct xfs_trans;
 struct xfs_trans_res;
 struct xfs_dquot_acct;
 struct xfs_busy_extent;
+struct xfs_rud_log_item;
+struct xfs_rui_log_item;
 
 typedef struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
@@ -232,15 +234,10 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 extern kmem_zone_t	*xfs_trans_zone;
 extern kmem_zone_t	*xfs_log_item_desc_zone;
 
+/* rmap updates */
 enum xfs_rmap_intent_type;
 
-struct xfs_rui_log_item *xfs_trans_get_rui(struct xfs_trans *tp, uint nextents);
-void xfs_trans_log_start_rmap_update(struct xfs_trans *tp,
-		struct xfs_rui_log_item *ruip, enum xfs_rmap_intent_type type,
-		__uint64_t owner, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
-		xfs_exntst_t state);
-
+void xfs_rmap_update_init_defer_op(void);
 struct xfs_rud_log_item *xfs_trans_get_rud(struct xfs_trans *tp,
 		struct xfs_rui_log_item *ruip, uint nextents);
 int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index e3a5172..baab990 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -37,7 +37,7 @@
  * caller must use all nextents extents, because we are not
  * flexible about this at all.
  */
-struct xfs_rui_log_item *
+STATIC struct xfs_rui_log_item *
 xfs_trans_get_rui(
 	struct xfs_trans		*tp,
 	uint				nextents)
@@ -96,7 +96,7 @@ xfs_trans_set_rmap_flags(
  * mapping is to be logged as needing to be updated.  It should be
  * called once for each mapping.
  */
-void
+STATIC void
 xfs_trans_log_start_rmap_update(
 	struct xfs_trans		*tp,
 	struct xfs_rui_log_item		*ruip,
@@ -129,7 +129,6 @@ xfs_trans_log_start_rmap_update(
 	xfs_trans_set_rmap_flags(rmap, type, whichfork, state);
 }
 
-
 /*
  * This routine is called to allocate an "rmap update done"
  * log item that will hold nextents worth of extents.  The
@@ -203,3 +202,129 @@ xfs_trans_log_finish_rmap_update(
 
 	return error;
 }
+
+/* Sort rmap intents by AG. */
+static int
+xfs_rmap_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_rmap_intent		*ra;
+	struct xfs_rmap_intent		*rb;
+
+	ra = container_of(a, struct xfs_rmap_intent, ri_list);
+	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->ri_bmap.br_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
+}
+
+/* Get an RUI. */
+STATIC void *
+xfs_rmap_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return xfs_trans_get_rui(tp, count);
+}
+
+/* Log rmap updates in the intent item. */
+STATIC void
+xfs_rmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*rmap;
+
+	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	xfs_trans_log_start_rmap_update(tp, intent, rmap->ri_type,
+			rmap->ri_owner, rmap->ri_whichfork,
+			rmap->ri_bmap.br_startoff,
+			rmap->ri_bmap.br_startblock,
+			rmap->ri_bmap.br_blockcount,
+			rmap->ri_bmap.br_state);
+}
+
+/* Get an RUD so we can process all the deferred rmap updates. */
+STATIC void *
+xfs_rmap_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_rud(tp, intent, count);
+}
+
+/* Process a deferred rmap update. */
+STATIC int
+xfs_rmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_defer_ops		*dop,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_rmap_intent		*rmap;
+	int				error;
+
+	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	error = xfs_trans_log_finish_rmap_update(tp, done_item,
+			rmap->ri_type,
+			rmap->ri_owner, rmap->ri_whichfork,
+			rmap->ri_bmap.br_startoff,
+			rmap->ri_bmap.br_startblock,
+			rmap->ri_bmap.br_blockcount,
+			rmap->ri_bmap.br_state);
+	kmem_free(rmap);
+	return error;
+}
+
+/* Clean up after processing deferred rmaps. */
+STATIC void
+xfs_rmap_update_finish_cleanup(
+	struct xfs_trans	*tp,
+	void			*state,
+	int			error)
+{
+}
+
+/* Abort all pending RUIs. */
+STATIC void
+xfs_rmap_update_abort_intent(
+	void				*intent)
+{
+	xfs_rui_release(intent);
+}
+
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_rmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_rmap_intent		*rmap;
+
+	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
+	kmem_free(rmap);
+}
+
+static const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.type		= XFS_DEFER_OPS_TYPE_RMAP,
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_rmap_update_diff_items,
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.log_item	= xfs_rmap_update_log_item,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rmap_update_finish_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+};
+
+/* Register the deferred op type. */
+void
+xfs_rmap_update_init_defer_op(void)
+{
+	xfs_defer_init_op_type(&xfs_rmap_update_defer_type);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
