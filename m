Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72D7C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BBC1214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jLs8ioNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfKGSYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:24:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44080 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfKGSYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mo1t/E5LU40G+9s/JIltl62P8jX7CJtwDfPOSfXqlAY=; b=jLs8ioNcG31/K1gIuyvbAI/GX
        T2zSZNyGjvEJNEHt29UIYgqQHIyE90WBW9RREjN836o5IUzeQDxo2lhT4HxotLn71HJTkL7nJsiCu
        TmWU03pdU5DAVmVHGQ+vZNyepR230RODlqnqSyJxRI+mve8/pkeAAa0NFycG3fpNCsk7JRca+gWMy
        m1vCZKWv+EdqnRDextL7duayP+KVWzC8qBct0Ugk7UMgRSoRWP3rpPpN2s8yibnKAERHyhYR0tezl
        6fYioEW+GjYZKSs2pCdngXcF0xzN2cTMGEZGIVO1mlFnBwa4J/7Y4+ZJ9WinaUsiN8x5c1ABZI6Zf
        V33CFwhFA==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSk-00035s-88
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:24:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/46] xfs: make the xfs_dir3_icfree_hdr available to xfs_dir2_node_addname_int
Date:   Thu,  7 Nov 2019 19:23:39 +0100
Message-Id: <20191107182410.12660-16-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Return the xfs_dir3_icfree_hdr used by the helpers called from
xfs_dir2_node_addname_int to the main function to prepare for the
next round of changes where we'll use the ichdr in xfs_dir3_icfree_hdr
to avoid extra operations to find the bests pointers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 42 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 4e49ac64a2ff..6d67ceac48b7 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1666,14 +1666,13 @@ xfs_dir2_node_add_datablk(
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
@@ -1736,25 +1735,25 @@ xfs_dir2_node_add_datablk(
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
 
@@ -1763,14 +1762,13 @@ xfs_dir2_node_add_datablk(
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
@@ -1784,10 +1782,10 @@ xfs_dir2_node_find_freeblk(
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
@@ -1814,13 +1812,12 @@ xfs_dir2_node_find_freeblk(
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
 
@@ -1864,13 +1861,13 @@ xfs_dir2_node_find_freeblk(
 
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
@@ -1904,6 +1901,7 @@ xfs_dir2_node_addname_int(
 	struct xfs_dir2_free	*free = NULL;	/* freespace block structure */
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_dir3_icfree_hdr freehdr;
 	struct xfs_buf		*dbp;		/* data block buffer */
 	struct xfs_buf		*fbp;		/* freespace buffer */
 	xfs_dir2_data_aoff_t	aoff;
@@ -1918,8 +1916,8 @@ xfs_dir2_node_addname_int(
 	__be16			*bests;
 
 	length = dp->d_ops->data_entsize(args->namelen);
-	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &findex,
-					   length);
+	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
+					   &findex, length);
 	if (error)
 		return error;
 
@@ -1941,7 +1939,7 @@ xfs_dir2_node_addname_int(
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

