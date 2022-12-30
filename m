Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A107AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiLaBc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiLaBc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:32:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63068DEB7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F291D61CC1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB49C433EF;
        Sat, 31 Dec 2022 01:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450375;
        bh=uK5umrqeFxRtLoDlsiRjf9B+yujrv83N4nm+pdXKqFw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QIhdf/bVl7vfzvz0qtPvkmmY3znAtzW64beRNJ50WYB0K/++QEGoj0JeO+bp2NLlg
         MwDouzP+u4Fs+krItNGXFUXAIeuLULd/kzdDIQsMEzLGEnL3kLRFwD7RO++uMVV9/R
         a9yvXkHKwQ4oxObI+4W3Ih6M03GGHiqnnY8zzUoctkvAy9MJQRcbv5F0ZpnVT9zI3L
         Hx5+VbmwCZiD211GYLpdk9IyjGLG9KkLwMzDwXdhtrav4RYzdgOpVyH2F0NxKuahIl
         79FSkk4Q8IpO4/pt0XerPD40ikeg4Tsw8dsL7zBXakJG5RJlyHnsEzTxkoYhT2T+Ym
         zn+Er/W9o7lrQ==
Subject: [PATCH 21/22] xfs: scrub each rtgroup's portion of the rtbitmap
 separately
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867567.712847.13451659455960114242.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new scrub type code so that userspace can scrub each rtgroup's
portion of the rtbitmap file separately.  This reduces the long tail
latency that results from scanning the entire bitmap all at once, and
prepares us for future patchsets, wherein we'll need to be able to lock
a specific rtgroup so that we can rebuild that rtgroup's part of the
rtbitmap contents from the rtgroup's rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 +-
 fs/xfs/scrub/common.h   |    6 ++++
 fs/xfs/scrub/rtbitmap.c |   73 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.c    |    7 +++++
 fs/xfs/scrub/scrub.h    |    2 +
 fs/xfs/scrub/trace.h    |    4 ++-
 6 files changed, 90 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c12be9dbb59d..7e9d7d7bb40b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -742,9 +742,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_RGSUPER	28	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RGBITMAP	29	/* realtime group bitmap */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 96bb8bc676e7..e83e88b44e5b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -105,10 +105,12 @@ int xchk_setup_parent(struct xfs_scrub *sc);
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
 int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
+int xchk_setup_rgbitmap(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
 # define xchk_setup_rgsuperblock	xchk_setup_nothing
+# define xchk_setup_rgbitmap		xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -166,6 +168,10 @@ void xchk_rt_init(struct xfs_scrub *sc, struct xchk_rt *sr,
 void xchk_rt_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
 
 #ifdef CONFIG_XFS_RT
+
+/* All the locks we need to check an rtgroup. */
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP_SHARED)
+
 int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 		struct xchk_rt *sr, unsigned int rtglock_flags);
 void xchk_rtgroup_unlock(struct xfs_scrub *sc, struct xchk_rt *sr);
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index a50b0580f3d8..d847773e5f66 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -14,10 +14,34 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 
+/* Set us up with the realtime group metadata locked. */
+int
+xchk_setup_rgbitmap(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	error = xchk_install_live_inode(sc, sc->mp->m_rbmip);
+	if (error)
+		return error;
+
+	error = xchk_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	return xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr,
+			XCHK_RTGLOCK_ALL);
+}
+
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rtbitmap(
@@ -105,6 +129,43 @@ xchk_rtbitmap_check_extents(
 	return error;
 }
 
+/* Scrub this group's realtime bitmap. */
+int
+xchk_rgbitmap(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_rtalloc_rec	keys[2];
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	xfs_rtblock_t		rtbno;
+	xfs_rgblock_t		last_rgbno = rtg->rtg_blockcount - 1;
+	int			error;
+
+	/* Sanity check the realtime bitmap size. */
+	if (sc->mp->m_rbmip->i_disk_size !=
+	    XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks)) {
+		xchk_ino_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
+		return 0;
+	}
+
+	/*
+	 * Check only the portion of the rtbitmap that corresponds to this
+	 * realtime group.
+	 */
+	rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, 0);
+	keys[0].ar_startext = xfs_rtb_to_rtxt(sc->mp, rtbno);
+
+	rtbno = xfs_rgbno_to_rtb(sc->mp, rtg->rtg_rgno, last_rgbno);
+	keys[1].ar_startext = xfs_rtb_to_rtxt(sc->mp, rtbno);
+	keys[0].ar_extcount = keys[1].ar_extcount = 0;
+
+	error = xfs_rtalloc_query_range(sc->mp, sc->tp, &keys[0], &keys[1],
+			xchk_rtbitmap_rec, sc);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+
+	return 0;
+}
+
 /* Scrub the realtime bitmap. */
 int
 xchk_rtbitmap(
@@ -128,12 +189,18 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
+	/*
+	 * Each rtgroup checks its portion of the rt bitmap, so if we don't
+	 * have that feature, we have to check the bitmap contents now.
+	 */
+	if (xfs_has_rtgroups(sc->mp))
+		return 0;
+
 	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out;
+		return error;
 
-out:
-	return error;
+	return 0;
 }
 
 /* xref check that the extent is not free in the rtbitmap */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 5e07150e8f14..6066673953cb 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -416,6 +416,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_rtgroups,
 		.repair = xrep_rgsuperblock,
 	},
+	[XFS_SCRUB_TYPE_RGBITMAP] = {	/* realtime group bitmap */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rgbitmap,
+		.scrub	= xchk_rgbitmap,
+		.has	= xfs_has_rtgroups,
+		.repair = xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6e5b96b6db81..48114bda2f4a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -189,10 +189,12 @@ int xchk_parent(struct xfs_scrub *sc);
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
 int xchk_rgsuperblock(struct xfs_scrub *sc);
+int xchk_rgbitmap(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
 # define xchk_rgsuperblock	xchk_nothing
+# define xchk_rgbitmap		xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a88ad16c90db..9a51eb404fae 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -75,6 +75,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGBITMAP);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -105,7 +106,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
-	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
+	{ XFS_SCRUB_TYPE_RGBITMAP,	"rgbitmap" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \

