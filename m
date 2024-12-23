Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3238385
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991328; cv=none; b=hMTNktNnKY3lGhsqnrQQw++AnwM1NOb5wZhlx1j4l/4U2BkGJlRSDHMP+cUvaEGLS0lThuRyarOpbk/Q9zY6yG+vIztHTK3S0nb/joortle2VdrVPwxMmcoSlXRCGFtwsXWmGVyEI7glksRWdkgLCeAXbubYVMQsCmPh2kLDtSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991328; c=relaxed/simple;
	bh=zywaIVk0do8KxnwqU/2bsefRd9Uj8iIPcUbqKE9Xfrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WyHhp9hHiI6Frz/v5DhAYgUzPwtpNySUiqbjscm/49lmJ1/ptwLpNq3MssyBC5ABbcEG4/v+KyhVzJ1OC7URYZd6wfK9eyQCUMX/irf/vAKP3WB07qjJ0ZHJlOaGYtsmvRjncTg3uVu8D7MfEZFuJsBnWoIbgRDtPapq6w9VR74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=muvZiiOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="muvZiiOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368CCC4CED3;
	Mon, 23 Dec 2024 22:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991328;
	bh=zywaIVk0do8KxnwqU/2bsefRd9Uj8iIPcUbqKE9Xfrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=muvZiiOuoT7BCP1pjXGvIfmxKk5BgQknVQ707hFsThTkRnHYqzEDtiPeUrQeaM+m2
	 xum0EJ+Cc/e4dbfdRvqz4QlCWa7zYRMpdcddzjJ8Wdz78DWqYsZPhtyZomhOylmONK
	 PPLo9q7KZiqGFDi6YWih39nYsj/ASrtNSirpPHfZpYzRgmXThEuPLW7SzTqLIEo9Ip
	 eHNDG/ZbVXaYOcdhIgLVvbij8+ZFgtHeqylMKi6RSaLPA4tR0Rvhjp4ZNMiICc3iw5
	 gOMX0FohXYVYQpqK++tRMCY007LgJ6UazfF2u2C8rYG1cDkZv4wS7OSJsErGhy4Icd
	 4nr/GAyySiN5A==
Date: Mon, 23 Dec 2024 14:02:07 -0800
Subject: [PATCH 15/52] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942724.2295836.6557717150046523104.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 9bb512734722d2815bb79e27850dddeeff10db90

Check that rt block pointers do not point to the realtime superblock and
that allocated rt space extents do not cross rtgroup boundaries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_types.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index a70c0395979cf8..4e366e62eb2ae8 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
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

