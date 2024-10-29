Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BC1946A2
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214749; cv=none; b=jszX/8nSyAVHKXHsP76BtwgF91YhSAfrxJfcW5FDg3VDHaGysf0dtarMbvL/JOCgbaOTFobKjWjp/GBB33atond+33Rwb3d8N5xD3/wC8XP3fs+Ae3T6nFslI443hGIiex8ZbADuyplO238zc++yuAyh4r1O18SeoTuDHX9dbyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214749; c=relaxed/simple;
	bh=gP+U3suwbd18xb1Y3R5xpcJsqx0AJe7c+lh5LH0/jvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzSz3OnZszI1KaxmTfYxxwUT1RPHAYO/X3GbCco5f5AtKU/My3VA1KLz9XZBwBNEFS/N2JI9Yt9xqxqRENep7JjxmqTFVJdjldbISLUVchP8rr8PhZRumXciK3H1J9BtAuk1cOzgjaAgbL8gq+wTE/5I1P9bTUvjL7NlA20hXcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C5zlu22l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C5zlu22l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FofnZmtHDw9S2j4BL1iaFz4F1rJW9fl4Oy0MW85c764=; b=C5zlu22lQs4t1mdt0J9XZtYU5n
	lxe8acQvRLiPjwkKiMYVZxfCWRFkFG+PJ0zOeUvRiTFbkexH4zL+91APMYu5AqOpy4E/bYX8XWs55
	wcHJksHxcne8043JrC41tbRBStsRWaicCicQwoj96Jq61RF63sFPiSROfw6MDWrLm5pzCVopC47AB
	MaLW4HAsCCMNKdKI6AFJ27vKnB9LXNSCdyzzKyqZ7QNi+p/VdaRWnPdeoIxJPTu/R0w5U4abo832U
	tnttkBL5m/dgaTECbZPpa1LmaXO0w6T9HnL54O6FOun+1f95LzM4IoL7vkT+toarnWqVU1z76dqto
	cuTnlkJw==;
Received: from 2a02-8389-2341-5b80-1009-120a-6297-8bca.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1009:120a:6297:8bca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ntT-0000000Eqs4-0b6l;
	Tue, 29 Oct 2024 15:12:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: remove __xfs_filemap_fault
Date: Tue, 29 Oct 2024 16:11:59 +0100
Message-ID: <20241029151214.255015-4-hch@lst.de>
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

xfs_filemap_huge_fault only ever serves DAX faults, so hard code the
call to xfs_dax_read_fault and open code __xfs_filemap_fault in the
only remaining caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0b8e36f8703c..7464d874e766 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1481,20 +1481,6 @@ xfs_write_fault(
 	return ret;
 }
 
-static vm_fault_t
-__xfs_filemap_fault(
-	struct vm_fault		*vmf,
-	unsigned int		order)
-{
-	struct inode		*inode = file_inode(vmf->vma->vm_file);
-
-	if (IS_DAX(inode))
-		return xfs_dax_read_fault(vmf, order);
-
-	trace_xfs_read_fault(XFS_I(inode), order);
-	return filemap_fault(vmf);
-}
-
 static inline bool
 xfs_is_write_fault(
 	struct vm_fault		*vmf)
@@ -1507,10 +1493,17 @@ static vm_fault_t
 xfs_filemap_fault(
 	struct vm_fault		*vmf)
 {
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+
 	/* DAX can shortcut the normal fault path on write faults! */
-	if (IS_DAX(file_inode(vmf->vma->vm_file)) && xfs_is_write_fault(vmf))
-		return xfs_write_fault(vmf, 0);
-	return __xfs_filemap_fault(vmf, 0);
+	if (IS_DAX(inode)) {
+		if (xfs_is_write_fault(vmf))
+			return xfs_write_fault(vmf, 0);
+		return xfs_dax_read_fault(vmf, 0);
+	}
+
+	trace_xfs_read_fault(XFS_I(inode), 0);
+	return filemap_fault(vmf);
 }
 
 static vm_fault_t
@@ -1524,7 +1517,7 @@ xfs_filemap_huge_fault(
 	/* DAX can shortcut the normal fault path on write faults! */
 	if (xfs_is_write_fault(vmf))
 		return xfs_write_fault(vmf, order);
-	return __xfs_filemap_fault(vmf, order);
+	return xfs_dax_read_fault(vmf, order);
 }
 
 static vm_fault_t
-- 
2.45.2

