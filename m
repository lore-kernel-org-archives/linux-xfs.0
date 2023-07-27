Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A09EC001DC
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjG0WaI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0WaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33E12696
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48AC361F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E9FC433C8;
        Thu, 27 Jul 2023 22:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497001;
        bh=34UObxOAg6wCNeC19iFfx7StduGEpfWfZw//8kBqBaw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=nPYdhvPjlq4KJXQFAZb2iKHMTSSCTXAjhEvI4RWR+m6N3Gwr/rub5Bgoqzjt+Gy21
         qzBiNuxBSrp88ZrCYDXSxTU+/AJpb+Bt0oM7AL5xNkSvkaPh+XYm2gqQ33Jo0uhKBl
         nrx7FKwyjh35+OgdQVDoY37bR4He3BauKlVcb1BQBurxl6isimedqu4p/crGi1A9iP
         OsxjEsVwek9cFbBm1NhuQk35SpVzRhvBfJ2fbW7rqKWbBpHEUaNgRT6wt3kxVQp+c+
         Hk/scFFk8/gvTHrpa8l06Hwn3+utLpm5BgxRrHpyuUkbYqJXCoSWjYoV2eSWw37816
         kWHY0qsaC3Ksg==
Date:   Thu, 27 Jul 2023 15:30:01 -0700
Subject: [PATCH 1/2] xfs: clear pagf_agflreset when repairing the AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625368.922161.1830641789703263196.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
References: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/agheader_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index d54edd0d8538d..4e99e19b2490d 100644
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

