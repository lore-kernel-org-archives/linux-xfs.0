Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AA4C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5n/VF8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F69C433C8;
	Sun, 31 Dec 2023 22:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060216;
	bh=nHlXFrlOnfWskUxEMcePtQne5+/98Mz3Kd8ssb1mKs4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L5n/VF8FYBLfWpE6UInnkq9DB2HtvQyNraRilD+/wjZQtZSS8tIowG0hF9IED3XKU
	 omreasgL6EjhdWdxBEgyciim5V0LfisyhfRxmeoito98HhL+lsvqkv47n4vWj2zKXr
	 PJo+lmHbt1c+yORhh/x42hhzBTKKn+pQpp0b7/yrN4T285eDvn/Z4n5TV+TxTA3d7A
	 DGGkcxkT8QLh70IwTX+CZKWSWVXLfHL8exVBB2uCZ/9xIM2ScMg2CtZl9EogUSr8Sx
	 iVVMr673Ypt+0pre2yAovOKyfEKOnAgR/lHfk08FmGwmyYAWLEKO8BBWGioWx1ePTW
	 +YEWbgTsB9Lyw==
Date: Sun, 31 Dec 2023 14:03:36 -0800
Subject: [PATCH 3/4] xfs: support reflink with force align enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Message-ID: <170404855945.1770028.5046920546504611520.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
References: <170404855884.1770028.10371509002317647981.stgit@frogsfrogsfrogs>
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

Reuse the "big rt extents" code to do the necessary "COW around"
behaviors so that we always reflink entire forcealign units.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    2 --
 fs/xfs/xfs_bmap_util.h |    4 ++--
 fs/xfs/xfs_inode.c     |    2 +-
 fs/xfs/xfs_inode.h     |    3 ++-
 fs/xfs/xfs_reflink.c   |   18 +++++++++++-------
 fs/xfs/xfs_trace.h     |    4 ----
 6 files changed, 16 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 911838fbecbfb..a408c59c7852c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1283,7 +1283,6 @@ xfs_insert_file_space(
 	return error;
 }
 
-#ifdef CONFIG_XFS_RT
 /*
  * Decide if this is an unwritten extent that isn't aligned to an allocation
  * unit boundary.
@@ -1462,7 +1461,6 @@ xfs_convert_bigalloc_file_space(
 
 	return 0;
 }
-#endif /* CONFIG_XFS_RT */
 
 /*
  * Reserve space and quota to this transaction to map in as much free space
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 75d16202e2d34..887b9942123bb 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -77,12 +77,12 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
-#ifdef CONFIG_XFS_RT
 int xfs_convert_bigalloc_file_space(struct xfs_inode *ip, loff_t pos,
 		uint64_t len);
+
+#ifdef CONFIG_XFS_RT
 int xfs_map_free_rt_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
 #else
-# define xfs_convert_bigalloc_file_space(ip, pos, len)	(-EOPNOTSUPP)
 # define xfs_map_free_rt_space(ip, off, len)		(-EOPNOTSUPP)
 #endif
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3408804bee9b2..00d7c20725a85 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3204,7 +3204,7 @@ xfs_inode_alloc_unitsize(
 {
 	unsigned int		blocks = 1;
 
-	if (XFS_IS_REALTIME_INODE(ip))
+	if (XFS_IS_REALTIME_INODE(ip) || xfs_inode_force_align(ip))
 		blocks = ip->i_mount->m_sb.sb_rextsize;
 
 	return XFS_FSB_TO_B(ip->i_mount, blocks);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ea311b1fa616b..defc1965a0216 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -333,7 +333,8 @@ static inline bool xfs_inode_force_align(struct xfs_inode *ip)
 
 static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
 {
-	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+	return (xfs_inode_force_align(ip) || XFS_IS_REALTIME_INODE(ip)) &&
+	       ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
 /* Decide if we need to unshare the blocks around a range that we're writing. */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index da39da13fcd7d..90cb3f7db8c35 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1614,7 +1614,6 @@ xfs_reflink_zero_posteof(
 	return xfs_zero_range(ip, isize, pos - isize, NULL);
 }
 
-#ifdef CONFIG_XFS_RT
 /*
  * Adjust the length of the remap operation to end on an allocation unit (AU)
  * boundary.
@@ -1661,9 +1660,6 @@ xfs_reflink_adjust_bigalloc_len(
 	trace_xfs_reflink_adjust_bigalloc_len(src, pos_in, *len, dest, pos_out);
 	return 0;
 }
-#else
-# define xfs_reflink_adjust_bigalloc_len(...)		(0)
-#endif /* CONFIG_XFS_RT */
 
 /*
  * Check the alignment of a remap request when the allocation unit size isn't a
@@ -1803,9 +1799,17 @@ xfs_reflink_remap_prep(
 	if (IS_DAX(inode_in) != IS_DAX(inode_out))
 		goto out_unlock;
 
-	/* XXX Can't reflink forcealign files for now */
-	if (xfs_inode_force_align(src) || xfs_inode_force_align(dest))
-		goto out_unlock;
+	/* Check non-power of two alignment issues, if necessary. */
+	if ((xfs_inode_force_align(src) || xfs_inode_force_align(dest)) &&
+	    !is_power_of_2(alloc_unit)) {
+		ret = xfs_reflink_remap_check_rtalign(src, pos_in, dest,
+				pos_out, len, remap_flags);
+		if (ret)
+			goto out_unlock;
+
+		/* Do the VFS checks with the regular block alignment. */
+		alloc_unit = src->i_mount->m_sb.sb_blocksize;
+	}
 
 	/* Check non-power of two alignment issues, if necessary. */
 	if (XFS_IS_REALTIME_INODE(dest) && !is_power_of_2(alloc_unit)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index db463d39649b9..75bb38cd08945 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3968,9 +3968,7 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 		  __entry->dest_lblk)
 );
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
-#ifdef CONFIG_XFS_RT
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_adjust_bigalloc_len);
-#endif /* CONFIG_XFS_RT */
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
@@ -4014,9 +4012,7 @@ TRACE_EVENT(xfs_ioctl_clone,
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_unshare);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_cow_around);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_unshare_error);
-#ifdef CONFIG_XFS_RT
 DEFINE_SIMPLE_IO_EVENT(xfs_convert_bigalloc_file_space);
-#endif /* CONFIG_XFS_RT */
 
 /* copy on write */
 DEFINE_INODE_IREC_EVENT(xfs_reflink_trim_around_shared);

