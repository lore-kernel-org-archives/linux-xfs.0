Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D6137F55
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 06:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0B3EAC002
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 04:49:18 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GDxo5L8hxR1k3gia for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 04:49:16 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XMyCX-0000FN-GD
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XMyCX-0004Kl-FK
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/7] xfs: don't zero partial page cache pages during O_DIRECT
	writes
Date: Thu, 28 Aug 2014 21:49:07 +1000
Message-Id: <1409226551-16570-4-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Similar to direct IO reads, direct IO writes are using
truncate_pagecache_range to invalidate the page cache. This is
incorrect due to the sub-block zeroing in the page cache that
truncate_pagecache_range() triggers.

This patch fixes things by using invalidate_inode_pages2_range
instead.  It preserves the page cache invalidation, but won't zero
any pages.

cc: stable@vger.kernel.org
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 827cfb2..19917fa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -644,7 +644,15 @@ xfs_file_dio_aio_write(
 						    pos, -1);
 		if (ret)
 			goto out;
-		truncate_pagecache_range(VFS_I(ip), pos, -1);
+		/*
+		 * Invalidate whole pages. This can return an error if
+		 * we fail to invalidate a page, but this should never
+		 * happen on XFS. Warn if it does fail.
+		 */
+		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+						pos >> PAGE_CACHE_SHIFT, -1);
+		WARN_ON_ONCE(ret);
+		ret = 0;
 	}
 
 	/*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
