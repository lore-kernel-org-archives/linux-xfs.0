Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DE190049
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214747; cv=none; b=sLAX2xcKKB4/qL74//cP7jNui+8HiR5t9w9vvKU9K1SdD461F1D4SuX3+XstR2tMCfKoCPY6L57vx8HYnp6HX2qFbNqbTuphNjPbnSZ6oh8w4cWzHIrZUuPgVFF8EvieMNwTOAhJqC6rggnff2KilOV7IVRGCqi1K+2Cg7y0ljQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214747; c=relaxed/simple;
	bh=fOKLWD9ftUlx5K2yiKtmK3sXOAkSa4//Qrka9PhMHKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDHKgk9MTpaNoZV+bKJH/8JBJ17icRNW4siq98zEDC5qFabd3uFniWDZBk5y45wrEQjrlahwWuPwCwCzer5cAG31D7kXzP8UX+U8TjXN/pVEWGOuRhXI/4W7UQoPskNlQTVPQKjGKscY4lj1FhQwe4+X3JCwJigYCunqqrMGwNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QBTXWM5Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QBTXWM5Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fXNg0673JUF6JDVyKLxZbzNHZL1M1b+N09iYlJm5zHM=; b=QBTXWM5Qax3bS5KgJbkDieSp7Q
	+BYUSB8KWnvxKS/UVnccYLDL6pKJGHVvnkeBQwMrAfidhYmBHEjC6AR1JeL/fjmplefLz/7rC4Q4i
	5h4s8qodoWuyhbNWpqZI4nYKe5zU3mm+dnPqnYwFsU/Avj9Ex6b3oktFj2QKfgBBkiIoGSvIwNLB2
	1gKdI/huBdp+PuWjhZzdtNfQb80/4bAShm4eUAPWk7YX1l7QHIYShghYetRmah+IFxN34oeX+IBHy
	+1gwWZgxcWopsF9PC5Ju08I17aSxsjzHuDoDoXw2WJjX5QvqOOFG6gmkF4Q+X7ZJMygCm6LQTBrOC
	92xosp5w==;
Received: from 2a02-8389-2341-5b80-1009-120a-6297-8bca.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1009:120a:6297:8bca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ntQ-0000000EqrY-0L6n;
	Tue, 29 Oct 2024 15:12:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: split write fault handling out of __xfs_filemap_fault
Date: Tue, 29 Oct 2024 16:11:58 +0100
Message-ID: <20241029151214.255015-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029151214.255015-1-hch@lst.de>
References: <20241029151214.255015-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Only two of the callers of __xfs_filemap_fault every handle read faults.
Split the write_fault handling out of __xfs_filemap_fault so that all
callers call that directly either conditionally or unconditionally and
only leave the read fault handling in __xfs_filemap_fault.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 20f7f92b8867..0b8e36f8703c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1434,6 +1434,16 @@ xfs_dax_read_fault(
 	return ret;
 }
 
+/*
+ * Locking for serialisation of IO during page faults. This results in a lock
+ * ordering of:
+ *
+ * mmap_lock (MM)
+ *   sb_start_pagefault(vfs, freeze)
+ *     invalidate_lock (vfs/XFS_MMAPLOCK - truncate serialisation)
+ *       page_lock (MM)
+ *         i_lock (XFS - extent map serialisation)
+ */
 static vm_fault_t
 xfs_write_fault(
 	struct vm_fault		*vmf,
@@ -1471,26 +1481,13 @@ xfs_write_fault(
 	return ret;
 }
 
-/*
- * Locking for serialisation of IO during page faults. This results in a lock
- * ordering of:
- *
- * mmap_lock (MM)
- *   sb_start_pagefault(vfs, freeze)
- *     invalidate_lock (vfs/XFS_MMAPLOCK - truncate serialisation)
- *       page_lock (MM)
- *         i_lock (XFS - extent map serialisation)
- */
 static vm_fault_t
 __xfs_filemap_fault(
 	struct vm_fault		*vmf,
-	unsigned int		order,
-	bool			write_fault)
+	unsigned int		order)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 
-	if (write_fault)
-		return xfs_write_fault(vmf, order);
 	if (IS_DAX(inode))
 		return xfs_dax_read_fault(vmf, order);
 
@@ -1511,9 +1508,9 @@ xfs_filemap_fault(
 	struct vm_fault		*vmf)
 {
 	/* DAX can shortcut the normal fault path on write faults! */
-	return __xfs_filemap_fault(vmf, 0,
-			IS_DAX(file_inode(vmf->vma->vm_file)) &&
-			xfs_is_write_fault(vmf));
+	if (IS_DAX(file_inode(vmf->vma->vm_file)) && xfs_is_write_fault(vmf))
+		return xfs_write_fault(vmf, 0);
+	return __xfs_filemap_fault(vmf, 0);
 }
 
 static vm_fault_t
@@ -1525,15 +1522,16 @@ xfs_filemap_huge_fault(
 		return VM_FAULT_FALLBACK;
 
 	/* DAX can shortcut the normal fault path on write faults! */
-	return __xfs_filemap_fault(vmf, order,
-			xfs_is_write_fault(vmf));
+	if (xfs_is_write_fault(vmf))
+		return xfs_write_fault(vmf, order);
+	return __xfs_filemap_fault(vmf, order);
 }
 
 static vm_fault_t
 xfs_filemap_page_mkwrite(
 	struct vm_fault		*vmf)
 {
-	return __xfs_filemap_fault(vmf, 0, true);
+	return xfs_write_fault(vmf, 0);
 }
 
 /*
@@ -1545,8 +1543,7 @@ static vm_fault_t
 xfs_filemap_pfn_mkwrite(
 	struct vm_fault		*vmf)
 {
-
-	return __xfs_filemap_fault(vmf, 0, true);
+	return xfs_write_fault(vmf, 0);
 }
 
 static const struct vm_operations_struct xfs_file_vm_ops = {
-- 
2.45.2

