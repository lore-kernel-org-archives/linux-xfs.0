Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60B6C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiLaA2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLaA2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:28:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B822F1E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:28:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74218B81EAD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB53C433EF;
        Sat, 31 Dec 2022 00:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446498;
        bh=THDiV6lz70du9OdKvWFTE8UhOfrdktdXp1k3ZnBz9pQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jddZzBZ5EAZbw+wy19APHAy06yeLTEHyixBDhCx+xBFo5VH3YvMWskNNoAWUG2uij
         ZJQ8hNwE0K55nKTzBTNK0N6PMHqRBsPpOKGRP9+gytEURDXRqDsig14n3NTTVQgJ5w
         OHykNjunlY6NU/64do1LdMDUNkkxEHwjUzUI0WkFL+wYNcpJEwJZTJKl+GP03qJxSw
         149I6yKz4RV9QM4d8HZxhEm8MN7pIo+8LydhMN6dOM20KncKPtucqweydquzjotuMH
         Y1W2gdtfe9M+K2vHowQJb06nP5pTqc4oQ55MmpI/5eKmSV9WBpAOLSaXq4FeNLCyJu
         NKhVnAYifUIgg==
Subject: [PATCH 4/9] xfs_scrub: remove scrub_metadata_file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869766.715746.17566397921177016618.stgit@magnolia>
In-Reply-To: <167243869711.715746.14725730988345960302.stgit@magnolia>
References: <167243869711.715746.14725730988345960302.stgit@magnolia>
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
index 656eccce449..138f0f8a8f3 100644
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
index 5dd5cf67a8e..b970d1cfe90 100644
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
index e1e70b38b8e..6e34ca2d7b3 100644
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

