Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9521F7FA6
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 00:01:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26624AC007
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 22:01:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EL0hAAPgFYIZqB24 for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 22:01:17 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WY76e-0004c9-N6
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WY76e-0002CH-MS
	for xfs@oss.sgi.com; Thu, 10 Apr 2014 15:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: write failure beyond EOF truncates too much data
Date: Thu, 10 Apr 2014 15:00:49 +1000
Message-Id: <1397106053-7489-3-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_aops.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 282c726..5f29693 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1609,12 +1609,21 @@ xfs_vm_write_begin(
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
+		if (pos + len > isize) {
+			ssize_t start = max_t(ssize_t, pos, isize);
+
+			truncate_pagecache_range(inode, start, pos + len);
+		}
 
 		page_cache_release(page);
 		page = NULL;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
