Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2BA38385
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053060; cv=none; b=JiRAeiYj/oPk51BxL+2U+bSkO7HEaJUKmY5gM0KMZPDZ4EQlhZsa5lBItVzCNsadN5rEVb5io3LuX6oAUhV/G05YcVO2XLDsXFWeW2K8bTECqxbIsAUUwZa7crZ01pSt9kwCHSJwziro2vRNf0PjDMByPvyjLYxGkoqugNyvGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053060; c=relaxed/simple;
	bh=8A3OvtxShk/d/AttFSxe8ntzKAWvzGQnO9G6Ds5GA8Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RKbs+7S448yyiz+f7esxoAJsQYutUmrzMngZ9nfj/ZhWnVepRdm1UmCVKsX6f3Peq2opziZk694KNkSGJXUkduM5yfaHew+XFfhB3a0BtwiW7xMFdL0RqRoJCevsFk+EzeZlHQ7d/IEWKVutWHMnK41CboskRcp9pDJ3NxqMnQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ybo6el0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ybo6el0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A11C4CECE;
	Fri, 13 Dec 2024 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053060;
	bh=8A3OvtxShk/d/AttFSxe8ntzKAWvzGQnO9G6Ds5GA8Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ybo6el0VDtl33ZNmsXN3laZqw5s0fiahZXuhuVYg/70bBeHDbuYcwOIkW4uBd3t3e
	 osD9xAzHx3EB8NYSzsqdAvlS33ALYjUDbUVfzkxBWSQmjVsKbqUnTONKCrrRHGAYjo
	 zashb4lZc+n60ll8Ac23gmL5qo1QzW7pHUF/55f0OTOM8X1l/+yo271UScbbNrl/8V
	 Ssu9c4lIDRhbqyYqsf2bem0DP3aeSqY0icEPOVVKdS0cwAmKzCvil9fgurZ83BaCbT
	 sygqwlYGoeMXy/fNqBxMeg9Xh/3v2uPbx7LU7hlJ6qpby5uTc/8H3ZGrdiGD7N5UfT
	 hfVqz9PfqKqdQ==
Date: Thu, 12 Dec 2024 17:24:19 -0800
Subject: [PATCH 11/11] xfs: support realtime reflink with an extent size that
 isn't a power of 2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125928.1184063.9203313014441349759.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the necessary alignment checking code to the reflink remap code to
ensure that remap requests are aligned to rt extent boundaries if the
realtime extent size isn't a power of two.  The VFS helpers assume that
they can use the usual (blocksize - 1) masking to avoid slow 64-bit
division, but since XFS is special we won't make everyone pay that cost
for our weird edge case.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |  119 +++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_reflink.h |    2 -
 fs/xfs/xfs_rtalloc.c |    4 --
 fs/xfs/xfs_super.c   |    9 ----
 4 files changed, 90 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0222b78dedd92d..6ceb00565bab24 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1638,6 +1638,83 @@ xfs_reflink_adjust_rtbigalloc_len(
 # define xfs_reflink_adjust_rtbigalloc_len(...)		(0)
 #endif /* CONFIG_XFS_RT */
 
+/*
+ * Check the alignment of a remap request when the allocation unit size isn't a
+ * power of two.  The VFS helpers use (fast) bitmask-based alignment checks,
+ * but here we have to use slow long division.
+ */
+static int
+xfs_reflink_remap_check_rtalign(
+	struct xfs_inode		*ip_in,
+	loff_t				pos_in,
+	struct xfs_inode		*ip_out,
+	loff_t				pos_out,
+	loff_t				*req_len,
+	unsigned int			remap_flags)
+{
+	struct xfs_mount		*mp = ip_in->i_mount;
+	uint32_t			rextbytes;
+	loff_t				in_size, out_size;
+	loff_t				new_length, length = *req_len;
+	loff_t				blen;
+
+	rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+	in_size = i_size_read(VFS_I(ip_in));
+	out_size = i_size_read(VFS_I(ip_out));
+
+	/* The start of both ranges must be aligned to a rt extent. */
+	if (!isaligned_64(pos_in, rextbytes) ||
+	    !isaligned_64(pos_out, rextbytes))
+		return -EINVAL;
+
+	if (length == 0)
+		length = in_size - pos_in;
+
+	/*
+	 * If the user wanted us to exchange up to the infile's EOF, round up
+	 * to the next block boundary for this check.
+	 *
+	 * Otherwise, reject the range length if it's not extent aligned.  We
+	 * already confirmed the starting offsets' extent alignment.
+	 */
+	if (pos_in + length == in_size)
+		blen = roundup_64(in_size, rextbytes) - pos_in;
+	else
+		blen = rounddown_64(length, rextbytes);
+
+	/* Don't allow overlapped remappings within the same file. */
+	if (ip_in == ip_out &&
+	    pos_out + blen > pos_in &&
+	    pos_in + blen > pos_out)
+		return -EINVAL;
+
+	/*
+	 * Ensure that we don't exchange a partial EOF extent into the middle
+	 * of another file.
+	 */
+	if (isaligned_64(length, rextbytes))
+		return 0;
+
+	new_length = length;
+	if (pos_out + length < out_size)
+		new_length = rounddown_64(new_length, rextbytes);
+
+	if (new_length == length)
+		return 0;
+
+	/*
+	 * Return the shortened request if the caller permits it.  If the
+	 * request was shortened to zero rt extents, we know that the original
+	 * arguments weren't valid in the first place.
+	 */
+	if ((remap_flags & REMAP_FILE_CAN_SHORTEN) && new_length > 0) {
+		*req_len = new_length;
+		return 0;
+	}
+
+	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
+}
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1681,6 +1758,7 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	const struct iomap_ops	*dax_read_ops = NULL;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(dest);
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1698,14 +1776,22 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
-	ASSERT(is_power_of_2(xfs_inode_alloc_unitsize(dest)));
+	/* Check non-power of two alignment issues, if necessary. */
+	if (XFS_IS_REALTIME_INODE(dest) && !is_power_of_2(alloc_unit)) {
+		ret = xfs_reflink_remap_check_rtalign(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret)
+			goto out_unlock;
+
+		/* Do the VFS checks with the regular block alignment. */
+		alloc_unit = src->i_mount->m_sb.sb_blocksize;
+	}
 
 	if (IS_DAX(inode_in))
 		dax_read_ops = &xfs_read_iomap_ops;
 
 	ret = __generic_remap_file_range_prep(file_in, pos_in, file_out,
-			pos_out, len, remap_flags, dax_read_ops,
-			xfs_inode_alloc_unitsize(dest));
+			pos_out, len, remap_flags, dax_read_ops, alloc_unit);
 	if (ret || *len == 0)
 		goto out_unlock;
 
@@ -1949,30 +2035,3 @@ xfs_reflink_unshare(
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
-
-/*
- * Can we use reflink with this realtime extent size?  Note that we don't check
- * for rblocks > 0 here because this can be called as part of attaching a new
- * rt section.
- */
-bool
-xfs_reflink_supports_rextsize(
-	struct xfs_mount	*mp,
-	unsigned int		rextsize)
-{
-	/* reflink on the realtime device requires rtgroups */
-	if (!xfs_has_rtgroups(mp))
-	       return false;
-
-	/*
-	 * Reflink doesn't support file allocation units larger than a single
-	 * block and not a power of two because we would have to perform
-	 * CoW-around for unaligned write requests to guarantee that we always
-	 * remap entire allocation units and the reflink code cannot yet handle
-	 * rounding ranges to align to non powers of two.
-	 */
-	if (!is_power_of_2(rextsize))
-		return false;
-
-	return true;
-}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index cc4e92278279b6..3bfd7ab9e1148a 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -62,6 +62,4 @@ extern int xfs_reflink_remap_blocks(struct xfs_inode *src, loff_t pos_in,
 extern int xfs_reflink_update_dest(struct xfs_inode *dest, xfs_off_t newlen,
 		xfs_extlen_t cowextsize, unsigned int remap_flags);
 
-bool xfs_reflink_supports_rextsize(struct xfs_mount *mp, unsigned int rextsize);
-
 #endif /* __XFS_REFLINK_H */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d8e6d073d64dc9..586da450cc44b4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1295,9 +1295,7 @@ xfs_growfs_rt(
 			goto out_unlock;
 		if (xfs_has_reflink(mp))
 			goto out_unlock;
-	} else if (xfs_has_reflink(mp) &&
-		   !xfs_reflink_supports_rextsize(mp, in->extsize))
-		goto out_unlock;
+	}
 
 	error = xfs_sb_validate_fsb_count(&mp->m_sb, in->newblocks);
 	if (error)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c91b9467a3eef8..8050fea541140a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1754,15 +1754,6 @@ xfs_fs_fill_super(
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
 
 	if (xfs_has_reflink(mp)) {
-		if (xfs_has_realtime(mp) &&
-		    !xfs_reflink_supports_rextsize(mp, mp->m_sb.sb_rextsize)) {
-			xfs_alert(mp,
-	"reflink not compatible with non-power-of-2 realtime extent size %u!",
-					mp->m_sb.sb_rextsize);
-			error = -EINVAL;
-			goto out_filestream_unmount;
-		}
-
 		/*
 		 * always-cow mode is not supported on filesystems with rt
 		 * extent sizes larger than a single block because we'd have

