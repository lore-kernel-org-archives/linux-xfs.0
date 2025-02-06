Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6922654C
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881840; cv=none; b=KVuR+s7IIivKxy+7Xv8QZGIp7RKLYmFC9SDq26wjqhFuNwyQVgZF3Bt3k+NyveOQUM+60ENtNMaszwvr+f3KENvbOo9WlPd47rViRwCPpwkdMS5XxCpPUrPIoLarZW7aRvmlmzZYWHgc5Bu2oKW1kHYSlgjVB2jRwk5ZQdGYdzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881840; c=relaxed/simple;
	bh=/khF7E3BaF+euyEuz0MOJ3lEjUN7yE5DNLXLaZtrTkY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PE+MFjDBLC+qDIP8rifi+aE6dMliCCf6mqLKHynmAFdElWhfkxPzSTr+jlkM2291WBifWPIQbGqBaoWpceV7m0CYNYFJ1jYkTLJBLTbbEUL6wUm1CdZanOcibffWHRkk5/xmjpgynQo6YK+j5Ac6iLKCnhigeQ/eX4dogWedDD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nM9FXux4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nM9FXux4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD4BC4CEDD;
	Thu,  6 Feb 2025 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881840;
	bh=/khF7E3BaF+euyEuz0MOJ3lEjUN7yE5DNLXLaZtrTkY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nM9FXux4QuKxtNegjZaRBnicAAc7uIoGPOED+26D5h4Co2DFp3ohNj1HSBM+6PJ/0
	 cJS4H31YaieYLqv4wzazVj0neOqDWYnnZNjRUj9PXLxGER7aPCW3YFXww3mL1ETma1
	 MaBjQY92h8vk4f8HZG1LsByZe07CtkCbgxZxZMsjTOfRGgyT2xskCE48BkTGKo2nuG
	 RTXflxu1ZTMRzb/XsAQ1HsZSEhR6OcvpJ7yn6valIPqhKlWIqASjcS0KwRSiVCt2IB
	 k5AySrOQJYnZ/fcgBiP/bkH9HWCCVvE0unlyLzDorlSVZNVGStg2shrhbTn9AJf/ZY
	 Nsj9hKbN3WyHw==
Date: Thu, 06 Feb 2025 14:43:59 -0800
Subject: [PATCH 34/56] xfs: add realtime refcount btree operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087313.2739176.13095092153401343169.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 1a6f88ea538db9b3d8aef86112894e7e6d098287

Implement the generic btree operations needed to manipulate rtrefcount
btree blocks. This is different from the regular refcountbt in that we
allocate space from the filesystem at large, and are neither constrained
to the free space nor any particular AG.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtrefcount_btree.c |  148 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index d92ef06b04a73e..ea05b1a48eab62 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -19,6 +19,7 @@
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"
 #include "xfs_rtgroup.h"
@@ -43,6 +44,106 @@ xfs_rtrefcountbt_dup_cursor(
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
@@ -109,6 +210,40 @@ const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
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
@@ -122,7 +257,20 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
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

