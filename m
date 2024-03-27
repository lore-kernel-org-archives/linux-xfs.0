Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C5218C36
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504276; cv=none; b=o/HjSBDn9SOryKSf5dSYAqUE5YaIU7wi/llAV0r/8imoeGWfmCwYZCjrm8IHzQtN+v09APvY7o5J2lThDFUFV8S5h+Qo+Q94D0Ce4pHx++KT4hqV5ZqlS603jfIy0uNwpy6eTreDA/BPDvvfIrQv4DBJnkogzcxf8eWm2LNeTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504276; c=relaxed/simple;
	bh=5AP/RW7cDuQokxjQW9HN8Hg9qZjcEmOqpXkSPNwa4Ik=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HiJeppMe1RWk/9ORS4U66rITL8Cocw1lJ8GFWi3tqUqZm405Z6Bxp0Up2l0M6fb3YhxzTcyWkoZRQ5roefUxtyZUVxP8/z389DtwyubHS3VOEUVdVgvsMwP6iQHV5kecJvCGOxmdpE7amAYTLzudzMVUdIP3lpjVk+qsEuyw94A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkYByNnq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkYByNnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A498DC43394;
	Wed, 27 Mar 2024 01:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504276;
	bh=5AP/RW7cDuQokxjQW9HN8Hg9qZjcEmOqpXkSPNwa4Ik=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mkYByNnqVeXSjkTd3WrVFeEdYmJaEiHtNlrnr6xRJMIvU0xoO/c+bjp/9ei4Ebnrz
	 0VW6uVBNWTBJSehdpyO5au8hLOkvILZDNS2BAhROxKAfvrRAORSHYY/tapkZyJsfxB
	 a12IIxRJKL29+Zbfv0lpGoE2ntnHj+SbT1Zfib5e1E/tV4CcUkYJ4qsoiw/UYAKfWY
	 AkWcwR6RVu++9sXKt0YYjVkMFdkAd3H4GfNfXld/7VUxLUA7qTZflhHL+9/lYnG4yU
	 wYEEMWnvhbVPWu3a8RTsp/51M/V8GNhenuQpL2/jjB8WNDCcoGDg+fgWKiABdZYdul
	 kOTnPrBJNdHaQ==
Date: Tue, 26 Mar 2024 18:51:16 -0700
Subject: [PATCH 1/7] xfs: move inode lease breaking functions to xfs_inode.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380149.3216450.1216133477002365216.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |   61 ---------------------------------------------------
 fs/xfs/xfs_inode.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |    1 -
 3 files changed, 62 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 632653e00906f..40b778415f5fc 100644
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
-	xfs_assert_ilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL);
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
-	xfs_assert_ilocked(XFS_I(inode), XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL);
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
index ea48774f6b76d..b95e249cc46a5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,6 +38,7 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_pnfs.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -3935,3 +3936,64 @@ xfs_inode_count_blocks(
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
+	xfs_assert_ilocked(XFS_I(inode), XFS_MMAPLOCK_EXCL);
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
+	xfs_assert_ilocked(XFS_I(inode), XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL);
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
index ab46ffb3ac19e..5164c5d3e549c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -565,7 +565,6 @@ xfs_itruncate_extents(
 	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
 }
 
-/* from xfs_file.c */
 int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);

