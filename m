Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9CA47F3F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C76D3304051
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	krChu7duFPlScGqy for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:50 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: write failure beyond EOF truncates too much data
Date: Fri, 21 Mar 2014 21:11:46 +1100
Message-Id: <1395396710-3824-3-git-send-email-david@fromorbit.com>
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

If we fail a write beyond EOF and have to handle it in
xfs_vm_write_begin(), we truncate the inode back to the current inode
size. This doesn't take into account the fact that we may have
already made successful writes to the same page (in the case of block
size < page size) and hence we can truncate the page cache away from
blocks with valid data in them. If these blocks are delayed
allocation blocks, we now have a mismatch between the page cache and
the extent tree, and this will trigger - at minimum - a delayed
block count mismatch assert when the inode is evicted from the cache.
We can also trip over it when block mapping for direct IO - this is
the most common symptom seen from fsx and fsstress when run from
xfstests.

Fix it by only truncating away the exact range we are updating state
for in this write_begin call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e810243..6b4ecc8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1609,12 +1609,18 @@ xfs_vm_write_begin(
 	status = __block_write_begin(page, pos, len, xfs_get_blocks);
 	if (unlikely(status)) {
 		struct inode	*inode = mapping->host;
+		size_t		isize = i_size_read(inode);
 
 		xfs_vm_write_failed(inode, page, pos, len);
 		unlock_page(page);
 
-		if (pos + len > i_size_read(inode))
-			truncate_pagecache(inode, i_size_read(inode));
+		/*
+		 * If the write is beyond EOF, we only want to kill blocks
+		 * allocated in this write, not blocks that were previously
+		 * written successfully.
+		 */
+		if (pos + len > isize)
+			truncate_pagecache_range(inode, pos, pos + len);
 
 		page_cache_release(page);
 		page = NULL;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
