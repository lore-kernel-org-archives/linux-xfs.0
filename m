Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4568ABA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOo2buWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCD0C433C7;
	Sun, 31 Dec 2023 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054255;
	bh=JRwaarBFcxrrKHSEWIRkqG2SiY594nUbnq1doASaNGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oOo2buWZxfRgLHn1Jwt8BVlZpCsXs1bN54qHOgzTRsQxvqxQCc+cczgc9J9BTO8lH
	 B0JAoII5mX6Y9MPqEVqB+HYdSN14hfQBfJ7wJuOMKuLHqzLjcaFhJz7jRZ3p5EeaIl
	 dk8s1nonBRN1lIHSYL/rPLazYl67v5RcGvJKxeQro+3Ybh+D18eZ0AFjStX3Nn4wDZ
	 T5svTre8VYSD4bWVnzL+iMpo6nknvuhfoCZPJnfpk6taMUQBjCxlD/ZXSXL62/VzBB
	 SY17SeZ60iR39PWFI+HOIwB8Jq6jdvjsqONx3qMI7HTmPDJVNzEMEK41iVnwAHZmWd
	 nrCCxBAvhO9sA==
Date: Sun, 31 Dec 2023 12:24:14 -0800
Subject: [PATCH 3/3] xfs: move symlink target write function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832695.1750161.6464756869860729774.stgit@frogsfrogsfrogs>
In-Reply-To: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
References: <170404832640.1750161.7474736298870522543.stgit@frogsfrogsfrogs>
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

Move xfs_symlink_write_target to xfs_symlink_remote.c so that kernel and
mkfs can share the same function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |   76 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_symlink_remote.h |    3 +
 fs/xfs/xfs_symlink.c               |   69 ++-------------------------------
 3 files changed, 84 insertions(+), 64 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index b1ab6bdc3834e..1b8815159702e 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -304,3 +304,79 @@ xfs_symlink_remote_read(
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
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.h b/fs/xfs/libxfs/xfs_symlink_remote.h
index bb83a8b8dfa66..a63bd38ae4faf 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -19,5 +19,8 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(void *sfp, int64_t size);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
+int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
+		uint resblks);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 0a9a1ad733336..2a082749be5cf 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -94,15 +94,7 @@ xfs_symlink(
 	int			error = 0;
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
-	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
-	int			nmaps;
-	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
-	xfs_daddr_t		d;
-	const char		*cur_chunk;
-	int			byte_cnt;
-	int			n;
-	struct xfs_buf		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -190,62 +182,11 @@ xfs_symlink(
 	xfs_qm_vop_create_dqattach(tp, ip, udqp, gdqp, pdqp);
 
 	resblks -= XFS_IALLOC_SPACE_RES(mp);
-	/*
-	 * If the symlink will fit into the inode, write it inline.
-	 */
-	if (pathlen <= xfs_inode_data_fork_size(ip)) {
-		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
-
-		ip->i_disk_size = pathlen;
-		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
-	} else {
-		int	offset;
-
-		first_fsb = 0;
-		nmaps = XFS_SYMLINK_MAPS;
-
-		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
-				  XFS_BMAPI_METADATA, resblks, mval, &nmaps);
-		if (error)
-			goto out_trans_cancel;
-
-		resblks -= fs_blocks;
-		ip->i_disk_size = pathlen;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		cur_chunk = target_path;
-		offset = 0;
-		for (n = 0; n < nmaps; n++) {
-			char	*buf;
-
-			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-			error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					       BTOBB(byte_cnt), 0, &bp);
-			if (error)
-				goto out_trans_cancel;
-			bp->b_ops = &xfs_symlink_buf_ops;
-
-			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-			byte_cnt = min(byte_cnt, pathlen);
-
-			buf = bp->b_addr;
-			buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
-						   byte_cnt, bp);
-
-			memcpy(buf, cur_chunk, byte_cnt);
-
-			cur_chunk += byte_cnt;
-			pathlen -= byte_cnt;
-			offset += byte_cnt;
-
-			xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
-			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
-							(char *)bp->b_addr);
-		}
-		ASSERT(pathlen == 0);
-	}
+	error = xfs_symlink_write_target(tp, ip, target_path, pathlen,
+			fs_blocks, resblks);
+	if (error)
+		goto out_trans_cancel;
+	resblks -= fs_blocks;
 	i_size_write(VFS_I(ip), ip->i_disk_size);
 
 	/*

