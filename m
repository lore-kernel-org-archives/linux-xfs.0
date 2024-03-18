Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E8358211
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798371; cv=none; b=EjcPmy022bhDeZ+8YaEGA7zWusXsWIQqoqvmO+OXDp5HTkrztawul+QZ0vRJNg/Pi2C2K56mI5uIlZbCMLJDCFdVqEAuOThilTzYVV2zGlv/G11ioJTqMOpite9l75rjCMfKcWcAUi+BSKPG4FSegCPNd2RfQEPTqt191lPLUn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798371; c=relaxed/simple;
	bh=viqE2uyVV+Tv+PVTaywZPDMXlPPbBVd2ZayIHXoNkU4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLCgjDdi1m+ODC7vaj6YD2giPXIiOJrNCdLghECNs8Zhp7ZXC9r03bvn9QA7jIvSYdgyoipprV9u4tMQBjnaiOAzH4gP/ePgeUHd5k7YiqwRwI8HiQ3xRzZHWBgukRg20dSed7NVKzsNQblObwE+sfL3eoOonkPqNu8w/cCGFTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vmpo6Q4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vmpo6Q4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA62BC433F1;
	Mon, 18 Mar 2024 21:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798370;
	bh=viqE2uyVV+Tv+PVTaywZPDMXlPPbBVd2ZayIHXoNkU4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vmpo6Q4sBIyDhGHKNoK5A95igWmAzxJkhXWeh2h/Vb+EGlMQ9SCHIy7ifVcvhPKeA
	 wDl3f90chElfXm1aWWvs90Kf55DpOUOStzqrAycoDnjWz7N1lImbBeNsFLYhol1PRx
	 SolfQFKqmGf+WLJPDy/7WZ2RfeHXkd4z3HPQ5AT0W4Hndum1XO8lj05DB3ht7saxd+
	 vGyTGUI8jeCJYxDqTc0YaMvAwkWnRRlwkrqnkpf+VEzsYEolGQK8fz0zScwL5PT6+g
	 2A1pLWTZG4XmygqFTLMmiiPHoxiRL1vK5+ferI1d8tW0cX6XGyt26mzKnYWYi8rugj
	 4v+wXjlud6TQQ==
Date: Mon, 18 Mar 2024 14:46:10 -0700
Subject: [PATCH 16/23] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802136.3806377.6455302091118859854.stgit@frogsfrogsfrogs>
In-Reply-To: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
References: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
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

Dave and I were discussing some recent test regressions as a result of
me turning on nrext64=1 on realtime filesystems, when we noticed that
the minimum log size of a 32M filesystem jumped from 954 blocks to 4287
blocks.

Digging through xfs_log_calc_max_attrsetm_res, Dave noticed that @size
contains the maximum estimated amount of space needed for a local format
xattr, in bytes, but we feed this quantity to XFS_NEXTENTADD_SPACE_RES,
which requires units of blocks.  This has resulted in an overestimation
of the minimum log size over the years.

We should nominally correct this, but there's a backwards compatibility
problem -- if we enable it now, the minimum log size will decrease.  If
a corrected mkfs formats a filesystem with this new smaller log size, a
user will encounter mount failures on an uncorrected kernel due to the
larger minimum log size computations there.

However, the large extent counters feature is still EXPERIMENTAL, so we
can gate the correction on that feature (or any features that get added
after that) being enabled.  Any filesystem with nrext64 or any of the
as-yet-undefined feature bits turned on will be rejected by old
uncorrected kernels, so this should be safe even in the upgrade case.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412d..b836de0de5b95 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,29 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Decide if the filesystem has the parent pointer feature or any feature
+ * added after that.  If so, we can improve the accuracy of the transaction
+ * reservation computations that should lead to more efficient log grant use.
+ */
+static inline bool
+xfs_has_parent_or_newer_feature(
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
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +54,16 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * Starting with the parent pointer feature, every new fs feature
+	 * corrects a unit conversion error in the xattr transaction
+	 * reservation code that resulted in oversized minimum log size
+	 * computations.
+	 */
+	if (xfs_has_parent_or_newer_feature(mp))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +

