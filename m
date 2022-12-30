Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5FFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiLaAIW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235621AbiLaAIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:08:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA1E1CB3E
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6AB5B81DF4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E0AC433EF;
        Sat, 31 Dec 2022 00:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445298;
        bh=dpExcijH4owY5W0Ytchhrw0Df3tNf3AwOgXN7Nv5ZTQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n0NitUxpUf81Pqbt668wSvxotrBnvRAoowksou05edccOnGxgIFNrfkPIUhn2T48C
         1h+YQlmdf0Z6uX+p9ZP/Tt8m5CrolYxdoynMgx7rOaASG3NJyENLNxpZBK6IuR7Iro
         QC8nfn8STEoZEqqIkfeSNjNGmyEKND6q3peG9qdBG93zd7y96t5esaJ5e1p+LY3YTE
         AgclU8RESW27KBr9naPXHCxXD1RuDaQyG8wxjC/Fuu9U3zxr8AkNR2tizoSyezIaol
         +Lwk7pYRxzNhtjXB8DySHZ4MAfkcy1iIVPgv4S5yADsD5EK/jKM1lWTmUFdn3VsXGb
         sWLxWqSmsO6rA==
Subject: [PATCH 1/3] xfs: report the health of quota counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:29 -0800
Message-ID: <167243864905.708814.1995101291642739144.stgit@magnolia>
In-Reply-To: <167243864892.708814.13943121883358066158.stgit@magnolia>
References: <167243864892.708814.13943121883358066158.stgit@magnolia>
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
 libxfs/xfs_fs.h                 |    1 +
 libxfs/xfs_health.h             |    4 +++-
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 spaceman/health.c               |    4 ++++
 4 files changed, 11 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 920fd4513fc..7e86e1db66d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -195,6 +195,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
+#define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 99e796256c5..1dea286bb15 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
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
diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6b7c83da758..f59a6e8a6a2 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -256,6 +256,9 @@ Free space bitmap for the realtime device.
 .TP
 .B XFS_FSOP_GEOM_SICK_RT_SUMMARY
 Free space summary for the realtime device.
+.TP
+.B XFS_FSOP_GEOM_SICK_QUOTACHECK
+Quota resource usage counters.
 .RE
 
 .SH RETURN VALUE
diff --git a/spaceman/health.c b/spaceman/health.c
index d83c5ccd90d..3318f9d1a7f 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -72,6 +72,10 @@ static const struct flag_map fs_flags[] = {
 		.descr = "realtime summary",
 		.has_fn = has_realtime,
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
+		.descr = "quota counts",
+	},
 	{0},
 };
 

