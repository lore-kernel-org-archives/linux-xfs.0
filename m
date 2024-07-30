Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8432963D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300623; cv=none; b=XJnHKCYeHxqHfLhGNLS49+6kNwUXOXAuW+df/ftrNoK0zjpT7tLeAzpkHqC8lcg4HUB0N9u5D6dzS4KraaX3ECu0V0mFRBe5lx8FCaIIG/MhJTTOenzOpsc6frSU/TUPPQ9QWjC5mDHQi5JX0FFU2Cz0HV5sXVIUSGmiDLQSovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300623; c=relaxed/simple;
	bh=9c7EMmuYZ7ZJQ3i61e30K372PXHFeyvKM6jGei/0Pj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s60+mJ2jyWFrB2wkXXeOR1pIG96zBS7Om7QSS6KduSJSKmRAMyeFiXzmedmsuXhjAtwDm/oCesESAlKq7hg0cT7JTwajl/yIKOOiLb6yBVEC2f8xqtuL+ZXuM6eyM20aImdM6KmqhwM8bWYfUH+hMVW4Slh9VpacGLq+AnJuA3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EaDix+04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EaDix+04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D707C32786;
	Tue, 30 Jul 2024 00:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300623;
	bh=9c7EMmuYZ7ZJQ3i61e30K372PXHFeyvKM6jGei/0Pj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EaDix+04XFyJZrdES/sfSIgLZDSnIevrIaZo50gudhuGEHBBuYejyuLVcZ8FnS2ug
	 10bQndBmZ/ERn/v9v8vTbOzBLFpUndO6izl4FqkKcQh6EyhQpnA8d9wBtM5+OPJ7ze
	 lZrGV/WybVsFwT/rIgCO5/5mrChOUfJkPGiJwQ7eBZ1mX6l3BNDxnsMUFOf4hM2fEf
	 hcs5okNjmkw3qbGkJNhBJvSNT9jEeTm0KZnqFfCRmw6FJ2PUVHzsMMaPl7qWpUSgmy
	 nUFcWrSqpUyT7K6o/QU936kPbJ8oIzpbre4dANLP88amUTWULm+CNS09O2N20mlM9e
	 RdlrBoCBNcTKg==
Date: Mon, 29 Jul 2024 17:50:22 -0700
Subject: [PATCH 102/115] xfs: use unsigned ints for non-negative quantities in
 xfs_attr_remote.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229843891.1338752.4693656738170403532.stgit@frogsfrogsfrogs>
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

Source kernel commit: a86f8671d03e6eb31abaefdf6928b92df0a2368c

In the next few patches we're going to refactor the attr remote code so
that we can support headerless remote xattr values for storing merkle
tree blocks.  For now, let's change the code to use unsigned int to
describe quantities of bytes and blocks that cannot be negative.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr_remote.c |   61 +++++++++++++++++++++++-----------------------
 libxfs/xfs_attr_remote.h |    2 +-
 2 files changed, 31 insertions(+), 32 deletions(-)


diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 282cf2cb9..34e74fd57 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -46,13 +46,13 @@
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
  */
-int
+unsigned int
 xfs_attr3_rmt_blocks(
-	struct xfs_mount *mp,
-	int		attrlen)
+	struct xfs_mount	*mp,
+	unsigned int		attrlen)
 {
 	if (xfs_has_crc(mp)) {
-		int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
+		unsigned int buflen = XFS_ATTR3_RMT_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
 		return (attrlen + buflen - 1) / buflen;
 	}
 	return XFS_B_TO_FSB(mp, attrlen);
@@ -91,7 +91,6 @@ xfs_attr3_rmt_verify(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	void			*ptr,
-	int			fsbsize,
 	xfs_daddr_t		bno)
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
@@ -102,7 +101,7 @@ xfs_attr3_rmt_verify(
 		return __this_address;
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
 		return __this_address;
-	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
+	if (be32_to_cpu(rmt->rm_bytes) > mp->m_attr_geo->blksize - sizeof(*rmt))
 		return __this_address;
 	if (be32_to_cpu(rmt->rm_offset) +
 				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
@@ -121,9 +120,9 @@ __xfs_attr3_rmt_read_verify(
 {
 	struct xfs_mount *mp = bp->b_mount;
 	char		*ptr;
-	int		len;
+	unsigned int	len;
 	xfs_daddr_t	bno;
-	int		blksize = mp->m_attr_geo->blksize;
+	unsigned int	blksize = mp->m_attr_geo->blksize;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_has_crc(mp))
@@ -140,7 +139,7 @@ __xfs_attr3_rmt_read_verify(
 			*failaddr = __this_address;
 			return -EFSBADCRC;
 		}
-		*failaddr = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
+		*failaddr = xfs_attr3_rmt_verify(mp, bp, ptr, bno);
 		if (*failaddr)
 			return -EFSCORRUPTED;
 		len -= blksize;
@@ -185,7 +184,7 @@ xfs_attr3_rmt_write_verify(
 {
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
-	int		blksize = mp->m_attr_geo->blksize;
+	unsigned int	blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
 	int		len;
 	xfs_daddr_t	bno;
@@ -202,7 +201,7 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		fa = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
+		fa = xfs_attr3_rmt_verify(mp, bp, ptr, bno);
 		if (fa) {
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			return;
@@ -280,20 +279,20 @@ xfs_attr_rmtval_copyout(
 	struct xfs_buf		*bp,
 	struct xfs_inode	*dp,
 	xfs_ino_t		owner,
-	int			*offset,
-	int			*valuelen,
+	unsigned int		*offset,
+	unsigned int		*valuelen,
 	uint8_t			**dst)
 {
 	char			*src = bp->b_addr;
 	xfs_daddr_t		bno = xfs_buf_daddr(bp);
-	int			len = BBTOB(bp->b_length);
-	int			blksize = mp->m_attr_geo->blksize;
+	unsigned int		len = BBTOB(bp->b_length);
+	unsigned int		blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
 	while (len > 0 && *valuelen > 0) {
-		int hdr_size = 0;
-		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int hdr_size = 0;
+		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 
@@ -329,20 +328,20 @@ xfs_attr_rmtval_copyin(
 	struct xfs_mount *mp,
 	struct xfs_buf	*bp,
 	xfs_ino_t	ino,
-	int		*offset,
-	int		*valuelen,
+	unsigned int	*offset,
+	unsigned int	*valuelen,
 	uint8_t		**src)
 {
 	char		*dst = bp->b_addr;
 	xfs_daddr_t	bno = xfs_buf_daddr(bp);
-	int		len = BBTOB(bp->b_length);
-	int		blksize = mp->m_attr_geo->blksize;
+	unsigned int	len = BBTOB(bp->b_length);
+	unsigned int	blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
 	while (len > 0 && *valuelen > 0) {
-		int hdr_size;
-		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
+		unsigned int hdr_size;
+		unsigned int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, blksize);
 
 		byte_cnt = min(*valuelen, byte_cnt);
 		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
@@ -388,12 +387,12 @@ xfs_attr_rmtval_get(
 	struct xfs_buf		*bp;
 	xfs_dablk_t		lblkno = args->rmtblkno;
 	uint8_t			*dst = args->value;
-	int			valuelen;
+	unsigned int		valuelen;
 	int			nmap;
 	int			error;
-	int			blkcnt = args->rmtblkcnt;
+	unsigned int		blkcnt = args->rmtblkcnt;
 	int			i;
-	int			offset = 0;
+	unsigned int		offset = 0;
 
 	trace_xfs_attr_rmtval_get(args);
 
@@ -451,7 +450,7 @@ xfs_attr_rmt_find_hole(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	int			error;
-	int			blkcnt;
+	unsigned int		blkcnt;
 	xfs_fileoff_t		lfileoff = 0;
 
 	/*
@@ -480,11 +479,11 @@ xfs_attr_rmtval_set_value(
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	uint8_t			*src = args->value;
-	int			blkcnt;
-	int			valuelen;
+	unsigned int		blkcnt;
+	unsigned int		valuelen;
 	int			nmap;
 	int			error;
-	int			offset = 0;
+	unsigned int		offset = 0;
 
 	/*
 	 * Roll through the "value", copying the attribute value to the
@@ -643,7 +642,7 @@ xfs_attr_rmtval_invalidate(
 	struct xfs_da_args	*args)
 {
 	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	unsigned int		blkcnt;
 	int			error;
 
 	/*
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index d097ec6c4..c64b04f91 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_ATTR_REMOTE_H__
 #define	__XFS_ATTR_REMOTE_H__
 
-int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
+unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,

