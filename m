Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DB91CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845873; cv=none; b=UkPT6usmHB1JeJKPPQ3oUswXUiifMSHnsQmT4yPJYuqTqIaTtbh6T3wFfaSWczSEhS4qofohULpul6eZOypFeJ/SF7vw1x92MasKaYdYwjSbx8pjSOONO2t4PXqVxStfym+f67MTymw60WzVdr88J5cFHxvol5mf2r/tXER3mMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845873; c=relaxed/simple;
	bh=8rfE2xWxsXbpSJoXBy6jSHY1KBlfKjhVUcFamUAByi0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FYxLU5QazU7hD70XQNUrKsJeEaj0F3+FfGFwEXaruC6ICOufbaQcal5nlSQlGOTXFXP+l6ydp9z1DO+ZVVn3xJ4htwEbtrFUtbhcBN59D5qh2v2mBRtH45vphZuYrVMQnxMdmgVq1ohZEzhztDa8X7/Pwvb7Jl2IUo6Zsg+bvpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA0KKKw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA0KKKw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6D9C4CECF;
	Tue,  5 Nov 2024 22:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845872;
	bh=8rfE2xWxsXbpSJoXBy6jSHY1KBlfKjhVUcFamUAByi0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NA0KKKw14sI2D6FZSeftTvFZ6NtoC9ebBR2rdDYoNi+wqj6vEID89afq6D7NH14kp
	 G4Q7yp6IeijVGkoW8PLDOBZD1nQbFC922Qa1wHqp+3s1xHti1nsYLkfmobi0Qb967r
	 vIItXIJLYbig4obyv4P7YbdmtfSqPOsrUv4p9wTRugN+oksU/lh9tdpLQNrs3VEWRs
	 /xNBPTLO3NWiiPyE078/s+S0ruUHbK3wLU28B+sZN4/LI9WO1DWI6RtlQAyiwXUADL
	 qwAsArGUhMwiTS6KUTvtDlJ9cbBNlGmDTNhPoKgv/G0aeWGRpj0mibzy2arzCSuRDC
	 GylHztK3+DvfA==
Date: Tue, 05 Nov 2024 14:31:12 -0800
Subject: [PATCH 05/34] xfs: check that rtblock extents do not break rtsupers
 or rtgroups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398269.1871887.1338805733205303063.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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

