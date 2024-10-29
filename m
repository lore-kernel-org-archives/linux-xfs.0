Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8932190049
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214744; cv=none; b=uAHLj1vd5211mWufgV68TKkwZZfZTVhdqIf2mY5DmGZH6hTGdgh3gz37M06DpxMcw8B228ngLgak4gv43COt3/nQuhNpHkAhenDRM9jf9GT4qb8vzo+jkPwhnJq56jTOGX1WPER/eCLH8p03/RXWF4kCLUy2nk1s0hSH2zSKhsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214744; c=relaxed/simple;
	bh=xeQ26DIlFwrMo2tpZVlvM4eYdtwaRLKDa0qnE7po2qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+/NmWKNHSZxsJnUPjCQ18N9w9JomSbIiwrQ/9XAhywjrRMAmI8itSNlYBpQtnUZK8GIXDncNjuUbpS7VMAot2yoPUaNjID7DCgou3AdvIPUpber2C7OzQg6R/nDX8ovmLByJCpYzzHFcXaeNYXHK4AWs4PWM3X0kFU5LD65IUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wxHSJyo3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wxHSJyo3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EVcjD4YSWsWdRq3FuGYrccSP7KzdxSTLpPYrhC9zBiA=; b=wxHSJyo31GIfFvVjmpuSKYyCq0
	Mr0J16aCH3BZpxrsEYDRKvM3ysQmc1Bt//HBG+J7zNTD3hX9GRZb87vTonBenntClb3RsY+is2lPA
	WU0/JiDrGB6+OmQSWXapW1J/7tj01P9+CR3A7E9NpVbFIArSZJJcic8+RUZsLJa5ZjtD0d1oJYbZc
	MmtLhf03qFzYuzBIqpkxoRb+ZeokHr3p9lb6ujJUIke7H5q3tt1ljjsMwlihTeEYKKKV2mmMFoqib
	7Qx+yOA4Hrz4YNtMTj2m+kor7OZePJc+5K+w5+i4/3UVSMNnP96FN7gybv7kisbLoBewqiJjVKQ7y
	/zZ83RLg==;
Received: from 2a02-8389-2341-5b80-1009-120a-6297-8bca.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1009:120a:6297:8bca] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5ntN-0000000EqrL-0oZg;
	Tue, 29 Oct 2024 15:12:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: split the page fault trace event
Date: Tue, 29 Oct 2024 16:11:57 +0100
Message-ID: <20241029151214.255015-2-hch@lst.de>
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

Split the xfs_filemap_fault trace event into separate ones for read and
write faults and move them into the applicable locations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  |  8 ++++++--
 fs/xfs/xfs_trace.h | 20 ++++++++++++--------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b19916b11fd5..20f7f92b8867 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1425,6 +1425,8 @@ xfs_dax_read_fault(
 	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
 	vm_fault_t		ret;
 
+	trace_xfs_read_fault(ip, order);
+
 	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
 	ret = xfs_dax_fault_locked(vmf, order, false);
 	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
@@ -1442,6 +1444,8 @@ xfs_write_fault(
 	unsigned int		lock_mode = XFS_MMAPLOCK_SHARED;
 	vm_fault_t		ret;
 
+	trace_xfs_write_fault(ip, order);
+
 	sb_start_pagefault(inode->i_sb);
 	file_update_time(vmf->vma->vm_file);
 
@@ -1485,12 +1489,12 @@ __xfs_filemap_fault(
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 
-	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
-
 	if (write_fault)
 		return xfs_write_fault(vmf, order);
 	if (IS_DAX(inode))
 		return xfs_dax_read_fault(vmf, order);
+
+	trace_xfs_read_fault(XFS_I(inode), order);
 	return filemap_fault(vmf);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee9f0b1f548d..efc4aae295aa 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -827,28 +827,32 @@ DEFINE_INODE_EVENT(xfs_inode_inactivating);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
 
-TRACE_EVENT(xfs_filemap_fault,
-	TP_PROTO(struct xfs_inode *ip, unsigned int order, bool write_fault),
-	TP_ARGS(ip, order, write_fault),
+DECLARE_EVENT_CLASS(xfs_fault_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned int order),
+	TP_ARGS(ip, order),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, order)
-		__field(bool, write_fault)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->order = order;
-		__entry->write_fault = write_fault;
 	),
-	TP_printk("dev %d:%d ino 0x%llx order %u write_fault %d",
+	TP_printk("dev %d:%d ino 0x%llx order %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->order,
-		  __entry->write_fault)
+		  __entry->order)
 )
 
+#define DEFINE_FAULT_EVENT(name) \
+DEFINE_EVENT(xfs_fault_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned int order), \
+	TP_ARGS(ip, order))
+DEFINE_FAULT_EVENT(xfs_read_fault);
+DEFINE_FAULT_EVENT(xfs_write_fault);
+
 DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
 	TP_ARGS(ip, caller_ip),
-- 
2.45.2

