Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53159 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752236AbdHQQIa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 12:08:30 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/13] dax: Create local variable for vmf->flags & FAULT_FLAG_WRITE test
Date: Thu, 17 Aug 2017 18:08:07 +0200
Message-Id: <20170817160815.30466-6-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>

There are already two users and more are coming.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 75aa0d9fb39f..7c150eddc01a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1105,6 +1105,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	struct iomap iomap = { 0 };
 	unsigned flags = IOMAP_FAULT;
 	int error, major = 0;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	int vmf_ret = 0;
 	void *entry;
 
@@ -1119,7 +1120,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 		goto out;
 	}
 
-	if ((vmf->flags & FAULT_FLAG_WRITE) && !vmf->cow_page)
+	if (write && !vmf->cow_page)
 		flags |= IOMAP_WRITE;
 
 	entry = grab_mapping_entry(mapping, vmf->pgoff, 0);
@@ -1196,7 +1197,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
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

