Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB7EC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjEZAvM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239099AbjEZAvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41BB1A8
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F1F615B4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EBBC4339B;
        Fri, 26 May 2023 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062263;
        bh=KTWaOUgi1ZT74Ss0rf4BSXB+f5PKHuRC3LWZNPYrKsc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=EEn00o0olQZFRDdIX2vchf/hw9TvMvsyHYGZvqhWPPsO6i9UUBaKLjkr4SMcJ3EgW
         lOy33yFlUuIS24lT57bCYjSSHwY5rv68ylImVMc/fgUEVkeeQsr8ZRr49UC30SAHxy
         YqBOJB6OgI4KcVHcbpmH8CpJhKjUpUrNJYuR3+AXezdROgECDHbk50/HhU44Q19JJx
         iXjTPNe0Ai83+wpaEL+upRD/121Nm6hck7SqjIgpssrRwhthWhhnGXTl9obN55zKqY
         i7L7d/PbhCr9+gKV1MGl6QDtc8RDBnOXGidynH6S/9svrCJ0Ue9lTWvSEGhHqkZjgv
         DRYrVnyI9rgJA==
Date:   Thu, 25 May 2023 17:51:03 -0700
Subject: [PATCH 1/5] xfs: clear pagf_agflreset when repairing the AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057930.3730229.467052060234390801.stgit@frogsfrogsfrogs>
In-Reply-To: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
References: <168506057909.3730229.17579286342302688368.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the pagf_agflreset flag when we're repairing the AGFL because we
fix all the same padding problems that xfs_agfl_reset does.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d54edd0d8538..4e99e19b2490 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -621,8 +621,11 @@ xrep_agfl_update_agf(
 	xfs_force_summary_recalc(sc->mp);
 
 	/* Update the AGF counters. */
-	if (xfs_perag_initialised_agf(sc->sa.pag))
+	if (xfs_perag_initialised_agf(sc->sa.pag)) {
 		sc->sa.pag->pagf_flcount = flcount;
+		clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET,
+				&sc->sa.pag->pag_opstate);
+	}
 	agf->agf_flfirst = cpu_to_be32(0);
 	agf->agf_flcount = cpu_to_be32(flcount);
 	agf->agf_fllast = cpu_to_be32(flcount - 1);

