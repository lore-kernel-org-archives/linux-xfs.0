Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1323C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiLaBvL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiLaBvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:51:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15781DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:51:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DDC561CBE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2F1C433D2;
        Sat, 31 Dec 2022 01:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451468;
        bh=SKjCZj/hkiW1AHDeEVxMdoqDo7b1DePxQNc3+elxhCU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t0xyOpyt0h3I4MKqHd3pFaezUuEUmKhfAg2Rqvd8pWhiR/O9vrDNCaZAeF6exnMLm
         x524vflqZZLyCjzYNl/2IS1zQ4AsXqmBSGlsIk3B16AwtLibPuuL7CrvwzBkfMbjwD
         fP+QxkuFh/YRzkuhbrMSp+6r6S6zFaIkX3VRPUX3ch8H2NvZK9fL66RlB61s6CmQOj
         LeYUkkr/JpfgVoXDs73yFiuaBmkBFuvxPbC4oq4ElTsOGFyp/QtI7SFLf94ePRvgfK
         14GfvdAc06/7jaRTHyg5AJ1wBGN0S0wfJlnjYlWeHgIZz2bRwI+Qs7RcWhQMpqJ6lW
         A4AYYuLeobcsA==
Subject: [PATCH 12/42] xfs: add metadata reservations for realtime refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:30 -0800
Message-ID: <167243871068.717073.4070369282152095464.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   39 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    2 ++
 fs/xfs/xfs_rtalloc.c                 |    9 +++++++-
 3 files changed, 49 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 40524fee3860..74c5cf9a0d3a 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -490,3 +490,42 @@ xfs_rtrefcountbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrefcount btree size for some records. */
+static unsigned long long
+xfs_rtrefcountbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrefc_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+static unsigned long long
+xfs_rtrefcountbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrefc_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrefcountbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ * We need enough space to hold one record for every rt extent in the rtgroup.
+ */
+xfs_filblks_t
+xfs_rtrefcountbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	return xfs_rtrefcountbt_max_size(mp,
+			xfs_rtb_to_rtxt(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index 1f3f590c68e6..ffda0b063bcf 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -72,4 +72,6 @@ void xfs_rtrefcountbt_destroy_cur_cache(void);
 int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c998e26f5db9..48c7cc28b7f2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1733,8 +1733,10 @@ xfs_rt_resv_free(
 	struct xfs_rtgroup	*rtg;
 	xfs_rgnumber_t		rgno;
 
-	for_each_rtgroup(mp, rgno, rtg)
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_imeta_resv_free_inode(rtg->rtg_refcountip);
 		xfs_imeta_resv_free_inode(rtg->rtg_rmapip);
+	}
 }
 
 /* Reserve space for rt metadata inodes' space expansion. */
@@ -1754,6 +1756,11 @@ xfs_rt_resv_init(
 		err2 = xfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
 		if (err2 && !error)
 			error = err2;
+
+		ask = xfs_rtrefcountbt_calc_reserves(mp);
+		err2 = xfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+		if (err2 && !error)
+			error = err2;
 	}
 
 	return error;

