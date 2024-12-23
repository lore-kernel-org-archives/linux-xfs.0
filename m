Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA708EAF6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992281; cv=none; b=grHcHKgoZd3fIXvkz3BRz2JoqtGWyuIQ7V+R9GeoVbaRJC4hwtrQM2qbcLZaugnuOw1bNeWlJ/g0vvH9OclOrRavpjMxccvhI3IOJYVE2yQOzdSju8MnoU44EAQ3RgmAMlLnjxUP3ORME5H/AFTQJhnbcItgrdJAeFpCUm4Apjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992281; c=relaxed/simple;
	bh=940WlDlONPGF50GHxfQtaghNTzV/9wRaZ0ua5Xp91RM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bjkaZNxce5V4PC+meMowojQibKHpcGYvFkwI1QnLF14tiaMIOWlC/D2+/tWMR6f81BnlITsIvWL62x9yfkXW26yfACPD/UlfpoP/B2cDvLU89axmsAUDnZWdcuKKK6uzQdfbunrQTLNRDOmUINXgVbAnT21z8STXHab77n7MYqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mIofPENp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mIofPENp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A335C4CED3;
	Mon, 23 Dec 2024 22:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992281;
	bh=940WlDlONPGF50GHxfQtaghNTzV/9wRaZ0ua5Xp91RM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mIofPENpRyjzZym9UW/kjTjkADUMZQMn2rW+qHWEgrsBVlIR5GgVjnowSDxY1SpoS
	 TKpXP+v4auXUewkq5XsYQxA1yWlLGYxY6B0FPzXE9zN4XVjGTVvOG+iqkLjgZvY+Xd
	 rCx4aobHR9tiRC03AabXBH43r1HZ2F8G48a7h1QIQXgnxdZzwmUSeiwNxUUonJVvkl
	 3L9c4dtoE/P0KTEqQmMEVWlxD7z/n2WBs1a9UiJdJNWgAGV5uNGtDdGen+tqTChGDd
	 UzKkj788lP42Z+gmE2rWLzxaJfAqRbqHgBiU6eWzH+5xUE5iLD7K9HvYTbe59fEPRZ
	 YMAYl4JhYiMEQ==
Date: Mon, 23 Dec 2024 14:18:01 -0800
Subject: [PATCH 24/51] xfs_db: enable the rtblock and rtextent commands for
 segmented rt block numbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944171.2297565.5530629850666848064.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that xfs_rtblock_t can be a segmented address, fix the validation in
rtblock_f to handle the inputs correctly; and fix rtextent_f to do all
of its conversions in linear address space.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)


diff --git a/db/block.c b/db/block.c
index f197e10cd5a08d..00830a3d57e1df 100644
--- a/db/block.c
+++ b/db/block.c
@@ -367,10 +367,23 @@ rtblock_f(
 		dbprintf(_("bad rtblock %s\n"), argv[1]);
 		return 0;
 	}
-	if (rtbno >= mp->m_sb.sb_rblocks) {
-		dbprintf(_("bad rtblock %s\n"), argv[1]);
-		return 0;
+
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
+		xfs_rgblock_t	rgbno = xfs_rtb_to_rgbno(mp, rtbno);
+
+		if (rgno >= mp->m_sb.sb_rgcount ||
+		    rgbno >= mp->m_sb.sb_rgextents * mp->m_sb.sb_rextsize) {
+			dbprintf(_("bad rtblock %s\n"), argv[1]);
+			return 0;
+		}
+	} else {
+		if (rtbno >= mp->m_sb.sb_rblocks) {
+			dbprintf(_("bad rtblock %s\n"), argv[1]);
+			return 0;
+		}
 	}
+
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
 	set_rt_cur(&typtab[TYP_DATA], xfs_rtb_to_daddr(mp, rtbno), blkbb,
 			DB_RING_ADD, NULL);
@@ -392,14 +405,17 @@ rtextent_help(void)
 /*
  * Move the cursor to a specific location on the realtime block device given
  * a linear address in units of realtime extents.
+ *
+ * NOTE: The user interface assumes a global RT extent number, while the
+ * in-kernel rtx is per-RTG now, thus the odd conversions here.
  */
 static int
 rtextent_f(
 	int		argc,
 	char		**argv)
 {
-	xfs_rtblock_t	rtbno;
-	xfs_rtxnum_t	rtx;
+	uint64_t	rfsbno;
+	uint64_t	rtx;
 	char		*p;
 
 	if (argc == 1) {
@@ -408,9 +424,9 @@ rtextent_f(
 			return 0;
 		}
 
-		rtbno = xfs_daddr_to_rtb(mp, iocur_top->off >> BBSHIFT);
+		rfsbno = XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT);
 		dbprintf(_("current rtextent is %lld\n"),
-				xfs_rtb_to_rtx(mp, rtbno));
+				xfs_blen_to_rtbxlen(mp, rfsbno));
 		return 0;
 	}
 	rtx = strtoull(argv[1], &p, 0);
@@ -423,9 +439,9 @@ rtextent_f(
 		return 0;
 	}
 
-	rtbno = xfs_rtbxlen_to_blen(mp, rtx);
+	rfsbno = xfs_rtbxlen_to_blen(mp, rtx);
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
-	set_rt_cur(&typtab[TYP_DATA], xfs_rtb_to_daddr(mp, rtbno),
+	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rfsbno),
 			mp->m_sb.sb_rextsize * blkbb, DB_RING_ADD, NULL);
 	return 0;
 }

