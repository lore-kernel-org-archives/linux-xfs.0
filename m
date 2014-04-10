Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77BCD7F9D
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 00:01:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A2AAAC006
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 22:01:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vFrGsUhAgsFtGTjA for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 22:01:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WY76e-0004cA-NY
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WY76e-0002CM-Ms
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: xfs_vm_write_end truncates too much on failure
Date: Thu, 10 Apr 2014 15:00:50 +1000
Message-Id: <1397106053-7489-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1397106053-7489-1-git-send-email-david@fromorbit.com>
References: <1397106053-7489-1-git-send-email-david@fromorbit.com>
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

Similar to the write_begin problem, xfs-vm_write_end will truncate
back to the old EOF, potentially removing page cache from over the
top of delalloc blocks with valid data in them. Fix this by
truncating back to just the start of the failed write.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5f29693..e0a7931 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1634,9 +1634,12 @@ xfs_vm_write_begin(
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
@@ -1659,8 +1662,11 @@ xfs_vm_write_end(
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
