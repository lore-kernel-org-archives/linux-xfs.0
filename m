Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C36BC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebDZztQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AC8C433C8;
	Sun, 31 Dec 2023 22:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060201;
	bh=T31r7Co0p4/Sb543awndAGE4oXM3/AMuUSb7kQA/w6Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ebDZztQP1jkZPEUuXEKqOs02eXOQnrG1if+ne1NtgFt0E+OnYjVgIU2cAWm2uHxqg
	 UyNwt2NP7eimLuO4tLmWuFwoC8nobmV1WhQg/K83W04Dm7NAkxGf/pmaPG64k4jn3y
	 IELPOTg3wO8TXi+Ido6K/k+EPnUYnkXwUxXM04RCjDk931ssmdO+wZAlpxMZob6JX3
	 6VhNRcZINhdUn/pJ45SGdJXVj2fk7MjpzTBjpgGcHNq/fbFuqXF5f27wuE3W0EnAQv
	 ou7BPotG0f+VFFR5dVhcS5F/eoazFJVp79bkJ3Z23xMDrtT/kaHEMjJgzpECwTdOpu
	 udxsTHowQFVJQ==
Date: Sun, 31 Dec 2023 14:03:20 -0800
Subject: [PATCH 2/4] xfs: make file data allocations observe the 'forcealign'
 flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Message-ID: <170404855929.1770028.8502538039360735032.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
References: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
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

The existing extsize hint code already did the work of expanding file
range mapping requests so that the range is aligned to the hint value.
Now add the code we need to guarantee that the space allocations are
also always aligned.

Co-developed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   48 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c       |    4 +++-
 fs/xfs/xfs_reflink.c     |    4 ++++
 3 files changed, 51 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7d0d82353a745..b14761ec96b87 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3351,6 +3351,17 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static inline bool
+xfs_bmap_use_forcealign(
+	const struct xfs_bmalloca	*ap)
+{
+	if (!xfs_inode_force_align(ap->ip))
+		return false;
+
+	return  (ap->flags & XFS_BMAPI_COWFORK) ||
+		(ap->datatype & XFS_ALLOC_USERDATA);
+}
+
 static int
 xfs_bmap_compute_alignments(
 	struct xfs_bmalloca	*ap,
@@ -3366,6 +3377,17 @@ xfs_bmap_compute_alignments(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
+	/*
+	 * File data mappings with forced alignment can use the stripe
+	 * alignment if it's a multiple of the forcealign value.  Otherwise,
+	 * use the regular forcealign value.
+	 */
+	if (xfs_bmap_use_forcealign(ap)) {
+		if (!stripe_align || stripe_align % mp->m_sb.sb_rextsize)
+			stripe_align = mp->m_sb.sb_rextsize;
+		args->alignment = stripe_align;
+	}
+
 	if (ap->flags & XFS_BMAPI_COWFORK)
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (ap->datatype & XFS_ALLOC_USERDATA)
@@ -3438,6 +3460,9 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 	ASSERT(ap->length);
 
+	if (xfs_inode_force_align(ap->ip))
+		return -ENOSPC;
+
 	if (ap->minlen != 1) {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
@@ -3511,6 +3536,7 @@ xfs_bmap_btalloc_at_eof(
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*caller_pag = args->pag;
+	int			orig_alignment = args->alignment;
 	int			error;
 
 	/*
@@ -3585,10 +3611,10 @@ xfs_bmap_btalloc_at_eof(
 
 	/*
 	 * Allocation failed, so turn return the allocation args to their
-	 * original non-aligned state so the caller can proceed on allocation
-	 * failure as if this function was never called.
+	 * original state so the caller can proceed on allocation failure as
+	 * if this function was never called.
 	 */
-	args->alignment = 1;
+	args->alignment = orig_alignment;
 	return 0;
 }
 
@@ -3611,6 +3637,10 @@ xfs_bmap_btalloc_low_space(
 {
 	int			error;
 
+	/* Don't try unaligned last-chance allocations with forcealign */
+	if (xfs_inode_force_align(ap->ip))
+		return -ENOSPC;
+
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
@@ -4115,7 +4145,9 @@ xfs_bmap_alloc_userdata(
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
 
-		if (mp->m_dalign && bma->length >= mp->m_dalign) {
+		/* forcealign mode reuses the stripe unit alignment code */
+		if (xfs_inode_force_align(bma->ip) ||
+		    (mp->m_dalign && bma->length >= mp->m_dalign)) {
 			error = xfs_bmap_isaeof(bma, whichfork);
 			if (error)
 				return error;
@@ -6381,6 +6413,10 @@ xfs_extlen_t
 xfs_get_extsz_hint(
 	struct xfs_inode	*ip)
 {
+	/* forcealign means we align to rextsize */
+	if (xfs_inode_force_align(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+
 	/*
 	 * No point in aligning allocations if we need to COW to actually
 	 * write to them.
@@ -6405,6 +6441,10 @@ xfs_get_cowextsz_hint(
 {
 	xfs_extlen_t		a, b;
 
+	/* forcealign means we align to rextsize */
+	if (xfs_inode_force_align(ip))
+		return ip->i_mount->m_sb.sb_rextsize;
+
 	a = 0;
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 559e8e7855952..3bfbcbed1bd68 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -185,7 +185,9 @@ xfs_eof_alignment(
 		 * If mounted with the "-o swalloc" option the alignment is
 		 * increased from the strip unit size to the stripe width.
 		 */
-		if (mp->m_swidth && xfs_has_swalloc(mp))
+		if (xfs_inode_force_align(ip))
+			align = xfs_get_extsz_hint(ip);
+		else if (mp->m_swidth && xfs_has_swalloc(mp))
 			align = mp->m_swidth;
 		else if (mp->m_dalign)
 			align = mp->m_dalign;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0c54522404963..da39da13fcd7d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1803,6 +1803,10 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
+	/* XXX Can't reflink forcealign files for now */
+	if (xfs_inode_force_align(src) || xfs_inode_force_align(dest))
+		goto out_unlock;
+
 	/* Check non-power of two alignment issues, if necessary. */
 	if (XFS_IS_REALTIME_INODE(dest) && !is_power_of_2(alloc_unit)) {
 		ret = xfs_reflink_remap_check_rtalign(src, pos_in, dest,

