Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7460FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiL3WyP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3WyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:54:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FD41AA0F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAD20B81BAA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E51C433EF;
        Fri, 30 Dec 2022 22:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440851;
        bh=nwz+LfTky6S4f+4HWJWCv9EXDNHEd47FaZwZGHHK9qM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oh8ALfSSMLEjmukjYyrd0mF8wSpuiyG57jIHlnw38vwG/zolQCgcvEwCTKBbHgo0t
         dxO1B0JshxbKf6kwLp7ZkZ1LbnJI2KZIheYQLIKRyWFk8gSRy+cUecbHWqgs/xchB3
         MrPoAYOaJCTXl6mrQE0mWlxS8LpSYHuBMo2oO2AkG4KKiM8NoJTUaPiqXODw6W8FsB
         pmVl4DsEPlPLrbrepSvLSe8IfTVBwAzvLtt3w6wzVoDT2x5Hqc2iCovw8iYcg6tBYL
         7J0r522Cgj646jtucU97szhchntYJruD6TJJ5MpK3cBdOKl85yMNX6Fog4TqcsQPB8
         WkV7bfeVSghIw==
Subject: [PATCH 4/4] xfs_db: expose the unwritten flag in rmapbt keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834791.692079.13037270095576625243.stgit@magnolia>
In-Reply-To: <167243834739.692079.8979395707061192623.stgit@magnolia>
References: <167243834739.692079.8979395707061192623.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the debugger to expose the "unwritten" flag in rmapbt keys so that
we can simulate an old filesystem writing out bad keys for testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btblock.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/db/btblock.c b/db/btblock.c
index 30f7b5ef955..d5be6adb734 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -770,6 +770,8 @@ const field_t	rmapbt_key_flds[] = {
 	{ "startblock", FLDT_AGBLOCK, OI(KOFF(startblock)), C1, 0, TYP_DATA },
 	{ "owner", FLDT_INT64D, OI(KOFF(owner)), C1, 0, TYP_NONE },
 	{ "offset", FLDT_RFILEOFFD, OI(RMAPBK_OFFSET_BITOFF), C1, 0, TYP_NONE },
+	{ "extentflag", FLDT_REXTFLG, OI(RMAPBK_EXNTFLAG_BITOFF), C1, 0,
+	  TYP_NONE },
 	{ "attrfork", FLDT_RATTRFORKFLG, OI(RMAPBK_ATTRFLAG_BITOFF), C1, 0,
 	  TYP_NONE },
 	{ "bmbtblock", FLDT_RBMBTFLG, OI(RMAPBK_BMBTFLAG_BITOFF), C1, 0,
@@ -777,6 +779,8 @@ const field_t	rmapbt_key_flds[] = {
 	{ "startblock_hi", FLDT_AGBLOCK, OI(HI_KOFF(startblock)), C1, 0, TYP_DATA },
 	{ "owner_hi", FLDT_INT64D, OI(HI_KOFF(owner)), C1, 0, TYP_NONE },
 	{ "offset_hi", FLDT_RFILEOFFD, OI(RMAPBK_OFFSETHI_BITOFF), C1, 0, TYP_NONE },
+	{ "extentflag_hi", FLDT_REXTFLG, OI(RMAPBK_EXNTFLAGHI_BITOFF), C1, 0,
+	  TYP_NONE },
 	{ "attrfork_hi", FLDT_RATTRFORKFLG, OI(RMAPBK_ATTRFLAGHI_BITOFF), C1, 0,
 	  TYP_NONE },
 	{ "bmbtblock_hi", FLDT_RBMBTFLG, OI(RMAPBK_BMBTFLAGHI_BITOFF), C1, 0,

