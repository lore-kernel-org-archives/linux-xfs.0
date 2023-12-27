Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B151362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xvk2OJA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36EDC433C8;
	Mon,  1 Jan 2024 00:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069442;
	bh=LGAKg4ItIUvTiglH6RA8uTvgIgqgDQ/xp0MIE1PphFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xvk2OJA0JoNgVwL/j7b23AjVf0xfDaY8LMkwknsC2BDg257CZaMJQ/zjK7VXPkGVs
	 b8uBz4qmtOQOXTrGHDi6iz7UJHqJaRjnv3kBYqlUPwFW8THKas9eXaRbsTW5eQ3LKt
	 zfbULtehQPnt6OSQ4aZ0RvJBNmP9l5fhH+h4jYOV/Yb/FWDJ7NiInJzqQLZGseX5cq
	 AKixG/O0q/ZmvIcQrW5g0MC5eZag+bN9y7aVVutRO7MizgzJa55yN/Hkbhv5yVMofZ
	 GKBdaLnDqF4EgB5NdnKWFT3xYZWkHvnZzlDOVVXj4JhDcCHMRRup0Aky2li8cGGsBN
	 nnFK3VxhYD9MQ==
Date: Sun, 31 Dec 2023 16:37:22 +9900
Subject: [PATCH 1/3] xfs: enable extent size hints for CoW when rtextsize > 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018025.1818169.13143459343794388781.stgit@frogsfrogsfrogs>
In-Reply-To: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
References: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
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

CoW extent size hints are not allowed on filesystems that have large
realtime extents because we only want to perform the minimum required
amount of write-around (aka write amplification) for shared extents.

On filesystems where rtextsize > 1, allocations can only be done in
units of full rt extents, which means that we can only map an entire rt
extent's worth of blocks into the data fork.  Hole punch requests become
conversions to unwritten if the request isn't aligned properly.

Because a copy-write fundamentally requires remapping, this means that
we also can only do copy-writes of a full rt extent.  This is too
expensive for large hint sizes, since it's all or nothing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bc703b13b7e..13bcf146d08 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6402,6 +6402,28 @@ xfs_get_cowextsz_hint(
 	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 		a = ip->i_cowextsize;
 	if (XFS_IS_REALTIME_INODE(ip)) {
+		/*
+		 * For realtime files, the realtime extent is the fundamental
+		 * unit of allocation.  This means that data sharing and CoW
+		 * remapping can only be done in those units.  For filesystems
+		 * where the extent size is larger than one block, write
+		 * requests that are not aligned to an extent boundary employ
+		 * an unshare-around strategy to ensure that all pages for a
+		 * shared extent are fully dirtied.
+		 *
+		 * Because the remapping alignment requirement applies equally
+		 * to all CoW writes, any regular overwrites that could be
+		 * turned (by a speculative CoW preallocation) into a CoW write
+		 * must either employ this dirty-around strategy, or be smart
+		 * enough to ignore the CoW fork mapping unless the entire
+		 * extent is dirty or becomes shared by writeback time.  Doing
+		 * the first would dramatically increase write amplification,
+		 * and the second would require deeper insight into the state
+		 * of the page cache during a writeback request.  For now, we
+		 * ignore the hint.
+		 */
+		if (ip->i_mount->m_sb.sb_rextsize > 1)
+			return ip->i_mount->m_sb.sb_rextsize;
 		b = 0;
 		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
 			b = ip->i_extsize;

