Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:8919 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752792AbeDTWJR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Apr 2018 18:09:17 -0400
From: Aleksei Besogonov <cyberax@amazon.com>
Subject: [PATCH 2/2] xfs: add support for iomap-based swapfile activation
Date: Fri, 20 Apr 2018 22:08:15 +0000
Message-ID: <20180420220815.44160-3-cyberax@amazon.com>
In-Reply-To: <20180420220815.44160-1-cyberax@amazon.com>
References: <20180420220815.44160-1-cyberax@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Aleksei Besogonov <cyberax@amazon.com>

Use iomap-based swapfile activation instead of the default
generic_swapfile_activate bmap-based infrastructure.
---
 fs/xfs/xfs_aops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 31f1f10eecd1..878ff3872883 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1491,6 +1491,12 @@ xfs_vm_set_page_dirty(
 	return newly_dirty;
 }
 
+static int xfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+			     sector_t *span)
+{
+	return iomap_swap_activate(sis, file, span, &xfs_iomap_ops);
+}
+
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
 	.readpages		= xfs_vm_readpages,
@@ -1504,4 +1510,5 @@ const struct address_space_operations xfs_address_space_operations = {
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.swap_activate          = xfs_swap_activate,
 };
-- 
2.14.1

