Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2B8F54
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608580; cv=none; b=Y74Ht8njxbCtjvgCOcfGeAKq4VvYvRdlv8zKy9ZM0XLs30yNpIyWoVZy6KLhml5w9Fa5qcDMZPm/6oVl1d3j5jzDDI4N4C8/P0UoolKaQl3zjuBhqIRi51zypRzTT/OK4xOPUix+vK5yiJBGGiTK/k0uPrJojU2e+d0oCTjtV00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608580; c=relaxed/simple;
	bh=q1n620s78XJJREYLgcTOmxZHbQ7tpN+TqLEEdcWboRc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BRy4E+JZ/Zbcr1YNID6/+p5km3gNeq2UBiAF8fclZOXYXr8GZTkKUJ+q++CV4ZpiZKaJq+VRtD2uoNUoZ6ii8kedUpoUknQ5YRzVjEJN93l2o07QhCqp7cK4hTMr6jExQ3dKMdKurDCvNNRP3HwqLqU25uQ45a73F8kqoePqcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DS6bZHy+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DS6bZHy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DAAC4CEC5;
	Fri, 11 Oct 2024 01:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608579;
	bh=q1n620s78XJJREYLgcTOmxZHbQ7tpN+TqLEEdcWboRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DS6bZHy+OE88SIxCyFaycl3mtdt4JXaVgnuyv+kf2uQ/VaWAu/XiwTv3Efh1m+dse
	 7GTtvFpuUdpmKzRvltwIPRK1O8/pVffG+0JSwBQvFw7KcVrFyb3cm7BuqsRiSyzITC
	 GjhimGKh7pHpk3U8OrTZB38tKwV/ZX9ouL+6X9OrKQm+QH+Ibu8K6Pm4mBpn2Ti1zW
	 AM6skCymz08yNrztPB5YF/24aoYfJhIrPEyP/bQMz4PeYGn1P3oQtW8t6VLNiQK0U0
	 nZbJ2JHLIqLZsV7Q/JL1+0k7A+64PCivK7wTLx1kYuN5wgOi1ut46DxynvAP982L7D
	 hfZX9EqqTB6+w==
Date: Thu, 10 Oct 2024 18:02:59 -0700
Subject: [PATCH 05/36] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644325.4178701.14720598099599958723.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Check that rt block pointers do not point to the realtime superblock and
that allocated rt space extents do not cross rtgroup boundaries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_types.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index c91db4f5140743..0396fb751688d0 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -12,6 +12,8 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 
 /*
@@ -135,18 +137,37 @@ xfs_verify_dir_ino(
 }
 
 /*
- * Verify that an realtime block number pointer doesn't point off the
- * end of the realtime device.
+ * Verify that a realtime block number pointer neither points outside the
+ * allocatable areas of the rtgroup nor off the end of the realtime
+ * device.
  */
 inline bool
 xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return rtbno < mp->m_sb.sb_rblocks;
+	if (rtbno >= mp->m_sb.sb_rblocks)
+		return false;
+
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
+		xfs_rtxnum_t	rtx = xfs_rtb_to_rtx(mp, rtbno);
+
+		if (rgno >= mp->m_sb.sb_rgcount)
+			return false;
+		if (rtx >= xfs_rtgroup_extents(mp, rgno))
+			return false;
+		if (xfs_has_rtsb(mp) && rgno == 0 && rtx == 0)
+			return false;
+	}
+	return true;
 }
 
-/* Verify that a realtime device extent is fully contained inside the volume. */
+/*
+ * Verify that an allocated realtime device extent neither points outside
+ * allocatable areas of the rtgroup, across an rtgroup boundary, nor off the
+ * end of the realtime device.
+ */
 bool
 xfs_verify_rtbext(
 	struct xfs_mount	*mp,
@@ -159,7 +180,14 @@ xfs_verify_rtbext(
 	if (!xfs_verify_rtbno(mp, rtbno))
 		return false;
 
-	return xfs_verify_rtbno(mp, rtbno + len - 1);
+	if (!xfs_verify_rtbno(mp, rtbno + len - 1))
+		return false;
+
+	if (xfs_has_rtgroups(mp) &&
+	    xfs_rtb_to_rgno(mp, rtbno) != xfs_rtb_to_rgno(mp, rtbno + len - 1))
+		return false;
+
+	return true;
 }
 
 /* Calculate the range of valid icount values. */

