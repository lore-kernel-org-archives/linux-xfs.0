Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070C5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiLaBtY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiLaBtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:49:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953091DDFF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:49:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5666CB81DF9
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1805FC433D2;
        Sat, 31 Dec 2022 01:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451360;
        bh=Gia+DuWNZ1ewXa4T2NngBVONHn6W4xPrAj+654Mmwi0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GisqnqojEI1Q2wKy01BO7YvJDNk/IpDGFYBAMSv5IZUSlO702k7qUYbditPr+fXRW
         LSTn/uDyT+HX5Rkls/yAm6hnZyfyaLJvTh1/TrXaU6zM+kvn4vAJumVmUAu7/vr6Xa
         91y2KlmUH30lfTqdUe6tZWvVCVQEdFKUFDh0ckoiriye1fE9j8T3SHjfY/jq6nYTSZ
         AYmf/ydOwn736v15xGQ0za+b4qJQymGuFcx8A9EmfR0+oy7UATNkkK/GKL5MUHW+R4
         4WDePiu8Zw9DLOCNNY1K1uMUeDZcthf7M78Lr+YSVGjxLs9f10nmTzOhnym+Qw9Y90
         u5e6KUDndZ0lg==
Subject: [PATCH 05/42] xfs: realtime refcount btree transaction reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870969.717073.10174042531639869915.stgit@magnolia>
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

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrefcountbt to add the record and a second
split in the regular refcountbt to record the rtrefcountbt split.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_trans_resv.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 52a4386a3d96..2b8b8dd5dec3 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -90,6 +90,14 @@ xfs_refcountbt_block_count(
 	return num_ops * (2 * mp->m_refc_maxlevels - 1);
 }
 
+static unsigned int
+xfs_rtrefcountbt_block_count(
+	struct xfs_mount	*mp,
+	unsigned int		num_ops)
+{
+	return num_ops * (2 * mp->m_rtrefc_maxlevels - 1);
+}
+
 /*
  * Logging inodes is really tricksy. They are logged in memory format,
  * which means that what we write into the log doesn't directly translate into
@@ -257,10 +265,13 @@ xfs_rtalloc_block_count(
  * Compute the log reservation required to handle the refcount update
  * transaction.  Refcount updates are always done via deferred log items.
  *
- * This is calculated as:
+ * This is calculated as the max of:
  * Data device refcount updates (t1):
  *    the agfs of the ags containing the blocks: nr_ops * sector size
  *    the refcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
+ * Realtime refcount updates (t2);
+ *    the rt refcount inode
+ *    the rtrefcount btrees: nr_ops * 1 trees * (2 * max depth - 1) * block size
  */
 static unsigned int
 xfs_calc_refcountbt_reservation(
@@ -268,12 +279,20 @@ xfs_calc_refcountbt_reservation(
 	unsigned int		nr_ops)
 {
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
+	unsigned int		t1, t2 = 0;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	return xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
-	       xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+	t1 = xfs_calc_buf_res(nr_ops, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_refcountbt_block_count(mp, nr_ops), blksz);
+
+	if (xfs_has_realtime(mp))
+		t2 = xfs_calc_inode_res(mp, 1) +
+		     xfs_calc_buf_res(xfs_rtrefcountbt_block_count(mp, nr_ops),
+				     blksz);
+
+	return max(t1, t2);
 }
 
 /*

