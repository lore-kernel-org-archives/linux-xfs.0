Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE21EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbjG0Wcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjG0Wcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0530DA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B6E361F5C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9C6C433CB;
        Thu, 27 Jul 2023 22:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497143;
        bh=o/DyvpJ95RitaS0DZ40yRLJNZd1NYADzDdWWlZfX2wg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OgF2ya61xTn1yMq11JVINXIOPDEvBIXMf3DSKd9DcypT7dXOvwCP0jFchb2FHTT1x
         95qJzi1Ed7xDYVh5OICK+Q1U9VkEeOzUncwX/a8O7cmyLjeSkUp/kqrQrtD5ijX3iD
         GdlR306gBuDQkXISkeOvG/ubIOdTbmEoOecy7nJ+icxfUs041fPwRmDFuGxSUjPcct
         PJLGTZWqTHk53Jj5xbUp/HfUPXNLc8Kb5nKotPBjvh8FFCAREVnIeqPaDuWAwJDG/T
         F/GtcvrZ13oAkGTSAznwiNUzMe07+Bg7yfKkjL7lugdKAlEjPovHYfN9t+U2Df9KfT
         Kc3hY7p8kQhzw==
Date:   Thu, 27 Jul 2023 15:32:22 -0700
Subject: [PATCH 1/6] xfs: disable online repair quota helpers when quota not
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626454.922543.2001531838833734673.stgit@frogsfrogsfrogs>
In-Reply-To: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
References: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't compile the quota helper functions if quota isn't being built into
the XFS module.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    2 ++
 fs/xfs/scrub/repair.h |    9 +++++++++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 9e336ab249535..546e8423a9165 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -683,6 +683,7 @@ xrep_find_ag_btree_roots(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -744,6 +745,7 @@ xrep_ino_dqattach(
 
 	return error;
 }
+#endif /* CONFIG_XFS_QUOTA */
 
 /* Initialize all the btree cursors for an AG repair. */
 void
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 42325305d29d9..ac8f0200b2963 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -50,8 +50,15 @@ struct xrep_find_ag_btree {
 
 int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
+
+#ifdef CONFIG_XFS_QUOTA
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+#else
+# define xrep_force_quotacheck(sc, type)	((void)0)
+# define xrep_ino_dqattach(sc)			(0)
+#endif /* CONFIG_XFS_QUOTA */
+
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
@@ -80,6 +87,8 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
+#define xrep_ino_dqattach(sc)	(0)
+
 static inline int
 xrep_attempt(
 	struct xfs_scrub	*sc,

