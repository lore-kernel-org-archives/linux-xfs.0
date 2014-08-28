Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C0F57F47
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 06:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EED4A304048
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 04:49:21 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GiYo4kvab5M0yjw9 for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 04:49:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XMyCX-0000FM-Fh
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XMyCX-0004Kg-Er
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/7] xfs: don't zero partial page cache pages during O_DIRECT
	writes
Date: Thu, 28 Aug 2014 21:49:06 +1000
Message-Id: <1409226551-16570-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1409226551-16570-1-git-send-email-david@fromorbit.com>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
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

From: Chris Mason <clm@fb.com>

xfs is using truncate_pagecache_range to invalidate the page cache
during DIO reads.  This is different from the other filesystems who
only invalidate pages during DIO writes.

truncate_pagecache_range is meant to be used when we are freeing the
underlying data structs from disk, so it will zero any partial
ranges in the page.  This means a DIO read can zero out part of the
page cache page, and it is possible the page will stay in cache.

buffered reads will find an up to date page with zeros instead of
the data actually on disk.

This patch fixes things by using invalidate_inode_pages2_range
instead.  It preserves the page cache invalidation, but won't zero
any pages.

[dchinner: catch error and warn if it fails. Comment.]

cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@fb.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 076b170..827cfb2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -296,7 +296,16 @@ xfs_file_read_iter(
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
-			truncate_pagecache_range(VFS_I(ip), pos, -1);
+
+			/*
+			 * Invalidate whole pages. This can return an error if
+			 * we fail to invalidate a page, but this should never
+			 * happen on XFS. Warn if it does fail.
+			 */
+			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+						pos >> PAGE_CACHE_SHIFT, -1);
+			WARN_ON_ONCE(ret);
+			ret = 0;
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
