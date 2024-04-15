Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CFD158A23
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224839; cv=none; b=W98P2Odha65FvF56/CmHksHRwzoBWKgg3ewDddKMTRR5as3WCS5wAN4Vak8rNSgKVKQHU9469QDFES0ck8lCmyFDaIY7W89PRUKlwYpXm3ci0zBJ/8524tx0B+pYxBfF/zqt2NuigZRqHeXE7SvQT1SekKdiiEKNjWVU/ZQJgMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224839; c=relaxed/simple;
	bh=meiah2qXRPnzLgwrjyZj0KcwEpmY0TJmnkOI78Z58r0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cBiBx/FxzqO7mUkRRQKcjU0Evk6qHU203jS5p2GOKE0vF/JfGXP8e//vhLSDJGeO4d/lag6jFJuay+d2lm4cwy0doc+egxwxeVSvo8Iz2ghxyx2fr32fg7PAqhX/vTMAVo4f0o4/phh2RuykjVNTsVdV7kMBagX0LafrTUqnIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LicKof8w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LicKof8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D089C113CC;
	Mon, 15 Apr 2024 23:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224839;
	bh=meiah2qXRPnzLgwrjyZj0KcwEpmY0TJmnkOI78Z58r0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LicKof8wV09JOmSCBxFh0FRrTr2srBIn6bjcjFmCc1IxRWW8U9QV2icK8IV25eUlC
	 Obk3okYbs6qaEawD/x0JttcvChN9e//dhEK7bgD2gbOIvNYTE4jmFWvFoBzX/j83ya
	 rwXzk7k9JirA6NiNAu9dO3ODXHaM19iQP9mm1pc0LhcCSJg7Z0lddTXKzo+pB4tkCn
	 07YT7CPalMSZ/LDWgCLjY34sePe4ybPi5f/gTHVx21lOaej+4sSgilzqGLz9ehFflS
	 wUMWpmyPiXOKGine4sS0ieuxFE5lt8Biwd8wZ9qCNSChawS1KE3jqatPmzyaLDfLGO
	 E2T21E12iqRIA==
Date: Mon, 15 Apr 2024 16:47:19 -0700
Subject: [PATCH 03/10] xfs: reduce indenting in xfs_attr_node_list
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382630.88250.8018483022627138305.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
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

Reduce the indentation here so that we can add some things in the next
patch without going over the column limits.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_list.c |   56 +++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a6819a642cc0..42a575db7267 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -310,46 +310,47 @@ xfs_attr_node_list(
 	 */
 	bp = NULL;
 	if (cursor->blkno > 0) {
+		struct xfs_attr_leaf_entry *entries;
+
 		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, &bp,
 				XFS_ATTR_FORK);
 		if (xfs_metadata_is_sick(error))
 			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
-		if ((error != 0) && (error != -EFSCORRUPTED))
+		if (error != 0 && error != -EFSCORRUPTED)
 			return error;
-		if (bp) {
-			struct xfs_attr_leaf_entry *entries;
+		if (!bp)
+			goto need_lookup;
 
-			node = bp->b_addr;
-			switch (be16_to_cpu(node->hdr.info.magic)) {
-			case XFS_DA_NODE_MAGIC:
-			case XFS_DA3_NODE_MAGIC:
+		node = bp->b_addr;
+		switch (be16_to_cpu(node->hdr.info.magic)) {
+		case XFS_DA_NODE_MAGIC:
+		case XFS_DA3_NODE_MAGIC:
+			trace_xfs_attr_list_wrong_blk(context);
+			xfs_trans_brelse(context->tp, bp);
+			bp = NULL;
+			break;
+		case XFS_ATTR_LEAF_MAGIC:
+		case XFS_ATTR3_LEAF_MAGIC:
+			leaf = bp->b_addr;
+			xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo,
+						     &leafhdr, leaf);
+			entries = xfs_attr3_leaf_entryp(leaf);
+			if (cursor->hashval > be32_to_cpu(
+					entries[leafhdr.count - 1].hashval)) {
 				trace_xfs_attr_list_wrong_blk(context);
 				xfs_trans_brelse(context->tp, bp);
 				bp = NULL;
-				break;
-			case XFS_ATTR_LEAF_MAGIC:
-			case XFS_ATTR3_LEAF_MAGIC:
-				leaf = bp->b_addr;
-				xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo,
-							     &leafhdr, leaf);
-				entries = xfs_attr3_leaf_entryp(leaf);
-				if (cursor->hashval > be32_to_cpu(
-						entries[leafhdr.count - 1].hashval)) {
-					trace_xfs_attr_list_wrong_blk(context);
-					xfs_trans_brelse(context->tp, bp);
-					bp = NULL;
-				} else if (cursor->hashval <= be32_to_cpu(
-						entries[0].hashval)) {
-					trace_xfs_attr_list_wrong_blk(context);
-					xfs_trans_brelse(context->tp, bp);
-					bp = NULL;
-				}
-				break;
-			default:
+			} else if (cursor->hashval <= be32_to_cpu(
+					entries[0].hashval)) {
 				trace_xfs_attr_list_wrong_blk(context);
 				xfs_trans_brelse(context->tp, bp);
 				bp = NULL;
 			}
+			break;
+		default:
+			trace_xfs_attr_list_wrong_blk(context);
+			xfs_trans_brelse(context->tp, bp);
+			bp = NULL;
 		}
 	}
 
@@ -359,6 +360,7 @@ xfs_attr_node_list(
 	 * Note that start of node block is same as start of leaf block.
 	 */
 	if (bp == NULL) {
+need_lookup:
 		error = xfs_attr_node_list_lookup(context, cursor, &bp);
 		if (error || !bp)
 			return error;

