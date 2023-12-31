Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31DBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ms8gpQov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D34C433C8;
	Sun, 31 Dec 2023 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057493;
	bh=Af8az1MLCxvemrSWEZ6nt+e/5KVZA0sD5MwWmAYUaRg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ms8gpQovNSjaIMkuD2KrEF8FInEy+aFuOLXmMMfEP+D52TynAU94XyGUN3HX6YUeQ
	 JoUssiDAtHRoYsg5/UmF2Drp8UlaDFeRtYMroONXuXy2tJ4+JjrzGKwoVTNOJ7r3UM
	 aJeBsy2FyzUFZKemMqYTe5WwMjI3pSWHngwzaCQkxgQmcSqDW3G8zXcO+cnViLg8SX
	 gsUCbqOWVpXsHjpr75IPa6IXvnzfuIT7haKWPu97w+CKGsgh1w8XFyTgQGQ06mU9nP
	 esypf4dI74R9f8mSgWxvKwYfF6rqjqJy0w/GAtYOy582mB1SiEYbMM5d4EA+DEXvRa
	 ARs/gKyVXYV1Q==
Date: Sun, 31 Dec 2023 13:18:13 -0800
Subject: [PATCH 10/24] xfs: check that rtblock extents do not overlap with the
 rt group metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846401.1763124.10399457109318187719.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_types.c |   46 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b1fa715e5f398..34d02b2bfdd16 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
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

