Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED9DC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZAuE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjEZAuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42469199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:50:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3AD8615B4
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E252C433D2;
        Fri, 26 May 2023 00:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062201;
        bh=qbhcu6uaHXs7rNX+rkew4Ot0Q/QepaN+xA986eTUEZQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CZ0I8fosZixFicAhl/+rdNiFoBIh22LC5UmbU5l+VLNzxLvHt4B8Gvv2geRiUVO/S
         dPpFwaABgBAQ4XipI/JyUtSUGOXHdyU0ua31Z5JzTl/SbX3sAguge53oiqZFwCIGhS
         86Zk+cs2L5KjGAg0iw/6d6FmMhNNcnSZS0yOxEWZ7935Iq3qnnwjQfPUUC8gZ9QMrJ
         l6Bf0QjW6jP915PRdBnGcn6sGdDQOq9yqApkFeQJjzwA5xM9udhHCDaXqrXNdKjD+l
         Gfd1ca2bBQX1tR+zrB95DusKaFDoOm0B6AaLVKGN4w6cJnYfAuEsbb7cEtXF2s6T4u
         MovoMkKOVnbFw==
Date:   Thu, 25 May 2023 17:50:00 -0700
Subject: [PATCH 1/2] xfs: always rescan allegedly healthy per-ag metadata
 after repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057238.3730021.5815780398185212485.stgit@frogsfrogsfrogs>
In-Reply-To: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
References: <168506057223.3730021.15237048674614006148.stgit@frogsfrogsfrogs>
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
index d2b2a1cb6533..5e2b09ed6e29 100644
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

