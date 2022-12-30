Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64833C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiLaAJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbiLaAJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:09:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DB31E3CA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1BC9B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C250C433D2;
        Sat, 31 Dec 2022 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445376;
        bh=jkJrPfaiuHL8SBWQKChxqj0T+/zKQ1+mSK3c1KjOeyE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PFUFj/S7XsxESHLJt6oVQZdglQlh4Y7khhHSOYvpyCIn9cR58i4kFRUzmezx7d41e
         qcBcLVD6SNu6DCUmHqHHpnNVJj0blegShv2hj2XmgCth9+uNk0S/JEegIl/+aUIOCZ
         KYVBXXsQLu9IaGMZvP6Cp59lnyEHxQkRiFshJmiIxznrpBEbw7wrXIKn2mUf25bo7Y
         qgl/xibNXMf7NWl8uCtllqjwl8CDlR1jOesL5KzF27tZmy018vAacC2K+gkXUjNRkT
         prJ7kWfAGdxl4rBt00BpGrFRw0a5pPukvas23/sA7CbPxCMq50HYk64jUJ9Qkq330t
         92hiNbc7XGM9g==
Subject: [PATCH 1/3] xfs: report inode link count health
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:35 -0800
Message-ID: <167243865515.709394.17529757205831816215.stgit@magnolia>
In-Reply-To: <167243865502.709394.13215707195694339795.stgit@magnolia>
References: <167243865502.709394.13215707195694339795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report the health of inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h     |    1 +
 libxfs/xfs_health.h |    4 +++-
 spaceman/health.c   |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 6612c89944d..2f9f13ba75b 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 1dea286bb15..5571f6cb253 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -42,6 +42,7 @@ struct xfs_fsop_geom;
 #define XFS_SICK_FS_GQUOTA	(1 << 2)  /* group quota */
 #define XFS_SICK_FS_PQUOTA	(1 << 3)  /* project quota */
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
+#define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -74,7 +75,8 @@ struct xfs_fsop_geom;
 				 XFS_SICK_FS_UQUOTA | \
 				 XFS_SICK_FS_GQUOTA | \
 				 XFS_SICK_FS_PQUOTA | \
-				 XFS_SICK_FS_QUOTACHECK)
+				 XFS_SICK_FS_QUOTACHECK | \
+				 XFS_SICK_FS_NLINKS)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)
diff --git a/spaceman/health.c b/spaceman/health.c
index 3318f9d1a7f..88b12c0b0ea 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -76,6 +76,10 @@ static const struct flag_map fs_flags[] = {
 		.mask = XFS_FSOP_GEOM_SICK_QUOTACHECK,
 		.descr = "quota counts",
 	},
+	{
+		.mask = XFS_FSOP_GEOM_SICK_NLINKS,
+		.descr = "inode link counts",
+	},
 	{0},
 };
 

