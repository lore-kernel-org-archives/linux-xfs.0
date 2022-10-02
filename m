Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E67C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJBS3s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:29:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8E7DFDE
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CA95CE0A24
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B689C433C1;
        Sun,  2 Oct 2022 18:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735383;
        bh=WWNNkmGPQSAXdNTfXgN5KkyjkD0SE4VOGM1zGqsrmSY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ktLJ1hBmQH2KsnPZ8EuwMSwSazqt18vVyvR4uaTyJmqGTQYO/sRDIJUF90bzJEi6z
         FQqxm/KKBsai+GZLfqlJ5Pv1Y7C1R+fBQT0LRcQ2UdNy8CKxKC4psHC6YTMR2rin2b
         yEjAAGE/LPsiV15j2qW3/ssujocM8DUB1DV1hHdBfazNeoqsG/noIUxntL25acf8dA
         j4mi1+REM+mC8mQtzJd0zKZkrBY++/9q5a5xkLBWI5Va+TvZAgdnMP95r0DMQ6Tra+
         dRaEpWP66kcavChQJKI/wjDHtH8uyrI0VPPvfgWFOGMFKvDrLbL43qzU2fUFlPptFr
         ZQOxpTY8qdqiw==
Subject: [PATCH 3/5] xfs: clean up scrub context if scrub setup returns
 -EDEADLOCK
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:59 -0700
Message-ID: <166473479919.1083534.10350621970798840449.stgit@magnolia>
In-Reply-To: <166473479864.1083534.16821762305468128245.stgit@magnolia>
References: <166473479864.1083534.16821762305468128245.stgit@magnolia>
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

