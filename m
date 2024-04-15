Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA050157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225105; cv=none; b=sLq89MSLjM3M8xSV3ZtwY59yn/sosOZC2x6PyMRrLEy+RKZKhM3Zd2BvQVEEM8ax6NTB/YuaxivUMMeNraL++OS71CWRd8W7dKX6Ltp5R9HuXjwZxA9/dpRKL7HHiBhKuWpSA1JjRJhnkw+RyYbyPXvEuATMTQBdWj7XTu8DV2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225105; c=relaxed/simple;
	bh=9EPBgrz/w6shq8qtoSYZ2kCt6KyMgP+QCHCse7ViZJY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F0osvgVKoPDE8EYXbKqWPivsGh3Bu/ZF7GnzUWW/Dk5QHXvoeAnGsQikmIdfYRZLUIwiu3Mjz/muj/JsBGPUSrbftZbzuHTSyPVWLYziAHlE9tiVbnWwfnmyzEikEH6kdGy9yGRl7XmO4MpV+mKkbC15ODeSgdcRAWUMBLfbK6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VkkEs3Ue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VkkEs3Ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4711DC113CC;
	Mon, 15 Apr 2024 23:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225105;
	bh=9EPBgrz/w6shq8qtoSYZ2kCt6KyMgP+QCHCse7ViZJY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VkkEs3UepO53gFnaZ/v4BfCWms/hEQQArF3AJeQufTVozLtvFCMwTPe+tGn7guPlj
	 tzyi8vZJhcZo7zLAwCZxwb5IIGgVA0qRKCQGGQ7Z3khOfhKST8VH+dBnqY/3hTM4iR
	 rtydvzqtnn2wJe3agH/7raSYxlOwgTzKEaAYQkbO6ZQ7DHOT7h4GNzwoC+AUDlu53A
	 NcE+7iu28uombANTxLDrDST+CNAJul7FwEoPnpMO6zsFMBuor+MxW0OOmO8bTxFdod
	 KjqIZ0WMmnyf9vqksQwj6E/zgDoEZAc31dNWFtBqtvGIX2JHBfL4ETDwatiLqIaST4
	 EQA46J+kp6LCA==
Date: Mon, 15 Apr 2024 16:51:44 -0700
Subject: [PATCH 1/5] xfs: inactivate directory data blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383887.89193.1150517933286068776.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
References: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
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

Teach inode inactivation to delete all the incore buffers backing a
directory.  In normal runtime this should never happen because the VFS
forbids rmdir on a non-empty directory.

In the next patch, online directory repair stands up a new directory,
exchanges it with the broken directory, and then drops the private
temporary directory.  If we cancel the repair just prior to exchanging
the directory contents, the new directory will need to be torn down.
Note: If we commit the repair, reaping will take care of all the ondisk
space allocations and incore buffers for the old corrupt directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b24c0e23d37d..09d643a9e997 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_attr.h"
+#include "xfs_bit.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -1551,6 +1552,51 @@ xfs_release(
 	return error;
 }
 
+/*
+ * Mark all the buffers attached to this directory stale.  In theory we should
+ * never be freeing a directory with any blocks at all, but this covers the
+ * case where we've recovered a directory swap with a "temporary" directory
+ * created by online repair and now need to dump it.
+ */
+STATIC void
+xfs_inactive_dir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
+	xfs_fileoff_t		off;
+
+	/*
+	 * Invalidate each directory block.  All directory blocks are of
+	 * fsbcount length and alignment, so we only need to walk those same
+	 * offsets.  We hold the only reference to this inode, so we must wait
+	 * for the buffer locks.
+	 */
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for (off = round_up(got.br_startoff, geo->fsbcount);
+		     off < got.br_startoff + got.br_blockcount;
+		     off += geo->fsbcount) {
+			struct xfs_buf	*bp = NULL;
+			xfs_fsblock_t	fsbno;
+			int		error;
+
+			fsbno = (off - got.br_startoff) + got.br_startblock;
+			error = xfs_buf_incore(mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, geo->fsbcount),
+					XBF_LIVESCAN, &bp);
+			if (error)
+				continue;
+
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+}
+
 /*
  * xfs_inactive_truncate
  *
@@ -1861,6 +1907,11 @@ xfs_inactive(
 			goto out;
 	}
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) && ip->i_df.if_nextents > 0) {
+		xfs_inactive_dir(ip);
+		truncate = 1;
+	}
+
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)

