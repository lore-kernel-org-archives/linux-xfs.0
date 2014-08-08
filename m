Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D79B57F59
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 11:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 58B09AC004
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 09:05:01 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id OOtgEeCKuiWncMlt
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 09:04:58 -0700 (PDT)
Message-ID: <53E4F518.9030107@fb.com>
Date: Fri, 8 Aug 2014 12:04:40 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: [PATCH RFC] xfs: use invalidate_inode_pages2_range for DIO writes
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
during DIO writes.  The other filesystems are calling
invalidate_inode_pages2_range
 
truncate_pagecache_range is meant to be used when we are freeing the
underlying data structs from disk, so it will zero any partial ranges
in the page.  This means a DIO write can zero out part of the page cache
page, and it is possible the page will stay in cache.

This one is an RFC because it is untested and because I don't understand
how XFS is dealing with pages the truncate was unable to clear away.
I'm not able to actually trigger zeros by mixing DIO writes with
buffered reads.

Signed-off-by: Chris Mason <clm@fb.com>

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8d25d98..c30c112 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -638,7 +638,10 @@ xfs_file_dio_aio_write(
 						    pos, -1);
 		if (ret)
 			goto out;
-		truncate_pagecache_range(VFS_I(ip), pos, -1);
+
+		/* what do we do if we can't invalidate the pages? */
+		invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+					      pos >> PAGE_CACHE_SHIFT, -1);
 	}
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
