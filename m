Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84164153511
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2024 14:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706538916; cv=none; b=Jgt0qlk7AZ62Zzrhoc+D2Ai2tfP1HmClXWadD3rlS+Cq2t/7GngxosiUeMTbGXWtgvSgb0iWmjYZTr43mSNhl7ist/EDA7bvWGxdg//D+exPwDP0VzUSf/bSBeVPIcmNB/sQVMgWB7MPnfGhPERk/KLEt0Z2oaDQxNb+DBPPxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706538916; c=relaxed/simple;
	bh=FKmAsrnjA9LSEhQPao1LMNQP1IOjIvnu8/cX1E3JGhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OoYCqj49fmDfno0S4FXVb+C8Yf5s6Ll10SqCROuq0QklR40aNjtfV6VIA35KY07aDdRPJq4mJRVXclMNbxk0WhmoBDBO5EjTJxknmRGRtIGOGedj2/nY/Bu2ge37uYowkvkNAVGt0fHQAp8Z/3jfWUwHKAcT5GOUl39iAj3mnkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o0WIyZ8V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0WIyZ8V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nnaIGoG1q9qfUz3HCpUPzAYpM+4OPI2B6Bp4snlIbvg=; b=o0WIyZ8VynAr1Xcm+mMkaMz+sV
	SItf+DLeOV8R04PtqoOb6bQJw/5IbegZytSrH46ei+cEalfXeMP9Q3AwG84JA/p7W30jjRahB7b6I
	I0i2y8Vg9255nLLDHqydZ8IPeIv5Obptbgmk4ZOi2X3mIyII6WC/etqw0sNEDffUTdGllpy8TamYv
	9rnUAdut6OLyVtun3mjYIYdmC3ftiQ5POh1ohTdFNZk8+SVewkyXtssI5AaHowWd2/A04iYP2t16O
	jtPse0UbmgdWQMA7Yk8S8knqnUJh4rQYMDwsnK79LQAAD0HDc830QSITk6iZ/6Qs7bC6E/llYyO/Y
	fQJ6PvYQ==;
Received: from [2001:4bb8:182:6550:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rUSjA-0000000D65Y-2kjA;
	Mon, 29 Jan 2024 14:35:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 02/20] shmem: move shmem_mapping out of line
Date: Mon, 29 Jan 2024 15:34:44 +0100
Message-Id: <20240129143502.189370-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240129143502.189370-1-hch@lst.de>
References: <20240129143502.189370-1-hch@lst.de>
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

