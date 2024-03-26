Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2321353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425397; cv=none; b=SdwzChmXQUPf4h1PlQk6DXyddTTr2u/VeKF/A7dJDIl/pGb+8r5BWdiOpbAEX2Z8Jq/nhOKPS9DMhOE0+DEKcO5vr2/0/P3q6s83o3XyMDQv2Lx5zBMiat7RkJuDt8eCklIFZDApjPk3mIN2hHtCh6imq5cJUyzxbXTvoyLnzjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425397; c=relaxed/simple;
	bh=7GIlr4x2YB7zlCaNkMGbqwrcwZVHX5jvFbcIDtrqI/o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qb8yGfc+7B7/ClUTlPXNBDD85BmQVXqpEwtFPMpOkl9TJzYOWZc1Ej65iE/CwwGeLpfd2xqX3iSU9hXelTgk1Og3hdPEohH7xlEfmlH8YYGNrNznmYQ1tXmWDOM1PqUDVNnqEgx4TON+iziHmjdoai/PKlquhvnvTK47BFO+38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1dAZMsg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1dAZMsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A08CC433F1;
	Tue, 26 Mar 2024 03:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425397;
	bh=7GIlr4x2YB7zlCaNkMGbqwrcwZVHX5jvFbcIDtrqI/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c1dAZMsgqUvw7jBeXj9mBHiXpMaUy5Gzhc6v8bKHWxa5GzYcYUHCgRiklYL2LrTiy
	 iSWHpPvoT1SDX1KOQQvE+MWXGSsadf0M88tFQtyD6uj9gVPXlRGu5SGOsNYa5L1mkM
	 rv8Suyho9FCL8MlXJJCnHoJ7gr7QPoAytZ+YShwyUtOQ0Ou5voJrFnOOfSwHHoEKWA
	 Mx5tkJsdwufd5wpMxcN45pZWg+fdcQPFECDZDkjGO+EpCoB/FEQUd7UQoxCwtYoLnx
	 g5ay9jUg9gfqPcAcTzE4Gnp92E1nWCliPw5/tBOKVn4VQurCfyWu5cRVmvSISYzaJf
	 smMNEgKs4zuZA==
Date: Mon, 25 Mar 2024 20:56:36 -0700
Subject: [PATCH 108/110] xfs: move symlink target write function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132933.2215168.4516774530554114266.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: b8102b61f7b8929ad8043e4574a1e26276398041

Move xfs_symlink_write_target to xfs_symlink_remote.c so that kernel and
mkfs can share the same function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_symlink_remote.c |   77 ++++++++++++++++++++++++++++++++++++++++++-
 libxfs/xfs_symlink_remote.h |    3 ++
 2 files changed, 79 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index f2e591ea9c9c..875e03bcbc90 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -18,7 +18,6 @@
 #include "xfs_bmap.h"
 #include "xfs_health.h"
 
-
 /*
  * Each contiguous block has a header, so it is not just a simple pathlen
  * to FSB conversion.
@@ -302,3 +301,79 @@ xfs_symlink_remote_read(
  out:
 	return error;
 }
+
+/* Write the symlink target into the inode. */
+int
+xfs_symlink_write_target(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen,
+	xfs_fsblock_t		fs_blocks,
+	uint			resblks)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_mount	*mp = tp->t_mountp;
+	const char		*cur_chunk;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	int			byte_cnt;
+	int			nmaps;
+	int			offset = 0;
+	int			n;
+	int			error;
+
+	/*
+	 * If the symlink will fit into the inode, write it inline.
+	 */
+	if (pathlen <= xfs_inode_data_fork_size(ip)) {
+		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
+
+		ip->i_disk_size = pathlen;
+		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+		return 0;
+	}
+
+	nmaps = XFS_SYMLINK_MAPS;
+	error = xfs_bmapi_write(tp, ip, 0, fs_blocks, XFS_BMAPI_METADATA,
+			resblks, mval, &nmaps);
+	if (error)
+		return error;
+
+	ip->i_disk_size = pathlen;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	cur_chunk = target_path;
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		char	*buf;
+
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+				BTOBB(byte_cnt), 0, &bp);
+		if (error)
+			return error;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		byte_cnt = min(byte_cnt, pathlen);
+
+		buf = bp->b_addr;
+		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset, byte_cnt,
+				bp);
+
+		memcpy(buf, cur_chunk, byte_cnt);
+
+		cur_chunk += byte_cnt;
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
+		xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
+						(char *)bp->b_addr);
+	}
+	ASSERT(pathlen == 0);
+	return 0;
+}
diff --git a/libxfs/xfs_symlink_remote.h b/libxfs/xfs_symlink_remote.h
index bb83a8b8dfa6..a63bd38ae4fa 100644
--- a/libxfs/xfs_symlink_remote.h
+++ b/libxfs/xfs_symlink_remote.h
@@ -19,5 +19,8 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
+int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
+		uint resblks);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */

