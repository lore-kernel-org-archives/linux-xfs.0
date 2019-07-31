Return-Path: <SRS0=EDo9=V4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C24C433FF
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0510208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Jul 2019 11:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfGaLty (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:49:54 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55517 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727125AbfGaLty (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 07:49:54 -0400
X-IronPort-AV: E=Sophos;i="5.64,330,1559491200"; 
   d="scan'208";a="72591480"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 19:49:51 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id BC0514CDDAEB;
        Wed, 31 Jul 2019 19:49:48 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 19:49:55 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <rgoldwyn@suse.de>,
        <gujx@cn.fujitsu.com>, <david@fromorbit.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 3/7] dax: replace mmap entry in case of CoW
Date:   Wed, 31 Jul 2019 19:49:31 +0800
Message-ID: <20190731114935.11030-4-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: BC0514CDDAEB.AABCA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190731114931.ITSoV4kimukDkHFcoxiQJTp0w6jM5BNSqhpn_kuQ_Q8@z>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

We replace the existing entry to the newly allocated one
in case of CoW. Also, we mark the entry as PAGECACHE_TAG_TOWRITE
so writeback marks this entry as writeprotected. This
helps us snapshots so new write pagefaults after snapshots
trigger a CoW.

btrfs does not support hugepages so we don't handle PMD.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/dax.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 084cc21d47a4..8eb065a1ec51 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -700,6 +700,9 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 	return 0;
 }
 
+#define DAX_IF_DIRTY		(1ULL << 0)
+#define DAX_IF_COW		(1ULL << 1)
+
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -709,14 +712,17 @@ static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
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
@@ -728,12 +734,12 @@ static void *dax_insert_entry(struct xa_state *xas,
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+	if (cow || (dax_entry_size(entry) != dax_entry_size(new_entry))) {
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 	}
 
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -753,6 +759,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
@@ -1040,7 +1049,7 @@ static vm_fault_t dax_load_hole(struct xa_state *xas,
 	vm_fault_t ret;
 
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_ZERO_PAGE, false);
+			DAX_ZERO_PAGE, 0);
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
 	trace_dax_load_hole(inode, vmf, ret);
@@ -1310,6 +1319,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	void *entry;
 	pfn_t pfn;
 	void *kaddr;
+	unsigned long insert_flags = 0;
 
 	trace_dax_pte_fault(inode, vmf, ret);
 	/*
@@ -1371,6 +1381,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			error = copy_user_dax(iomap.bdev, iomap.dax_dev,
 					sector, PAGE_SIZE, vmf->cow_page, vaddr);
 			break;
+		case IOMAP_COW:
+			/* Should not be setting this - fallthrough */
 		default:
 			WARN_ON_ONCE(1);
 			error = -EIO;
@@ -1391,6 +1403,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	switch (iomap.type) {
 	case IOMAP_COW:
+		insert_flags |= DAX_IF_COW;
+		/* fallthrough */
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
@@ -1401,8 +1415,10 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		if (error < 0)
 			goto error_finish_iomap;
 
+		if (write && !sync)
+			insert_flags |= DAX_IF_DIRTY;
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						 0, write && !sync);
+						 0, insert_flags);
 
 		if (iomap.type == IOMAP_COW) {
 			error = dax_copy_edges(inode, pos, PAGE_SIZE, &srcmap,
@@ -1490,7 +1506,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 
 	pfn = page_to_pfn_t(zero_page);
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
-			DAX_PMD | DAX_ZERO_PAGE, false);
+			DAX_PMD | DAX_ZERO_PAGE, 0);
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
@@ -1542,6 +1558,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	int error;
 	pfn_t pfn;
 	void *kaddr;
+	unsigned long insert_flags = 0;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1627,8 +1644,11 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		if (error < 0)
 			goto finish_iomap;
 
+		if (write && !sync)
+			insert_flags |= DAX_IF_DIRTY;
+
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
-						DAX_PMD, write && !sync);
+						DAX_PMD, insert_flags);
 
 		if (iomap.type == IOMAP_COW) {
 			error = dax_copy_edges(inode, pos, PMD_SIZE, &srcmap,
-- 
2.17.0



