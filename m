Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD4FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiLaBjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiLaBjo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697391CFF2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 069E861CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611CAC433EF;
        Sat, 31 Dec 2022 01:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450782;
        bh=G5PUs7g/SF61bdrI7n7idYQ2SbHd+DT4jwMJNkeTWUM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eAzLy5TkHZsdsR5nFC/u9UATDqvCaJmMdODtbKcYW4ZSFRr9CEEFJk71FVOQjkxmo
         9u6zec/Smb7xWG1RbZ/5Y0gzuggj78ir38hozws132SffbbLbSNpZOzmbCMZbyoNWx
         bsHxH3JPRAOmeGKNm/VEk7wh0jR8Cnq/sQPJh9QzrOpD9zeyqSKkz5Bd4wgnfeBgOH
         1LJbQtDewNFr0/Ae74kCli/sH4YzVH/AuHYOUtXK1KCQKid51r1iPb+VwRXkeejUzA
         WNbp+o4dMKDd96ceoWwTSvnIjEuw/LPGq0Vr6HgZH227TETn1Cy3UpuyoqL3GYErmv
         B88u4tHAcSzbw==
Subject: [PATCH 11/38] xfs: attach dquots to rt metadata files when starting
 quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869755.715303.17695593088764549428.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Attach dquots to the realtime metadata files when starting up quotas,
since the resources used by them are charged to the root dquot.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c   |    4 +++-
 fs/xfs/xfs_qm.c      |   20 +++++++++++++++++---
 fs/xfs/xfs_qm_bhv.c  |    2 +-
 fs/xfs/xfs_quota.h   |    4 ++--
 fs/xfs/xfs_rtalloc.c |   19 +++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    3 +++
 6 files changed, 45 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1d2403b93f58..2e64f18deabf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1007,7 +1007,9 @@ xfs_mountfs(
 		ASSERT(mp->m_qflags == 0);
 		mp->m_qflags = quotaflags;
 
-		xfs_qm_mount_quotas(mp);
+		error = xfs_qm_mount_quotas(mp);
+		if (error)
+			goto out_rtunmount;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 905765eedcb0..63085d8b5ec1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -29,6 +29,7 @@
 #include "xfs_health.h"
 #include "xfs_imeta.h"
 #include "xfs_da_format.h"
+#include "xfs_rtalloc.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1486,7 +1487,7 @@ xfs_qm_quotacheck(
  * If we fail here, the mount will continue with quota turned off. We don't
  * need to inidicate success or failure at all.
  */
-void
+int
 xfs_qm_mount_quotas(
 	struct xfs_mount	*mp)
 {
@@ -1525,7 +1526,7 @@ xfs_qm_mount_quotas(
 		error = xfs_qm_quotacheck(mp);
 		if (error) {
 			/* Quotacheck failed and disabled quotas. */
-			return;
+			return 0;
 		}
 	}
 	/*
@@ -1566,8 +1567,21 @@ xfs_qm_mount_quotas(
 
 	if (error) {
 		xfs_warn(mp, "Failed to initialize disk quotas.");
-		return;
+		return 0;
 	}
+
+	/*
+	 * Attach dquots to realtime metadata files before we do anything that
+	 * could alter the resource usage of rt metadata (log recovery, normal
+	 * operation, etc).
+	 */
+	error = xfs_rtmount_dqattach(mp);
+	if (error) {
+		xfs_qm_unmount_quotas(mp);
+		return error;
+	}
+
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 271c1021c733..df569a839d3f 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -119,7 +119,7 @@ xfs_qm_newmount(
 			 * mounting, and get on with the boring life
 			 * without disk quotas.
 			 */
-			xfs_qm_mount_quotas(mp);
+			return xfs_qm_mount_quotas(mp);
 		} else {
 			/*
 			 * Clear the quota flags, but remember them. This
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index fe63489d91b2..0cb52d5be4aa 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -120,7 +120,7 @@ extern void xfs_qm_dqdetach(struct xfs_inode *);
 extern void xfs_qm_dqrele(struct xfs_dquot *);
 extern void xfs_qm_statvfs(struct xfs_inode *, struct kstatfs *);
 extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
-extern void xfs_qm_mount_quotas(struct xfs_mount *);
+int xfs_qm_mount_quotas(struct xfs_mount *mp);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
@@ -205,7 +205,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
 #define xfs_qm_statvfs(ip, s)			do { } while(0)
 #define xfs_qm_newmount(mp, a, b)					(0)
-#define xfs_qm_mount_quotas(mp)
+#define xfs_qm_mount_quotas(mp)						(0)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
 #define xfs_inode_near_dquot_enforcement(ip, type)			(false)
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7a94fb5b5a7f..82b729a86740 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -26,6 +26,7 @@
 #include "xfs_imeta.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_quota.h"
 
 /*
  * Realtime metadata files are not quite regular files because userspace can't
@@ -1686,6 +1687,24 @@ xfs_rtmount_inodes(
 	return error;
 }
 
+/* Attach dquots for realtime metadata files. */
+int
+xfs_rtmount_dqattach(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_qm_dqattach(mp->m_rbmip);
+	if (error)
+		return error;
+
+	error = xfs_qm_dqattach(mp->m_rsumip);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 04931ab1bcac..873ebac239dd 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -46,6 +46,8 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp);
 
+int xfs_rtmount_dqattach(struct xfs_mount *mp);
+
 /*
  * Get the bitmap and summary inodes into the mount structure
  * at mount time.
@@ -104,6 +106,7 @@ xfs_rtmount_init(
 # define xfs_rtfile_convert_unwritten(ip, pos, len)	(0)
 # define xfs_rt_resv_free(mp)				((void)0)
 # define xfs_rt_resv_init(mp)				(0)
+# define xfs_rtmount_dqattach(mp)			(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */

