Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BB88183A
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNDGNdc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD3CC433C7;
	Wed, 13 Dec 2023 22:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508137;
	bh=RfSj6Z7thumCAGiqVMwk7Ofkl8FLbF1vXPZM5B/qZtQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kNDGNdc259WQp86Gh88PDwclsROZkmeFJV8QFYU9fh4B3g0u3IDERed12xjp52VP6
	 spJTsCof5I/eoPmK8v5azR5452ZQLxSL8UcSHSE7OqRn0OgmrsTFgnbfdIc8Sma1gX
	 r91+W9lE6RoIyiSkUz6b0V5tu1wVg5E2bOIeVglOYudl+6spfckxHOn/u/Yh6ysZrA
	 m+/T54gXa+oIMBqUyJ6Oq2cstCn9jBfCIL8kyUh5nXzI18E2tscSi5iQSg2m7J8CBJ
	 ye+7Iq/RwcDpvrj1f6dPlUv9TDQVHbZV9Rrp2yytZwmMxk9L9RUV8z5ZQptj9IzUpl
	 4qlNKdF+zz0Bw==
Date: Wed, 13 Dec 2023 14:55:36 -0800
Subject: [PATCH 9/9] xfs: skip the rmapbt search on an empty attr fork unless
 we know it was zapped
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250783612.1399182.15991983383343750542.stgit@frogsfrogsfrogs>
In-Reply-To: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
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

The attribute fork scrubber can optionally scan the reverse mapping
records of the filesystem to determine if the fork is missing mappings
that it should have.  However, this is a very expensive operation, so we
only want to do this if we suspect that the fork is missing records.
For attribute forks the criteria for suspicion is that the attr fork is
in EXTENTS format and has zero extents.

However, there are several ways that a file can end up in this state
through regular filesystem usage.  For example, an LSM can set a
s_security hook but then decide not to set an ACL; or an attr set can
create the attr fork but then the actual set operation fails with
ENOSPC; or we can delete all the attrs on a file whose data fork is in
btree format, in which case we do not delete the attr fork.  We don't
want to run the expensive check for any case that can be arrived at
through regular operations.

However.

When online inode repair decides to zap an attribute fork, it cannot
determine if it is zapping ACL information.  As a precaution it removes
all the discretionary access control permissions and sets the user and
group ids to zero.  Check these three additional conditions to decide if
we want to scan the rmap records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c |  101 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1487aaf3d95f..8175e8c17c14 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -638,6 +638,82 @@ xchk_bmap_check_ag_rmaps(
 	return error;
 }
 
+/*
+ * Decide if we want to scan the reverse mappings to determine if the attr
+ * fork /really/ has zero space mappings.
+ */
+STATIC bool
+xchk_bmap_check_empty_attrfork(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*ifp = &ip->i_af;
+
+	/*
+	 * If the dinode repair found a bad attr fork, it will reset the fork
+	 * to extents format with zero records and wait for the this scrubber
+	 * to reconstruct the block mappings.  If the fork is not in this
+	 * state, then the fork cannot have been zapped.
+	 */
+	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS || ifp->if_nextents != 0)
+		return false;
+
+	/*
+	 * Files can have an attr fork in EXTENTS format with zero records for
+	 * several reasons:
+	 *
+	 * a) an attr set created a fork but ran out of space
+	 * b) attr replace deleted an old attr but failed during the set step
+	 * c) the data fork was in btree format when all attrs were deleted, so
+	 *    the fork was left in place
+	 * d) the inode repair code zapped the fork
+	 *
+	 * Only in case (d) do we want to scan the rmapbt to see if we need to
+	 * rebuild the attr fork.  The fork zap code clears all DAC permission
+	 * bits and zeroes the uid and gid, so avoid the scan if any of those
+	 * three conditions are not met.
+	 */
+	if ((VFS_I(ip)->i_mode & 0777) != 0)
+		return false;
+	if (!uid_eq(VFS_I(ip)->i_uid, GLOBAL_ROOT_UID))
+		return false;
+	if (!gid_eq(VFS_I(ip)->i_gid, GLOBAL_ROOT_GID))
+		return false;
+
+	return true;
+}
+
+/*
+ * Decide if we want to scan the reverse mappings to determine if the data
+ * fork /really/ has zero space mappings.
+ */
+STATIC bool
+xchk_bmap_check_empty_datafork(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*ifp = &ip->i_df;
+
+	/* Don't support realtime rmap checks yet. */
+	if (XFS_IS_REALTIME_INODE(ip))
+		return false;
+
+	/*
+	 * If the dinode repair found a bad data fork, it will reset the fork
+	 * to extents format with zero records and wait for the this scrubber
+	 * to reconstruct the block mappings.  If the fork is not in this
+	 * state, then the fork cannot have been zapped.
+	 */
+	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS || ifp->if_nextents != 0)
+		return false;
+
+	/*
+	 * If we encounter an empty data fork along with evidence that the fork
+	 * might not really be empty, we need to scan the reverse mappings to
+	 * decide if we're going to rebuild the fork.  Data forks with nonzero
+	 * file size are scanned.
+	 */
+	return i_size_read(VFS_I(ip)) != 0;
+}
+
 /*
  * Decide if we want to walk every rmap btree in the fs to make sure that each
  * rmap for this file fork has corresponding bmbt entries.
@@ -647,7 +723,6 @@ xchk_bmap_want_check_rmaps(
 	struct xchk_bmap_info	*info)
 {
 	struct xfs_scrub	*sc = info->sc;
-	struct xfs_ifork	*ifp;
 
 	if (!xfs_has_rmapbt(sc->mp))
 		return false;
@@ -656,28 +731,10 @@ xchk_bmap_want_check_rmaps(
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return false;
 
-	/* Don't support realtime rmap checks yet. */
-	if (info->is_rt)
-		return false;
+	if (info->whichfork == XFS_ATTR_FORK)
+		return xchk_bmap_check_empty_attrfork(sc->ip);
 
-	/*
-	 * The inode repair code zaps broken inode forks by resetting them back
-	 * to EXTENTS format and zero extent records.  If we encounter a fork
-	 * in this state along with evidence that the fork isn't supposed to be
-	 * empty, we need to scan the reverse mappings to decide if we're going
-	 * to rebuild the fork.  Data forks with nonzero file size are scanned.
-	 * xattr forks are never empty of content, so they are always scanned.
-	 */
-	ifp = xfs_ifork_ptr(sc->ip, info->whichfork);
-	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS && ifp->if_nextents == 0) {
-		if (info->whichfork == XFS_DATA_FORK &&
-		    i_size_read(VFS_I(sc->ip)) == 0)
-			return false;
-
-		return true;
-	}
-
-	return false;
+	return xchk_bmap_check_empty_datafork(sc->ip);
 }
 
 /* Make sure each rmap has a corresponding bmbt entry. */

