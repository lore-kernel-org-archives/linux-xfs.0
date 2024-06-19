Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD5137747
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798081; cv=none; b=j1blDQjdk/fgPr2xWRfDvjYneqQwUr+pOALsTuuGGW746wRBiLJ/KJasp2yf6ohRdXIVb5lbMiLZV14iGy/dN19U1uAlKdFUyeKGCh5YYIHPQAzy/mkFW3n/e+PT3UUVIz5c60cYjaKqgwuzp7NLCtclnQD4SHiRegl+NQbjh+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798081; c=relaxed/simple;
	bh=rGnbf4TGRGvU69TcU2hVgTBuVEXASjouSSCHPPmQvJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKZjO8tT7OP08DFbavgGre3JqLSnwAOzg+dq/c7bVWbg69jRmEZ1cvUSigZCPcw60hrNk9UJ2PavDSwvoI+7XXDL5EVn8YSSL2jv5ROfAHV5/z8qnXb934QdsenAnuL2UGYI0umDCia0V9vjVT6yRyoG+ZjvwpkgWxPDT+asJhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rgfogS02; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rgfogS02"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7KWC4NC8EV1alccP+zfG8a3lNmKfjXNnX3UeU5O++hc=; b=rgfogS02S6xr39Muo54rez/UYf
	iB6G07f0QeQJvZIbLhyr1nw7RkEHa6PJKHocDaHQCTKR2XQfG21b+TY8dXH1czbl0ReW2r18jKlcI
	QQO8rOBHMaNFGBpTOJbt8QaN/ingaBxTV4798uVaXYE5xGtNPpdFAJHm7RY9yCA4uA0IOnKqaa2Wo
	Fn33wAUHWA/yXn+mgl3Ibowzp1KhIogxeqeawdm9t1aV+a05+6WhXJRzjfpJdj39lIIw0xi50a9YG
	dNpgWt4ejlmorC+bcN7vF7Q+JMlfSk0xUvH/xpHW8rATDLLZtVd3ykbfRrdRqeoWRKzyIJ+GohHse
	lFzHzKWg==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJttf-000000014Op-1ZFu;
	Wed, 19 Jun 2024 11:54:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: refactor __xfs_filemap_fault
Date: Wed, 19 Jun 2024 13:53:54 +0200
Message-ID: <20240619115426.332708-5-hch@lst.de>
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

Split the write fault and DAX fault handling into separate helpers
so that the main fault handler is easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 71 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8aab2f66fe016f..51e50afd935895 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1252,7 +1252,7 @@ xfs_file_llseek(
 }
 
 static inline vm_fault_t
-xfs_dax_fault(
+xfs_dax_fault_locked(
 	struct vm_fault		*vmf,
 	unsigned int		order,
 	bool			write_fault)
@@ -1273,6 +1273,45 @@ xfs_dax_fault(
 	return ret;
 }
 
+static vm_fault_t
+xfs_dax_fault(
+	struct vm_fault		*vmf,
+	unsigned int		order)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
+	unsigned int		lock_mode;
+	vm_fault_t		ret;
+
+	lock_mode = xfs_ilock_for_write_fault(ip);
+	ret = xfs_dax_fault_locked(vmf, order, false);
+	xfs_iunlock(ip, lock_mode);
+
+	return ret;
+}
+
+static vm_fault_t
+xfs_write_fault(
+	struct vm_fault		*vmf,
+	unsigned int		order)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+	unsigned int		lock_mode;
+	vm_fault_t		ret;
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vmf->vma->vm_file);
+
+	lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+	if (IS_DAX(inode))
+		ret = xfs_dax_fault_locked(vmf, order, true);
+	else
+		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
+	xfs_iunlock(XFS_I(inode), lock_mode);
+
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+}
+
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
  * ordering of:
@@ -1290,34 +1329,14 @@ __xfs_filemap_fault(
 	bool			write_fault)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	struct xfs_inode	*ip = XFS_I(inode);
-	vm_fault_t		ret;
-	unsigned int		lock_mode = 0;
 
-	trace_xfs_filemap_fault(ip, order, write_fault);
-
-	if (write_fault) {
-		sb_start_pagefault(inode->i_sb);
-		file_update_time(vmf->vma->vm_file);
-	}
-
-	if (IS_DAX(inode) || write_fault)
-		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
-
-	if (IS_DAX(inode)) {
-		ret = xfs_dax_fault(vmf, order, write_fault);
-	} else if (write_fault) {
-		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
-	} else {
-		ret = filemap_fault(vmf);
-	}
-
-	if (lock_mode)
-		xfs_iunlock(XFS_I(inode), lock_mode);
+	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
 
 	if (write_fault)
-		sb_end_pagefault(inode->i_sb);
-	return ret;
+		return xfs_write_fault(vmf, order);
+	if (IS_DAX(inode))
+		return xfs_dax_fault(vmf, order);
+	return filemap_fault(vmf);
 }
 
 static inline bool
-- 
2.43.0

