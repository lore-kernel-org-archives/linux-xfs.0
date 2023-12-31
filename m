Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB12BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DeZdnob5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8D6C433C7;
	Sun, 31 Dec 2023 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054395;
	bh=YfvnMkmO5S1jqw2AMHEiO0JgRuy8rqoFUIinltLN2uY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DeZdnob5bUjniES/u5Wg8GpBhUqsOoyvu9UsLxZlA+BmgtaNs9Z0sc9cHQ0ihNV/H
	 lq174VJIskqI7EgMv6ETPrYyJ5Qhqe5/jCdPYNajPJqMrco+QIpztpZduulBaAwrye
	 6I5kBcdPXlM9u65xZ8TeGCepcvQS3LFR4IrwCA4+YHvG09Rh0ljE4ZdNeGeUvJoEOt
	 L/ef/I3GT1juxK8h/SZThKGCsb0FEdiG2bKKYfoegNUtaC8Uta2VsZ8MCE4KKbQFwq
	 n7QXwEIwotCDhzMq19HCnNsORlO09aQ3iyU+wlk+ERl3tBzgXoAOWAbgnLRbD1qXSr
	 Q68pALQoct4Bg==
Date: Sun, 31 Dec 2023 12:26:35 -0800
Subject: [PATCH 09/25] xfs: create a log incompat flag for atomic extent
 swapping
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833283.1750288.17935435131106303748.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a log incompat flag so that we only attempt to process swap
extent log items if the filesystem supports it, and a geometry flag to
advertise support if it's present.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h  |    6 +++
 fs/xfs/libxfs/xfs_fs.h      |    3 ++
 fs/xfs/libxfs/xfs_sb.c      |    3 ++
 fs/xfs/libxfs/xfs_swapext.h |   75 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_swapext.h


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4baafff619789..c0209bd21dba1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -391,6 +391,12 @@ xfs_sb_has_incompat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed Attributes */
+
+/*
+ * Log contains SXI log intent items which are not otherwise protected by
+ * an INCOMPAT/RO_COMPAT feature flag.
+ */
+#define XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT  (1U << 31)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
 	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ec92e6ded6b8b..63a145e50350b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -240,6 +240,9 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt btree counter */
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 
+/* atomic file extent swap available to userspace */
+#define XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP	(1U << 31)
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7f2a5aee0ab83..5de377c2b0fea 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -26,6 +26,7 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_swapext.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1258,6 +1259,8 @@ xfs_fs_geometry(
 	}
 	if (xfs_has_large_extent_counts(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
+	if (xfs_atomic_swap_supported(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATOMIC_SWAP;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
diff --git a/fs/xfs/libxfs/xfs_swapext.h b/fs/xfs/libxfs/xfs_swapext.h
new file mode 100644
index 0000000000000..01bb3271f6474
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_swapext.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SWAPEXT_H_
+#define __XFS_SWAPEXT_H_ 1
+
+/*
+ * Decide if this filesystem supports the minimum feature set required to use
+ * the swapext iteration code in non-atomic swap mode.  This mode uses the
+ * BUI log items introduced for the rmapbt and reflink features, but does not
+ * use swapext log items to track progress over a file range.
+ */
+static inline bool
+xfs_swapext_supports_nonatomic(
+	struct xfs_mount	*mp)
+{
+	return xfs_has_reflink(mp) || xfs_has_rmapbt(mp);
+}
+
+/*
+ * Decide if this filesystem has a new enough permanent feature set to protect
+ * swapext log items from being replayed on a kernel that does not have
+ * XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT set.
+ */
+static inline bool
+xfs_swapext_can_use_without_log_assistance(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_is_v5(&mp->m_sb))
+		return false;
+
+	if (xfs_sb_has_incompat_feature(&mp->m_sb,
+				~(XFS_SB_FEAT_INCOMPAT_FTYPE |
+				  XFS_SB_FEAT_INCOMPAT_SPINODES |
+				  XFS_SB_FEAT_INCOMPAT_META_UUID |
+				  XFS_SB_FEAT_INCOMPAT_BIGTIME |
+				  XFS_SB_FEAT_INCOMPAT_NREXT64)))
+		return true;
+
+	return false;
+}
+
+/*
+ * Decide if atomic extent swapping could be used on this filesystem.  This
+ * does not say anything about the filesystem's readiness to do that.
+ */
+static inline bool
+xfs_atomic_swap_supported(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * In theory, we could support atomic extent swapping by setting
+	 * XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT on any filesystem and that would be
+	 * sufficient to protect the swapext log items that would be created.
+	 * However, we don't want to enable new features on a really old
+	 * filesystem, so we'll only advertise atomic swap support on the ones
+	 * that support BUI log items.
+	 */
+	if (xfs_swapext_supports_nonatomic(mp))
+		return true;
+
+	/*
+	 * If the filesystem has an RO_COMPAT or INCOMPAT bit that we don't
+	 * recognize, then it's new enough not to need INCOMPAT_LOG_SWAPEXT
+	 * to protect swapext log items.
+	 */
+	if (xfs_swapext_can_use_without_log_assistance(mp))
+		return true;
+
+	return false;
+}
+
+#endif /* __XFS_SWAPEXT_H_ */

