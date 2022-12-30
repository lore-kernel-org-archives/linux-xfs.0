Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25A7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiLaCr3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:47:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2224D12D0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:47:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C88D6B81E6C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747E3C433D2;
        Sat, 31 Dec 2022 02:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454845;
        bh=OgV83HvKYsxjiDSq6wlQyQ188WzR/ctPuoeMELC785k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r7PWyPoX54Yhpt30kdYVdI90uv32gQucj8HhCLKccf3grGGdjUTN/ggzyrkF+Mcq/
         fozJIxmoJ8zjh3zugEuvnCqNgCewohTa4HhzNXs7Fy//H+ouHvNj+TAOH/ytf2pL1n
         5IdsIWgevnyBMqSJY6l4zRos3sXPwdx2naoYUMqZvjA/4ZopfagNYx1VUtWWZ+DnsS
         IkSztNmiKfORGjj6MkCntw1/wjKIbrRsEjwC2II49LIdNJ/KbBXyOKu22M72YjzQu4
         arcg54Wurg/UONl0Gx25r+mnzQU6BA+WTYQ5BLJ49mqx1+DinklfEs7n96u3l/Av5O
         BbPD7UIZqqSPw==
Subject: [PATCH 19/41] xfs: hook live realtime rmap operations during a repair
 operation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:58 -0800
Message-ID: <167243879845.732820.13143332721787001519.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hook the regular realtime rmap code when an rtrmapbt repair operation is
running so that we can unlock the AGF buffer to scan the filesystem and
keep the in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c    |   39 ++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_rmap.h    |    6 ++++++
 libxfs/xfs_rtgroup.c |    2 +-
 libxfs/xfs_rtgroup.h |    3 +++
 4 files changed, 44 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 5c118eb98b4..a8ba49a89cf 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -905,6 +905,7 @@ static inline void
 xfs_rmap_update_hook(
 	struct xfs_trans		*tp,
 	struct xfs_perag		*pag,
+	struct xfs_rtgroup		*rtg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -921,6 +922,8 @@ xfs_rmap_update_hook(
 
 		if (pag)
 			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+		else if (rtg)
+			xfs_hooks_call(&rtg->rtg_rmap_update_hooks, op, &p);
 	}
 }
 
@@ -941,8 +944,28 @@ xfs_rmap_hook_del(
 {
 	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->update_hook);
 }
+
+# ifdef CONFIG_XFS_RT
+/* Call the specified function during a rt reverse mapping update. */
+int
+xfs_rtrmap_hook_add(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rmap_hook	*hook)
+{
+	return xfs_hooks_add(&rtg->rtg_rmap_update_hooks, &hook->update_hook);
+}
+
+/* Stop calling the specified function during a rt reverse mapping update. */
+void
+xfs_rtrmap_hook_del(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rmap_hook	*hook)
+{
+	xfs_hooks_del(&rtg->rtg_rmap_update_hooks, &hook->update_hook);
+}
+# endif /* CONFIG_XFS_RT */
 #else
-# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while(0)
+# define xfs_rmap_update_hook(t, p, r, o, s, b, u, oi)	do { } while(0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
 /*
@@ -965,7 +988,8 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag, NULL, XFS_RMAP_UNMAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1209,7 +1233,8 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag, NULL, XFS_RMAP_MAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2730,8 +2755,12 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
-			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	if (ri->ri_realtime)
+		xfs_rmap_update_hook(tp, NULL, ri->ri_rtg, ri->ri_type, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	else
+		xfs_rmap_update_hook(tp, ri->ri_pag, NULL, ri->ri_type, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 9d0aaa16f55..36d071b3b44 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -279,6 +279,12 @@ void xfs_rmap_hook_enable(void);
 
 int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
 void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+
+# ifdef CONFIG_XFS_RT
+int xfs_rtrmap_hook_add(struct xfs_rtgroup *rtg, struct xfs_rmap_hook *hook);
+void xfs_rtrmap_hook_del(struct xfs_rtgroup *rtg, struct xfs_rmap_hook *hook);
+# endif /* CONFIG_XFS_RT */
+
 #endif
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 8c41869a61a..f5f981609b4 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -130,7 +130,7 @@ xfs_initialize_rtgroups(
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
 		xfs_drain_init(&rtg->rtg_intents);
-
+		xfs_hooks_init(&rtg->rtg_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		/* first new rtg is fully initialized */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 1d41a2cac34..4e9b9098f2f 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -46,6 +46,9 @@ struct xfs_rtgroup {
 	 * inconsistencies.
 	 */
 	struct xfs_drain	rtg_intents;
+
+	/* Hook to feed rt rmapbt updates to an active online repair. */
+	struct xfs_hooks	rtg_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 

