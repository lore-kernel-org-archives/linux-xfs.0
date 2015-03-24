Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB6337F3F
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B614304043
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9QQGHYoydSFZPJru for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:20 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: mmap lock needs to be inside freeze protection
Date: Tue, 24 Mar 2015 21:50:59 +1100
Message-Id: <1427194266-2885-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194266-2885-1-git-send-email-david@fromorbit.com>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

Lock ordering for the new mmap lock needs to be:

mmap_sem
  sb_start_pagefault
    i_mmap_lock
      page lock
        <fault processsing>

Right now xfs_vm_page_mkwrite gets this the wrong way around,
While technically it cannot deadlock due to the current freeze
ordering, it's still a landmine that might explode if we change
anything in future. Hence we need to nest the locks correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dc5f609..a4c882e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1449,15 +1449,20 @@ xfs_filemap_page_mkwrite(
 	struct vm_fault		*vmf)
 {
 	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
-	int			error;
+	int			ret;
 
 	trace_xfs_filemap_page_mkwrite(ip);
 
+	sb_start_pagefault(VFS_I(ip)->i_sb);
+	file_update_time(vma->vm_file);
 	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
-	error = block_page_mkwrite(vma, vmf, xfs_get_blocks);
+
+	ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
+
 	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	sb_end_pagefault(VFS_I(ip)->i_sb);
 
-	return error;
+	return block_page_mkwrite_return(ret);
 }
 
 const struct file_operations xfs_file_operations = {
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
