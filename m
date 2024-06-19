Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8C713DDC9
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798079; cv=none; b=ShjyoTjAMzZkUVdgXCP+xk8GYRRbzJ+0Uy7rtZ7WnhoBybBAsaaPMR5eKZs9M0kp8I+jmgQ25Xa98qtuSE/gNYLiUY0wPdJhPADO4oJg3JN084trLvEDqOvaLN/P4BYUH9tCJXWEs5Wk27LIvvVONH74Q2QHBQDsEoaVEOsgrqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798079; c=relaxed/simple;
	bh=NYHsJkLr6lrnXFHQppGIN5fg9scICb4UfHikRC6hIt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE54kKoOOrYK6SYBM7dNVChzketFpIpUySeXt3xc6szLswuhAz1RgGedpqAGnJeHtLX/YnBZstvKoiDSb67gDS/BxO74xIKfDu25XBMxeXTp5repYaVzCYgDxfTpSmwGgnF7VauOHDl7/eMaY9ctaPA2AzvMHuV4cRvX8ku7kJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WSY+XOXz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WSY+XOXz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qhMM1eIVGZWmjqGRAM5clmHZ0fIZ7OEUKRktm3o0LJg=; b=WSY+XOXz+bMryp083JWwSRO5oY
	WRZprbTJb/s0rufpfcoV7MjusbM5Ut3DW7QEQGhauwhmDaL4/yo6IW5EUUufABqFO/4/7pBXLTJQY
	nyNMC/WL++GCH28mL/Z54/CyIlt2TzrKxgsXEfYXpCxIOWAROCDETAo7jE2RrvRqAjAU910wEe93c
	DO0RMK97DlygXFoABaVQT7XrHwy93tteeY/I587zWy8M5qpNAPQkr5wzCVt3oU9AzU11nF5bsQKuP
	ZSFJZFbwdePA9E6bJT/3QK/mLQSTHZyLwUbZmzexjenh7ROZDqNBdP4yne+QrWouE0f7P9UBr9zeC
	Zzu5ONFA==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJttc-000000014Ob-2jYq;
	Wed, 19 Jun 2024 11:54:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: simplify xfs_dax_fault
Date: Wed, 19 Jun 2024 13:53:53 +0200
Message-ID: <20240619115426.332708-4-hch@lst.de>
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

Replace the separate stub with an IS_ENABLED check, and take the call to
dax_finish_sync_fault into xfs_dax_fault instead of leaving it in the
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 74c2c8d253e69b..8aab2f66fe016f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1251,31 +1251,27 @@ xfs_file_llseek(
 	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
 }
 
-#ifdef CONFIG_FS_DAX
 static inline vm_fault_t
 xfs_dax_fault(
 	struct vm_fault		*vmf,
 	unsigned int		order,
-	bool			write_fault,
-	pfn_t			*pfn)
+	bool			write_fault)
 {
-	return dax_iomap_fault(vmf, order, pfn, NULL,
+	vm_fault_t		ret;
+	pfn_t			pfn;
+
+	if (!IS_ENABLED(CONFIG_FS_DAX)) {
+		ASSERT(0);
+		return VM_FAULT_SIGBUS;
+	}
+	ret = dax_iomap_fault(vmf, order, &pfn, NULL,
 			(write_fault && !vmf->cow_page) ?
 				&xfs_dax_write_iomap_ops :
 				&xfs_read_iomap_ops);
+	if (ret & VM_FAULT_NEEDDSYNC)
+		ret = dax_finish_sync_fault(vmf, order, pfn);
+	return ret;
 }
-#else
-static inline vm_fault_t
-xfs_dax_fault(
-	struct vm_fault		*vmf,
-	unsigned int		order,
-	bool			write_fault,
-	pfn_t			*pfn)
-{
-	ASSERT(0);
-	return VM_FAULT_SIGBUS;
-}
-#endif
 
 /*
  * Locking for serialisation of IO during page faults. This results in a lock
@@ -1309,11 +1305,7 @@ __xfs_filemap_fault(
 		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
 
 	if (IS_DAX(inode)) {
-		pfn_t pfn;
-
-		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
-		if (ret & VM_FAULT_NEEDDSYNC)
-			ret = dax_finish_sync_fault(vmf, order, pfn);
+		ret = xfs_dax_fault(vmf, order, write_fault);
 	} else if (write_fault) {
 		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-- 
2.43.0

