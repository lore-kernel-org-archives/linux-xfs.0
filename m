Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7F5391
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710880; cv=none; b=FnoksPq0tiKwUe10mBDEDDXUK7nIcH2DHIIdWDhK7QU9y9XPBNVQ2VRThLnsCMSkxsrZYS4oEd98m7siGE4kfJXi0uGUveGCkBaZ3GOuvkeHiOd2W4jB0vQc1sGqUCMaX2JWDBY89o/rgh2e7KF2PWqmNsWw0q0X4+7G14sXpgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710880; c=relaxed/simple;
	bh=Ci3ye8+//spnZAj5yLmQKmqoR4qum3iR3QM8tRmpREE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFKoWnU27lFs5NZDgFtcwSNNe2e9nezgYlXeWPn23yrIK4Qx69BbWAbw5R5ElbnE9YCbhhzsvDJGnuVaVk/v6Aqp9Zd5FgM+DDiy2fus76/DZe/1+lr5bCCquy2lJ5rnyyw0C3x83/wWBkQLJOyDRZjgqORtyyf0OhbMfPHyATw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ouaMzqFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouaMzqFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0662C433F1;
	Wed, 10 Apr 2024 01:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710880;
	bh=Ci3ye8+//spnZAj5yLmQKmqoR4qum3iR3QM8tRmpREE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ouaMzqFt8Spsd7Dv4WfPpJb9cBAMjG7CbCvpBh1efLq5dR8Yu3juDC/+ohuPnOl86
	 2ea778lUEeN73XFbVuucjWLa/knER64ncU3VLTZmrD26rc4EL3QU6/VVPqdfBay+vU
	 MPF1BdDz+yLQI0c7fyoihtA7RsnMEAaUm2qxF+flk2vrQrtMeMF05Jdh19HNs79CMd
	 ppHc4YtNfunzqruc47EsXhqo22UvjHw8i2N73LOC1du5jawimMXgYXtpAuGE+cDO+U
	 o1sJOjx8Ch67beCmg/ePATSUw5CFhxGXc9GIvGU6gNmHt4N7torCno4OhOiQucSDpj
	 sFYXDSvDXlM1w==
Date: Tue, 09 Apr 2024 18:01:20 -0700
Subject: [PATCH 30/32] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970059.3631889.4894608923555781612.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

Therefore, turn this on for parent pointers because it wasn't merged at
all upstream when this issue was discovered.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 9975b93a7412d..3518d5e21df03 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -16,6 +16,29 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trace.h"
 
+/*
+ * Shortly after enabling the large extents count feature in 2023, longstanding
+ * bugs were found in the code that computes the minimum log size.  Luckily,
+ * the bugs resulted in over-estimates of that size, so there's no impact to
+ * existing users.  However, we don't want to reduce the minimum log size
+ * because that can create the situation where a newer mkfs writes a new
+ * filesystem that an older kernel won't mount.
+ *
+ * Therefore, we only may correct the computation starting with filesystem
+ * features that didn't exist in 2023.  In other words, only turn this on if
+ * the filesystem has parent pointers.
+ *
+ * This function can be called before the XFS_HAS_* flags have been set up,
+ * (e.g. mkfs) so we must check the ondisk superblock.
+ */
+static inline bool
+xfs_want_minlogsize_fixes(
+	struct xfs_sb	*sb)
+{
+	return xfs_sb_is_v5(sb) &&
+	       xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_PARENT);
+}
+
 /*
  * Calculate the maximum length in bytes that would be required for a local
  * attribute value as large attributes out of line are not logged.
@@ -31,6 +54,15 @@ xfs_log_calc_max_attrsetm_res(
 	       MAXNAMELEN - 1;
 	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
 	nblks += XFS_B_TO_FSB(mp, size);
+
+	/*
+	 * If the feature set is new enough, correct a unit conversion error in
+	 * the xattr transaction reservation code that resulted in oversized
+	 * minimum log size computations.
+	 */
+	if (xfs_want_minlogsize_fixes(&mp->m_sb))
+		size = XFS_B_TO_FSB(mp, size);
+
 	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
 
 	return  M_RES(mp)->tr_attrsetm.tr_logres +

