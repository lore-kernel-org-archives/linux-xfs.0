Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F352ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJ3XmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3XmL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6E79FED
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:42:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB8E1B810A5
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EFBC433C1;
        Sun, 30 Oct 2022 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173327;
        bh=9qAgpmGf8lrawZLgVYp6yW2RTDfgGGobLBUj0Gupmho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Eb/SVTSpADDtStb7yq9kv/cE94DHHOhuake+WLsHJpvtCqP3GzVun1rmTSlxdu9uN
         ENbXH6zKaTBuU32t46aQkCthXfgxAW9V1f8Aq/mK2h0PUzge177iwpZbKyk8TcBCy7
         vOEkInOGSv3cHRoZx1rjGv6Md/L9BOHfQo9QQdubYzwxxnG05DmUEOKVqxTM/fgdr0
         L5PYH0wqSYvpHegTZR4EVUf/HnbocoTASyf9QOQNzXuxCWdYCdHAWFesLFcoM+JdpG
         ToQmukcC2gOsgohUGdauxPGNv7ZF8dwh1aoF2BL0r8i8ufc4MEgUjA15azts/ZgzT9
         6pNvTF8MUtXAg==
Subject: [PATCH 08/13] xfs: refactor domain and refcount checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:42:07 -0700
Message-ID: <166717332713.417886.12749181191367647918.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_refcount.c |    5 +----
 fs/xfs/libxfs/xfs_refcount.h |   12 ++++++++++++
 fs/xfs/scrub/refcount.c      |   10 ++++------
 3 files changed, 17 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 0f920eff34c4..8eaa11470f46 100644
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
index 3beb5a30a9c9..ee32e8eb5a99 100644
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
index af5b796ec9ec..fe5ffe4f478d 100644
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
 	if (!xfs_verify_agbext(pag, irec.rc_startblock, irec.rc_blockcount))

