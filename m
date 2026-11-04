Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793821603;
	b=Gx/yTWcLg8BaKWA0SkZDxvLqZHWZsfeJCUmvWEp+fooTw+F2O1Rw82u6tq0j3ac5KkJE
	 XRzZQ8Sd5bkPrmai/Qj8l5w7SMDUkSV8dtLt0E4NzC7LukRZ+HW2b5MI9SBmq1OW3rL5h
	 Nedh+gEnoxKm6dQeHFpVG7XFtFe1LZltBk0ZNSrcRLSLeomrtUJ2gbkWbKJCgsZFbYSsj
	 pKYlhqKpJC3WXZH+mLtRrsub3U//bSetccYnUnoFbWbLSK25VlniSq6QNKa/8YaRg0ITx
	 u4c8jeBNJ7hD+6Y4YVcHynl6AMIpacdOnZ1jMuD5wyqz2KjOHW7xTh6xmpCaXl0KTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793821603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=oUcPL85ei5U4d0RhTPCHJJ3QC2Sk5WoYZJdWFp/OwSg=;
	b=THRg4BN9lHnXyX6ALtJnX/kPF5l0KEaYe7OFAqfAN0y3XpBgE3oMsPtT6/GLkGaekOXE
	 ThFQoLNbYZAWex6AVElWDzWJU2Qwj306xk0UGO5RTADtzIaU/lE5e0y0ROp2sqSwC+YHw
	 /bcFaGakYHA0uo0N8lGTHZgU5TlEDVXwGbqJeZ4qwahidOWtwoJrMxNsymewLz/7UlHXl
	 FaUOuQbJt7wgMgz2hQDlud4b5a39+I9+JMLCL9G6Fx8KeprgPyQ2QSwDNoFeFrokSDEAq
	 04FzrJziwIkk0YbJFBsuLCz24pXnyt4LsP3BQoy4hepMp0rSUquyEF/w5waUhofsaXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SGHBzpuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567B606A861;
	Wed,  4 Nov 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SGHBzpuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFCE1F000C1;
	Wed,  4 Nov 2026 19:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821602;
	bh=oUcPL85ei5U4d0RhTPCHJJ3QC2Sk5WoYZJdWFp/OwSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGHBzpuU8UnmqexhEbiWAA20uJBNcu6XuwqLQ7V1psxJSeBN44dOujaKqLosA+wgl
	 Ep6ep3fPvcC/sqScixQrr34pDRLsKuAR4Tg1iGrT/n5LrNp7j74+W9JfmXxnR46pbr
	 0y/5K0URlBPSM6hufEUI61/VbCOMwyBRwraZpkQ2tRNH46tq27rG6UttS7EpWgFeOW
	 XwCCqIpCGmMqu6yO0juELENSbdZDl2SojM/x7dzGlh/6/hSgJS86FvXJFbRkzXdUsq
	 1gbdTMSZPmiEKm0MXwsZAj9L6z0dtKv91aOHJ+RPCBij9NituK5em8kZT3Vw+oTnRZ
	 QqEHjk5GlvSVw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: ebiggers@kernel.org,
	hch@lst.de,
	fsverity@lists.linux.dev
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org
Subject: [PATCH 3/5] btrfs: use I_VERITY_BUILDING instead of private flags
Date: Wed,  4 Nov 2026 20:46:12 +0100
Message-ID: <20261104194618.103332-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104194618.103332-1-aalbersh@kernel.org>
References: <20261104194618.103332-1-aalbersh@kernel.org>
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
index b34d2247cf84..82e2ebad0d3e 100644
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
 
 	return 0;
-- 
2.54.0

