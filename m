Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9D2EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjG0W3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:29:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05F22D63
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A4C061F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEEBC433C7;
        Thu, 27 Jul 2023 22:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496939;
        bh=kYxsWyXd6O/SyMUHPAeK6sejMVX8nD0wmvQ2dLaYqz0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qpJVcXYvz1QkQ27Y33p+/hLmWZC1V8r8BPRqwyKsZPjJHjaUifSh0Icxj/NVv67Ja
         5e0oBWuvlPGz3vT3s17j9G9cTZKwC0Khr+cIpJGAfdfICHPH4HY2hEUMJZuV+3esV2
         oMaOUWyq4CS2zzcm0Bdcs2cgGloZ7t1fC+zTO29SyMBH1bv//+Zsfg3nJGJd921y0l
         R4E14Ug6Zt0Bph8aT61LEznzPz+5NYiLlXPG2QcSBCvnVb5UCKQtcICH/2EaHfDKT1
         tn8jgoA3sNj2YxwMTRspuX+HxMEpxVkSrs8UvcAUTRIn8/FqpUN4ekJXFfDHYy6CCc
         ks3Wj3mCn1VdA==
Date:   Thu, 27 Jul 2023 15:28:58 -0700
Subject: [PATCH 1/2] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624679.921955.5778346578070387516.stgit@frogsfrogsfrogs>
In-Reply-To: <169049624664.921955.12084246901012682213.stgit@frogsfrogsfrogs>
References: <169049624664.921955.12084246901012682213.stgit@frogsfrogsfrogs>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/health.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index d2b2a1cb6533d..5e2b09ed6e29a 100644
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

