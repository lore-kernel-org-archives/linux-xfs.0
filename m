Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1463AF65B;
	Mon,  3 Aug 2026 20:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785787755; cv=none; b=BtT0SfI4giZFc09P99gERKqIsQfyfR2Y4f84hBDycCannrk7A4q5T+Ew0ARzH57cYsBqO3MTh3hgzpSTvA7tTOu7QpgDCMu97wdrTFdVb2OmBuecz4QwTEVYR3QvJkbxJKwJ6H94Fk7MpIcCo2v9hSoi9u6fqJnhDxkyLfpUvSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785787755; c=relaxed/simple;
	bh=nboUe27Hg3eu5X3k6XUYtWHU2eXSf94tsh0P6VISTSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL2NhqzplgHGs5FGhfqw3fd3gwFtkyfJp+rJmiWEpckmpA8r1lxeGkA3FKXiIEJXte3U0HR3FflF0B48IWx7A9TFF7fS8dk53OijsAFfdYpBFCjXYVyg9weyK0aApnJbr7lp2TX1bGGzWk35947hL1ysGe1LJOULBUAXtDMQ2zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PX+OCy8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PX+OCy8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48CE1F00A3E;
	Mon,  3 Aug 2026 20:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785787753;
	bh=jK7/p3tKZCXLJ6SoZHiH+c6KuVCucmDWJN7yYrR8bGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PX+OCy8WQHcZkymX0CI4VxRsjJyfL+5WIV2zfNBscWRvEJp8SBXVnY/tw8ZY1bB5C
	 U0eUUuchZDhf1FztwilBldh9Yq6aLExGGvJZmVkrVUcY9HbPZzvTyolHo7208fXu4U
	 1bpgmZklBSWbH1xMEvI5HVDrskbIkHssdZ7YehEd/lwg2Ky/pP1p1fKWZTmbkLD7Xs
	 LfIItDyAa9J8GpsbmgVnerS8wQFY/L9wzPL9ztqiAtvcOik+8QpDdKiRx7pD2B9PX5
	 ubW2pOJc+gJxDNuAZhlgxTGdTv5WVBqUWayIvBxIH89Na8lSzgjhv2Tc/ZjBmimLKx
	 fp1YH7v46yd8A==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org,
	David Sterba <dsterba@suse.com>
Subject: [PATCH v14 03/21] fsverity: pass digest size and hash of the all-zeroes block to ->write
Date: Mon,  3 Aug 2026 22:07:53 +0200
Message-ID: <20260803200820.393203-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260803200820.393203-1-aalbersh@kernel.org>
References: <20260803200820.393203-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let filesystem iterate over hashes in the block and check if these are
hashes of zeroed data blocks. XFS will use this to decide if it want to
store tree block full of these hashes.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/verity.c        | 6 +++++-
 fs/ext4/verity.c         | 4 +++-
 fs/f2fs/verity.c         | 4 +++-
 fs/verity/enable.c       | 4 +++-
 include/linux/fsverity.h | 6 +++++-
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 983365a73541..bd79e343ae23 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -773,11 +773,15 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
  * @buf:	Merkle tree block to write
  * @pos:	the position of the block in the Merkle tree (in bytes)
  * @size:	the Merkle tree block size (in bytes)
+ * @zero_digest:	the hash of the all-zeroes block
+ * @digest_size:	size of zero_digest, in bytes
  *
  * Returns 0 on success or negative error code on failure
  */
 static int btrfs_write_merkle_tree_block(struct file *file, const void *buf,
-					 u64 pos, unsigned int size)
+					 u64 pos, unsigned int size,
+					 const u8 *zero_digest,
+					 unsigned int digest_size)
 {
 	struct inode *inode = file_inode(file);
 	loff_t merkle_pos = merkle_file_pos(inode);
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index ca61da53f313..347945ac23a4 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -374,7 +374,9 @@ static void ext4_readahead_merkle_tree(struct inode *inode, pgoff_t index,
 }
 
 static int ext4_write_merkle_tree_block(struct file *file, const void *buf,
-					u64 pos, unsigned int size)
+					u64 pos, unsigned int size,
+					const u8 *zero_digest,
+					unsigned int digest_size)
 {
 	pos += ext4_verity_metadata_pos(file_inode(file));
 
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 39f482515445..cc4158fc841d 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -272,7 +272,9 @@ static void f2fs_readahead_merkle_tree(struct inode *inode, pgoff_t index,
 }
 
 static int f2fs_write_merkle_tree_block(struct file *file, const void *buf,
-					u64 pos, unsigned int size)
+					u64 pos, unsigned int size,
+					const u8 *zero_digest,
+					unsigned int digest_size)
 {
 	pos += f2fs_verity_metadata_pos(file_inode(file));
 
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 42dfed1ce0ce..ad4ff71d7dd9 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -50,7 +50,9 @@ static int write_merkle_tree_block(struct file *file, const u8 *buf,
 	int err;
 
 	err = inode->i_sb->s_vop->write_merkle_tree_block(file, buf, pos,
-							  params->block_size);
+							  params->block_size,
+							  params->zero_digest,
+							  params->digest_size);
 	if (err)
 		fsverity_err(inode, "Error %d writing Merkle tree block %lu",
 			     err, index);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 3c3250f6f272..9e7d946676b9 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -124,6 +124,8 @@ struct fsverity_operations {
 	 * @buf: the Merkle tree block to write
 	 * @pos: the position of the block in the Merkle tree (in bytes)
 	 * @size: the Merkle tree block size (in bytes)
+	 * @zero_digest: the hash of the all-zeroes block
+	 * @digest_size: size of zero_digest, in bytes
 	 *
 	 * This is only called between ->begin_enable_verity() and
 	 * ->end_enable_verity().
@@ -131,7 +133,9 @@ struct fsverity_operations {
 	 * Return: 0 on success, -errno on failure
 	 */
 	int (*write_merkle_tree_block)(struct file *file, const void *buf,
-				       u64 pos, unsigned int size);
+				       u64 pos, unsigned int size,
+				       const u8 *zero_digest,
+				       unsigned int digest_size);
 };
 
 #ifdef CONFIG_FS_VERITY
-- 
2.54.0

