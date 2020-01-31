Return-Path: <SRS0=/Bg7=3U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACCFC33CB2
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 06:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEE5C2082E
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 06:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HMR9mf80"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgAaGDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 01:03:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgAaGDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jan 2020 01:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yd3J5xUeb7qqa0S6UKGzFY1aO3j3YHqIwdxgXXx3zTY=; b=HMR9mf80kVDjJJ7hsPEuaQhwF
        Y6urop8n2bB1lkH9JpepdV7+0Yhu8SOIkv1g70QB0svHtxpyFInLlRrFtqTZxV7V4Q1nROKNbCmzU
        jnp6E7phJJVAYTPQGqkKDSqn1HxwWlcbRfZG/KT5a5NNhc5UKcUTettfAxdOw2uqxQABAUro+ZlmF
        8BJGOGoMJsyajX0Mb9/W1w4j6a6KqodczhDy5eDriqF4yxznRoSTDdhrR49syjC9TT9RS14rNkcq/
        YaLytAQyHfSiElpPozhb0aVTJ7WLT5kZHJiTH86l3EEVmFphI7df0sDx9xkV7t1fagPN1QeMt0shu
        1w12Mb0kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ixPOd-0004t7-1F; Fri, 31 Jan 2020 06:03:15 +0000
Date:   Thu, 30 Jan 2020 22:03:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 11/8] xfs_repair: don't corrupt a attr fork da3 node
 when clearing forw/back
Message-ID: <20200131060315.GA26786@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <20200130181512.GZ3447196@magnolia>
 <20200130184606.GC3447196@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130184606.GC3447196@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks sensible, but I think we want the helpers for both the node and
leaf case, something like this untested patch:

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 9a44f610..0c26f0e6 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -952,6 +952,98 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
 	return 0;
 }
 
+static int
+process_leaf_da_root(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	struct blkmap		*blkmap,
+	int			*repair,
+	struct xfs_buf		*bp)
+{
+	struct xfs_attr3_icleaf_hdr leafhdr;
+	xfs_dahash_t		next_hashval;
+	int			repairlinks = 0;
+
+	/*
+	 * Check sibling pointers in block 0 before we have to release the btree
+	 * block.
+	 */
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
+		if (!no_modify)  {
+			do_warn(
+	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+				ino);
+			repairlinks = 1;
+			leafhdr.forw = 0;
+			leafhdr.back = 0;
+			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo, bp->b_addr,
+					&leafhdr);
+		} else  {
+			do_warn(
+	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
+		}
+	}
+
+	if (process_leaf_attr_block(mp, bp->b_addr, 0, ino, blkmap, 0,
+			&next_hashval, repair)) {
+		*repair = 0;
+		/* the block is bad.  lose the attribute fork. */
+		libxfs_putbuf(bp);
+		return 1;
+	}
+
+	*repair = *repair || repairlinks;
+	return 0;
+}
+
+static int
+process_node_da_root(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	struct blkmap		*blkmap,
+	int			*repair,
+	struct xfs_buf		*bp)
+{
+	struct xfs_da3_icnode_hdr	da3_hdr;
+	int			repairlinks = 0;
+	int			error;
+
+	/*
+	 * Check sibling pointers in block 0 before we have to release the btree
+	 * block.
+	 */
+	xfs_da3_node_hdr_from_disk(mp, &da3_hdr, bp->b_addr);
+	if (da3_hdr.forw != 0 || da3_hdr.back != 0)  {
+		if (!no_modify)  {
+			do_warn(
+_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
+				ino);
+
+			repairlinks = 1;
+			da3_hdr.forw = 0;
+			da3_hdr.back = 0;
+			xfs_da3_node_hdr_to_disk(mp, bp->b_addr, &da3_hdr);
+		} else  {
+			do_warn(
+_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
+		}
+	}
+
+	/* must do this now, to release block 0 before the traversal */
+	if ((*repair || repairlinks) && !no_modify) {
+		*repair = 1;
+		libxfs_writebuf(bp, 0);
+	} else
+		libxfs_putbuf(bp);
+	error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
+	if (error)
+		*repair = 0;
+	return error;
+}
+
 /*
  * Start processing for a leaf or fuller btree.
  * A leaf directory is one where the attribute fork is too big for
@@ -963,19 +1055,15 @@ _("wrong FS UUID, inode %" PRIu64 " attr block %" PRIu64 "\n"),
  */
 static int
 process_longform_attr(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
-	blkmap_t	*blkmap,
-	int		*repair)	/* out - 1 if something was fixed */
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_dinode	*dip,
+	blkmap_t		*blkmap,
+	int			*repair) /* out - 1 if something was fixed */
 {
-	xfs_attr_leafblock_t	*leaf;
-	xfs_fsblock_t	bno;
-	xfs_buf_t	*bp;
-	xfs_dahash_t	next_hashval;
-	int		repairlinks = 0;
-	struct xfs_attr3_icleaf_hdr leafhdr;
-	int		error;
+	xfs_fsblock_t		bno;
+	struct xfs_buf		*bp;
+	struct xfs_da_blkinfo   *info;
 
 	*repair = 0;
 
@@ -1015,77 +1103,35 @@ process_longform_attr(
 		return 1;
 	}
 
-	/* verify leaf block */
-	leaf = bp->b_addr;
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
-
-	/* check sibling pointers in leaf block or root block 0 before
-	* we have to release the btree block
-	*/
-	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
-		if (!no_modify)  {
-			do_warn(
-	_("clearing forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"),
-				ino);
-			repairlinks = 1;
-			leafhdr.forw = 0;
-			leafhdr.back = 0;
-			xfs_attr3_leaf_hdr_to_disk(mp->m_attr_geo,
-						   leaf, &leafhdr);
-		} else  {
-			do_warn(
-	_("would clear forw/back pointers in block 0 for attributes in inode %" PRIu64 "\n"), ino);
-		}
-	}
-
 	/*
 	 * use magic number to tell us what type of attribute this is.
 	 * it's possible to have a node or leaf attribute in either an
 	 * extent format or btree format attribute fork.
 	 */
-	switch (leafhdr.magic) {
+	info = bp->b_addr;
+	switch (be16_to_cpu(info->magic)) {
 	case XFS_ATTR_LEAF_MAGIC:	/* leaf-form attribute */
 	case XFS_ATTR3_LEAF_MAGIC:
-		if (process_leaf_attr_block(mp, leaf, 0, ino, blkmap,
-				0, &next_hashval, repair)) {
-			*repair = 0;
-			/* the block is bad.  lose the attribute fork. */
-			libxfs_putbuf(bp);
-			return(1);
-		}
-		*repair = *repair || repairlinks;
-		break;
-
+		return process_leaf_da_root(mp, ino, dip, blkmap, repair, bp);
 	case XFS_DA_NODE_MAGIC:		/* btree-form attribute */
 	case XFS_DA3_NODE_MAGIC:
-		/* must do this now, to release block 0 before the traversal */
-		if ((*repair || repairlinks) && !no_modify) {
-			*repair = 1;
-			libxfs_writebuf(bp, 0);
-		} else
-			libxfs_putbuf(bp);
-		error = process_node_attr(mp, ino, dip, blkmap); /* + repair */
-		if (error)
-			*repair = 0;
-		return error;
+		return process_node_da_root(mp, ino, dip, blkmap, repair, bp);
 	default:
 		do_warn(
 	_("bad attribute leaf magic # %#x for dir ino %" PRIu64 "\n"),
-			be16_to_cpu(leaf->hdr.info.magic), ino);
+			be16_to_cpu(info->magic), ino);
 		libxfs_putbuf(bp);
 		*repair = 0;
-		return(1);
+		return 1;
 	}
 
 	if (*repair && !no_modify)
 		libxfs_writebuf(bp, 0);
 	else
 		libxfs_putbuf(bp);
-
-	return(0);  /* repair may be set */
+	return 0;  /* repair may be set */
 }
 
-
 static int
 xfs_acl_from_disk(
 	struct xfs_mount	*mp,
