Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E12C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiLaCpX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiLaCox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:44:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF3162FD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:44:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B7FEB81E5F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DFBC433EF;
        Sat, 31 Dec 2022 02:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454690;
        bh=KRqwimTztnqKZuTtxJ3Ea9S/c5YPGoXstnMZ8vnOGvw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ECVPF3RxPXuwqgEOQV+zShmRjRA1ui7sUbDrg0L4a3GpdVlkhC8jzQ+hk/jmI3Pdw
         UWnW52okOkfwd7jhyPnQbWOvG+GOWCaeateN7Up7n5qr5GnAdze+HOL0LvYSM3kjMA
         wwBAGBW4vl4p5InrfZBozxeix005FtjmZTOFlTYMjjf0k72IXptArQ+dnE0hlLlaUX
         snrHzg38Y8pAKWEG0B55/y9LtCtW3QOoCZaaGLMYJ4x02xcTbcrRLWugQNJLofei2P
         GGLV475AaOxuhZoaj/wHhi3jpmODiDbhtDCJjlQNxw+wZZYD2QYTpXjmbYIJJeDsLg
         nvYzvbUBxOQXQ==
Subject: [PATCH 09/41] xfs: add metadata reservations for realtime rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:57 -0800
Message-ID: <167243879716.732820.3007642601638128697.stgit@magnolia>
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

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c |   39 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    2 ++
 2 files changed, 41 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 85608c813b4..d45f711ce06 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -606,3 +606,42 @@ xfs_rtrmapbt_create_path(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 26e2445f5d6..63e667d0d76 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -84,4 +84,6 @@ void xfs_rtrmapbt_destroy_cur_cache(void);
 int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */

