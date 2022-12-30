Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15E3C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiL3X1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiL3X1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:27:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4D519C20
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:27:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A314EB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52442C433D2;
        Fri, 30 Dec 2022 23:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442855;
        bh=Fgsi1EQILRBYcUddTo8wgqYpXXz5l8IeWGUms0FhD2E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hUEOHpCk4C2ZFTeUSfcczKIzYod6KKv4QA6WcaezC5rPy9LzXxfUDmZ2HgGsCxWN4
         RlUEzvWkqdJWDybDedb7TfHfCT2RELRTYO7+CRKkUUH9LxStvqjnLLAi0oTKUgSIDJ
         3+3JsApeJYyB+bnqQwWTEx2I+WmIQZmHdlG50oorow+KjHVl3YLgcIAnVxhDB3yy+1
         Du2coZMXt6kMfqdQ/YBJmo0CiHv2pjdNOgdWWpz8J8eKUa8htZbF+mANvW1JdqLCMs
         tpwH6yN8u7z+/F3TXSzqlPdPMc03J5mrwP4CKsTsP2mhBxXWNC7olnsCW4C8gjU6OT
         kGjBtsmwyw1YQ==
Subject: [PATCH 1/2] xfs: don't complain about unfixed metadata when repairs
 were injected
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:45 -0800
Message-ID: <167243836552.692955.15678490136490770591.stgit@magnolia>
In-Reply-To: <167243836537.692955.2878906942781441773.stgit@magnolia>
References: <167243836537.692955.2878906942781441773.stgit@magnolia>
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
---
 fs/xfs/scrub/common.h |   12 ++++++++++++
 fs/xfs/scrub/scrub.c  |    7 ++-----
 2 files changed, 14 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 4b2590540be4..92578c4aed13 100644
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
 void xchk_stop_reaping(struct xfs_scrub *sc);
 void xchk_start_reaping(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index fe5faec4d1d2..cda7b55d77a5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -534,15 +534,12 @@ xfs_scrub_metadata(
 
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

