Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A5D11704
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gY6nJU5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A14C433C8;
	Sun, 31 Dec 2023 21:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059857;
	bh=5Rr9JlF3EjsLQbhtb33DDUNhRGF5Q7iAcUYO9H9g3ow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gY6nJU5bfxdx59/YKspvRGazZ60M1OBhd0NzahSgXRLyZwV1awPesqIdwpjXyAM0O
	 RIpVZfqsxRTDiaqrFy1FwV0C+unzkyFfqQBfijy730Yq4LmhDpOjmfPOcTa7fT8Vyn
	 S2592wVMcbU+Ela4c9FTfw/O+V1wKsQbwdGWCjX+ZrKlpXcY0pTuMIi73nC+5Wlk/v
	 lG0/HULmIUu+OUrcXqbqHMKIHYci75rAWyWUOPLHLp+fvEmoxlDAEuof3v6NxSqE7O
	 17Jf9y0kzC4BeN8utcFvK78Yh9+Z7cYiQi1wzqlUAdbAhTFZtK4IG0Fsk/6tc5Bfhi
	 /pXu1BeCrfqkw==
Date: Sun, 31 Dec 2023 13:57:36 -0800
Subject: [PATCH 6/9] xfs: enable extent size hints for CoW when rtextsize > 1
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852767.1767395.6394408204682530311.stgit@frogsfrogsfrogs>
In-Reply-To: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
References: <170404852650.1767395.17654728220580066333.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_bmap.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 41354bdbbc90f..c6ab6a38bc7cd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6408,6 +6408,28 @@ xfs_get_cowextsz_hint(
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

