Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF22F7F69
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 00:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF4A98F8039
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 22:09:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yAygDWfCjAW6tct7 for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 22:09:39 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/6] xfs: don't zero partial page cache pages during O_DIRECT
	writes
Date: Thu, 21 Aug 2014 15:09:11 +1000
Message-Id: <1408597754-13526-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1408597754-13526-1-git-send-email-david@fromorbit.com>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
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
Cc: clm@fb.com

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
