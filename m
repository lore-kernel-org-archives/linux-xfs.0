Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3273FBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RadlWI16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E06C433C8;
	Sun, 31 Dec 2023 21:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057947;
	bh=M5TPtXzgXQ/EhcwWcGQEjxJkwgdTBr+18PbnOFJ67vA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RadlWI16x1gzhKvAaHMGaxtp1Gc+7mH8ShechDsjgIRkq9426J9Gg+f0ZJs10S6BS
	 v20QvExmX2aFg7BJGWVm6AynXbrGl9l8dGBXUp1wqBhNu7QiUSf5iIjWYsjcuRmoaR
	 /bN6PnwBaaDnA9D11UnSZFMHESqpxtUQyYZpDm9ZAtmTAeSLfP1qCw9cTL5+rBGilu
	 qSVFowF1AEVNALjWRYQpa6KrWLADs4RYTfM5JlArBy3Rwzfo4rXnczx000mDje3Jza
	 zGxnumzf77gVoCeGgI9gyJLHT8vDW0TY+IABGZa2OHp41cXN48nHoZU+dAcZ2TQ5WE
	 vtZI5BDAuDbmg==
Date: Sun, 31 Dec 2023 13:25:47 -0800
Subject: [PATCH 14/14] xfs: update btree keys correctly when _insrec splits an
 inode root block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847593.1763835.12995764830585274777.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

In commit 2c813ad66a72, I partially fixed a bug wherein xfs_btree_insrec
would erroneously try to update the parent's key for a block that had
been split if we decided to insert the new record into the new block.
The solution was to detect this situation and update the in-core key
value that we pass up to the caller so that the caller will (eventually)
add the new block to the parent level of the tree with the correct key.

However, I missed a subtlety about the way inode-rooted btrees work.  If
the full block was a maximally sized inode root block, we'll solve that
fullness by moving the root block's records to a new block, resizing the
root block, and updating the root to point to the new block.  We don't
pass a pointer to the new block to the caller because that work has
already been done.  The new record will /always/ land in the new block,
so in this case we need to use xfs_btree_update_keys to update the keys.

This bug can theoretically manifest itself in the very rare case that we
split a bmbt root block and the new record lands in the very first slot
of the new block, though I've never managed to trigger it in practice.
However, it is very easy to reproduce by running generic/522 with the
realtime rmapbt patchset if rtinherit=1.

Fixes: 2c813ad66a72 ("xfs: support btrees with overlapping intervals for keys")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 76320ab728467..ddbe2d55a8077 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3656,14 +3656,31 @@ xfs_btree_insrec(
 	xfs_btree_log_block(cur, bp, XFS_BB_NUMRECS);
 
 	/*
-	 * If we just inserted into a new tree block, we have to
-	 * recalculate nkey here because nkey is out of date.
+	 * Update btree keys to reflect the newly added record or keyptr.
+	 * There are three cases here to be aware of.  Normally, all we have to
+	 * do is walk towards the root, updating keys as necessary.
 	 *
-	 * Otherwise we're just updating an existing block (having shoved
-	 * some records into the new tree block), so use the regular key
-	 * update mechanism.
+	 * If the caller had us target a full block for the insertion, we dealt
+	 * with that by calling the _make_block_unfull function.  If the
+	 * "make unfull" function splits the block, it'll hand us back the key
+	 * and pointer of the new block.  We haven't yet added the new block to
+	 * the next level up, so if we decide to add the new record to the new
+	 * block (bp->b_bn != old_bn), we have to update the caller's pointer
+	 * so that the caller adds the new block with the correct key.
+	 *
+	 * However, there is a third possibility-- if the selected block is the
+	 * root block of an inode-rooted btree and cannot be expanded further,
+	 * the "make unfull" function moves the root block contents to a new
+	 * block and updates the root block to point to the new block.  In this
+	 * case, no block pointer is passed back because the block has already
+	 * been added to the btree.  In this case, we need to use the regular
+	 * key update function, just like the first case.  This is critical for
+	 * overlapping btrees, because the high key must be updated to reflect
+	 * the entire tree, not just the subtree accessible through the first
+	 * child of the root (which is now two levels down from the root).
 	 */
-	if (bp && xfs_buf_daddr(bp) != old_bn) {
+	if (!xfs_btree_ptr_is_null(cur, &nptr) &&
+	    bp && xfs_buf_daddr(bp) != old_bn) {
 		xfs_btree_get_keys(cur, block, lkey);
 	} else if (xfs_btree_needs_key_update(cur, optr)) {
 		error = xfs_btree_update_keys(cur, level);

