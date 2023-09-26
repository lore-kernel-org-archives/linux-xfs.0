Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604B8E7F14C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:17:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbjI0ARE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbjI0APC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:15:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8CE4EDE
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:35:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F60FC433C7;
        Tue, 26 Sep 2023 23:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771318;
        bh=LwhCM0jBGSq7GhOGwGa4s3e1apuJT8v7hm3P+f2XyDg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aa2E9eCcmjLIlxiCn27YkheqQrDQRhLWX+RmXNuFa0oaj61B7asSEDQPWzYRmWOcu
         1z9r5VMEwHgxaAlHfQwadKOA6L7AAYgyC7pbnOZu7EgmAClQN0hRayenBrwnrWtA/P
         xfE2q1OgyGOTc6FaNtfR0/44UmYHjmH7YA/7EB0gkKacX+E4ylN9uIttTl6R+fy26P
         nYw8Gd+qT0+7FecvAk70EiaLnYFr9V0NFehzJ1mgbpOQxh21EgHZ764LFvJr9cIwxi
         jxb8UuJi5DjMP6R3Vkd0EkpMo+eZJjI+uozxytNpbxxGzjiAdQmfpuUuAVEZ5Syijj
         jmby9GZebTkdw==
Date:   Tue, 26 Sep 2023 16:35:18 -0700
Subject: [PATCH 1/7] xfs: disable online repair quota helpers when quota not
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577060377.3315095.15798405139562658027.stgit@frogsfrogsfrogs>
In-Reply-To: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
References: <169577060353.3315095.13977747715399477216.stgit@frogsfrogsfrogs>
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
index ad1df212ec4c1..18f8d54948f26 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -673,6 +673,7 @@ xrep_find_ag_btree_roots(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -734,6 +735,7 @@ xrep_ino_dqattach(
 
 	return error;
 }
+#endif /* CONFIG_XFS_QUOTA */
 
 /* Initialize all the btree cursors for an AG repair. */
 void
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index cc7ea39427296..93814acc678a8 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -57,8 +57,15 @@ struct xrep_find_ag_btree {
 
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
@@ -87,6 +94,8 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
+#define xrep_ino_dqattach(sc)	(0)
+
 static inline int
 xrep_attempt(
 	struct xfs_scrub	*sc,

