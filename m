Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BD5C4321E
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbiDKAeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiDKAeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D47CEDED4
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A92C853AD3C
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEN8-IM
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjw-HR
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: convert shutdown reasons to unsigned.
Date:   Mon, 11 Apr 2022 10:31:46 +1000
Message-Id: <20220411003147.2104423-17-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=S7XFdT2ykH6ascrGT28A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |  2 +-
 fs/xfs/xfs_log.c   |  2 +-
 fs/xfs/xfs_log.h   |  2 +-
 fs/xfs/xfs_mount.h | 11 +++++------
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 68f74549fa22..e4cc6b7cae0f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -512,7 +512,7 @@ xfs_fs_goingdown(
 void
 xfs_do_force_shutdown(
 	struct xfs_mount *mp,
-	int		flags,
+	uint32_t	flags,
 	char		*fname,
 	int		lnnum)
 {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 499e15b24215..3c216140a1c4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3829,7 +3829,7 @@ xlog_verify_iclog(
 bool
 xlog_force_shutdown(
 	struct xlog	*log,
-	int		shutdown_flags)
+	uint32_t	shutdown_flags)
 {
 	bool		log_error = (shutdown_flags & SHUTDOWN_LOG_IO_ERROR);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index dc1b77b92fc1..3ecf891f34c4 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -140,7 +140,7 @@ void	xfs_log_clean(struct xfs_mount *mp);
 bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
-bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
+bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
 void xlog_use_incompat_feat(struct xlog *log);
 void xlog_drop_incompat_feat(struct xlog *log);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f6dc19de8322..e5629e7c5aaf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -425,16 +425,15 @@ __XFS_IS_OPSTATE(blockgc_enabled, BLOCKGC_ENABLED)
 #define XFS_MAX_IO_LOG		30	/* 1G */
 #define XFS_MIN_IO_LOG		PAGE_SHIFT
 
-#define xfs_is_shutdown(mp)		xfs_is_shutdown(mp)
-void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
+void xfs_do_force_shutdown(struct xfs_mount *mp, uint32_t flags, char *fname,
 		int lnnum);
 #define xfs_force_shutdown(m,f)	\
 	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
 
-#define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
-#define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
-#define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
-#define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
+#define SHUTDOWN_META_IO_ERROR	(1u << 0) /* write attempt to metadata failed */
+#define SHUTDOWN_LOG_IO_ERROR	(1u << 1) /* write attempt to the log failed */
+#define SHUTDOWN_FORCE_UMOUNT	(1u << 2) /* shutdown from a forced unmount */
+#define SHUTDOWN_CORRUPT_INCORE	(1u << 3) /* corrupt in-memory structures */
 
 #define XFS_SHUTDOWN_STRINGS \
 	{ SHUTDOWN_META_IO_ERROR,	"metadata_io" }, \
-- 
2.35.1

