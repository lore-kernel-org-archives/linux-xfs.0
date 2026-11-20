Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190048;
	b=oj11TjyJj1xKo2PtfwdVfqoyOUeRC8TqbbfJmEetkVZ+5eFpCvyHlOkQ97cnlG2W4jM1
	 +1hnLAT7v9cbUdjzbMvyFuBOmveAXGWYuuqvAENknmjbDzVZWHx8cQK1HHfGVyypyaq9j
	 VIiMlLrUyw3MCqv6IAmHb5rTrewC6SJVIn5TB5c23cfviUgfa4s9v8jC1wD5ckfB84ErB
	 ctRGhKZ1u2evJcs+BOYgch6Aw3wUFCJcKJpNzZKO+CA4P+zI3HLaLY+O9bqq7Fte0Ly99
	 1ZKjckQyYWVTvnZ9r/IFSoemOoq4C7aIYyjSraItjNIFsTFDwh8A7xTuu/ohDyGWWwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lizTcuSYWUIopycLWQe3gYcaIwLecJSICxRsK0lO5ko=;
	b=PhiwlFJjDHFohvng6MS9YIbiRreJl0Sox/m/QHiIqYWhkNKWEaO8JLP/XmAbhZqCQGKl
	 AxG0wfPAGWC/gsBioyNURa3Kh7YR7gpZLksGRZIcOdTIbFTj9DpyxAp24Y5+NplVsPWMu
	 6nLIwmOpFis6I+YAYIr5r4zSf+nXlmokOtkj1cscuSEj4FlAgtijXU9Scbipw2MHuoDo7
	 KOmQ0E444HjhLHT+Kj647J2Ktl9VhVsE+GVfQgpSUP+TEOy5sBq0QnM0qozsw5W6kldnL
	 BUq9ue0Zh/+uWEpU7Yvf4CxiCS5xPAJP0x2D7fVf8ZaJbEAHdQvlb4FJvjnrikVdC+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bvCCwFMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7114760A2609;
	Fri, 20 Nov 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bvCCwFMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FFE1F000D8;
	Fri, 20 Nov 2026 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190048;
	bh=lizTcuSYWUIopycLWQe3gYcaIwLecJSICxRsK0lO5ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvCCwFMhsQWRjiP1hJiUE6LV1/P46aaO5AIF6IxzeOCc14fu1mtW5JAEQfk+drYil
	 QewEclk2ajj2tnmJHjZUEkX7/xVYvP6ociRqTa+/h1GGAT+3rJ7L7g3ynC7OHvuZtF
	 7Ve7l+bbX6Ja3+vPyWvi4WyZdD5om5GroDOcfJREj9aakQ6nd0/JBF0dz3i+3+aSGA
	 8lAfF6XmGh2YXyodTtVOm7L19ruC4vMliEc8iNZfRJoTnZwFUZBmUk5si4BG5aEh1J
	 yG98zpJySaVfsH1tVnrx4ylKCHlipL8tT7f469CJ8v2wozFV2X7X43KvYFte6HjjTu
	 LQMdICwS1XB4Q==
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
Subject: [PATCH v3 5/7] btrfs: use I_VERITY_BUILDING instead of private flags
Date: Fri, 20 Nov 2026 16:50:27 +0100
Message-ID: <20261120155032.187246-6-aalbersh@kernel.org>
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

Now that the VFS tracks an inode whose Merkle tree is under construction
via I_VERITY_BUILDING and handles the concurrent-enable guard in the
generic fs-verity enable path, drop the inode runtime flags that
duplicated this.

btrfs only used BTRFS_INODE_VERITY_IN_PROGRESS internally, so remove it
outright.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/btrfs_inode.h |  7 -------
 fs/btrfs/verity.c      | 12 ++----------
 2 files changed, 2 insertions(+), 17 deletions(-)

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
index 79ace98714ad..c7eec8886e49 100644
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
@@ -606,8 +600,6 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		return PTR_ERR(trans);
 
 	ret = btrfs_orphan_add(trans, inode);
-	if (!ret)
-		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
 	return ret;
-- 
2.54.0

