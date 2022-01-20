Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01143C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbiATAZt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48326 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345332AbiATAZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0123BB81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC771C004E1;
        Thu, 20 Jan 2022 00:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638346;
        bh=LfzFaPxgI4QwXT46O06inMuqusk0lGBkhp7x6r61fLY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nja/RvRkbNTQAd3uOLtox1elOqOp+ii52AayQEgvyxaw69Ez4JJFsC3mqij47k6ni
         FmNQ+/Nxf4EXVo6wF4S5gFcdyqht+EBMixOUv75+jOlPy+krF5FdoBexgT421KkMjd
         T2ECivnhPKKCbPHdEQx9NHox54M5svsVlTdIr7KW0EIG9MzsEQ4bm+KEv2Xzn+YF/o
         LX4CkRTOIyRhS702XWTuNGrZqak4BUn5/j4Qm6dCKEXF1W9eGDbEMO19NJuUDcOoCC
         wsvJ40Pe14ZB7tHBYKOcguTF12OrIoxcSD2yyFxguBnoT0Gq0+hzYSTg41OzBUqVkE
         hQJYq4H0TjMlA==
Subject: [PATCH 28/48] xfs_repair: warn about suspicious btree levels in AG
 headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:46 -0800
Message-ID: <164263834640.865554.8783708804794640296.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Warn about suspicious AG btree levels in the AGF and AGI.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/scan.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)


diff --git a/repair/scan.c b/repair/scan.c
index e2d281a2..e7bf1fde 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2261,6 +2261,13 @@ validate_agf(
 {
 	xfs_agblock_t		bno;
 	uint32_t		magic;
+	unsigned int		levels;
+
+	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		do_warn(_("bad levels %u for btbno root, agno %d\n"),
+			levels, agno);
+	}
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
@@ -2274,6 +2281,12 @@ validate_agf(
 			bno, agno);
 	}
 
+	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		do_warn(_("bad levels %u for btbcnt root, agno %d\n"),
+			levels, agno);
+	}
+
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
 		magic = xfs_has_crc(mp) ? XFS_ABTC_CRC_MAGIC
@@ -2288,7 +2301,6 @@ validate_agf(
 
 	if (xfs_has_rmapbt(mp)) {
 		struct rmap_priv	priv;
-		unsigned int		levels;
 
 		memset(&priv.high_key, 0xFF, sizeof(priv.high_key));
 		priv.high_key.rm_blockcount = 0;
@@ -2320,8 +2332,6 @@ validate_agf(
 	}
 
 	if (xfs_has_reflink(mp)) {
-		unsigned int	levels;
-
 		levels = be32_to_cpu(agf->agf_refcount_level);
 		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
@@ -2378,6 +2388,13 @@ validate_agi(
 	xfs_agblock_t		bno;
 	int			i;
 	uint32_t		magic;
+	unsigned int		levels;
+
+	levels = be32_to_cpu(agi->agi_level);
+	if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+		do_warn(_("bad levels %u for inobt root, agno %d\n"),
+			levels, agno);
+	}
 
 	bno = be32_to_cpu(agi->agi_root);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
@@ -2392,6 +2409,12 @@ validate_agi(
 	}
 
 	if (xfs_has_finobt(mp)) {
+		levels = be32_to_cpu(agi->agi_free_level);
+		if (levels == 0 || levels > XFS_BTREE_MAXLEVELS) {
+			do_warn(_("bad levels %u for finobt root, agno %d\n"),
+				levels, agno);
+		}
+
 		bno = be32_to_cpu(agi->agi_free_root);
 		if (libxfs_verify_agbno(mp, agno, bno)) {
 			magic = xfs_has_crc(mp) ?

