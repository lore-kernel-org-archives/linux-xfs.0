Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02899137747
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798086; cv=none; b=X4h/3GouHcvgGHKfpUW90QQTQq9+ROuap2rhW9QHd41KwjebjZna9XroX80HkL5wYlec6idM+Q+f+TeCTOwJqjkXns5cYlrxf9DNCAk9Tx6KUq2Rm0KSzRf8I7E44ljTG8Rb0Zxf045wpMvox99dYkQgchP0in04H5uM3g7IHc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798086; c=relaxed/simple;
	bh=DdtYINDZM5wGmVXu51JHWF6Anl5VtYuMryRZQnrB2xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcfDpXGlD+SqBWs9JZJItG+tuju7inHGD6HL9SQdPD2nldZ+F4EIh0aBlFUn977Fdv0gJ3b+QpZt0EZEP7H22TGQOJYDQ1HJweQV0ppiUbcmRksx01CUVZOuDNBlCvbWnpMPod9SCEbHtF8eiijeq1L2dBuQ4b2b2fdrR1eEBH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XrXlPZxK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XrXlPZxK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Suebk8GsbhsPBL6Nuhd26f4hiVv4BZ2QhO/e8BDsq+A=; b=XrXlPZxKGY/m/YKSjNnOHLObcd
	xWcSa4P6RkUaOPXnUPVKyD9Ydb7GmldlwEUFklfvvdQ0VyimOvuwAXkqNRtmwBsZe3zSds9PjH7sT
	Yf+rLN+D50zyvs+x7c2bfi0JXpFu/GmHCFNMWCNZsvpQoofjZ8bw5ayQIlpuHctgAl4PUJWNOE2Ze
	qtBuHvP1QxzbwJPbFut32ni/RJ35jbLg8PEoYUCAR0702x3kqZ1r/MDfVzmK3pdCBqfhQniKd/PdS
	srRWQ1vpg20fC+cXRcQA6YqOpOmn8PS32dNnmxM783Jk37Uw4F8sILHgJlxNzkUEXLxBXkdcWB0Xy
	OPLxDzew==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJttk-000000014Qr-1D3i;
	Wed, 19 Jun 2024 11:54:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: fold xfs_ilock_for_write_fault into xfs_write_fault
Date: Wed, 19 Jun 2024 13:53:56 +0200
Message-ID: <20240619115426.332708-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240619115426.332708-1-hch@lst.de>
References: <20240619115426.332708-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the page fault handler has been refactored, the only caller
of xfs_ilock_for_write_fault is simple enough and calls it
unconditionally.  Fold the logic and expand the comments explaining it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 62a69ed796f2fd..05ea96661c475f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -227,21 +227,6 @@ xfs_ilock_iocb_for_write(
 	return 0;
 }
 
-static unsigned int
-xfs_ilock_for_write_fault(
-	struct xfs_inode	*ip)
-{
-	/* get a shared lock if no remapping in progress */
-	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
-	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
-		return XFS_MMAPLOCK_SHARED;
-
-	/* wait for remapping to complete */
-	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	return XFS_MMAPLOCK_EXCL;
-}
-
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -1294,18 +1279,30 @@ xfs_write_fault(
 	unsigned int		order)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	unsigned int		lock_mode;
+	struct xfs_inode	*ip = XFS_I(inode);
+	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
-	lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+	/*
+	 * Normally we only need the shared mmaplock, but if a reflink remap is
+	 * in progress we take the exclusive lock to wait for the remap to
+	 * finish before taking a write fault.
+	 */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (xfs_iflags_test(ip, XFS_IREMAPPING)) {
+		xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+		xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+		lock_mode = XFS_MMAPLOCK_EXCL;
+	}
+
 	if (IS_DAX(inode))
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
 		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
-	xfs_iunlock(XFS_I(inode), lock_mode);
+	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
 	return ret;
-- 
2.43.0

