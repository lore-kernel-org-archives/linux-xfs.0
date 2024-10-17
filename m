Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436A421B43F
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191884; cv=none; b=BAa3qM1faQkOI1ZmA+b3TnMqji0aO6UatD7AA7E1xWrjstfyK7Il9n/v2SbVZyP/bshE78wDYkGtKcvMC0l5tCRJJNfrDzCJnLP3m9er3wr98/mOK9QOWNf3c7XM9c8bzw+wtqcutyU09cbXW3CAAi3ZTX+qVaSmdBDOAKqHPf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191884; c=relaxed/simple;
	bh=8rfE2xWxsXbpSJoXBy6jSHY1KBlfKjhVUcFamUAByi0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bH+QSvwBsyca8ijDGuIrEa40/bg8rwNJL04rlEnLfQ0BltXEAKBuuXSYELg5HNvUFcY6mNiigxe7gZ1IJZAm/TDVmBd7ewUs1onweMmmMVgx6F2xP7CoZ/eGP6j5uNuCF/W3IPF64vXhL30eaF4p8kQe+wMq4fpNMjZOQ3CQOBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFMiR9a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFMiR9a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36E2C4CEC3;
	Thu, 17 Oct 2024 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191883;
	bh=8rfE2xWxsXbpSJoXBy6jSHY1KBlfKjhVUcFamUAByi0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KFMiR9a/J4SwN+KX8fe/c81BvFy07WEchCSGj87iYMKW8xHdpxoty8biuTl8Xa0gQ
	 hlA3pcXr3ABJRn06rfnpv+datFKt/dYdEGFIIu5QDP2KNLUqE6aU2LZQNpC8atXkpx
	 EBTVYDRUixdfP0RvENo12tsXKssDo1SDKRb+nZhVp3k/CMROJgih5G9VE2ao7LXMGJ
	 A5RzLvL4nOcTKPPx+E/E/HnYDL+gjTcgFb6/WHdGZUHV2185m1LSB4hSvhxtewEGJF
	 gurTYd2McULM3Ihws8EIGUMmO/nK5bmarBEu6woY8/izJNVTLGGF/KxWJDEc7anvJJ
	 +jPq+v5h4eQvQ==
Date: Thu, 17 Oct 2024 12:04:43 -0700
Subject: [PATCH 05/34] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071752.3453179.5275357148266525178.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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
index 1cbfe57e971d5c..a4c30844d42be1 100644
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

