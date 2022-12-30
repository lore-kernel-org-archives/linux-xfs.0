Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D308C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236215AbiLaCq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLaCqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:46:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380E9625D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:46:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9D6361D1A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E39C433EF;
        Sat, 31 Dec 2022 02:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454783;
        bh=f6oJlp91QFJujOvs5O1h3w/whNm5CToUlnBqdhiVAwQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GTKyhA0XrMr9p5AxU1ZKsdcf7U8VW9dj1+vcOvIJra9ILa8ejiCkEoLIzIGmBHUD9
         DbKb28sb5eYSFuQkclnW9mIjLb3Hmw2Q6PzR2Q3zoJNdo9WMO8UBTHy+5MNyjOrIUJ
         Xl5mhsma6fPA9Jd6dzDVCswh5UArMvD9xmkRl48Wto0M1GLVEu47OIEKfCpCQZr/jQ
         6MPkrY/9pqbWRErC2n7G0SK2Nm62FfnYF2XW4mCJH5ult5Nag9VbUkXi6IFDvh2pe7
         sGpxO09UJdc/bK/LsWVGAytHcayZpJ7/e7Xe1y9HFaKW/Cq6r0zL7V9fFdlwGh+aCI
         B5JoEdTxGgOyg==
Subject: [PATCH 15/41] xfs: allow queued realtime intents to drain before
 scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879794.732820.2517586055635614609.stgit@magnolia>
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

When a writer thread executes a chain of log intent items for the
realtime volume, the ILOCKs taken during each step are for each rt
metadata file, not the entire rt volume itself.  Although scrub takes
all rt metadata ILOCKs, this isn't sufficient to guard against scrub
checking the rt volume while that writer thread is in the middle of
finishing a chain because there's no higher level locking primitive
guarding the realtime volume.

When there's a collision, cross-referencing between data structures
(e.g. rtrmapbt and rtrefcountbt) yields false corruption events; if
repair is running, this results in incorrect repairs, which is
catastrophic.

Fix this by adding to the mount structure the same drain that we use to
protect scrub against concurrent AG updates, but this time for the
realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h  |    5 +++++
 libxfs/defer_item.c  |    9 ++++++++-
 libxfs/xfs_rtgroup.c |    3 +++
 libxfs/xfs_rtgroup.h |    9 +++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index a4d0ba70e83..ca79c420afb 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -311,6 +311,11 @@ struct xfs_drain { /* empty */ };
 static inline void xfs_perag_bump_intents(struct xfs_perag *pag) { }
 static inline void xfs_perag_drop_intents(struct xfs_perag *pag) { }
 
+struct xfs_rtgroup;
+
+static inline void xfs_rtgroup_bump_intents(struct xfs_rtgroup *rtg) { }
+static inline void xfs_rtgroup_drop_intents(struct xfs_rtgroup *rtg) { }
+
 #define xfs_drain_free(dr)		((void)0)
 #define xfs_drain_init(dr)		((void)0)
 
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 9a4196f7cc0..baf3b9e6204 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -91,6 +91,7 @@ xfs_extent_free_get_group(
 
 		rgno = xfs_rtb_to_rgno(mp, xefi->xefi_startblock);
 		xefi->xefi_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_bump_intents(xefi->xefi_rtg);
 		return;
 	}
 
@@ -105,6 +106,7 @@ xfs_extent_free_put_group(
 	struct xfs_extent_free_item	*xefi)
 {
 	if (xfs_efi_is_realtime(xefi)) {
+		xfs_rtgroup_drop_intents(xefi->xefi_rtg);
 		xfs_rtgroup_put(xefi->xefi_rtg);
 		return;
 	}
@@ -275,6 +277,7 @@ xfs_rmap_update_get_group(
 
 		rgno = xfs_rtb_to_rgno(mp, ri->ri_bmap.br_startblock);
 		ri->ri_rtg = xfs_rtgroup_get(mp, rgno);
+		xfs_rtgroup_bump_intents(ri->ri_rtg);
 		return;
 	}
 
@@ -289,6 +292,7 @@ xfs_rmap_update_put_group(
 	struct xfs_rmap_intent	*ri)
 {
 	if (ri->ri_realtime) {
+		xfs_rtgroup_drop_intents(ri->ri_rtg);
 		xfs_rtgroup_put(ri->ri_rtg);
 		return;
 	}
@@ -522,6 +526,7 @@ xfs_bmap_update_get_group(
 
 			rgno = xfs_rtb_to_rgno(mp, bi->bi_bmap.br_startblock);
 			bi->bi_rtg = xfs_rtgroup_get(mp, rgno);
+			xfs_rtgroup_bump_intents(bi->bi_rtg);
 		} else {
 			bi->bi_rtg = NULL;
 		}
@@ -548,8 +553,10 @@ xfs_bmap_update_put_group(
 	struct xfs_bmap_intent	*bi)
 {
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork)) {
-		if (xfs_has_rtgroups(bi->bi_owner->i_mount))
+		if (xfs_has_rtgroups(bi->bi_owner->i_mount)) {
+			xfs_rtgroup_drop_intents(bi->bi_rtg);
 			xfs_rtgroup_put(bi->bi_rtg);
+		}
 		return;
 	}
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 8018cd02e70..8c41869a61a 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -129,6 +129,8 @@ xfs_initialize_rtgroups(
 #ifdef __KERNEL__
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
+		xfs_drain_init(&rtg->rtg_intents);
+
 #endif /* __KERNEL__ */
 
 		/* first new rtg is fully initialized */
@@ -180,6 +182,7 @@ xfs_free_rtgroups(
 		spin_unlock(&mp->m_rtgroup_lock);
 		ASSERT(rtg);
 		XFS_IS_CORRUPT(rtg->rtg_mount, atomic_read(&rtg->rtg_ref) != 0);
+		xfs_drain_free(&rtg->rtg_intents);
 
 		call_rcu(&rtg->rcu_head, __xfs_free_rtgroups);
 	}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 3230dd03d8f..1d41a2cac34 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -37,6 +37,15 @@ struct xfs_rtgroup {
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 	spinlock_t		rtg_state_lock;
+
+	/*
+	 * We use xfs_drain to track the number of deferred log intent items
+	 * that have been queued (but not yet processed) so that waiters (e.g.
+	 * scrub) will not lock resources when other threads are in the middle
+	 * of processing a chain of intent items only to find momentary
+	 * inconsistencies.
+	 */
+	struct xfs_drain	rtg_intents;
 #endif /* __KERNEL__ */
 };
 

