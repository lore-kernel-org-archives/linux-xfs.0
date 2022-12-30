Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F71C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiL3WfS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiL3WfR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:35:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2EF1C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:35:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2B0961C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004D8C433EF;
        Fri, 30 Dec 2022 22:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439716;
        bh=+BG90usFdb8Dm9mvwdP6XAls0Qiyp8mE3/BtAGRdEzY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TcMLaJr/cIxPP326KyCiDqAu817A+UldV3150WTAvFOP2godPPFRwLqRxltuiWdDA
         7sHS/d9x77vRT6e7xqmLpJhl6CMDZYuNSmaXiu3ZB/SUscXQjx2tijNYlhbjmq9fSn
         nHPzZLTKgZzmrdNfCWUJ5WE5uFFerXNS6fKxD3EnmH+FkmcaohhaH2lKmXVrjU501r
         NjawGjmeXIkkVyMcPfnCzRxF/GZafxNVmFBOfw99RRquvS4fHdpGeOe9tSysE3kXXM
         0/VBk1XyoUQJ4xkXMNSJgn4rCVKsyb3+VyGc+67VN0VyGZO3Ha+puXfzMYDofjybu0
         xcy4Dz5szrsnA==
Subject: [PATCH 1/5] xfs: give xfs_bmap_intent its own perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:00 -0800
Message-ID: <167243826089.683449.10500045700322966342.stgit@magnolia>
In-Reply-To: <167243826070.683449.502057797810903920.stgit@magnolia>
References: <167243826070.683449.502057797810903920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Give the xfs_bmap_intent an active reference to the perag structure
data.  This reference will be used to enable scrub intent draining
functionality in subsequent patches.  Later, shrink will use these
active references to know if an AG is quiesced or not.

The reason why we take an active ref for a file mapping operation is
simple: we're committing to some sort of action involving space in an
AG, so we want to indicate our active interest in that AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    1 +
 fs/xfs/libxfs/xfs_bmap.h |    4 ++++
 fs/xfs/xfs_bmap_item.c   |   29 ++++++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c8c65387136c..45dfa5a56154 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6109,6 +6109,7 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 01c2df35c3e3..0cd86781fcd5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -231,9 +231,13 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
+	struct xfs_perag			*bi_pag;
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
+void xfs_bmap_update_get_group(struct xfs_mount *mp,
+		struct xfs_bmap_intent *bi);
+
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6e2f0013380a..32ccd4bb9f46 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,6 +24,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_bui_cache;
 struct kmem_cache	*xfs_bud_cache;
@@ -363,6 +364,26 @@ xfs_bmap_update_create_done(
 	return &xfs_trans_get_bud(tp, BUI_ITEM(intent))->bud_item;
 }
 
+/* Take an active ref to the AG containing the space we're mapping. */
+void
+xfs_bmap_update_get_group(
+	struct xfs_mount	*mp,
+	struct xfs_bmap_intent	*bi)
+{
+	xfs_agnumber_t		agno;
+
+	agno = XFS_FSB_TO_AGNO(mp, bi->bi_bmap.br_startblock);
+	bi->bi_pag = xfs_perag_get(mp, agno);
+}
+
+/* Release an active AG ref after finishing mapping work. */
+static inline void
+xfs_bmap_update_put_group(
+	struct xfs_bmap_intent	*bi)
+{
+	xfs_perag_put(bi->bi_pag);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
@@ -381,6 +402,8 @@ xfs_bmap_update_finish_item(
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
 		return -EAGAIN;
 	}
+
+	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 	return error;
 }
@@ -393,7 +416,7 @@ xfs_bmap_update_abort_intent(
 	xfs_bui_release(BUI_ITEM(intent));
 }
 
-/* Cancel a deferred rmap update. */
+/* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
@@ -401,6 +424,8 @@ xfs_bmap_update_cancel_item(
 	struct xfs_bmap_intent		*bi;
 
 	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 
@@ -509,10 +534,12 @@ xfs_bui_item_recover(
 	fake.bi_bmap.br_state = (map->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 
+	xfs_bmap_update_get_group(mp, &fake);
 	error = xfs_trans_log_finish_bmap_update(tp, budp, &fake);
 	if (error == -EFSCORRUPTED)
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, map,
 				sizeof(*map));
+	xfs_bmap_update_put_group(&fake);
 	if (error)
 		goto err_cancel;
 

