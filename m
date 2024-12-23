Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172C918BBAC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991047; cv=none; b=LNS/1iZ+y44FQ2kOwDvX37I3T1x1v7bfbW6mggngiPmlvUz1eHg2jcmyW+oVFmf73HA+4hY9bhNADFqPiZlHEYcmOjGDi4g2IuDzwlupw+jBPqueXGNSxrPrEM7pl4wQT4Dssokcv11l5vr3vKjQ6pn+Ur6TOjcGjIfgVWvtbbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991047; c=relaxed/simple;
	bh=J6+SqxA7kZkn0HINHyeZN1HJ3CekGL7YYX8UUynpvMY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUlucGtp4eLM5WvL/gtaOFVDpwysJnvtyxE0dCHiYdNV96QUy/+wOadSdy14XUTsr2wia8P2nkxhnR/jpqolXSRVdGKG8kqz9yCZjNTH62CxubA70maKsxwuyJV+rbavnjCb+EBykdNK2vN+RkNPXI34NKLFQF8Nkm4CTlok+qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qfB5tThW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qfB5tThW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8AB6C4CED3;
	Mon, 23 Dec 2024 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991046;
	bh=J6+SqxA7kZkn0HINHyeZN1HJ3CekGL7YYX8UUynpvMY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qfB5tThWy3aNn6cVWJhcE/Z7KB5R16pnevg8OoQtlxi5aJi89/X6Nb2GkTSz5S9BV
	 miVzT3L2sz7E5xPjTbb3YYI5CMD1IPndu41esedwb+tNdNS/ItqjXpKD+TKcxlQVYo
	 T2XWas8+x53PdDdpzpWa9BdRXh2+H3ox2/EgWDF/qhe//sdeqyohRq0TFv7dXiBoa+
	 1XC3vxMaW/v9cCuaJMfrsVXBg29munvEQ5eRH4wOHi5Bnl8GjaIOwsFHMtWY+16j/F
	 yIbj4yw8+ZpQzF+ikInIrWHK1madbSqaDONWmv7tTD/XBHUunIXdXFHgTxvsGdLoMV
	 r9ceHHjvTATeA==
Date: Mon, 23 Dec 2024 13:57:26 -0800
Subject: [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface with the
 kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941944.2295644.931587730201619009.stgit@frogsfrogsfrogs>
In-Reply-To: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
References: <173498941923.2295644.12590815257028938964.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make the userspace xfs_alloc_file_space behave (more or less) like the
kernel version, at least as far as the interface goes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h |    4 +-
 libxfs/util.c    |  140 ++++++++++++++++++++++++++++++++++++------------------
 mkfs/proto.c     |    2 -
 3 files changed, 96 insertions(+), 50 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 348d36be192966..878fefbbde7524 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -176,8 +176,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 /* Shared utility routines */
 
-extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
-				xfs_off_t, int, int);
+int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
+		xfs_off_t len, uint32_t bmapi_flags);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index 97da94506aee01..e5892fc86c3e92 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -179,78 +179,124 @@ libxfs_mod_incore_sb(
  */
 int
 libxfs_alloc_file_space(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	xfs_off_t	len,
-	int		alloc_type,
-	int		attr_flags)
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len,
+	uint32_t		bmapi_flags)
 {
-	xfs_mount_t	*mp;
-	xfs_off_t	count;
-	xfs_filblks_t	datablocks;
-	xfs_filblks_t	allocated_fsb;
-	xfs_filblks_t	allocatesize_fsb;
-	xfs_bmbt_irec_t *imapp;
-	xfs_bmbt_irec_t imaps[1];
-	int		reccount;
-	uint		resblks;
-	xfs_fileoff_t	startoffset_fsb;
-	xfs_trans_t	*tp;
-	int		xfs_bmapi_flags;
-	int		error;
+	xfs_mount_t		*mp = ip->i_mount;
+	xfs_off_t		count;
+	xfs_filblks_t		allocatesize_fsb;
+	xfs_extlen_t		extsz, temp;
+	xfs_fileoff_t		startoffset_fsb;
+	xfs_fileoff_t		endoffset_fsb;
+	int			rt;
+	xfs_trans_t		*tp;
+	xfs_bmbt_irec_t		imaps[1], *imapp;
+	int			error;
 
 	if (len <= 0)
 		return -EINVAL;
 
+	rt = XFS_IS_REALTIME_INODE(ip);
+	extsz = xfs_get_extsz_hint(ip);
+
 	count = len;
-	error = 0;
 	imapp = &imaps[0];
-	reccount = 1;
-	xfs_bmapi_flags = alloc_type ? XFS_BMAPI_PREALLOC : 0;
-	mp = ip->i_mount;
-	startoffset_fsb = XFS_B_TO_FSBT(mp, offset);
-	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
+	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
+	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
+	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
 
-	/* allocate file space until done or until there is an error */
+	/*
+	 * Allocate file space until done or until there is an error
+	 */
 	while (allocatesize_fsb && !error) {
-		datablocks = allocatesize_fsb;
+		xfs_fileoff_t	s, e;
+		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
-		resblks = (uint)XFS_DIOSTRAT_SPACE_RES(mp, datablocks);
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
-					0, 0, &tp);
 		/*
-		 * Check for running out of space
+		 * Determine space reservations for data/realtime.
 		 */
-		if (error) {
-			ASSERT(error == -ENOSPC);
+		if (unlikely(extsz)) {
+			s = startoffset_fsb;
+			do_div(s, extsz);
+			s *= extsz;
+			e = startoffset_fsb + allocatesize_fsb;
+			div_u64_rem(startoffset_fsb, extsz, &temp);
+			if (temp)
+				e += temp;
+			div_u64_rem(e, extsz, &temp);
+			if (temp)
+				e += extsz - temp;
+		} else {
+			s = 0;
+			e = allocatesize_fsb;
+		}
+
+		/*
+		 * The transaction reservation is limited to a 32-bit block
+		 * count, hence we need to limit the number of blocks we are
+		 * trying to reserve to avoid an overflow. We can't allocate
+		 * more than @nimaps extents, and an extent is limited on disk
+		 * to XFS_BMBT_MAX_EXTLEN (21 bits), so use that to enforce the
+		 * limit.
+		 */
+		resblks = min_t(xfs_fileoff_t, (e - s),
+				(XFS_MAX_BMBT_EXTLEN * nimaps));
+		if (unlikely(rt)) {
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+			rblocks = resblks;
+		} else {
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
+			rblocks = 0;
+		}
+
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+				dblocks, rblocks, false, &tp);
+		if (error)
 			break;
-		}
-		xfs_trans_ijoin(tp, ip, 0);
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb, allocatesize_fsb,
-				xfs_bmapi_flags, 0, imapp, &reccount);
+		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error)
+			goto error;
 
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, bmapi_flags, 0, imapp,
+				&nimaps);
 		if (error)
-			goto error0;
+			goto error;
+
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-		/*
-		 * Complete the transaction
-		 */
 		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-		if (reccount == 0)
-			return -ENOSPC;
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
+		/*
+		 * If xfs_bmapi_write finds a delalloc extent at the requested
+		 * range, it tries to convert the entire delalloc extent to a
+		 * real allocation.
+		 * If the allocator cannot find a single free extent large
+		 * enough to cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
+		}
 	}
+
 	return error;
 
-error0:	/* Cancel bmap, cancel trans */
+error:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 05c2621f8a0b13..0764064e043e97 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -203,7 +203,7 @@ rsvfile(
 	int		error;
 	xfs_trans_t	*tp;
 
-	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
+	error = -libxfs_alloc_file_space(ip, 0, llen, XFS_BMAPI_PREALLOC);
 
 	if (error) {
 		fail(_("error reserving space for a file"), error);

