Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190040;
	b=wt+0Jcy4v+EeU9jO79fKqvrdcvBUT0wIacEQhGFZS+y30L6Sha/3+XsI+tMOgJQSEKWS
	 h5mDBmxcl2HO5lsLNeppntPs++UyJw1Sor/tPuT4aOPn34OC8JtkPQgu4eWf1aZuVd23v
	 OG4HTqJQkk3qjfQSbEFWaNzsqtT4DqZedcq4M/LRIWwG8tmBrICNHM2NomECIWuIHUiIv
	 ZZUMqNyhbysw1vdNPncyCGnmC96JBoq75dq4WSZDrbuOS7ZL/1QGzRr4JjAeyymYteV6v
	 L1E6YzjLtvN4767UU4kzyuo5zakkUbt2pW5F+bVCwAZpmoc8MOEijdRtZEZRxRmriIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jgJExFJD0MvkSRlPMmIUjXU/tY14HBrHfd9zhs/d7KI=;
	b=vGCmKTkBUgTJCuxuukbqGMdQk+CCiWuJZUQPyiY7pKCZJqEvgFXbcG1pCHs9P87TYUlW
	 qArh8Zs6T/AHpnRf17cdrExvkwvuZUEUB5xK36S5pokq8pqGbjAUPqRAbFERFZcfvWhsM
	 DLFNBKHoeG3rydk+hUoiTqHR+ykY85FIhb0ytkWYSAfpG2Bs+r5hYKEJqM8yANNnuR6qp
	 6M4l5FnNk0akkKcqr0M4z9HrDvfzh37o3oeti/06SzDAwpQ3RRCkZkWriU9dURjKDlVSA
	 B4A6v0wW6DcdQ69fKs5VR4Owsr7WbkRafa4h8qojrd1W4VhgVfptIZDoS4F7GEqLUsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="W/uUqSwQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C2606A33D;
	Fri, 20 Nov 2026 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/uUqSwQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC21F000D4;
	Fri, 20 Nov 2026 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190039;
	bh=jgJExFJD0MvkSRlPMmIUjXU/tY14HBrHfd9zhs/d7KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/uUqSwQlEGBX2CWp8jRHad+I9Pl0CqzqlEEeV39pfTU4xLAJBP2uP9dJ7bGAMgYQ
	 /ePlnFAyKU8b6ZbL9pRNJr49r70/a2cSmBpA4hP8e1cNG7vKD8lG3RS2dth1sRYAhv
	 IPfd6UGUJKs8S2EwkY+FFtVtYBjmW968Bzr+hrL5JiqLPr5Vo5VVFIiioIX89UCmgu
	 oidgWZU6oQi7hhL3J1U8awMs+njO5uToVzKOb8KS1aKjhD6ML9DsaM/+DX+gKALYqS
	 Vo02m+yAzs2n2KHLHUJI1QmpbjqhqeJ8uGPXTdD66YO0/g+aWIuuUPhyAE6lpN1mbx
	 B3Vfi1spvCIMw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/7] fs,fsverity: add I_VERITY_BUILDING inode state flag
Date: Fri, 20 Nov 2026 16:50:25 +0100
Message-ID: <20261120155032.187246-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155032.187246-1-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/verity/enable.c               | 22 +++++++++++++++++++---
 include/linux/fs.h               |  6 ++++++
 include/linux/fsverity.h         | 26 ++++++++++++++++++++++++--
 include/trace/events/writeback.h |  3 ++-
 4 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index fe8493280b77..d820c8d348ca 100644
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
+	} else if (fsverity_is_building(inode)) {
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
index 5c62a968fbde..3bf953351e11 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -708,6 +708,11 @@ is_uncached_acl(struct posix_acl *acl)
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
@@ -742,6 +747,7 @@ enum inode_state_flags_enum {
 	I_SYNC_QUEUED		= (1U << 17),
 	I_PINNING_NETFS_WB	= (1U << 18),
 	I_METADATA_WRITEBACK	= (1U << 19),
+	I_VERITY_BUILDING	= (1U << 20),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 61fe96ccdff6..e02f79682e33 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -36,11 +36,12 @@ struct fsverity_operations {
 	 * @filp: a readonly file descriptor for the file
 	 *
 	 * The filesystem must do any needed filesystem-specific preparations
-	 * for enabling verity, e.g. evicting inline data.  It also must return
-	 * -EBUSY if verity is already being enabled on the given file.
+	 * for enabling verity, e.g. evicting inline data.
 	 *
 	 * i_rwsem is held for write.
 	 *
+	 * I_VERITY_BUILDING is set on the inode for the duration of enabling.
+	 *
 	 * Return: 0 on success, -errno on failure
 	 */
 	int (*begin_enable_verity)(struct file *filp);
@@ -164,6 +165,22 @@ static inline bool fsverity_active(const struct inode *inode)
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
+	return inode_state_read_once(inode) & I_VERITY_BUILDING;
+}
+
 struct fsverity_info *__fsverity_get_info(const struct inode *inode);
 /**
  * fsverity_get_info - get fsverity information for an inode
@@ -217,6 +234,11 @@ static inline bool fsverity_active(const struct inode *inode)
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
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 13ee076ccd16..6d0473d0f270 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -28,7 +28,8 @@
 		{I_DONTCACHE,		"I_DONTCACHE"},		\
 		{I_SYNC_QUEUED,		"I_SYNC_QUEUED"},	\
 		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
-		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"}	\
+		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"},	\
+		{I_VERITY_BUILDING,	"I_VERITY_BUILDING"}	\
 	)
 
 /* enums need to be exported to user space */
-- 
2.54.0

