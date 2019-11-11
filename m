Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8E6C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A0D206C3
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 18:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dx1aj6s0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfKKSET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Nov 2019 13:04:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKSET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Nov 2019 13:04:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wNrw6goTmNXmwm5ifjvmxbdF/GFd2rdqQ6oZ+kkh2qA=; b=dx1aj6s0HUZq8BfJ4SWaF6DnZ
        iEagYiOwAWsLoidUTctgpX9+NZSOyCet+Vzpig/zIknp+f+JkfdlBm1wsBKtmiNU2AjY08wiVK3bD
        dgi27veol0UVQqQZvvuox+Mve9kgXn6bSMOygx6XI22d6/RxJJZPsewdYuoGRCYWCdpYxUqQUT2uE
        5ZYgYVZbP/9sDhZr1h6sHNDrqfxamTyUYYm2LXTiaLXRXQz1sS/fMdrnyOY1IqsrdIbqVkKWxE7WE
        DbIAXYlfS8n4y9WpjRd8UIvV+wnZ/JfkrIVawGhoZ3R33seqx5sfBnU3SThCVuh71HBFev9mRUAjQ
        kB9XXP0bw==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iUE30-0004Qc-8O
        for linux-xfs@vger.kernel.org; Mon, 11 Nov 2019 18:04:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: devirtualize ->m_dirnameops
Date:   Mon, 11 Nov 2019 19:04:15 +0100
Message-Id: <20191111180415.22975-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of causing a relatively expensive indirect call for each
hashing and comparism of a file name in a directory just use an
inline function and a simple branch on the ASCII CI bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c   | 14 +-------------
 fs/xfs/libxfs/xfs_da_btree.h   | 11 -----------
 fs/xfs/libxfs/xfs_dir2.c       | 33 +++++++++++----------------------
 fs/xfs/libxfs/xfs_dir2_block.c |  5 ++---
 fs/xfs/libxfs/xfs_dir2_data.c  |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |  2 +-
 fs/xfs/libxfs/xfs_dir2_priv.h  | 24 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2_sf.c    |  3 +--
 fs/xfs/xfs_mount.h             |  2 --
 10 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 46b1c3fb305c..bbe883f04bda 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -12,9 +12,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
-#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_attr_leaf.h"
@@ -2098,18 +2098,6 @@ xfs_da_compname(
 					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
 }
 
-static xfs_dahash_t
-xfs_default_hashname(
-	struct xfs_name	*name)
-{
-	return xfs_da_hashname(name->name, name->len);
-}
-
-const struct xfs_nameops xfs_default_nameops = {
-	.hashname	= xfs_default_hashname,
-	.compname	= xfs_da_compname
-};
-
 int
 xfs_da_grow_inode_int(
 	struct xfs_da_args	*args,
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 5af4df71e92b..ed3b558a9c1a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -158,16 +158,6 @@ struct xfs_da3_icnode_hdr {
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)), \
 		(uint)(XFS_DA_LOGOFF(BASE, ADDR)+(SIZE)-1)
 
-/*
- * Name ops for directory and/or attr name operations
- */
-struct xfs_nameops {
-	xfs_dahash_t	(*hashname)(struct xfs_name *);
-	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
-					const unsigned char *, int);
-};
-
-
 /*========================================================================
  * Function prototypes.
  *========================================================================*/
@@ -234,6 +224,5 @@ void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 
 extern struct kmem_zone *xfs_da_state_zone;
-extern const struct xfs_nameops xfs_default_nameops;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 624c05e77ab4..05182f2ebef4 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -52,7 +52,7 @@ xfs_mode_to_ftype(
  * ASCII case-insensitive (ie. A-Z) support for directories that was
  * used in IRIX.
  */
-STATIC xfs_dahash_t
+xfs_dahash_t
 xfs_ascii_ci_hashname(
 	struct xfs_name	*name)
 {
@@ -65,14 +65,14 @@ xfs_ascii_ci_hashname(
 	return hash;
 }
 
-STATIC enum xfs_dacmp
+enum xfs_dacmp
 xfs_ascii_ci_compname(
-	struct xfs_da_args *args,
-	const unsigned char *name,
-	int		len)
+	struct xfs_da_args	*args,
+	const unsigned char	*name,
+	int			len)
 {
-	enum xfs_dacmp	result;
-	int		i;
+	enum xfs_dacmp		result;
+	int			i;
 
 	if (args->namelen != len)
 		return XFS_CMP_DIFFERENT;
@@ -89,11 +89,6 @@ xfs_ascii_ci_compname(
 	return result;
 }
 
-static const struct xfs_nameops xfs_ascii_ci_nameops = {
-	.hashname	= xfs_ascii_ci_hashname,
-	.compname	= xfs_ascii_ci_compname,
-};
-
 int
 xfs_da_mount(
 	struct xfs_mount	*mp)
@@ -163,12 +158,6 @@ xfs_da_mount(
 	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
 				(uint)sizeof(xfs_da_node_entry_t);
 	dageo->magicpct = (dageo->blksize * 37) / 100;
-
-	if (xfs_sb_version_hasasciici(&mp->m_sb))
-		mp->m_dirnameops = &xfs_ascii_ci_nameops;
-	else
-		mp->m_dirnameops = &xfs_default_nameops;
-
 	return 0;
 }
 
@@ -279,7 +268,7 @@ xfs_dir_createname(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
 	args->inumber = inum;
 	args->dp = dp;
 	args->total = total;
@@ -375,7 +364,7 @@ xfs_dir_lookup(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
 	args->dp = dp;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
@@ -447,7 +436,7 @@ xfs_dir_removename(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
 	args->inumber = ino;
 	args->dp = dp;
 	args->total = total;
@@ -508,7 +497,7 @@ xfs_dir_replace(
 	args->name = name->name;
 	args->namelen = name->len;
 	args->filetype = name->type;
-	args->hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args->hashval = xfs_dir2_hashname(dp->i_mount, name);
 	args->inumber = inum;
 	args->dp = dp;
 	args->total = total;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 358151ddfa75..f9d83205659e 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -718,7 +718,7 @@ xfs_dir2_block_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			*bpp = bp;
@@ -1218,8 +1218,7 @@ xfs_dir2_sf_to_block(
 		xfs_dir2_data_log_entry(args, bp, dep);
 		name.name = sfep->name;
 		name.len = sfep->namelen;
-		blp[2 + i].hashval =
-			cpu_to_be32(mp->m_dirnameops->hashname(&name));
+		blp[2 + i].hashval = cpu_to_be32(xfs_dir2_hashname(mp, &name));
 		blp[2 + i].address =
 			cpu_to_be32(xfs_dir2_byte_to_dataptr(newoffset));
 		offset = (int)((char *)(tagp + 1) - (char *)hdr);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 9e471a28b6c6..11b1f3021e66 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -236,7 +236,7 @@ __xfs_dir3_data_check(
 						((char *)dep - (char *)hdr));
 			name.name = dep->name;
 			name.len = dep->namelen;
-			hash = mp->m_dirnameops->hashname(&name);
+			hash = xfs_dir2_hashname(mp, &name);
 			for (i = 0; i < be32_to_cpu(btp->count); i++) {
 				if (be32_to_cpu(lep[i].address) == addr &&
 				    be32_to_cpu(lep[i].hashval) == hash)
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index e2e4b2c6d6c2..73edd96ce0ac 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1288,7 +1288,7 @@ xfs_dir2_leaf_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			*indexp = index;
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 5f30a1953a52..f0f67b7eb171 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -876,7 +876,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		 * EEXIST immediately. If it's the first case-insensitive
 		 * match, store the block & inode number and continue looking.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = xfs_dir2_compname(args, dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			/* If there is a CI match block, drop it */
 			if (args->cmpresult != XFS_CMP_DIFFERENT &&
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index a22222df4bf2..eb6af7daf803 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -40,6 +40,9 @@ struct xfs_dir3_icfree_hdr {
 };
 
 /* xfs_dir2.c */
+xfs_dahash_t xfs_ascii_ci_hashname(struct xfs_name *name);
+enum xfs_dacmp xfs_ascii_ci_compname(struct xfs_da_args *args,
+		const unsigned char *name, int len);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
@@ -191,4 +194,25 @@ xfs_dir2_data_entsize(
 	return round_up(len, XFS_DIR2_DATA_ALIGN);
 }
 
+static inline xfs_dahash_t
+xfs_dir2_hashname(
+	struct xfs_mount	*mp,
+	struct xfs_name		*name)
+{
+	if (unlikely(xfs_sb_version_hasasciici(&mp->m_sb)))
+		return xfs_ascii_ci_hashname(name);
+	return xfs_da_hashname(name->name, name->len);
+}
+
+static inline enum xfs_dacmp
+xfs_dir2_compname(
+	struct xfs_da_args	*args,
+	const unsigned char	*name,
+	int			len)
+{
+	if (unlikely(xfs_sb_version_hasasciici(&args->dp->i_mount->m_sb)))
+		return xfs_ascii_ci_compname(args, name, len);
+	return xfs_da_compname(args, name, len);
+}
+
 #endif /* __XFS_DIR2_PRIV_H__ */
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index db1a82972d9e..41eb8a676bf3 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -914,8 +914,7 @@ xfs_dir2_sf_lookup(
 		 * number. If it's the first case-insensitive match, store the
 		 * inode number and continue looking for an exact match.
 		 */
-		cmp = dp->i_mount->m_dirnameops->compname(args, sfep->name,
-								sfep->namelen);
+		cmp = xfs_dir2_compname(args, sfep->name, sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir2_sf_get_ino(mp, sfp, sfep);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 43145a4ab690..247c2b15a22c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -9,7 +9,6 @@
 struct xlog;
 struct xfs_inode;
 struct xfs_mru_cache;
-struct xfs_nameops;
 struct xfs_ail;
 struct xfs_quotainfo;
 struct xfs_da_geometry;
@@ -154,7 +153,6 @@ typedef struct xfs_mount {
 	int			m_dalign;	/* stripe unit */
 	int			m_swidth;	/* stripe width */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
-	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-- 
2.20.1

