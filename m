Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08005C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiLaCc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiLaCcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:32:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B584926D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:32:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39DFB61D13
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966E8C433EF;
        Sat, 31 Dec 2022 02:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453942;
        bh=shbbnvMwfQ1g2b/x0X5SuRE53P/hf8h7ukqJa0GC7L8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FZ+puA8SbyfQqPu13HyEBqAahyHeMwMEc7LvEKW3csosx28WWBrzUtOeR2+JrnjG8
         ot9w7IEfNSUcKM0mqLRPJYTlGjJAOYEsSiYvwWYE2fB4vm4XREqFXmf7c08x7+4Wdl
         SMGTvZP4Nw3KlcnL93HqbHwj+OAXQA0PeUK/t06HOjhzLz3Hb9ykmDR4myVNqBgqUA
         0FepSK7sRsQEVHhYfY/m1FxmgQlszE9mWshgifRgMwzeI18x8Iv3mIwHVNIGIDvWBc
         qLO7n0H5OBYu1rBML4yQKghvQvp68W/4fA/9pf8SdUJjCSXtaALuoSJFD0WYWcgIjP
         QBBSZtP7bFF/Q==
Subject: [PATCH 09/45] xfs: record rt group superblock errors in the health
 system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878482.731133.16012297468628814513.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Record the state of per-rtgroup metadata sickness in the rtgroup
structure for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_health.h  |   28 +++++++++++++++++++++++++++-
 libxfs/xfs_rtgroup.h |    8 ++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 99d53bae9c1..0beb4153a43 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -52,6 +52,7 @@ struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
 struct xfs_da_args;
+struct xfs_rtgroup;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -65,6 +66,7 @@ struct xfs_da_args;
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
 #define XFS_SICK_RT_SUMMARY	(1 << 1)  /* realtime summary */
+#define XFS_SICK_RT_SUPER	(1 << 2)  /* rt group superblock */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -101,7 +103,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_METADIR)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
-				 XFS_SICK_RT_SUMMARY)
+				 XFS_SICK_RT_SUMMARY | \
+				 XFS_SICK_RT_SUPER)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
@@ -176,6 +179,14 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_rgno_mark_sick(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		unsigned int mask);
+void xfs_rtgroup_mark_sick(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_checked(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_mark_healthy(struct xfs_rtgroup *rtg, unsigned int mask);
+void xfs_rtgroup_measure_sickness(struct xfs_rtgroup *rtg, unsigned int *sick,
+		unsigned int *checked);
+
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
@@ -225,6 +236,15 @@ xfs_ag_has_sickness(struct xfs_perag *pag, unsigned int mask)
 	return sick & mask;
 }
 
+static inline bool
+xfs_rtgroup_has_sickness(struct xfs_rtgroup *rtg, unsigned int mask)
+{
+	unsigned int	sick, checked;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	return sick & mask;
+}
+
 static inline bool
 xfs_inode_has_sickness(struct xfs_inode *ip, unsigned int mask)
 {
@@ -246,6 +266,12 @@ xfs_rt_is_healthy(struct xfs_mount *mp)
 	return !xfs_rt_has_sickness(mp, -1U);
 }
 
+static inline bool
+xfs_rtgroup_is_healthy(struct xfs_rtgroup *rtg)
+{
+	return !xfs_rtgroup_has_sickness(rtg, -1U);
+}
+
 static inline bool
 xfs_ag_is_healthy(struct xfs_perag *pag)
 {
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index d8723fabeb5..0e664e2436b 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -23,6 +23,14 @@ struct xfs_rtgroup {
 	/* Number of blocks in this group */
 	xfs_rgblock_t		rtg_blockcount;
 
+	/*
+	 * Bitsets of per-rtgroup metadata that have been checked and/or are
+	 * sick.  Callers should hold rtg_state_lock before accessing this
+	 * field.
+	 */
+	uint16_t		rtg_checked;
+	uint16_t		rtg_sick;
+
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
 	spinlock_t		rtg_state_lock;

