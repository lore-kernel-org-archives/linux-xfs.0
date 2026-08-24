Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E027AC31
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571991; cv=none; b=B2ruZGbnxpDtE/b3VXMxuBQo/v6SP6SIflaZTojcFLkR3tPMMKh9x/POYbQWMjcsVS3tXqAuQZxljZo/TveCj4XtbeqmySBob1xe0U1/vQoH3/7Lgz8wIlUP5nHaR9viJtjxRIi/pozVS/cpDm5mcQY9xnpcogXvhleeRpdvl04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571991; c=relaxed/simple;
	bh=CgeyXsE0Ta7TFpuzcQ7NRTvDHbtswWrO1fV/6Kqr2Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBkSSPwqhfuyhYs/0HQ6j0OUyaiIxcFEd4LwsWacJXe0ulzw0GNMwVbpwCg6bb5EwU8HX4SVbRAvq+qEA/fnFklosYqnYPRn0b5mRx9SvRZrEORZpzXNxnZZYZEUSnv2pO8/v3cud1PwnRFwsMP17ss+dQdK6FX+tQVrwUdTzc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cP+ahH/s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cP+ahH/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEA21F000E9;
	Mon, 24 Aug 2026 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571990;
	bh=SlbAHi2t3oa7XpzdyG8F6h473M8PYON1g4uKo+UFOPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cP+ahH/sLF7jgYyXUnCwQbpgJqfxiQltnsFMD65aPN41gFLeUV+p/jjgKXn65LHAY
	 ghlyBhoCaGqqQ9kPU/5oShs3AknhgtxpF1hMdYs/8Hq2nnSPh2c2hJxYJjmRyxXT+9
	 R1fM//L2a0JxR3I9DLkOG/HI+ASCG+E1DDx1edmp6P1tWydJoXefg46lq9uMwgv2rz
	 19F8JMcNTR6G7rWT9bvQ0HvC3qLwUZL+KF4Zn5C7JUp2aPBZvi6RL4TaA4XKYBhAH3
	 Iho1FqHM1h9FWxZ3xtVsuLh8fSidWRN7H2bc3rBRuJzYIp+avT1fJ3AjWXrdR/bzi3
	 4AdoNgf5GKH1w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH 11/21] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Date: Mon, 24 Aug 2026 12:40:09 +0200
Message-ID: <20260824104022.420566-12-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: caffb4252cf15c5c3bbe7ff1f48f24f4015edb9c

xfs_imap_to_bp only uses the im_blkno field from struct xfs_imap, so pass
that directly.  Rename the function to xfs_read_icluster, which describes
the functionality much better and matches other helpers like xfs_read_agf
and xfs_read_agi.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ialloc.c    |  2 +-
 libxfs/xfs_inode_buf.c | 12 +++++-------
 libxfs/xfs_inode_buf.h |  6 +++---
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f313acbe559a..7ecb7d54577a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1070,7 +1070,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_imap_to_bp(pag_mount(pag), tp, &imap, &bp);
+	error = xfs_read_icluster(pag_mount(pag), tp, imap.im_blkno, &bp);
 	if (error)
 		return -EAGAIN;
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 84800fb3b37b..6882f7099ab0 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -120,24 +120,22 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
 
 
 /*
- * This routine is called to map an inode to the buffer containing the on-disk
- * version of the inode.  It returns a pointer to the buffer containing the
- * on-disk inode in the bpp parameter.
+ * Read the inode cluster at @bno and return it in @bpp.
  */
 int
-xfs_imap_to_bp(
+xfs_read_icluster(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_imap		*imap,
+	xfs_daddr_t		bno,
 	struct xfs_buf		**bpp)
 {
 	int			error;
 
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, bno,
 			XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster),
 			0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
-		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
+		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, bno),
 				XFS_SICK_AG_INODES);
 	return error;
 }
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 54870796da41..bcad22871b5c 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -11,15 +11,15 @@ struct xfs_dinode;
 
 /*
  * Inode location information.  Stored in the inode and passed to
- * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
+ * xfs_read_icluster() to get a buffer and dinode for a given inode.
  */
 struct xfs_imap {
 	xfs_daddr_t	im_blkno;	/* starting BB of inode chunk */
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
-int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
-		       struct xfs_imap *imap, struct xfs_buf **bpp);
+int	xfs_read_icluster(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_daddr_t bno, struct xfs_buf **bpp);
 void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
-- 
2.55.0

