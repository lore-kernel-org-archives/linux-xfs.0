Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C35C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SE/e8dcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE86C433C8;
	Sun, 31 Dec 2023 22:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061795;
	bh=JxqMQGkLCpUi4OwwOZdzMQJ5kuFzpSMZgu1FLbHR6kM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SE/e8dcNq8ybJhfxRRToFk2b4m41+bZ8CkKUnBRLNBmfcbBCaVFAtX3DPpJ1rHdAC
	 bhXwmFZfzlqJ7rF1VZEKOelGw8ipJslvRiAK2ts6BGUQRP8qmuIg6huyxro3izsUK/
	 OWw5jKssFbdHJuyi3lesTq0PB0FrNSakozrE7blK7Icet/48O/Q9wgsNFcFCsYEOiW
	 brc8/+7+OJn27LHNaawC7KgjJQTXcgZK3GXlxIAg11iU3eF1pPoNn1qEBy3Q+XzKOE
	 SkL6tXmNM4p0X5SraBU0W+mlj7ZEgc82iUNwRWiCyg/mGsAeLGpvazifiPKQaDNZn8
	 kEWJkPetGa39Q==
Date: Sun, 31 Dec 2023 14:29:55 -0800
Subject: [PATCH 11/20] xfs: make atomic extent swapping support realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996422.1796128.15098682086982326791.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
References: <170404996260.1796128.1530179577245518199.stgit@frogsfrogsfrogs>
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

Now that bmap items support the realtime device, we can add the
necessary pieces to the atomic extent swapping code to support such
things.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h  |    5 ++
 libxfs/xfs_swapext.c |  165 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 161 insertions(+), 9 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index bcac3a09c6b..302df4c6f7e 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -325,6 +325,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 364ae16252d..92d2f8fa133 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -29,6 +29,7 @@
 #include "xfs_dir2_priv.h"
 #include "xfs_dir2.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_swapext_intent_cache;
 
@@ -131,6 +132,102 @@ sxi_advance(
 	sxi->sxi_blockcount -= irec->br_blockcount;
 }
 
+#ifdef DEBUG
+/*
+ * If we're going to do a BUI-only extent swap, ensure that all mappings are
+ * aligned to the realtime extent size.
+ */
+static inline int
+xfs_swapext_check_rt_extents(
+	struct xfs_mount		*mp,
+	const struct xfs_swapext_req	*req)
+{
+	struct xfs_bmbt_irec		irec1, irec2;
+	xfs_fileoff_t			startoff1 = req->startoff1;
+	xfs_fileoff_t			startoff2 = req->startoff2;
+	xfs_filblks_t			blockcount = req->blockcount;
+	uint32_t			mod;
+	int				nimaps;
+	int				error;
+
+	/* xattrs don't live on the rt device */
+	if (req->whichfork == XFS_ATTR_FORK)
+		return 0;
+
+	/*
+	 * Caller got permission to use SXI log items, so log recovery will
+	 * finish the swap and not leave us with partially swapped rt extents
+	 * exposed to userspace.
+	 */
+	if (req->req_flags & XFS_SWAP_REQ_LOGGED)
+		return 0;
+
+	/*
+	 * Allocation units must be fully mapped to a file range.  For files
+	 * with a single-fsblock allocation unit, this is trivial.
+	 */
+	if (!xfs_inode_has_bigallocunit(req->ip2))
+		return 0;
+
+	/*
+	 * For multi-fsblock allocation units, we must check the alignment of
+	 * every single mapping.
+	 */
+	while (blockcount > 0) {
+		/* Read extent from the first file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip1, startoff1, blockcount,
+				&irec1, &nimaps, 0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/* Read extent from the second file */
+		nimaps = 1;
+		error = xfs_bmapi_read(req->ip2, startoff2,
+				irec1.br_blockcount, &irec2, &nimaps,
+				0);
+		if (error)
+			return error;
+		ASSERT(nimaps == 1);
+
+		/*
+		 * We can only swap as many blocks as the smaller of the two
+		 * extent maps.
+		 */
+		irec1.br_blockcount = min(irec1.br_blockcount,
+					  irec2.br_blockcount);
+
+		/* Both mappings must be aligned to the realtime extent size. */
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_startoff);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_startoff);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		mod = xfs_rtb_to_rtxoff(mp, irec1.br_blockcount);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EINVAL;
+		}
+
+		startoff1 += irec1.br_blockcount;
+		startoff2 += irec1.br_blockcount;
+		blockcount -= irec1.br_blockcount;
+	}
+
+	return 0;
+}
+#else
+# define xfs_swapext_check_rt_extents(mp, req)		(0)
+#endif
+
 /* Check all extents to make sure we can actually swap them. */
 int
 xfs_swapext_check_extents(
@@ -150,12 +247,7 @@ xfs_swapext_check_extents(
 	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
-	/* We don't support realtime data forks yet. */
-	if (!XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
-	if (req->whichfork == XFS_ATTR_FORK)
-		return 0;
-	return -EINVAL;
+	return xfs_swapext_check_rt_extents(mp, req);
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -196,6 +288,8 @@ xfs_swapext_can_skip_mapping(
 	struct xfs_swapext_intent	*sxi,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_mount		*mp = sxi->sxi_ip1->i_mount;
+
 	/* Do not skip this mapping if the caller did not tell us to. */
 	if (!(sxi->sxi_flags & XFS_SWAP_EXT_INO1_WRITTEN))
 		return false;
@@ -208,10 +302,63 @@ xfs_swapext_can_skip_mapping(
 	 * The mapping is unwritten or a hole.  It cannot be a delalloc
 	 * reservation because we already excluded those.  It cannot be an
 	 * unwritten extent with dirty page cache because we flushed the page
-	 * cache.  We don't support realtime files yet, so we needn't (yet)
-	 * deal with them.
+	 * cache.  For files where the allocation unit is 1FSB (files on the
+	 * data dev, rt files if the extent size is 1FSB), we can safely
+	 * skip this mapping.
 	 */
-	return true;
+	if (!xfs_inode_has_bigallocunit(sxi->sxi_ip1))
+		return true;
+
+	/*
+	 * For a realtime file with a multi-fsb allocation unit, the decision
+	 * is trickier because we can only swap full allocation units.
+	 * Unwritten mappings can appear in the middle of an rtx if the rtx is
+	 * partially written, but they can also appear for preallocations.
+	 *
+	 * If the mapping is a hole, skip it entirely.  Holes should align with
+	 * rtx boundaries.
+	 */
+	if (!xfs_bmap_is_real_extent(irec))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten.
+	 *
+	 * - If the beginning is not aligned to an rtx, trim the end of the
+	 *   mapping so that it does not cross an rtx boundary, and swap it.
+	 *
+	 * - If both ends are aligned to an rtx, skip the entire mapping.
+	 */
+	if (!isaligned_64(irec->br_startoff, mp->m_sb.sb_rextsize)) {
+		xfs_fileoff_t	new_end;
+
+		new_end = roundup_64(irec->br_startoff, mp->m_sb.sb_rextsize);
+		irec->br_blockcount = min(irec->br_blockcount,
+					  new_end - irec->br_startoff);
+		return false;
+	}
+	if (isaligned_64(irec->br_blockcount, mp->m_sb.sb_rextsize))
+		return true;
+
+	/*
+	 * All mappings below this point are unwritten, start on an rtx
+	 * boundary, and do not end on an rtx boundary.
+	 *
+	 * - If the mapping is longer than one rtx, trim the end of the mapping
+	 *   down to an rtx boundary and skip it.
+	 *
+	 * - The mapping is shorter than one rtx.  Swap it.
+	 */
+	if (irec->br_blockcount > mp->m_sb.sb_rextsize) {
+		xfs_fileoff_t	new_end;
+
+		new_end = rounddown_64(irec->br_startoff + irec->br_blockcount,
+				mp->m_sb.sb_rextsize);
+		irec->br_blockcount = new_end - irec->br_startoff;
+		return true;
+	}
+
+	return false;
 }
 
 /*

