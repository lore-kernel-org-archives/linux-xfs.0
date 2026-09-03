Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE71494810
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435698; cv=none; b=r2EdQK0/N0GezqAdbi0lZATe+r537Yq7LxlsxAi8h3QofeAbD9ceD715CrxzaIxneBBAp3SGTXRX82rlZb3RM2pVpdWbigtsn72jDsK8LvQFGBqXoJ7g0bDmz8Y4qNSPZNMC9nvv68wOpj9sCKvcmyB/QXUR1ZGzUVooFqOXBJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435698; c=relaxed/simple;
	bh=Ob7OXQvn6vd7EzRcpzeXiZOJmXZVp67P444VTnuGrpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wttu9v+K7HDD0wy5tbxU3zraxW83cTp7D+z5lDfejFEeYImkjUbKA9rD1spCAmDgtiLr9YoGLqv+HnWQuGPq3gXON5dxiFlywWameThF4d5oFyA6xrkDfzSrp1N4JX5DN0lB0ojjYDA+po1zSjltESGaD60sQ0ahPoMdgk8JhKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUyz9Ugy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUyz9Ugy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637BD1F000E9;
	Thu,  3 Sep 2026 11:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435687;
	bh=gsi1U8CSK32lPtXYPrLfHMgQkVYSQHJm14KeZVpcB9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUyz9UgyI/l4s3ujwjkc+my814AuEJJ34v3TganFPmLPH6NoRVz9p4ORCb7mf4WUH
	 swRXOH37NMj6mhVbZeXdkDF0q2hpeN/huRJmoPNlI6WtVRY/EXLoh1oy/TkFWlXc1C
	 0zIQ54Cco/uZi6zPRf4dnYwwwjX6mVRiv3SCXn47Z37QaFuUFgtlDlsEH87Bkg6Kdh
	 ng8SwvmlyhXHvw11TLe3/Yg8sUtrxwUHeH8uaA2EhPVF4LRQTz9s2KvS7IZvz44a86
	 jKh8xJngl/UXUhkuyTn0nKzxOl2zieiZkx4gQpxbbeJshPeZI2MATqXG6Yr2lYR4Hk
	 ubiu4MVbQtegA==
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
Subject: [PATCH v2 12/23] xfs: massage xfs_imap_to_bp into xfs_read_icluster
Date: Thu,  3 Sep 2026 13:39:54 +0200
Message-ID: <20260903114022.570210-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/iunlink.c             |  2 +-
 libxfs/inode.c           |  2 +-
 libxfs/iunlink.c         |  2 +-
 libxfs/libxfs_api_defs.h |  2 +-
 libxfs/logitem.c         |  3 ++-
 libxfs/xfs_ialloc.c      |  2 +-
 libxfs/xfs_inode_buf.c   | 12 +++++-------
 libxfs/xfs_inode_buf.h   |  6 +++---
 repair/bmap_repair.c     |  2 +-
 9 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/db/iunlink.c b/db/iunlink.c
index b4705a187b28..ba5637553d6d 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -65,7 +65,7 @@ get_next_unlinked(
 		dbprintf("\n");
 	}
 
-	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
+	error = -libxfs_read_icluster(mp, NULL, ip->i_imap.im_blkno, &ino_bp);
 	if (error) {
 		libxfs_irele(ip);
 		goto bad;
diff --git a/libxfs/inode.c b/libxfs/inode.c
index b4bf3b5859a7..fe127160ed0a 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -182,7 +182,7 @@ libxfs_iget(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &bp);
 		if (error)
 			goto out_destroy;
 
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 7a00915290db..15654d262ba0 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -44,7 +44,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	error = xfs_read_icluster(mp, tp, ip->i_imap.im_blkno, &ibp);
 	if (error)
 		return error;
 	/*
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d7c912e77879..4f542ae7267e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -200,7 +200,7 @@
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
-#define xfs_imap_to_bp			libxfs_imap_to_bp
+#define xfs_read_icluster		libxfs_read_icluster
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 67b982788061..ac50b680d386 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -261,7 +261,8 @@ xfs_inode_item_precommit(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(ip->i_mount, tp, ip->i_imap.im_blkno,
+				&bp);
 		if (error)
 			return error;
 
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
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 2e1995b39334..dadd6e2ce39f 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -821,7 +821,7 @@ rebuild_bmap(
 	 * Rebuilding the inode fork rolled the transaction, so we need to
 	 * re-grab the inode cluster buffer and dinode pointer for the caller.
 	 */
-	err2 = -libxfs_imap_to_bp(mp, NULL, &sc.ip->i_imap, ino_bpp);
+	err2 = -libxfs_read_icluster(mp, NULL, sc.ip->i_imap.im_blkno, ino_bpp);
 	if (err2)
 		do_error(
  _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
-- 
2.55.0

