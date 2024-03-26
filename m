Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4613128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422091; cv=none; b=LNbxX9pDRGIdZS8q/51co4ht/No+yPHMGqBdcNgOtqcy28N1jTd6GHka+AR6NOo+kCEMHEv1I5uZ6ZT8b6hRqREAwIdpF6S/1ehXGRqXWkes/SuEfxAQ+EQhQDnC7qXCZOcR00Puf+hA/fqUNagxuGjJ4vUdkxCNp9WQqTSmqjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422091; c=relaxed/simple;
	bh=TIXvSyGvRziR7hbSRgVjltj7KHIaMhIIXsqwj5yTC9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TesomRpO3jOOdq06UkQYpexnRP5ReaIylJsyyGZi8LSTjPoJtzi0dsPJqtgdzUTxsyBdqiBc4bKWf46N7mpMPGSc/m9xUIE3QNL76gPAE1qJXwjcHSsowDK6WhbxxcfSPi8QlpdbVhGmQ9i9TehGyoDwzbIDHsCgu/z4a1iKQZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rZKLsbH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rZKLsbH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B69C433B1;
	Tue, 26 Mar 2024 03:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422091;
	bh=TIXvSyGvRziR7hbSRgVjltj7KHIaMhIIXsqwj5yTC9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rZKLsbH9GFMhGruNXzUUSwYKC3S+CiKqC4kGdPL8CPyFsrdjQuyVr3+sBYm4Hd4Ng
	 H5phVc9JOGai8VfCr0tOU8IWtgc7KtqRx/ksKEQWqnJyqZKkdXijcJmmAZ9tp/Lolz
	 Sxexxag/T/0FxoyyBJcK85iiN3ofaAtZAfNURJuhGPdEs3kTHG3NUpfb+ukugi2A6O
	 vml6VrKspyk2xrZPU02dJ9N3NjAUbuo/BQwVWWv7dsChaKGFSp2z2tzhT4Q5vvJKpy
	 x4ibOXe2TIoluzq/9Ej8ARTGe//UhjpxXNTTkm6WYBrLExseLWKRiRKlLWrj/kUFKi
	 EOM7rSCiBL8ow==
Date: Mon, 25 Mar 2024 20:01:31 -0700
Subject: [PATCH 08/13] xfs_{db,repair}: convert open-coded xfs_rtword_t
 pointer accesses to helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126424.2211955.12925122283880287040.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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
 

