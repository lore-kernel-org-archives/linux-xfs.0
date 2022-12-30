Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A188C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiL3XkJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:40:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DC31DF16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDF0BB81DC8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFCEC433EF;
        Fri, 30 Dec 2022 23:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443602;
        bh=YLsCVv4UIUWKufDupGXNubu6fcg22B7Qyu5tQ7QmjPk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oheEfdyFyYuUkXR0cueNQqaex72imZuXAk2/RlXl8GfDqOfwIZ5dbbilAKf0vQyFn
         pRAPT16qLcV6SBgONagrF+W1PmFWlnJuDlUN3K02g+CD0AX+zUWgNnF/Spkm+Rxxf0
         RPNbrZmI81Tw9/OFyEVr4tnssFTHQl/E9JS1UI1jQeQEHWMVsxfWff0xwB0XjB7jD9
         TsMvIOY2BLbzpSEuYmkNZdQ7F8TenILV595izOam4zAWE4Qme90v76bALFfnh3uw1/
         6YFJ7Rv082/u/4VUrPYv1Utiy6bYlOV0SgMdjiJlxxF23t+cPeNax5FjQuamQPXhXR
         /eSlZMBckDo2Q==
Subject: [PATCH 2/3] xfs: remember sick inodes that get inactivated
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:19 -0800
Message-ID: <167243839943.696295.2148192273764409349.stgit@magnolia>
In-Reply-To: <167243839911.696295.17985265962177375571.stgit@magnolia>
References: <167243839911.696295.17985265962177375571.stgit@magnolia>
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
 fs/xfs/xfs_inode.c            |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 7 files changed, 49 insertions(+), 4 deletions(-)


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
index e5cc89d43808..962791c8fafb 100644
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
index 2a1eee807f15..b082222a9061 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1794,6 +1794,33 @@ xfs_inode_needs_inactive(
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
+	xfs_ag_mark_sick(pag, XFS_SICK_AG_INODES);
+	xfs_perag_put(pag);
+}
+
 /*
  * xfs_inactive
  *
@@ -1822,6 +1849,8 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
+	xfs_inactive_health(ip);
+
 	/* If this is a read-only mount, don't do this (would generate I/O) */
 	if (xfs_is_readonly(mp))
 		goto out;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a435ca32f186..145808b733ce 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3921,6 +3921,7 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 	TP_ARGS(ip, flags))
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
+DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
 TRACE_EVENT(xfs_iwalk_ag,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,

