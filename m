Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB24A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300185; cv=none; b=pzUchYMNuP2PQ5MQqE+V+XOlLcIpQrhKmjOWMlzHWHAlmAWJz8i0A7prjuTMjivX4quK4thR124BUGCxhnyCsRFIJl3Z9dsUjvR7DMnzFJuUWuX88lyav4KhDS/zG3xkEMr4jEru2ttzGXrkRL4pz/Kq1D8BC1q+xnnlG4L4O90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300185; c=relaxed/simple;
	bh=8oev3+MAJblHPUCLzY+Z0RvOxM/ZCztk340/QD1P0fc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRQlDSzrZQ9G9yiPA+MGyuKOyBVlh81IjXmEq+CrlmqX0xXVQSJnrRcC+jDkf9ddsonV4z9d4vbCt4v7+8JU7QnIxNI6O6s/j5JYnPXs2vExUMPlVNJt7Mm+Ma29QU728/OdtdE8YzPqTUdVCgfEJ38CpILH0P/y6aBDNUIiNSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnPBytT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnPBytT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F7EC4AF07;
	Tue, 30 Jul 2024 00:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300185;
	bh=8oev3+MAJblHPUCLzY+Z0RvOxM/ZCztk340/QD1P0fc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OnPBytT9Xd6N3Z7BOa48sqM9UVHEobGQoAKRbOD+mQlXDIZ2odFEuD2iyv0s5cNPT
	 pnDbJC7fanVm7OBWNKmByn37SRirarQf2iEXCCgYTcZc6kSoWuDSbSPvZwI3KPLyGj
	 DSmthwrywmng1zYSFDLW8w6Rr0uXaf/gM9FkTen6osi3NVjoQzaU4Q/qXDY+KXlrhP
	 QgVzSOzhJcpJ4I7L3Yh8kQoNDcdkrshLdJ/noG4aGumuUmiYl4CRE3s5NPiij9u2vC
	 z+wKH47i4qmI9iqQR4LPY7EmILLEoqjiaGCezMEK9L4aqzF56oUDAZ5Or7fQyIAwXI
	 +KZP0IG9SfQNg==
Date: Mon, 29 Jul 2024 17:43:04 -0700
Subject: [PATCH 074/115] xfs: fix unit conversion error in
 xfs_log_calc_max_attrsetm_res
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843485.1338752.13541870224423419444.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7ea816ca4043c2bc6052f696b6aebe2c22980a03

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_log_rlimit.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)


diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
index cba24493f..a7bbd2933 100644
--- a/libxfs/xfs_log_rlimit.c
+++ b/libxfs/xfs_log_rlimit.c
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

