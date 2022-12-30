Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9025BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbiL3XhP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235583AbiL3Xg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:36:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB491DDDC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69BF761C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA6BC433EF;
        Fri, 30 Dec 2022 23:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443415;
        bh=8DNsGs5A12nnQpSsFv1kAX3oeJZYpnG7kJv1KW1/rhA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ETYwPX4HmQLJavGh1JVJnuEXASDNfYfaYjQJ+jGbbbjljTovYZOakvF95Y6xNtHsa
         KO8cknfRtiU9YGuwbrIQTODGHtREInRglWOE+GJT1a+JMx0S8IZFBAMCcvunBbgMN7
         e0F/cL7R+SE1uCz6GuUJH8VNtHcKPD8A3nz3pPlJPZdEw17XJaljmDPLvE11H5h4IU
         rpY9nb5G8HgCbzULBUZLz7mnRRqNSAN4DjxNRYrczXP6jFZl6rYhHCNOqqLwqi+mjs
         WJtPkFH1Qo3FoT4fzNUIudZXwKXhNF4iTGUz8wrfQuiseTAavEWfSmd9ku3m5g3qdR
         sYZcTXyWv6H4w==
Subject: [PATCH 01/11] xfs: separate the marking of sick and checked metadata
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:14 -0800
Message-ID: <167243839473.695999.10977027234952523208.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Split the setting of the sick and checked masks into separate functions
as part of preparing to add the ability for regular runtime fs code
(i.e. not scrub) to mark metadata structures sick when corruptions are
found.  Improve the documentation of libxfs' requirements for helper
behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h |   16 +++++++++++++-
 fs/xfs/scrub/health.c      |   20 ++++++++++-------
 fs/xfs/xfs_health.c        |   51 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.c         |    5 +++-
 4 files changed, 81 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 5571f6cb2539..aa4771fad505 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -101,24 +101,38 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT)
 
-/* These functions must be provided by the xfs implementation. */
+/*
+ * These functions must be provided by the xfs implementation.  Function
+ * behavior with respect to the first argument should be as follows:
+ *
+ * xfs_*_mark_sick:    set the sick flags and do not set checked flags.
+ * xfs_*_mark_checked: set the checked flags.
+ * xfs_*_mark_healthy: clear the sick flags and set the checked flags.
+ *
+ * xfs_*_measure_sickness: return the sick and check status in the provided
+ * out parameters.
+ */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_checked(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 6749930b50a2..e5cc89d43808 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -144,30 +144,34 @@ xchk_update_health(
 	switch (type_to_health_flag[sc->sm->sm_type].group) {
 	case XHG_AG:
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
-		if (bad)
+		if (bad) {
 			xfs_ag_mark_sick(pag, sc->sick_mask);
-		else
+			xfs_ag_mark_checked(pag, sc->sick_mask);
+		} else
 			xfs_ag_mark_healthy(pag, sc->sick_mask);
 		xfs_perag_put(pag);
 		break;
 	case XHG_INO:
 		if (!sc->ip)
 			return;
-		if (bad)
+		if (bad) {
 			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
-		else
+			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
+		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
 		break;
 	case XHG_FS:
-		if (bad)
+		if (bad) {
 			xfs_fs_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_fs_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	case XHG_RT:
-		if (bad)
+		if (bad) {
 			xfs_rt_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_rt_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	default:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 9cf933a8f532..3ef91601bc2b 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -98,6 +98,18 @@ xfs_fs_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark per-fs metadata as having been checked. */
+void
+xfs_fs_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -141,6 +153,19 @@ xfs_rt_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark realtime metadata as having been checked. */
+void
+xfs_rt_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	trace_xfs_rt_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -184,6 +209,18 @@ xfs_ag_mark_sick(
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark per-ag metadata as having been checked. */
+void
+xfs_ag_mark_checked(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+
+	spin_lock(&pag->pag_state_lock);
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -227,7 +264,6 @@ xfs_inode_mark_sick(
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick |= mask;
-	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 
 	/*
@@ -240,6 +276,19 @@ xfs_inode_mark_sick(
 	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
+/* Mark inode metadata as having been checked. */
+void
+xfs_inode_mark_checked(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_INO_PRIMARY));
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_checked |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
 /* Mark parts of an inode healed. */
 void
 xfs_inode_mark_healthy(
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..31f49211fdd6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -496,8 +496,10 @@ xfs_check_summary_counts(
 	if (xfs_is_clean(mp) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
-	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
+	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount)) {
 		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+		xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
+	}
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -1271,6 +1273,7 @@ xfs_force_summary_recalc(
 		return;
 
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
 }
 
 /*

