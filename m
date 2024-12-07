Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500CA4A07
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530287; cv=none; b=sl7fEn8Pg6JekC8pvj7z/LwRE3eq9petWg8wscrBBkL+8MWOp5gWYZiLkdlUJgJKzk/aYIWF/j2wxbzMq36WmNdGnT2GBMIv38VKjMx6771rNhLCCVQxXLoQui47/uuPdEd2sDWMSibWcMTSj/++MB+aaQLHwJaaMls1lTb9kyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530287; c=relaxed/simple;
	bh=sRsRFAhCHCoEukFkIdwnHD2nmS1apEizt2pThiEM3Mw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IzvimPflhAgWA8QNsnZfjDaLpXxY64hvoIZA+0XAGGIo8bhgIWSvKSeTKH32rVZLYYFByw9gGCKR+auDMLQQO+rWqo+K5ZNAydkcAVFJzQv5NlfNPGJHlHGoDyb/um7R8HhACjUS835jJwdamZZbDJ3MtOoBRJooy0mxPqeSlXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QT0oWwx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QT0oWwx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BFEC4CED1;
	Sat,  7 Dec 2024 00:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530287;
	bh=sRsRFAhCHCoEukFkIdwnHD2nmS1apEizt2pThiEM3Mw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QT0oWwx/6XNkQcZiFgudXSnqgAVykrKAOBijuLE8fQNfodSq6DaHmIZYym421NQWE
	 vjlxWxewbypW1w61MELLnGHca9dU6ma0nSCjwaZmBJyN0j3SFSc99YBuRSn2SlDL7Y
	 7UTXtPmBp32/2YzhjM0eHHZPXxdHjvw9Jw/0Ol/u5S9KwHdaIKWnmq2N1xTmOxl4Vo
	 YET6ucgabirAr7X6uKyG8zkRdTbIqhg9jKFICHmXqqHHQNO1+ijeSvHJoQwmQ7st0K
	 Wkb1jFuFCmCgdXO1ZX6/14nbj05c3dfNk3KSCT2p4WH2f7z806CD4hqD0/e9XAX+PX
	 o6WDXGPAMvx4w==
Date: Fri, 06 Dec 2024 16:11:26 -0800
Subject: [PATCH 25/50] xfs_db: fix the rtblock and rtextent commands for
 segmented rt block numbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752326.126362.1070873250646267314.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

