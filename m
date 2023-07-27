Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B46EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjG0W3d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjG0W3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667DE2D64
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBAA61F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58410C433C8;
        Thu, 27 Jul 2023 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496970;
        bh=xAM1QgNOThs708gNhs8gKtMq77oiS/KDVzXrsB7diWA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Rrte0lOdKUQmB5vw/kZSJfN6H/3ooQ1bh/gRxzfxc7lHMUiYajYnBgDltBVxqgPKd
         SpYNTM0lP9UVk2vtW/s4j/mD6memAOG75QSRkK6oDFBQRjGExRlqmdNSOczOY1vlR4
         VIjfg0uK3eZo3np9+xB5sawWngerqytE3TDg+1gKdJsg0plNpNsurp9s2i3EvBONOS
         L++Sy+MAwTx41iVP8hiIQgo22zqGH3/xzwje7pLh9rMyZSwmQHwf5B6Se0Duv8F5Ch
         tMCke6Rz4KRbAy1erVG3cP8rzei7zPNu1RPKewIIFZ+FWzG5yJWzXnWWG1YrFfrA7P
         jv5KE9XEpkHQg==
Date:   Thu, 27 Jul 2023 15:29:29 -0700
Subject: [PATCH 1/2] xfs: don't complain about unfixed metadata when repairs
 were injected
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049625034.922058.13500878099203996730.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625018.922058.9081185927358791336.stgit@frogsfrogsfrogs>
References: <169049625018.922058.9081185927358791336.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While debugging other parts of online repair, I noticed that if someone
injects FORCE_SCRUB_REPAIR, starts an IFLAG_REPAIR scrub on a piece of
metadata, and the metadata repair fails, we'll log a message about
uncorrected errors in the filesystem.

This isn't strictly true if the scrub function didn't set OFLAG_CORRUPT
and we're only doing the repair because the error injection knob is set.
Repair functions are allowed to abort the entire operation at any point
before committing new metadata, in which case the piece of metadata is
in the same state as it was before.  Therefore, the log message should
be gated on the results of the scrub.  Refactor the predicate and
rearrange the code flow to make this happen.

Note: If the repair function errors out after it commits the new
metadata, the transaction cancellation will shut down the filesystem,
which is an obvious sign of corrupt metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/common.h |   12 ++++++++++++
 fs/xfs/scrub/scrub.c  |    7 ++-----
 2 files changed, 14 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5fe6d661d42d9..4f7cb410904d6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -167,6 +167,18 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+/* Decide if a repair is required. */
+static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT |
+			       XFS_SCRUB_OFLAG_PREEN);
+}
+#else
+# define xchk_needs_repair(sc)		(false)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
 /*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index cd0ecb29c50c6..a2492aae34d4f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -537,15 +537,12 @@ xfs_scrub_metadata(
 
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 	    !(sc->flags & XREP_ALREADY_FIXED)) {
-		bool needs_fix;
+		bool needs_fix = xchk_needs_repair(sc->sm);
 
 		/* Let debug users force us into the repair routines. */
 		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
-			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			needs_fix = true;
 
-		needs_fix = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-						 XFS_SCRUB_OFLAG_XCORRUPT |
-						 XFS_SCRUB_OFLAG_PREEN));
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.

