Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871100;
	b=wpPOXae0q4SCU1kFE+uM+drT9wDVgHLjtQI+Rsx8E0jX1buCABMkVtXuEjnXdxRzcDAS
	 5M0aJslAHEXq20JQnHA20YXwFjcenjP7bLrDEw0h+WxarSCbd2UhEvyFtuf2y9ZoNONjf
	 gPU/ZEpPKPHrSE/rNNo8hzNQfoo9A6m4g7yyIxzjCuiAXNyYu6+lEvEeCx+gex29JlPg+
	 y1DdXDvr+dr3C+iM++eXkrjBXoDr7xfAqWBTF0Qs63jGkmqzcgHDjYhNChRKPpojxcYPm
	 1AApjccNyJZFEjPoqnRmnrwHEqrnYLWwAFUrn5L0wWebBx5bLyRQwclAr6MJsI8zHTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=It8qELfxT2bUa+sKO+yvBp1jd+DjmMHxaUK/5IxP8xE=;
	b=JWM5EQnojN+pa/U4SB6c+UMPE2t/3VlJQ6bREr6KUx5VigleGaDHownRmie1/Kn6nEYU
	 PhSbjFwRGe7fSUD0TActcU7+gCaoKIovrcCfHlN2IBRxMGU0EFcVRXyFpvofp91QuMxcF
	 ko6paidb5+gjKGq1Wh3ddgiKgRB4DsheSouJd/vu/oep+iz3+rY1dM+8YeWzm+Rvki7ix
	 8uMlJ0w+QdBKQdGeOxYwZ6ofAM0t8P0U9vQoPMA6EOpfOF01kOHt3W/hahpeAOhxVcTHo
	 K3mljTzkgo35vyH5brAMeJqjA88JWftD6geZWzXUTl4lX1LpIcpKSH1bmwUysEqCoWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wwrt4SES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C81B606A335
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wwrt4SES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5531C1F000D0;
	Mon, 16 Nov 2026 23:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871100;
	bh=It8qELfxT2bUa+sKO+yvBp1jd+DjmMHxaUK/5IxP8xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wwrt4SESCsreq5A/o/I/DTn1mH5SYyuZnJMt1HTXylvVnRC7JmtXIofRT2ixa0yQy
	 ito0sjzPm7+YdpnGAKoicGYz47BGx90Ks5cKvbrAp6GjplO8DsED0nOzci7WZTHveA
	 vhNxalDso9PNR5IAA5yagW0L0CfrUd96nXwBgJJEmM+n8VYPVT7z7qj5j+gE42q8OR
	 cEbhfm497YW3fiSY+sqOf9j+F3zZIG5DSAUBIay1K8HK9rRst1wufnoRR+t6ROZAO9
	 ZcJAFyCu1dXedVPd8hm0gEpVEuNYkbTi44wyk5Ho9mYImf1XP1uoZqRDawTrsDX+ey
	 vdCNeJ7/AR3+w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 51/59] xfs: validate logged btree fork roots during recovery
Date: Tue, 17 Nov 2026 10:15:08 +1100
Message-ID: <20261116231707.3625263-52-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A btree format fork is logged as the expanded in-core bmap btree root, which is
a normal btree root block whose length is only as long as the fork region that
holds it. Recovery copied this root into the inode without inspecting it, so a
corrupt root was replayed as it stood.

Validate the logged bmap btree root once the fork has been verified against the
core. The root is checked as a short btree root block whose record count fills
the fork region exactly, and its keys and pointers are checked to be in range.
The metadata btree roots are a distinct form and remain validated by a following
patch.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 66 ++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 89a087d77aae..d9ab9900a201 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -29,6 +29,7 @@
 #include "xfs_metafile.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
 
@@ -470,6 +471,64 @@ xlog_dinode_verify_extents(
 			src, size / sizeof(struct xfs_bmbt_rec));
 }
 
+/*
+ * Verify a logged bmap btree root. The logged root is the expanded in-core
+ * block form, not the compact on-disk root, so it is a normal btree root block
+ * whose length is only as long as the fork region that holds it. The block
+ * length is fixed by the record count, so the region size fixes how many
+ * records the root can hold.
+ *
+ * The region size has already been bounds checked against the inode fork size,
+ * so it is known to fit within the fork and does not need rechecking here.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_bmbt_root(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	int				whichfork,
+	void				*src,
+	unsigned int			size)
+{
+	struct xfs_btree_block		*block = src;
+	xfs_failaddr_t			fa;
+	uint32_t			magic;
+	unsigned int			numrecs;
+	unsigned int			i;
+
+	if (size < xfs_bmbt_block_len(mp))
+		return __this_address;
+
+	/* The root block is never a leaf, so it always has keys and pointers. */
+	magic = xfs_has_crc(mp) ? XFS_BMAP_CRC_MAGIC : XFS_BMAP_MAGIC;
+	/*
+	 * m_bm_maxlevels includes the inode root level, so the deepest valid
+	 * root level is one less than that.
+	 */
+	fa = xfs_btree_check_fsblock_root_hdr(mp, magic,
+			xfs_bmbt_maxrecs(mp, size, false), block, 1,
+			mp->m_bm_maxlevels[whichfork] - 1);
+	if (fa)
+		return fa;
+
+	/* The record count must be non-zero and exactly fill the region. */
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (numrecs == 0 || size != xfs_bmap_broot_space_calc(mp, numrecs))
+		return __this_address;
+
+	for (i = 1; i <= numrecs; i++) {
+		struct xfs_bmbt_key	*key = xfs_bmbt_key_addr(mp, block, i);
+		xfs_bmbt_ptr_t		*ptr = xfs_bmap_broot_ptr_addr(mp, block,
+						i, size);
+
+		if (!xfs_verify_fileoff(be64_to_cpu(key->br_startoff)))
+			return __this_address;
+		if (!xfs_verify_fsbno(mp, be64_to_cpu(*ptr)))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 /*
  * Verify a logged shortform symlink target. The logged target is the on-disk
  * form, which is not null terminated, so this cannot use
@@ -569,6 +628,10 @@ xlog_dinode_verify_dfork(
 				XFS_DATA_FORK, item->ri_buf[2].iov_base,
 				ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_BTREE:
+		if (field != XFS_ILOG_DBROOT)
+			return __this_address;
+		return xlog_dinode_verify_bmbt_root(mp, ldip, XFS_DATA_FORK,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_META_BTREE:
 		if (field != XFS_ILOG_DBROOT)
 			return __this_address;
@@ -631,7 +694,8 @@ xlog_dinode_verify_afork(
 	case XFS_DINODE_FMT_BTREE:
 		if (field != XFS_ILOG_ABROOT)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_bmbt_root(mp, ldip, XFS_ATTR_FORK,
+				item->ri_buf[region].iov_base, ilfp->ilf_asize);
 	}
 
 	return NULL;
-- 
2.55.0

