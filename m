Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5629D7F75
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 19:03:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 467CC30408D
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:54 -0700 (PDT)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	9XB1pMj2tLOy9K50 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Aug 2013 17:03:53 -0700 (PDT)
Received: by mail-pd0-f179.google.com with SMTP id v10so2585139pde.10
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 17:03:53 -0700 (PDT)
From: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 7/7] xfs: Defer mmap cmtime updates
Date: Thu, 22 Aug 2013 17:03:23 -0700
Message-Id: <67df6fbc92d9b92a8301b4ad72e2a760d5e662df.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
In-Reply-To: <cover.1377193658.git.luto@amacapital.net>
References: <cover.1377193658.git.luto@amacapital.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>

This involves a change to block_page_mkwrite.  xfs is the only user.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/buffer.c       | 7 -------
 fs/xfs/xfs_aops.c | 1 +
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 4d74335..408677c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2431,13 +2431,6 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
 
 	sb_start_pagefault(sb);
-
-	/*
-	 * Update file times before taking page lock. We may end up failing the
-	 * fault so this update may be superfluous but who really cares...
-	 */
-	file_update_time(vma->vm_file);
-
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	sb_end_pagefault(sb);
 	return block_page_mkwrite_return(ret);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 596ec71..aa8fbcf 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1668,6 +1668,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.readpages		= xfs_vm_readpages,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
+	.update_cmtime_deferred	= generic_update_cmtime_deferred,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
