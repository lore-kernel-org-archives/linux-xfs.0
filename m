Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB81361
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299199; cv=none; b=L51ZLHb4er2mIQYpcO6GH4D6yb6MlHRreegFRqc4sV4uE9OAZBp8CGCR1TcA8etfuYQJslKTBZulg2ArQG4Luda1d5l/2zcqLBq0OGoBpmAdJG/qrtpMw6xJMTEmawc/vCLaUTD4E8PS5BJ7H5pbPhNpOkb89x+hBazZifg7DWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299199; c=relaxed/simple;
	bh=k0ZktlBYfMQULT3Gdav2tNpux228pBkWXHtQlzP7zVo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tughfNW33Z35MDF7Gqk9wLJpKvGolirBgx5e9wyxldCGFux3Phfm8n1ncYrKJnm7THI/Qvj/GFLTruKfqmYq+cNTOIGSNZnL1IRD9vOsKqyRTUcPT496xi+I6GJNPfx7PiLUzISSHjP5JItO5njHVGs6+ORNkvRkRk7zkBCiS+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW8Ck1tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW8Ck1tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192F9C32786;
	Tue, 30 Jul 2024 00:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299199;
	bh=k0ZktlBYfMQULT3Gdav2tNpux228pBkWXHtQlzP7zVo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GW8Ck1tOn6nm5Gswck6TjP5en3ITCccm9d1DyM5KvwtXSKf+ftgLDsKLmLoacLDTL
	 UpSOAP3ld54RgqxtewSlwCFV8e6u0NiEwHtx0lhNctGGliuC5JxWnAL/XiHZktecc7
	 x5N16XrTQqL3AfCMZstGoCT4UV6eJeYWSYILsKgcqBg9Z7A3P7MlZmoZdnQvHjkeZb
	 W2254TE3lJgAUC6jHT3I5WtfLJP+lTwPidVu9e2NFcCdexM8xVAtCU1JgVIxI70xsi
	 I3vjQZhQa6BVgHcHcnGFjL+3zXa+rjCEcBDkF7ejLQWTufwIVZFj+0lN2bOQkOeHHb
	 fYwvY4BLZiUcg==
Date: Mon, 29 Jul 2024 17:26:38 -0700
Subject: [PATCH 011/115] xfs: make file range exchange support realtime files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842596.1338752.16136594403263694499.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: e62941103faa2eedba6a155316e059a490c743a6

Now that bmap items support the realtime device, we can add the
necessary pieces to the file range exchange code to support exchanging
mappings.  All we really need to do here is adjust the blockcount
upwards to the end of the rt extent and remove the inode checks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h   |   10 +++++++
 libxfs/xfs_exchmaps.c |   70 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 10 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index a351bb0d9..825708383 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -325,6 +325,16 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+
+/*
+ * Decide if this file is a realtime file whose data allocation unit is larger
+ * than a single filesystem block.
+ */
+static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 34ac9d5f2..37e58d088 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -149,12 +149,7 @@ xfs_exchmaps_check_forks(
 	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
-	/* We don't support realtime data forks yet. */
-	if (!XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
-	if (whichfork == XFS_ATTR_FORK)
-		return 0;
-	return -EINVAL;
+	return 0;
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -195,6 +190,8 @@ xfs_exchmaps_can_skip_mapping(
 	struct xfs_exchmaps_intent	*xmi,
 	struct xfs_bmbt_irec		*irec)
 {
+	struct xfs_mount		*mp = xmi->xmi_ip1->i_mount;
+
 	/* Do not skip this mapping if the caller did not tell us to. */
 	if (!(xmi->xmi_flags & XFS_EXCHMAPS_INO1_WRITTEN))
 		return false;
@@ -206,11 +203,64 @@ xfs_exchmaps_can_skip_mapping(
 	/*
 	 * The mapping is unwritten or a hole.  It cannot be a delalloc
 	 * reservation because we already excluded those.  It cannot be an
-	 * unwritten mapping with dirty page cache because we flushed the page
-	 * cache.  We don't support realtime files yet, so we needn't (yet)
-	 * deal with them.
+	 * unwritten extent with dirty page cache because we flushed the page
+	 * cache.  For files where the allocation unit is 1FSB (files on the
+	 * data dev, rt files if the extent size is 1FSB), we can safely
+	 * skip this mapping.
 	 */
-	return true;
+	if (!xfs_inode_has_bigrtalloc(xmi->xmi_ip1))
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

