Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752632AbdHQQIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 12:08:30 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/13] dax: Inline dax_pmd_insert_mapping() into the callsite
Date: Thu, 17 Aug 2017 18:08:09 +0200
Message-Id: <20170817160815.30466-8-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>

dax_pmd_insert_mapping() has only one callsite and we will need to
further fine tune what it does for synchronous faults. Just inline it
into the callsite so that we don't have to pass awkward bools around.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c                      | 43 ++++++++++++++-----------------------------
 include/trace/events/fs_dax.h |  1 -
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 766cb840c276..54d2a9161f71 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1230,34 +1230,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
-static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-		loff_t pos, void *entry)
-{
-	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct inode *inode = mapping->host;
-	void *ret = NULL;
-	pfn_t pfn;
-	int rc;
-
-	rc = dax_iomap_pfn(iomap, pos, PMD_SIZE, &pfn);
-	if (rc < 0)
-		goto fallback;
-
-	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector,
-			RADIX_DAX_PMD);
-	if (IS_ERR(ret))
-		goto fallback;
-
-	trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, ret);
-	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
-			pfn, vmf->flags & FAULT_FLAG_WRITE);
-
-fallback:
-	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
-	return VM_FAULT_FALLBACK;
-}
-
 static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 		void *entry)
 {
@@ -1312,6 +1284,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	void *entry;
 	loff_t pos;
 	int error;
+	pfn_t pfn;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1379,7 +1352,19 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		result = dax_pmd_insert_mapping(vmf, &iomap, pos, entry);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		if (error < 0)
+			goto finish_iomap;
+
+		entry = dax_insert_mapping_entry(mapping, vmf, entry,
+						dax_iomap_sector(&iomap, pos),
+						RADIX_DAX_PMD);
+		if (IS_ERR(entry))
+			goto finish_iomap;
+
+		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
+		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
+					    write);
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index fbc4a06f7310..88a9d19b8ff8 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -148,7 +148,6 @@ DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 	TP_ARGS(inode, vmf, length, pfn, radix_entry))
 
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
-DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
 
 DECLARE_EVENT_CLASS(dax_pte_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
-- 
2.12.3

