Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66D4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiATAUy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:20:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58436 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiATAUx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:20:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C57C61506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7430C004E1;
        Thu, 20 Jan 2022 00:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638053;
        bh=dIeexqpe88caIAJzJbbeLds7nA3qMrWytROx26yV18g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RunBXTFJWyhULnPVtkWFMKmzvTkrLP96v7LSkBeBu+Ek6XeEg6/7qA/gGGbodKG8v
         v/CYKcncVc3Zp7D+9VREEhELZthj5bar2rg0ke96PMjhnX0yTCfumRS6z94ucMNput
         Zp7k7OMi4aV+Mm3vuzawCivB+JOUZhadUFT6AJToPct8JpMsL42dYHXg0TqcbmgP8M
         2prI1LgDnsx5mQ0M77s1f4+3fPpk9AnrHeV36RdnwOvV1j8ULCzzfz4k0N+awePe1+
         Z4gJynTp8CAkN/pa8ep98O7eqWossDhtK/OfjziqLDId9sAx0GuwiNOw/sKsQ2k7hG
         w7yk31Vonuq/A==
Subject: [PATCH 38/45] libxfs: use opstate flags and functions for libxfs
 mount options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:52 -0800
Message-ID: <164263805261.860211.1342663364051871462.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the three LIBXFS_MOUNT flags that actually do anything to set
opstate flags in preparation for removing m_flags in a later patch.
Retain the LIBXFS_MOUNT #defines so that libxfs clients can pass them
into libxfs_mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h  |    7 ++++++-
 libxfs/init.c        |   21 ++++++++++++---------
 libxfs/libxfs_priv.h |    2 +-
 repair/xfs_repair.c  |    2 +-
 4 files changed, 20 insertions(+), 12 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 97e27724..52b699f1 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -212,6 +212,9 @@ __XFS_UNSUPP_FEAT(readonly)
 
 /* Operational mount state flags */
 #define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
+#define XFS_OPSTATE_DEBUGGER		1	/* is this the debugger? */
+#define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
+#define XFS_OPSTATE_PERAG_DATA_LOADED	3	/* per-AG data initialized? */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -234,6 +237,9 @@ static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
 }
 
 __XFS_IS_OPSTATE(inode32, INODE32)
+__XFS_IS_OPSTATE(debugger, DEBUGGER)
+__XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
+__XFS_IS_OPSTATE(perag_data_loaded, PERAG_DATA_LOADED)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -249,7 +255,6 @@ __XFS_UNSUPP_OPSTATE(shutdown)
 #define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
 #define LIBXFS_MOUNT_ATTR2		0x0010
 #define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
-#define LIBXFS_MOUNT_PERAG_DATA_LOADED	0x0040
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/init.c b/libxfs/init.c
index ee49aeb8..e9235a35 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -449,7 +449,7 @@ rtmount_init(
 		return -1;
 	}
 
-	if (mp->m_rtdev_targp->bt_bdev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
+	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
 		return -1;
@@ -464,7 +464,7 @@ rtmount_init(
 	/*
 	 * Allow debugger to be run without the realtime device present.
 	 */
-	if (flags & LIBXFS_MOUNT_DEBUGGER)
+	if (xfs_is_debugger(mp))
 		return 0;
 
 	/*
@@ -723,10 +723,13 @@ libxfs_mount(
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
 	xfs_daddr_t		d;
-	bool			debugger = (flags & LIBXFS_MOUNT_DEBUGGER);
 	int			error;
 
 	mp->m_features = xfs_sb_version_to_features(sb);
+	if (flags & LIBXFS_MOUNT_DEBUGGER)
+		xfs_set_debugger(mp);
+	if (flags & LIBXFS_MOUNT_WANT_CORRUPTED)
+		xfs_set_reporting_corruption(mp);
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
@@ -761,7 +764,7 @@ libxfs_mount(
 	d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
 		fprintf(stderr, _("%s: size check failed\n"), progname);
-		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+		if (!xfs_is_debugger(mp))
 			return NULL;
 	}
 
@@ -810,7 +813,7 @@ libxfs_mount(
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
-		if (!debugger)
+		if (!xfs_is_debugger(mp))
 			return NULL;
 	} else
 		libxfs_buf_relse(bp);
@@ -824,7 +827,7 @@ libxfs_mount(
 				0, &bp, NULL)) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
-			if (!debugger)
+			if (!xfs_is_debugger(mp))
 				return NULL;
 		}
 		if (bp)
@@ -852,7 +855,7 @@ libxfs_mount(
 		if (error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
-			if (!debugger)
+			if (!xfs_is_debugger(mp))
 				return NULL;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
@@ -867,7 +870,7 @@ libxfs_mount(
 			progname);
 		exit(1);
 	}
-	mp->m_flags |= LIBXFS_MOUNT_PERAG_DATA_LOADED;
+	xfs_set_perag_data_loaded(mp);
 
 	return mp;
 }
@@ -989,7 +992,7 @@ libxfs_umount(
 	 * Only try to free the per-AG structures if we set them up in the
 	 * first place.
 	 */
-	if (mp->m_flags & LIBXFS_MOUNT_PERAG_DATA_LOADED)
+	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag(mp);
 
 	kmem_free(mp->m_attr_geo);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fd15ed78..2b72751d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -153,7 +153,7 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 } while (0)
 
 #define XFS_WARN_CORRUPT(mp, expr) \
-	( ((mp)->m_flags & LIBXFS_MOUNT_WANT_CORRUPTED) ? \
+	( xfs_is_reporting_corruption(mp) ? \
 	   (printf("%s: XFS_WARN_CORRUPT at %s:%d", #expr, \
 		   __func__, __LINE__), true) : true)
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index abde6fe8..bcd44cd5 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -979,7 +979,7 @@ main(int argc, char **argv)
 
 	/* Spit out function & line on these corruption macros */
 	if (verbose > 2)
-		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
+		xfs_set_reporting_corruption(mp);
 
 	/* Capture the first writeback so that we can set needsrepair. */
 	if (xfs_has_crc(mp))

