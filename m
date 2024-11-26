Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930BBBE46;
	Tue, 26 Nov 2024 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584455; cv=none; b=RrnFMQlgEOYF4gdmQdhE71ca2ZvBi+kc2rSOyycOb3ymMpWKyGMCQuKoKfCXkqcippTSHLeuIVuhbb8vkD8MUdoTVerCEFtOfW2/H+XfBgL5LXXKjC5BOoFdMlUVy5c05pGWOu2q8ruZ4veCauYWxbXA2/63qDbax9w9WOmLvmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584455; c=relaxed/simple;
	bh=aCJvKNRheCLyJUL7KlMcJui60wDCGNq4cMyG98vTi00=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DxYHFVl4rsFs3Vr4pwmUxbQAxL2jjv9SqR6PTQu7fKaW0vUMRhel49hwZK/5FWJK9TGDhOjhDQazpMWrvbvx04ho2n6QoCRZFPDcsENJinQdrGoqYyDIAiQEEu0FvbCcmoMP/EYYxelaIdguXo3zp3dAqbFR+c2bI1NOnQtPAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCKSPyLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCKSPyLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F3FC4CECE;
	Tue, 26 Nov 2024 01:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584455;
	bh=aCJvKNRheCLyJUL7KlMcJui60wDCGNq4cMyG98vTi00=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QCKSPyLln/pqYM2t2zWbm0XKDnYrKmihSaX5JbA+PSbaqa5Wcftzpm9tOiTgoBA/a
	 5ZqOSiQw7obDZr2TCMl5cY1A+Ksqtejy6ZdzMwyXiUz+nKYYFdLp6rcPIF0exIIkGZ
	 ctrGnX76T0tfNxzwrisDG1ShaGWKDd1GonySsTw2oughC9+FFNE2AEERGE1XroeT0z
	 fvftmsxx9ym9l21TqAq92uKNxccaSXQfoMRu0OyZVi4foSjXwYTcW+I1ulTTUbNcKO
	 Ea9yQOq5b6RUK0KNnJnixSLsL8dmGG88OkxjyVhDHS1qR04XUSQv3QCIZsEarVkgLg
	 ZIPjOFDnNIquw==
Date: Mon, 25 Nov 2024 17:27:34 -0800
Subject: [PATCH 11/21] xfs: update btree keys correctly when _insrec splits an
 inode root block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173258397991.4032920.4586526854197814179.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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

Cc: <stable@vger.kernel.org> # v4.8
Fixes: 2c813ad66a7218 ("xfs: support btrees with overlapping intervals for keys")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c748866ef92368..68ee1c299c25fd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3557,14 +3557,31 @@ xfs_btree_insrec(
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

