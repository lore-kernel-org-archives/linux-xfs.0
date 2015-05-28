Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C265B7F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E8D5AC003
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:10 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xriIALAOI30XqLBZ for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:08 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006co-8T
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024G-7e
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfs: mmap lock needs to be inside freeze protection
Date: Fri, 29 May 2015 09:45:48 +1000
Message-Id: <1432856755-7859-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 3b75912..4a0af89 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1487,15 +1487,20 @@ xfs_filemap_page_mkwrite(
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
