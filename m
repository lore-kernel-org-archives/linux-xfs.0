Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C817A729
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579545; cv=none; b=C3zBbhmTdDpWTYNEiBGnq/cWDQkNqfIhzhZuLhz67+E0/6Ix2yLhubGya6P546oKqwInP9gioegiVxtjCsw/0NdbAUegNy9E54ZciP90mW4aD0VugVAPIL+uKNpMeVswBJCRW4xLRD/9k2jpkPl8lhvQM7AR0nTd0BhGu6LKxGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579545; c=relaxed/simple;
	bh=SStO3MOW2u5KsO8/UusGE2i9sPUyuTxbXlOJN7+jtOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRvGRVNlWJEVffN/J/uleJNMgevJiijI9iDKuuigQBjDVF3qth7GmShHBfimB7IYp4ZH0jgijj7Ed3vru4jMlJaMJ0MYgFuil/fRz+K9SongFWhufXs+rStTwPSoo8D4+eQRTeWwu2br20620FxHbc//ai6DALwcv+dTygHJio0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ab4Q0nzK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ab4Q0nzK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vw7Hqds3kjPV691CMfHa/B2Ot566kYEuH+bc7CPQnG4=;
	b=Ab4Q0nzKVX7BnW1CKV7ztwkY/oHvmJLluxMYBFTp7D/QeL6vrP/Rj/tDA30qiNfMdF6psV
	UFBVIlJUTlCYDejAo+CtnanvgW2SbXL5Dg0vuh6RkOW98/7sA1XygmXQFZMvlqgkZsFxkp
	dvZM2aWJ0tJAXzS2oDgARkZ7F7boySw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-h91bY7fwNYewhhuGqE1iKA-1; Mon, 04 Mar 2024 14:12:18 -0500
X-MC-Unique: h91bY7fwNYewhhuGqE1iKA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51345bb1c89so1685234e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579536; x=1710184336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vw7Hqds3kjPV691CMfHa/B2Ot566kYEuH+bc7CPQnG4=;
        b=i3QyA8tLgDjV9VC/YmoyWLPUz+iEB4J9DLlHbvhqFknyGq5iAIHH7T6qkOZfRsW/7P
         K4zq2A3cxU00kTNmc6O8/nbQcn1wg9cWzhXtqVvYKehlHKcykeyttW+hG8Fq3mZykvUZ
         NSrSKiYo7QHcXWY//4fDKC/NC+x43oFaE9dXwvPUk8uk8PStWvl57O/IngTDZlKo1sUk
         w+U64B9/nRNvXkpwUAS1JgkK/PZvA689yNi2iEU8+h9Kj9C4vgs2IR+vzyZHlmPR00da
         Pyjp8MZf/1+4+nyYsIB6ds1ncTnTO7nu6d+oAKc1p6FKWYUGQj/s4WkGJ+2NIQygdNbZ
         Pzbg==
X-Forwarded-Encrypted: i=1; AJvYcCVD/lUPHV64lxIuj5nW6dS6EZH5/t0PzZZIA1LlG4Nrw2PUtypNYNg3Rml3Gg+ZWNkWLSJJjOBJPfPXOV3Q9yvfs3RxnsayL12i
X-Gm-Message-State: AOJu0YyEOZAa8KxGv2TAOhuGTyZ8VV+v8AItwGK7E3/9Z21DXWHSK83c
	9dKRyW2DMRcMOUnodKl9iGytvyc6tv71ypG4TmSY+slGlCgDpIE3yRENKW2ZuF4g2cpTpsugc0o
	8ZdYHPOMREEmGIUrPrNEpgpGSTF+6oSglN+X/iLKOXUVXhj8qe5GLzYue
X-Received: by 2002:ac2:42c3:0:b0:513:3f16:25d6 with SMTP id n3-20020ac242c3000000b005133f1625d6mr3805654lfl.34.1709579536596;
        Mon, 04 Mar 2024 11:12:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfDSbClFcafmZzQTfNNN+PHTRYEIEdcmRoCaXYEzSwLMrvqR4HZHhRmpoF1p1meXKQT+foAQ==
X-Received: by 2002:ac2:42c3:0:b0:513:3f16:25d6 with SMTP id n3-20020ac242c3000000b005133f1625d6mr3805635lfl.34.1709579536148;
        Mon, 04 Mar 2024 11:12:16 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 06/24] fsverity: pass tree_blocksize to end_enable_verity()
Date: Mon,  4 Mar 2024 20:10:29 +0100
Message-ID: <20240304191046.157464-8-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

XFS will need to know tree_blocksize to remove the tree in case of an
error. The size is needed to calculate offsets of particular Merkle
tree blocks.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/btrfs/verity.c        | 4 +++-
 fs/ext4/verity.c         | 3 ++-
 fs/f2fs/verity.c         | 3 ++-
 fs/verity/enable.c       | 6 ++++--
 include/linux/fsverity.h | 4 +++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 66e2270b0dae..966630523502 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -621,6 +621,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
  * @desc:              verity descriptor to write out (NULL in error conditions)
  * @desc_size:         size of the verity descriptor (variable with signatures)
  * @merkle_tree_size:  size of the merkle tree in bytes
+ * @tree_blocksize:    the Merkle tree block size
  *
  * If desc is null, then VFS is signaling an error occurred during verity
  * enable, and we should try to rollback. Otherwise, attempt to finish verity.
@@ -628,7 +629,8 @@ static int btrfs_begin_enable_verity(struct file *filp)
  * Returns 0 on success, negative error code on error.
  */
 static int btrfs_end_enable_verity(struct file *filp, const void *desc,
-				   size_t desc_size, u64 merkle_tree_size)
+				   size_t desc_size, u64 merkle_tree_size,
+				   unsigned int tree_blocksize)
 {
 	struct btrfs_inode *inode = BTRFS_I(file_inode(filp));
 	int ret = 0;
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 2f37e1ea3955..da2095a81349 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -189,7 +189,8 @@ static int ext4_write_verity_descriptor(struct inode *inode, const void *desc,
 }
 
 static int ext4_end_enable_verity(struct file *filp, const void *desc,
-				  size_t desc_size, u64 merkle_tree_size)
+				  size_t desc_size, u64 merkle_tree_size,
+				  unsigned int tree_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	const int credits = 2; /* superblock and inode for ext4_orphan_del() */
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 4fc95f353a7a..b4461b9f47a3 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -144,7 +144,8 @@ static int f2fs_begin_enable_verity(struct file *filp)
 }
 
 static int f2fs_end_enable_verity(struct file *filp, const void *desc,
-				  size_t desc_size, u64 merkle_tree_size)
+				  size_t desc_size, u64 merkle_tree_size,
+				  unsigned int tree_blocksize)
 {
 	struct inode *inode = file_inode(filp);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index c284f46d1b53..04e060880b79 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -274,7 +274,8 @@ static int enable_verity(struct file *filp,
 	 * Serialized with ->begin_enable_verity() by the inode lock.
 	 */
 	inode_lock(inode);
-	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
+	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size,
+				      params.block_size);
 	inode_unlock(inode);
 	if (err) {
 		fsverity_err(inode, "%ps() failed with err %d",
@@ -300,7 +301,8 @@ static int enable_verity(struct file *filp,
 
 rollback:
 	inode_lock(inode);
-	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size);
+	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size,
+				      params.block_size);
 	inode_unlock(inode);
 	goto out;
 }
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 1eb7eae580be..ac58b19f23d3 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -51,6 +51,7 @@ struct fsverity_operations {
 	 * @desc: the verity descriptor to write, or NULL on failure
 	 * @desc_size: size of verity descriptor, or 0 on failure
 	 * @merkle_tree_size: total bytes the Merkle tree took up
+	 * @tree_blocksize: the Merkle tree block size
 	 *
 	 * If desc == NULL, then enabling verity failed and the filesystem only
 	 * must do any necessary cleanups.  Else, it must also store the given
@@ -65,7 +66,8 @@ struct fsverity_operations {
 	 * Return: 0 on success, -errno on failure
 	 */
 	int (*end_enable_verity)(struct file *filp, const void *desc,
-				 size_t desc_size, u64 merkle_tree_size);
+				 size_t desc_size, u64 merkle_tree_size,
+				 unsigned int tree_blocksize);
 
 	/**
 	 * Get the verity descriptor of the given inode.
-- 
2.42.0

