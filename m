Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697A8BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQfMW+3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB77C433C7;
	Sun, 31 Dec 2023 20:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054301;
	bh=5IPZkH4tEH+efMydv2yniaEVkkEoGdLA4so10w89asg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cQfMW+3k8GPZruEP2hzm0cwQQThWrDWTSnBkiAKYhbkqX2KiLYugwi9GnvPIVJGTZ
	 EUwhrOJL6kd3ML13eSG9dRWphrX6J73jl6y1XS6eRM06h0/KTBdBt95ik8CtxNx2tC
	 oBLWVGDQjJUdDxtDa1haB9gMPDDDegqHwcDQjEsVsxRthmMEeM6Ch5ev6Wc9dgju0s
	 7wR+TNA6HIpPnZQPvuK2q27ICkWw29HZIdzYIFy1wToyMpmJJT9q39TLK7xaNMa0Kt
	 nSg85VFgzLqb1oGpE4zwkPlXEsccLgoDeWLjq/tHfllex+RL5KZmTl210d0qgBAh2y
	 aI4gHB/Vqv2Zw==
Date: Sun, 31 Dec 2023 12:25:01 -0800
Subject: [PATCH 03/25] xfs: move inode lease breaking functions to xfs_inode.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833187.1750288.6547634546701820300.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

The lease breaking functions operate at the scope of the entire VFS
inode, not subranges of a file.  Move them to xfs_inode.c since they're
already declared in xfs_inode.h.  This cleanup moves us closer to
having xfs_FOO.h declare only the symbols in xfs_FOO.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  |   61 ---------------------------------------------------
 fs/xfs/xfs_inode.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |    1 -
 3 files changed, 62 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0a38dde178738..351e00065bf24 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -861,67 +861,6 @@ xfs_file_write_iter(
 	return xfs_file_buffered_write(iocb, from);
 }
 
-static void
-xfs_wait_dax_page(
-	struct inode		*inode)
-{
-	struct xfs_inode        *ip = XFS_I(inode);
-
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
-	schedule();
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-}
-
-int
-xfs_break_dax_layouts(
-	struct inode		*inode,
-	bool			*retry)
-{
-	struct page		*page;
-
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
-
-	page = dax_layout_busy_page(inode->i_mapping);
-	if (!page)
-		return 0;
-
-	*retry = true;
-	return ___wait_var_event(&page->_refcount,
-			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
-			0, 0, xfs_wait_dax_page(inode));
-}
-
-int
-xfs_break_layouts(
-	struct inode		*inode,
-	uint			*iolock,
-	enum layout_break_reason reason)
-{
-	bool			retry;
-	int			error;
-
-	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
-
-	do {
-		retry = false;
-		switch (reason) {
-		case BREAK_UNMAP:
-			error = xfs_break_dax_layouts(inode, &retry);
-			if (error || retry)
-				break;
-			fallthrough;
-		case BREAK_WRITE:
-			error = xfs_break_leased_layouts(inode, iolock, &retry);
-			break;
-		default:
-			WARN_ON_ONCE(1);
-			error = -EINVAL;
-		}
-	} while (error == 0 && retry);
-
-	return error;
-}
-
 /* Does this file, inode, or mount want synchronous writes? */
 static inline bool xfs_file_sync_writes(struct file *filp)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 04fa933061c7d..faa3d0abf4551 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,6 +38,7 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_pnfs.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -3953,3 +3954,64 @@ xfs_inode_count_blocks(
 	xfs_bmap_count_leaves(ifp, rblocks);
 	*dblocks = ip->i_nblocks - *rblocks;
 }
+
+static void
+xfs_wait_dax_page(
+	struct inode		*inode)
+{
+	struct xfs_inode        *ip = XFS_I(inode);
+
+	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
+	schedule();
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+}
+
+int
+xfs_break_dax_layouts(
+	struct inode		*inode,
+	bool			*retry)
+{
+	struct page		*page;
+
+	ASSERT(xfs_isilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL));
+
+	page = dax_layout_busy_page(inode->i_mapping);
+	if (!page)
+		return 0;
+
+	*retry = true;
+	return ___wait_var_event(&page->_refcount,
+			atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
+			0, 0, xfs_wait_dax_page(inode));
+}
+
+int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock,
+	enum layout_break_reason reason)
+{
+	bool			retry;
+	int			error;
+
+	ASSERT(xfs_isilocked(XFS_I(inode), XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL));
+
+	do {
+		retry = false;
+		switch (reason) {
+		case BREAK_UNMAP:
+			error = xfs_break_dax_layouts(inode, &retry);
+			if (error || retry)
+				break;
+			fallthrough;
+		case BREAK_WRITE:
+			error = xfs_break_leased_layouts(inode, iolock, &retry);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			error = -EINVAL;
+		}
+	} while (error == 0 && retry);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 764d88198366d..3611597343658 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -565,7 +565,6 @@ xfs_itruncate_extents(
 	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
 }
 
-/* from xfs_file.c */
 int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);

