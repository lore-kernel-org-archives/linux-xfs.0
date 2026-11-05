Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879809;
	b=HIkY4EnNlwAQGIDBS2fZum2lUcs1ZBJD6ukXR/Q3gVWVkbsAS/vfixU+P0MXz9niBpiX
	 9AlvWASAL74LV+pSaXe8nY0O+vLGwWVHapDsg8n9/59pKiMTfS4vT7k2sQ/iuPspYruW9
	 /o5tmMPcopc2k/ZREnmP+5iF3ZFydWUPTbqwhyAO3ctEJ9mxpxR9HPMTQ2IgwS2hQAbux
	 kK4NPCexnK0NUYgiDGWmKK4tLf+xTWLLWymuLnIB3JwbNxpVJUmhqA1f5ktYwIoeAT4Sy
	 Ox/K+aWYhiRL+Q4PZEQZ//2etjsAbUcGAJhXFW86yq+JIlO2AF/s09yLJRhqdmN+40Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nLWgWt4BnslkaMJq2Nml0U4unW/O/XancfYoUJ4qlpY=;
	b=tZr79sHRXiS7NSeKiQaU6luSvw2EA7uGpTbQ33wY35l5wimylC8akeWzfikOk1B58Rnc
	 M7vftW/Jhr0izN/+DH/yZX7bmWIAtwU0FR7SD2azR1h0JVy8wDkcSiEcqDdIyGy2s1fG+
	 8kFjB0FLnjAPTzJcPidsU5AYWz1L1tX/+8CT53Qg7V8xXzOwVadJhbaAREAz9aIHOdHT0
	 35GMR7y1xlNQiC71R2G7YwX7erJv/y6GblKHgBKoyc4Ozl2FN1BnhDqUUZx6VQ/QqPMwM
	 URUlQ+qJdZDO9iNhttsr7PQL1h1Z4TbnK6Z7kuYe86H7NIywkTbs5eFLoNqt7SHat2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7mdH2Hw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3CA606A32E;
	Thu,  5 Nov 2026 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7mdH2Hw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81EF1F00A17;
	Thu,  5 Nov 2026 11:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879809;
	bh=nLWgWt4BnslkaMJq2Nml0U4unW/O/XancfYoUJ4qlpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7mdH2HwkOWECtcq+fuA5uoIYOF4T04KVSxvtXk6Sbqc1V8qzVSDWMd+BXpJ/tGPC
	 h1Dab8z+24a8iLJeiijSWRzyDMnD39afB9QzMxB1xt2VndJtB/dW7ialpENcmDUYXI
	 NQULeSdbg0dRdw2c1i8QgxnJ0wWREYiywTytiABFPTIXBqnwW2fNCHg0GRGDWNv7ai
	 liTnSxEbfj4Za1enqG0/SSQnnv8Dyy3Nr1/BJ46Ax7afK7ltl/ts/2HfT5ztrB8v7R
	 mnbWoF5MmRPETcrFqXV/K0rpUKAhpB9lRpWnoQqsQsEO6jVxEA6c5FQpHTe2liMtPb
	 nHSZrAEJXf2MA==
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
Subject: [PATCH v2 2/5] fsverity: add I_VERITY_BUILDING inode state flag
Date: Thu,  5 Nov 2026 12:55:27 +0100
Message-ID: <20261105115532.613467-3-aalbersh@kernel.org>
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

Every filesystem that supports fs-verity keeps a private runtime inode
flag meaning Merkle tree is currently being built *_VERITY_IN_PROGRESS.
They all serve the same two purposes: reject a concurrent enable with
-EBUSY and let the write paths recognize the special writes done while
the tree is under construction.

Hoist this flag into the VFS as a new inode state flag,
I_VERITY_BUILDING, and manage its lifetime in the generic fs-verity
enable path. The flag is set after ->begin_enable_verity() succeeds and
cleared after ->end_enable_verity() returns (both on the success and the
rollback paths). Add the concurrent-enable guard.

A new helper, fsverity_is_building(), is provided for filesystems to
query the flag. No filesystem uses it yet; the per-fs flags are
converted in following patches.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/verity/enable.c       | 22 +++++++++++++++++++---
 include/linux/fs.h       |  6 ++++++
 include/linux/fsverity.h | 21 +++++++++++++++++++++
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index fe8493280b77..65d3571c62b5 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -229,13 +229,23 @@ static int enable_verity(struct file *filp,
 
 	/*
 	 * Start enabling verity on this file, serialized by the inode lock.
-	 * Fail if verity is already enabled or is already being enabled.
+	 * Fail if verity is already enabled or is already being enabled. Set
+	 * I_VERITY_BUILDING inode runtime flag which will be cleared when
+	 * enablement succeeded or rolled back.
 	 */
 	inode_lock(inode);
-	if (IS_VERITY(inode))
+	if (IS_VERITY(inode)) {
 		err = -EEXIST;
-	else
+	} else if (inode_state_read_once(inode) & I_VERITY_BUILDING) {
+		err = -EBUSY;
+	} else {
 		err = vops->begin_enable_verity(filp);
+		if (!err) {
+			spin_lock(&inode->i_lock);
+			inode_state_set(inode, I_VERITY_BUILDING);
+			spin_unlock(&inode->i_lock);
+		}
+	}
 	inode_unlock(inode);
 	if (err)
 		goto out;
@@ -291,6 +301,9 @@ static int enable_verity(struct file *filp,
 	 */
 	inode_lock(inode);
 	err = vops->end_enable_verity(filp, desc, desc_size, params.tree_size);
+	spin_lock(&inode->i_lock);
+	inode_state_clear(inode, I_VERITY_BUILDING);
+	spin_unlock(&inode->i_lock);
 	inode_unlock(inode);
 	if (err) {
 		fsverity_err(inode, "%ps() failed with err %d",
@@ -317,6 +330,9 @@ static int enable_verity(struct file *filp,
 rollback:
 	inode_lock(inode);
 	(void)vops->end_enable_verity(filp, NULL, 0, params.tree_size);
+	spin_lock(&inode->i_lock);
+	inode_state_clear(inode, I_VERITY_BUILDING);
+	spin_unlock(&inode->i_lock);
 	inode_unlock(inode);
 	goto out;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 99caef43ff3c..7c90ce09f797 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -707,6 +707,11 @@ is_uncached_acl(struct posix_acl *acl)
  * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
  *			i_count.
  *
+ * I_VERITY_BUILDING	fs-verity is being enabled on the inode: the Merkle
+ *			tree is under construction.  The file is effectively
+ *			read-only to userspace; the only writes happening are
+ *			for the fs-verity metadata.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  *
  * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
@@ -741,6 +746,7 @@ enum inode_state_flags_enum {
 	I_SYNC_QUEUED		= (1U << 17),
 	I_PINNING_NETFS_WB	= (1U << 18),
 	I_METADATA_WRITEBACK	= (1U << 19),
+	I_VERITY_BUILDING	= (1U << 20),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 61fe96ccdff6..c72edec57e30 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -164,6 +164,22 @@ static inline bool fsverity_active(const struct inode *inode)
 	return false;
 }
 
+/**
+ * fsverity_is_building() - is fs-verity being enabled on the inode
+ * @inode: inode to check
+ *
+ * This checks whether the inode's Merkle tree is currently being built.
+ * While this is the case the file is read-only to userspace and the only writes
+ * allowed are for the fs-verity metadata. This becomes false when fsverity
+ * metadata is fully created and written to disk or building failed.
+ *
+ * Return: true if fs-verity is being enabled on the inode
+ */
+static inline bool fsverity_is_building(const struct inode *inode)
+{
+	return inode_state_read_once((struct inode *)inode) & I_VERITY_BUILDING;
+}
+
 struct fsverity_info *__fsverity_get_info(const struct inode *inode);
 /**
  * fsverity_get_info - get fsverity information for an inode
@@ -217,6 +233,11 @@ static inline bool fsverity_active(const struct inode *inode)
 	return false;
 }
 
+static inline bool fsverity_is_building(const struct inode *inode)
+{
+	return false;
+}
+
 static inline struct fsverity_info *fsverity_get_info(const struct inode *inode)
 {
 	return NULL;
-- 
2.54.0

