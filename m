Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046CBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiL3X2K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiL3X2J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:28:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7F313F32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B65B81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BFCC433EF;
        Fri, 30 Dec 2022 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442886;
        bh=XrQUSJw3IGThz+pKh+ouzTC8pHfPg2xbZfsrSda080c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lpJA1IU/AzkrLX6A3HmRnU4894OEphaEjVGz5ij6zjIBf/qeqWfeun4koF07EqWIS
         f7vIagLlsp/z5AvbIm1Sroa3QDt8w5sFWNLB0mbLxuKcM6ln4MqGGK4tzMLXFugYBx
         t1R8S9AOXGD50myiV2Htr5Etw3CBmE/EQm/VVveM9DgnGJh7nxaMk4Nt8CP2wflyuD
         Ez/TVqN2q3yGh4Hyrfo+rOypbAsvzngeICMV2xw9CxCKJSNHYCB/maTVbcQhNgyi5F
         0MqkjJyuPKNNzJeBzW/QmE6de8Dy+p9kW+0RcZ/8SdN5q/i/SEWTc21Mg8cc11Qex1
         QtMfCpaySp6Gg==
Subject: [PATCH 1/5] xfs: clear pagf_agflreset when repairing the AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:48 -0800
Message-ID: <167243836882.693494.4734082885669214084.stgit@magnolia>
In-Reply-To: <167243836860.693494.7976721071711129282.stgit@magnolia>
References: <167243836860.693494.7976721071711129282.stgit@magnolia>
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
 fs/xfs/scrub/agheader_repair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 377a7a4bda5c..daeb88cf5825 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -620,8 +620,10 @@ xrep_agfl_update_agf(
 	xfs_force_summary_recalc(sc->mp);
 
 	/* Update the AGF counters. */
-	if (sc->sa.pag->pagf_init)
+	if (sc->sa.pag->pagf_init) {
 		sc->sa.pag->pagf_flcount = flcount;
+		sc->sa.pag->pagf_agflreset = false;
+	}
 	agf->agf_flfirst = cpu_to_be32(0);
 	agf->agf_flcount = cpu_to_be32(flcount);
 	agf->agf_fllast = cpu_to_be32(flcount - 1);

