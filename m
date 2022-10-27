Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759D8FA3742
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiJ0ROs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbiJ0ROr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB820B1FC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 590B0B82722
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B50C433D6;
        Thu, 27 Oct 2022 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890883;
        bh=qU/uR9aOgvic4uaJ6QmY300yEjsPnwyCbSKwrRD86w0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tgd9Ld+H3SoTm2DuqnK13w0dzLl8AeMDAdk1JJdCyMupVyx0EzF0s6h/6Y+5k6JYa
         phsLWFngAMDZKemym2ecQF7ciqWFvk53jPfvNAW3wupGHoWe/4nw/2gKbiL1/9GwAV
         JSH0S1/LZnm+BExzAb1NlZICTjaRzQuFJiJpARbNsFR9/FIHekoZOJd+XXAhelb+Q1
         pLljeiGeboXGgnttYUKEkKJkQKOyvfpE//nMskQsilGy+5FP9+i4gi4NOsoDXIx5rk
         1f7eTRbNlvek1I3g0fLV8SmllDaINCIDIrPH9jZXo0wMCssxUX/hmA+RRsKFBPjsp9
         YbebL5m550m2Q==
Subject: [PATCH 07/12] xfs: refactor domain and refcount checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:42 -0700
Message-ID: <166689088265.3788582.15184390909746101694.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a helper function to ensure that CoW staging extent records have
a single refcount and that shared extent records have more than 1
refcount.  We'll put this to more use in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |    5 +----
 fs/xfs/libxfs/xfs_refcount.h |   12 ++++++++++++
 fs/xfs/scrub/refcount.c      |   10 ++++------
 3 files changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 8d0417565b9d..586c58b5a557 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -142,10 +142,7 @@ xfs_refcount_get_rec(
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		goto out_bad_rec;
 
-	/* handle special COW-staging domain */
-	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
-		goto out_bad_rec;
-	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
+	if (!xfs_refcount_check_domain(irec))
 		goto out_bad_rec;
 
 	/* check for valid extent range, including overflow */
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index ca3ffe11a452..d666a0e32659 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -55,6 +55,18 @@ struct xfs_refcount_intent {
 	xfs_fsblock_t				ri_startblock;
 };
 
+/* Check that the refcount is appropriate for the record domain. */
+static inline bool
+xfs_refcount_check_domain(
+	const struct xfs_refcount_irec	*irec)
+{
+	if (irec->rc_domain == XFS_REFC_DOMAIN_COW && irec->rc_refcount != 1)
+		return false;
+	if (irec->rc_domain == XFS_REFC_DOMAIN_SHARED && irec->rc_refcount < 2)
+		return false;
+	return true;
+}
+
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 6adc645060e7..98c033072120 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -337,14 +337,12 @@ xchk_refcountbt_rec(
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
 
-	/* Only CoW records can have refcount == 1. */
-	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED && irec.rc_refcount == 1)
+	/* Check the domain and refcount are not incompatible. */
+	if (!xfs_refcount_check_domain(&irec))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-	if (irec.rc_domain == XFS_REFC_DOMAIN_COW) {
-		if (irec.rc_refcount != 1)
-			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	if (irec.rc_domain == XFS_REFC_DOMAIN_COW)
 		(*cow_blocks) += irec.rc_blockcount;
-	}
 
 	/* Check the extent. */
 	if (irec.rc_startblock + irec.rc_blockcount <= irec.rc_startblock ||

