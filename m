Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C106DC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjEZBDf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjEZBDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:03:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABED125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFCC2647D0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D628C433D2;
        Fri, 26 May 2023 01:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063013;
        bh=ngAEvAd8wnyzLzdvjRou4hhjZUuT0BYahffLzpa1On0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d3XYa5vIX91AAQcKn3YysFZF8c1TzaWC2vnKM69UGEpvBP1oEAQmfx9bUSdhTxj4L
         YUzVkXIdPqBdcwosDtDUgZW+haQ6J58cWkaK+NYoUDlVUSMwxWSJDy1VX5jrXA/YZQ
         +c+kR45oughuaW9ywR4BJzpC3rGdhEYYRiPFRU2tlmbWA2olC6Yx+N2bO0Kx1V94Ew
         g7pvOU54pgYpffsbEZyRWP8QQ8oXaSiz5+6PLDX79offENs1vNN1MC0OCeSdvEO+wV
         mx5YrJJvxfYNU0IMlfpbI2jFX+M+BhjoClAci6vvi1D2wS8EmwCQPux4HlHIS3oRPZ
         IAUASHtq0vXZQ==
Date:   Thu, 25 May 2023 18:03:32 -0700
Subject: [PATCH 2/3] xfs: remember sick inodes that get inactivated
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506061173.3732817.16969401568774101269.stgit@frogsfrogsfrogs>
In-Reply-To: <168506061141.3732817.12069555992432067658.stgit@frogsfrogsfrogs>
References: <168506061141.3732817.12069555992432067658.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an unhealthy inode gets inactivated, remember this fact in the
per-fs health summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h        |    1 +
 fs/xfs/libxfs/xfs_health.h    |    7 +++++--
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
 fs/xfs/scrub/health.c         |   12 +++++++++++-
 fs/xfs/xfs_health.c           |    1 +
 fs/xfs/xfs_inode.c            |   35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 7 files changed, 55 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 3885c56078f5..417cf85c0f70 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -292,6 +292,7 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_AG_GEOM_SICK_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
+#define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b3733f756bb2..252334bc0488 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -76,6 +76,7 @@ struct xfs_da_args;
 #define XFS_SICK_AG_FINOBT	(1 << 7)  /* free inode index */
 #define XFS_SICK_AG_RMAPBT	(1 << 8)  /* reverse mappings */
 #define XFS_SICK_AG_REFCNTBT	(1 << 9)  /* reference counts */
+#define XFS_SICK_AG_INODES	(1 << 10) /* inactivated bad inodes */
 
 /* Observable health issues for inode metadata. */
 #define XFS_SICK_INO_CORE	(1 << 0)  /* inode core */
@@ -86,6 +87,8 @@ struct xfs_da_args;
 #define XFS_SICK_INO_XATTR	(1 << 5)  /* extended attributes */
 #define XFS_SICK_INO_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_SICK_INO_PARENT	(1 << 7)  /* parent pointers */
+/* Don't propagate sick status to ag health summary during inactivation */
+#define XFS_SICK_INO_FORGET	(1 << 8)
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -122,12 +125,12 @@ struct xfs_da_args;
 #define XFS_SICK_FS_SECONDARY	(0)
 #define XFS_SICK_RT_SECONDARY	(0)
 #define XFS_SICK_AG_SECONDARY	(0)
-#define XFS_SICK_INO_SECONDARY	(0)
+#define XFS_SICK_INO_SECONDARY	(XFS_SICK_INO_FORGET)
 
 /* Evidence of health problems elsewhere. */
 #define XFS_SICK_FS_INDIRECT	(0)
 #define XFS_SICK_RT_INDIRECT	(0)
-#define XFS_SICK_AG_INDIRECT	(0)
+#define XFS_SICK_AG_INDIRECT	(XFS_SICK_AG_INODES)
 #define XFS_SICK_INO_INDIRECT	(0)
 
 /* All health masks. */
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 992ce2d5b9d0..454f40b29249 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -139,7 +139,7 @@ xfs_imap_to_bp(
 			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
-				XFS_SICK_AG_INOBT);
+				XFS_SICK_AG_INODES);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index d09a354e2351..09569b8289d5 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -155,7 +155,17 @@ xchk_update_health(
 		if (!sc->ip)
 			return;
 		if (bad) {
-			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
+			unsigned int	mask = sc->sick_mask;
+
+			/*
+			 * If we're coming in for repairs then we don't want
+			 * sickness flags to propagate to the incore health
+			 * status if the inode gets inactivated before we can
+			 * fix it.
+			 */
+			if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+				mask |= XFS_SICK_INO_FORGET;
+			xfs_inode_mark_sick(sc->ip, mask);
 			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
 		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index e1c7fe898161..74a4620d763b 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -415,6 +415,7 @@ static const struct ioctl_sick_map ag_map[] = {
 	{ XFS_SICK_AG_FINOBT,	XFS_AG_GEOM_SICK_FINOBT },
 	{ XFS_SICK_AG_RMAPBT,	XFS_AG_GEOM_SICK_RMAPBT },
 	{ XFS_SICK_AG_REFCNTBT,	XFS_AG_GEOM_SICK_REFCNTBT },
+	{ XFS_SICK_AG_INODES,	XFS_AG_GEOM_SICK_INODES },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 70506b1ed022..167d10c614ec 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1745,6 +1745,39 @@ xfs_inode_needs_inactive(
 	return xfs_can_free_eofblocks(ip, true);
 }
 
+/*
+ * Save health status somewhere, if we're dumping an inode with uncorrected
+ * errors and online repair isn't running.
+ */
+static inline void
+xfs_inactive_health(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	unsigned int		sick;
+	unsigned int		checked;
+
+	xfs_inode_measure_sickness(ip, &sick, &checked);
+	if (!sick)
+		return;
+
+	trace_xfs_inode_unfixed_corruption(ip, sick);
+
+	if (sick & XFS_SICK_INO_FORGET)
+		return;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	if (!pag) {
+		/* There had better still be a perag structure! */
+		ASSERT(0);
+		return;
+	}
+
+	xfs_ag_mark_sick(pag, XFS_SICK_AG_INODES);
+	xfs_perag_put(pag);
+}
+
 /*
  * xfs_inactive
  *
@@ -1773,6 +1806,8 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
+	xfs_inactive_health(ip);
+
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (xfs_is_readonly(mp))
 		goto out;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f2dcf9d599c1..e57bf37d4993 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3954,6 +3954,7 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 	TP_ARGS(ip, flags))
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
 TRACE_EVENT(xfs_iwalk_ag,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

