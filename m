Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB64C3A59F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiKWRJ4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239241AbiKWRJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EFFDF58
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F93861DF7
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084E7C433D6;
        Wed, 23 Nov 2022 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223363;
        bh=W1HI7Nt87cDLU6WLIkKoYP6/6fdQbPDPlie8zv59qQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m244ulAaImaN3bfyvjwBRH4O/rZAQ0vyLYfysDZs/WQe7Oe3qeSFerey4s1FZYXhx
         XyFP2WVxj4Cpr+LlbjyWZ52c2zzZ3BwcVqs8fdnFwmz73tsJFovr3EhBiaVXuxeiHT
         JB7rkJAXY9E5yX1gmmbPDIuDjNNueOY7nOJNe27l0VXI1LBVnflEzVRTg0o+vMOTSI
         jBzBJriQmAmFTeXukV/eBEIM0ERILVPjSE3L16nr2nH8uoxhQYniI2nuB9nB76H6Yk
         oNnWJ4Vn5bavH48qbcvmxrWYhhLvTv9v4dthY6SHiAe16/ZKf95QlqQERaH8ngkUV6
         NzYG6IT64T7kA==
Subject: [PATCH 5/9] xfs_db: fix printing of reverse mapping record
 blockcounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:09:22 -0800
Message-ID: <166922336259.1572664.1318580687689818471.stgit@magnolia>
In-Reply-To: <166922333463.1572664.2330601679911464739.stgit@magnolia>
References: <166922333463.1572664.2330601679911464739.stgit@magnolia>
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
index 24c6566980f..c563fb0389a 100644
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

