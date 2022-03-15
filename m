Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5EFC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 06:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbiCOGoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 02:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345271AbiCOGoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 02:44:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6840D25F3
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 23:42:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D51CB533055
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:42:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-005elO-Ly
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 17:42:43 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-00D9KG-Kb
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 17:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: log items should have a xlog pointer, not a mount
Date:   Tue, 15 Mar 2022 17:42:39 +1100
Message-Id: <20220315064241.3133751-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315064241.3133751-1-david@fromorbit.com>
References: <20220315064241.3133751-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62303565
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=eK9uUbcZqazOid2N2AkA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Log items belong to the log, not the xfs_mount. Convert the mount
pointer in the log item to a xlog pointer in preparation for
upcoming log centric changes to the log items.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     | 2 +-
 fs/xfs/xfs_buf_item.c      | 5 +++--
 fs/xfs/xfs_extfree_item.c  | 2 +-
 fs/xfs/xfs_log.c           | 2 +-
 fs/xfs/xfs_log_cil.c       | 2 +-
 fs/xfs/xfs_refcount_item.c | 2 +-
 fs/xfs/xfs_rmap_item.c     | 2 +-
 fs/xfs/xfs_trace.h         | 4 ++--
 fs/xfs/xfs_trans.c         | 2 +-
 fs/xfs/xfs_trans.h         | 3 ++-
 10 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index fa710067aac2..65ac261b3b28 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -476,7 +476,7 @@ xfs_bui_item_recover(
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
 	xfs_filblks_t			count;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a7a8e4528881..522d450a94b1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -21,6 +21,7 @@
 #include "xfs_dquot.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 
 
 struct kmem_cache	*xfs_buf_item_cache;
@@ -428,7 +429,7 @@ xfs_buf_item_format(
 	 * occurs during recovery.
 	 */
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
-		if (xfs_has_v3inodes(lip->li_mountp) ||
+		if (xfs_has_v3inodes(lip->li_log->l_mp) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
 		      xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
@@ -616,7 +617,7 @@ xfs_buf_item_put(
 	 * that case, the bli is freed on buffer writeback completion.
 	 */
 	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-		  xfs_is_shutdown(lip->li_mountp);
+			xlog_is_shutdown(lip->li_log);
 	dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	if (dirty && !aborted)
 		return false;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 36eeac9413f5..893a7dd15cbb 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -615,7 +615,7 @@ xfs_efi_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
 	struct xfs_trans		*tp;
 	struct xfs_extent		*extp;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b0e05fa902d4..5c4ef45f42d2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1136,7 +1136,7 @@ xfs_log_item_init(
 	int			type,
 	const struct xfs_item_ops *ops)
 {
-	item->li_mountp = mp;
+	item->li_log = mp->m_log;
 	item->li_ailp = mp->m_ail;
 	item->li_type = type;
 	item->li_ops = ops;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48b16a5feb27..e9b80036268a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -76,7 +76,7 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item *lip)
 {
-	return xlog_item_in_current_chkpt(lip->li_mountp->m_log->l_cilp, lip);
+	return xlog_item_in_current_chkpt(lip->li_log->l_cilp, lip);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d4632f2ceb89..1b82b818f515 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -468,7 +468,7 @@ xfs_cui_item_recover(
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index cb0490919b2c..546bd824cdf7 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -523,7 +523,7 @@ xfs_rui_item_recover(
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
-	struct xfs_mount		*mp = lip->li_mountp;
+	struct xfs_mount		*mp = lip->li_log->l_mp;
 	enum xfs_rmap_intent_type	type;
 	xfs_exntst_t			state;
 	int				i;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 585bd9853b6b..cc69b7c066e8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1308,7 +1308,7 @@ DECLARE_EVENT_CLASS(xfs_log_item_class,
 		__field(xfs_lsn_t, lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
@@ -1364,7 +1364,7 @@ DECLARE_EVENT_CLASS(xfs_ail_class,
 		__field(xfs_lsn_t, new_lsn)
 	),
 	TP_fast_assign(
-		__entry->dev = lip->li_mountp->m_super->s_dev;
+		__entry->dev = lip->li_log->l_mp->m_super->s_dev;
 		__entry->lip = lip;
 		__entry->type = lip->li_type;
 		__entry->flags = lip->li_flags;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 82590007e6c5..de87fb136b51 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -646,7 +646,7 @@ xfs_trans_add_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
-	ASSERT(lip->li_mountp == tp->t_mountp);
+	ASSERT(lip->li_log == tp->t_mountp->m_log);
 	ASSERT(lip->li_ailp == tp->t_mountp->m_ail);
 	ASSERT(list_empty(&lip->li_trans));
 	ASSERT(!test_bit(XFS_LI_DIRTY, &lip->li_flags));
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 85dca2c9b559..1c5c5d7f522f 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -8,6 +8,7 @@
 
 /* kernel only transaction subsystem defines */
 
+struct xlog;
 struct xfs_buf;
 struct xfs_buftarg;
 struct xfs_efd_log_item;
@@ -31,7 +32,7 @@ struct xfs_log_item {
 	struct list_head		li_ail;		/* AIL pointers */
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
-	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
+	struct xlog			*li_log;
 	struct xfs_ail			*li_ailp;	/* ptr to AIL */
 	uint				li_type;	/* item type */
 	unsigned long			li_flags;	/* misc flags */
-- 
2.35.1

