Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 916A0C5DF60
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF2C218AE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XrrIGnRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfKGSZq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44244 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfKGSZp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nJNSdScFwk9C/b9D497IwP+ak5O29z3Dr6wil831PbM=; b=XrrIGnRt6S/WbFRJrdpOmVcUa
        +rga36uMQvy7sGs4eKAlDG4+8nmWm4nAL5bdWM6zumQR9nQehoT9+4CXdQGjjHQ/mA1xPHSZdB3rD
        D8DK812hJN060f36hG63+sXABZXLdlWdbjs9LvAO+oMfSPzOoLUPB/LMYczdCjy8+ORi5jZbx8P77
        FsyThZyVhw5VYMBFua53gbaFhbOWa41iDq+WdVfBmJnCQ/d8KzqEtmBkHkgZqXbHSN2Nz0p/mGHpH
        fJFj9LT7tNcMrnBogObarnOVPt1IDZHVxxZ/GYf/Jz4WKr4mogyz1uTQM/BgIZ9rB4SHMccptQbJz
        lvjWFXtFg==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTZ-0004Rp-6I
        for linux-xfs@vger.kernel.org; Thu, 07 Nov 2019 18:25:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 35/46] xfs: cleanup __xfs_dir3_data_check
Date:   Thu,  7 Nov 2019 19:23:59 +0100
Message-Id: <20191107182410.12660-36-hch@lst.de>
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

Use an offset as the main means for iteration, and only do pointer
arithmetics to find the data/unused entries.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 59 ++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 50e3fa092ff9..8c729270f9f1 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -23,6 +23,22 @@ static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_unused *dup,
 		struct xfs_dir2_data_free **bf_ent);
 
+/*
+ * The number of leaf entries is limited by the size of the block and the amount
+ * of space used by the data entries.  We don't know how much space is used by
+ * the data entries yet, so just ensure that the count falls somewhere inside
+ * the block right now.
+ */
+static inline unsigned int
+xfs_dir2_data_max_leaf_entries(
+	const struct xfs_dir_ops	*ops,
+	struct xfs_da_geometry		*geo)
+{
+	return (geo->blksize - sizeof(struct xfs_dir2_block_tail) -
+		ops->data_entry_offset) /
+			sizeof(struct xfs_dir2_leaf_entry);
+}
+
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
@@ -38,23 +54,20 @@ __xfs_dir3_data_check(
 	xfs_dir2_block_tail_t	*btp=NULL;	/* block tail */
 	int			count;		/* count of entries found */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
-	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_free_t	*dfp;		/* bestfree entry */
-	xfs_dir2_data_unused_t	*dup;		/* unused entry */
-	char			*endp;		/* end of useful data */
+	void			*endp;		/* end of useful data */
 	int			freeseen;	/* mask of bestfrees seen */
 	xfs_dahash_t		hash;		/* hash of current name */
 	int			i;		/* leaf index */
 	int			lastfree;	/* last entry was unused */
 	xfs_dir2_leaf_entry_t	*lep=NULL;	/* block leaf entries */
 	struct xfs_mount	*mp = bp->b_mount;
-	char			*p;		/* current data position */
 	int			stale;		/* count of stale leaves */
 	struct xfs_name		name;
+	unsigned int		offset;
+	unsigned int		end;
 	const struct xfs_dir_ops *ops;
-	struct xfs_da_geometry	*geo;
-
-	geo = mp->m_dir_geo;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
 
 	/*
 	 * We can be passed a null dp here from a verifier, so we need to go the
@@ -71,7 +84,7 @@ __xfs_dir3_data_check(
 		return __this_address;
 
 	hdr = bp->b_addr;
-	p = (char *)ops->data_entry_p(hdr);
+	offset = ops->data_entry_offset;
 
 	switch (hdr->magic) {
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
@@ -79,15 +92,8 @@ __xfs_dir3_data_check(
 		btp = xfs_dir2_block_tail_p(geo, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 
-		/*
-		 * The number of leaf entries is limited by the size of the
-		 * block and the amount of space used by the data entries.
-		 * We don't know how much space is used by the data entries yet,
-		 * so just ensure that the count falls somewhere inside the
-		 * block right now.
-		 */
 		if (be32_to_cpu(btp->count) >=
-		    ((char *)btp - p) / sizeof(struct xfs_dir2_leaf_entry))
+		    xfs_dir2_data_max_leaf_entries(ops, geo))
 			return __this_address;
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
@@ -99,6 +105,7 @@ __xfs_dir3_data_check(
 	endp = xfs_dir3_data_endp(geo, hdr);
 	if (!endp)
 		return __this_address;
+	end = endp - bp->b_addr;
 
 	/*
 	 * Account for zero bestfree entries.
@@ -128,8 +135,10 @@ __xfs_dir3_data_check(
 	/*
 	 * Loop over the data/unused entries.
 	 */
-	while (p < endp) {
-		dup = (xfs_dir2_data_unused_t *)p;
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+
 		/*
 		 * If it's unused, look for the space in the bestfree table.
 		 * If we find it, account for that, else make sure it
@@ -140,10 +149,10 @@ __xfs_dir3_data_check(
 
 			if (lastfree != 0)
 				return __this_address;
-			if (endp < p + be16_to_cpu(dup->length))
+			if (offset + be16_to_cpu(dup->length) > end)
 				return __this_address;
 			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
-			    (char *)dup - (char *)hdr)
+			    offset)
 				return __this_address;
 			fa = xfs_dir2_data_freefind_verify(hdr, bf, dup, &dfp);
 			if (fa)
@@ -158,7 +167,7 @@ __xfs_dir3_data_check(
 				    be16_to_cpu(bf[2].length))
 					return __this_address;
 			}
-			p += be16_to_cpu(dup->length);
+			offset += be16_to_cpu(dup->length);
 			lastfree = 1;
 			continue;
 		}
@@ -168,15 +177,13 @@ __xfs_dir3_data_check(
 		 * in the leaf section of the block.
 		 * The linear search is crude but this is DEBUG code.
 		 */
-		dep = (xfs_dir2_data_entry_t *)p;
 		if (dep->namelen == 0)
 			return __this_address;
 		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
-		if (endp < p + ops->data_entsize(dep->namelen))
+		if (offset + ops->data_entsize(dep->namelen) > end)
 			return __this_address;
-		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
-		    (char *)dep - (char *)hdr)
+		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) != offset)
 			return __this_address;
 		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
 			return __this_address;
@@ -198,7 +205,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		p += ops->data_entsize(dep->namelen);
+		offset += ops->data_entsize(dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
-- 
2.20.1

