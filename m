Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9887021353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424535; cv=none; b=h9JfVx9BKotndyMQMUL/pwO9AN3ik0hkqw6gTAnqzFoMlqbnq1Ad1TABgnLTNAOgyMeklKbmLa0ccywdU9cmx0LntTxyaQxv9hv6VOqrXy5sT4NJfbLsKAN81pZPL7n9sf32tOR6t/3304Zf/m606QwQP2FIGptozPAKfHLFKJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424535; c=relaxed/simple;
	bh=EQB4i3VnDS5zCBwGRpEAVK1YWwFE0fA2T8cjUvkOQOM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSHVA+dh1wGIisMneJBlXhx1jw1COglZ8Scw2BQeOoeKkwu00vw5CeFn7em3Qxsjqd9swRFpQ6EWEeNmeuu3OTERRCdd1hTLX6iVtzcGaDpmRllXNWd92KSDY98UoEXqtGNUdVpUsk5tYOvSiZnjKTzr8x+o5dIN9G4FzcGN7kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZjKrMj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZjKrMj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E896C433C7;
	Tue, 26 Mar 2024 03:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424535;
	bh=EQB4i3VnDS5zCBwGRpEAVK1YWwFE0fA2T8cjUvkOQOM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZjKrMj0qtQaCBnZBk9PSxCjI8mB1zOnKEk5aM1TdCU2R7jxEChd6gPGaSPZUI4is
	 P9D0xhwxXZf5yXp8SuTsPdw9JLytRKbAPXZSwXagqpNIxfrdu5HWziGVDHYI/d1Mob
	 KN+rd9GjhbMntlUlPA0ATVMdaUTnBljtxHmrQjDLxi8WcK3TI5v0K9RRIDgnJ5sMCo
	 dWcvYccbxjDGgQNN6cRD05bCpR/Rm8uWmeqwLdhHibMJzAlO9efzkdcSfjyJ+AtpeP
	 2J6DcU7f7B6Z8GWdZM992n7cqcT63JlLXqJIVjUPygtpjUCBC60TQafhI83yTlIWuD
	 CAwqQM2tIwncg==
Date: Mon, 25 Mar 2024 20:42:14 -0700
Subject: [PATCH 053/110] xfs: fold xfs_allocbt_init_common into
 xfs_allocbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132147.2215168.15903424516120446855.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: fb518f8eeb90197624b21a3429e57b6a65bff7bb

Make the levels initialization in xfs_allocbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c |   42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6b17037f807d..13d2310cfa36 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -511,11 +511,16 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.keys_contiguous	= NULL, /* not needed right now */
 };
 
-/* Allocate most of a new allocation btree cursor. */
-STATIC struct xfs_btree_cur *
-xfs_allocbt_init_common(
+/*
+ * Allocate a new allocation btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
+ */
+struct xfs_btree_cur *
+xfs_allocbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
@@ -530,31 +535,14 @@ xfs_allocbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
 			xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *			/* new alloc btree cursor */
-xfs_allocbt_init_cursor(
-	struct xfs_mount	*mp,		/* file system mount point */
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agf structure */
-	struct xfs_perag	*pag,
-	xfs_btnum_t		btnum)		/* btree identifier */
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_allocbt_init_common(mp, tp, pag, btnum);
-	if (btnum == XFS_BTNUM_CNT)
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-	else
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
-
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
 
+		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) :
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	}
 	return cur;
 }
 
@@ -568,7 +556,7 @@ xfs_allocbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_allocbt_init_common(mp, NULL, pag, btnum);
+	cur = xfs_allocbt_init_cursor(mp, NULL, NULL, pag, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

