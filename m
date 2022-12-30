Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52C7C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3X33 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3X31 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:29:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C9813D4C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:29:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6697B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D74EC433EF;
        Fri, 30 Dec 2022 23:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442964;
        bh=G8XBubj0NergYCNQQ9W7RnIGT4bS+UklpcMnx1Pt2Wk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NVQmW1LczESTIL9NhB9dbOqJMRNulYxn06JtyU3c3qHQ1ws/DQhgNTulr7xBj6r5w
         K/LRsqOcHwXudSBhanqR+K7Dgu51JmaE7elZ0d/5Ves6xKvuPu7cIW7AJSkmIkvlog
         UtDG81gJofhPStWZwP6u5NlMFluy7iZZ0k3yNkNdNyLZSf4CRaPvarnOM5TM84qmbx
         AW9NRTlv32OQ300cXTVuNLhjvj5ULtCwBNF75Kdy3j7FBF+xD4atCGH+iN25PKDPXx
         +eNZ7qasiG+w4ObzaqduPKOaSrgUP1r9/Y4OOhqa4euVusLmEeTG0bynXNwWK+Fhyf
         N55gsoXkmCPJQ==
Subject: [PATCH 1/6] xfs: disable online repair quota helpers when quota not
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:52 -0800
Message-ID: <167243837252.694402.13392064475443667155.stgit@magnolia>
In-Reply-To: <167243837231.694402.7473901938296662729.stgit@magnolia>
References: <167243837231.694402.7473901938296662729.stgit@magnolia>
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
index bc5bbff1558e..d9b0d19c8e2d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -674,6 +674,7 @@ xrep_find_ag_btree_roots(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -735,6 +736,7 @@ xrep_ino_dqattach(
 
 	return error;
 }
+#endif /* CONFIG_XFS_QUOTA */
 
 /* Initialize all the btree cursors for an AG repair. */
 void
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e93cae73cf61..441b6b073001 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -48,8 +48,15 @@ struct xrep_find_ag_btree {
 
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
@@ -78,6 +85,8 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
+#define xrep_ino_dqattach(sc)	(0)
+
 static inline int
 xrep_attempt(
 	struct xfs_scrub	*sc)

