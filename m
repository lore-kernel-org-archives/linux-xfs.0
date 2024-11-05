Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F003433B5
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845764; cv=none; b=hf3N5MJILNxiCHWqjWhymtuneaFhmcztnC0gs2shYPEVEdxMTnlPQBhVSNyZCSBKWpj6zuHEppI/bJknHyKa62mDjucqHIbf3FaooO3TQAIuhi+rxJ2HXFCHPd9p8aq2JzaGpnVJkVFQbS5ViYpWvbHg9XvIrKvHV3fPsl/segI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845764; c=relaxed/simple;
	bh=Y7IeuFXHlSwc+9gEcXB07Kzn1QD0YV7+tAX6asyKgzY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTrXsvelzUt1j1WAGjVFdDfFtoA5NcMwNq3efSZsK+cCGmL0aMcRBPkz+/0zgtLpIsZkp/0gJnecVkF6OvMpnCq3upe60qjeyvAklRJcmGps3+sAToiL/VxuETMgN20PvvsS6lTb4ON2hnDrg7LebMIqCrXawXfs0AXNuY335wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M518QZjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M518QZjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95482C4CECF;
	Tue,  5 Nov 2024 22:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845763;
	bh=Y7IeuFXHlSwc+9gEcXB07Kzn1QD0YV7+tAX6asyKgzY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M518QZjLGDvJSKBCvu1dH3RQjNqKYalAV0J5sshRe0qYzxuEC3yl3C+iaoMh8BfFv
	 1WE0MjYYcdkPES5LD8uw0USOqi82wHy5WIqnfidvqM84lNxTPmzAEc2OZKqIj090q9
	 8BiHf6PpVeqJo4ywOAoxVbkmhLxhiYXPBYgd4i6qC8nXQi/9NaXMaMgvER6DUxu67w
	 NnDr+ZOZVW4Bb2mDsLq0pzdNRi0An+u2SlkLFZINe605c+WSCr7MjS2ftmxKNrgSPo
	 mOQ5GImZlMqd/hoQPPoOAgHL+9nQQxSR5VBXLfQhDj1BqHZ/zmEttrFu9sPg+e4T/z
	 j7WUVKKEyEXtw==
Date: Tue, 05 Nov 2024 14:29:23 -0800
Subject: [PATCH 21/21] xfs: make RT extent numbers relative to the rtgroup
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397298.1871025.16779315755137356707.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

To prepare for adding per-rtgroup bitmap files, make the xfs_rtxnum_t
type encode the RT extent number relative to the rtgroup.  The biggest
part of this to clearly distinguish between the relative extent number
that gets masked when converting from a global block number and length
values that just have a factor applied to them when converting from
file system blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    6 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h |   69 ++++++++++++++++++++++++++----------------
 fs/xfs/scrub/rtbitmap.c      |    9 ++---
 fs/xfs/scrub/rtsummary.c     |    6 ++--
 fs/xfs/xfs_discard.c         |    4 +-
 fs/xfs/xfs_fsmap.c           |   11 ++++---
 fs/xfs/xfs_iomap.c           |    4 +-
 fs/xfs/xfs_mount.c           |    2 +
 fs/xfs/xfs_rtalloc.c         |    4 +-
 fs/xfs/xfs_super.c           |    3 +-
 10 files changed, 68 insertions(+), 50 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7ba75b4d161618..9bfa8247854d41 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4094,7 +4094,7 @@ xfs_bmapi_reserve_delalloc(
 
 	fdblocks = indlen;
 	if (XFS_IS_REALTIME_INODE(ip)) {
-		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
 		if (error)
 			goto out_unreserve_quota;
 	} else {
@@ -4129,7 +4129,7 @@ xfs_bmapi_reserve_delalloc(
 
 out_unreserve_frextents:
 	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
@@ -5037,7 +5037,7 @@ xfs_bmap_del_extent_delay(
 	fdblocks = da_diff;
 
 	if (isrt)
-		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
+		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 776cca9e41bf05..b2b9e59a87a278 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -22,13 +22,37 @@ struct xfs_rtalloc_args {
 
 static inline xfs_rtblock_t
 xfs_rtx_to_rtb(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rtxnum_t		rtx)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rtblock_t		start = xfs_rgno_start_rtb(mp, rtg_rgno(rtg));
+
+	if (mp->m_rtxblklog >= 0)
+		return start + (rtx << mp->m_rtxblklog);
+	return start + (rtx * mp->m_sb.sb_rextsize);
+}
+
+/* Convert an rgbno into an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rgbno_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rgblock_t		rgbno)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return rgbno >> mp->m_rtxblklog;
+	return rgbno / mp->m_sb.sb_rextsize;
+}
+
+static inline uint64_t
+xfs_rtbxlen_to_blen(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtbxlen)
 {
 	if (mp->m_rtxblklog >= 0)
-		return rtx << mp->m_rtxblklog;
+		return rtbxlen << mp->m_rtxblklog;
 
-	return rtx * mp->m_sb.sb_rextsize;
+	return rtbxlen * mp->m_sb.sb_rextsize;
 }
 
 static inline xfs_extlen_t
@@ -65,16 +89,29 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+/* Convert an rt block count into an rt extent count. */
+static inline xfs_rtbxlen_t
+xfs_blen_to_rtbxlen(
+	struct xfs_mount	*mp,
+	uint64_t		blen)
+{
+	if (likely(mp->m_rtxblklog >= 0))
+		return blen >> mp->m_rtxblklog;
+
+	return div_u64(blen, mp->m_sb.sb_rextsize);
+}
+
 /* Convert an rt block number into an rt extent number. */
 static inline xfs_rtxnum_t
 xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (likely(mp->m_rtxblklog >= 0))
-		return rtbno >> mp->m_rtxblklog;
+	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
 
-	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+	if (likely(mp->m_rtxblklog >= 0))
+		return __rgbno >> mp->m_rtxblklog;
+	return div_u64(__rgbno, mp->m_sb.sb_rextsize);
 }
 
 /* Return the offset of an rt block number within an rt extent. */
@@ -89,26 +126,6 @@ xfs_rtb_to_rtxoff(
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/*
- * Convert an rt block number into an rt extent number, rounding up to the next
- * rt extent if the rt block is not aligned to an rt extent boundary.
- */
-static inline xfs_rtxnum_t
-xfs_rtb_to_rtxup(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	if (likely(mp->m_rtxblklog >= 0)) {
-		if (rtbno & mp->m_rtxblkmask)
-			return (rtbno >> mp->m_rtxblklog) + 1;
-		return rtbno >> mp->m_rtxblklog;
-	}
-
-	if (do_div(rtbno, mp->m_sb.sb_rextsize))
-		rtbno++;
-	return rtbno;
-}
-
 /* Round this rtblock up to the nearest rt extent size. */
 static inline xfs_rtblock_t
 xfs_rtb_roundup_rtx(
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index ababbf4068d600..376a36fd9a9cdd 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -65,7 +65,7 @@ xchk_setup_rtbitmap(
 	 */
 	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
-		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
+		rtb->rextents = xfs_blen_to_rtbxlen(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
 		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp);
 	}
@@ -83,15 +83,14 @@ xchk_rtbitmap_rec(
 	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
 {
-	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_scrub	*sc = priv;
 	xfs_rtblock_t		startblock;
 	xfs_filblks_t		blockcount;
 
-	startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	blockcount = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	startblock = xfs_rtx_to_rtb(rtg, rec->ar_startext);
+	blockcount = xfs_rtxlen_to_extlen(rtg_mount(rtg), rec->ar_extcount);
 
-	if (!xfs_verify_rtbext(mp, startblock, blockcount))
+	if (!xfs_verify_rtbext(rtg_mount(rtg), startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 4125883c6da080..8f3f69b26cad04 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -102,7 +102,7 @@ xchk_setup_rtsummary(
 	 */
 	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
-		rts->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
+		rts->rextents = xfs_blen_to_rtbxlen(mp, mp->m_sb.sb_rblocks);
 		rts->rbmblocks = xfs_rtbitmap_blockcount(mp);
 		rts->rsumblocks =
 			xfs_rtsummary_blockcount(mp, &rts->rsumlevels);
@@ -182,8 +182,8 @@ xchk_rtsum_record_free(
 	lenlog = xfs_highbit64(rec->ar_extcount);
 	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
 
-	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	rtbno = xfs_rtx_to_rtb(rtg, rec->ar_startext);
+	rtlen = xfs_rtxlen_to_extlen(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc,
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index fe9d6b81ea2a2f..4f3e4736f13ea6 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -526,8 +526,8 @@ xfs_trim_gather_rtextent(
 		return -ECANCELED;
 	}
 
-	rbno = xfs_rtx_to_rtb(rtg_mount(rtg), rec->ar_startext);
-	rlen = xfs_rtx_to_rtb(rtg_mount(rtg), rec->ar_extcount);
+	rbno = xfs_rtx_to_rtb(rtg, rec->ar_startext);
+	rlen = xfs_rtbxlen_to_blen(rtg_mount(rtg), rec->ar_extcount);
 
 	/* Ignore too small. */
 	if (rlen < tr->minlen_fsb) {
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index b14e0e306f8a34..82f2e0dd224997 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -722,7 +722,10 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	};
 	struct xfs_mount		*mp = rtg_mount(rtg);
 	struct xfs_getfsmap_info	*info = priv;
-	xfs_rtblock_t			rtbno;
+	xfs_rtblock_t			start_rtb =
+				xfs_rtx_to_rtb(rtg, rec->ar_startext);
+	uint64_t			rtbcount =
+				xfs_rtbxlen_to_blen(mp, rec->ar_extcount);
 
 	/*
 	 * For an info->last query, we're looking for a gap between the last
@@ -736,12 +739,10 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL) {
 		frec.start_daddr = info->end_daddr;
 	} else {
-		rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-		frec.start_daddr = xfs_rtb_to_daddr(mp, rtbno);
+		frec.start_daddr = xfs_rtb_to_daddr(mp, start_rtb);
 	}
 
-	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
-	frec.len_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	frec.len_daddr = XFS_FSB_TO_BB(mp, rtbcount);
 	return xfs_getfsmap_helper(tp, info, &frec);
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 86da16f54be9d7..e810e901cd3576 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -501,8 +501,8 @@ xfs_iomap_prealloc_size(
 				       alloc_blocks);
 
 	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
-		freesp = xfs_rtx_to_rtb(mp,
-			xfs_iomap_freesp(&mp->m_frextents,
+		freesp = xfs_rtbxlen_to_blen(mp,
+				xfs_iomap_freesp(&mp->m_frextents,
 					mp->m_low_rtexts, &shift));
 	else
 		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 9464eddf9212e9..dba1f6fc688166 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1474,7 +1474,7 @@ xfs_mod_delalloc(
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
 		percpu_counter_add_batch(&mp->m_delalloc_rtextents,
-				xfs_rtb_to_rtx(mp, data_delta),
+				xfs_blen_to_rtbxlen(mp, data_delta),
 				XFS_DELALLOC_BATCH);
 		if (!ind_delta)
 			return;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 2a5c7c1856c912..d9fb5e9c0aaf87 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -748,7 +748,7 @@ xfs_growfs_rt_alloc_fake_mount(
 	nmp->m_sb.sb_rextsize = rextsize;
 	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
 	nmp->m_sb.sb_rblocks = rblocks;
-	nmp->m_sb.sb_rextents = xfs_rtb_to_rtx(nmp, nmp->m_sb.sb_rblocks);
+	nmp->m_sb.sb_rextents = xfs_blen_to_rtbxlen(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
 	nmp->m_sb.sb_rextslog = xfs_compute_rextslog(nmp->m_sb.sb_rextents);
 	nmp->m_rsumblocks = xfs_rtsummary_blockcount(nmp, &nmp->m_rsumlevels);
@@ -1463,7 +1463,7 @@ xfs_rtallocate(
 	xfs_trans_mod_sb(tp, wasdel ?
 			XFS_TRANS_SB_RES_FREXTENTS : XFS_TRANS_SB_FREXTENTS,
 			-(long)len);
-	*bno = xfs_rtx_to_rtb(args.mp, rtx);
+	*bno = xfs_rtx_to_rtb(args.rtg, rtx);
 	*blen = xfs_rtxlen_to_extlen(args.mp, len);
 
 out_release:
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index be493d39296005..9ae352dfdd6c57 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -885,7 +885,8 @@ xfs_fs_statfs(
 
 		statp->f_blocks = sbp->sb_rblocks;
 		freertx = percpu_counter_sum_positive(&mp->m_frextents);
-		statp->f_bavail = statp->f_bfree = xfs_rtx_to_rtb(mp, freertx);
+		statp->f_bavail = statp->f_bfree =
+			xfs_rtbxlen_to_blen(mp, freertx);
 	}
 
 	return 0;

