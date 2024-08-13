Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3158ABF
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534832; cv=none; b=KEnlInoz1Hls0eD/rJf5mv2E2xvzuUHm36wcPxe5hHb7gVLdBGfW0MTlgXTv/RutGfh8ldnh9Ivv5aDkvj96HGw2qnUZBhUd3AXfEFpGRoIkRWA0e4+vViP0QHG1H6IZ5hqxTnC06W9tFPVZYYeWnV7S4IrDg0IsWhhkhDhui28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534832; c=relaxed/simple;
	bh=IgNnX77TruHwlPbFmP1sNDl8aysBjNoJhPkOU8utgvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8coHVpMlc0iYfguRXy8SVYxa5iX10zSrv8UheiOftI7Sam5QqBLRMeQLNVsyUblFaLsS46FDk6o18P59FF2hP7JzRkdji/1IP4uPsPhI+RksN2ua83gem6kLVPhIRQ/2x48i9FEHw6ylOfrkJCQwAm0qbEqm4U6rXEEiAmvNA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=odXXh8dR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="odXXh8dR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t/6itKJSb5fga8/5T/Vx3R+vP2lP+c0eRJ48C4ZfaMg=; b=odXXh8dRiyDtM51ixyPWB9w1u4
	HU65mFGDI6mtw8XeuxRQIw6AMNpibKvgQniMoA/Pu6zg/9JbMnoydyXItuZVLoITMp7qiXSB7/+Ks
	8U4vK2SDWWg0w8T+8Pc7YGAniBwHwUNSWImNpkrHh/NIZM+4iaaj76Y/1vby3Gtkc5WwuRKX7cfJf
	KvgWf+z58F3wfhlM0AjlkdLP50ZQbI5jtTF07ZfPv/oebwU72mN4fQHwPKYi0//Yjm1sVx5ZQnCb1
	a7EUgDVmXAYH5b8tl/itH/citZyg3KoSE1x2+5NwwVgNhQIvWWdvIUbu6MMmaPGhz3GsopGZrgqcb
	FX0Y77ew==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8s-00000002lDw-0ze8;
	Tue, 13 Aug 2024 07:40:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: reclaim speculative preallocations for append only files
Date: Tue, 13 Aug 2024 09:39:42 +0200
Message-ID: <20240813073952.81360-10-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
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
index 986448d1ff3c0c..0d258c21b9897f 100644
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
 		if (xfs_can_free_eofblocks(ip) &&
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

