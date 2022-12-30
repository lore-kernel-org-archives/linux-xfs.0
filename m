Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42708C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiLaBti (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236079AbiLaBth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:49:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92FA1DDF7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 476ED61CD0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4177C433D2;
        Sat, 31 Dec 2022 01:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451375;
        bh=tD9NvOuuGzM0XArO54GRX658vM4eNvAJId3HZwdsLHg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VZVohukBt3bqgmEvCY7Rt22vUG23sgg7kTTPJctQ8/HBRubyAXTpXAURwPPG84PtO
         V5rkt6jEBuOV0LUB3UCx+QlFFKDNe5KhdyY2Td7NOvsSe+eenIp2cr+P9Y/TzeaEyC
         JCs5/MEMo7bxBncuf3fvhMxSToRd1BVXY9VRH8Ukd/px5WV2hYe2axzrPbUUDpuhpe
         7+PAR7U8uLOmlTtezgmA4136OS7kK/fqI43cViBYBx4FcQNuiTicMrl0SGZVPxg00C
         YB8+W9gzfzPR8WFOpByl9Q4+dPd/2DoMs1vVmXb4xbDwXvRXqo6WrUz6/jnj8jyIXA
         /6GuTX/+1GXYg==
Subject: [PATCH 06/42] xfs: add realtime refcount btree operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870983.717073.6818978594509030568.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Implement the generic btree operations needed to manipulate rtrefcount
btree blocks. This is different from the regular refcountbt in that we
allocate space from the filesystem at large, and are neither constrained
to the free space nor any particular AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  148 ++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index dd8e628b068b..bdefc4f5939d 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_error.h"
@@ -53,6 +54,106 @@ xfs_rtrefcountbt_dup_cursor(
 	return new;
 }
 
+STATIC int
+xfs_rtrefcountbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+
+		return xfs_rtrefcountbt_maxrecs(cur->bc_mp, ifp->if_broot_bytes,
+				level == 0) / 2;
+	}
+
+	return cur->bc_mp->m_rtrefc_mnr[level != 0];
+}
+
+STATIC int
+xfs_rtrefcountbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level == cur->bc_nlevels - 1) {
+		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+
+		return xfs_rtrefcountbt_maxrecs(cur->bc_mp, ifp->if_broot_bytes,
+				level == 0);
+	}
+
+	return cur->bc_mp->m_rtrefc_mxr[level != 0];
+}
+
+STATIC void
+xfs_rtrefcountbt_init_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	key->refc.rc_startblock = rec->refc.rc_startblock;
+}
+
+STATIC void
+xfs_rtrefcountbt_init_high_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	__u32				x;
+
+	x = be32_to_cpu(rec->refc.rc_startblock);
+	x += be32_to_cpu(rec->refc.rc_blockcount) - 1;
+	key->refc.rc_startblock = cpu_to_be32(x);
+}
+
+STATIC void
+xfs_rtrefcountbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	const struct xfs_refcount_irec *irec = &cur->bc_rec.rc;
+	uint32_t		start;
+
+	start = xfs_refcount_encode_startblock(irec->rc_startblock,
+			irec->rc_domain);
+	rec->refc.rc_startblock = cpu_to_be32(start);
+	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
+	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
+}
+
+STATIC void
+xfs_rtrefcountbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	ptr->l = 0;
+}
+
+STATIC int64_t
+xfs_rtrefcountbt_key_diff(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
+{
+	const struct xfs_refcount_key	*kp = &key->refc;
+	const struct xfs_refcount_irec	*irec = &cur->bc_rec.rc;
+	uint32_t			start;
+
+	start = xfs_refcount_encode_startblock(irec->rc_startblock,
+			irec->rc_domain);
+	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
+}
+
+STATIC int64_t
+xfs_rtrefcountbt_diff_two_keys(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
+{
+	ASSERT(!mask || mask->refc.rc_startblock);
+
+	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
+			be32_to_cpu(k2->refc.rc_startblock);
+}
+
 static xfs_failaddr_t
 xfs_rtrefcountbt_verify(
 	struct xfs_buf		*bp)
@@ -119,6 +220,40 @@ const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
 	.verify_struct		= xfs_rtrefcountbt_verify,
 };
 
+STATIC int
+xfs_rtrefcountbt_keys_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->refc.rc_startblock) <
+	       be32_to_cpu(k2->refc.rc_startblock);
+}
+
+STATIC int
+xfs_rtrefcountbt_recs_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
+{
+	return  be32_to_cpu(r1->refc.rc_startblock) +
+		be32_to_cpu(r1->refc.rc_blockcount) <=
+		be32_to_cpu(r2->refc.rc_startblock);
+}
+
+STATIC enum xbtree_key_contig
+xfs_rtrefcountbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	ASSERT(!mask || mask->refc.rc_startblock);
+
+	return xbtree_key_contig(be32_to_cpu(key1->refc.rc_startblock),
+				 be32_to_cpu(key2->refc.rc_startblock));
+}
+
 const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
@@ -126,7 +261,20 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 				  XFS_BTREE_CRC_BLOCKS | XFS_BTREE_IROOT_RECORDS,
 
 	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
+	.alloc_block		= xfs_btree_alloc_imeta_block,
+	.free_block		= xfs_btree_free_imeta_block,
+	.get_minrecs		= xfs_rtrefcountbt_get_minrecs,
+	.get_maxrecs		= xfs_rtrefcountbt_get_maxrecs,
+	.init_key_from_rec	= xfs_rtrefcountbt_init_key_from_rec,
+	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
+	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_rtrefcountbt_init_ptr_from_cur,
+	.key_diff		= xfs_rtrefcountbt_key_diff,
 	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
+	.diff_two_keys		= xfs_rtrefcountbt_diff_two_keys,
+	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
+	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
+	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
 };
 
 /* Initialize a new rt refcount btree cursor. */

