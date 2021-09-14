Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95321C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F022610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhINCok (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235706AbhINCoj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D628606A5;
        Tue, 14 Sep 2021 02:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587402;
        bh=0gUrzyn26X7ZeQ4qwix4Dc84ue5GI9Kj8eM2Vmvyy6k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E4VIgttgt26B4V1ox3TEHpNB8bmCMgf3ErjilIZ2G0s8OX1fbwP2739D9FKnJ5j2b
         I8lctc3jD1S8lF49R5l+qG2QCkZTCaZILdejupDGgx3Mh7+UDNQa2/LWrL+F/V6roW
         keRodOyMGMV2iayPHljCxSfoPio+QJXFDhgnvjVaE+WFwQetne5BPGfcM7LAYH1DWj
         WXy7f44wyrZ8nZjoqxZJ9h+VylbPvjTsZCOM3hH148TkBTG6fpXRfnHw2yN9BTOfU/
         +2gpUk5Z/6pGPU1DCUBAmVbpRj577S9FiOpPVEqNS8a+Y1BEUv0Jv0SPN2m+L+O9k8
         zCYi60/fXy2ZA==
Subject: [PATCH 37/43] libxfs: use opstate flags and functions for libxfs
 mount options
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:22 -0700
Message-ID: <163158740237.1604118.3025907636672209452.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the two LIBXFS_MOUNT flags that actually do anything to set opstate
flags, in preparation for removing m_flags.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h  |    4 ++++
 libxfs/init.c        |   17 ++++++++++-------
 libxfs/libxfs_priv.h |    2 +-
 repair/xfs_repair.c  |    2 +-
 4 files changed, 16 insertions(+), 9 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 29d0440e..1f4f4390 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -213,6 +213,8 @@ __XFS_UNSUPP_FEAT(readonly)
  * XXX: need real atomic bit ops!
  */
 #define XFS_OPSTATE_INODE32		0	/* inode32 allocator active */
+#define XFS_OPSTATE_DEBUGGER		1	/* is this the debugger? */
+#define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -235,6 +237,8 @@ static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
 }
 
 __XFS_IS_OPSTATE(inode32, INODE32)
+__XFS_IS_OPSTATE(debugger, DEBUGGER)
+__XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/libxfs/init.c b/libxfs/init.c
index d36595cf..a96f5389 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -441,7 +441,7 @@ rtmount_init(
 		return -1;
 	}
 
-	if (mp->m_rtdev_targp->bt_bdev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
+	if (mp->m_rtdev_targp->bt_bdev == 0 && !xfs_is_debugger(mp)) {
 		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
 			progname);
 		return -1;
@@ -456,7 +456,7 @@ rtmount_init(
 	/*
 	 * Allow debugger to be run without the realtime device present.
 	 */
-	if (flags & LIBXFS_MOUNT_DEBUGGER)
+	if (xfs_is_debugger(mp))
 		return 0;
 
 	/*
@@ -715,10 +715,13 @@ libxfs_mount(
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
@@ -751,7 +754,7 @@ libxfs_mount(
 	d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
 		fprintf(stderr, _("%s: size check failed\n"), progname);
-		if (!(flags & LIBXFS_MOUNT_DEBUGGER))
+		if (!xfs_is_debugger(mp))
 			return NULL;
 	}
 
@@ -800,7 +803,7 @@ libxfs_mount(
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
-		if (!debugger)
+		if (!xfs_is_debugger(mp))
 			return NULL;
 	} else
 		libxfs_buf_relse(bp);
@@ -814,7 +817,7 @@ libxfs_mount(
 				0, &bp, NULL)) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
 					progname);
-			if (!debugger)
+			if (!xfs_is_debugger(mp))
 				return NULL;
 		}
 		if (bp)
@@ -842,7 +845,7 @@ libxfs_mount(
 		if (error) {
 			fprintf(stderr, _("%s: read of AG %u failed\n"),
 						progname, sbp->sb_agcount);
-			if (!debugger)
+			if (!xfs_is_debugger(mp))
 				return NULL;
 			fprintf(stderr, _("%s: limiting reads to AG 0\n"),
 								progname);
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 3e5ff2a8..3fc13c52 100644
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

