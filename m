Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbdLRPMT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 10:12:19 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 07/19] exofs: switch to new i_version API
Date: Mon, 18 Dec 2017 10:11:44 -0500
Message-Id: <20171218151156.14565-8-jlayton@kernel.org>
In-Reply-To: <20171218151156.14565-1-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/exofs/dir.c   | 9 +++++----
 fs/exofs/super.c | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 98233a97b7b8..c5a53fcc43ea 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -31,6 +31,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/iversion.h>
 #include "exofs.h"
 
 static inline unsigned exofs_chunk_size(struct inode *inode)
@@ -60,7 +61,7 @@ static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion(dir);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
@@ -241,7 +242,7 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(exofs_chunk_size(inode)-1);
-	int need_revalidate = (file->f_version != inode->i_version);
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 
 	if (pos > inode->i_size - EXOFS_DIR_REC_LEN(1))
 		return 0;
@@ -264,8 +265,8 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 								chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_query_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (struct exofs_dir_entry *)(kaddr + offset);
 		limit = kaddr + exofs_last_byte(inode, n) -
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 819624cfc8da..7e244093c0e5 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/exportfs.h>
 #include <linux/slab.h>
+#include <linux/iversion.h>
 
 #include "exofs.h"
 
@@ -159,7 +160,7 @@ static struct inode *exofs_alloc_inode(struct super_block *sb)
 	if (!oi)
 		return NULL;
 
-	oi->vfs_inode.i_version = 1;
+	inode_set_iversion(&oi->vfs_inode, 1);
 	return &oi->vfs_inode;
 }
 
-- 
2.14.3

