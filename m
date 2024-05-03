Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F81BF31
	for <linux-xfs@vger.kernel.org>; Fri,  3 May 2024 04:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714710829; cv=none; b=hmqEqluVcDqFLIGSBntru3w3TdMVb1Z1RwyJ5H6OH+r1xupRs73qwYsmfAA2CFIQCF9PKdml1rB0xlSJj3bEas83pIYIV8mpZsp/SqmUs4Ws/beEymmTAyK8vg0qTkXF7GHLW79j8belr8mXtOrKZP1Isfm7rkB8UARoBuXMqQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714710829; c=relaxed/simple;
	bh=G9y0D1UHvopU97+VzBHcXocu0Fnic5D4PCQH425Rywg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvpaTHkB2sY5tyoWKnPAL+RNbfH5WlAyHrEBbW5T42864V3Nn5flhDBeuV60dzKQ82AFCz0rUliCUZRt0r1zyxuoDnAYlY3heXunXJ+jYIrmptNDrVzBUEX006DRV5ClL83Bk7tXJxLU4dGbjVlJQLvSfGk2P1Jv/3hHanLMgsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxLXU3a9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxLXU3a9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F92CC116B1;
	Fri,  3 May 2024 04:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714710828;
	bh=G9y0D1UHvopU97+VzBHcXocu0Fnic5D4PCQH425Rywg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bxLXU3a91TNO40JGtakQfBymyJSC4SvVOEgdIPkSCrvOtcbAtjzcJnHk7BfI7cMRb
	 CtP7vLwYdm3pQDw9N1h2BA6benJluB51P89/Fk2r6DQw8pWlpbshwhHnBbki2ekerf
	 JlQxpTVnx9qPoEpFNjZZc2ByuceUHTLIi95Cti/++fiiDgdt8CGrJ5VFB8xZPZaMHQ
	 NXb1+ykgYS3QxIBbk8fRZ6Yn3pCCGr4PmuQRADC3Lfp8r9SssDrm5xODPnMsz7fz62
	 pcWG0pbt1AZbvHmncPN4cecL1wUDT7mY8MNSJ5cUcL0vWBBHvHAt02ncNQ7Is5wevS
	 Jh7yuA6AxewEQ==
Date: Thu, 02 May 2024 21:33:48 -0700
Subject: [PATCH 1/5] xfs: use unsigned ints for non-negative quantities in
 xfs_attr_remote.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171471075334.2662283.15584984314190560776.stgit@frogsfrogsfrogs>
In-Reply-To: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
References: <171471075305.2662283.8498264701525930955.stgit@frogsfrogsfrogs>
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

In the next few patches we're going to refactor the attr remote code so
that we can support headerless remote xattr values for storing merkle
tree blocks.  For now, let's change the code to use unsigned int to
describe quantities of bytes and blocks that cannot be negative.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_remote.c |   61 +++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr_remote.h |    2 +
 2 files changed, 31 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index beb0efdd8f6b..7c38c6feb8c9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -47,13 +47,13 @@
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
@@ -92,7 +92,6 @@ xfs_attr3_rmt_verify(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	void			*ptr,
-	int			fsbsize,
 	xfs_daddr_t		bno)
 {
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
@@ -103,7 +102,7 @@ xfs_attr3_rmt_verify(
 		return __this_address;
 	if (be64_to_cpu(rmt->rm_blkno) != bno)
 		return __this_address;
-	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
+	if (be32_to_cpu(rmt->rm_bytes) > mp->m_attr_geo->blksize - sizeof(*rmt))
 		return __this_address;
 	if (be32_to_cpu(rmt->rm_offset) +
 				be32_to_cpu(rmt->rm_bytes) > XFS_XATTR_SIZE_MAX)
@@ -122,9 +121,9 @@ __xfs_attr3_rmt_read_verify(
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
@@ -141,7 +140,7 @@ __xfs_attr3_rmt_read_verify(
 			*failaddr = __this_address;
 			return -EFSBADCRC;
 		}
-		*failaddr = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
+		*failaddr = xfs_attr3_rmt_verify(mp, bp, ptr, bno);
 		if (*failaddr)
 			return -EFSCORRUPTED;
 		len -= blksize;
@@ -186,7 +185,7 @@ xfs_attr3_rmt_write_verify(
 {
 	struct xfs_mount *mp = bp->b_mount;
 	xfs_failaddr_t	fa;
-	int		blksize = mp->m_attr_geo->blksize;
+	unsigned int	blksize = mp->m_attr_geo->blksize;
 	char		*ptr;
 	int		len;
 	xfs_daddr_t	bno;
@@ -203,7 +202,7 @@ xfs_attr3_rmt_write_verify(
 	while (len > 0) {
 		struct xfs_attr3_rmt_hdr *rmt = (struct xfs_attr3_rmt_hdr *)ptr;
 
-		fa = xfs_attr3_rmt_verify(mp, bp, ptr, blksize, bno);
+		fa = xfs_attr3_rmt_verify(mp, bp, ptr, bno);
 		if (fa) {
 			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 			return;
@@ -281,20 +280,20 @@ xfs_attr_rmtval_copyout(
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
 
@@ -330,20 +329,20 @@ xfs_attr_rmtval_copyin(
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
@@ -389,12 +388,12 @@ xfs_attr_rmtval_get(
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
 
@@ -452,7 +451,7 @@ xfs_attr_rmt_find_hole(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	int			error;
-	int			blkcnt;
+	unsigned int		blkcnt;
 	xfs_fileoff_t		lfileoff = 0;
 
 	/*
@@ -481,11 +480,11 @@ xfs_attr_rmtval_set_value(
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
@@ -644,7 +643,7 @@ xfs_attr_rmtval_invalidate(
 	struct xfs_da_args	*args)
 {
 	xfs_dablk_t		lblkno;
-	int			blkcnt;
+	unsigned int		blkcnt;
 	int			error;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index d097ec6c4dc3..c64b04f91caf 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_ATTR_REMOTE_H__
 #define	__XFS_ATTR_REMOTE_H__
 
-int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
+unsigned int xfs_attr3_rmt_blocks(struct xfs_mount *mp, unsigned int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,

