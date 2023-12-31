Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E3C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLl9PFfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CA1C433C7;
	Sun, 31 Dec 2023 23:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066579;
	bh=0LhhCwyee2U3iZxGvjHF3U7N5UMf+OjFv/Ws7WWjwas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fLl9PFfe5Hu74O4Ye4X9ivNOmVfSk6hHrLxfamre6UYUhqtBie5+K1VURODUNP3uJ
	 O+3UdDOcHjHYjgCwYxHPPFIOfdP2ymhGTWbW3Jcllw2AX1rZKWvWgfNpylPwabr0ih
	 /r8bmMsTvorsyuQtNk/GjXU5KbT5raLF0MmGpWOMFxwyxD2L6cS1NwfxMMykbRyD59
	 n9hiYENsYUSHpadyIFRJPNaTsE7qwnVJpS255xrADRsuueLPOIfGGccjNqZdsExHmh
	 lp5O6NarCwdiHSV8V7hD45Dg9yaX0DRO53cNBt6N+Iuz6JTLxch8P1sEvzpbNTD0Vh
	 pDoqMUY2IbGfQ==
Date: Sun, 31 Dec 2023 15:49:39 -0800
Subject: [PATCH 08/52] xfs: check that rtblock extents do not overlap with the
 rt group metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012276.1811243.7989520284192306969.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

The ondisk format specifies that the start of each realtime group must
have a superblock so that rt space mappings never cross an rtgroup
boundary.  Check that rt block pointers obey this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_types.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index f5eab8839e3..6488cda24e8 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -13,6 +13,8 @@
 #include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_imeta.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 
 /*
@@ -133,6 +135,26 @@ xfs_verify_dir_ino(
 	return xfs_verify_ino(mp, ino);
 }
 
+/*
+ * Verify that an rtgroup block number pointer neither points outside the
+ * rtgroup nor points at static metadata.
+ */
+static inline bool
+xfs_verify_rgno_rgbno(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	xfs_rgblock_t		eorg;
+
+	eorg = xfs_rtgroup_block_count(mp, rgno);
+	if (rgbno >= eorg)
+		return false;
+	if (rgbno < mp->m_sb.sb_rextsize)
+		return false;
+	return true;
+}
+
 /*
  * Verify that an realtime block number pointer doesn't point off the
  * end of the realtime device.
@@ -142,7 +164,20 @@ xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return rtbno < mp->m_sb.sb_rblocks;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno;
+
+	if (rtbno >= mp->m_sb.sb_rblocks)
+		return false;
+
+	if (!xfs_has_rtgroups(mp))
+		return true;
+
+	rgbno = xfs_rtb_to_rgbno(mp, rtbno, &rgno);
+	if (rgno >= mp->m_sb.sb_rgcount)
+		return false;
+
+	return xfs_verify_rgno_rgbno(mp, rgno, rgbno);
 }
 
 /* Verify that a realtime device extent is fully contained inside the volume. */
@@ -158,7 +193,14 @@ xfs_verify_rtbext(
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

