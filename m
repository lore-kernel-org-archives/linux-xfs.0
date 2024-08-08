Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CC6190499
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130911; cv=none; b=YJlW/um0hQ1oiS5CFoMt+aL7MfHKBRN1CbK/aLBhdjPqaX+i3+lIvNjnGUl+fl5HiLuzvKxWPolml0dKECqF1K+NNg41y6vIXakTpy6tPSFYgRBe+kRSaYmgts+UCa2S+WrgiwOxqXLcjRaoQKuTAvLMG7ZmZzujPJMhAY/SRc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130911; c=relaxed/simple;
	bh=5+UUpO6S3VmYBhsgLAtVjzH/JvKZ0+Pe4F6dRl0KP74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaM22BVZ+KzqH+Goalpsi0zmo4nUTI4hrV5tgJH/Y6oPWldByTFyRZrn+BkkUEzaGnzXbyUnxLlOcl5aoA9ZtwBsGYZWM4Xsgbr85oqnDGZASqmvjeGIWshOxsFphuoZHnLMe4UXnn5amMr3nZ9jl71fGWpxHcm0Ue68MwOV3uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hhcSD/0Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hhcSD/0Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=V5j5VFzmWrk70fbT2Ja9cUuW3rjTTkYJ4FQrPgYIQjY=; b=hhcSD/0ZICyzdW0uLHG6f6EPVb
	KDi9EulwySEswPlhFP7B8AtQu6+U+ytwUHNp0FoK7mOGYk6vPpdJMYvlKZzaysdny+/YHDwGpw7j8
	u0DQv2hMpbtl8z6KFqeufwUZ4jjscsEw/ayu9ljTrf1iL3GUsuS3S/FhkpL3WFDwKavvSOKppWe69
	WyC0XEWg/bqM/4wWw+ohzY8sHuZbdpxXadGfYNYyccbU7Ly4l16jBZHPchhZZJFKDaS5SfKmKJ4Oz
	PpN9nBK9REZMh7IBrow0LHE5pnaa0x0DjOpzP0b+CbKMuIUzhmLkGma0phQC9YHJwfHyyxlDHZzPL
	PihCRsCg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc541-00000008kXW-2XKl;
	Thu, 08 Aug 2024 15:28:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: reclaim speculative preallocations for append only files
Date: Thu,  8 Aug 2024 08:27:35 -0700
Message-ID: <20240808152826.3028421-10-hch@lst.de>
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

The XFS XFS_DIFLAG_APPEND maps to the VFS S_APPEND flag, which forbids
writes that don't append at the current EOF.

But the commit originally adding XFS_DIFLAG_APPEND support (commit
a23321e766d in xfs xfs-import repository) also checked it to skip
releasing speculative preallocations, which doesn't make any sense.

Another commit (dd9f438e3290 in the xfs-import repository) later extended
that flag to also report these speculation preallocations which should
not exist in getbmap.

Remove these checks as nothing XFS_DIFLAG_APPEND implies that
preallocations beyond EOF should exist, but explicitly check for
XFS_DIFLAG_APPEND in xfs_file_release to bypass the algorithm that
discard preallocations on the first close as append only files aren't
expected to be written to only once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 12 +++++-------
 fs/xfs/xfs_file.c      |  4 ++++
 fs/xfs/xfs_icache.c    |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9c42cfb62cf2dc..0f1e3289255c2e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -331,8 +331,7 @@ xfs_getbmap(
 		}
 
 		if (xfs_get_extsz_hint(ip) ||
-		    (ip->i_diflags &
-		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
+		    (ip->i_diflags & XFS_DIFLAG_PREALLOC))
 			max_len = mp->m_super->s_maxbytes;
 		else
 			max_len = XFS_ISIZE(ip);
@@ -524,12 +523,11 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Only free real extents for inodes with persistent preallocations or
-	 * the append-only flag.
+	 * Do not free real extents in preallocated files unless the file has
+	 * delalloc blocks and we are forced to remove them.
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (ip->i_delayed_blks == 0)
-			return false;
+	if ((ip->i_diflags & XFS_DIFLAG_PREALLOC) && !ip->i_delayed_blks)
+		return false;
 
 	/*
 	 * Do not try to free post-EOF blocks if EOF is beyond the end of the
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f1593690ba88d2..f244b8e8056f66 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1220,6 +1220,9 @@ xfs_file_release(
 	 * one file after another without going back to it while keeping the
 	 * preallocation for files that have recurring open/write/close cycles.
 	 *
+	 * This heuristic is skipped for inodes with the append-only flag as
+	 * that flag is rather pointless for inodes written only once.
+	 *
 	 * There is no point in freeing blocks here for open but unlinked files
 	 * as they will be taken care of by the inactivation path soon.
 	 *
@@ -1234,6 +1237,7 @@ xfs_file_release(
 	 */
 	if (inode->i_nlink &&
 	    (file->f_mode & FMODE_WRITE) &&
+	    !(ip->i_diflags & XFS_DIFLAG_APPEND) &&
 	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip)) {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cf629302d48e74..e995e2f6152dbd 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1159,7 +1159,7 @@ xfs_inode_free_eofblocks(
 	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
-	/* inode could be preallocated or append-only */
+	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
 	xfs_inode_clear_eofblocks_tag(ip);
 	return 0;
-- 
2.43.0

