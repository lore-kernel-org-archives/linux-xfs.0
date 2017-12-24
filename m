Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17309 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752619AbdLXBEc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Dec 2017 20:04:32 -0500
Subject: [PATCH v4 03/18] ext2: auto disable dax instead of failing mount
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:17 -0800
Message-ID: <151407697703.38751.2935252018151032360.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

Bring the ext2 filesystem in line with xfs that only warns and continues
when the "-o dax" option is specified to mount and the backing device
does not support dax. This is in preparation for removing dax support
from devices that do not enable get_user_pages() operations on dax
mappings. In other words 'gup' support is required and configurations
that were using so called 'page-less' dax will be converted back to
using the page cache.

Removing the broken 'page-less' dax support is a pre-requisite for
removing the "EXPERIMENTAL" warning when mounting a filesystem in dax
mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7646818ab266..38f9222606ee 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -959,8 +959,11 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		err = bdev_dax_supported(sb, blocksize);
-		if (err)
-			goto failed_mount;
+		if (err) {
+			ext2_msg(sb, KERN_ERR,
+				"DAX unsupported by block device. Turning off DAX.");
+			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
+		}
 	}
 
 	/* If the blocksize doesn't match, re-read the thing.. */

