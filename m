Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0DACA9EAF
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C29B2087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 04:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfJ3EOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 00:14:23 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:4003 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727222AbfJ3EOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 00:14:23 -0400
X-IronPort-AV: E=Sophos;i="5.68,245,1569254400"; 
   d="scan'208";a="77665116"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Oct 2019 12:14:20 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 786AD4CE1510;
        Wed, 30 Oct 2019 12:06:22 +0800 (CST)
Received: from localhost.localdomain (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 30 Oct 2019 12:14:30 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>, <rgoldwyn@suse.de>, <hch@infradead.org>,
        <david@fromorbit.com>
CC:     <linux-kernel@vger.kernel.org>, <gujx@cn.fujitsu.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH v2 3/7] dax: replace mmap entry in case of CoW
Date:   Wed, 30 Oct 2019 12:13:54 +0800
Message-ID: <20191030041358.14450-4-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
References: <20191030041358.14450-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 786AD4CE1510.A420B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We replace the existing entry to the newly allocated one
in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
so writeback marks this entry as writeprotected. This
helps us snapshots so new write pagefaults after snapshots
trigger a CoW.

btrfs does not support hugepages so we don't handle PMD.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 949a40cf1fe7..e6174c0c669a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -705,6 +705,9 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 	return 0;
 }
 
+#define DAX_IF_DIRTY		(1ULL << 0)
+#define DAX_IF_COW		(1ULL << 1)
+
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -714,14 +717,17 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
  */
 static void *dax_insert_entry(struct xa_state *xas,
 		struct address_space *mapping, struct vm_fault *vmf,
-		void *entry, pfn_t pfn, unsigned long flags, bool dirty)
+		void *entry, pfn_t pfn, unsigned long flags,
+		unsigned int insert_flags)
 {
 	void *new_entry = dax_make_entry(pfn, flags);
+	bool dirty = insert_flags & DAX_IF_DIRTY;
+	bool cow = insert_flags & DAX_IF_COW;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
-	if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
+	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -733,7 +739,7 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
@@ -757,6 +763,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
@@ -1044,7 +1053,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+			DAX_ZERO_PAGE, 0);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1313,6 +1322,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	void *entry;
 	pfn_t pfn;
 	void *kaddr;
+	unsigned long insert_flags = 0;
 
 	trace_dax_pte_fault(inode, vmf, ret);
 	/*
@@ -1405,8 +1415,10 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		if (error < 0)
 			goto error_finish_iomap;
 
-		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
+		if (write && !sync)
+			insert_flags |= DAX_IF_DIRTY;
+		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn, 0,
+					 insert_flags);
 
 		if (srcmap.type != IOMAP_HOLE) {
 			error = dax_copy_edges(pos, PAGE_SIZE, &srcmap, kaddr,
@@ -1438,8 +1450,10 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		goto finish_iomap;
 	case IOMAP_UNWRITTEN:
-		if (srcmap.type != IOMAP_HOLE)
+		if (srcmap.type != IOMAP_HOLE) {
+			insert_flags |= DAX_IF_COW;
 			goto cow;
+		}
 		/*FALLTHRU*/
 	case IOMAP_HOLE:
 		if (!write) {
@@ -1497,7 +1511,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 
 	pfn = page_to_pfn_t(zero_page);
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+			DAX_PMD | DAX_ZERO_PAGE, 0);
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
@@ -1549,6 +1563,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	int error;
 	pfn_t pfn;
 	void *kaddr;
+	unsigned long insert_flags = 0;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1636,8 +1651,11 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		if (error < 0)
 			goto finish_iomap;
 
+		if (write && !sync)
+			insert_flags |= DAX_IF_DIRTY;
+
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
+						DAX_PMD, insert_flags);
 
 		if (srcmap.type != IOMAP_HOLE) {
 			error = dax_copy_edges(pos, PMD_SIZE, &srcmap, kaddr,
@@ -1664,8 +1682,10 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		result = vmf_insert_pfn_pmd(vmf, pfn, write);
 		break;
 	case IOMAP_UNWRITTEN:
-		if (srcmap.type != IOMAP_HOLE)
+		if (srcmap.type != IOMAP_HOLE) {
+			insert_flags |= DAX_IF_COW;
 			goto cow;
+		}
 		/*FALLTHRU*/
 	case IOMAP_HOLE:
 		if (WARN_ON_ONCE(write))
-- 
2.23.0



