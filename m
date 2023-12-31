Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780FBC126
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+a/0RsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46727C433C7;
	Sun, 31 Dec 2023 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060154;
	bh=D7G2GX0Elm2gYgsNnqDDnk94iKISGvSZYKbOG57q4M4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s+a/0RsH/3V2qs8aYY3RteX1NO0O1mNy+gb8d66ScYk/WemyP7YRr/n8cvCa79eS8
	 pwu7dAlrYMEaqu6Se61ABDbAuwfdKmTjyx7zsOf1x56uvWlNo34o32y+X8rxJk1Eyo
	 mmhzrPDgMb6VZB9stuzgnyY7LKk3vO0de8eFOubq16YgYz5S1nh/iy9SgIDpSriwth
	 EZ/6T+osa6QoFyB9mjjtLDVLPYlVIy5B60hK3CEGWUElJPF1crUuJTURcyO8f35uzs
	 PZx4OTJbpazfVrV+YY61RUDz4+MJBvV+3PsomiKLJXN7uxFV+H6F13LelTYW9EidWR
	 +IlwpptTiRnzw==
Date: Sun, 31 Dec 2023 14:02:33 -0800
Subject: [PATCH 1/2] xfs: capture the offset and length in fallocate
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404855529.1769925.7811199281495779410.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855508.1769925.12296060252141719128.stgit@frogsfrogsfrogs>
References: <170404855508.1769925.12296060252141719128.stgit@frogsfrogsfrogs>
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

Change the class of the fallocate tracepoints to capture the offset and
length of the requested operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    8 ++++----
 fs/xfs/xfs_file.c      |    2 +-
 fs/xfs/xfs_trace.h     |   10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a3b987fafcce6..72abd62d40607 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -826,7 +826,7 @@ xfs_alloc_file_space(
 	xfs_bmbt_irec_t		imaps[1], *imapp;
 	int			error;
 
-	trace_xfs_alloc_file_space(ip);
+	trace_xfs_alloc_file_space(ip, offset, len);
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -1014,7 +1014,7 @@ xfs_free_file_space(
 	xfs_fileoff_t		endoffset_fsb;
 	int			done = 0, error;
 
-	trace_xfs_free_file_space(ip);
+	trace_xfs_free_file_space(ip, offset, len);
 
 	error = xfs_qm_dqattach(ip);
 	if (error)
@@ -1152,7 +1152,7 @@ xfs_collapse_file_space(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
-	trace_xfs_collapse_file_space(ip);
+	trace_xfs_collapse_file_space(ip, offset, len);
 
 	error = xfs_free_file_space(ip, offset, len);
 	if (error)
@@ -1222,7 +1222,7 @@ xfs_insert_file_space(
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
 
-	trace_xfs_insert_file_space(ip);
+	trace_xfs_insert_file_space(ip, offset, len);
 
 	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
 	if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f2dd4daaa4e24..36ccec461e2a4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1150,7 +1150,7 @@ xfs_file_fallocate(
 			 */
 			unsigned int blksize = i_blocksize(inode);
 
-			trace_xfs_zero_file_space(ip);
+			trace_xfs_zero_file_space(ip, offset, len);
 
 			/* Unshare around the region to zero, if needed. */
 			if (xfs_file_write_needs_cow_around(ip, offset, len)) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9ea65cd65d4af..7b3abcabbafb6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -831,11 +831,6 @@ DEFINE_INODE_EVENT(xfs_getattr);
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
@@ -1629,6 +1624,11 @@ DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
+DEFINE_SIMPLE_IO_EVENT(xfs_alloc_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),

