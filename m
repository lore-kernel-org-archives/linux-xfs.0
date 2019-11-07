Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4382EC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05BC8206DF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 18:25:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kBh3VocQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfKGSZx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:25:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbfKGSZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rUfUVQ8HLzrBK8/Ui8fYifxaFBKF7I1km1Y20EH6llU=; b=kBh3VocQlQzlCc1O0zfbL3A7PZ
        paW0GKtDHwTVs+CkOhkK8X5RZmg6cl7BZKG7uOyrTZ+Ic9rboMLdU54gCmPZ2CSn8u8q/ti//VthV
        tpMiAQLyt4gqhEb2Vdk2b5KEZNDr9JTdETRYZRVGkHE6T1510+TNSZNBZYVGdmxjXfQYgs1DTItOr
        ldx4Z91VRcpXPhBTQkIhuDmoTmKwrSkHSnike7RZLpWV3LwvQ9j5rqW+0ihNi4gaJjxNsRgWarSBP
        QyR5X2NGBkOqMEmg6Zgrll/WKjy/3tXLOjnLb63OQq1GzZQTFROiKqV4uzP7RrOdudu6zFwEqibHw
        z9DMBp8Q==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmTg-0004TD-Ra; Thu, 07 Nov 2019 18:25:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 38/46] xfs: devirtualize ->data_entsize
Date:   Thu,  7 Nov 2019 19:24:02 +0100
Message-Id: <20191107182410.12660-39-hch@lst.de>
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

Replace the ->data_entsize dir ops method with a directly called
xfs_dir2_data_entsize helper that takes care of the differences between
the directory format with and without the file type field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c  | 22 ++++++++--------------
 fs/xfs/libxfs/xfs_dir2.h       |  3 +--
 fs/xfs/libxfs/xfs_dir2_block.c |  9 +++++----
 fs/xfs/libxfs/xfs_dir2_data.c  | 14 +++++++-------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  5 +++--
 fs/xfs/libxfs/xfs_dir2_node.c  |  7 ++++---
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c    | 14 +++++++-------
 fs/xfs/scrub/dir.c             |  4 ++--
 fs/xfs/xfs_dir2_readdir.c      | 11 ++++++-----
 10 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index e70cc54d99e1..e4498bd0d6c0 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -41,18 +41,15 @@
 		 sizeof(xfs_dir2_data_off_t) + sizeof(uint8_t)),	\
 		XFS_DIR2_DATA_ALIGN)
 
-static int
+int
 xfs_dir2_data_entsize(
+	struct xfs_mount	*mp,
 	int			n)
 {
-	return XFS_DIR2_DATA_ENTSIZE(n);
-}
-
-static int
-xfs_dir3_data_entsize(
-	int			n)
-{
-	return XFS_DIR3_DATA_ENTSIZE(n);
+	if (xfs_sb_version_hasftype(&mp->m_sb))
+		return XFS_DIR3_DATA_ENTSIZE(n);
+	else
+		return XFS_DIR2_DATA_ENTSIZE(n);
 }
 
 static uint8_t
@@ -100,7 +97,7 @@ xfs_dir2_data_entry_tag_p(
 	struct xfs_dir2_data_entry *dep)
 {
 	return (__be16 *)((char *)dep +
-		xfs_dir2_data_entsize(dep->namelen) - sizeof(__be16));
+		XFS_DIR2_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
 }
 
 static __be16 *
@@ -108,7 +105,7 @@ xfs_dir3_data_entry_tag_p(
 	struct xfs_dir2_data_entry *dep)
 {
 	return (__be16 *)((char *)dep +
-		xfs_dir3_data_entsize(dep->namelen) - sizeof(__be16));
+		XFS_DIR3_DATA_ENTSIZE(dep->namelen) - sizeof(__be16));
 }
 
 static struct xfs_dir2_data_free *
@@ -124,7 +121,6 @@ xfs_dir3_data_bestfree_p(struct xfs_dir2_data_hdr *hdr)
 }
 
 static const struct xfs_dir_ops xfs_dir2_ops = {
-	.data_entsize = xfs_dir2_data_entsize,
 	.data_get_ftype = xfs_dir2_data_get_ftype,
 	.data_put_ftype = xfs_dir2_data_put_ftype,
 	.data_entry_tag_p = xfs_dir2_data_entry_tag_p,
@@ -137,7 +133,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
-	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
@@ -150,7 +145,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 };
 
 static const struct xfs_dir_ops xfs_dir3_ops = {
-	.data_entsize = xfs_dir3_data_entsize,
 	.data_get_ftype = xfs_dir3_data_get_ftype,
 	.data_put_ftype = xfs_dir3_data_put_ftype,
 	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 3a4b98d4973d..f717b1cdb208 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -32,7 +32,6 @@ extern unsigned char xfs_mode_to_ftype(int mode);
  * directory operations vector for encode/decode routines
  */
 struct xfs_dir_ops {
-	int	(*data_entsize)(int len);
 	uint8_t (*data_get_ftype)(struct xfs_dir2_data_entry *dep);
 	void	(*data_put_ftype)(struct xfs_dir2_data_entry *dep,
 				uint8_t ftype);
@@ -85,7 +84,7 @@ extern int xfs_dir2_isleaf(struct xfs_da_args *args, int *r);
 extern int xfs_dir2_shrink_inode(struct xfs_da_args *args, xfs_dir2_db_t db,
 				struct xfs_buf *bp);
 
-extern void xfs_dir2_data_freescan_int(struct xfs_da_geometry *geo,
+extern void xfs_dir2_data_freescan_int(struct xfs_mount *mp,
 		const struct xfs_dir_ops *ops,
 		struct xfs_dir2_data_hdr *hdr, int *loghead);
 extern void xfs_dir2_data_freescan(struct xfs_inode *dp,
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 9061f378d52a..a83fcf4ac35c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -355,7 +355,7 @@ xfs_dir2_block_addname(
 	if (error)
 		return error;
 
-	len = dp->d_ops->data_entsize(args->namelen);
+	len = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
 
 	/*
 	 * Set up pointers to parts of the block.
@@ -791,7 +791,8 @@ xfs_dir2_block_removename(
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(args, bp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
+		&needscan);
 	/*
 	 * Fix up the block tail.
 	 */
@@ -1149,7 +1150,7 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[0].hashval = cpu_to_be32(xfs_dir_hash_dot);
 	blp[0].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
-	offset += dp->d_ops->data_entsize(dep->namelen);
+	offset += xfs_dir2_data_entsize(mp, dep->namelen);
 
 	/*
 	 * Create entry for ..
@@ -1164,7 +1165,7 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_data_log_entry(args, bp, dep);
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(offset));
-	offset += dp->d_ops->data_entsize(dep->namelen);
+	offset += xfs_dir2_data_entsize(mp, dep->namelen);
 
 	/*
 	 * Loop over existing entries, stuff them in.
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index f5fa8b9187b0..830dfd9edfda 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -13,6 +13,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -179,7 +180,7 @@ __xfs_dir3_data_check(
 			return __this_address;
 		if (xfs_dir_ino_validate(mp, be64_to_cpu(dep->inumber)))
 			return __this_address;
-		if (offset + ops->data_entsize(dep->namelen) > end)
+		if (offset + xfs_dir2_data_entsize(mp, dep->namelen) > end)
 			return __this_address;
 		if (be16_to_cpu(*ops->data_entry_tag_p(dep)) != offset)
 			return __this_address;
@@ -203,7 +204,7 @@ __xfs_dir3_data_check(
 			if (i >= be32_to_cpu(btp->count))
 				return __this_address;
 		}
-		offset += ops->data_entsize(dep->namelen);
+		offset += xfs_dir2_data_entsize(mp, dep->namelen);
 	}
 	/*
 	 * Need to have seen all the entries and all the bestfree slots.
@@ -567,7 +568,7 @@ xfs_dir2_data_freeremove(
  */
 void
 xfs_dir2_data_freescan_int(
-	struct xfs_da_geometry		*geo,
+	struct xfs_mount		*mp,
 	const struct xfs_dir_ops	*ops,
 	struct xfs_dir2_data_hdr	*hdr,
 	int				*loghead)
@@ -588,7 +589,7 @@ xfs_dir2_data_freescan_int(
 	memset(bf, 0, sizeof(*bf) * XFS_DIR2_DATA_FD_COUNT);
 	*loghead = 1;
 
-	end = xfs_dir3_data_end_offset(geo, addr);
+	end = xfs_dir3_data_end_offset(mp->m_dir_geo, addr);
 	while (offset < end) {
 		struct xfs_dir2_data_unused	*dup = addr + offset;
 		struct xfs_dir2_data_entry	*dep = addr + offset;
@@ -608,7 +609,7 @@ xfs_dir2_data_freescan_int(
 		 * For active entries, check their tags and skip them.
 		 */
 		ASSERT(offset == be16_to_cpu(*ops->data_entry_tag_p(dep)));
-		offset += ops->data_entsize(dep->namelen);
+		offset += xfs_dir2_data_entsize(mp, dep->namelen);
 	}
 }
 
@@ -618,8 +619,7 @@ xfs_dir2_data_freescan(
 	struct xfs_dir2_data_hdr *hdr,
 	int			*loghead)
 {
-	return xfs_dir2_data_freescan_int(dp->i_mount->m_dir_geo, dp->d_ops,
-			hdr, loghead);
+	return xfs_dir2_data_freescan_int(dp->i_mount, dp->d_ops, hdr, loghead);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index bbbd7b96678a..dd7b4bd8ed61 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -660,7 +660,7 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = leafhdr.ents;
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
 
 	/*
 	 * See if there are any entries with the same hash value
@@ -1397,7 +1397,8 @@ xfs_dir2_leaf_removename(
 	 */
 	xfs_dir2_data_make_free(args, dbp,
 		(xfs_dir2_data_aoff_t)((char *)dep - (char *)hdr),
-		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
+		&needscan);
 	/*
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7b0de42c2c77..f07ac23a2e2f 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -666,7 +666,7 @@ xfs_dir2_leafn_lookup_for_addname(
 		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC) ||
 		       free->hdr.magic == cpu_to_be32(XFS_DIR3_FREE_MAGIC));
 	}
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = xfs_dir2_data_entsize(mp, args->namelen);
 	/*
 	 * Loop over leaf entries with the right hash value.
 	 */
@@ -1320,7 +1320,8 @@ xfs_dir2_leafn_remove(
 	longest = be16_to_cpu(bf[0].length);
 	needlog = needscan = 0;
 	xfs_dir2_data_make_free(args, dbp, off,
-		dp->d_ops->data_entsize(dep->namelen), &needlog, &needscan);
+		xfs_dir2_data_entsize(dp->i_mount, dep->namelen), &needlog,
+		&needscan);
 	/*
 	 * Rescan the data block freespaces for bestfree.
 	 * Log the data block header if needed.
@@ -1913,7 +1914,7 @@ xfs_dir2_node_addname_int(
 	int			needscan = 0;	/* need to rescan data frees */
 	__be16			*tagp;		/* data entry tag pointer */
 
-	length = dp->d_ops->data_entsize(args->namelen);
+	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
 	error = xfs_dir2_node_find_freeblk(args, fblk, &dbno, &fbp, &freehdr,
 					   &findex, length);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index b49f745f1bc3..c60b8663f754 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -57,6 +57,8 @@ extern int xfs_dir2_leaf_to_block(struct xfs_da_args *args,
 		struct xfs_buf *lbp, struct xfs_buf *dbp);
 
 /* xfs_dir2_data.c */
+int xfs_dir2_data_entsize(struct xfs_mount *mp, int n);
+
 #ifdef DEBUG
 extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 #else
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index bb6491a3c473..a41715c9b061 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -323,7 +323,7 @@ xfs_dir2_block_to_sf(
 
 			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 		}
-		offset += dp->d_ops->data_entsize(dep->namelen);
+		offset += xfs_dir2_data_entsize(mp, dep->namelen);
 	}
 	ASSERT((char *)sfep - (char *)sfp == size);
 
@@ -540,10 +540,10 @@ xfs_dir2_sf_addname_hard(
 	 */
 	for (offset = dp->d_ops->data_first_offset,
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
-	      add_datasize = dp->d_ops->data_entsize(args->namelen),
+	      add_datasize = xfs_dir2_data_entsize(mp, args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
 	     !eof;
-	     offset = new_offset + dp->d_ops->data_entsize(oldsfep->namelen),
+	     offset = new_offset + xfs_dir2_data_entsize(mp, oldsfep->namelen),
 	      oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep),
 	      eof = (char *)oldsfep == &buf[old_isize]) {
 		new_offset = xfs_dir2_sf_get_offset(oldsfep);
@@ -615,7 +615,7 @@ xfs_dir2_sf_addname_pick(
 	int			used;		/* data bytes used */
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	size = dp->d_ops->data_entsize(args->namelen);
+	size = xfs_dir2_data_entsize(mp, args->namelen);
 	offset = dp->d_ops->data_first_offset;
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
@@ -628,7 +628,7 @@ xfs_dir2_sf_addname_pick(
 		if (!holefit)
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
 		offset = xfs_dir2_sf_get_offset(sfep) +
-			 dp->d_ops->data_entsize(sfep->namelen);
+			 xfs_dir2_data_entsize(mp, sfep->namelen);
 		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
 	}
 	/*
@@ -693,7 +693,7 @@ xfs_dir2_sf_check(
 		i8count += ino > XFS_DIR2_MAX_SHORT_INUM;
 		offset =
 			xfs_dir2_sf_get_offset(sfep) +
-			dp->d_ops->data_entsize(sfep->namelen);
+			xfs_dir2_data_entsize(mp, sfep->namelen);
 		ASSERT(xfs_dir2_sf_get_ftype(mp, sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
@@ -793,7 +793,7 @@ xfs_dir2_sf_verify(
 			return __this_address;
 
 		offset = xfs_dir2_sf_get_offset(sfep) +
-				dops->data_entsize(sfep->namelen);
+				xfs_dir2_data_entsize(mp, sfep->namelen);
 
 		sfep = next_sfep;
 	}
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 7f03f0fb178a..11d1429a69e4 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -262,7 +262,7 @@ xchk_dir_rec(
 		}
 		if (dep == dent)
 			break;
-		offset += mp->m_dir_inode_ops->data_entsize(dep->namelen);
+		offset += xfs_dir2_data_entsize(mp, dep->namelen);
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
@@ -400,7 +400,7 @@ xchk_directory_data_bestfree(
 		if (dup->freetag != cpu_to_be16(XFS_DIR2_DATA_FREE_TAG)) {
 			struct xfs_dir2_data_entry *dep = bp->b_addr + offset;
 
-			newlen = d_ops->data_entsize(dep->namelen);
+			newlen = xfs_dir2_data_entsize(mp, dep->namelen);
 			if (newlen <= 0) {
 				xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 						lblk);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 6d229aa93d01..a52f0931b6af 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -78,7 +78,7 @@ xfs_dir2_sf_getdents(
 			dp->d_ops->data_entry_offset);
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			dp->d_ops->data_entry_offset +
-			dp->d_ops->data_entsize(sizeof(".") - 1));
+			xfs_dir2_data_entsize(mp, sizeof(".") - 1));
 
 	/*
 	 * Put . entry unless we're starting past it.
@@ -192,7 +192,7 @@ xfs_dir2_block_getdents(
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		offset += dp->d_ops->data_entsize(dep->namelen);
+		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
 
 		/*
 		 * The entry is before the desired starting point, skip it.
@@ -347,6 +347,7 @@ xfs_dir2_leaf_getdents(
 	size_t			bufsize)
 {
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp = NULL;	/* data block buffer */
 	xfs_dir2_data_hdr_t	*hdr;		/* data block header */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
@@ -424,8 +425,8 @@ xfs_dir2_leaf_getdents(
 						continue;
 					}
 					dep = bp->b_addr + offset;
-					length =
-					   dp->d_ops->data_entsize(dep->namelen);
+					length = xfs_dir2_data_entsize(mp,
+							dep->namelen);
 					offset += length;
 				}
 				/*
@@ -456,7 +457,7 @@ xfs_dir2_leaf_getdents(
 		}
 
 		dep = bp->b_addr + offset;
-		length = dp->d_ops->data_entsize(dep->namelen);
+		length = xfs_dir2_data_entsize(mp, dep->namelen);
 		filetype = dp->d_ops->data_get_ftype(dep);
 
 		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
-- 
2.20.1

