Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DDBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiL3X1J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiL3X1F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:27:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EF863C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:27:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D5961C40
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2064BC433EF;
        Fri, 30 Dec 2022 23:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442824;
        bh=uZdj4+pBldl4cB52gibOLnJXZSkA1cBiTzo67XK852Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=D6Pp6i1gBoKgSWVn6j9x/Qe5TNz+IaStpC9aw0bVPX8dZICBlCvUegTkzJ2rAgg8j
         +FQbA4hOEzxcFDRWTPht7dt2Gk4J4CErvj48fxtS38nTm6+4o+9tD+sdzEi9EhnVND
         o77N+/0ioMMMJA8DR5PCuY1HsIxBwiXAwHBY8F91q32NlX9SPxOZz9yhmoUgSuBbDn
         l1vNmFbPUXzIXP1rQe5Ty0UhIhpEB7qLFj/WSFSeZhXAulTeybAsx+aEV2xbYZ3fU0
         MVrynqCJj1v2CSjWePk4IsY2qvVp8CH0N4BP7dFpEyhyt+AEMu4jbRdiUgKNe8DX8N
         DmK0ZkkOozA2Q==
Subject: [PATCH 1/2] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:42 -0800
Message-ID: <167243836229.692856.14915564091962394735.stgit@magnolia>
In-Reply-To: <167243836213.692856.10814391065284832600.stgit@magnolia>
References: <167243836213.692856.10814391065284832600.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

After an online repair function runs for a per-AG metadata structure,
sc->sick_mask is supposed to reflect the per-AG metadata that the repair
function fixed.  Our next move is to re-check the metadata to assess
the completeness of our repair, so we don't want the rebuilt structure
to be excluded from the rescan just because the health system previously
logged a problem with the data structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index f7c5a109615f..f67279ecb69c 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -226,6 +226,16 @@ xchk_ag_btree_healthy_enough(
 		return true;
 	}
 
+	/*
+	 * If we just repaired some AG metadata, sc->sick_mask will reflect all
+	 * the per-AG metadata types that were repaired.  Exclude these from
+	 * the filesystem health query because we have not yet updated the
+	 * health status and we want everything to be scanned.
+	 */
+	if ((sc->flags & XREP_ALREADY_FIXED) &&
+	    type_to_health_flag[sc->sm->sm_type].group == XHG_AG)
+		mask &= ~sc->sick_mask;
+
 	if (xfs_ag_has_sickness(pag, mask)) {
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
 		return false;

