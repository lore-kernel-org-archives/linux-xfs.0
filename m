Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C620313
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504762; cv=none; b=hu51/n9YmjkX+hmz0CdrjGcdGKEyqK4W2ijjC7aUUnB3/C37d8pGMMzId32oOF46nuhxhYSYJUCgECyzPPenokz7hQC+eS3B9dwuEPAdXhNB7lkZgv0VclKQrasYZkBCvZ+RCkpupQ28XsfcwDeV0MKpArhxujFpdqAJ8t1gsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504762; c=relaxed/simple;
	bh=bx2Uwic3nuaxvE+qmV45hJXadpAv38yNhl7w1Aa3erM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nET0hnNwraZSw4eaN4nvbaJ4Mkw1XEdIJapSxaXmcJhMpuyBqbfM1sqtx6KJ8deQ7RU/DW18Gar+SVvlVB553G7WEZepJvYkcSeVZug+7SXfv7PtL7+VfVcrd7pnOB3nEsTDc7fp2GjNlwsJvRdl+7OAIpGvHd32WkfY6xTGbdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNA4Vzcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNA4Vzcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81E8C433F1;
	Wed, 27 Mar 2024 01:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504761;
	bh=bx2Uwic3nuaxvE+qmV45hJXadpAv38yNhl7w1Aa3erM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lNA4Vzcr0AtBmu/KJToPWadPhGbIpmhLBe2c0Ec6tZCMM2cGAVYK5IjEd7SdsZfw+
	 LyjfL5w+eIlvAs71OnrwS2HUpzksAsqkNzJWGz/QC4FubKGKzy2PdDCeGKl4qyQQ+6
	 ijxFAvdFuQvSlFhh4v//ePhN0/BsdgmU4xLhoyGiDJLwGiHfUCgfCUuqwL1nNP/NuN
	 1klJICEfFZ6f/Zeybj6rWyvy997SCQCmQHa07fgBz1dAEUCMz3eRixOdq8oXsNGfrG
	 ez8DdYDbt7vfU2rVu2idCYWV37n/BLBuJUnzeev7/7XJG78FLGHPUQh5jfyrmTMUGW
	 awjkBvBpzOFhg==
Date: Tue, 26 Mar 2024 18:59:21 -0700
Subject: [PATCH 03/10] xfs: reduce indenting in xfs_attr_node_list
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382175.3217370.15842303765544950135.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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

Reduce the indenting here so that we can add some things in the next
patch without going over the column limits.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_list.c |   56 +++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a6819a642cc07..42a575db72678 100644
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

