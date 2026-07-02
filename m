Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEBC306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022609; cv=none; b=ctgyW/Ozj1YijFFV8ohYFMZDWzDQN6JsQLxcCSp6VFVVicHRwJ0tiUELvr7hdvYazaFe1e0qVVPRr4RsmAVbMjf1JFC8JfjOS3S9qSkYc/eP3u/gzwDi+N8Q+ufsT1ll22GxNJNGzcfphm2OECETafKBxnwFO47wiPt7nR0Ev5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022609; c=relaxed/simple;
	bh=eYlw7OroKyfsK5dX906fSo4Swt7uWD7sm76NhSA8rYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hTz7J/N53K87F3c000CrRrSQZhLw0ag0jxiobaC+awpc/p0besx+PlaQKltw7NEdHF5gxtVIfYOGTyQHhAQAPCp3e0b5YMAXHosGB46rBnj/L+6FPYoXD+MsGf8wKm3FBtcCKxRhbWcaTxKSr6qEipYbl15eQDiQji4WiCpgBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aTGsrrS7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTGsrrS7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 232A71F000E9;
	Thu,  2 Jul 2026 20:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022608;
	bh=h0DBiYnpJA0at7QJjm9C9v2hJGOklw9M8KT7snw8TMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=aTGsrrS7E0+ewynnLNGLaSI7dqrh8ijn0c6xRKQrcP7SvO20zzwbDD/OC2GQo+Tth
	 xTAhGkFN9aS8/XGKihelH709vU19M2rZFlVsD6Nz4wumnv97nmXBO6jAcS1zHgTb3P
	 dupsCVVTa+m/2ei9J0WtTIvtEtT34WSp9C83YvHgS+XXH9gqS1uhR9e+T2VhgGeAAS
	 nXuvJ3Bvs5qoi6HQUvqPG2aSVmbkvMlds4vUVVd/4DEdzhDV5LA1tZAUEb0l6HaNL0
	 EVTTdg2jLX0IEeqm4Td4S95Yis5XIaPW1n0zP1wP4YnJ6XzI3+uppPBjiFtqeOvUkx
	 l/GeIGDV5KoVQ==
Date: Thu, 02 Jul 2026 13:03:27 -0700
Subject: [PATCH 12/18] xfs: massage xfs_imap_to_bp into xfs_read_icluster
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226527.845537.18042509448302644400.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 libxfs/libxfs_api_defs.h |    2 +-
 libxfs/xfs_inode_buf.h   |    6 +++---
 db/iunlink.c             |    2 +-
 libxfs/inode.c           |    2 +-
 libxfs/iunlink.c         |    2 +-
 libxfs/logitem.c         |    3 ++-
 libxfs/xfs_ialloc.c      |    2 +-
 libxfs/xfs_inode_buf.c   |   12 +++++-------
 repair/bmap_repair.c     |    2 +-
 9 files changed, 16 insertions(+), 17 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d7c912e778799c..4f542ae7267e8c 100644
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
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 54870796da419a..bcad22871b5c40 100644
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
diff --git a/db/iunlink.c b/db/iunlink.c
index b4705a187b28b1..ba5637553d6de5 100644
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
index b4bf3b5859a7e6..fe127160ed0a11 100644
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
index 7a00915290db86..15654d262ba0d1 100644
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
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 67b982788061f8..ac50b680d38623 100644
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
index f313acbe559ad7..7ecb7d54577a0d 100644
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
index 84800fb3b37b7a..6882f7099ab030 100644
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
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 2e1995b3933428..dadd6e2ce39f8b 100644
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

