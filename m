Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA39EC7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjEZBrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbjEZBrd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:47:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AF719A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:47:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C769264C3E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C32C433D2;
        Fri, 26 May 2023 01:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065651;
        bh=kr7EJog2gwpJmUAylpRqoMDBTABJmcd9U2NDNxgkONY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mgwfzfy7VuQUqKEMXNEe1EGLe1oPmAeh4NN61+Nnz37TBnwNJX8m6ljOHGIqBa1tQ
         Jg0GgpfQedtx7thD9QXomeESqWpQTGBz1m6Uc9Ul6ycRs9iHJDzILFxbsGK78ltyYi
         7HDGmoDMrRQPqGWedbwBE1LDwo+ahXBD32EzpkeJ/UYE1aikWfYamzZ+aVjmN2fCkX
         K6ZsNnYKE18QvMvdsG79/PQP3pKeFs4OAW0yGtuMsyqumL5y7bWulSc2TWE9YCeiqv
         A4DMbxrPqYbeB9VMF1QNUu4FDwk516k59L4YwjiWhK8YhUnyxk++ddMeDzLRho8V57
         1YmBR/M1J7KbQ==
Date:   Thu, 25 May 2023 18:47:30 -0700
Subject: [PATCH 5/5] xfs_scrub: hoist scrub retry loop to
 scrub_item_check_file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072480.3744014.8481844546968154189.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072412.3744014.10740186421005934865.stgit@frogsfrogsfrogs>
References: <168506072412.3744014.10740186421005934865.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For metadata check calls, use the ioctl retry and freeze permission
tracking in scrub_item that we created in the last patch.  This enables
us to move the check retry loop out of xfs_scrub_metadata and into its
caller to remove a long backwards jump, and gets us closer to
vectorizing scrub calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 158ce67cc86..8ceafc36af7 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -88,7 +88,6 @@ xfs_check_metadata(
 	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	struct xfs_scrub_metadata	meta = { };
 	enum xfrog_scrub_group		group;
-	unsigned int			tries = 0;
 	int				error;
 
 	background_sleep();
@@ -116,7 +115,7 @@ xfs_check_metadata(
 	descr_set(&dsc, &meta);
 
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
-retry:
+
 	error = -xfrog_scrub_metadata(xfdp, &meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
 		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
@@ -163,10 +162,8 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && tries < 10) {
-		tries++;
-		goto retry;
-	}
+	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
 	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
@@ -304,6 +301,7 @@ scrub_item_check_file(
 	int				override_fd)
 {
 	struct xfs_fd			xfd;
+	struct scrub_item		old_sri;
 	struct xfs_fd			*xfdp = &ctx->mnt;
 	unsigned int			scrub_type;
 	int				error;
@@ -323,7 +321,14 @@ scrub_item_check_file(
 		if (!(sri->sri_state[scrub_type] & SCRUB_ITEM_NEEDSCHECK))
 			continue;
 
-		error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+		sri->sri_tries[scrub_type] = SCRUB_ITEM_MAX_RETRIES;
+		do {
+			memcpy(&old_sri, sri, sizeof(old_sri));
+			error = xfs_check_metadata(ctx, xfdp, scrub_type, sri);
+			if (error)
+				return error;
+		} while (scrub_item_call_kernel_again(sri, scrub_type,
+					SCRUB_ITEM_NEEDSCHECK, &old_sri));
 
 		/*
 		 * Progress is counted by the inode for inode metadata; for

