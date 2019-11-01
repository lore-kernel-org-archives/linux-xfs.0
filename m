Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62F8CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2D92085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S9MZ7OOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfKAWIn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:08:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWIn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=coDZ3rlx+nyxx963Qhs+lWQ2l+I8pBJlek0JdFSsS0Q=; b=S9MZ7OOfLmfvV71+/tpX67SRE
        miNcLHMn6EEb0eVLlN2r4MV5kqdJBpXSVPFMipOlNGJVbGBTb5J6DElZlrVCunHRkzKiseTNHJJj2
        PNnc7XyAolCjXvF83S28UNzN0V/e2iLGnjs5e/kuBZwJteAgTTJBM7VLVbCtqbYtd5r/aimhY2B6T
        RsV8tnr6Imy43i+XKECX8MM3XHFnOLiS5dLXGSUPNd99F5dVSdJtQmehNeElAlYLwaVQXHQpEP9zc
        PrHe47cByJuhmfiT3o4Dl6oG6ORhtrCuWbGRINmU2xTDXo7tPzJfJ5QxSR3C455O/OIrEyRBhP55h
        srMM+8v0Q==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf63-0005xc-0S
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/34] xfs: make the xfs_dir3_icfree_hdr available to xfs_dir2_node_addname_int
Date:   Fri,  1 Nov 2019 15:06:59 -0700
Message-Id: <20191101220719.29100-15-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the xfs_dir3_icfree_hdr used by the helpers called from
xfs_dir2_node_addname_int to the main function to prepare for the
next round of changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 42 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 26032eba1e32..d400243c9556 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1660,14 +1660,13 @@ xfs_dir2_node_add_datablk(
 	xfs_dir2_db_t		*dbno,
 	struct xfs_buf		**dbpp,
 	struct xfs_buf		**fbpp,
+	struct xfs_dir3_icfree_hdr *hdr,
 	int			*findex)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_dir2_data_free *bf;
-	struct xfs_dir2_data_hdr *hdr;
 	struct xfs_dir2_free	*free = NULL;
 	xfs_dir2_db_t		fbno;
 	struct xfs_buf		*fbp;
@@ -1730,25 +1729,25 @@ xfs_dir2_node_add_datablk(
 			return error;
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
 
 		/* Remember the first slot as our empty slot. */
-		freehdr.firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
+		hdr->firstdb = (fbno - xfs_dir2_byte_to_db(args->geo,
 							XFS_DIR2_FREE_OFFSET)) *
 				dp->d_ops->free_max_bests(args->geo);
 	} else {
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(mp, &freehdr, free);
+		xfs_dir2_free_hdr_from_disk(mp, hdr, free);
 	}
 
 	/* Set the freespace block index from the data block number. */
 	*findex = dp->d_ops->db_to_fdindex(args->geo, *dbno);
 
 	/* Extend the freespace table if the new data block is off the end. */
-	if (*findex >= freehdr.nvalid) {
+	if (*findex >= hdr->nvalid) {
 		ASSERT(*findex < dp->d_ops->free_max_bests(args->geo));
-		freehdr.nvalid = *findex + 1;
+		hdr->nvalid = *findex + 1;
 		bests[*findex] = cpu_to_be16(NULLDATAOFF);
 	}
 
@@ -1757,14 +1756,13 @@ xfs_dir2_node_add_datablk(
 	 * true) then update the header.
 	 */
 	if (bests[*findex] == cpu_to_be16(NULLDATAOFF)) {
-		freehdr.nused++;
-		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, &freehdr);
+		hdr->nused++;
+		xfs_dir2_free_hdr_to_disk(mp, fbp->b_addr, hdr);
 		xfs_dir2_free_log_header(args, fbp);
 	}
 
 	/* Update the freespace value for the new block in the table. */
-	hdr = dbp->b_addr;
-	bf = dp->d_ops->data_bestfree_p(hdr);
+	bf = dp->d_ops->data_bestfree_p(dbp->b_addr);
 	bests[*findex] = bf[0].length;
 
 	*dbpp = dbp;
@@ -1778,10 +1776,10 @@ xfs_dir2_node_find_freeblk(
 	struct xfs_da_state_blk	*fblk,
 	xfs_dir2_db_t		*dbnop,
 	struct xfs_buf		**fbpp,
+	struct xfs_dir3_icfree_hdr *hdr,
 	int			*findexp,
 	int			length)
 {
-	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_dir2_free	*free = NULL;
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_trans	*tp = args->trans;
@@ -1808,13 +1806,12 @@ xfs_dir2_node_find_freeblk(
 		if (findex >= 0) {
 			/* caller already found the freespace for us. */
 			bests = dp->d_ops->free_bests_p(free);
-			xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr,
-						    free);
+			xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
 
-			ASSERT(findex < freehdr.nvalid);
+			ASSERT(findex < hdr->nvalid);
 			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
 			ASSERT(be16_to_cpu(bests[findex]) >= length);
-			dbno = freehdr.firstdb + findex;
+			dbno = hdr->firstdb + findex;
 			goto found_block;
 		}
 
@@ -1858,13 +1855,13 @@ xfs_dir2_node_find_freeblk(
 
 		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
-		xfs_dir2_free_hdr_from_disk(dp->i_mount, &freehdr, free);
+		xfs_dir2_free_hdr_from_disk(dp->i_mount, hdr, free);
 
 		/* Scan the free entry array for a large enough free space. */
-		for (findex = freehdr.nvalid - 1; findex >= 0; findex--) {
+		for (findex = hdr->nvalid - 1; findex >= 0; findex--) {
 			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
 			    be16_to_cpu(bests[findex]) >= length) {
-				dbno = freehdr.firstdb + findex;
+				dbno = hdr->firstdb + findex;
 				goto found_block;
 			}
 		}
@@ -1898,6 +1895,7 @@ xfs_dir2_node_addname_int(
 	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_buf		*dbp;		/* data block buffer */
 	struct xfs_buf		*fbp;		/* freespace buffer */
 	xfs_dir2_data_aoff_t	aoff;
@@ -1912,8 +1910,8 @@ xfs_dir2_node_addname_int(
 	__be16			*bests;
 
 	length = dp->d_ops->data_entsize(args->namelen);
-	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
-					   length);
+	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
+					   &findex, length);
 	if (error)
 		return error;
 
@@ -1935,7 +1933,7 @@ xfs_dir2_node_addname_int(
 		/* we're going to have to log the free block index later */
 		logfree = 1;
 		error = xfs_dir2_node_add_datablk(args, fblk, &dbno, &dbp, &fbp,
-						  &findex);
+						  &freehdr, &findex);
 	} else {
 		/* Read the data block in. */
 		error = xfs_dir3_data_read(tp, dp,
-- 
2.20.1

