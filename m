Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6207C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiL3X1X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3X1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:27:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0E719C20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15066B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF73C433D2;
        Fri, 30 Dec 2022 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442839;
        bh=9/84iOvu/gKIsbcTJSZYjdLd1ivSrb8eDP5IEZ/Dg/4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b7fdeGhkvDDyMyrBotcQcDChZlCzOaK8Ic23IMWnFrK+RJWxKSOU1TRAoHR8F03lG
         3Kj95B1Rs3qxWw/ypprUzsSqkvrejfSZVgBdb0vUC0r8ipfl7WVjMePoBN4pSPUwId
         TgZ0MvcTfWy2Uz77TsNBjirzCIQYlRGzoEKZAEvXjNrxzM3ivTbbaaxt0/xFLPkSnb
         0dFoFTkruudFCo0T9ZBoW4qc+1slSkVzWe4rVCK809lY4UMLiIkPvwN+DcnqqTGibd
         YVnW5uRLQULzx+KRzv3EFZQsByTS/Ud8drIAyoeZjRvkka+khaBdGmOwPG1e+ZjrT3
         wvbP0cFmTkjvA==
Subject: [PATCH 2/2] xfs: allow the user to cancel repairs before we start
 writing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:42 -0800
Message-ID: <167243836243.692856.10000272539073209572.stgit@magnolia>
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

All online repair functions have the same structure: walk filesystem
metadata structures gathering enough data to rebuild the structure,
stage a new copy, and then commit the new copy.

The gathering steps do not write anything to disk, so they are peppered
with xchk_should_terminate calls to avoid softlockup warnings and to
provide an opportunity to abort the repair (by killing xfs_scrub).
However, it's not clear in the code base when is the last chance to
abort cleanly without having to undo a bunch of structure.

Therefore, add one more call to xchk_should_terminate (along with a
comment) providing the sysadmin with the ability to abort before it's
too late and to make it clear in the source code when it's no longer
convenient or safe to abort a repair.   As there are only four repair
functions right now, this patch exists more to establish a precedent for
subsequent additions than to deliver practical functionality.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 5140f52fa9a1..377a7a4bda5c 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -50,6 +50,10 @@ xrep_superblock(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Copy AG 0's superblock to this one. */
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
@@ -424,6 +428,10 @@ xrep_agf(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Start rewriting the header and implant the btrees we found. */
 	xrep_agf_init_header(sc, agf_bp, &old_agf);
 	xrep_agf_set_roots(sc, agf, fab);
@@ -748,6 +756,10 @@ xrep_agfl(
 	if (error)
 		goto err;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err;
+
 	/*
 	 * Update AGF and AGFL.  We reset the global free block counter when
 	 * we adjust the AGF flcount (which can fail) so avoid updating any
@@ -995,6 +1007,10 @@ xrep_agi(
 	if (error)
 		return error;
 
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
 	/* Start rewriting the header and implant the btrees we found. */
 	xrep_agi_init_header(sc, agi_bp, &old_agi);
 	xrep_agi_set_roots(sc, agi, fab);

