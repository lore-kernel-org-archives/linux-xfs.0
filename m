Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3895C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDD6D610FB
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhINCl2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236074AbhINCl1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39D05610D1;
        Tue, 14 Sep 2021 02:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587211;
        bh=qtx4K6+rnWMjKDGdEjLxy78d7q2/++H/a6DV8Tkibco=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SqJynLqmiH1BtiqPRfbzJJpdkyuzBE98iKHq/AevS69kscx/pLwBjnwPHQE8rsazl
         +S9dhOsBhCuDym/RkQeghCCo97d8o00ghFIVP+k3NFBZbjcRAL6LNGU3pUtOEm39YB
         QXZcyRG4/ytAwT7rv20iJ/G0bK0vI07YujaPC/JlhsJlRa1bXpMW6kAz1RJWHY5BkL
         mdV2AHcKFyLrf0vVQj4Nzrcr239M++347TjHTdd71jg7z6e3djnLDAMK9CAuUFxquT
         t9mT3s6orsIIZ9+HO95tqk4RtwArm79k9SCBdSqSMdXwwTeCWgR1/YtQDJrBnmtcZT
         FJ03ddC2CX46A==
Subject: [PATCH 02/43] xfs: remove support for disabling quota accounting on a
 mounted file system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:40:10 -0700
Message-ID: <163158721096.1604118.17353772572397459905.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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

