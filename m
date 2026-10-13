Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6839B417BD2
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871381; cv=none; b=EM67sw9CxirKZEW0HVsoPp5h+JAK0vmrKGQTf+b4VLSBSoPBi8qZvOTAdyuL4zpzWUOYJH4221ph3g3wrXAa+nvgA/B5Akfl9KtMsH33WeS6lwKWTsNFlciqld8mXTHvuxWMCUaC+UfElWBfEONIATKeK5L0117mxWLPm70rMkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871381; c=relaxed/simple;
	bh=qSl0t6AWyYJXq2FK+9orTeXdR/eMyihsiyJQledSRMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW1HaflTu0Ps40Rn1YKcaQfWNz9KaLn8iSIzPhh/gkbWzV6gZ9behPzh/i1p987fGZJ/VrG2FFA/7VTlwZi0oc9lIc1W0pUg7H2m+ityyVO1Wz8+LoZJyimq90snOY75u8puqyB6SBCnvxVkjVj3lfre4NhmgT3SFKx3IVAHC+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMeB3dbo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMeB3dbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE91F00898;
	Tue, 13 Oct 2026 06:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871380;
	bh=Rq4JsUsgskaUN/fmNf85iFBKK5uPk7RLvabcd3i2Sv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMeB3dbojVWg08pXSmLhDCSl+rDZljvSxy7+RSIsLns1xmguaRsfe9MuNUqh1XnY3
	 CKpPppUwrAVIdTf7Crv46bF6m6q3fHmwg+9/TwLqKlyBoXfw7fEbmkSzi7pWLFc2rM
	 S+eBV3REyF+gy+s9JCeF8D/yT5cQNfQvNBP5MCtv+zU435mk9rRccF6guu2Ekos6p3
	 ZEU6qyOVI8z0E2Ufgs5M+pyX9eOr5eM6oLcEqtmOh0uuwwdi308xU8sB6sLKc5ReLl
	 i25UePJy6njC/2oL2vaNwIYDJSyvjQa4FLcp1mOIN1/Zu0ffvScWZehK2tbQug7lnJ
	 9IDnGp+tquQmg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 41/48] xfs: validate logged btree fork roots during recovery
Date: Tue, 13 Oct 2026 17:01:31 +1100
Message-ID: <20261013060204.3138690-42-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
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
 fs/xfs/xfs_inode_item_recover.c | 62 ++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 3e0109833d21..b979e922e5e9 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -29,6 +29,7 @@
 #include "xfs_metafile.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_btree.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
 
@@ -469,6 +470,60 @@ xlog_dinode_verify_extents(
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
+	fa = xfs_btree_check_fsblock_root_hdr(mp, magic,
+			xfs_bmbt_maxrecs(mp, size, false), block, 1,
+			mp->m_bm_maxlevels[whichfork]);
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
@@ -567,6 +622,10 @@ xlog_dinode_verify_dfork(
 		return xlog_dinode_verify_extents(mp, ldip, XFS_DATA_FORK,
 				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_BTREE:
+		if (field != XFS_ILOG_DBROOT)
+			return __this_address;
+		return xlog_dinode_verify_bmbt_root(mp, ldip, XFS_DATA_FORK,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_META_BTREE:
 		if (field != XFS_ILOG_DBROOT)
 			return __this_address;
@@ -628,7 +687,8 @@ xlog_dinode_verify_afork(
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

