Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2A5444707
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319630; cv=none; b=A0QgQqDsxXglKQ1gXSPxuaI05F8JLCupWzp1fr7slNE+xfArKQv2dUvmyBCWJzDLprdeCi5h1nNio7RDJD7avuxPIh+Og0MQ4icXV1AT1juyndSvmzo3uCwPEcxWKNU6b+ZDzzF2tqA9PtPYGLeZD6SZHIHzGjtmG/IQH5YtsWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319630; c=relaxed/simple;
	bh=Lp1oYgCHof3/KVYuE2Af6LNIu05L32RauO6417BDAqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPlrH+oS5Gua4mKd/eBnmxWAEiVzdPJP0nD8+TlXI5dkizbNpjib+xKGNQPwlQYCSzM3yYMOxbmkULMQ/SrrEJU0vX+lla+I+4ShKyvDfhkEbM92IZAEd3dWwIjrmsiowgyEnRhLdllp5XHaUG47sGxVec/LiEemEIvU93bNw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOhG0I4S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOhG0I4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA321F00A3D;
	Wed, 29 Jul 2026 10:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319629;
	bh=eYzFO9YzwydoMy+37g3ijPNXcdc7nZruYIUK97ZjWnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOhG0I4SDqYPYYEH1dg2xJaf5n2oGcHEpLebcZy3tEnUSu0UIn37uEXfGwVhoKoD3
	 +6XSORFu8UqouPWdsbn1fIrdaqCFtDYAiatSnaxabGfmrHi0pQdIyoY9CSVKI0h8dD
	 WXX/kb4Fjjf+RKocTAVliaAs7u+RZFcqXsLygcN4PV8C2hYaL/cY/irkBgD1qoZ26Q
	 PJmKgZfpOMKWU9WDCfTI6Nlp2CXVx8CxNDIm1VpDagPa/sz12huh4tik78shVArB8Z
	 I0sQ+D6C8Wqrf1QQXcSm5VK8bmjoqiConFpfPtgaskxlsHGTJTaZqsuwn/Un7axAKG
	 w1y8C4ODNh98A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 29/33] xfs: convert xfs_direct_write_iomap_begin to use dwa struct throughout
Date: Wed, 29 Jul 2026 20:02:13 +1000
Message-ID: <20260729100629.1943710-30-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs_direct_write_iomap_begin() to use a single
xfs_direct_write_args struct (dwa) allocated on the stack instead
of individual local variables for the fields that are passed down
the call chain.

This replaces the temporary args struct construction at each call
site with a single struct initialised at function entry. The
imap, nimaps, lockmode, iomap_flags, and other fields that were
previously local variables are now accessed through dwa.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 109 +++++++++++++++++++--------------------------
 1 file changed, 47 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ed80b23115bf..b388ded20ffc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1043,14 +1043,21 @@ xfs_direct_write_iomap_begin(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	imap;
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	struct xfs_direct_write_args dwa = {
+		.ip		= ip,
+		.offset_fsb	= XFS_B_TO_FSBT(mp, offset),
+		.offset		= offset,
+		.length		= length,
+		.flags		= flags,
+		.nimaps		= 1,
+		.convert_now	= (flags & IOMAP_DIRECT) || IS_DAX(inode),
+		.iomap		= iomap,
+		.srcmap		= srcmap,
+	};
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 	xfs_fileoff_t		orig_end_fsb = end_fsb;
-	int			nimaps = 1, error = 0;
-	u16			iomap_flags = 0;
 	bool			needs_alloc;
-	unsigned int		lockmode;
+	int			error = 0;
 	u64			seq;
 
 	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
@@ -1064,49 +1071,36 @@ xfs_direct_write_iomap_begin(
 	 * there is no other metadata changes pending or have been made here.
 	 */
 	if (offset + length > i_size_read(inode))
-		iomap_flags |= IOMAP_F_DIRTY;
+		dwa.iomap_flags |= IOMAP_F_DIRTY;
 
 	/* HW-offload atomics are always used in this path */
 	if (flags & IOMAP_ATOMIC)
-		iomap_flags |= IOMAP_F_ATOMIC_BIO;
+		dwa.iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
 	if (xfs_is_cow_inode(ip)) {
-		struct xfs_direct_write_args cow_args = {
-			.ip		= ip,
-			.offset		= offset,
-			.length		= length,
-			.flags		= flags,
-			.iomap_flags	= iomap_flags,
-			.convert_now	= (flags & IOMAP_DIRECT) ||
-					  IS_DAX(inode),
-			.iomap		= iomap,
-			.srcmap		= srcmap,
-		};
-
-		error = xfs_direct_write_cow_iomap_begin(&cow_args, true);
+		error = xfs_direct_write_cow_iomap_begin(&dwa, true);
 		if (error)
 			return error;
-		if (!cow_args.nimaps)
+		if (!dwa.nimaps)
 			return 0;
 
-		imap = cow_args.imap;
-		lockmode = cow_args.lockmode;
-		end_fsb = imap.br_startoff + imap.br_blockcount;
-		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
+		end_fsb = dwa.imap.br_startoff + dwa.imap.br_blockcount;
+		dwa.length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	} else {
-		lockmode = XFS_ILOCK_SHARED;
+		dwa.lockmode = XFS_ILOCK_SHARED;
 
-		error = xfs_ilock_for_iomap(ip, flags, &lockmode);
+		error = xfs_ilock_for_iomap(ip, flags, &dwa.lockmode);
 		if (error)
 			return error;
 
-		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, 0);
+		error = xfs_bmapi_read(ip, dwa.offset_fsb,
+				end_fsb - dwa.offset_fsb,
+				&dwa.imap, &dwa.nimaps, 0);
 		if (error)
 			goto out_unlock;
 	}
 
-	needs_alloc = imap_needs_alloc(inode, flags, &imap, nimaps);
+	needs_alloc = imap_needs_alloc(inode, flags, &dwa.imap, dwa.nimaps);
 
 	if (flags & IOMAP_ATOMIC) {
 		error = -ENOPROTOOPT;
@@ -1115,11 +1109,11 @@ xfs_direct_write_iomap_begin(
 		 * then we may end up with multiple extents, which means that
 		 * REQ_ATOMIC-based cannot be used, so avoid this possibility.
 		 */
-		if (needs_alloc && orig_end_fsb - offset_fsb > 1)
+		if (needs_alloc && orig_end_fsb - dwa.offset_fsb > 1)
 			goto out_unlock;
 
-		if (!xfs_bmap_hw_atomic_write_possible(ip, &imap, offset_fsb,
-				orig_end_fsb))
+		if (!xfs_bmap_hw_atomic_write_possible(ip, &dwa.imap,
+				dwa.offset_fsb, orig_end_fsb))
 			goto out_unlock;
 	}
 
@@ -1134,7 +1128,7 @@ xfs_direct_write_iomap_begin(
 	 */
 	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY)) {
 		error = -EAGAIN;
-		if (!imap_spans_range(&imap, offset_fsb, end_fsb))
+		if (!imap_spans_range(&dwa.imap, dwa.offset_fsb, end_fsb))
 			goto out_unlock;
 	}
 
@@ -1146,15 +1140,17 @@ xfs_direct_write_iomap_begin(
 	 */
 	if (flags & IOMAP_OVERWRITE_ONLY) {
 		error = -EAGAIN;
-		if (imap.br_state != XFS_EXT_NORM &&
-	            ((offset | length) & mp->m_blockmask))
+		if (dwa.imap.br_state != XFS_EXT_NORM &&
+		    ((offset | dwa.length) & mp->m_blockmask))
 			goto out_unlock;
 	}
 
-	seq = xfs_iomap_inode_sequence(ip, iomap_flags);
-	xfs_iunlock(ip, lockmode);
-	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags, seq);
+	seq = xfs_iomap_inode_sequence(ip, dwa.iomap_flags);
+	xfs_iunlock(ip, dwa.lockmode);
+	trace_xfs_iomap_found(ip, offset, dwa.length, XFS_DATA_FORK,
+			&dwa.imap);
+	return xfs_bmbt_to_iomap(ip, iomap, &dwa.imap, flags,
+			dwa.iomap_flags, seq);
 
 allocate_blocks:
 	error = -EAGAIN;
@@ -1170,34 +1166,23 @@ xfs_direct_write_iomap_begin(
 	 * Note that the values needs to be less than 32-bits wide until the
 	 * lower level functions are updated.
 	 */
-	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
-	end_fsb = xfs_iomap_end_fsb(mp, offset, length);
+	dwa.length = min_t(loff_t, dwa.length, 1024 * PAGE_SIZE);
+	end_fsb = xfs_iomap_end_fsb(mp, offset, dwa.length);
 
-	if (offset + length > XFS_ISIZE(ip))
+	if (offset + dwa.length > XFS_ISIZE(ip))
 		end_fsb = xfs_iomap_eof_align_last_fsb(ip, end_fsb);
-	else if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
-		end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
-	xfs_iunlock(ip, lockmode);
+	else if (dwa.nimaps && dwa.imap.br_startblock == HOLESTARTBLOCK)
+		end_fsb = min(end_fsb, dwa.imap.br_startoff +
+				dwa.imap.br_blockcount);
 
-	{
-		struct xfs_direct_write_args args = {
-			.ip		= ip,
-			.offset_fsb	= offset_fsb,
-			.count_fsb	= end_fsb - offset_fsb,
-			.offset		= offset,
-			.length		= length,
-			.flags		= flags,
-			.iomap_flags	= iomap_flags,
-			.imap		= imap,
-			.iomap		= iomap,
-		};
+	dwa.count_fsb = end_fsb - dwa.offset_fsb;
+	xfs_iunlock(ip, dwa.lockmode);
 
-		return xfs_iomap_write_direct(&args);
-	}
+	return xfs_iomap_write_direct(&dwa);
 
 out_unlock:
-	if (lockmode)
-		xfs_iunlock(ip, lockmode);
+	if (dwa.lockmode)
+		xfs_iunlock(ip, dwa.lockmode);
 	return error;
 }
 
-- 
2.55.0

