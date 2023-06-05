Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB98C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 15:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbjFEPgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 11:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbjFEPgb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:36:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1D4AD
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:36:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C0BD61E27
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EA4C433EF;
        Mon,  5 Jun 2023 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979384;
        bh=nwz+LfTky6S4f+4HWJWCv9EXDNHEd47FaZwZGHHK9qM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hzbR1nWCRLXELy68RcP7b4oA+iYocLBwP2Fhlc7/OETUEFfConX6X150ZygT5Njo9
         vGdDphmzU3ZerQMJmfhohFq/UThd2SgVPaj7CGHW9BYvkQE1ywbHy9kkNZ1IAfbefU
         amPS3v8M4ItyaC418wXm2qTu/qhGbvsIzD3MM90WYNzLVgf9k0rJo8VRj4ybOmRJFH
         MqbGX5Jne+jy3YmO1hplXSjCYLH6CaddkHKNuZB012dC4GWR+CvOg1sM6Lg12bPFH2
         P1hhTlAIW8HxQ8gb9JEhZfSd2L/+XkUu3yYChrNrX9e9hNKbexXw6ES9lWxrLA7dBn
         Q62/s5pccsJCg==
Subject: [PATCH 3/3] xfs_db: expose the unwritten flag in rmapbt keys
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:36:23 -0700
Message-ID: <168597938358.1225991.7414295770975629345.stgit@frogsfrogsfrogs>
In-Reply-To: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
References: <168597936664.1225991.1267673489846772229.stgit@frogsfrogsfrogs>
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

