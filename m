Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7A420E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120975; cv=none; b=b1HQmeHwD5l1KipyKaACtE4nWz87tvONVPZqVi8iHzgEl04LiRedm8m+VH8cpBXUYPoDTQuNfYnrhLtHxHGw2ODI4wOltXl/43Svzqv313zm3IHvB+9vJPqhy7yhaTrj6arkfBApe47To0W9Tp+Ryfz5O1VIFy6dEOM1lB/Mgo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120975; c=relaxed/simple;
	bh=WqjiBkyJ/60e0YSpL9HzdpggI73cWZ10IYoqiICgLfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGTd1eJ+EAUpuO2IBMcV8tmc9Tf3qDkqTDDEnfQxWOAlsITk06g21qZgRYDL49xaqXbnv+ATljCuxyCdcEAkhXFzdr81JznCXd/LVCbZAMo/anXA7n3nWIm54fk8TJtlCayBZ9N/0KwV3zWJDhMitayJkuNkEfJ8AXYNt2K/E/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yyOW0WEf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yyOW0WEf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oOXV51C19r2ZeIRrSLS8NeZk0+Avh6JI8o9XXm0djkM=; b=yyOW0WEfe8TciTo4kyPiEABfVA
	L9iT627F7EtNIyflfIvxZ8VcPx7fMCCWL0ly4OwGVk1+da1vUT1pXbUML531xkCp7qggmQHb80qR5
	wI+ywbsMb5lbb7rgGIhsGRJAOW9xObdx+gYhrRcCypZUrlmcadEptUzllgUXcu5NNjzRiy9JtyUY9
	0Zv1FHDM1YcUQISXXTVzfZLyWUKdBF+yCp/ZOczDXp2LodG9VJl6fVXWyDBzLIKJtSewRrfk+MhQc
	vrbrXjaknqmktwB0GsIKoBA35+JJ81vG2OxXZMSrvU5+j+K4HqPxA9+exQr/ucxqo5Zl2iZ0UJmSs
	bAcJr8rg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtd-0000000DOKq-1j94;
	Sun, 23 Jun 2024 05:36:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs: reclaim speculative preallocations for append only files
Date: Sun, 23 Jun 2024 07:34:55 +0200
Message-ID: <20240623053532.857496-11-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
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

Another commit (dd9f438e3290 in the xfs-import repository) late extended
that flag to also report these speculation preallocations which should
not exist in getbmap.

Remove these checks as nothing XFS_DIFLAG_APPEND implies that
preallocations beyond EOF should exist, but explicitly check for
XFS_DIFLAG_APPEND in xfs_file_release to bypass the algorithm that
discard preallocations on the first close as append only file aren't
expected to be written to only once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 12 +++++-------
 fs/xfs/xfs_file.c      |  4 ++++
 fs/xfs/xfs_icache.c    |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 52863b784b023f..aa924d7cd32abd 100644
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
index 1903fa5568a37d..b05822a70ea680 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1231,6 +1231,9 @@ xfs_file_release(
 	 * one file after another without going back to it while keeping the
 	 * preallocation for files that have recurring open/write/close cycles.
 	 *
+	 * This heuristic is skipped for inodes with the append-only flag as
+	 * that flags is rather pointless for inodes written oly once.
+	 *
 	 * There is no point in freeing blocks here for open but unlinked files
 	 * as they will be taken care of by the inactivation path soon.
 	 *
@@ -1245,6 +1248,7 @@ xfs_file_release(
 	 */
 	if (inode->i_nlink &&
 	    (file->f_mode & FMODE_WRITE) &&
+	    !(ip->i_diflags & XFS_DIFLAG_APPEND) &&
 	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip)) {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9967334ea99f1a..0f07ec842b7023 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1158,7 +1158,7 @@ xfs_inode_free_eofblocks(
 	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
-	/* inode could be preallocated or append-only */
+	/* inode could be preallocated */
 	trace_xfs_inode_free_eofblocks_invalid(ip);
 	xfs_inode_clear_eofblocks_tag(ip);
 	return 0;
-- 
2.43.0

