Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C001F2372
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907457; cv=none; b=XcQivolc13ghB/d2dAnGQwh3RRdkk2PbkwUBwKn++I34xsesSAgK4Fahz+udqBV+3SfWjAuLvqAv23FL/+nOj39+VQJPc4cboC2/3TQd4YNRRfSjLH3QQoWKLknV2fYEQXq25LPt3Hqu6pX2dL+BbUmC3QiglOOZnTUfu+N6rqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907457; c=relaxed/simple;
	bh=ciJ+SOaPeSItOd0CIY7iXdqLpcdbT63cluVPyrLk4nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtGo1+gayHvqw+7e61TCsi3mEGJY3X6JclEbuzDzMYZ1IjxCBTuhdPmhZVRx/G44Gk39/xrP3u7w/yJxjuJpPHI+iOV9QDdv6Elc5MoJJRVzaPKEFIiZzBekGBoypUDNqjbx8ttcr/XZZsP9s4nqjB1NNMGkelQoAjeuW7a0IG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X/lDABAG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X/lDABAG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E5RlXgfWrFB5/Lb5vk1S+pTlku8S7WbPPHMkZi0LOvc=; b=X/lDABAGy3adT5BkB9VXI1fi1D
	yrfLb+136FtRxqH6R1wpgFnKuOseuLSxSC+5RI7SwC9y5cqE8QICw6ku17WO1mfid3SOiUDvCM2K1
	4X4zR0Cpo5qhJEDHFI76xlI1fAdgRMwJSs79K0878OyIEvSmzR2rpEn2gOLfDTp/Dd+UBWghgS/f0
	Xjyp0S4j6Wnp/ydke6kTBCjROTiqYPdg0Eq8+2+2jhjqol68//d/5wb7HT+rVX4LNXA7083p7nv31
	wDxV24Pxcak5iwlq0CW/O1LZl1pEFktLUd25/0jQqJMJMBiuOIWWFSuh9zAClsV3ir32WJEKyzjUP
	tMWEd8MA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXH-0000000EJFL-1Ghi;
	Wed, 11 Dec 2024 08:57:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 21/43] xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
Date: Wed, 11 Dec 2024 09:54:46 +0100
Message-ID: <20241211085636.1380516-22-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
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
---
 fs/xfs/xfs_file.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 27301229011b..827f7819df6a 100644
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

