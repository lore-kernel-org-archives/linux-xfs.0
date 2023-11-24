Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D9139FC7
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lj5KTB5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F96C433C7;
	Fri, 24 Nov 2023 23:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870068;
	bh=mcm/XGFnFMclrKboN/vLCTu34tgtNgln6XYDXKD0eGI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lj5KTB5JHtC6VpqqKW531LzHD6cGPe7P2gE8x8fSFFX5JOHuR1YZPmQE0ARkbQGQs
	 wf0fj5QEpnlLIBRCQc/j+5JnRl1Rhy+ULdRrU4uNj0fgKlL2yioEGKMvvmipLDnqLk
	 MhKE5DgclF8XaAvDs5MOcseZwB3Nr2Y/xZMbdMimPDss9xINJI4YiXK/C2y7idrLrU
	 weofQdCQyKcMnATgs5Ef88smh0aPiD7xgTaZui2kwv3kMYZA9mU3KrGfuXbpcdXdDo
	 H3nOkktbywLHiSP1FctF7Ol4jU9pN+EXIG2fy7zsqqjLir8gaemneRszVLdIiwPnPU
	 eAiT/czEK7m8g==
Date: Fri, 24 Nov 2023 15:54:28 -0800
Subject: [PATCH 1/6] xfs: check rt bitmap file geometry more thoroughly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928361.2771542.12276270495680939208.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

I forgot that the superblock tracks the number of blocks that are in the
realtime bitmap, and that the rt bitmap file can have more blocks mapped
to the data fork than sb_rbmblocks if growfsrt fails.

So.  Add to the rtbitmap scrubber an explicit check that sb_rextents and
sb_rbmblocks are correct, then adjust the rtbitmap i_size checks to
allow for the growfsrt failure case.  Finally, flag post-eof blocks in
the rtbitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtbitmap.c |   97 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 82 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index d509a08d3fc3e..3b5b62fbf4e0a 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -14,16 +14,30 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bit.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
+struct xchk_rtbitmap {
+	uint64_t		rextents;
+	uint64_t		rbmblocks;
+	unsigned int		rextslog;
+};
+
 /* Set us up with the realtime metadata locked. */
 int
 xchk_setup_rtbitmap(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rtbitmap	*rtb;
 	int			error;
 
+	rtb = kzalloc(sizeof(struct xchk_rtbitmap), XCHK_GFP_FLAGS);
+	if (!rtb)
+		return -ENOMEM;
+	sc->buf = rtb;
+
 	error = xchk_trans_alloc(sc, 0);
 	if (error)
 		return error;
@@ -37,6 +51,15 @@ xchk_setup_rtbitmap(
 		return error;
 
 	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
+
+	/*
+	 * Now that we've locked the rtbitmap, we can't race with growfsrt
+	 * trying to expand the bitmap or change the size of the rt volume.
+	 * Hence it is safe to compute and check the geometry values.
+	 */
+	rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
+	rtb->rextslog = rtb->rextents ? xfs_highbit32(rtb->rextents) : 0;
+	rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
 	return 0;
 }
 
@@ -67,21 +90,30 @@ STATIC int
 xchk_rtbitmap_check_extents(
 	struct xfs_scrub	*sc)
 {
-	struct xfs_mount	*mp = sc->mp;
 	struct xfs_bmbt_irec	map;
-	xfs_rtblock_t		off;
-	int			nmap;
+	struct xfs_iext_cursor	icur;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	xfs_fileoff_t		off = 0;
+	xfs_fileoff_t		endoff;
 	int			error = 0;
 
-	for (off = 0; off < mp->m_sb.sb_rbmblocks;) {
+	/* Mappings may not cross or lie beyond EOF. */
+	endoff = XFS_B_TO_FSB(mp, ip->i_disk_size);
+	if (xfs_iext_lookup_extent(ip, &ip->i_df, endoff, &icur, &map)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, endoff);
+		return 0;
+	}
+
+	while (off < endoff) {
+		int		nmap = 1;
+
 		if (xchk_should_terminate(sc, &error) ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 			break;
 
 		/* Make sure we have a written extent. */
-		nmap = 1;
-		error = xfs_bmapi_read(mp->m_rbmip, off,
-				mp->m_sb.sb_rbmblocks - off, &map, &nmap,
+		error = xfs_bmapi_read(ip, off, endoff - off, &map, &nmap,
 				XFS_DATA_FORK);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, off, &error))
 			break;
@@ -102,12 +134,48 @@ int
 xchk_rtbitmap(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rtbitmap	*rtb = sc->buf;
 	int			error;
 
-	/* Is the size of the rtbitmap correct? */
-	if (sc->mp->m_rbmip->i_disk_size !=
-	    XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks)) {
-		xchk_ino_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
+	/* Is sb_rextents correct? */
+	if (mp->m_sb.sb_rextents != rtb->rextents) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return 0;
+	}
+
+	/* Is sb_rextslog correct? */
+	if (mp->m_sb.sb_rextslog != rtb->rextslog) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return 0;
+	}
+
+	/*
+	 * Is sb_rbmblocks large enough to handle the current rt volume?  In no
+	 * case can we exceed 4bn bitmap blocks since the super field is a u32.
+	 */
+	if (rtb->rbmblocks > U32_MAX) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return 0;
+	}
+	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return 0;
+	}
+
+	/* The bitmap file length must be aligned to an fsblock. */
+	if (mp->m_rbmip->i_disk_size & mp->m_blockmask) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		return 0;
+	}
+
+	/*
+	 * Is the bitmap file itself large enough to handle the rt volume?
+	 * growfsrt expands the bitmap file before updating sb_rextents, so the
+	 * file can be larger than sb_rbmblocks.
+	 */
+	if (mp->m_rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
+		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
 		return 0;
 	}
 
@@ -120,12 +188,11 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtbitmap_rec, sc);
+	error = xfs_rtalloc_query_all(mp, sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		goto out;
+		return error;
 
-out:
-	return error;
+	return 0;
 }
 
 /* xref check that the extent is not free in the rtbitmap */

