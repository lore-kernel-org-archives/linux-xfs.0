Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF9357F89
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 07:57:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEC838F8066
	for <xfs@oss.sgi.com>; Sat,  9 Aug 2014 05:57:07 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id 5s7okgtsuR1d979C
	for <xfs@oss.sgi.com>; Sat, 09 Aug 2014 05:57:06 -0700 (PDT)
Message-ID: <53E61A9C.4020807@fb.com>
Date: Sat, 9 Aug 2014 08:57:00 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: don't zero partial page cache pages during O_DIRECT
References: <53E4E03A.7050101@fb.com>
In-Reply-To: <53E4E03A.7050101@fb.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>


xfs is using truncate_pagecache_range to invalidate the page cache
during DIO reads.  This is different from the other filesystems who only
invalidate pages during DIO writes.

truncate_pagecache_range is meant to be used when we are freeing the
underlying data structs from disk, so it will zero any partial ranges in
the page.  This means a DIO read can zero out part of the page cache
page, and it is possible the page will stay in cache.

buffered reads will find an up to date page with zeros instead of the
data actually on disk.

This patch fixes things by using invalidate_inode_pages2_range instead.
It preserves the page cache invalidation, but won't zero any pages.

Signed-off-by: Chris Mason <clm@fb.com>
cc: stable@vger.kernel.org

---
 fs/xfs/xfs_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1f66779..023d575 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -295,7 +295,8 @@ xfs_file_read_iter(
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
-			truncate_pagecache_range(VFS_I(ip), pos, -1);
+			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+					      pos >> PAGE_CACHE_SHIFT, -1);
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}
-- 
1.8.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
