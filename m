Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290098;
	b=U24GrwWfoAj1eKZR2cOD9gc9CMo8vKcNXbojvyX62wRspLrqPHes05xe3brtmpagajXW
	 pM9ftT36z7UU0dVfyNUCgZm8ykuf1S3oxSS9fmDqiUjagzSW4cWV6HhNNzJZVNU/hLAMx
	 uJcUEvG7KGSAoFg2I40OamknGZ/dbTfMZVW8oC4VMlcmnv7QBUkb60aw1WSk/niYXkLYl
	 bgLMmvbOYeDPjAkR6UcP0a4A0oF22FEPI+0tx24rYPRiH9LxSs6KkQdZzNRPlS4MzTUcO
	 CMhz6Pe7SLj/6kPWrN/eb1/nBpu54tYN1Ds66ZlqDWqOWEOsM0b+Ke5SpVFZkcrjbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290098;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=iVtfPcXJU1Dl8ABOoiDUG8I8knzlj5kyhgqCw7tVF5M=;
	b=hhXAv6BtBmwaHVpJ0SIw+BN5ULvmFtvkfduDGZdL9fwAhYQkmdck1X6NkX5Hq/AwTrBU
	 /FWWErDnrFT3aUKVgX7mF72OnJi1MaEzDr7+Wf70l0y6NPR7AC9Li0hjf08Y+5DUfgKBO
	 bDaQPvpBaSy/o1ZKbkXBO8ODqO0CzaiCN9ePnqOoSbwOn96/P2Z58BbjvnDZ5yi0zHx2Z
	 bnFfrd2+5u8+vrCZTVbxra6lnLdKNkIaxRlNsxedghw4Z007U6OC6UriWgczti5xJbDSQ
	 1Ei9hrzinwAAZyBwXgxzf2nT2mtOYwQf6uue2uut1BbFlIH02whrDvSceqp7HQ994fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaNj3haK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD70606A31A;
	Thu, 29 Oct 2026 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SaNj3haK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20F91F01816;
	Thu, 29 Oct 2026 16:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290097;
	bh=iVtfPcXJU1Dl8ABOoiDUG8I8knzlj5kyhgqCw7tVF5M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SaNj3haKjPhS0EV5du9JfwoaG8Rin7tmXFLxPOygnrJjfpOEMsH1kKI3PDQ5XrA31
	 elsbGH2JC31Wkk9r2juQXQaMil6mGer0JYCXeGnlS7/hHIbTjXtNGAiTEsULpLJxMu
	 x7YJWpentI1ho5FrGAqj77ZuQkE0HOtBSPBH+2h5Sw/HmrQ7Qr5Z3mw2MkbbdT1YeW
	 C4YSP8lYmdEQ5tm4M6lVTrBxeZPwia5DPaoZf9AuXRGXTJe+LAly8bh0nCkCaJXpRy
	 gtiqGKF122MQYR1+vHibsjYN3LXS6PReB5hM7+APMQef/PKfJbmCFxtyQT0H0voNLH
	 HSOMgvztVLvIA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:04 +0100
Subject: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4282; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ceXsregJOQeiQPf6PAYWpIExvMexFMwQYxKrBcvN4/M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztf/G9F4fqpwKhPTyquti1c/aoie/mDt5qzJk/o3n
 OiRrDI53VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRNWcY/ofueNnGaSAsE9ow
 Q/pZjtOVzvKr4cfmvV425Zn10Rk6T2sYGR4lKM17/HbTJjHHb7e8RaenbuR6nMZutGfxEYddod2
 vjJkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

hfs_btree_open() sets SB_RDONLY when the map record of a b-tree doesn't
mark the header node as used. That's fine while mounting. But
hfsplus_create_attributes_file() calls it too when the first extended
attribute is set on a filesystem that has no attributes file yet. That
runs on the live filesystem without s_umount and a filesystem must not
change SB_RDONLY behind the VFS' back.

hfsplus_create_attributes_file() opens a tree it has just created itself
with the header node marked as used, so there's nothing to check there.
Move the check into hfsplus_fill_super() and do it for every tree it
opens. No functional changes.

Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfsplus/btree.c      | 42 ++++++++++++++++++++++++++++--------------
 fs/hfsplus/hfsplus_fs.h |  1 +
 fs/hfsplus/super.c      |  5 +++++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index bd4dbdbc8f98..4a67569050e3 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -270,7 +270,6 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	struct hfs_btree *tree;
 	struct hfs_btree_header_rec *head;
 	struct address_space *mapping;
-	struct hfs_bnode *node;
 	struct inode *inode;
 	struct page *page;
 	unsigned int size;
@@ -381,19 +380,6 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	kunmap_local(head);
 	put_page(page);
 
-	node = hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
-	if (IS_ERR(node))
-		goto free_inode;
-
-	if (!hfs_bmap_test_bit(node, 0)) {
-		pr_warn("(%s): %s (cnid 0x%x) map record invalid or bitmap corruption detected, forcing read-only.\n",
-				sb->s_id, hfs_btree_name(id), id);
-		pr_warn("Run fsck.hfsplus to repair.\n");
-		sb->s_flags |= SB_RDONLY;
-	}
-
-	hfs_bnode_put(node);
-
 	return tree;
 
  fail_page:
@@ -407,6 +393,34 @@ struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id)
 	return NULL;
 }
 
+/*
+ * Check the map record of a b-tree at mount. hfs_btree_open() can't do it
+ * because hfsplus_create_attributes_file() calls it on the live filesystem
+ * where SB_RDONLY must not be set.
+ */
+int hfsplus_btree_check_map(struct hfs_btree *tree)
+{
+	struct super_block *sb = tree->sb;
+	struct hfs_bnode *node;
+
+	node = hfs_bnode_find(tree, HFSPLUS_TREE_HEAD);
+	if (IS_ERR(node)) {
+		pr_err("failed to load %s header node\n",
+		       hfs_btree_name(tree->cnid));
+		return PTR_ERR(node);
+	}
+
+	if (!hfs_bmap_test_bit(node, 0)) {
+		pr_warn("(%s): %s (cnid 0x%x) map record invalid or bitmap corruption detected, forcing read-only.\n",
+				sb->s_id, hfs_btree_name(tree->cnid), tree->cnid);
+		pr_warn("Run fsck.hfsplus to repair.\n");
+		sb->s_flags |= SB_RDONLY;
+	}
+
+	hfs_bnode_put(node);
+	return 0;
+}
+
 /* Release resources used by a btree */
 void hfs_btree_close(struct hfs_btree *tree)
 {
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 6f240f87f8ff..58c780b09b6f 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -362,6 +362,7 @@ int hfsplus_block_free(struct super_block *sb, u32 offset, u32 count);
 u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u64 sectors,
 				  int file_id);
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
+int hfsplus_btree_check_map(struct hfs_btree *tree);
 void hfs_btree_close(struct hfs_btree *tree);
 int hfs_btree_write(struct hfs_btree *tree);
 int hfs_bmap_reserve(struct hfs_btree *tree, u32 rsvd_nodes);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ff7d6b3336a6..532f23502df3 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -564,6 +564,11 @@ static int hfsplus_fill_super(struct super_block *sb, struct fs_context *fc)
 	}
 	sb->s_xattr = hfsplus_xattr_handlers;
 
+	if (hfsplus_btree_check_map(sbi->ext_tree) ||
+	    hfsplus_btree_check_map(sbi->cat_tree) ||
+	    (sbi->attr_tree && hfsplus_btree_check_map(sbi->attr_tree)))
+		goto out_close_attr_tree;
+
 	inode = hfsplus_iget(sb, HFSPLUS_ALLOC_CNID);
 	if (IS_ERR(inode)) {
 		pr_err("failed to load allocation file\n");

-- 
2.53.0

