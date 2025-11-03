Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9759A27FD7D;
	Mon,  3 Nov 2025 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191842; cv=none; b=dQnVhPiB7wIcAnCUy8dE1y5HDyoE0qnVrR27HEMfj5BItFPX5N/fI1TZCu7MvjIj1J6WL8OD8n+VCWFXLxUoj9DgeGP1bKQIL7pwAvYEI5vCrqfQKM8C6yiUfTtibocj1BOvQbkr9aOSw0oXQWsO+WX1dkozxjSkpoHgy8/11uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191842; c=relaxed/simple;
	bh=jcDLwxQoWnZuOgWcyNbNEVXxbtdONIoMp74EqDjB870=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Td7NMUf6UFpMa9uizi4DGk7H361yq9Tysyw7e1p36rImyKeZbw8VlcPzacgpv629JXRlsUQVsmg6yOC9utFP8NFuYeI8u2UofBoNTc9nSmBn4Xfwr6q923ZZSoqukOHXMRmUJdxXWUlU3rIKjeuLluySkWkW2JdOX/lUda2xljY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XIJa5JdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XIJa5JdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4F7C4CEE7;
	Mon,  3 Nov 2025 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762191841;
	bh=jcDLwxQoWnZuOgWcyNbNEVXxbtdONIoMp74EqDjB870=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XIJa5JdHhGzEvgTkZ3HmF13Q0QqeRVSTDQScWIw4DfothSQ3HvTrpvhkis6UuKsRM
	 DIcaAMKX0jrKJ0N+55JVxJaT9lJ50HAF9PmSBDm/IkC0NN9NRbBzNxnr+sAY+xl+AX
	 MuHrk+BC6tIPYwgVWRD6+4ise90mA8GcMkg+sJ3q4KUkHY/pooZyH9trkQnEMfzJ3P
	 kioe7wzbX50rtOOMcNXGHXUFEcUTysuftUK9wW/jlKmNHUjuamcsMf9RZ9t7T5rMJI
	 98M7WmBs3JqArZe04Tbamd41Fo5gx7JeXav+iw0zoOMqU4xu5Z3hu3gJ165DmynC9j
	 YlkKeExBh7zzA==
Date: Mon, 3 Nov 2025 09:44:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix various problems in
 xfs_atomic_write_cow_iomap_begin
Message-ID: <20251103174400.GC196370@frogsfrogsfrogs>
References: <20251103174024.GB196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103174024.GB196370@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

I think there are several things wrong with this function:

A) xfs_bmapi_write can return a much larger unwritten mapping than what
   the caller asked for.  We convert part of that range to written, but
   return the entire written mapping to iomap even though that's
   inaccurate.

B) The arguments to xfs_reflink_convert_cow_locked are wrong -- an
   unwritten mapping could be *smaller* than the write range (or even
   the hole range).  In this case, we convert too much file range to
   written state because we then return a smaller mapping to iomap.

C) It doesn't handle delalloc mappings.  This I covered in the patch
   that I already sent to the list.

D) Reassigning count_fsb to handle the hole means that if the second
   cmap lookup attempt succeeds (due to racing with someone else) we
   trim the mapping more than is strictly necessary.  The changing
   meaning of count_fsb makes this harder to notice.

E) The tracepoint is kinda wrong because @length is mutated.  That makes
   it harder to chase the data flows through this function because you
   can't just grep on the pos/bytecount strings.

F) We don't actually check that the br_state = XFS_EXT_NORM assignment
   is accurate, i.e that the cow fork actually contains a written
   mapping for the range we're interested in

G) Somewhat inadequate documentation of why we need to xfs_trim_extent
   so aggressively in this function.

H) Not sure why xfs_iomap_end_fsb is used here, the vfs already clamped
   the write range to s_maxbytes.

Fix these issues, and then the atomic writes regressions in generic/760,
generic/617, generic/091, generic/263, and generic/521 all go away for
me.

Cc: <stable@vger.kernel.org> # v6.16
Fixes: bd1d2c21d5d249 ("xfs: add xfs_atomic_write_cow_iomap_begin()")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |   60 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e1da06b157cf94..469f34034daddd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1091,6 +1091,29 @@ const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
 };
 #endif /* CONFIG_XFS_RT */
 
+#ifdef DEBUG
+static void
+xfs_check_atomic_conversion(
+	struct xfs_inode		*ip,
+	xfs_fileoff_t			offset_fsb,
+	xfs_filblks_t			count_fsb,
+	const struct xfs_bmbt_irec	*cmap)
+{
+	struct xfs_iext_cursor		icur;
+	struct xfs_bmbt_irec		cmap2 = { };
+
+	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &cmap2))
+		xfs_trim_extent(&cmap2, offset_fsb, count_fsb);
+
+	ASSERT(cmap2.br_startoff == cmap->br_startoff);
+	ASSERT(cmap2.br_blockcount == cmap->br_blockcount);
+	ASSERT(cmap2.br_startblock == cmap->br_startblock);
+	ASSERT(cmap2.br_state == cmap->br_state);
+}
+#else
+# define xfs_check_atomic_conversion(...)	((void)0)
+#endif
+
 static int
 xfs_atomic_write_cow_iomap_begin(
 	struct inode		*inode,
@@ -1102,9 +1125,10 @@ xfs_atomic_write_cow_iomap_begin(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	const xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
-	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
+	const xfs_fileoff_t	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	const xfs_fileoff_t	end_fsb = XFS_B_TO_FSB(mp, offset + length);
+	const xfs_filblks_t	count_fsb = end_fsb - offset_fsb;
+	xfs_filblks_t		hole_count_fsb;
 	int			nmaps = 1;
 	xfs_filblks_t		resaligned;
 	struct xfs_bmbt_irec	cmap;
@@ -1143,14 +1167,20 @@ xfs_atomic_write_cow_iomap_begin(
 	if (cmap.br_startoff <= offset_fsb) {
 		if (isnullstartblock(cmap.br_startblock))
 			goto convert;
+
+		/*
+		 * cmap could extend outside the write range due to previous
+		 * speculative preallocations.  We must trim cmap to the write
+		 * range because the cow fork treats written mappings to mean
+		 * "write in progress".
+		 */
 		xfs_trim_extent(&cmap, offset_fsb, count_fsb);
 		goto found;
 	}
 
-	end_fsb = cmap.br_startoff;
-	count_fsb = end_fsb - offset_fsb;
+	hole_count_fsb = cmap.br_startoff - offset_fsb;
 
-	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
+	resaligned = xfs_aligned_fsb_count(offset_fsb, hole_count_fsb,
 			xfs_get_cowextsz_hint(ip));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
@@ -1186,7 +1216,7 @@ xfs_atomic_write_cow_iomap_begin(
 	 * atomic writes to that same range will be aligned (and don't require
 	 * this COW-based method).
 	 */
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+	error = xfs_bmapi_write(tp, ip, offset_fsb, hole_count_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC |
 			XFS_BMAPI_EXTSZALIGN, 0, &cmap, &nmaps);
 	if (error) {
@@ -1199,17 +1229,25 @@ xfs_atomic_write_cow_iomap_begin(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * cmap could map more blocks than the range we passed into bmapi_write
+	 * because of EXTSZALIGN or adjacent pre-existing unwritten mappings
+	 * that were merged.  Trim cmap to the original write range so that we
+	 * don't convert more than we were asked to do for this write.
+	 */
+	xfs_trim_extent(&cmap, offset_fsb, count_fsb);
+
 found:
 	if (cmap.br_state != XFS_EXT_NORM) {
-		error = xfs_reflink_convert_cow_locked(ip, offset_fsb,
-				count_fsb);
+		error = xfs_reflink_convert_cow_locked(ip, cmap.br_startoff,
+				cmap.br_blockcount);
 		if (error)
 			goto out_unlock;
 		cmap.br_state = XFS_EXT_NORM;
+		xfs_check_atomic_conversion(ip, offset_fsb, count_fsb, &cmap);
 	}
 
-	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
-	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
+	trace_xfs_iomap_found(ip, offset, length, XFS_COW_FORK, &cmap);
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
