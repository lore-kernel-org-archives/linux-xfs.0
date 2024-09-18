Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83161136326
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637492; cv=none; b=T4t4nXrhi9isorXwRTmdnQ20PjVqrSNH1cGOgO00nORksscBMae3SI0pkUg4PMO2S7W4kzJEfWvyqJq8q3OOOrEgqF2wjVCxLQEt46rljW7BOFZjR3ToEjeZlny75qVpUusq25sS60ZOhz2zKiCSKeeeBS93fTNeKVJhvDzDIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637492; c=relaxed/simple;
	bh=bvRtUjAgroH6hFb3BGCBpb5IkD5IIxVmkP9xUSgvIgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg653sfiYetiZV1CHGx9xcGaGmE8qwrwnAQxP+kr4cesoaZv+CqSeQt6tkICq8Y7ik640DwqkLNK/54KW2Xqhd7NimfPVKKc8s+4fK7PSK6K8ulZB2jUG3hcdoRMBHVCT7XU6ktdB3PnvmT0mCkecVz9Pfv43sQsugwUd5hTgiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Aehb9h6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Aehb9h6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2xKe6G0IHj7FFAxcDKzxzD98qM619hVEPaquPEfdEfI=; b=3Aehb9h6Q97gccsAdsxHkzUovQ
	5sOCQHb5rhGStXxXICU95nAvmV3N4FUQTuRFJLVRB6ZwKjO+gYA0iN4qlOVF/P7OFVRSoCAL2hrWO
	qmszZ0B6BSDkUgago4pl+vyCIysj3e+dKs5mrEVk9w0WRTeLnyQMGbdB2O6S12d4LPaD1ZKINIIcM
	+GPNVt0ec/t7SvHvWzOw5QH09Rmiru48aA4NrPj95kP0za1EvRrqOUIF3JcUO2hdDy7WhtXIuFerG
	E9TWS+TRigeOzij1Aiz3K9ckUrGXbelR50m9XRPnkxgV7xnJtuxfN9QcdbAnF7WJACGwtj9BPqe74
	LYkgJLGw==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHl-00000007TkT-2KK9;
	Wed, 18 Sep 2024 05:31:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/8] xfs: return bool from xfs_attr3_leaf_add
Date: Wed, 18 Sep 2024 07:30:04 +0200
Message-ID: <20240918053117.774001-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_attr3_leaf_add only has two potential return values, indicating if the
entry could be added or not.  Replace the errno return with a bool so that
ENOSPC from it can't easily be confused with a real ENOSPC.

Remove the return value from the xfs_attr3_leaf_add_work helper entirely,
as it always return 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c      | 13 +++++-------
 fs/xfs/libxfs/xfs_attr_leaf.c | 37 ++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b9df7a6b1f9d61..0bf4f718be462f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -557,10 +557,7 @@ xfs_attr_leaf_addname(
 	 * or perform more xattr manipulations. Otherwise there is nothing more
 	 * to do and we can return success.
 	 */
-	error = xfs_attr3_leaf_add(bp, args);
-	if (error) {
-		if (error != -ENOSPC)
-			return error;
+	if (!xfs_attr3_leaf_add(bp, args)) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -574,7 +571,7 @@ xfs_attr_leaf_addname(
 	}
 
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
-	return error;
+	return 0;
 
 out_brelse:
 	xfs_trans_brelse(args->trans, bp);
@@ -1399,21 +1396,21 @@ xfs_attr_node_try_addname(
 {
 	struct xfs_da_state		*state = attr->xattri_da_state;
 	struct xfs_da_state_blk		*blk;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_attr_node_addname(state->args);
 
 	blk = &state->path.blk[state->path.active-1];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 
-	error = xfs_attr3_leaf_add(blk->bp, state->args);
-	if (error == -ENOSPC) {
+	if (!xfs_attr3_leaf_add(blk->bp, state->args)) {
 		if (state->path.active == 1) {
 			/*
 			 * Its really a single leaf node, but it had
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
+			error = -ENOSPC;
 			goto out;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 6aaec1246c9500..8f69ce89da247e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -47,7 +47,7 @@
  */
 STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
 				 xfs_dablk_t which_block, struct xfs_buf **bpp);
-STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
+STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
 				   struct xfs_attr3_icleaf_hdr *ichdr,
 				   struct xfs_da_args *args, int freemap_index);
 STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
@@ -995,10 +995,8 @@ xfs_attr_shortform_to_leaf(
 		xfs_attr_sethash(&nargs);
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
-		error = xfs_attr3_leaf_add(bp, &nargs);
-		ASSERT(error != -ENOSPC);
-		if (error)
-			goto out;
+		if (!xfs_attr3_leaf_add(bp, &nargs))
+			ASSERT(0);
 		sfe = xfs_attr_sf_nextentry(sfe);
 	}
 	error = 0;
@@ -1343,8 +1341,9 @@ xfs_attr3_leaf_split(
 	struct xfs_da_state_blk	*oldblk,
 	struct xfs_da_state_blk	*newblk)
 {
-	xfs_dablk_t blkno;
-	int error;
+	bool			added;
+	xfs_dablk_t		blkno;
+	int			error;
 
 	trace_xfs_attr_leaf_split(state->args);
 
@@ -1379,10 +1378,10 @@ xfs_attr3_leaf_split(
 	 */
 	if (state->inleaf) {
 		trace_xfs_attr_leaf_add_old(state->args);
-		error = xfs_attr3_leaf_add(oldblk->bp, state->args);
+		added = xfs_attr3_leaf_add(oldblk->bp, state->args);
 	} else {
 		trace_xfs_attr_leaf_add_new(state->args);
-		error = xfs_attr3_leaf_add(newblk->bp, state->args);
+		added = xfs_attr3_leaf_add(newblk->bp, state->args);
 	}
 
 	/*
@@ -1390,13 +1389,15 @@ xfs_attr3_leaf_split(
 	 */
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
-	return error;
+	if (!added)
+		return -ENOSPC;
+	return 0;
 }
 
 /*
  * Add a name to the leaf attribute list structure.
  */
-int
+bool
 xfs_attr3_leaf_add(
 	struct xfs_buf		*bp,
 	struct xfs_da_args	*args)
@@ -1405,6 +1406,7 @@ xfs_attr3_leaf_add(
 	struct xfs_attr3_icleaf_hdr ichdr;
 	int			tablesize;
 	int			entsize;
+	bool			added = true;
 	int			sum;
 	int			tmp;
 	int			i;
@@ -1433,7 +1435,7 @@ xfs_attr3_leaf_add(
 		if (ichdr.freemap[i].base < ichdr.firstused)
 			tmp += sizeof(xfs_attr_leaf_entry_t);
 		if (ichdr.freemap[i].size >= tmp) {
-			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
+			xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
 			goto out_log_hdr;
 		}
 		sum += ichdr.freemap[i].size;
@@ -1445,7 +1447,7 @@ xfs_attr3_leaf_add(
 	 * no good and we should just give up.
 	 */
 	if (!ichdr.holes && sum < entsize)
-		return -ENOSPC;
+		return false;
 
 	/*
 	 * Compact the entries to coalesce free space.
@@ -1458,24 +1460,24 @@ xfs_attr3_leaf_add(
 	 * free region, in freemap[0].  If it is not big enough, give up.
 	 */
 	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
-		tmp = -ENOSPC;
+		added = false;
 		goto out_log_hdr;
 	}
 
-	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
+	xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
 out_log_hdr:
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 				xfs_attr3_leaf_hdr_size(leaf)));
-	return tmp;
+	return added;
 }
 
 /*
  * Add a name to a leaf attribute list structure.
  */
-STATIC int
+STATIC void
 xfs_attr3_leaf_add_work(
 	struct xfs_buf		*bp,
 	struct xfs_attr3_icleaf_hdr *ichdr,
@@ -1593,7 +1595,6 @@ xfs_attr3_leaf_add_work(
 		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index bac219589896ad..589f810eedc0d8 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -76,7 +76,7 @@ int	xfs_attr3_leaf_split(struct xfs_da_state *state,
 int	xfs_attr3_leaf_lookup_int(struct xfs_buf *leaf,
 					struct xfs_da_args *args);
 int	xfs_attr3_leaf_getvalue(struct xfs_buf *bp, struct xfs_da_args *args);
-int	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
+bool	xfs_attr3_leaf_add(struct xfs_buf *leaf_buffer,
 				 struct xfs_da_args *args);
 int	xfs_attr3_leaf_remove(struct xfs_buf *leaf_buffer,
 				    struct xfs_da_args *args);
-- 
2.45.2

