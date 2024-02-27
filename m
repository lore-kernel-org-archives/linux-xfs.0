Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A2FBEA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000374; cv=none; b=nIPHpnDuxDAxqZYX20HGmuAzrhZo4DPz942SPjohw9o9RhgepYpbn4vS4ZPWckdTaZjYnWFTVPbqbkPjzDZkXQYu1f6rO1zW27/1YSAgKJUIhN1/gn/ZsPV2vuyWygCmj50z3xHeeSUIcFgiRbHjoCYnflxvJBjIMZcxggX7Apc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000374; c=relaxed/simple;
	bh=oeQ1V5NaKTeVChrMqWc9WTv+6Z791zrWzN1EiA2QIiY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AlHEL45F3tlYcX1ekVJEu4HpIZmj1cCr/7ZdXybhDmS8DN8b37D4KRx0b561AuP9QEZgIMiZ11gWoznN+coAM3A90X+JypQwZjYf0z7VbSLIYGAYS8ltqeF/WadhGuurD/IzW/2MExoIu5tB+SSeolW/pTNK1zZz37i/83Vsw98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CyWtiV9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CyWtiV9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513E1C433C7;
	Tue, 27 Feb 2024 02:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000374;
	bh=oeQ1V5NaKTeVChrMqWc9WTv+6Z791zrWzN1EiA2QIiY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CyWtiV9oJrEBFcy9L4OW/w0LQDzuOzMBi7k0XiVRhN/fXGlEuO3eSawPbwiYCPWwT
	 Et2IzW5QBZjox77d8E/CAklo2T+8M3KSdVrSsVPA2ycDG1hbONsHbKFuTJd+xdunqW
	 IFfR8ZZccfrJ2uWIZ5b7B3ziN9QSUXPBY8CIutfRzbvPROzqc+oVHG/LiGHLBYxrUG
	 AAnFWbkYNkKpg4lpXbIac8fyd97jiZjrBBbgnVrxWxusrZ0k7WVMuM3sXXf6C5PM/o
	 eZDgRnSZJDFZGmxEqsOHes0oDErbhMfKS19ajvDhFKZCYl/s5n7UTDsurwoT47XGIc
	 +guoiN2vmbJQg==
Date: Mon, 26 Feb 2024 18:19:33 -0800
Subject: [PATCH 1/6] xfs: move inode lease breaking functions to xfs_inode.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011149.938068.2118965709387421042.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
index e33e5e13b95f4..40b778415f5fc 100644
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
index c177e7f6ce7a3..97ad5e959f65e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,6 +38,7 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_pnfs.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -3957,3 +3958,64 @@ xfs_inode_count_blocks(
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
index 9fb404d27e710..dfa72cee2b230 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -565,7 +565,6 @@ xfs_itruncate_extents(
 	return xfs_itruncate_extents_flags(tpp, ip, whichfork, new_size, 0);
 }
 
-/* from xfs_file.c */
 int	xfs_break_dax_layouts(struct inode *inode, bool *retry);
 int	xfs_break_layouts(struct inode *inode, uint *iolock,
 		enum layout_break_reason reason);

