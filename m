Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:60434 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750964AbdJTCqW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 22:46:22 -0400
Subject: [PATCH v3 11/13] fs: use smp_load_acquire in break_{layout,lease}
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:57 -0700
Message-ID: <150846719726.24336.3564801642993121646.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, hch@lst.de, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, Ross Zwisler <ross.zwisler@linux.intel.com>

Commit 128a37852234 "fs: fix data races on inode->i_flctx" converted
checks of inode->i_flctx to use smp_load_acquire(), but it did not
convert break_layout(). smp_load_acquire() includes a READ_ONCE(). There
should be no functional difference since __break_lease repeats the
sequence, but this is a clean up to unify all ->i_flctx lookups on a
common pattern.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/fs.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 13dab191a23e..eace2c5396a7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2281,8 +2281,9 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 	 * could end up racing with tasks trying to set a new lease on this
 	 * file.
 	 */
-	smp_mb();
-	if (inode->i_flctx && !list_empty_careful(&inode->i_flctx->flc_lease))
+	struct file_lock_context *ctx = smp_load_acquire(&inode->i_flctx);
+
+	if (ctx && !list_empty_careful(&ctx->flc_lease))
 		return __break_lease(inode, mode, FL_LEASE);
 	return 0;
 }
@@ -2325,8 +2326,9 @@ static inline int break_deleg_wait(struct inode **delegated_inode)
 
 static inline int break_layout(struct inode *inode, bool wait)
 {
-	smp_mb();
-	if (inode->i_flctx && !list_empty_careful(&inode->i_flctx->flc_lease))
+	struct file_lock_context *ctx = smp_load_acquire(&inode->i_flctx);
+
+	if (ctx && !list_empty_careful(&ctx->flc_lease))
 		return __break_lease(inode,
 				wait ? O_WRONLY : O_WRONLY | O_NONBLOCK,
 				FL_LAYOUT);

