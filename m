Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932197AbdJXPZb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Oct 2017 11:25:31 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/17] dax: Create local variable for vmf->flags & FAULT_FLAG_WRITE test
Date: Tue, 24 Oct 2017 17:24:03 +0200
Message-Id: <20171024152415.22864-7-jack@suse.cz>
In-Reply-To: <20171024152415.22864-1-jack@suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

There are already two users and more are coming.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c09465884bbe..5ea71381dba0 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1116,6 +1116,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	int vmf_ret = 0;
 	void *entry;
 
@@ -1130,7 +1131,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		goto out;
 	}
 
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
+	if (write && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
 
 	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
@@ -1207,7 +1208,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
-		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
+		if (!write) {
 			vmf_ret = dax_load_hole(mapping, entry, vmf);
 			goto finish_iomap;
 		}
-- 
2.12.3

