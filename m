Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3B8C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiLaBkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBkP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:40:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C313DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6737C61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62AAC433EF;
        Sat, 31 Dec 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450813;
        bh=CwtT5HT8O1xpGCfCzTC1Fw1IY1sGrepAYPTosBLLaP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gb7bu/WCOVG6tQkNSV8LD7sjS2PvMcm0PrEn4LkXkcvYbHLV/BkZOiJ3gxnX1muZ4
         0N3EaJNIL/Y8AVCnnH5sTqp1vRtUsZIDdIFEFGgBO+bVEm825U5vdG1jJVk9cYs8xa
         0fidkjRBIVb3RP3oprHN+oD297wHdxNE/ClJNeFD+c7J49WvdhWA4KHth3q0ZGpI7X
         fa0bxTHFUPBTIgCtoNgCzZRIoQ+gNC5S79zn6yn6HeqxXl4jclQ3CsxP1znK9KqBOU
         bouCkzVfX0s5aqQKHiBumwn0xwZf0RwDbsoYjXt2kFBtKjZAttjeuEO0Bj84Iwa3qi
         +yjShayy0gWww==
Subject: [PATCH 13/38] xfs: add metadata reservations for realtime rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869783.715303.4496353824604001461.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   39 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    2 ++
 fs/xfs/xfs_rtalloc.c             |   21 +++++++++++++++++++-
 3 files changed, 61 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 754812eaff87..c90017408574 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -608,3 +608,42 @@ xfs_rtrmapbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrmap btree size for some records. */
+static unsigned long long
+xfs_rtrmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum rmap btree size.
+ */
+static unsigned long long
+xfs_rtrmapbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrmapbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+xfs_filblks_t
+xfs_rtrmapbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	/* 1/64th (~1.5%) of the space, and enough for 1 record per block. */
+	return max_t(xfs_filblks_t, mp->m_sb.sb_rgblocks >> 6,
+			xfs_rtrmapbt_max_size(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 26e2445f5d6c..63e667d0d76d 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -84,4 +84,6 @@ void xfs_rtrmapbt_destroy_cur_cache(void);
 int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ba330265ab8a..c3d27cb85c26 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1571,6 +1571,11 @@ void
 xfs_rt_resv_free(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg)
+		xfs_imeta_resv_free_inode(rtg->rtg_rmapip);
 }
 
 /* Reserve space for rt metadata inodes' space expansion. */
@@ -1578,7 +1583,21 @@ int
 xfs_rt_resv_init(
 	struct xfs_mount	*mp)
 {
-	return 0;
+	struct xfs_rtgroup	*rtg;
+	xfs_filblks_t		ask;
+	xfs_rgnumber_t		rgno;
+	int			error = 0;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		int		err2;
+
+		ask = xfs_rtrmapbt_calc_reserves(mp);
+		err2 = xfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
 }
 
 static inline int

