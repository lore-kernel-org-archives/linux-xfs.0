Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B40C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKICFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKICFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2608C57B65
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:05:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC5FB81CD7
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8633AC433D6;
        Wed,  9 Nov 2022 02:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959528;
        bh=nD7fLq3AxZvWdmidicP7ETlMCazJRaK9kgjujLxxzdg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b8W5yTEKS3ow+4QAiTSR7HBHXRnZFCRRx0BJBf+bmZYp3GMLDNPcumPRUWYSXlm1o
         s2PbaUYXgoctspUhNfEJMtpmFMd/L+JBre1Q7wtTEsxgBFl1lelZ+A8lXRnbhKHm6V
         dljNEgh/f9Q0AQiqjTYDSvn69pNxfXVqwQq5/hcjYaPSQmpPS8MwLminEUMeEnyTPp
         0bkjAXGO0j9sYI+Gro1OZW237bd0tJrfH1RjYH4cAgClKGQk3XJEcpr5NvOmRB4zRo
         TW/Rm5qmUSCiBMERDfvV6qgRpLG7oLoOr7h6S3lzD2q0vlpIhhqZ8KdeXnXr+Dze9v
         ZxnE6ijIlhu4Q==
Subject: [PATCH 5/7] xfs_db: fix printing of reverse mapping record
 blockcounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:05:28 -0800
Message-ID: <166795952805.3761353.10222029310244625406.stgit@magnolia>
In-Reply-To: <166795950005.3761353.14062544433865007925.stgit@magnolia>
References: <166795950005.3761353.14062544433865007925.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

FLDT_EXTLEN is the correct type for a 32-bit block count within an AG;
FLDT_REXTLEN is the type for a 21-bit file mapping block count.  This
code should have been using the first type, not the second.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/btblock.c b/db/btblock.c
index 24c6566980..c563fb0389 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -727,7 +727,7 @@ const field_t	rmapbt_key_flds[] = {
 
 const field_t	rmapbt_rec_flds[] = {
 	{ "startblock", FLDT_AGBLOCK, OI(RMAPBT_STARTBLOCK_BITOFF), C1, 0, TYP_DATA },
-	{ "blockcount", FLDT_REXTLEN, OI(RMAPBT_BLOCKCOUNT_BITOFF), C1, 0, TYP_NONE },
+	{ "blockcount", FLDT_EXTLEN, OI(RMAPBT_BLOCKCOUNT_BITOFF), C1, 0, TYP_NONE },
 	{ "owner", FLDT_INT64D, OI(RMAPBT_OWNER_BITOFF), C1, 0, TYP_NONE },
 	{ "offset", FLDT_RFILEOFFD, OI(RMAPBT_OFFSET_BITOFF), C1, 0, TYP_NONE },
 	{ "extentflag", FLDT_REXTFLG, OI(RMAPBT_EXNTFLAG_BITOFF), C1, 0,

