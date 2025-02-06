Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8EF2253E0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824370; cv=none; b=N4G3vHYxguzTpChA7wdGplR0FpomDyluvNPO5+0Sr7ipXlx2Us5/2kKI+oApFrRE6WtKE4eWfGyehvOaDUxk5wbqE9BB0roCuH7yyiUXGp9kmhMXflvqvGi9CcAyruZFbDqDOfGy7v9s4KbDPrbKT0PVCMNVapkxcJpX6bpPU8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824370; c=relaxed/simple;
	bh=aWDUBiSZHNRonv1APT6cmRgVH3Xc8sXmLh0W847Jo7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nczTD4MeJkTRnPcEzpg4Z6L83LzV4MGcbsTzN+IOwGwGeCNP6TXRWrTDDYvpI38xgX8a53x6CxxtqTBO9gX06ceod5g7N640zYoWS4dKHC2YeyFrg7Kh3YIrR+9aoEu2WLbnamBZM17XiqBj5H6dqnBpjYNV4JvKCyPTInFkDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pJ22jIjg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pJ22jIjg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ii2kLU5VNjG+NQwuQnfj2ULC9V4U4sdnq1UuwRsSwv8=; b=pJ22jIjguUK3QeFX22EN4M1940
	XlmbS+1yAxMj0TEOAEsueINp35cmN9xwv7HreWhZP4jWB+3L1kLx8p/orS4FNSSrnorYZtd91LMVs
	DgdRbpZXa/8Cr8LLjALDYMCOFHhVpehRSOUcW92scbrvjrO3xucZo8IuN0UqB1loNm0lsHL0U6Yvh
	odYvxkKfbQqrmytRmyuk2c3+TXbN7f4zm7BNhsPyVl/6FCHyg/5Vv8rQVgDoj6QQgDex+FTf6ZGPs
	bRx6H3eInPzFxQFZjt2u6Ekgea5rZ/rygvOwAMtaQuKqrnwIuX4eXBegwdePRlYNagCaE0tfrqPgo
	F0b4Ye7g==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfveK-00000005QLV-2tr3;
	Thu, 06 Feb 2025 06:46:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/43] xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
Date: Thu,  6 Feb 2025 07:44:35 +0100
Message-ID: <20250206064511.2323878-20-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
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

