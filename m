Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B493BB654
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294705; cv=none; b=e26wYcZ3WJJXzXD4Rdziuum36SPF35EdLTiVpx6Xf9UbcmWtehBuGcDYkC/13e9MLExZuZ21hO//DQ0kx4QzThDjRHqOyQ9zY4wMXcqOSaSrmzlcvEQjXqfp9SHdyHlohR/56ZKtP/GNSxHdiqC+t8oBKTGjw4yJkAabhBkiYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294705; c=relaxed/simple;
	bh=PBw6Cmm7vYI4cdraxFW7df81pT0eOIV3LW7xWqgW7OY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ncr0HaQ9vgc12Uqc9J7zsCh7mcElDLen9sHR5NJIf9mYTFS0pM4OX5LGHdLNmHbmks8lpOLCrUyj7I3gLx/pm0ELhJ7q0ENEjL+939Pa4+pz1kQpcNv0wdHB1QRZ8Kn06ZvcRX4SkDJHss746tl2RUAO9jzvDkS2hXYnjU2oL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1JTL4L7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1JTL4L7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32200C433C7;
	Wed, 13 Mar 2024 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294705;
	bh=PBw6Cmm7vYI4cdraxFW7df81pT0eOIV3LW7xWqgW7OY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=e1JTL4L7/hZXYB5uuz7RwAiE+7I+gDn7JiG0lYN9OCEv4ledE3kiBwz1/ML424ZaC
	 bMjgzcGw223Cu1GJOBVEZBA15IaP4kgj8HCOinBctqGTRymz/JAbgKKFxEnS5HKPTt
	 IGkO7r1frfqx2FjzgmWNuL1SbfNumvlPguRHyGe+e4unSFGcX2xH1EAWdnkXkzFbu3
	 0xDb43zrhjOM0+rpk61glkh0WDLC5xc2/2FmhykHb4elYG562GVYBBgdR17xeZ+k1M
	 UDkFdckiJIXgpBdo6WVi+lVXUw32sLscFo9cpnYu1J5FmIQRUgPX4J0uOCIJv+NzvF
	 KEEnFHNnpqWEw==
Date: Tue, 12 Mar 2024 18:51:44 -0700
Subject: [PATCH 08/13] xfs_{db,repair}: convert open-coded xfs_rtword_t
 pointer accesses to helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430672.2061422.3068891686655718546.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

There are a bunch of places in xfs_db and xfs_repair where we use
open-coded logic to find a pointer to an xfs_rtword_t within a rt bitmap
buffer.  Convert all that to helper functions for better type safety.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c      |   12 +++++++++---
 repair/phase6.c |   12 ++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)


diff --git a/db/check.c b/db/check.c
index 6e06499b9eb3..a8f6310fcd25 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3608,8 +3608,11 @@ process_rtbitmap(
 	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
 	bit = extno = prevbit = start_bmbno = start_bit = 0;
 	bmbno = NULLFILEOFF;
-	while ((bmbno = blkmap_next_off(blkmap, bmbno, &t)) !=
-	       NULLFILEOFF) {
+	while ((bmbno = blkmap_next_off(blkmap, bmbno, &t)) != NULLFILEOFF) {
+		struct xfs_rtalloc_args	args = {
+			.mp		= mp,
+		};
+
 		bno = blkmap_get(blkmap, bmbno);
 		if (bno == NULLFSBLOCK) {
 			if (!sflag)
@@ -3622,7 +3625,7 @@ process_rtbitmap(
 		push_cur();
 		set_cur(&typtab[TYP_RTBITMAP], XFS_FSB_TO_DADDR(mp, bno), blkbb,
 			DB_RING_IGN, NULL);
-		if ((words = iocur_top->data) == NULL) {
+		if (!iocur_top->bp) {
 			if (!sflag)
 				dbprintf(_("can't read block %lld for rtbitmap "
 					 "inode\n"),
@@ -3631,6 +3634,9 @@ process_rtbitmap(
 			pop_cur();
 			continue;
 		}
+
+		args.rbmbp = iocur_top->bp;
+		words = (xfs_rtword_t *)xfs_rbmblock_wordptr(&args, 0);
 		for (bit = 0;
 		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
 		     bit++, extno++) {
diff --git a/repair/phase6.c b/repair/phase6.c
index 3870c5c933a8..7b2044fd1dbb 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -593,6 +593,12 @@ fill_rbmino(xfs_mount_t *mp)
 	}
 
 	while (bno < mp->m_sb.sb_rbmblocks)  {
+		struct xfs_rtalloc_args	args = {
+			.mp		= mp,
+			.tp		= tp,
+		};
+		union xfs_rtword_raw	*ondisk;
+
 		/*
 		 * fill the file one block at a time
 		 */
@@ -618,11 +624,13 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 			return(1);
 		}
 
-		memmove(bp->b_addr, bmp, mp->m_sb.sb_blocksize);
+		args.rbmbp = bp;
+		ondisk = xfs_rbmblock_wordptr(&args, 0);
+		memcpy(ondisk, bmp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		bmp = (xfs_rtword_t *)((intptr_t) bmp + mp->m_sb.sb_blocksize);
+		bmp += mp->m_blockwsize;
 		bno++;
 	}
 

