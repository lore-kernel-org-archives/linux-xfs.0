Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F7F3D25CC;
	Mon, 20 Jul 2026 09:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538304; cv=none; b=R+hoSioyGZpQkpXWKRKjZuFZHimh6FHURjMV7wvF+CfbvBV/rU+d+Ki+BmaE0TchZlH3itQyeIJXfWv4umRRa0Dx020o4XzB5dFesS+ydkc389fnaDIrJcj/iygKZUpITg6NfPq3c2Ec9bLzpB3vf24gT9rlfEj0vndKgQ7e+n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538304; c=relaxed/simple;
	bh=XL3o9W2kzR+eqNV9dmhcwvOuPQyNlCR3vYBSO9JDnVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biX9p5Pk1RkcY/hSRefJ0y+TcBOHigc9k2EJnMNnfzXgVZbhatydpO487/bfphfhM2vJVRkiaQT01FwWIbfp6i20syHNEf5y1LqhtqpcLspJQfxefuwmjCMoqVfII8L/d3oJ3sFkmoeR+DZvp/yXxrlULcz4JX2i20iUk238WP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFsAIKau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFsAIKau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C231F00A3A;
	Mon, 20 Jul 2026 09:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784538303;
	bh=i0Rsh4cPeB/WILyk3ZVofd79y/gOW8f0+5qtEc82UTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFsAIKau9yR0RhKAVg9uyW3HsOt4haQuuNgSuA8Q/RDdknTrbA8KWUHsQBLsFxUAz
	 1jMPJ6sGvCktykH8uZuGS/duf1oIJH2OuSHJ36WG5GYlxsvVtd/Q/gtXkiNA680Gtc
	 24JicjWcwVIHfGE5Yunq0ngcIUILINksp9l4bNKl6/p6KU/jGhBTutdE7uvnTTHuh1
	 LQ2vUMX9czcXi8cHmJOU70uhvFIooSTHKbTi6CTeUS4U/KsP4l8qY23OHucwMrApYM
	 Y7U0R9vDK+UKlnIyKfzcQZFo8KKslk+J4lm6QKkw/RfttYDBb3bWrPTPjxrmNVvn5i
	 z+gn6ZMUcm0ow==
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
	djwong@kernel.org
Subject: [PATCH v12 03/21] fsverity: pass digest size and hash of the all-zeroes block to ->write
Date: Mon, 20 Jul 2026 11:03:31 +0200
Message-ID: <20260720090410.3487990-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
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

