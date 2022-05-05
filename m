Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99481C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381611AbiEEQIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379571AbiEEQIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE4F5712C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 612F061D05
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28A9C385A8;
        Thu,  5 May 2022 16:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766665;
        bh=TzRFfdLFXz84phwo4T/S7E11CYrzqCmHn0b45bxx2M4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DH6Xbc9KzJj1PmH5SljqKgZdXQXpzOSEKTFmuyfesiXMlOyjAfTvfYGOXU+V7ukmL
         LHMciR7swySyOYr/tMXzeJ09HOloP4XGvqiRKn14Mm7QpMPWzir+XTpBi1GQdHltQD
         OFRs62wFfBP8HdnRabTXDFpgsaZ+UgrBgnvXbczcKrxSAoVCm6ioNgLFaQdAhw97Ai
         WuNzL/V+VF5bLqpEzNjlzNUBu5ZzgqV3BhOp86ev4/cbmJQAzlG5TSTfBDNqO38wQ8
         sYbrMsH1LmsFMwuF8AqbWrW2Q4wCx8ByU+TlFIPbA2mDlWFjtpCjdEmPnPVAgZpelw
         XP3m3sGlslluA==
Subject: [PATCH 2/2] xfs_repair: warn about suspicious btree levels in AG
 headers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:25 -0700
Message-ID: <165176666532.246985.13522676978486453410.stgit@magnolia>
In-Reply-To: <165176665416.246985.13192803422215905607.stgit@magnolia>
References: <165176665416.246985.13192803422215905607.stgit@magnolia>
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
index 4a234ded..5a4b8dbd 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -2261,6 +2261,13 @@ validate_agf(
 {
 	xfs_agblock_t		bno;
 	uint32_t		magic;
+	unsigned int		levels;
+
+	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
+		do_warn(_("bad levels %u for btbno root, agno %d\n"),
+			levels, agno);
+	}
 
 	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
@@ -2274,6 +2281,12 @@ validate_agf(
 			bno, agno);
 	}
 
+	levels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	if (levels == 0 || levels > mp->m_alloc_maxlevels) {
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
 		if (levels == 0 || levels > mp->m_refc_maxlevels) {
 			do_warn(_("bad levels %u for refcountbt root, agno %d\n"),
@@ -2378,6 +2388,13 @@ validate_agi(
 	xfs_agblock_t		bno;
 	int			i;
 	uint32_t		magic;
+	unsigned int		levels;
+
+	levels = be32_to_cpu(agi->agi_level);
+	if (levels == 0 || levels > M_IGEO(mp)->inobt_maxlevels) {
+		do_warn(_("bad levels %u for inobt root, agno %d\n"),
+			levels, agno);
+	}
 
 	bno = be32_to_cpu(agi->agi_root);
 	if (libxfs_verify_agbno(mp, agno, bno)) {
@@ -2392,6 +2409,12 @@ validate_agi(
 	}
 
 	if (xfs_has_finobt(mp)) {
+		levels = be32_to_cpu(agi->agi_free_level);
+		if (levels == 0 || levels > M_IGEO(mp)->inobt_maxlevels) {
+			do_warn(_("bad levels %u for finobt root, agno %d\n"),
+				levels, agno);
+		}
+
 		bno = be32_to_cpu(agi->agi_free_root);
 		if (libxfs_verify_agbno(mp, agno, bno)) {
 			magic = xfs_has_crc(mp) ?

