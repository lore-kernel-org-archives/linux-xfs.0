Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7F0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:35:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiL3Xfl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiL3Xfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:35:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904A61DDF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B6EBB81D97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03309C433D2;
        Fri, 30 Dec 2022 23:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443338;
        bh=Pu9Ns9UQ/pRFIn2XgBi/KX2PnfDAGwuDjmInw3XwECs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PMuoWP8DQEFEfovEttRIIxK6OAXMxYcBV0aC6TfmG0VJt6wQ7D6o044Gg/E1S2iKH
         dyTspTvO3va2ryVW6LM0B0qq/7qFqB8MZo1wTptkLvra4tCTWqqwabB31cvB4no0q6
         xvD6lXhjxMjqCpjQwTGegb3osroqoLvYTUT1pdb+4G92KErAZ6Bitr6cSa/oWO0by4
         u4UiHg11eDezJ0Rc8ohxL4tlhHlYR8WFSFE1oPBCTkW+rTQ/PkCN1wOiL3bXgWOkgY
         MD0PBIxbyeAssYvdmE1Es07lIoXw/MZUaRaRYBqe5aClUtpd6AuGk8UmPC0seEasTx
         1disOhF/RFhYw==
Subject: [PATCH 1/5] xfs: report health of inode link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:10 -0800
Message-ID: <167243839083.695835.7968596515514585676.stgit@magnolia>
In-Reply-To: <167243839062.695835.16105316950703126803.stgit@magnolia>
References: <167243839062.695835.16105316950703126803.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report on the health of the inode link counts.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |    1 +
 fs/xfs/libxfs/xfs_health.h |    4 +++-
 fs/xfs/xfs_health.c        |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6612c89944d0..2f9f13ba75b8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -196,6 +196,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_RT_BITMAP	(1 << 4)  /* realtime bitmap */
 #define XFS_FSOP_GEOM_SICK_RT_SUMMARY	(1 << 5)  /* realtime summary */
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
+#define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 1dea286bb157..5571f6cb2539 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
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
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index cd32f0fc0643..9cf933a8f532 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -281,6 +281,7 @@ static const struct ioctl_sick_map fs_map[] = {
 	{ XFS_SICK_FS_GQUOTA,	XFS_FSOP_GEOM_SICK_GQUOTA },
 	{ XFS_SICK_FS_PQUOTA,	XFS_FSOP_GEOM_SICK_PQUOTA },
 	{ XFS_SICK_FS_QUOTACHECK, XFS_FSOP_GEOM_SICK_QUOTACHECK },
+	{ XFS_SICK_FS_NLINKS,	XFS_FSOP_GEOM_SICK_NLINKS },
 	{ 0, 0 },
 };
 

