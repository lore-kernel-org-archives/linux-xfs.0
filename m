Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44F19F430
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416310; cv=none; b=h++GAjiHIOLzS299s3/Ch9tEDbijfXm55tnSVTnDNh19MTWt0piuFzrS761n8PWxm6//Np+tFelAxL9+dgY0zaTNqKQ38e4058UnA9CowtWcLXJnIxF8Fw+85pibnJMJHNOczxR1MKrwI3bXgTCaUNzz2UK3WxIgYDFNe/+aKro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416310; c=relaxed/simple;
	bh=8svOkqyDhvtmoKyRmdlfVLGDCIW5e05QT/GBbirxhQA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YPI7RREncR1orLvQmGnmujgzIri73+WYLEv0fi+7NUFFn2HHJ4Lj7IqprVq6EDGNqGsTq/NT+t78HprYnM7b/ardhpmVbp6E+kewwqWLXiwfyw+6KzwV9wcorYHVl4sn/rWv0Lp6O92Xg3pxhbcor9BAelg/Wdq9zLevbY4gW2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSCQ4YWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSCQ4YWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD9C4CEC3;
	Thu, 31 Oct 2024 23:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416310;
	bh=8svOkqyDhvtmoKyRmdlfVLGDCIW5e05QT/GBbirxhQA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eSCQ4YWfgX0TZPiQ35rH0MLsujaYIpfj9w0OOzjfLQSFNO3XpxGtCLFVBz+sTVAnU
	 9vW6I9VywpBo7JqGTKodo3WbShI9qdmAomigGJWqtMjRqz5AYDBEXJJ4JASqzCSJiL
	 vgb7YiSplof8134fBd6jgkj5FtH2UVM8U8aNgZq390+ghtadeK/AU5eAwAaPSwC8a7
	 MfKXtHLCdsgPEZGjrcGYqMVDJ1oYI405oToE/0PEM8JTS4dXF3fPi5NWEJSGYZxkoY
	 2zbvC7oS0usu1EhZiYvNYQGzAkxb9AuoZfrWr9rdKwOn3v94J689cnODcHN9dznmLg
	 BgYZUEygDGKWA==
Date: Thu, 31 Oct 2024 16:11:49 -0700
Subject: [PATCH 12/41] xfs: factor out rtbitmap/summary initialization helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566102.962545.10982856844842387054.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 2a95ffc44b610643c9d5d2665600d3fbefa5ec4f

Add helpers to libxfs that can be shared by growfs and mkfs for
initializing the rtbitmap and summary, and by passing the optional data
pointer also by repair for rebuilding them.  This will become even more
useful when the rtgroups feature adds a metadata header to each block,
which means even more shared code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor documentation and data advance tweaks]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtbitmap.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h |    3 +
 2 files changed, 129 insertions(+)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index fc904547147e93..9d771af677adb1 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -13,6 +13,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
@@ -1253,3 +1255,127 @@ xfs_rtbitmap_unlock_shared(
 	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
 		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
 }
+
+static int
+xfs_rtfile_alloc_blocks(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_filblks_t		count_fsb,
+	struct xfs_bmbt_irec	*map)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			nmap = 1;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtalloc,
+			XFS_GROWFSRT_SPACE_RES(mp, count_fsb), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+				XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+			XFS_BMAPI_METADATA, 0, map, &nmap);
+	if (error)
+		goto out_trans_cancel;
+
+	return xfs_trans_commit(tp);
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Get a buffer for the block. */
+static int
+xfs_rtfile_initialize_block(
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsbno,
+	void			*data)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	struct xfs_buf		*bp;
+	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
+	enum xfs_blft		buf_type;
+	int			error;
+
+	if (ip == mp->m_rsumip)
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+	else
+		buf_type = XFS_BLFT_RTBITMAP_BUF;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
+	if (error)
+		return error;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	xfs_trans_buf_set_type(tp, bp, buf_type);
+	bp->b_ops = &xfs_rtbuf_ops;
+	if (data)
+		memcpy(bp->b_addr, data, copylen);
+	else
+		memset(bp->b_addr, 0, copylen);
+	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
+	return xfs_trans_commit(tp);
+}
+
+/*
+ * Allocate space to the bitmap or summary file, and zero it, for growfs.
+ * @data must be a contiguous buffer large enough to fill all blocks in the
+ * file; or NULL to initialize the contents to zeroes.
+ */
+int
+xfs_rtfile_initialize_blocks(
+	struct xfs_inode	*ip,		/* inode (bitmap/summary) */
+	xfs_fileoff_t		offset_fsb,	/* offset to start from */
+	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
+	void			*data)		/* data to fill the blocks */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
+
+	while (offset_fsb < end_fsb) {
+		struct xfs_bmbt_irec	map;
+		xfs_filblks_t		i;
+		int			error;
+
+		error = xfs_rtfile_alloc_blocks(ip, offset_fsb,
+				end_fsb - offset_fsb, &map);
+		if (error)
+			return error;
+
+		/*
+		 * Now we need to clear the allocated blocks.
+		 *
+		 * Do this one block per transaction, to keep it simple.
+		 */
+		for (i = 0; i < map.br_blockcount; i++) {
+			error = xfs_rtfile_initialize_block(ip,
+					map.br_startblock + i, data);
+			if (error)
+				return error;
+			if (data)
+				data += copylen;
+		}
+
+		offset_fsb = map.br_startoff + map.br_blockcount;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e87e2099cff5e0..0d5ab5e2cb6a32 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -343,6 +343,9 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
+int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
+
 void xfs_rtbitmap_lock(struct xfs_trans *tp, struct xfs_mount *mp);
 void xfs_rtbitmap_unlock(struct xfs_mount *mp);
 

