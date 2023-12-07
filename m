Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F5D1846
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="icXNGKNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4346EC433C8;
	Thu,  7 Dec 2023 02:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916746;
	bh=73vE3NJ93/H6Dwxf65VAV+7NNxZABhsW814meJXun9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=icXNGKNK4/l1zPLhu1LA3QX+eqQ4vI6hQ4mvLY2Tbg/QL9u75XZZbGZxB1KHqbYjU
	 EIIuQIUIRiBpWrlgZ94M+Uq7NfHihdY2kReIA93Idfw8CFRuI01Gf+aUDhJcPbl6Q/
	 0qUHozUyzsxkoLLWgJgDlqabklRDnc/JviKskb0RzYHbm1f4bX8urCKNR6KqXmHzrs
	 JcdavQWFqUA5C3AQe1IyGU/nrtcHBsQkAy3LSyGTcyA5EXRyRz+m5WJQW0dcsgYK/7
	 QaBVMz4EdYImhSUdjfWMGrn4kxDRWE4aclCwV9aq4nZN7MSRNm5+IwTVKrWMsSC/yB
	 b361ZJK+i83jA==
Date: Wed, 06 Dec 2023 18:39:05 -0800
Subject: [PATCH 3/6] xfs: read leaf blocks when computing keys for bulkloading
 into node blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191665194.1180191.14732920823825360410.stgit@frogsfrogsfrogs>
In-Reply-To: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When constructing a new btree, xfs_btree_bload_node needs to read the
btree blocks for level N to compute the keyptrs for the blocks that will
be loaded into level N+1.  The level N blocks must be formatted at that
point.

A subsequent patch will change the btree bulkloader to write new btree
blocks in 256K chunks to moderate memory consumption if the new btree is
very large.  As a consequence of that, it's possible that the buffers
for lower level blocks might have been reclaimed by the time the node
builder comes back to the block.

Therefore, change xfs_btree_bload_node to read the lower level blocks
to handle the reclaimed buffer case.  As a side effect, the read will
increase the LRU refs, which will bias towards keeping new btree buffers
in memory after the new btree commits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c         |    2 +-
 fs/xfs/libxfs/xfs_btree.h         |    3 +++
 fs/xfs/libxfs/xfs_btree_staging.c |    7 ++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6a6503ab0cd76..c100e92140be1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1330,7 +1330,7 @@ xfs_btree_get_buf_block(
  * Read in the buffer at the given ptr and return the buffer and
  * the block pointer within the buffer.
  */
-STATIC int
+int
 xfs_btree_read_buf_block(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_ptr	*ptr,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 4d68a58be160c..e0875cec49392 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -700,6 +700,9 @@ void xfs_btree_set_ptr_null(struct xfs_btree_cur *cur,
 int xfs_btree_get_buf_block(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, struct xfs_btree_block **block,
 		struct xfs_buf **bpp);
+int xfs_btree_read_buf_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *ptr, int flags,
+		struct xfs_btree_block **block, struct xfs_buf **bpp);
 void xfs_btree_set_sibling(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, const union xfs_btree_ptr *ptr,
 		int lr);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 29e3f8ccb1852..ee0594a4c3d32 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -483,7 +483,12 @@ xfs_btree_bload_node(
 
 		ASSERT(!xfs_btree_ptr_is_null(cur, child_ptr));
 
-		ret = xfs_btree_get_buf_block(cur, child_ptr, &child_block,
+		/*
+		 * Read the lower-level block in case the buffer for it has
+		 * been reclaimed.  LRU refs will be set on the block, which is
+		 * desirable if the new btree commits.
+		 */
+		ret = xfs_btree_read_buf_block(cur, child_ptr, 0, &child_block,
 				&child_bp);
 		if (ret)
 			return ret;

