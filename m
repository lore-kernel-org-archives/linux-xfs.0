Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1394CCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE41D218AC
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="drAJ2vzb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfKAWJl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53788 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKAWJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RAmaK7VDhvq/gJvwk057eQaOtthTbbiPo/uHxlUO3AA=; b=drAJ2vzbpw6WCAdfwcFmIjEVS
        J574htzSWWAwgmdH3ujqLxOHLgXbnwFsYY6jmf3MT+NWtCb9RJA36B5BaGHF9xampN2kDNdsLBC1E
        HGDGjBiBLBz/FmHST7FaRVoL4sOFSGPihyKxVU5HKIvCCGGYHmB4RSgczcVuOHSGljP/Adms+QPKo
        QtXuwbPe7H2uXSWdf03TyeQQ341Eihv/Ty7ncJBDMn6dYOrx9S1KuLMJAILu0aBmYvoIuIKyER4tX
        hlS8ku0oiOBahRASCzM7HOaPFB71JL9DzF94Na9gQcnd/jvtgR4boBo4m5PsSNUIUkmSn7i2Xrfly
        2SFSYucUQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf6z-00069t-0s
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 25/34] xfs: remove the ->data_entry_entry_p method
Date:   Fri,  1 Nov 2019 15:07:10 -0700
Message-Id: <20191101220719.29100-26-hch@lst.de>
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

Replace the users of the ->data_entry_entry_p dir ops method with a
direct calculation using ->data_entry_offset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 37 ----------------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  5 -----
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_data.c  |  6 +++---
 fs/xfs/libxfs/xfs_dir2_sf.c    |  2 +-
 fs/xfs/scrub/dir.c             |  4 ++--
 fs/xfs/xfs_dir2_readdir.c      |  4 ++--
 7 files changed, 9 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 35edf470efc8..47c56f6dd872 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -123,34 +123,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 	return ((struct xfs_dir3_data_hdr *)hdr)->best_free;
 }
 
-static struct xfs_dir2_data_entry *
-xfs_dir2_data_entry_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
-static struct xfs_dir2_data_unused *
-xfs_dir2_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + sizeof(struct xfs_dir2_data_hdr));
-}
-
-static struct xfs_dir2_data_entry *
-xfs_dir3_data_entry_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
-static struct xfs_dir2_data_unused *
-xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
-{
-	return (struct xfs_dir2_data_unused *)
-		((char *)hdr + sizeof(struct xfs_dir3_data_hdr));
-}
-
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
@@ -165,9 +137,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 				XFS_DIR2_DATA_ENTSIZE(1) +
 				XFS_DIR2_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
-
-	.data_entry_p = xfs_dir2_data_entry_p,
-	.data_unused_p = xfs_dir2_data_unused_p,
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
@@ -184,9 +153,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir2_data_hdr),
-
-	.data_entry_p = xfs_dir2_data_entry_p,
-	.data_unused_p = xfs_dir2_data_unused_p,
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
@@ -203,9 +169,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 				XFS_DIR3_DATA_ENTSIZE(1) +
 				XFS_DIR3_DATA_ENTSIZE(2),
 	.data_entry_offset = sizeof(struct xfs_dir3_data_hdr),
-
-	.data_entry_p = xfs_dir3_data_entry_p,
-	.data_unused_p = xfs_dir3_data_unused_p,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 20417c42ca6f..e9de15e62630 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -44,11 +44,6 @@ struct xfs_dir_ops {
 	xfs_dir2_data_aoff_t data_dotdot_offset;
 	xfs_dir2_data_aoff_t data_first_offset;
 	size_t	data_entry_offset;
-
-	struct xfs_dir2_data_entry *
-		(*data_entry_p)(struct xfs_dir2_data_hdr *hdr);
-	struct xfs_dir2_data_unused *
-		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 };
 
 extern const struct xfs_dir_ops *
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 34e0cdf03950..b32beb71b7b2 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1122,7 +1122,7 @@ xfs_dir2_sf_to_block(
 	 * The whole thing is initialized to free by the init routine.
 	 * Say we're using the leaf and tail area.
 	 */
-	dup = dp->d_ops->data_unused_p(hdr);
+	dup = (void *)hdr + dp->d_ops->data_entry_offset;
 	needlog = needscan = 0;
 	error = xfs_dir2_data_use_free(args, bp, dup, args->geo->blksize - i,
 			i, &needlog, &needscan);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 2c79be4c3153..edb3fe5c9174 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -71,7 +71,7 @@ __xfs_dir3_data_check(
 		return __this_address;
 
 	hdr = bp->b_addr;
-	p = (char *)ops->data_entry_p(hdr);
+	p = (char *)hdr + ops->data_entry_offset;
 
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
@@ -587,7 +587,7 @@ xfs_dir2_data_freescan_int(
 	/*
 	 * Set up pointers.
 	 */
-	p = (char *)ops->data_entry_p(hdr);
+	p = (char *)hdr + ops->data_entry_offset;
 	endp = xfs_dir3_data_endp(geo, hdr);
 	/*
 	 * Loop over the block's entries.
@@ -685,7 +685,7 @@ xfs_dir3_data_init(
 	/*
 	 * Set up an unused entry for the block's body.
 	 */
-	dup = dp->d_ops->data_unused_p(hdr);
+	dup = (void *)hdr + dp->d_ops->data_entry_offset;
 	dup->freetag = cpu_to_be16(XFS_DIR2_DATA_FREE_TAG);
 
 	t = args->geo->blksize - (uint)dp->d_ops->data_entry_offset;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 10199261c94c..b2c6c492b09d 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -296,7 +296,7 @@ xfs_dir2_block_to_sf(
 	/*
 	 * Set up to loop over the block's entries.
 	 */
-	ptr = (char *)dp->d_ops->data_entry_p(hdr);
+	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
 	endptr = xfs_dir3_data_endp(args->geo, hdr);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	/*
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index dfaa0fca617e..8d6ecfe09611 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -241,7 +241,7 @@ xchk_dir_rec(
 	dent = (struct xfs_dir2_data_entry *)(((char *)bp->b_addr) + off);
 
 	/* Make sure we got a real directory entry. */
-	p = (char *)mp->m_dir_inode_ops->data_entry_p(bp->b_addr);
+	p = bp->b_addr + mp->m_dir_inode_ops->data_entry_offset;
 	endp = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 	if (!endp) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
@@ -391,7 +391,7 @@ xchk_directory_data_bestfree(
 	}
 
 	/* Make sure the bestfrees are actually the best free spaces. */
-	ptr = (char *)d_ops->data_entry_p(bp->b_addr);
+	ptr = bp->b_addr + d_ops->data_entry_offset;
 	endptr = xfs_dir3_data_endp(mp->m_dir_geo, bp->b_addr);
 
 	/* Iterate the entries, stopping when we hit or go past the end. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index e18045465455..04f8c2451b93 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -176,7 +176,7 @@ xfs_dir2_block_getdents(
 	/*
 	 * Set up values for the loop.
 	 */
-	ptr = (char *)dp->d_ops->data_entry_p(hdr);
+	ptr = (char *)hdr + dp->d_ops->data_entry_offset;
 	endptr = xfs_dir3_data_endp(geo, hdr);
 
 	/*
@@ -410,7 +410,7 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Find our position in the block.
 			 */
-			ptr = (char *)dp->d_ops->data_entry_p(hdr);
+			ptr = (char *)hdr + dp->d_ops->data_entry_offset;
 			byteoff = xfs_dir2_byte_to_off(geo, curoff);
 			/*
 			 * Skip past the header.
-- 
2.20.1

