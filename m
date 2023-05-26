Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FAFC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbjEZBOd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbjEZBOb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:14:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16C9125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:14:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CADA64C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15FFC433EF;
        Fri, 26 May 2023 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063668;
        bh=uymlD9TvC8EmbHc/1mT3pWIZAARZKf6bUpJy3CjoNKo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AQfLFPWgeoaPXKBqb8JHvYe9iON2auuzKeL4c2zUHm4Eq1IMBYrmoGj/KnBr9eIjx
         4klE8nKoEPMVSGSF//SO12uW6we0OtOaXPJFb6G1cUyTQK4DRFKQsDzm2jczFV8mgj
         984WHjWpKyexRAiYqDorhT9DPr6hJNWeMst3fOg54atzva8G1XXVO1qN7FsLQCd15M
         JCIem+LlajcMP6gwKdgNwvp6S770YQAC9JCCqMJ+4NZ/ecz1ayXqqJOuOgZ1QPLxnU
         TiQbmuxDy3UBjBI3yGSZG3ckLWyBxPut+b3BwEQBk6547e08cTYM7bkf4d+8fDotuf
         Of7iwnsjOj0ig==
Date:   Thu, 25 May 2023 18:14:28 -0700
Subject: [PATCH 3/3] xfs: move symlink target write function to libxfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064609.3734314.12123552356439852393.stgit@frogsfrogsfrogs>
In-Reply-To: <168506064562.3734314.9065396398319098452.stgit@frogsfrogsfrogs>
References: <168506064562.3734314.9065396398319098452.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 7b4f2b306bc4..5261f15ea2ed 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -315,3 +315,79 @@ xfs_symlink_remote_read(
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
index 7d3acaee0af0..d81461c06b6b 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.h
+++ b/fs/xfs/libxfs/xfs_symlink_remote.h
@@ -20,5 +20,8 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 xfs_failaddr_t xfs_symlink_sf_verify_struct(void *sfp, int64_t size);
 xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 int xfs_symlink_remote_read(struct xfs_inode *ip, char *link);
+int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
+		uint resblks);
 
 #endif /* __XFS_SYMLINK_REMOTE_H */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index e92c7de74d6f..2ecaebbdb00e 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -92,15 +92,7 @@ xfs_symlink(
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
@@ -188,62 +180,11 @@ xfs_symlink(
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

