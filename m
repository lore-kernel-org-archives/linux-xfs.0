Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241F71D86DC
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 07:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765525190; cv=none; b=K1kG9LT07bTHvQcT93U889jynTd16bRgEA1iljXpJlcthn5ze1TC/QyhlWrNCpT7RHFWhSrS9w6VteBpXbtJ4cLWu+4l0ivMgKQcL1OgnFzLF+HtrXdRylXOH5WzSwU50Isea4kiyEo/ep72iOagOpfIqEQ3+FGlQwnPn/93ciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765525190; c=relaxed/simple;
	bh=LPZ64LxbVFS4w/qlPvDGuA2Lx52INZKazjcZKBqZIKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V41UblVDU4bjF1rBqh8ECfjtO2hXFscpj1hQHtTTugn0Y78Tq0/ef5AbdwubRgWchqy2t2B6oaqEvCKGKZhDF66QW/20Y7UoNw18Jx56Z9uXkf3hQGGChucUlDn2+lFViqlORvtvTKqHoSpB90+KlJUH1vYw8XXL0chj3BgumSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 59578227A88; Fri, 12 Dec 2025 08:39:37 +0100 (CET)
Date: Fri, 12 Dec 2025 08:39:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix XFS_ERRTAG_FORCE_ZERO_RANGE for zoned file
 system
Message-ID: <20251212073937.GA30172@lst.de>
References: <20251210090400.3642383-1-hch@lst.de> <aTmTl_khrrNz9yLY@bfoster> <20251210154016.GA3851@lst.de> <aTmqe3lDL2BkZe3b@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmqe3lDL2BkZe3b@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 12:14:35PM -0500, Brian Foster wrote:
> Well yeah, it would look something like this at the current site:
> 
> 	if (!is_inode_zoned() && XFS_TEST_ERROR(...) ||
> 	    ac->reserved_blocks == magic_default_res + len)
> 		xfs_zero_range(...);
> 	else
> 		xfs_free_file_space(...);
> 
> ... and the higher level zoned code would clone the XFS_TEST_ERROR() to
> create the block reservation condition to trigger it.
> 
> Alternatively perhaps you could make that check look something like:
> 
> 	if (XFS_TEST_ERROR() && (!ac || ac->res > len))
> 		...
> 	else
> 		...

I had to juggle this a bit to not trigger the wrong way and add a
helper.  The changes are a bit bigger than the original version,
but I guess you'll probably prefer it because it keeps things more
contained in the zoned code?

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6108612182e2..d70c8e0d802b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1240,6 +1240,28 @@ xfs_falloc_insert_range(
 	return xfs_insert_file_space(XFS_I(inode), offset, len);
 }
 
+#define XFS_ZONED_ZERO_RANGE_SPACE_RES		2
+
+/*
+ * Zero range implements a full zeroing mechanism but is only used in limited
+ * situations. It is more efficient to allocate unwritten extents than to
+ * perform zeroing here, so use an errortag to randomly force zeroing on DEBUG
+ * kernels for added test coverage.
+ *
+ * On zoned file systems, the error is already injected by
+ * xfs_file_zoned_fallocate, which then reserves the additional space needed.
+ * We only check for this extra space reservation here.
+ */
+static inline bool
+xfs_falloc_force_zero(
+	struct xfs_inode		*ip,
+	struct xfs_zone_alloc_ctx	*ac)
+{
+	if (ac)
+		return ac->reserved_blocks > XFS_ZONED_ZERO_RANGE_SPACE_RES;
+	return XFS_TEST_ERROR(ip->i_mount, XFS_ERRTAG_FORCE_ZERO_RANGE);
+}
+
 /*
  * Punch a hole and prealloc the range.  We use a hole punch rather than
  * unwritten extent conversion for two reasons:
@@ -1268,14 +1290,7 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
-	/*
-	 * Zero range implements a full zeroing mechanism but is only used in
-	 * limited situations. It is more efficient to allocate unwritten
-	 * extents than to perform zeroing here, so use an errortag to randomly
-	 * force zeroing on DEBUG kernels for added test coverage.
-	 */
-	if (XFS_TEST_ERROR(ip->i_mount,
-			   XFS_ERRTAG_FORCE_ZERO_RANGE)) {
+	if (xfs_falloc_force_zero(ip, ac)) {
 		error = xfs_zero_range(ip, offset, len, ac, NULL);
 	} else {
 		error = xfs_free_file_space(ip, offset, len, ac);
@@ -1423,13 +1438,26 @@ xfs_file_zoned_fallocate(
 {
 	struct xfs_zone_alloc_ctx ac = { };
 	struct xfs_inode	*ip = XFS_I(file_inode(file));
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_filblks_t		count_fsb;
 	int			error;
 
-	error = xfs_zoned_space_reserve(ip->i_mount, 2, XFS_ZR_RESERVED, &ac);
+	/*
+	 * If full zeroing is forced by the error injection nob, we need a space
+	 * reservation that covers the entire range.  See the comment in
+	 * xfs_zoned_write_space_reserve for the rationale for the calculation.
+	 * Otherwise just reserve space for the two boundary blocks.
+	 */
+	count_fsb = XFS_ZONED_ZERO_RANGE_SPACE_RES;
+	if ((mode & FALLOC_FL_MODE_MASK) == FALLOC_FL_ZERO_RANGE &&
+	    XFS_TEST_ERROR(mp, XFS_ERRTAG_FORCE_ZERO_RANGE))
+		count_fsb += XFS_B_TO_FSB(mp, len) + 1;
+
+	error = xfs_zoned_space_reserve(mp, count_fsb, XFS_ZR_RESERVED, &ac);
 	if (error)
 		return error;
 	error = __xfs_file_fallocate(file, mode, offset, len, &ac);
-	xfs_zoned_space_unreserve(ip->i_mount, &ac);
+	xfs_zoned_space_unreserve(mp, &ac);
 	return error;
 }
 
