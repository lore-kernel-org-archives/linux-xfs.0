Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A133CC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiL3Xe1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbiL3XeY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:34:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EDB1DF13
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E36EB81DA0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4175AC433EF;
        Fri, 30 Dec 2022 23:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443260;
        bh=cPgakDQsa3A1MwIVvOWOz961tbDhZEHl0i72eRgqYyU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VVuihoBURgTeBTgL1KT8J91ogJ6zt3KxR0CwRNw5iqWD/V6hkqh51ABna3Pkv4zjR
         hwf4vL6R811+rZOHNb7DNl92TQ7OmkyDXuihTBb4C5Yqz3sUXGg2FaxcomGI+MlvaK
         ahnCktqE0BUFnKHvjjM0jg1SaLq81uW/sU/DtVE3OoI/X4eJRZgOWfbJNIQtfS5St2
         3e6ISH/02utTixXqOKV3xocl5dNbTfrcbBj/QNB0pvudKnhR+p32AI7CDVWYBxlYi9
         ufkVOaGkMctoO1e0nmXUXvKOT68o1aUQ6WcGzoVW/FDfX1Zcs62ait5wFahi74ccLd
         GNu5RzS8fJR3Q==
Subject: [PATCH 1/5] xfs: report the health of quota counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:07 -0800
Message-ID: <167243838705.695667.3899535754623623042.stgit@magnolia>
In-Reply-To: <167243838686.695667.4884256571173103690.stgit@magnolia>
References: <167243838686.695667.4884256571173103690.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report the health of quota counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/xfs_health.c        |    1 +
 fs/xfs/xfs_qm.c            |    7 ++++++-
 fs/xfs/xfs_trans_dquot.c   |    2 ++
 5 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 920fd4513fcb..7e86e1db66dd 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 99e796256c5d..1dea286bb157 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -41,6 +41,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_UQUOTA	(1 << 1)  /* user quota */
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
+#define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -72,7 +73,8 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
-				 XFS_SICK_FS_PQUOTA)
+				 XFS_SICK_FS_PQUOTA | \
+				 XFS_SICK_FS_QUOTACHECK)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 72a075bb2c10..cd32f0fc0643 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -280,6 +280,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_UQUOTA,	XFS_FSOP_GEOM_SICK_UQUOTA },
 	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
+	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
 	{ 0, 0 },
 };
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ff53d40a2dae..8356b7500d75 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
+#include "xfs_health.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1392,8 +1393,12 @@ xfs_qm_quotacheck(
 			xfs_warn(mp,
 				"Quotacheck: Failed to reset quota flags.");
 		}
-	} else
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_QUOTACHECK);
+	} else {
 		xfs_notice(mp, "Quotacheck: Done.");
+		xfs_fs_mark_healthy(mp, XFS_SICK_FS_QUOTACHECK);
+	}
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index aa00cf67ad72..968dc7af4fc7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -17,6 +17,7 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -706,6 +707,7 @@ xfs_trans_dqresv(
 error_corrupt:
 	xfs_dqunlock(dqp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	xfs_fs_mark_sick(mp, XFS_SICK_FS_QUOTACHECK);
 	return -EFSCORRUPTED;
 }
 

