Return-Path: <SRS0=EDo9=V4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF25C32751
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B377208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfGaLtx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:49:53 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55522 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbfGaLtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 07:49:53 -0400
X-IronPort-AV: E=Sophos;i="5.64,330,1559491200"; 
   d="scan'208";a="72591482"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 19:49:51 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id EF3E44CDD99E;
        Wed, 31 Jul 2019 19:49:46 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 19:49:53 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <rgoldwyn@suse.de>,
        <gujx@cn.fujitsu.com>, <david@fromorbit.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 2/7] dax: copy data before write.
Date:   Wed, 31 Jul 2019 19:49:30 +0800
Message-ID: <20190731114935.11030-3-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: EF3E44CDD99E.AAA68
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190731114930.36lYYDZPPO4I6E0ysizpPSm1HA1PSblydauXN8rX6Po@z>

Add dax_copy_edges() into each dax actor functions to perform COW in the
case of IOMAP_COW type is set.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/dax.c | 39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 450baafe2ea4..084cc21d47a4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1098,11 +1098,12 @@ EXPORT_SYMBOL_GPL(__dax_zero_page_range);
  * 		    offset/offset+length are not page aligned.
  */
 static int dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
-			  struct iomap *srcmap, void *daddr)
+			  struct iomap *srcmap, void *daddr, bool pmd)
 {
-	unsigned offset = pos & (PAGE_SIZE - 1);
+	size_t page_size = pmd ? PMD_SIZE : PAGE_SIZE;
+	unsigned offset = pos & (page_size - 1);
 	loff_t end = pos + length;
-	loff_t pg_end = round_up(end, PAGE_SIZE);
+	loff_t pg_end = round_up(end, page_size);
 	void *saddr = 0;
 	int ret = 0;
 
@@ -1153,7 +1154,8 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			return iov_iter_zero(min(length, end - pos), iter);
 	}
 
-	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
+	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED &&
+			 iomap->type != IOMAP_COW))
 		return -EIO;
 
 	/*
@@ -1192,6 +1194,13 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
+		if (iomap->type == IOMAP_COW) {
+			ret = dax_copy_edges(inode, pos, length, srcmap, kaddr,
+					     false);
+			if (ret)
+				break;
+		}
+
 		map_len = PFN_PHYS(map_len);
 		kaddr += offset;
 		map_len -= offset;
@@ -1300,6 +1309,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	vm_fault_t ret = 0;
 	void *entry;
 	pfn_t pfn;
+	void *kaddr;
 
 	trace_dax_pte_fault(inode, vmf, ret);
 	/*
@@ -1380,19 +1390,27 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	sync = dax_fault_is_synchronous(flags, vma, &iomap);
 
 	switch (iomap.type) {
+	case IOMAP_COW:
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, NULL);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, &kaddr);
 		if (error < 0)
 			goto error_finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						 0, write && !sync);
 
+		if (iomap.type == IOMAP_COW) {
+			error = dax_copy_edges(inode, pos, PAGE_SIZE, &srcmap,
+					       kaddr, false);
+			if (error)
+				goto error_finish_iomap;
+		}
+
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
 		 * we can insert PTE into page tables only after that happens.
@@ -1523,6 +1541,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	loff_t pos;
 	int error;
 	pfn_t pfn;
+	void *kaddr;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1602,14 +1621,22 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	sync = dax_fault_is_synchronous(iomap_flags, vma, &iomap);
 
 	switch (iomap.type) {
+	case IOMAP_COW:
 	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, &kaddr);
 		if (error < 0)
 			goto finish_iomap;
 
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
 
+		if (iomap.type == IOMAP_COW) {
+			error = dax_copy_edges(inode, pos, PMD_SIZE, &srcmap,
+					       kaddr, true);
+			if (error)
+				goto unlock_entry;
+		}
+
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
 		 * we can insert PMD into page tables only after that happens.
-- 
2.17.0



