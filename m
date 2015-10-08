Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6CEB7F37
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 16:58:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B60EAC00E
	for <xfs@oss.sgi.com>; Thu,  8 Oct 2015 14:58:12 -0700 (PDT)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	7ZqoXFZ3Lto8jVig for <xfs@oss.sgi.com>;
	Thu, 08 Oct 2015 14:58:10 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] xfs: clarify lock ordering comment
Date: Thu,  8 Oct 2015 15:58:01 -0600
Message-Id: <1444341481-14139-1-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

Replace "i_mmap_lock" with "mmap_lock" in the lock ordering comment above
xfs_filemap_page_mkwrite().  The lock in question is actually the
XFS_MMAPLOCK_SHARED rw_semaphore (no leading "i"), and this comment is
easily confused with the "i_mmap_lock_[read|write]" functions that operate
on struct address_space->i_mmap_rwsem.  This clarification is especially
important because address_space->i_mmap_rwsem is taken down in the DAX
code as part of this fault path.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index f429662..b190033 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1477,7 +1477,7 @@ xfs_file_llseek(
  *
  * mmap_sem (MM)
  *   sb_start_pagefault(vfs, freeze)
- *     i_mmap_lock (XFS - truncate serialisation)
+ *     mmap_lock (XFS - truncate serialisation)
  *       page_lock (MM)
  *         i_lock (XFS - extent map serialisation)
  */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
