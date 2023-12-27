Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3217EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Or1NOkjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D0AC433C8;
	Mon,  1 Jan 2024 00:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068581;
	bh=PR8tJjNPh+QFd/tksTfuu153ph65HTziK2Hd8lMZGBY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Or1NOkjkSXzyroGGIM1mi06O6I1BwOArZRHj1zjby6rd6xFdICQ15pitm5A1cwzYg
	 YshP4zMzWwrqEJGOcpTqeWFh1sSvxuPc65towu50+3b9EGNnnHNbDAd3obNt0g0AZG
	 uA/MENlmNXY9dt2FRYDjRncFMaqq0AI33dmrjf43SMjFIiWZNDWpHo2XgRRukfYnKz
	 am2JtNNh7BUGjEbQvI95tCROeRL9VlL9/kE/fSXiFADl9QQQ0MF31ubBn7QAt+LW3D
	 j5TlQ4+tufOj+Lf+vR6wcUOLhhZwn0E8WHCpA+z5JU0cfoyZXO8cSV2NafcI98BPP+
	 v/npPikjOzrCg==
Date: Sun, 31 Dec 2023 16:23:01 +9900
Subject: [PATCH 1/4] libxfs: resync libxfs_alloc_file_space interface with the
 kernel
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016251.1816687.11676235673456526383.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
References: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
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

Make the userspace xfs_alloc_file_space behave (more or less) like the
kernel version, at least as far as the interface goes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h |    4 +-
 libxfs/util.c    |  143 ++++++++++++++++++++++++++++++++++++------------------
 mkfs/proto.c     |    2 -
 3 files changed, 99 insertions(+), 50 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 72f38938f69..1fc8bc0e97b 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -174,8 +174,8 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 
 /* Shared utility routines */
 
-extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
-				xfs_off_t, int, int);
+extern int	libxfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
+					xfs_off_t len, uint32_t bmapi_flags);
 
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
diff --git a/libxfs/util.c b/libxfs/util.c
index 76e49b8637c..aec7798a814 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -179,78 +179,127 @@ libxfs_mod_incore_sb(
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
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+		if (error == -EFBIG)
+			error = xfs_iext_count_upgrade(tp, ip,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
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
index d575d9c511e..5b632d31215 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -205,7 +205,7 @@ rsvfile(
 	int		error;
 	xfs_trans_t	*tp;
 
-	error = -libxfs_alloc_file_space(ip, 0, llen, 1, 0);
+	error = -libxfs_alloc_file_space(ip, 0, llen, XFS_BMAPI_PREALLOC);
 
 	if (error) {
 		fail(_("error reserving space for a file"), error);

