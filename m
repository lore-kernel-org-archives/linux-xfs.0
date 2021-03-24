Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC2C433C1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45DE561A0E
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhCXOWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbhCXOVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C249C061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=gdiDkoMzXVgSeDXb/k59IH5EWxTiRlMXEW8v9m1mtgM=; b=C5uqK6KPG6NzTrqJkTlYayBimF
        /mXbz8agJzZn3Mfj7eGBcuHBQaWMlv1FWKrZjMAPptiw53RbrH+TCd+F7Qxtu7pGzURq47X1sem3G
        kTnwcyvxmNX/Ny6hCBAQwyE3gCLE0Y+XwrroDVI2IxzzM75mn/dC/LHm+rerWJtmUThgkLzU7lw3T
        fiIJxALJ4JTnGwCF7pb2iXnU4moYBmkOaPNL8YYZdUc/YJFuN0sgY4axoWE1piEyWZjDpUWTPQ5N0
        Y72aZ1vz/lnLX2zBLu8DdHYG1lLJWUmNjEV9w8YfB5vFWjmL0JKA2InLP3N+/i1AGzZdj11uCF6jA
        5gOcRJeg==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4O6-0045WR-Fx
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/18] xfs: split xfs_imap_to_bp
Date:   Wed, 24 Mar 2021 15:21:12 +0100
Message-Id: <20210324142129.1011766-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split looking up the dinode from xfs_imap_to_bp, which can be
significantly simplified as a result.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c   | 27 ++++-----------------------
 fs/xfs/libxfs/xfs_inode_buf.h   |  5 ++---
 fs/xfs/libxfs/xfs_trans_inode.c |  3 +--
 fs/xfs/scrub/ialloc.c           |  3 +--
 fs/xfs/xfs_icache.c             |  6 +++---
 fs/xfs/xfs_inode.c              |  6 ++++--
 fs/xfs/xfs_log_recover.c        |  3 ++-
 7 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 4d7410e49db41b..af5ee8bd7e6ac9 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -124,37 +124,18 @@ const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
 /*
  * This routine is called to map an inode to the buffer containing the on-disk
  * version of the inode.  It returns a pointer to the buffer containing the
- * on-disk inode in the bpp parameter, and in the dipp parameter it returns a
- * pointer to the on-disk inode within that buffer.
- *
- * If a non-zero error is returned, then the contents of bpp and dipp are
- * undefined.
+ * on-disk inode in the bpp parameter.
  */
 int
 xfs_imap_to_bp(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	struct xfs_imap		*imap,
-	struct xfs_dinode       **dipp,
-	struct xfs_buf		**bpp,
-	uint			buf_flags)
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	int			error;
-
-	buf_flags |= XBF_UNMAPPED;
-	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-				   (int)imap->im_len, buf_flags, &bp,
+	return xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
+				   imap->im_len, XBF_UNMAPPED, bpp,
 				   &xfs_inode_buf_ops);
-	if (error) {
-		ASSERT(error != -EAGAIN || (buf_flags & XBF_TRYLOCK));
-		return error;
-	}
-
-	*bpp = bp;
-	if (dipp)
-		*dipp = xfs_buf_offset(bp, imap->im_boffset);
-	return 0;
 }
 
 static inline struct timespec64 xfs_inode_decode_bigtime(uint64_t ts)
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index ef5eaf33d146ff..9e1ae38380b3c0 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -47,9 +47,8 @@ struct xfs_imap {
 	unsigned short	im_boffset;	/* inode offset in block in bytes */
 };
 
-int	xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
-		       struct xfs_imap *, struct xfs_dinode **,
-		       struct xfs_buf **, uint);
+int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
+		       struct xfs_imap *imap, struct xfs_buf **bpp);
 void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
 void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 			  xfs_lsn_t lsn);
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 90f1d564505270..4f02cb439ab57e 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -164,8 +164,7 @@ xfs_trans_log_inode(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
-					&bp, 0);
+		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
 		if (error) {
 			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
 			return;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 6517d67e8d51f8..1644199c29a815 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -212,7 +212,6 @@ xchk_iallocbt_check_cluster(
 {
 	struct xfs_imap			imap;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
-	struct xfs_dinode		*dip;
 	struct xfs_buf			*cluster_bp;
 	unsigned int			nr_inodes;
 	xfs_agnumber_t			agno = bs->cur->bc_ag.agno;
@@ -278,7 +277,7 @@ xchk_iallocbt_check_cluster(
 			&XFS_RMAP_OINFO_INODES);
 
 	/* Grab the inode cluster buffer. */
-	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &dip, &cluster_bp, 0);
+	error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap, &cluster_bp);
 	if (!xchk_btree_xref_process_error(bs->sc, bs->cur, 0, &error))
 		return error;
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1d7720a0c068b7..266fb77ac5608c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -505,14 +505,14 @@ xfs_iget_cache_miss(
 	    (flags & XFS_IGET_CREATE) && !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
 	} else {
-		struct xfs_dinode	*dip;
 		struct xfs_buf		*bp;
 
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &bp, 0);
+		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
 		if (error)
 			goto out_destroy;
 
-		error = xfs_inode_from_disk(ip, dip);
+		error = xfs_inode_from_disk(ip,
+				xfs_buf_offset(bp, ip->i_imap.im_boffset));
 		if (!error)
 			xfs_buf_set_ref(bp, XFS_INO_REF);
 		xfs_trans_brelse(tp, bp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 46a861d55e487b..3fa332a1d24f9f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2051,9 +2051,10 @@ xfs_iunlink_update_inode(
 
 	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0);
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
 	if (error)
 		return error;
+	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
 
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
@@ -2178,13 +2179,14 @@ xfs_iunlink_map_ino(
 		return error;
 	}
 
-	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0);
+	error = xfs_imap_to_bp(mp, tp, imap, bpp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
 				__func__, error);
 		return error;
 	}
 
+	*dipp = xfs_buf_offset(*bpp, imap->im_boffset);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f31308de03b9..31348e660cd65b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2683,9 +2683,10 @@ xlog_recover_process_one_iunlink(
 	/*
 	 * Get the on disk inode to find the next inode in the bucket.
 	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &ibp, 0);
+	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &ibp);
 	if (error)
 		goto fail_iput;
+	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
 
 	xfs_iflags_clear(ip, XFS_IRECOVERY);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
-- 
2.30.1

