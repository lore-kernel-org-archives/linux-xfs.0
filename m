Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219B3EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjFPBhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBhV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787382948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 089B5618E1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E6C433C0;
        Fri, 16 Jun 2023 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879439;
        bh=UU7W5EGYsuThFqnkk30hpbT6XoWOo0FotRQrx9BcgKM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EiR3Nj0BwMXMeNPnPDtDbFFOc6kFg1LUt2wSXyEVfkEjOPxQiq5QHPwjQqa/81o+g
         IkmCxOfYDuqBzTxb20iyvwf2bDdmnxWrx/Jc7Vyaf2PXPvW2qbILy7BxOq7CgUwDZI
         sCiRX/gOY1xavvabl/Lz/HBs4bmoRw6VU7l+gqsWc2WxPu1a6YwU+b9doq30TGrdVE
         pVHBupLY0Dz3Rph/m3N50WANRWu8MIRRpAPn2xGRGU8uDYuQYrB/CHEyeNyE1wZ1jh
         4Gnd+MlHdqDO9mQMcZvUdwz/zSo4DiLA5B3PM5XkGX8CWr5lRPjvHedMxELaeoo6gB
         A7Tew7ty+f+Tg==
Subject: [PATCH 4/8] xfs: restore allocation trylock iteration
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     kernel test robot <oliver.sang@intel.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:18 -0700
Message-ID: <168687943874.831530.8009396415791436397.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 00dcd17cfa7f103f7d640ffd34645a2ddab96330

It was accidentally dropped when refactoring the allocation code,
resulting in the AG iteration always doing blocking AG iteration.
This results in a small performance regression for a specific fsmark
test that runs more user data writer threads than there are AGs.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 2edf06a50f5b ("xfs: factor xfs_alloc_vextent_this_ag() for _iterate_ags()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_alloc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 87920191..8d305c3f 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3183,7 +3183,8 @@ xfs_alloc_vextent_check_args(
  */
 static int
 xfs_alloc_vextent_prepare_ag(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	uint32_t		flags)
 {
 	bool			need_pag = !args->pag;
 	int			error;
@@ -3192,7 +3193,7 @@ xfs_alloc_vextent_prepare_ag(
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
 	args->agbp = NULL;
-	error = xfs_alloc_fix_freelist(args, 0);
+	error = xfs_alloc_fix_freelist(args, flags);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
 		if (need_pag)
@@ -3332,7 +3333,7 @@ xfs_alloc_vextent_this_ag(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_size(args);
 
@@ -3376,7 +3377,7 @@ xfs_alloc_vextent_iterate_ags(
 	for_each_perag_wrap_range(mp, start_agno, restart_agno,
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
-		error = xfs_alloc_vextent_prepare_ag(args);
+		error = xfs_alloc_vextent_prepare_ag(args, flags);
 		if (error)
 			break;
 		if (!args->agbp) {
@@ -3542,7 +3543,7 @@ xfs_alloc_vextent_exact_bno(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_exact(args);
 
@@ -3583,7 +3584,7 @@ xfs_alloc_vextent_near_bno(
 	if (needs_perag)
 		args->pag = xfs_perag_grab(mp, args->agno);
 
-	error = xfs_alloc_vextent_prepare_ag(args);
+	error = xfs_alloc_vextent_prepare_ag(args, 0);
 	if (!error && args->agbp)
 		error = xfs_alloc_ag_vextent_near(args);
 

