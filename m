Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2D41CD00
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372549; cv=none; b=pkUbxzlm2e0tQFFL5WzP6ehX96FVRUBK982CKfV5rs/lI0vFx0UUnW3oP2lt+M8Dok/gA+8JteRv/x6u1Wha56iPy2Al5vRlC6HJ9xVRrQ+EnqYAS3kAPvpwDQ6RtWmSN6pCJn7cLaUJEfyf8ajjtih6Rdzup3zTX+40M59yCpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372549; c=relaxed/simple;
	bh=+40wS/gmtPRH+RbrGL5cm7dNkmca/kHfiySqKQ4H5EA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IvD7NIc9cSq0UQYesZEt94QAJvmSkpJbVO5gsFTIOZz243ZLv7wYNEkcOsQamX2xVec6LzqJi/0//H5xP77tlXejxTx+/q1fLylTo0C4pZL9tAT4sFhyoRwH6+GdCQM/wuMDC1QZaTuRP/+J6m2dYYZYZa317TbeM4IYOofjUeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k+rP5Dag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k+rP5Dag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F5FC32782;
	Fri, 23 Aug 2024 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372549;
	bh=+40wS/gmtPRH+RbrGL5cm7dNkmca/kHfiySqKQ4H5EA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k+rP5DagT2sxGGsZUOKDYSC5s/PnIYckogzJeiJS7UH0cEy0AOFBX7EdcLFtp9/7o
	 wPIWPNLt+LFpOQgc6MSZJBjK9aen0mmIAKgtCk+mbJeNs+lnjcorDTAlfteGmjFRQl
	 r5M//kneF7pFl7WRIMTSBrzqsF/Nf3cn8FqvecHKH3Vgr7yF7o29L7J+1oaK9tEhM2
	 JxrzqDKjtxK6KFjk3/+GM/3Sqjo99QkjweoWRCG4TfgOYGdGcQsqdMCuKu0M0kqTFa
	 Ie/ONg35vV2M+2LJHp9pAU9QrI6uvOsxUHPhqLxnYWd/92oa1sehwtgvYEFpY1yC5p
	 s6ZY34CmKaaBQ==
Date: Thu, 22 Aug 2024 17:22:28 -0700
Subject: [PATCH 05/26] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088605.60592.17624348368832345999.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_types.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index c299b16c9365f..8625cbaf530e5 100644
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

