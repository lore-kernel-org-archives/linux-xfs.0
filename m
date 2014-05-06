Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 223167F93
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:42:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABD5DAC003
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:42:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rM7REAzFnJ8SEGi7 for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:42:13 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWGf-0002TP-0y
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:42:09 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWGf-00059B-00
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:42:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix directory readahead offset off-by-one
Date: Tue,  6 May 2014 13:42:08 +1000
Message-Id: <1399347728-19752-1-git-send-email-david@fromorbit.com>
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

Directory readahead can throw loud scary but harmless warnings
when multiblock directories are in use a specific pattern of
discontiguous blocks are found in the directory. That is, if a hole
follows a discontiguous block, it will throw a warning like:

XFS (dm-1): xfs_da_do_buf: bno 637 dir: inode 34363923462
XFS (dm-1): [00] br_startoff 637 br_startblock 1917954575 br_blockcount 1 br_state 0
XFS (dm-1): [01] br_startoff 638 br_startblock -2 br_blockcount 1 br_state 0

And dump a stack trace.

This is because the readahead offset increment loop does a double
increment of the block index - it does an increment for the loop
iteration as well as increase the loop counter by the number of
blocks in the extent. As a result, the readahead offset does not get
incremented correctly for discontiguous blocks and hence can ask for
readahead of a directory block from an offset part way through a
directory block.  If that directory block is followed by a hole, it
will trigger a mapping warning like the above.

The bad readahead will be ignored, though, because the main
directory block read loop uses the correct mapping offsets rather
than the readahead offset and so will ignore the bad readahead
altogether.

Fix the warning by ensuring that the readahead offset is correctly
incremented.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 50b72f7..fe2db98 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -456,7 +456,7 @@ xfs_dir2_leaf_readbuf(
 		/*
 		 * Advance offset through the mapping table.
 		 */
-		for (j = 0; j < mp->m_dirblkfsbs; j++) {
+		for (j = 0; j < mp->m_dirblkfsbs; ) {
 			/*
 			 * The rest of this extent but not more than a dir
 			 * block.
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
