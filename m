Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F265C43217
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 00:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbiDKAeL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 20:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240902AbiDKAeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5B3F11C09
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 00D2753ABFA
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEN3-GV
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjm-FX
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/17] xfs: convert ptag flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:44 +1000
Message-Id: <20220411003147.2104423-15-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625376f7
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
 fs/xfs/xfs_error.h   | 20 ++++++++++----------
 fs/xfs/xfs_message.c |  2 +-
 fs/xfs/xfs_message.h |  3 ++-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 5735d5ea87ee..5191e9145e55 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -64,16 +64,16 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
  * XFS panic tags -- allow a call to xfs_alert_tag() be turned into
  *			a panic by setting xfs_panic_mask in a sysctl.
  */
-#define		XFS_NO_PTAG			0
-#define		XFS_PTAG_IFLUSH			0x00000001
-#define		XFS_PTAG_LOGRES			0x00000002
-#define		XFS_PTAG_AILDELETE		0x00000004
-#define		XFS_PTAG_ERROR_REPORT		0x00000008
-#define		XFS_PTAG_SHUTDOWN_CORRUPT	0x00000010
-#define		XFS_PTAG_SHUTDOWN_IOERROR	0x00000020
-#define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
-#define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
-#define		XFS_PTAG_VERIFIER_ERROR		0x00000100
+#define		XFS_NO_PTAG			0u
+#define		XFS_PTAG_IFLUSH			(1u << 0)
+#define		XFS_PTAG_LOGRES			(1u << 1)
+#define		XFS_PTAG_AILDELETE		(1u << 2)
+#define		XFS_PTAG_ERROR_REPORT		(1u << 3)
+#define		XFS_PTAG_SHUTDOWN_CORRUPT	(1u << 4)
+#define		XFS_PTAG_SHUTDOWN_IOERROR	(1u << 5)
+#define		XFS_PTAG_SHUTDOWN_LOGERROR	(1u << 6)
+#define		XFS_PTAG_FSBLOCK_ZERO		(1u << 7)
+#define		XFS_PTAG_VERIFIER_ERROR		(1u << 8)
 
 #define XFS_PTAG_STRINGS \
 	{ XFS_NO_PTAG,			"none" }, \
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index bc66d95c8d4c..c5084dce75cd 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -62,7 +62,7 @@ define_xfs_printk_level(xfs_debug, KERN_DEBUG);
 void
 xfs_alert_tag(
 	const struct xfs_mount	*mp,
-	int			panic_tag,
+	uint32_t		panic_tag,
 	const char		*fmt, ...)
 {
 	struct va_format	vaf;
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index bb9860ec9a93..dee98e9ccc3d 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -11,7 +11,8 @@ void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
 void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(3, 4)
-void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+void xfs_alert_tag(const struct xfs_mount *mp, uint32_t tag,
+		const char *fmt, ...);
 extern __printf(2, 3)
 void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
 extern __printf(2, 3)
-- 
2.35.1

