Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB015820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479596; cv=none; b=kQZhc5Cdow90IdEy8YFS7+ezTOr6oOg2D/XfpjPcBJbcnXCgPFPx27+puKEU4OvHgVYMqai6PxJ2BghT6qnRmI6EDUAzePFjHAFd+slZKpm6dqcsj42VI9F4y9H0mQIyfuj3uyU/kXSE0iSevQHhJ6BVa03kb9SyuqrCAzHcqMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479596; c=relaxed/simple;
	bh=clwKI/CoxNJf6c+DASnqNhBJAYjjidaK4A5ZxUeAbJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVj0wJJXS6JB9YIc7MTt8dnfUEYge8k48TmsTqWpBe/pz5MVONEgMHIc6KUteE/SQgUrv42OljPhvNb3W3pPJOj/ujmoFPBN/1p3ItdsY+vs7lvq50xpjKAqAbKv45GBFe7ien1WQDTY6UrJocYiekl9eZ5DQEZfc3SiRSG8nZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dSj12onI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dSj12onI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fDcnlmN5z1C4hB5ZDM4Cxn9hBX+7G2B1kPIQLTQvAnA=;
	b=dSj12onIHacZyJwarCVt/7+KBS6vsMIMFc+sxIO2Xi2CYj9EOqzfwelOYzQqjQJzsOKLcE
	3pJlPyZShp7S7Ua+GTv7rkzr7kyG4SPjgXHdKYhNuY+7Uo0lcjp9o3gr3lfs6I0pi0RAlx
	DxJ9gh6nUaO+TJXa+omlNFl3yJjR8u4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-Gztw198GNHCjgJCfyr-4gA-1; Sun, 29 Dec 2024 08:39:52 -0500
X-MC-Unique: Gztw198GNHCjgJCfyr-4gA-1
X-Mimecast-MFC-AGG-ID: Gztw198GNHCjgJCfyr-4gA
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3d2d60d3fso967357a12.3
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479591; x=1736084391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDcnlmN5z1C4hB5ZDM4Cxn9hBX+7G2B1kPIQLTQvAnA=;
        b=YSUunYCUliQFJTS+KQc1FKIGRIQMUT10bK69ov3NoYW9Yrw8151vQTF2aI2h1R/C1d
         Lwt0Vbwh8JG4I4GHflxhAveIwItRz831jR7ifGOMlKE2A4t4CQtwN+Plgfuj/Ll3TYdS
         PugBgvg/dzLSWgi09WllTtJNzxZdFDdSKIrkaOoSgVQs+VR5eLIGUr5bu69pscx2ICwa
         O9EkfkAYAyhuZG6lWzKjkkNwnnJvwQpYo4UiKyyHJ/vNvAinVEp1hig+XpxCv/4B/6I7
         FhEarCcaWr/26z9Dk9XM13ommO1SdrowxqwnhHn9lpzYSXjgdtlOho6GpNwb1/Z0UexC
         urQw==
X-Gm-Message-State: AOJu0YwlPZUhY5Z9wMM/3wXsnrWg4Rq/lLaeH5pZ3SaeJmQ2+2f6x9/1
	ztjpVjeVaV3FVhgHaV4AmvhxhY+MY5jnUMb1mayeZ2MDmYioubmqiyDrysCFuL8+GKA8L+HoZTh
	BMjsqDOAv+8ptvdgPjjkRFhxGpVoYR9whTcbb2Ylaz4dgeVWK2N/DqwaECKmiV0w4U83omA8aSm
	TgXGXx1c4kuQp0e7ZvGhXJ9vrrSX7JjYiEagyMFdF6
X-Gm-Gg: ASbGncsdpXuSDOrlOlNJ/N/jyzMnUp6AZqemb/jYM2rj8um79DfpQRuJmMBz5W8DrlP
	9YcXTfa+8hfTRTfHq0fSeeTxbo2oAHlyTKuNGlOZGuDJA6I1oXdwNpDfjlZs5sauVx6MkUV6W8M
	zCJQiaMzjcz6nM1IyxF25ArUeD6f3X03DIhImOZjPdYbkxkz8UD0I583+5AcSzrxUV8Y2k+pR4b
	afN0V7ckRNhH+65zoX4G7AodkFxXey58n2NZWElwljbiJkK+fNOfulVeMQhkQTuwkuMNEZRzyLl
	sw6ujgLxE5/rZcc=
X-Received: by 2002:a17:907:60d2:b0:aa6:7933:8b26 with SMTP id a640c23a62f3a-aac27028437mr2740263866b.9.1735479590755;
        Sun, 29 Dec 2024 05:39:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiJTMEbj1ID4N+/KKZfTGw2gL2g2DEqKO8pQbk9R0BxpuRcesrZO47vcvoKyxWw5kTem9TGA==
X-Received: by 2002:a17:907:60d2:b0:aa6:7933:8b26 with SMTP id a640c23a62f3a-aac27028437mr2740261566b.9.1735479590363;
        Sun, 29 Dec 2024 05:39:50 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 02/24] fsverity: pass tree_blocksize to end_enable_verity()
Date: Sun, 29 Dec 2024 14:39:05 +0100
Message-ID: <20241229133927.1194609-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@redhat.com>

XFS will need to know tree_blocksize to remove the tree in case of an
error. The size is needed to calculate offsets of particular Merkle
tree blocks.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: I put ebiggers' suggested changes in a separate patch]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/btrfs/verity.c        | 4 +++-
 fs/ext4/verity.c         | 3 ++-
 fs/f2fs/verity.c         | 3 ++-
 fs/verity/enable.c       | 6 ++++--
 include/linux/fsverity.h | 4 +++-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index e97ad824ae16..dc142c4b24dc 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -620,6 +620,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
  * @desc:              verity descriptor to write out (NULL in error conditions)
  * @desc_size:         size of the verity descriptor (variable with signatures)
  * @merkle_tree_size:  size of the merkle tree in bytes
+ * @tree_blocksize:    the Merkle tree block size
  *
  * If desc is null, then VFS is signaling an error occurred during verity
  * enable, and we should try to rollback. Otherwise, attempt to finish verity.
@@ -627,7 +628,8 @@ static int btrfs_begin_enable_verity(struct file *filp)
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
index d9203228ce97..839ebf7d42ca 100644
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
index 2287f238ae09..ff9308ca04aa 100644
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
2.47.0

