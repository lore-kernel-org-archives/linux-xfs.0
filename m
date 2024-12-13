Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C10421345
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053029; cv=none; b=KShEssr+bzUx/tmEkCUgtTBvLPnCpuM1ruHajYNuIFIha1raVkf78ejil8GXkISOMwDp2U2cBcggu38PRI8S386nQ2uMcAfPs/CQXs1biiNmLsuBXeZnzKOZG9Jze4p6TY8yBhn3hUg6IS6dyIB54zBlWkR6bkDY2pNmA2Uvm/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053029; c=relaxed/simple;
	bh=CA3zQGiztERvQtDTb+QA0vzkbRbztOQJVB13SigRqIA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b3gjcpMeG0tRGkEILbLvSFBZTuUwHzElkAUNqKtFirxkMk6LNh3PtasGTAyIG8sgyUo3lSylS9V6LMroTiQ06DcZ2F7xru6geFj/96GhGbqa0Q4hWD7owIYaBkjzCeojM2NUXKgn86v4G1OBBz8cA0HvuHa7DW0RWKjNcuVNL9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVQxZTnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVQxZTnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F5DC4CECE;
	Fri, 13 Dec 2024 01:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053028;
	bh=CA3zQGiztERvQtDTb+QA0vzkbRbztOQJVB13SigRqIA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZVQxZTnSeo2MZIPnCAN7Xv/rN4nKUk+8KLbGlKHmIBOUN+UP4pS1/OAXPOaGQbEp2
	 /235627snhSmV8wRKXNEQ4VZEsoQrqGN4OZRozpkfEyq6nJeBl8kkLveGWccEhyaZy
	 oRa3Xhd1PWJyDZhCQ7EzP7/ebnpzRsppaVg4fsTHhlFolGcl61UoglCMagaylKloPF
	 Uh2un/uDRzmJwwLd55OFfraYzu3bDrjJETzf0UvJ06pyqUAq3k33YocGlFH1TE3h/9
	 2tblW7kSE0TSQPfk+6qkvC1bOgJldJeV9qv8Se+ZgxYvrVcfe6GMH49uv0Cn4a230+
	 7gnMYgVaEh+Yw==
Date: Thu, 12 Dec 2024 17:23:48 -0800
Subject: [PATCH 09/11] xfs: allow reflink on the rt volume when extent size is
 larger than 1 rt block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125896.1184063.11119572969501198910.stgit@frogsfrogsfrogs>
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

Make the necessary tweaks to the reflink remapping code to support
remapping on the realtime volume when the rt extent size is larger than
a single rt block.  We need to check that the remap arguments from
userspace are aligned to a rt extent boundary, and that the length
is always aligned, even if the kernel tried to round it up to EOF for
us.  XFS can only map and remap full rt extents, so we have to be a
little more strict about the alignment there.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   91 +++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c   |    2 +
 fs/xfs/xfs_trace.h   |    3 ++
 3 files changed, 85 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 82ceec8517a020..0222b78dedd92d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1506,6 +1506,13 @@ xfs_reflink_remap_blocks(
 	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
 			XFS_MAX_FILEOFF);
 
+	/*
+	 * Make sure the end is aligned with an allocation unit, even if it's
+	 * past EOF.
+	 */
+	if (xfs_inode_has_bigrtalloc(dest))
+		len = xfs_blen_roundup_rtx(mp, len);
+
 	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
 	while (len > 0) {
@@ -1580,6 +1587,57 @@ xfs_reflink_zero_posteof(
 	return xfs_zero_range(ip, isize, pos - isize, NULL);
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * Adjust the length of the remap operation to end on an allocation unit (AU)
+ * boundary.
+ */
+STATIC int
+xfs_reflink_adjust_rtbigalloc_len(
+	struct xfs_inode	*src,
+	loff_t			pos_in,
+	struct xfs_inode	*dest,
+	loff_t			pos_out,
+	loff_t			*len,
+	unsigned int		remap_flags)
+{
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(src);
+	uint32_t		mod;
+
+	div_u64_rem(*len, alloc_unit, &mod);
+
+	/*
+	 * We previously checked the AU alignment of both offsets, so we now
+	 * have to check the AU alignment of the length.  The VFS remap prep
+	 * function can change the length on us, so we can only make length
+	 * adjustments after that.  If the length is aligned to an AU, we're
+	 * good to go.
+	 *
+	 * Otherwise, the length is not aligned to an AU.  If the source file's
+	 * range ends at EOF, the VFS ensured that the dest file's range also
+	 * ends at EOF.  The actual remap function will round the (byte) length
+	 * up to the nearest AU, so we're ok here too.
+	 */
+	if (mod == 0 || pos_in + *len == i_size_read(VFS_I(src)))
+		return 0;
+
+	/*
+	 * Otherwise, the only thing we can do is round the request length down
+	 * to an AU boundary.  If the caller doesn't allow that, we cannot move
+	 * forward.
+	 */
+	if (!(remap_flags & REMAP_FILE_CAN_SHORTEN))
+		return -EINVAL;
+
+	/* Back off by a single extent. */
+	(*len) -= mod;
+	trace_xfs_reflink_adjust_rtbigalloc_len(src, pos_in, *len, dest, pos_out);
+	return 0;
+}
+#else
+# define xfs_reflink_adjust_rtbigalloc_len(...)		(0)
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
@@ -1622,6 +1680,7 @@ xfs_reflink_remap_prep(
 	struct xfs_inode	*src = XFS_I(inode_in);
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
+	const struct iomap_ops	*dax_read_ops = NULL;
 	int			ret;
 
 	/* Lock both files against IO */
@@ -1639,15 +1698,25 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
-	if (!IS_DAX(inode_in))
-		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
-				pos_out, len, remap_flags);
-	else
-		ret = dax_remap_file_range_prep(file_in, pos_in, file_out,
-				pos_out, len, remap_flags, &xfs_read_iomap_ops);
+	ASSERT(is_power_of_2(xfs_inode_alloc_unitsize(dest)));
+
+	if (IS_DAX(inode_in))
+		dax_read_ops = &xfs_read_iomap_ops;
+
+	ret = __generic_remap_file_range_prep(file_in, pos_in, file_out,
+			pos_out, len, remap_flags, dax_read_ops,
+			xfs_inode_alloc_unitsize(dest));
 	if (ret || *len == 0)
 		goto out_unlock;
 
+	/* Adjust the end to align to an allocation unit. */
+	if (xfs_inode_has_bigrtalloc(src)) {
+		ret = xfs_reflink_adjust_rtbigalloc_len(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret || *len == 0)
+			goto out_unlock;
+	}
+
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)
@@ -1896,11 +1965,13 @@ xfs_reflink_supports_rextsize(
 	       return false;
 
 	/*
-	 * Reflink doesn't support rt extent size larger than a single fsblock
-	 * because we would have to perform CoW-around for unaligned write
-	 * requests to guarantee that we always remap entire rt extents.
+	 * Reflink doesn't support file allocation units larger than a single
+	 * block and not a power of two because we would have to perform
+	 * CoW-around for unaligned write requests to guarantee that we always
+	 * remap entire allocation units and the reflink code cannot yet handle
+	 * rounding ranges to align to non powers of two.
 	 */
-	if (rextsize != 1)
+	if (!is_power_of_2(rextsize))
 		return false;
 
 	return true;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0fa7b7cc75c146..c91b9467a3eef8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1757,7 +1757,7 @@ xfs_fs_fill_super(
 		if (xfs_has_realtime(mp) &&
 		    !xfs_reflink_supports_rextsize(mp, mp->m_sb.sb_rextsize)) {
 			xfs_alert(mp,
-	"reflink not compatible with realtime extent size %u!",
+	"reflink not compatible with non-power-of-2 realtime extent size %u!",
 					mp->m_sb.sb_rextsize);
 			error = -EINVAL;
 			goto out_filestream_unmount;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 021ea65909c915..b218786e734df0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3965,6 +3965,9 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		  __entry->dest_lblk)
 );
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
+#ifdef CONFIG_XFS_RT
+DEFINE_DOUBLE_IO_EVENT(xfs_reflink_adjust_rtbigalloc_len);
+#endif /* CONFIG_XFS_RT */
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);

