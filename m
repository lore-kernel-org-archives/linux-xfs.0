Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF79CA9EAF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1B521479
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfJ3EO2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 00:14:28 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45395 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726627AbfJ3EOW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 00:14:22 -0400
X-IronPort-AV: E=Sophos;i="5.68,245,1569254400"; 
   d="scan'208";a="77665114"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Oct 2019 12:14:20 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3291C4B6AE15;
        Wed, 30 Oct 2019 12:06:18 +0800 (CST)
Received: from localhost.localdomain (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 30 Oct 2019 12:14:26 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <rgoldwyn@suse.de>, <hch@infradead.org>,
        <david@fromorbit.com>
CC:     <linux-kernel@vger.kernel.org>, <gujx@cn.fujitsu.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH v2 1/7] dax: Introduce dax_copy_edges() for COW.
Date:   Wed, 30 Oct 2019 12:13:52 +0800
Message-ID: <20191030041358.14450-2-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 3291C4B6AE15.A438C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To copy source data to destance address before write.  Change
dax_iomap_pfn() to return the address as well in order to use it for
performing a memcpy in case the type is IOMAP_COW.

dax_copy_edges() is a helper functions performs a copy from one part of
the device to another for data not page aligned.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/dax.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 68eef98cd9c4..e1f4493ce56a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -987,8 +987,8 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
 }
 
-static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+static int dax_iomap_direct_access(struct iomap *iomap, loff_t pos, size_t size,
+			 pfn_t *pfnp, void **addr)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
@@ -999,12 +999,14 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	if (rc)
 		return rc;
 	id = dax_read_lock();
-	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size), addr,
+				   pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
 	}
+	if (!pfnp)
+		goto out_check_addr;
 	rc = -EINVAL;
 	if (PFN_PHYS(length) < size)
 		goto out;
@@ -1014,6 +1016,12 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	if (length > 1 && !pfn_t_devmap(*pfnp))
 		goto out;
 	rc = 0;
+
+out_check_addr:
+	if (!addr)
+		goto out;
+	if (!*addr)
+		rc = -EFAULT;
 out:
 	dax_read_unlock(id);
 	return rc;
@@ -1056,6 +1064,48 @@ static bool dax_range_is_aligned(struct block_device *bdev,
 	return true;
 }
 
+/*
+ * dax_copy_edges - Copies the part of the pages not included in
+ * 		    the write, but required for CoW because
+ * 		    offset/offset+length are not page aligned.
+ */
+static int dax_copy_edges(loff_t pos, loff_t length, struct iomap *srcmap,
+			  void *daddr, bool pmd)
+{
+	size_t page_size = pmd ? PMD_SIZE : PAGE_SIZE;
+	loff_t offset = pos & (page_size - 1);
+	size_t size = ALIGN(offset + length, page_size);
+	loff_t end = pos + length;
+	loff_t pg_end = round_up(end, page_size);
+	void *saddr = 0;
+	int ret = 0;
+
+	ret = dax_iomap_direct_access(srcmap, pos, size, NULL, &saddr);
+	if (ret)
+		return ret;
+	/*
+	 * Copy the first part of the page
+	 * Note: we pass offset as length
+	 */
+	if (offset) {
+		if (saddr)
+			ret = memcpy_mcsafe(daddr, saddr, offset);
+		else
+			memset(daddr, 0, offset);
+	}
+
+	/* Copy the last part of the range */
+	if (end < pg_end) {
+		if (saddr)
+			ret = memcpy_mcsafe(daddr + offset + length,
+			       saddr + offset + length,	pg_end - end);
+		else
+			memset(daddr + offset + length, 0,
+					pg_end - end);
+	}
+	return ret;
+}
+
 int __dax_zero_page_range(struct block_device *bdev,
 		struct dax_device *dax_dev, sector_t sector,
 		unsigned int offset, unsigned int size)
@@ -1342,7 +1392,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		error = dax_iomap_direct_access(&iomap, pos, PAGE_SIZE, &pfn,
+						NULL);
 		if (error < 0)
 			goto error_finish_iomap;
 
@@ -1560,7 +1611,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		error = dax_iomap_direct_access(&iomap, pos, PMD_SIZE, &pfn,
+						NULL);
 		if (error < 0)
 			goto finish_iomap;
 
-- 
2.23.0



