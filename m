Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE7A19884C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637079; cv=none; b=oBNNlS/q8U4yh4UBE9FEyubIYJAdWDKaNwi9KErexwHHx6YPOZLxaG8/8J/Pjk6GycoGPOKaxpJVdY+ijBUEew2FpslrC2YrUf40q3m09P6DWoOmTSFkdStk/XN8UB5UTlSKsEyFUsdbikJasAU9PWSB7qmf2CDCTPD36GQbE98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637079; c=relaxed/simple;
	bh=krTqPSDbEL4Uf4dmqOY5JcZGYJBUioGdHSoLVkGzkCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7bM+lTyKYTc3+giTEXAqTY/dadK3u1uCmYRaj5sxBTk//Kq5GpIWXZGSZCGb6hBZ4/Gz8+l+aVc1pGh13/VLxYkY+TTIOg6/Z0H8HNFGHIL5QZUs6uJgsjRbWo0GyhbUKqlh2AFsx8fOl/t/PPoRNzp8u9wtaymqexzursNxzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsoBpaKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsoBpaKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6E5C4CECE;
	Thu, 19 Dec 2024 19:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637079;
	bh=krTqPSDbEL4Uf4dmqOY5JcZGYJBUioGdHSoLVkGzkCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lsoBpaKkF4y/UhmJWUdCyu3erMyBYVJH5QkHZDhVhPU2Wi5aMfZ/hPtRS3iDGkkM4
	 B4QwDghU+o63J/Ix5ZWeNWJmo3mF0vrPs7t7zfvAxqAiy3J1DpIB7gMpLrBSBbpzgv
	 JtUUgH4SvqC2OAjfSdF0MECJ6OWC0OaV6cwx+XOV0FO467l5BWkkMFXzWMT3NZqEUN
	 uKyrHzqDZtXSf6xc3+syZjuBLPH1BzZC6bYBY/6OMCttgXlGtNNNa0waMhx2LGLJn1
	 Ey/KXvXZELBlMiMrSOe8SanMwhTfdiUtKEqsENs1g6k4Wun0dQmzoE3Bg0TlC38YVo
	 iM7PeA0SDOaxQ==
Date: Thu, 19 Dec 2024 11:37:59 -0800
Subject: [PATCH 19/43] xfs: enable CoW for realtime data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581304.1572761.16104892994654937567.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update our write paths to support copy on write on the rt volume.  This
works in more or less the same way as it does on the data device, with
the major exception that we never do delalloc on the rt volume.

Because we consider unwritten CoW fork staging extents to be incore
quota reservation, we update xfs_quota_reserve_blkres to support this
case.  Though xfs doesn't allow rt and quota together, the change is
trivial and we shouldn't leave a logic bomb here.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 29574b015fddc0..24f545687b8730 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -439,20 +439,26 @@ xfs_reflink_fill_cow_hole(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
-	xfs_extlen_t		resblks;
+	unsigned int		dblocks = 0, rblocks = 0;
 	int			nimaps;
 	int			error;
 	bool			found;
 
 	resaligned = xfs_aligned_fsb_count(imap->br_startoff,
 		imap->br_blockcount, xfs_get_cowextsz_hint(ip));
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+		rblocks = 0;
+	}
 
 	xfs_iunlock(ip, *lockmode);
 	*lockmode = 0;
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
-			false, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+			rblocks, false, &tp);
 	if (error)
 		return error;
 
@@ -1212,7 +1218,7 @@ xfs_reflink_remap_extent(
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
 	int64_t			qdelta = 0;
-	unsigned int		resblks;
+	unsigned int		dblocks, rblocks, resblks;
 	bool			quota_reserved = true;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1243,8 +1249,15 @@ xfs_reflink_remap_extent(
 	 * we're remapping.
 	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		dblocks = resblks;
+		rblocks = dmap->br_blockcount;
+	} else {
+		dblocks = resblks + dmap->br_blockcount;
+		rblocks = 0;
+	}
 	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
-			resblks + dmap->br_blockcount, 0, false, &tp);
+			dblocks, rblocks, false, &tp);
 	if (error == -EDQUOT || error == -ENOSPC) {
 		quota_reserved = false;
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
@@ -1324,8 +1337,15 @@ xfs_reflink_remap_extent(
 	 * done.
 	 */
 	if (!quota_reserved && !smap_real && dmap_written) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip,
-				dmap->br_blockcount, 0, false);
+		if (XFS_IS_REALTIME_INODE(ip)) {
+			dblocks = 0;
+			rblocks = dmap->br_blockcount;
+		} else {
+			dblocks = dmap->br_blockcount;
+			rblocks = 0;
+		}
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+				false);
 		if (error)
 			goto out_cancel;
 	}

