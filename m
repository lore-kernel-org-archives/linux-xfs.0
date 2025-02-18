Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54331DDC07
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866373; cv=none; b=UKOZI2TAHSRrdmfeRkSgVm6l7FRFrBkmn7/srBTrzi54CHUoDHoAXAiX5/28AtUzAGc0OOzjSpD1pQbeF37sBb98cniJJrsbY2LR3/gnKmGvEoGjc7EaX79G/BCn40GIlCuhHf2fnoggpVoXvtsZ6OLPkjna6dS+5N3nuUld1/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866373; c=relaxed/simple;
	bh=aWDUBiSZHNRonv1APT6cmRgVH3Xc8sXmLh0W847Jo7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsoVEocAcJQ4r47W//+LG5sLAHF0jiKce4HL9FGJ+jigo3iYU+e8iDfPpPWy3tG9kqyQJl6Jl+QMAnVfAUXhcHUiBd3e1ixpX3FrA0jCMh3nFfRLEobLMbkqG20/XpyLVfL7OzhpyhR8QP+Xax+NBHLY8J8fc0rjZIk/5HhlEfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IgAhj/G9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IgAhj/G9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ii2kLU5VNjG+NQwuQnfj2ULC9V4U4sdnq1UuwRsSwv8=; b=IgAhj/G9/RvOlJHk1Q7NO8V8K3
	miML1lI42kiYjoy34T+5paU9nkOwg5F+YzHhJgfYy/x9zC7dR5teCcOZLLHf+9YwADeCkxRlKLFu0
	GiGU1M5vmEzvYFQYz57VZAhiwAHfqaigs2JGBxHddEFNqfZDRmmbXBbE8ccz82PT8orCBwxuX6DvH
	OqKKw7SwtUvMAIZZhu9fqqIpkMzi5U/EKB6U3M0/xDHDOK4Y4q0/ZCTR1Dh6lse66jgMwtG4yESft
	dMKwpvWZHKVsky/NOM4t8+yHoL4EVLGQ03ozeEOp6Ml1PDetWz1ODyLTMpalV7XlmTHoAtpeZxOTl
	IYQTSr9g==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIio-00000007CYK-3ncu;
	Tue, 18 Feb 2025 08:12:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/45] xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
Date: Tue, 18 Feb 2025 09:10:24 +0100
Message-ID: <20250218081153.3889537-22-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems require out of place writes and thus can't support
post-EOF speculative preallocations.  Avoid the pointless ilock critical
section to find out that none can be freed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 807e85e16a52..dc27a6c36bf7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1356,15 +1356,22 @@ xfs_file_release(
 	 * blocks.  This avoids open/read/close workloads from removing EOF
 	 * blocks that other writers depend upon to reduce fragmentation.
 	 *
+	 * Inodes on the zoned RT device never have preallocations, so skip
+	 * taking the locks below.
+	 */
+	if (!inode->i_nlink ||
+	    !(file->f_mode & FMODE_WRITE) ||
+	    (ip->i_diflags & XFS_DIFLAG_APPEND) ||
+	    xfs_is_zoned_inode(ip))
+		return 0;
+
+	/*
 	 * If we can't get the iolock just skip truncating the blocks past EOF
 	 * because we could deadlock with the mmap_lock otherwise. We'll get
 	 * another chance to drop them once the last reference to the inode is
 	 * dropped, so we'll never leak blocks permanently.
 	 */
-	if (inode->i_nlink &&
-	    (file->f_mode & FMODE_WRITE) &&
-	    !(ip->i_diflags & XFS_DIFLAG_APPEND) &&
-	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
+	if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
 		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
-- 
2.45.2

