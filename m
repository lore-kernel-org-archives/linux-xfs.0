Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C0238C0A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Mar 2026 08:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773045509; cv=none; b=UCimwRPgxNxI88zTGwzPx2pU4LriZYjGQ0fitZgVWtAsLgzvz17CVuDI6JgRhH2KIFCIn8OpZtxaM83uBccYrY060hGn45akeeOCeeohMVYdq4WGyu8gtJgE9dg99ZS3j6PYdBaSRhpDH96zobG2zr5MxhKiyAsNuwkfcA10ZJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773045509; c=relaxed/simple;
	bh=8Rj0BTNsTuLMuazIyVlR6PQJKLd8a2sSzTDxNl2+T2Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ma6dwLKbYyGLWxJaF9jNsAOikrzAT9FHsSk2bAoZrOCHPGiy0AOjavT3Tl/eMfXpqf5n6bZoiPvPSRQLtYTt4KOoxy+06VWLJsmOLciHPQ9lecE1DZX8p0hzzNxoiKBUXKOIdoYMiIBjAVMszdLh0bdDm/wgpRX+3B5haX8kgew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=owlvJkD3; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="owlvJkD3"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VbPsAEuah1KydphwBjA/kVE03SO1te9AOXct9cjir1k=;
	b=owlvJkD3Yq+bYmqr+tLhwTI9Y9WOCHP7ulUT4sXqm0SkqMENrJAsJndKVwEBAlIKHvh7WCIf5
	kKEPrjcyV1XNbz9tCo+SVT0too9SAQoAw9K388gt61HjYe/nejxRC4dSVaW1IFResl55nuBiltZ
	X3jL5DzALMejsPsNZo0nkH0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fTqz60S3Gz1prNG;
	Mon,  9 Mar 2026 16:33:22 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 77A9D40538;
	Mon,  9 Mar 2026 16:38:18 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Mar 2026 16:38:18 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 9 Mar
 2026 16:38:17 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH 2/4] xfs: factor out xfs_da3_node_entry_remove
Date: Mon, 9 Mar 2026 16:27:50 +0800
Message-ID: <20260309082752.2039861-3-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260309082752.2039861-1-leo.lilong@huawei.com>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Factor out wrapper xfs_da3_node_entry_remove function, which
exported for external use.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 54 ++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_da_btree.h |  2 ++
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 766631f0562e..466c43098768 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1506,21 +1506,20 @@ xfs_da3_fixhashpath(
 }
 
 /*
- * Remove an entry from an intermediate node.
+ * Internal implementation to remove an entry from an intermediate node.
  */
 STATIC void
-xfs_da3_node_remove(
-	struct xfs_da_state	*state,
-	struct xfs_da_state_blk	*drop_blk)
+__xfs_da3_node_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_da_geometry  *geo,
+	struct xfs_da_state_blk *drop_blk)
 {
 	struct xfs_da_intnode	*node;
 	struct xfs_da3_icnode_hdr nodehdr;
 	struct xfs_da_node_entry *btree;
 	int			index;
 	int			tmp;
-	struct xfs_inode	*dp = state->args->dp;
-
-	trace_xfs_da_node_remove(state->args);
 
 	node = drop_blk->bp->b_addr;
 	xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr, node);
@@ -1536,17 +1535,17 @@ xfs_da3_node_remove(
 		tmp  = nodehdr.count - index - 1;
 		tmp *= (uint)sizeof(xfs_da_node_entry_t);
 		memmove(&btree[index], &btree[index + 1], tmp);
-		xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+		xfs_trans_log_buf(tp, drop_blk->bp,
 		    XFS_DA_LOGRANGE(node, &btree[index], tmp));
 		index = nodehdr.count - 1;
 	}
 	memset(&btree[index], 0, sizeof(xfs_da_node_entry_t));
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
+	xfs_trans_log_buf(tp, drop_blk->bp,
 	    XFS_DA_LOGRANGE(node, &btree[index], sizeof(btree[index])));
 	nodehdr.count -= 1;
 	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
-	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
-	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
+	xfs_trans_log_buf(tp, drop_blk->bp,
+	    XFS_DA_LOGRANGE(node, &node->hdr, geo->node_hdr_size));
 
 	/*
 	 * Copy the last hash value from the block to propagate upwards.
@@ -1554,6 +1553,39 @@ xfs_da3_node_remove(
 	drop_blk->hashval = be32_to_cpu(btree[index - 1].hashval);
 }
 
+/*
+ * Remove an entry from an intermediate node.
+ */
+STATIC void
+xfs_da3_node_remove(
+	struct xfs_da_state	*state,
+	struct xfs_da_state_blk	*drop_blk)
+{
+	trace_xfs_da_node_remove(state->args);
+	__xfs_da3_node_remove(state->args->trans, state->args->dp,
+			state->args->geo, drop_blk);
+}
+
+/*
+ * Remove an entry from a node at the specified index, this is an exported
+ * wrapper for removing entries from intermediate nodes.
+ */
+void
+xfs_da3_node_entry_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp,
+	int			index)
+{
+	struct xfs_da_state_blk blk;
+
+	memset(&blk, 0, sizeof(blk));
+	blk.index = index;
+	blk.bp = bp;
+
+	__xfs_da3_node_remove(tp, dp, dp->i_mount->m_attr_geo, &blk);
+}
+
 /*
  * Unbalance the elements between two intermediate nodes,
  * move all Btree elements from one node into another.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 354d5d65043e..6cec4313c83c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -184,6 +184,8 @@ int	xfs_da3_split(xfs_da_state_t *state);
 int	xfs_da3_join(xfs_da_state_t *state);
 void	xfs_da3_fixhashpath(struct xfs_da_state *state,
 			    struct xfs_da_state_path *path_to_to_fix);
+void	xfs_da3_node_entry_remove(struct xfs_trans *tp, struct xfs_inode *dp,
+				struct xfs_buf *bp, int index);
 
 /*
  * Routines used for finding things in the Btree.
-- 
2.39.2

