Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB308171BA
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121520; cv=none; b=P337y9r4oFaBIcg4dcIlKUiC0vjhCj1dZRwg+crESdD30lpuMV2QZSO5K8QWM57RR+h6Zj6uEuYJttBJXp97dVIVlICP0sCxHX/YnjYsqPujfzm8ZQDwQo8jqz3fp4Q+7jWP8US4Dv9ZLlt93ukBTEG1xp/WIlYxrARyS3fCKzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121520; c=relaxed/simple;
	bh=fiXOdvrAocMnKIbbJ10/yECMN3FsLrXYhmg3ZwPiGD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfFFqfuWLXzLpXm4CHC+yNjP9ig1Fv6zL2dpQnFnYqiyKc8JJwy48+xJofgQbKdQkuFrOuvuz66jJ4eYFILKEhn1Dgy/X0vhkvAS1s8S/JZKsVPBiEtfkHL8eUkzHUrAGMNCxprgC2ZWnws2j2Ie9UHQk+bqnCEnsJ/MobTyBG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WqPPsI3V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WqPPsI3V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FPR1zaHaaa+XSLa0TuT2+/UYYh1mDdxBGunH+sOMvOc=; b=WqPPsI3VCLO4n4dLBET53oR7yn
	exMoJaTwNNFMH8pEUa/JXNEZ+rJUQd7okvwUn/+sl0wnZ2wQdkvvO8duu9v1zox40CdLkFL4wAdOJ
	QziqXLmMXzCPnNYOxxk46ITw53Lq1ct5hWjhYNSOhBTFWQ/P8qUWmzt3Y+BzP+bhqOebGvn6NMg23
	sK4i99ORujE6wPhJn8tTDZ0AUN6RVLo9KS8rkouJW5sF+5zdCfxgvtn/15Eee8M9MoFQWrqI5KB22
	lCTxlJ+izgkAEkaUJ+ZnIIVYF2bdn1sPA5lLQ0KvNenzyZnRX3l/1Vs6tuG4EnP8w2V4j7PleNjH6
	p8pPyPrg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2P-0000000DPBl-3HYF;
	Sun, 23 Jun 2024 05:45:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: refactor __xfs_filemap_fault
Date: Sun, 23 Jun 2024 07:44:29 +0200
Message-ID: <20240623054500.870845-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623054500.870845-1-hch@lst.de>
References: <20240623054500.870845-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 71 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8aab2f66fe016f..32a2cd6ec82e0c 100644
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
+xfs_dax_read_fault(
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
-
-	trace_xfs_filemap_fault(ip, order, write_fault);
 
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
+		return xfs_dax_read_fault(vmf, order);
+	return filemap_fault(vmf);
 }
 
 static inline bool
-- 
2.43.0

