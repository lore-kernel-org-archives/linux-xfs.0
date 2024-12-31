Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092E313FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688302; cv=none; b=U/m0W7EONlKjHYtpDvRt2cg5x/x2O+uNmUg05GjIMg/6DSWZPkfzNgd0ku+39PQ2fMyBHLr5JLXjlfY+AG+lmfD4OWIxL0mhCng43L2YQhqo6OkZN/KEfg3Vgr01BaG5b9YbVV40h9soqvkY7tPUwrrWh+iDeYAnRh+jX4Kw/4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688302; c=relaxed/simple;
	bh=MqVgvSJLFTkcGCLOJKr+k7tACSnjkpQ9NLB1k8eCDwI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=prRKJX1ByqOnTsqfPmTuZsCoIWczIrkLDGmThs31i3F33oRJSY5+Jw6dkTwx/q3AAsej0gUdEqz9ye0jBQEFzkSWgp+k1KxMGl/BgQF/N8CmPI5McpJlb4zlbcRvXygnvoZHLAGc+k5SaEW3y/eJrOP0ipV6vcyLSKBOzi4040s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S6maF0bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S6maF0bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F8EC4CED2;
	Tue, 31 Dec 2024 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688300;
	bh=MqVgvSJLFTkcGCLOJKr+k7tACSnjkpQ9NLB1k8eCDwI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S6maF0bZ5psFXG9jncATnFu71PS2YID4Im3fia2afy09/6G4kmJ7ysLbKGQWhSwK0
	 W0R0sRRnM3QU/mlG8EeF6Vu+Xc9LHVrf5Kr8mIXC6PZhWtaURK1U9eul7598l/bdn2
	 ko/LI0Sgz+i4JDBGftG2PF3syCYzuJ+RmLiu1vnRA8VCIugD3bmjHXVkE0011v4HnM
	 hTpE8JeiO5hyQSq4UY20D9M25madWJdZcaauGSQi28MC/pAv5pMUoPEAWi3RRZNdIQ
	 rpUEZ834r8T1rHrt15Syg+c+fsajB7Cpq2ovBgSJr/RRZspXWuHrqvuFvg63BSeFUY
	 anTv8LspqRKfw==
Date: Tue, 31 Dec 2024 15:38:20 -0800
Subject: [PATCH 2/4] xfs: capture the offset and length in fallocate
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754249.2704719.5267977950716130700.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
References: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change the class of the fallocate tracepoints to capture the offset and
length of the requested operation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++----
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_trace.h     |   10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 783349f2361ad3..c9e60fb2693c9b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -652,7 +652,7 @@ xfs_alloc_file_space(
 	if (xfs_is_always_cow_inode(ip))
 		return 0;
 
-	trace_xfs_alloc_file_space(ip);
+	trace_xfs_alloc_file_space(ip, offset, len);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -839,7 +839,7 @@ xfs_free_file_space(
 	xfs_fileoff_t		endoffset_fsb;
 	int			done = 0, error;
 
-	trace_xfs_free_file_space(ip);
+	trace_xfs_free_file_space(ip, offset, len);
 
 	error = xfs_qm_dqattach(ip);
 	if (error)
@@ -987,7 +987,7 @@ xfs_collapse_file_space(
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
-	trace_xfs_collapse_file_space(ip);
+	trace_xfs_collapse_file_space(ip, offset, len);
 
 	error = xfs_free_file_space(ip, offset, len, ac);
 	if (error)
@@ -1056,7 +1056,7 @@ xfs_insert_file_space(
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
-	trace_xfs_insert_file_space(ip);
+	trace_xfs_insert_file_space(ip, offset, len);
 
 	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
 	if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d31ad7bf29885d..b8f0b9a2998b9c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1362,7 +1362,7 @@ xfs_falloc_zero_range(
 	loff_t			new_size = 0;
 	int			error;
 
-	trace_xfs_zero_file_space(XFS_I(inode));
+	trace_xfs_zero_file_space(XFS_I(inode), offset, len);
 
 	error = xfs_falloc_newsize(file, mode, offset, len, &new_size);
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7043b6481d5f97..e81247b3024e53 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -928,11 +928,6 @@ DEFINE_INODE_EVENT(xfs_getattr);
 DEFINE_INODE_EVENT(xfs_setattr);
 DEFINE_INODE_EVENT(xfs_readlink);
 DEFINE_INODE_EVENT(xfs_inactive_symlink);
-DEFINE_INODE_EVENT(xfs_alloc_file_space);
-DEFINE_INODE_EVENT(xfs_free_file_space);
-DEFINE_INODE_EVENT(xfs_zero_file_space);
-DEFINE_INODE_EVENT(xfs_collapse_file_space);
-DEFINE_INODE_EVENT(xfs_insert_file_space);
 DEFINE_INODE_EVENT(xfs_readdir);
 #ifdef CONFIG_XFS_POSIX_ACL
 DEFINE_INODE_EVENT(xfs_get_acl);
@@ -1732,6 +1727,11 @@ DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
 DEFINE_SIMPLE_IO_EVENT(xfs_zoned_map_blocks);
+DEFINE_SIMPLE_IO_EVENT(xfs_alloc_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),

