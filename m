Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 743CAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiLaB1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiLaB06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:26:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F191DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA33261CB4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18954C433D2;
        Sat, 31 Dec 2022 01:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450017;
        bh=laDVakxdCBlOBKigu6xTJQU/2Mz0o5c3o3rGv5kape4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J3aZ9PAM1gyuN18Rz0Yqs3GbEvfxHOZVa2rKEuJCGcKgjYmzFOqQkPUjvGnP/oP5j
         S62cfNONQeMTlnXdnOGjQrEXS/rCMqe6ieSf8sE/POOBcQTmOK5v4G8LMmudyCE9HP
         v9mtbaPTqE+Mx+RrD9uEzJp3BHuod8Fu3OZplAQf0I05FnZi5LmHL8u0qphj0ZEj/V
         kPv4UVVC2lWLEMDNFwBmjRRDoT5BaZbBSOLo7grkRmub7f31n8pt6AWLf1vu7pFJ6o
         X7TJdR6P4Y+PHWfPuTfunKdgieY9yj+zm5p1+hVHTAPMsvVzZ2d+EqjZ2aRUCeC+6Q
         9pO7xesBYHTGA==
Subject: [PATCH 1/3] xfs: use separate lock classes for realtime metadata
 inode ILOCKs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866898.712531.18306581093831583878.stgit@magnolia>
In-Reply-To: <167243866880.712531.9794913817759933297.stgit@magnolia>
References: <167243866880.712531.9794913817759933297.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Realtime metadata files are not quite regular files because userspace
can't access the realtime bitmap directly, and because we take the ILOCK
of the rt bitmap file while holding the ILOCK of a realtime file.  The
double nature of inodes confuses lockdep, so up until now we've created
lockdep subclasses to help lockdep keep things straight.

We've gotten away with using lockdep subclasses because there's only two
rt metadata files, but with the coming addition of realtime rmap and
refcounting, we'd need two more subclasses, which is a lot of class bits
to burn on a side feature.

Therefore, switch to manually setting the lockdep class of the rt
metadata ILOCKs.  In the next patch we'll remove the rt-related ILOCK
subclasses.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 11c42ebfa0a5..674ca3dab72e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -26,6 +26,16 @@
 #include "xfs_imeta.h"
 #include "xfs_rtbitmap.h"
 
+/*
+ * Realtime metadata files are not quite regular files because userspace can't
+ * access the realtime bitmap directly, and because we take the ILOCK of the rt
+ * bitmap file while holding the ILOCK of a regular realtime file.  This double
+ * locking confuses lockdep, so create different lockdep classes here to help
+ * it keep things straight.
+ */
+static struct lock_class_key xfs_rbmip_key;
+static struct lock_class_key xfs_rsumip_key;
+
 /*
  * Read and return the summary information for a given extent size,
  * bitmap block combination.
@@ -1342,6 +1352,28 @@ xfs_rtalloc_reinit_frextents(
 	return 0;
 }
 
+static inline int
+__xfs_rt_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct lock_class_key	*lockdep_key,
+	const char		*lockdep_key_name,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+	if (error)
+		return error;
+
+	lockdep_set_class_and_name(&(*ipp)->i_lock.mr_lock, lockdep_key,
+			lockdep_key_name);
+	return 0;
+}
+
+#define xfs_rt_iget(mp, ino, lockdep_key, ipp) \
+	__xfs_rt_iget((mp), (ino), (lockdep_key), #lockdep_key, (ipp))
+
 /*
  * Read in the bmbt of an rt metadata inode so that we never have to load them
  * at runtime.  This enables the use of shared ILOCKs for rtbitmap scans.  Use
@@ -1389,7 +1421,7 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+	error = xfs_rt_iget(mp, mp->m_sb.sb_rbmino, &xfs_rbmip_key,
 			&mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
@@ -1401,7 +1433,7 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_bitmap;
 
-	error = xfs_imeta_iget(mp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+	error = xfs_rt_iget(mp, mp->m_sb.sb_rsumino, &xfs_rsumip_key,
 			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);

