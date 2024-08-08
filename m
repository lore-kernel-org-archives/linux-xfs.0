Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0021190063
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130912; cv=none; b=jsphtmlmrbckTjghVlp/JvW3t3C1tJ7sNNwgnCUZ/7MibrJxOsNElMEXdJN7P34TFNmXkCApWENlWeISGcnig9LP54XTDH9HchAmNx74Kl2pK/Lf9BjYPc3f2agy5N9/zIoIhIGujePAXXDHQlmYA3w67sv/i7GcxBcEHLyy6QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130912; c=relaxed/simple;
	bh=qcOZrHatrdmCkh/krTR43DXipZ7oi9ssbT/lnYPzh8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0mS3t/aI9IPY6LtrvkHiON4ApnK+tARjFcAOB9K8okda6akP9uKw2+2xHJQ/z7ai8YM70zHw0aZn+MPykHrb7qdshpXRgAZYrk1hvr8PPN8G1XYT9C56cPfGOz085UZzg1CYZbh9Go68o0lF5zWvRIy2MGB6SD1tnENagMbi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xynuTrq/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xynuTrq/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6w5WKwu+GuyQYt+XcbZowmclgAuDwQMqE2g8AYeoGxo=; b=xynuTrq/025zYVxukrQeA3G+rb
	evcYnHdUDNWyvz1LEqT1nx9vTPvo7HnNuC3KWVBY0emcYTDNxbRkWgifaAfKmcPwfUgU3GlFWGtVs
	l4nD5F8gAxkOJALMpmHsfB0cFkxf8ZeGTLoeDt/YxGfTHm6NoodHEEHj43Zp7QZ7PVbr5JgjrtDB4
	vkuN/hQTQG/xROnFvFLp0EiCCuq+Y2+c0kRpKMJA39nrRZ+QRU6DmmBt5r0fCf6wYl1EaVfwXUtra
	38DIGujSG3a1CbCAIWDvPIcadHrXh3Ms6ZsjF7BEAidci0Cn0ymx2BPrwBpnt93dB0ZMkIlx76L6C
	MzQjY/2A==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc540-00000008kWL-02io;
	Thu, 08 Aug 2024 15:28:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: refactor f_op->release handling
Date: Thu,  8 Aug 2024 08:27:28 -0700
Message-ID: <20240808152826.3028421-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808152826.3028421-1-hch@lst.de>
References: <20240808152826.3028421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently f_op->release is split in not very obvious ways.  Fix that by
folding xfs_release into xfs_file_release.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c  | 71 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.c | 79 ----------------------------------------------
 fs/xfs/xfs_inode.h |  1 -
 3 files changed, 68 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4cdc54dc96862e..11732fe1c657c9 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1177,10 +1177,75 @@ xfs_dir_open(
 
 STATIC int
 xfs_file_release(
-	struct inode	*inode,
-	struct file	*filp)
+	struct inode		*inode,
+	struct file		*file)
 {
-	return xfs_release(XFS_I(inode));
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	/* If this is a read-only mount, don't generate I/O */
+	if (xfs_is_readonly(mp))
+		return 0;
+
+	/*
+	 * If we previously truncated this file and removed old data in the
+	 * process, we want to initiate "early" writeout on the last close.
+	 * This is an attempt to combat the notorious NULL files problem which
+	 * is particularly noticeable from a truncate down, buffered (re-)write
+	 * (delalloc), followed by a crash.  What we are effectively doing here
+	 * is significantly reducing the time window where we'd otherwise be
+	 * exposed to that problem.
+	 */
+	if (!xfs_is_shutdown(mp) &&
+	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
+		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
+		if (ip->i_delayed_blks > 0) {
+			error = filemap_flush(inode->i_mapping);
+			if (error)
+				return error;
+		}
+	}
+
+	/*
+	 * XFS aggressively preallocates post-EOF space to generate contiguous
+	 * allocations for writers that append to the end of the file and we
+	 * try to free these when an open file context is released.
+	 *
+	 * There is no point in freeing blocks here for open but unlinked files
+	 * as they will be taken care of by the inactivation path soon.
+	 *
+	 * If we can't get the iolock just skip truncating the blocks past EOF
+	 * because we could deadlock with the mmap_lock otherwise. We'll get
+	 * another chance to drop them once the last reference to the inode is
+	 * dropped, so we'll never leak blocks permanently.
+	 */
+	if (inode->i_nlink && xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+		if (xfs_can_free_eofblocks(ip) &&
+		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
+			/*
+			 * Check if the inode is being opened, written and
+			 * closed frequently and we have delayed allocation
+			 * blocks outstanding (e.g. streaming writes from the
+			 * NFS server), truncating the blocks past EOF will
+			 * cause fragmentation to occur.
+			 *
+			 * In this case don't do the truncation, but we have to
+			 * be careful how we detect this case. Blocks beyond EOF
+			 * show up as i_delayed_blks even when the inode is
+			 * clean, so we need to truncate them away first before
+			 * checking for a dirty release. Hence on the first
+			 * dirty close we will still remove the speculative
+			 * allocation, but after that we will leave it in place.
+			 */
+			error = xfs_free_eofblocks(ip);
+			if (!error && ip->i_delayed_blks)
+				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
+		}
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	}
+
+	return error;
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c7249257155881..a283312033e562 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1079,85 +1079,6 @@ xfs_itruncate_extents_flags(
 	return error;
 }
 
-int
-xfs_release(
-	xfs_inode_t	*ip)
-{
-	xfs_mount_t	*mp = ip->i_mount;
-	int		error = 0;
-
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
-		return 0;
-
-	if (!xfs_is_shutdown(mp)) {
-		int truncated;
-
-		/*
-		 * If we previously truncated this file and removed old data
-		 * in the process, we want to initiate "early" writeout on
-		 * the last close.  This is an attempt to combat the notorious
-		 * NULL files problem which is particularly noticeable from a
-		 * truncate down, buffered (re-)write (delalloc), followed by
-		 * a crash.  What we are effectively doing here is
-		 * significantly reducing the time window where we'd otherwise
-		 * be exposed to that problem.
-		 */
-		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
-		if (truncated) {
-			xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-			if (ip->i_delayed_blks > 0) {
-				error = filemap_flush(VFS_I(ip)->i_mapping);
-				if (error)
-					return error;
-			}
-		}
-	}
-
-	if (VFS_I(ip)->i_nlink == 0)
-		return 0;
-
-	/*
-	 * If we can't get the iolock just skip truncating the blocks past EOF
-	 * because we could deadlock with the mmap_lock otherwise. We'll get
-	 * another chance to drop them once the last reference to the inode is
-	 * dropped, so we'll never leak blocks permanently.
-	 */
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
-		return 0;
-
-	if (xfs_can_free_eofblocks(ip)) {
-		/*
-		 * Check if the inode is being opened, written and closed
-		 * frequently and we have delayed allocation blocks outstanding
-		 * (e.g. streaming writes from the NFS server), truncating the
-		 * blocks past EOF will cause fragmentation to occur.
-		 *
-		 * In this case don't do the truncation, but we have to be
-		 * careful how we detect this case. Blocks beyond EOF show up as
-		 * i_delayed_blks even when the inode is clean, so we need to
-		 * truncate them away first before checking for a dirty release.
-		 * Hence on the first dirty close we will still remove the
-		 * speculative allocation, but after that we will leave it in
-		 * place.
-		 */
-		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
-			goto out_unlock;
-
-		error = xfs_free_eofblocks(ip);
-		if (error)
-			goto out_unlock;
-
-		/* delalloc blocks after truncation means it really is dirty */
-		if (ip->i_delayed_blks)
-			xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
-	}
-
-out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
-	return error;
-}
-
 /*
  * Mark all the buffers attached to this directory stale.  In theory we should
  * never be freeing a directory with any blocks at all, but this covers the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 51defdebef30ed..6ec83fab66266a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -512,7 +512,6 @@ enum layout_break_reason {
 #define XFS_INHERIT_GID(pip)	\
 	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
 
-int		xfs_release(struct xfs_inode *ip);
 int		xfs_inactive(struct xfs_inode *ip);
 int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
-- 
2.43.0

