Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C42C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbiL3WhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3WhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:37:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CDE18692
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:37:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D62B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67874C433EF;
        Fri, 30 Dec 2022 22:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439840;
        bh=WWNNkmGPQSAXdNTfXgN5KkyjkD0SE4VOGM1zGqsrmSY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TcslaqTDy+BQU3ByaoPDJicRDuTVLssxyvQh6ifgngAI6CD28ZL4EvD2BhyPMVzMO
         8Pe/dEDguh05QLpDHd2JhAvCZhGX/7dWbIt8+5hyN1j4UYg32ek/gyNi6O/AqfAuE1
         5gss8b9L+uLg7pAc41KWKkrvgIGfacpHE+PLpSRVjQQmI1rKg8juRqZWicDhyKDShj
         nv8o7YId/SNRTpgldChEiRdIVBiLas3rI+oSweHZF2vTmDOQ9jHoJTNnffc18dqC34
         wcfj3/CZ7KesGy3eoGC++74fobjHq/FMR6ruefvZiwqGaJU4dVfqVs38DM1y54Yh1t
         0zU40uIYwEITA==
Subject: [PATCH 3/5] xfs: clean up scrub context if scrub setup returns
 -EDEADLOCK
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:07 -0800
Message-ID: <167243826794.683691.10735232030785081091.stgit@magnolia>
In-Reply-To: <167243826744.683691.2061427880010614570.stgit@magnolia>
References: <167243826744.683691.2061427880010614570.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It has been a longstanding convention that online scrub and repair
functions can return -EDEADLOCK to signal that they weren't able to
obtain some necessary resource.  When this happens, the scrub framework
is supposed to release all resources attached to the scrub context, set
the TRY_HARDER flag in the scrub context flags, and try again.  In this
context, individual scrub functions are supposed to take all the
resources they (incorrectly) speculated were not necessary.

We're about to make it so that the functions that lock and wait for a
filesystem AG can also return EDEADLOCK to signal that we need to try
again with the drain waiters enabled.  Therefore, refactor
xfs_scrub_metadata to support this behavior for ->setup() functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 07a7a75f987f..50db13c5f626 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -491,23 +491,16 @@ xfs_scrub_metadata(
 
 	/* Set up for the operation. */
 	error = sc->ops->setup(sc);
+	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
+		goto try_harder;
 	if (error)
 		goto out_teardown;
 
 	/* Scrub for errors. */
 	error = sc->ops->scrub(sc);
-	if (!(sc->flags & XCHK_TRY_HARDER) && error == -EDEADLOCK) {
-		/*
-		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
-		 * Tear down everything we hold, then set up again with
-		 * preparation for worst-case scenarios.
-		 */
-		error = xchk_teardown(sc, 0);
-		if (error)
-			goto out_sc;
-		sc->flags |= XCHK_TRY_HARDER;
-		goto retry_op;
-	} else if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
+	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
+		goto try_harder;
+	if (error || (sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE))
 		goto out_teardown;
 
 	xchk_update_health(sc);
@@ -565,4 +558,15 @@ xfs_scrub_metadata(
 		error = 0;
 	}
 	return error;
+try_harder:
+	/*
+	 * Scrubbers return -EDEADLOCK to mean 'try harder'.  Tear down
+	 * everything we hold, then set up again with preparation for
+	 * worst-case scenarios.
+	 */
+	error = xchk_teardown(sc, 0);
+	if (error)
+		goto out_sc;
+	sc->flags |= XCHK_TRY_HARDER;
+	goto retry_op;
 }

