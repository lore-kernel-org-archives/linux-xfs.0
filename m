Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8015C4C634
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388828; cv=none; b=ibzx3FDWBGLQrFi99/vx1EKFikwm2EOSVgtCSvF9dIlQpkSKTZN8mjz+zljceAMy8PTl0b/ln7/fJPRTC25kyJKKOK/tuLsEEPAnPEVtA9SOf9H2PMeo/XaiIDj52ipmy7NlJ6JCMnMsUCPuLXP48Xqo7S0TZ+bjLSX13uUqoTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388828; c=relaxed/simple;
	bh=CubImYIgByMM2YW0b/EmZxrQ8ju8mGc11fnOa/mmteI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdgEnBx7mcpWr2Riar2e7PI4eZFKsR3LPd1EpcRKCGsje0+dqxoLyQShJw63FdsCPlIs3mtknUSfp/8EUZv30NuQJEy0GYmRvTtPaW+PAD6kLk+SSuWzx5r+kPpNSfGPYsHHjxwAavjY+jRM/DY52igNOzcjz2j5t0wbwMDMJW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tvPe0IVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tvPe0IVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1E5C072AA;
	Wed, 17 Apr 2024 21:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388828;
	bh=CubImYIgByMM2YW0b/EmZxrQ8ju8mGc11fnOa/mmteI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tvPe0IVwI+PVuXOV21GZ01C10bxxHq2d6Qp6W+lSv6nk4vUgqxybhjWqP4wyh4dyu
	 MlFVv4qdiHwKp6sJTdmKg4X38FBgQsRCS5jiAiauWDc4GKQ3XjyRhwJVfxwEvLB+mP
	 eBzvhxmgzkpp5W8JlnlgUvfikl8LxTwiyujeTTxYXA1N0LqAurHSnqwhliIGYwp/Z6
	 euNB/dC0zSZyqX+NomifpscMnnqhgQZbxkUEzDxf8NQb8etdal1gdF0nnUcMy9IUJ/
	 0mJdsFoB3lMBMhXZDXh0zNfgSk4ChwluiWdGg/mRb+6N0NvYFj0B2JkPInalGmVb6G
	 LbrhgiCusLpeA==
Date: Wed, 17 Apr 2024 14:20:27 -0700
Subject: [PATCH 06/11] xfs_{db,repair}: convert open-coded xfs_rtword_t
 pointer accesses to helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841827.1853034.4569830531252865554.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c      |   12 +++++++++---
 repair/phase6.c |   12 ++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)


diff --git a/db/check.c b/db/check.c
index 6e06499b9..a8f6310fc 100644
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
index 3870c5c93..7b2044fd1 100644
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
 

