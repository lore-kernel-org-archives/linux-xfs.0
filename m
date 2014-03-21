Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41B9C7F3F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 30B638F8068
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:55 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	N5kSLZa36bB9A70i for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:53 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: xfs_vm_write_end truncates too much on failure
Date: Fri, 21 Mar 2014 21:11:47 +1100
Message-Id: <1395396710-3824-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1395396710-3824-1-git-send-email-david@fromorbit.com>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
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
Cc: Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

From: Dave Chinner <dchinner@redhat.com>

Similar to the write_begin problem, xfs-vm_write_end will truncate
back to the old EOF, potentially removing page cache from over the
top of delalloc blocks with valid data in them. Fix this by
truncating back to just the start of the failed write.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6b4ecc8..8bbd8ba 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1631,9 +1631,12 @@ xfs_vm_write_begin(
 }
 
 /*
- * On failure, we only need to kill delalloc blocks beyond EOF because they
- * will never be written. For blocks within EOF, generic_write_end() zeros them
- * so they are safe to leave alone and be written with all the other valid data.
+ * On failure, we only need to kill delalloc blocks beyond EOF in the range of
+ * this specific write because they will never be written. Previous writes
+ * beyond EOF where block allocation succeeded do not need to be trashed, so
+ * only new blocks from this write should be trashed. For blocks within
+ * EOF, generic_write_end() zeros them so they are safe to leave alone and be
+ * written with all the other valid data.
  */
 STATIC int
 xfs_vm_write_end(
@@ -1656,8 +1659,11 @@ xfs_vm_write_end(
 		loff_t		to = pos + len;
 
 		if (to > isize) {
-			truncate_pagecache(inode, isize);
+			/* only kill blocks in this write beyond EOF */
+			if (pos > isize)
+				isize = pos;
 			xfs_vm_kill_delalloc_range(inode, isize, to);
+			truncate_pagecache_range(inode, isize, to);
 		}
 	}
 	return ret;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
