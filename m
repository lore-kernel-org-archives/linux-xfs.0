Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D301A0BF1
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636861; cv=none; b=tkjY3Qpc3xamfQ/FVd+5RjAAKfc2a+LoUW146hHWut9T4KqFKy9/EcmGTT6EX3vkr11No0RCO7TpAaFUo4+uoojlIGx6EjKgmTcNnefaV7dE/ICjO25t5tpeerQXCUB5yf6l0mLPg42MiuPklp0rr1K1Yx4JqvQ52lYVjXalPK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636861; c=relaxed/simple;
	bh=ZUdLw7o4FRGopF8Nar1v+WZzXiBfyMORl99rS/t5lsk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2b9cVRrN4jAoJdtd+DtbO1YPrOp5rkvhxaqhcLb5QBomAkFVm1MH8mslEHr20GHsq/kqfN9wptfrtgpEERb5Z8kfFkjyWyAa2GYgk8uEbkmsJypDvM8nn8gHQpUsTBTP0UwyRapH3Erw7/1obrmbgkQFN2n3QZwsyMgnqBwbBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rncIGUJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rncIGUJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF78EC4CECE;
	Thu, 19 Dec 2024 19:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636860;
	bh=ZUdLw7o4FRGopF8Nar1v+WZzXiBfyMORl99rS/t5lsk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rncIGUJrErVPMUrzZX69cE6EE59RlBTrOsx9n1r2kWScvK5UUiu1Squrc43TASTLn
	 05OKk60puAlO2/vtqPE73OzSLD1hEPnoeuZzSjaVazMEfxppUCR3LT11E7mgS6L9IU
	 1m2ubsl5tX2xHNRBAk3G+ZFiNZa2Tmp7zV0FrDjuDZgV6dcRDF25gWAEV4kwkXSKy/
	 fAJ9iRgWcVzE2RKaQPmakFciGft6Dnwv8WGv4LhQcDEv7K3DhpIgcuQT5gDwyCLFsv
	 WopZnaWFc9VfCiIWPUB6grLMChtCbGM8GvU5lh1WsjwKY9pMoH+bu0p2D/7638h+sI
	 XF6coXsnhfLbQ==
Date: Thu, 19 Dec 2024 11:34:20 -0800
Subject: [PATCH 05/43] xfs: add realtime refcount btree operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581063.1572761.13161907660221555602.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Implement the generic btree operations needed to manipulate rtrefcount
btree blocks. This is different from the regular refcountbt in that we
allocate space from the filesystem at large, and are neither constrained
to the free space nor any particular AG.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  148 ++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index d07d3b1e78f730..e30af941581651 100644
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
@@ -45,6 +46,106 @@ xfs_rtrefcountbt_dup_cursor(
 	return xfs_rtrefcountbt_init_cursor(cur->bc_tp, to_rtg(cur->bc_group));
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
@@ -111,6 +212,40 @@ const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
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
 	.name			= "rtrefcount",
 	.type			= XFS_BTREE_TYPE_INODE,
@@ -124,7 +259,20 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrefcbt_2),
 
 	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
+	.alloc_block		= xfs_btree_alloc_metafile_block,
+	.free_block		= xfs_btree_free_metafile_block,
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
 
 /* Allocate a new rt refcount btree cursor. */

