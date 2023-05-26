Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADC0C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242089AbjEZBpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbjEZBo5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197D0189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2AD164C19
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDD2C433D2;
        Fri, 26 May 2023 01:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065495;
        bh=TaaO8cInoIs+7a4MbvD+iwfvAczbI1t412axd5jHWb0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vDH3c4bUfW4lHhqdNzwgqBhfgKq52FUJfXI96ZZEKaQ7rqbLGnVxSTfR0qXLUVhxr
         KGMooqM+ACCbtLKuV+AcIfjFXFO+sMed7hMgD6QIu34GbnirISjyky5alo7IHpJpnd
         WZ8Ig/iCI/AKkiSjfgMpd65pt76QznMU7kEhAhoE/0jMgjL8L3TezEc1ZQEjCdkLdE
         hFKltrBDFIpChjGIBolhzqnQY0+SeguUK1ID5IFPqglVyHIzG8uM4V4vyQqdc7tBlj
         d6Aydt/0NLhks+y8cgLxOuomIhOe20I1BfgPixTYlr5hkA2x2sJrnAGL4tVE2W7OlM
         uMIgcNUADVIvg==
Date:   Thu, 25 May 2023 18:44:54 -0700
Subject: [PATCH 4/9] xfs_scrub: remove scrub_metadata_file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072074.3743400.14112271437813610211.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
References: <168506072015.3743400.5119599474014297677.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Collapse this function with scrub_meta_type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |    2 +-
 scrub/scrub.c  |   12 ------------
 scrub/scrub.h  |    2 --
 3 files changed, 1 insertion(+), 15 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index bbe61372469..29e242b456f 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -131,7 +131,7 @@ scan_metafile(
 		goto out;
 
 	scrub_item_init_fs(&sri);
-	ret = scrub_metadata_file(ctx, type, &sri);
+	ret = scrub_meta_type(ctx, type, &sri);
 	if (ret) {
 		sctl->aborted = true;
 		goto out;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 77a0da25373..e611e05f527 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -317,18 +317,6 @@ scrub_ag_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_PERAG, sri);
 }
 
-/* Scrub one metadata file */
-int
-scrub_metadata_file(
-	struct scrub_ctx		*ctx,
-	unsigned int			type,
-	struct scrub_item		*sri)
-{
-	ASSERT(xfrog_scrubbers[type].group == XFROG_SCRUB_GROUP_METAFILES);
-
-	return scrub_meta_type(ctx, type, sri);
-}
-
 /* Scrub all FS summary metadata. */
 int
 scrub_summary_metadata(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b584f7ec7de..5c0bb299bac 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -82,8 +82,6 @@ void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
 int scrub_ag_headers(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_ag_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
-int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
-		struct scrub_item *sri);
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct scrub_item *sri);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,

