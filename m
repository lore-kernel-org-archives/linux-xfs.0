Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB73AC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbjEZAmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEZAmP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3826EE
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:42:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 694B3616EF
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6ECC433D2;
        Fri, 26 May 2023 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061732;
        bh=fAkxgLFrGEgAjSgq8dlMrh8hEWa06WBwtepPavZwJZI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WVQJYDRudMP++p7syLfoevoYqLP81tHUT/cdiCjafEEBWvAcgukDF7DgVzfx6CM8N
         Ud9ay2q11t8077gC8hCe/VvLVTVERdkv/HfLbCrwE10xt3oz6as+DSyaQkIPty1vEp
         4/btHq+ZWDfYXauJlvpCbyzfvBCg4jVtO3VqZYy6gCpX7TyLAtFMdMelAYm5WMQNqJ
         fvSiHvAZa8Mq2m/kY6+LjK/4dferc0GRqkNohW2Gk66o2Zs93cIWR5ld/ytKmVi8LD
         +0V5+jKbNlYiP0zBdSZYATiqOJg/giT6eR9nuq6aHL6tBpK9ZlWX8qu5MCUIH0MQBH
         vnAavtUYQ2CtA==
Date:   Thu, 25 May 2023 17:42:12 -0700
Subject: [PATCH 4/7] xfs: clean up the rtbitmap fsmap backend
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055254.3727958.9311703035231760592.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
References: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The rtbitmap fsmap backend doesn't query the rmapbt, so it's wasteful to
spend time initializing the rmap_irec objects.  Worse yet, the logic to
query the rtbitmap is spread across three separate functions, which is
unnecessarily difficult to follow.

Compute the start rtextent that we want from keys[0] directly and
combine the functions to avoid passing parameters around everywhere, and
consolidate all the logic into a single function.  At one point many
years ago I intended to use __xfs_getfsmap_rtdev as the launching point
for realtime rmapbt queries, but this hasn't been the case for a long
time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   62 ++++++++--------------------------------------------
 fs/xfs/xfs_trace.h |   25 +++++++++++++++++++++
 2 files changed, 34 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 6bd6ab56ca9f..47295067f212 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -512,22 +512,21 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
 }
 
-/* Execute a getfsmap query against the realtime device. */
+/* Execute a getfsmap query against the realtime device rtbitmap. */
 STATIC int
-__xfs_getfsmap_rtdev(
+xfs_getfsmap_rtdev_rtbitmap(
 	struct xfs_trans		*tp,
 	const struct xfs_fsmap		*keys,
-	int				(*query_fn)(struct xfs_trans *,
-						    struct xfs_getfsmap_info *,
-						    xfs_rtblock_t start_rtb,
-						    xfs_rtblock_t end_rtb),
 	struct xfs_getfsmap_info	*info)
 {
+
+	struct xfs_rtalloc_rec		alow = { 0 };
+	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
 	uint64_t			eofs;
-	int				error = 0;
+	int				error;
 
 	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rextents * mp->m_sb.sb_rextsize);
 	if (keys[0].fmr_physical >= eofs)
@@ -536,14 +535,7 @@ __xfs_getfsmap_rtdev(
 				keys[0].fmr_physical + keys[0].fmr_length);
 	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
 
-	/* Set up search keys */
-	info->low.rm_startblock = start_rtb;
-	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
-	if (error)
-		return error;
-	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
-	info->low.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (keys[0].fmr_length > 0) {
@@ -552,32 +544,8 @@ __xfs_getfsmap_rtdev(
 			return 0;
 	}
 
-	info->high.rm_startblock = end_rtb;
-	error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
-	if (error)
-		return error;
-	info->high.rm_offset = XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
-	info->high.rm_blockcount = 0;
-	xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
-
-	trace_xfs_fsmap_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
-	trace_xfs_fsmap_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
-
-	return query_fn(tp, info, start_rtb, end_rtb);
-}
-
-/* Actually query the realtime bitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap_query(
-	struct xfs_trans		*tp,
-	struct xfs_getfsmap_info	*info,
-	xfs_rtblock_t			start_rtb,
-	xfs_rtblock_t			end_rtb)
-{
-	struct xfs_rtalloc_rec		alow = { 0 };
-	struct xfs_rtalloc_rec		ahigh = { 0 };
-	struct xfs_mount		*mp = tp->t_mountp;
-	int				error;
+	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
+	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
 
 	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 
@@ -609,18 +577,6 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 	return error;
 }
-
-/* Execute a getfsmap query against the realtime device rtbitmap. */
-STATIC int
-xfs_getfsmap_rtdev_rtbitmap(
-	struct xfs_trans		*tp,
-	const struct xfs_fsmap		*keys,
-	struct xfs_getfsmap_info	*info)
-{
-	info->missing_owner = XFS_FMR_OWN_UNKNOWN;
-	return __xfs_getfsmap_rtdev(tp, keys, xfs_getfsmap_rtdev_rtbitmap_query,
-			info);
-}
 #endif /* CONFIG_XFS_RT */
 
 /* Execute a getfsmap query against the regular data device. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cd4ca5b1fcb0..5a906bed6f56 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3623,6 +3623,31 @@ DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
 DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
 DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
 
+DECLARE_EVENT_CLASS(xfs_fsmap_linear_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno),
+	TP_ARGS(mp, keydev, bno),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_fsblock_t, bno)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->bno = bno;
+	),
+	TP_printk("dev %d:%d keydev %d:%d bno 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->bno)
+)
+#define DEFINE_FSMAP_LINEAR_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_linear_class, name, \
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno), \
+	TP_ARGS(mp, keydev, bno))
+DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_low_key_linear);
+DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_high_key_linear);
+
 DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap),
 	TP_ARGS(mp, fsmap),

