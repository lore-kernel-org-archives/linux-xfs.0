Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25001F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529036; cv=none; b=KvyONHR4YDY3l92Mx9wbqLe0XHVGfkTmrM5yBmkXOmO7zgNYWl/DEdG7EDtfeaalUEUP+d4VYGc3sT0+PCUEobyUym2rg90X4FeSa99QU5BFTxIGwsYXPRWLTMGGLRVG7b8jgxf6Tvf2DghScJEXgGv/+rfGiRayhH1ir9n9j9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529036; c=relaxed/simple;
	bh=TvQEHQibBWDOgj08toEA7hDVzY0RRGueb/sJ/z9q7qY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LhNHbj5lBlTWW2DITDgLU/vXCftgAGUgLXBUjgwSvyjY9h6n/xvi2+cs8xYwgpQ1h0dmi1RkOkdneLHUbyG0Rl+l9R5PiwBMApx7NMcqH7UmPXwckMy099J2QP8texg4UJZNyZzCng6fuo65+10z6cxv1a5Maz3j895f11sci6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2ks1uq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2ks1uq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C912DC4CED1;
	Fri,  6 Dec 2024 23:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529035;
	bh=TvQEHQibBWDOgj08toEA7hDVzY0RRGueb/sJ/z9q7qY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K2ks1uq1BM7srJb28BhOQH0aVB2qbHOQ4TrjNQvov1xU9KH8q7Dv3oDeFm2nUw47p
	 z5Z3Eg5Y0G0gEOCPxH1XFtd/0ocyb/EjYzRSa09zj7kjfkwRKb0VITqb79DNbBPo/A
	 S6sLwHjvIR4xABU5agm1W1ix7UjUXQU/oRwAXQDOtMxRWosDC1CtGiTTSeQ+l5+jar
	 gT3UC96x+C+euSTso4Xz3RHtzJc1+7eutfXUqaJOhOq2Zs3XY/435HLj5g73n2DYmO
	 oqIz4SH8yywRYw6p3a2xWQsQIk/gLBZVxnbtogbY+/T7a042JUZ7SrNXGDlViujaa8
	 zfLI8BETMbnyQ==
Date: Fri, 06 Dec 2024 15:50:35 -0800
Subject: [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface with the
 kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352749331.124368.17875844919571380397.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
References: <173352749310.124368.15119896789476594437.stgit@frogsfrogsfrogs>
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

