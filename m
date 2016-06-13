Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1E4F7CA0
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 13:37:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DC65AC003
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2016 11:37:36 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id CuOxzZnAeJ42PQoo
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jun 2016 11:37:34 -0700 (PDT)
Content-Disposition: inline
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 13 Jun 2016 19:36:37 +0100
Message-ID: <lsq.1465842997.733859592@decadent.org.uk>
Subject: [PATCH 3.16 097/114] xfs: mmap lock needs to be inside freeze
	protection
In-Reply-To: <lsq.1465842997.838358341@decadent.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>, akpm@linux-foundation.org

3.16.36-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit ec56b1f1fdc69599963574ce94cc5693d535dd64 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com
---
 fs/xfs/xfs_file.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1441,15 +1441,20 @@ xfs_filemap_page_mkwrite(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
