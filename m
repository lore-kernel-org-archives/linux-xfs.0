Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6F200A8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324053; cv=none; b=EiH8cMy7vdfKy46hfcFlsA1Yxs1A6y8VK3EZOM7UnIl4TJEzTu1cCAsEUWthxxbQFa7pR6GHFo85kkxO4UnUERuQ5J5q1MZ3/UcmSmvAaS/OxaYoOdGxVlPJI8WFYWuTAemWzmEPwlzVwiFZ+Cz0+VPO6jgTOCs5SxgaXlNhKiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324053; c=relaxed/simple;
	bh=qwfS1q99G31b/jz4PDWX8FZNi9qQ7pWR5uzd+mzYgo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sxsPVVLHrf2rNmZIp5J8oHUZzKURJ0keJ3yLyX3+qCOUE0TeVDzjcnd1RTAmQrLNpS/i7FvEwd+F0sUVHXdNUcw2W0BlYFgP8Y6QScP72sfedWKTenWUtCzWjM87HMUt5/wVXZFfNn2oAsMK2N5WiPWnW7vmrgTPX6BPhomr1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XNYJh366; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XNYJh366"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=clOp26eC8FKH7Dvv6yg9RYRM6akZaOkBAUeiLBbKRv8=; b=XNYJh366mgdDIBrZQeDtw84FK1
	fHJ00w2tBnxewggSV+MWGfHkf8hwUDGq1lSvdehhAjs488kbF2Ipy9CMdoqbrh1YoTIbbxxPVZgVm
	yP/Iw1OY64VD6VsqpbL4R1iukf00mL9aUMqiETx0uVqAchTdYndLHXKyUrFKkctgqVG2LNJQQ3LMv
	CIajI590GSXkr9/EmWh2xbBGshqpqyroAZTaHxxqrDvyOwMds43DrHbKcL6/2qejRNObFRG+PZdQN
	dHGla2X/BGRjiIc3nidep3Md1mPIY/mmYqDk2ZY/ZukyvBHpzYZ5foD7IdM6irYSaIVqj3RPs/fgY
	moYT1u6w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbx7h-00000009F6F-3PHD;
	Mon, 19 Feb 2024 06:27:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Su <sh_def@163.com>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 02/22] shmem: move shmem_mapping out of line
Date: Mon, 19 Feb 2024 07:27:10 +0100
Message-Id: <20240219062730.3031391-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219062730.3031391-1-hch@lst.de>
References: <20240219062730.3031391-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

shmem_aops really should not be exported to the world.  Move
shmem_mapping and export it as internal for the one semi-legitimate
modular user in udmabuf.

This effectively reverts commit 30e6a51dbb05 ("mm/shmem.c: make
shmem_mapping() inline"). which added a bogus shmem_aops non-GPL export
for no reason whatsoever as there as no shmem_mapping call outside of
core MM code at that point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/shmem_fs.h |  6 +-----
 mm/shmem.c               | 11 ++++++++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 2caa6b86106aa3..6b96a87e4bc80a 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -97,11 +97,7 @@ extern unsigned long shmem_get_unmapped_area(struct file *, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 extern int shmem_lock(struct file *file, int lock, struct ucounts *ucounts);
 #ifdef CONFIG_SHMEM
-extern const struct address_space_operations shmem_aops;
-static inline bool shmem_mapping(struct address_space *mapping)
-{
-	return mapping->a_ops == &shmem_aops;
-}
+bool shmem_mapping(struct address_space *mapping);
 #else
 static inline bool shmem_mapping(struct address_space *mapping)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index d7c84ff621860b..f607b0cab7e4e2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -254,7 +254,7 @@ static void shmem_inode_unacct_blocks(struct inode *inode, long pages)
 }
 
 static const struct super_operations shmem_ops;
-const struct address_space_operations shmem_aops;
+static const struct address_space_operations shmem_aops;
 static const struct file_operations shmem_file_operations;
 static const struct inode_operations shmem_inode_operations;
 static const struct inode_operations shmem_dir_inode_operations;
@@ -263,6 +263,12 @@ static const struct vm_operations_struct shmem_vm_ops;
 static const struct vm_operations_struct shmem_anon_vm_ops;
 static struct file_system_type shmem_fs_type;
 
+bool shmem_mapping(struct address_space *mapping)
+{
+	return mapping->a_ops == &shmem_aops;
+}
+EXPORT_SYMBOL_GPL(shmem_mapping);
+
 bool vma_is_anon_shmem(struct vm_area_struct *vma)
 {
 	return vma->vm_ops == &shmem_anon_vm_ops;
@@ -4466,7 +4472,7 @@ static int shmem_error_remove_folio(struct address_space *mapping,
 	return 0;
 }
 
-const struct address_space_operations shmem_aops = {
+static const struct address_space_operations shmem_aops = {
 	.writepage	= shmem_writepage,
 	.dirty_folio	= noop_dirty_folio,
 #ifdef CONFIG_TMPFS
@@ -4478,7 +4484,6 @@ const struct address_space_operations shmem_aops = {
 #endif
 	.error_remove_folio = shmem_error_remove_folio,
 };
-EXPORT_SYMBOL(shmem_aops);
 
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
-- 
2.39.2

