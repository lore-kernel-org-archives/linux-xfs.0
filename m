Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD4E148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529317; cv=none; b=pSL3023dGTe1dirgehAW524TQVNcEL3HIOQhw89qi6t5+LmeCGBCIWO2aw2FRHR5L+A7mt+uBohJ0gPtl/frOUxMTgnbYYJYY9zk4Nt/fSNoaKOPJbHUQG5mfEA+2kB9LkT7cDvsRq3AGTYWmIJagr0KK12y7B2WO2S19jtznYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529317; c=relaxed/simple;
	bh=zywaIVk0do8KxnwqU/2bsefRd9Uj8iIPcUbqKE9Xfrc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRHTLhZOZnCKwL36u9zmdO1i80lBuhdAHJJScwTGEACb5xfj+AvMxZh2bVadSXD56ZF8EHk6hKQBLAlOQ1X9oG2++qffw+Uko7TMjEOA9dg9u/pPp/SRdPFs5qK/pj/mlyQrgaFl+IEVHKHw2f1e06JJeAhO0jxF70GS4jEIop0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bz3taglH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bz3taglH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF170C4CED1;
	Fri,  6 Dec 2024 23:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529316;
	bh=zywaIVk0do8KxnwqU/2bsefRd9Uj8iIPcUbqKE9Xfrc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bz3taglHn9fk6/ftCFJ8ZXd0jFxV/T0+PGIWbKokvG3jhGCjbKYuBT827tC1/B/zn
	 cuYDP+h/Cbi/w9ncme0zNux6OZFrOYKEO2Tr7GQHXLNNT6Fv3PvzMN1qQWq3LIfwvT
	 6bB+s6Ee1CpX2HOkALYaqqvM0XOPWY4uEAd+cxJf9Mh0KNfPGvsfq4iulhnELLJOiR
	 80VEV8ulIFOBSqrfpEfgQWjKIJtVzOL6kScJcDpvrvMSzURPedxiPNPj/2VoGn2sNN
	 r51dkVJBBvFergyZlrYkHLQLimtMRX5VStQfh+QceD6Chbxyn75LKhkrUB1l7/rmnL
	 TQZ2kvolOxamw==
Date: Fri, 06 Dec 2024 15:55:16 -0800
Subject: [PATCH 15/46] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750223.124560.238266808139613220.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

