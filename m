Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67F0CA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F462217D9
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 22:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p1NCQvuR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKAWJw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 18:09:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53804 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfKAWJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:09:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f6z0fG0eq/fCw3zkLZVXFzi0gLiUMTemEqFOLdsDbBk=; b=p1NCQvuRVWU2/tXSXwNVjqFgx
        rGr3A9XWunCsNeEXeypYgB0BMtSr1X5z5l2amsi3KTKV2c/U8bf0yO7yW2dHNOLiJxSZ1aBKKy10B
        xIHe6yKZM5HQRS6YkCJWOSMNxQO5MhU8d4U1wLts1UgzXTErYF2BeZderAKNONuJ6ZuC7cU62kqWc
        ZxOUKphh1WwPJK6vn8e9wj9O+BnR6AJGXktp/IntRplwBLOsOHMRUI873aWYZB18waklDI0EvSReQ
        nGGVmqzQIZvr84UeRCvfLldvwI/dLn5ujQaVWIYeEkBZzzdja4gQQ4Rh+hEjFiUyYcBbkOvqApH0L
        FGrC0bWYQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf79-0006DD-Jn
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:09:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 27/34] xfs: devirtualize ->data_entry_tag_p
Date:   Fri,  1 Nov 2019 15:07:12 -0700
Message-Id: <20191101220719.29100-28-hch@lst.de>
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

Replace the ->data_entry_tag_p dir ops method with a directly called
xfs_dir2_data_entry_tag_p helper that takes care of the differences
between the directory format with and without the file type field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_format.c  | 22 ----------------------
 fs/xfs/libxfs/xfs_dir2.h       |  1 -
 fs/xfs/libxfs/xfs_dir2_block.c |  8 ++++----
 fs/xfs/libxfs/xfs_dir2_data.c  | 21 ++++++++++++++++++---
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/scrub/dir.c             |  2 +-
 8 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index bbff0e7822b8..9c247223326f 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -89,25 +89,6 @@ xfs_dir3_data_put_ftype(
 	dep->name[dep->namelen] = type;
 }
 
-/*
- * Pointer to an entry's tag word.
- */
-static __be16 *
-xfs_dir2_data_entry_tag_p(
-	struct xfs_dir2_data_entry *dep)
-{
-	return (__be16 *)((char *)dep +
-		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
-}
-
-static __be16 *
-xfs_dir3_data_entry_tag_p(
-	struct xfs_dir2_data_entry *dep)
-{
-	return (__be16 *)((char *)dep +
-		XFS_DIR3_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
-}
-
 static struct xfs_dir2_data_free *
 xfs_dir2_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 {
@@ -123,7 +104,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
-	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
 	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
@@ -138,7 +118,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
-	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir2_data_bestfree_p,
 
 	.data_dot_offset = sizeof(struct xfs_dir2_data_hdr),
@@ -153,7 +132,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
-	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
 	.data_bestfree_p = xfs_dir3_data_bestfree_p,
 
 	.data_dot_offset = sizeof(struct xfs_dir3_data_hdr),
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 3fb2c514437a..8397e35d6b82 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -35,7 +35,6 @@ struct xfs_dir_ops {
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
 				uint8_t ftype);
-	__be16 * (*data_entry_tag_p)(struct xfs_dir2_data_entry *dep);
 	struct xfs_dir2_data_free *
 		(*data_bestfree_p)(struct xfs_dir2_data_hdr *hdr);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 709423199369..4230ea945bc4 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -542,7 +542,7 @@ xfs_dir2_block_addname(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
-	tagp = dp->d_ops->data_entry_tag_p(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
@@ -1154,7 +1154,7 @@ xfs_dir2_sf_to_block(
 	dep->namelen = 1;
 	dep->name[0] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
-	tagp = dp->d_ops->data_entry_tag_p(dep);
+	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
@@ -1168,7 +1168,7 @@ xfs_dir2_sf_to_block(
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
 	dp->d_ops->data_put_ftype(dep, XFS_DIR3_FT_DIR);
-	tagp = dp->d_ops->data_entry_tag_p(dep);
+	tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
@@ -1219,7 +1219,7 @@ xfs_dir2_sf_to_block(
 		dep->namelen = sfep->namelen;
 		dp->d_ops->data_put_ftype(dep, xfs_dir2_sf_get_ftype(mp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
-		tagp = dp->d_ops->data_entry_tag_p(dep);
+		tagp = xfs_dir2_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 		xfs_dir2_data_log_entry(args, bp, dep);
 		name.name = sfep->name;
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 7e3d35f0cdb5..750e95997d8c 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -17,12 +17,25 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_dir2_priv.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
 		struct xfs_dir2_data_unused *dup,
 		struct xfs_dir2_data_free **bf_ent);
 
+/*
+ * Pointer to an entry's tag word.
+ */
+__be16 *
+xfs_dir2_data_entry_tag_p(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_data_entry	*dep)
+{
+	return (__be16 *)((char *)dep +
+		xfs_dir2_data_entsize(mp, dep->namelen) - sizeof(__be16));
+}
+
 /*
  * Check the consistency of the data block.
  * The input can also be a block-format directory.
@@ -175,7 +188,7 @@ __xfs_dir3_data_check(
 			return __this_address;
 		if (endp < p + xfs_dir2_data_entsize(mp, dep->namelen))
 			return __this_address;
-		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) !=
+		if (be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp, dep)) !=
 		    (char *)dep - (char *)hdr)
 			return __this_address;
 		if (ops->data_get_ftype(dep) >= XFS_DIR3_FT_MAX)
@@ -609,7 +622,8 @@ xfs_dir2_data_freescan_int(
 		else {
 			dep = (xfs_dir2_data_entry_t *)p;
 			ASSERT((char *)dep - (char *)hdr ==
-			       be16_to_cpu(*ops->data_entry_tag_p(dep)));
+			       be16_to_cpu(*xfs_dir2_data_entry_tag_p(mp,
+					   dep)));
 			p += xfs_dir2_data_entsize(mp, dep->namelen);
 		}
 	}
@@ -709,6 +723,7 @@ xfs_dir2_data_log_entry(
 	struct xfs_buf		*bp,
 	xfs_dir2_data_entry_t	*dep)		/* data entry pointer */
 {
+	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dir2_data_hdr *hdr = bp->b_addr;
 
 	ASSERT(hdr->magic == cpu_to_be32(XFS_DIR2_DATA_MAGIC) ||
@@ -717,7 +732,7 @@ xfs_dir2_data_log_entry(
 	       hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
 
 	xfs_trans_log_buf(args->trans, bp, (uint)((char *)dep - (char *)hdr),
-		(uint)((char *)(args->dp->d_ops->data_entry_tag_p(dep) + 1) -
+		(uint)((char *)(xfs_dir2_data_entry_tag_p(mp, dep) + 1) -
 		       (char *)hdr - 1));
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 2f7eda3008a6..3a65b7c8aa83 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -866,7 +866,7 @@ xfs_dir2_leaf_addname(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
-	tagp = dp->d_ops->data_entry_tag_p(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index d08a11121dee..7534e35d8aa2 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1966,7 +1966,7 @@ xfs_dir2_node_addname_int(
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
 	dp->d_ops->data_put_ftype(dep, args->filetype);
-	tagp = dp->d_ops->data_entry_tag_p(dep);
+	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 585b7b42c204..750344407f27 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -48,6 +48,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 
 /* xfs_dir2_data.c */
 int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
+__be16 *xfs_dir2_data_entry_tag_p(struct xfs_mount *mp,
+		struct xfs_dir2_data_entry *dep);
 
 #ifdef DEBUG
 extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5ddd95f12b85..d7ac9423ed86 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -269,7 +269,7 @@ xchk_dir_rec(
 	/* Retrieve the entry, sanity check it, and compare hashes. */
 	ino = be64_to_cpu(dent->inumber);
 	hash = be32_to_cpu(ent->hashval);
-	tag = be16_to_cpup(dp->d_ops->data_entry_tag_p(dent));
+	tag = be16_to_cpup(xfs_dir2_data_entry_tag_p(mp, dent));
 	if (!xfs_verify_dir_ino(mp, ino) || tag != off)
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 	if (dent->namelen == 0) {
-- 
2.20.1

