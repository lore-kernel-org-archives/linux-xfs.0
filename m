Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571276;
	b=G1qRdPxEtuY3hlZZAY8YSORRnTsbRbk0m6RzX0O+IENiTPKmWRzKE7OXyUHBXeWL71L8
	 gNRrBX8m2TFWPJQl9sH3nczX32vfum4CNImOdbiUqmSij9vQnAZj+Wilme2dSMYaY479Q
	 3dFgKgl2C+DNd7HrF1Zd8mK/b8nGNCWIr8a7MD9oJMwfwyuoQ6nLGryjDHXlASFKyP1n7
	 I+MXNCi776PLDcUYSfiFXbLRPN4FB6xCXZo44qhBo0xaSk6uu36MMPh+2TUQkpbeIXf2O
	 JmOG0Ymn3kUPE/DMueX8k2eHXKJ/XBIiLC0SgxnL/TnCSr1gQIBAFfg3FRm8b9TgwYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571276;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=/YHEqYzi5KXNIwRcZhn83Em4Jwz15A4c49SP6KyvpsM=;
	b=hzawbcIdwgPXXuX4JyGlSphlAAwMKW8H9/z35aq05ZiF1CjrsVMYzhZ6UD/8TzXXoNua
	 Ba61O3Uz8ngqSc8528NFmTqbdxZTOpg1GzJAoZjBr4/Lie/p0Q5gbQuB2HxQqDIKDuHuh
	 9rvotBDo2FSg3QRvLpPuwKmN/brGdusU5fia9jAHnt/72UHbZrWxbExmVJwzRoALXdCrI
	 1fJ/GKjuTN7bcYnMeklJE0jCls29AeRrHXaKu8FcJWT9+H0D/ltLWbUOsREO5rN9SPYW3
	 HM4V571RD0uBL3FIUhVsz9oE2/TJV8n8U+1OyEdmT2wghPYnr0CgS9mIol9GDsyj9QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROqB3IOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6660E60A2629;
	Fri, 13 Nov 2026 12:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ROqB3IOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127921F000C4;
	Fri, 13 Nov 2026 12:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571276;
	bh=/YHEqYzi5KXNIwRcZhn83Em4Jwz15A4c49SP6KyvpsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ROqB3IOnFwfdV8L8FloWuGRW9fzjTNujIbxsHPGc6ZIYoXTLVhTZjQqpbFYqwssfy
	 wbNG3roSn2UJqG5xX9LzWsBJLHJACFpGxTcgR4Oo/EW56SzA616NfPWYp0sNE6H8qs
	 RooXVYKq2C14UEtszL1v++YKW8z1YHN5QCZlbbX/5Hcsofc/hmAAhRiCAezMKlifUc
	 mOEqeCi9EgNkof/s0h/sg7i5wDBKeHqwFdWGnMQJ6Uz5ZsEAWwNKFwXp8jsGKphQrL
	 SiqQ/CQP2AZgJkAHZRunIRKmH4DOLqojvqPeInDh6/cJH3rNEO1Qm/l5V7N7UGuNIR
	 pkx2wvDSX1/Ww==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:11 +0100
Subject: [PATCH v3 15/33] hfsplus: don't set SB_RDONLY when creating the
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
Message-Id: <20261113-work-fs-sb_rdonly-v3-15-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4341; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hq2uWZM7C6gmK9X25gRT9szwb+uBN9yc2jOPMElC9g4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+7163lcGr3jlpaG7PNRjpKTusjD2TPE14lpWusM6e
 JWel69BRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwERmaDH8s67S7K+Y9S6t7OO2
 rerlTCLH0i5Mm6Fy0OtF6jSWNcuk4xj+GQuwbE8W2r1cRel5RZjorJrMr4tm7HtXoag+Zaan2VZ
 TdgA=
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
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfsplus/btree.c      | 42 ++++++++++++++++++++++++++++--------------
 fs/hfsplus/hfsplus_fs.h |  1 +
 fs/hfsplus/super.c      |  5 +++++
 3 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index bd4dbdbc8f98c..4a67569050e36 100644
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
index 6f240f87f8ff1..58c780b09b6f8 100644
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
index ff7d6b3336a66..532f23502df3c 100644
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

