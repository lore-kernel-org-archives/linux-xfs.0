Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879813;
	b=fFvDvPjurEIAcNy8YL6fEQEb5llvnO4IXKLO0MpET+0GtrwPj+FBuSsVZ0bAiHkF6T50
	 NmF1F/FGZJZ4ZE1GG5QYACEfNSZN4t2sH+xbTGH0YgGN6pgQrjFuWkNsPjzIxak8yqeMb
	 88+w3MMJfz6IhTl51XhfViz7P6Q0GLZf2cqpA30HfMqNjwIQ+wf72N3IWnjxXhluZP8K+
	 sjHiLjviqKUglNVUOvj8bdWa5AUyTZOBDcEsGEyhc+wddF+5OeSvn712RwNjJZvOij2yk
	 T6BweFWquiJBAN6biTtiS1y9KdODBYpE5qsGT3ab+LBAaIa83o3Voj+lxq9Bu4lpy0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6OoXSuBVckbjMr10776+BofcenI1h9UgLTjzn6lRqQ0=;
	b=Qo8ykn0ZjlkwYf2+u2QO+zWHJCDsUxLRtGfrg03U1LAwbiGIozBnOYOlnfNRTk4l/ByZ
	 YrWmdFSVq5rAQ4EWgRivSWsnhqh4bA2lpqVXyQva2fgeQKgdly/LsJsBKaN9qobj5/5zy
	 ilsu9W8xFcFnKLYjQoeMaJ3U1mvAYp43labogtAyhOxFmExv2pa7icxsS9WwoPmF+i5qA
	 Redjhh4AOxPDWCtpEOXsdWgJeVTk2veeOMhrIR8FGntPmcve3m1ESWl7b6mwZWeZSBytG
	 VRkV5jScRnlw/5h+v+wY3U4ZDxd6CPrVqVgBN5xxho5zTDZrzOoecxX/YibNt+uMCwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwocAs9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C627606A33F;
	Thu,  5 Nov 2026 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AwocAs9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828381F000C1;
	Thu,  5 Nov 2026 11:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879812;
	bh=6OoXSuBVckbjMr10776+BofcenI1h9UgLTjzn6lRqQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AwocAs9bXTz3L1BcS9htL33YQmVnDPQMOQLyznSDYXoML+o6az4Qgx+TbmpAWOGiV
	 UrkcI2zSIXSQ4hUatXMpx0WXWOCh8fTa9Q5k9iotbw1UTewWYrG6JqNqYKmUq+S/v6
	 zCagGSyIGuKKbbTSVHEM2mCN1DNZqMTCyTDhVgj8X7hjk9prq7nin0YJufM5JGwY8e
	 tVQpOFuY0DPrNo140Y9EllrDUhfbk7K04enByXvmaVtK/uUDGMfkFEFGFDfaGeIMdo
	 iOVBuSDiZ8TVUD/v1jvS3Fh87I3aFLITSz7vTS6P/xwYwhJHDWkGQ3uRL1kHnl3BwH
	 6fw+xz8fXcPSw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev,
	dsterba@suse.com
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk,
	jaegeuk@kernel.org,
	chao@kernel.org,
	tytso@mit.edu
Subject: [PATCH v2 3/5] btrfs: use I_VERITY_BUILDING instead of private flags
Date: Thu,  5 Nov 2026 12:55:28 +0100
Message-ID: <20261105115532.613467-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105115532.613467-1-aalbersh@kernel.org>
References: <20261105115532.613467-1-aalbersh@kernel.org>
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

Now that the VFS tracks an inode whose Merkle tree is under construction
via I_VERITY_BUILDING and handles the concurrent-enable guard in the
generic fs-verity enable path, drop the inode runtime flags that
duplicated this.

btrfs only used BTRFS_INODE_VERITY_IN_PROGRESS internally, so remove it
outright.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  7 -------
 fs/btrfs/verity.c      | 14 +++-----------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 0782f917fccc..5c752b947b56 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -78,13 +78,6 @@ enum {
 	 * the file range, inode's io_tree).
 	 */
 	BTRFS_INODE_NO_DELALLOC_FLUSH,
-	/*
-	 * Set when we are working on enabling verity for a file. Computing and
-	 * writing the whole Merkle tree can take a while so we want to prevent
-	 * races where two separate tasks attempt to simultaneously start verity
-	 * on the same file.
-	 */
-	BTRFS_INODE_VERITY_IN_PROGRESS,
 	/* Set when this inode is a free space inode. */
 	BTRFS_INODE_FREE_SPACE_INODE,
 	/* Set when there are no capabilities in XATTs for the inode. */
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index b34d2247cf84..c7eec8886e49 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -461,7 +461,6 @@ static int rollback_verity(struct btrfs_inode *inode)
 
 	btrfs_assert_inode_locked(inode);
 	truncate_inode_pages(inode->vfs_inode.i_mapping, inode->vfs_inode.i_size);
-	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	ret = btrfs_drop_verity_items(inode);
 	if (ret) {
 		btrfs_handle_fs_error(root->fs_info, ret,
@@ -513,7 +512,6 @@ static int rollback_verity(struct btrfs_inode *inode)
  * - mark the inode with the verity flag
  * - delete the orphan item
  * - mark the ro compat bit
- * - clear the in progress bit
  *
  * Returns 0 on success, negative error code on failure.
  */
@@ -555,7 +553,6 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
 		goto end_trans;
 	/* Now that rollback is no longer possible, set S_VERITY. */
 	btrfs_sync_inode_flags_to_i_flags(inode);
-	clear_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_set_fs_compat_ro(root->fs_info, VERITY);
 end_trans:
 	if (ret)
@@ -570,8 +567,8 @@ static int finish_verity(struct btrfs_inode *inode, const void *desc,
  *
  * @filp:  file to enable verity on
  *
- * Begin enabling fsverity for the file. We drop any existing verity items, add
- * an orphan and set the in progress bit.
+ * Begin enabling fsverity for the file. We drop any existing verity items and
+ * add an orphan.
  *
  * Returns 0 on success, negative error code on failure.
  */
@@ -587,9 +584,6 @@ static int btrfs_begin_enable_verity(struct file *filp)
 	if (IS_ENCRYPTED(&inode->vfs_inode))
 		return -EOPNOTSUPP;
 
-	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags))
-		return -EBUSY;
-
 	/*
 	 * This should almost never do anything, but theoretically, it's
 	 * possible that we failed to enable verity on a file, then were
@@ -606,11 +600,9 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		return PTR_ERR(trans);
 
 	ret = btrfs_orphan_add(trans, inode);
-	if (!ret)
-		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.54.0

