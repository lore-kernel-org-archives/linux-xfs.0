Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E01AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbiLaA1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiLaA1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:27:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01201E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:27:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E131B81EA6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A99AC433D2;
        Sat, 31 Dec 2022 00:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446436;
        bh=bPNufkI7FgCrl2mtFH/9AgDa31YVGlpOR/zdSoq8Mt4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y1txoOasWEHtjSvwHt4gpVIHGkY+epd8uH17eDTZUBte0WUx4ZfoiYVgj0LVYE2op
         z+bnjFk8guj/rtbbm2eNu3EbTjiqE8ndiCPAkqKhMWKSg7xY6/zBiimMQn1tPgl/vf
         LH6z+cBnpkvnq/Eq8jFBRGaXlcm1JII4ndbAdy0kyO9PSpDw+4ecYG+vm2yWE4+Vtk
         thPIN4z/oW8YDMCVVLT6cGZiBQjGaFyWWqQ30oXKcxyrWPjbJK4Z9laRgQsAmdfgQz
         WhO2JOy6IA2VI1UOLc10A9oZEBJFMQKUxPAD8SdWuljQFlJAMmGcnCt6ax0+ZYe6Gf
         J0fLBRPYQkw1A==
Subject: [PATCH 6/6] xfs_scrub: warn about difficult repairs to rt and quota
 metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:14 -0800
Message-ID: <167243869447.715119.6647883176428105129.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Warn the user if there are problems with the rt or quota metadata that
might make repairs difficult.  For now there aren't any corruption
conditions that would trigger this, but we don't want to leave a gap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 360426c5fb0..a78d15aac1f 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -31,6 +31,25 @@ struct scan_ctl {
 	bool			aborted;
 };
 
+/* Warn about the types of mutual inconsistencies that may make repairs hard. */
+static inline void
+warn_repair_difficulties(
+	struct scrub_ctx	*ctx,
+	unsigned int		difficulty,
+	const char		*descr)
+{
+	if (!(difficulty & REPAIR_DIFFICULTY_SECONDARY))
+		return;
+	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+		return;
+
+	if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
+		str_info(ctx, descr, _("Corrupt primary and secondary metadata."));
+	else
+		str_info(ctx, descr, _("Corrupt secondary metadata."));
+	str_info(ctx, descr, _("Filesystem might not be repairable."));
+}
+
 /* Scrub each AG's metadata btrees. */
 static void
 scan_ag_metadata(
@@ -80,18 +99,7 @@ scan_ag_metadata(
 	 */
 	difficulty = action_list_difficulty(&alist);
 	action_list_find_mustfix(&alist, &immediate_alist);
-
-	if ((difficulty & REPAIR_DIFFICULTY_SECONDARY) &&
-	    !debug_tweak_on("XFS_SCRUB_FORCE_REPAIR")) {
-		if (difficulty & REPAIR_DIFFICULTY_PRIMARY)
-			str_info(ctx, descr,
-_("Corrupt primary and secondary block mapping metadata."));
-		else
-			str_info(ctx, descr,
-_("Corrupt secondary block mapping metadata."));
-		str_info(ctx, descr,
-_("Filesystem might not be repairable."));
-	}
+	warn_repair_difficulties(ctx, difficulty, descr);
 
 	/* Repair (inode) btree damage. */
 	ret = action_list_process_or_defer(ctx, agno, &immediate_alist);
@@ -115,6 +123,7 @@ scan_metafile(
 	struct action_list	alist;
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct scan_ctl		*sctl = arg;
+	unsigned int		difficulty;
 	int			ret;
 
 	if (sctl->aborted)
@@ -127,6 +136,10 @@ scan_metafile(
 		goto out;
 	}
 
+	/* Complain about metadata corruptions that might not be fixable. */
+	difficulty = action_list_difficulty(&alist);
+	warn_repair_difficulties(ctx, difficulty, xfrog_scrubbers[type].descr);
+
 	action_list_defer(ctx, 0, &alist);
 
 out:

