Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039C2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbiLaC4c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiLaC4b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEAC10F2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB1FA61CD1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1944DC433D2;
        Sat, 31 Dec 2022 02:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455390;
        bh=b8EppkeeByAxPaKbgqvn5KA75t26s0du3D5ME+9t6/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r1WKTg8+nYNzMOdIRYM1Pgj1dt2nm+/ntbrB3u+nYPpRly7YhBE4pbPW13zhFY4jU
         GOoHMtoPo+3GDkvUqmzyG2LjO8UTEdWyn8P2PSGQheBq7gclRUV+YY2IwL1R4uVtOS
         3CJJveTdHc+n2P70GWgFDTwgtHvgQ0r/uI24vbl5/1LiJ77vEWGPSEePih+8SZJrh3
         WaSkWQso0dieYh05daVnKmRRlM94azFCaGDuqvTOiT2UJvrnr7RPmpWm9HxtEP4DSw
         mFOqR3ONkYPo9Wg0srqDKFoiX+e+LUH1eJUreuerz7//LNdV6n/jEice448KAwlL/y
         yn8gqvfIGUPPA==
Subject: [PATCH 09/41] xfs: add metadata reservations for realtime refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:08 -0800
Message-ID: <167243880889.734096.4065600802300106264.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
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
 libxfs/xfs_rtrefcount_btree.c |   39 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    2 ++
 2 files changed, 41 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index c69b4296d57..a5146550b20 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -488,3 +488,42 @@ xfs_rtrefcountbt_create_path(
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
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index 1f3f590c68e..ffda0b063bc 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -72,4 +72,6 @@ void xfs_rtrefcountbt_destroy_cur_cache(void);
 int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */

