Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49437 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbdEaQUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2017 12:20:47 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/24] tmpfs: generate random sb->s_uuid
Date: Wed, 31 May 2017 18:18:25 +0200
Message-Id: <20170531161826.23243-24-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

From: Amir Goldstein <amir73il@gmail.com>

This is used by overlayfs to encode intrasystem unique file handles.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba4e98e..391f2dcca727 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -75,6 +75,7 @@ static struct vfsmount *shm_mnt;
 #include <uapi/linux/memfd.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
+#include <linux/uuid.h>
 
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -3761,6 +3762,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
+	uuid_gen(&sb->s_uuid);
 
 	inode = shmem_get_inode(sb, NULL, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
-- 
2.11.0

