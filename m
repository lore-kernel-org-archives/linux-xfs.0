Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A95EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344895AbiATARo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344962AbiATARk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:17:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC87C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:17:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A9D3614F4
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A3CC004E1;
        Thu, 20 Jan 2022 00:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637859;
        bh=qtx4K6+rnWMjKDGdEjLxy78d7q2/++H/a6DV8Tkibco=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nq+Za2EuRVuTWQDh/m6ygDP4f9qzuui0dvTq7CI4oDWYy9Lg+X8pbwbBSZSKv/IqY
         Jw8s1AhdKKcphpnis5dwwuOw5eHoqdw7nMHu5SxCX5e9cWVtwoE8EIojofCVutypRK
         QRVQZ+ggY7MVNsk7ZKE+l6k6ECAdHpx8Rk06pLxIaamosqdkyHFFuMayqOBUCgBgIw
         nNaPatgVaK6yfMrM4G1ThfqL+ErPNGTc2yoVIALqejx/NRtgNTjL5k2ZZQ4DqoW1tI
         CJEe/35E5ajTE8odvZumZVfxwNxPIKStHTKzNjjXfXf06P1YIq0RPFkILOj9zppwvm
         lFv6RGX9ooLLg==
Subject: [PATCH 03/45] xfs: remove support for disabling quota accounting on a
 mounted file system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:17:39 -0800
Message-ID: <164263785922.860211.7411935063402410960.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 40b52225e58cd3adf9358146b4b39dccfbfe5892

Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
And it has a very strange mind set, as quota accounting (unlike
enforcement) really is a propery of the on-disk format.  There is no good
use case for supporting this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_resv.c |   30 ------------------------------
 libxfs/xfs_trans_resv.h |    2 --
 2 files changed, 32 deletions(-)


diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 9ce7d8f9..fa5edb87 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -797,29 +797,6 @@ xfs_calc_qm_dqalloc_reservation(
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
 
-/*
- * Turning off quotas.
- *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
- *    the superblock for the quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_quotaoff_reservation(
-	struct xfs_mount	*mp)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2 +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
- * End of turning off quotas.
- *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
- */
-STATIC uint
-xfs_calc_qm_quotaoff_end_reservation(void)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2;
-}
-
 /*
  * Syncing the incore super block changes to disk.
  *     the super block to reflect the changes: sector size
@@ -922,13 +899,6 @@ xfs_trans_resv_calc(
 	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation();
 	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
-	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
-	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
-	resp->tr_qm_equotaoff.tr_logres =
-		xfs_calc_qm_quotaoff_end_reservation();
-	resp->tr_qm_equotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
 	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
 	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 7241ab28..fc4e9b36 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -46,8 +46,6 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
 	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
-	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
-	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };

