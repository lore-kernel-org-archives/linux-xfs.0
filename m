Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7837ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LqgcTJyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED9CC433C8;
	Mon,  1 Jan 2024 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068847;
	bh=PDTrrZn8C5Qy2f9CAEAz3RQlYvLmUus8C6OHNqXRC6g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LqgcTJydXayEAedV8rWz4FAiv8K4/gFymPi6B3SwxPVyFevGD24d4vi2JqUXYHcrH
	 OFxMWH9jhoerXI0hyHWRCclI3T6jcqG3tPCgXAmcT3J5vPHRJ276Q8eNCHKypNLHVS
	 ad8fG7GwvYlWuOjM+EIcib9VSHF2Hmz2FBIirLs4wTE8wpMJvm6M50KOWatQOsv207
	 WvVErgtGyOw9ROfM6jaMYe1WimzDG2rOzYXZ9OQ+kkkraCZ8a06SSVNGqa17LHX/Dr
	 mmehoN6ucCxvd4IQ5mSLnujLddOgUxKh5WviAoXCt6P3tAY4/d6oB/yYSZ4buH5sbM
	 u+uGLHqVwqCcA==
Date: Sun, 31 Dec 2023 16:27:27 +9900
Subject: [PATCH 05/42] xfs: add realtime refcount btree operations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017192.1817107.14834630588218589936.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rtrefcount_btree.c |  148 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 148 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index e0db4cbf34c..fb4944d570f 100644
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
@@ -51,6 +52,106 @@ xfs_rtrefcountbt_dup_cursor(
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
@@ -117,6 +218,40 @@ const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
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
@@ -125,7 +260,20 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
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

