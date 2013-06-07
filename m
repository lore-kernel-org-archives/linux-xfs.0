Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F2E27F55
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 00:46:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4F66E8F8052
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 22:46:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1tD9TORrEfaSz0fv for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 22:46:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkpUi-0004Xv-8z
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:48 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkpUT-0003kS-5b
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 15:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/17] xfs: add pluging for bulkstat readahead
Date: Fri,  7 Jun 2013 15:45:14 +1000
Message-Id: <1370583929-14276-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1370583929-14276-1-git-send-email-david@fromorbit.com>
References: <1370583929-14276-1-git-send-email-david@fromorbit.com>
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

I was running some tests on bulkstat on CRC enabled filesystems when
I noticed that all the IO being issued was 8k in size, regardless of
the fact taht we are issuing sequential 8k buffers for inodes
clusters. The IO size shoul dbe 16k for 256 byte inodes, and 32k for
512 byte inodes, but this wasn't happening.

blktrace showed that there was an explict plug and unplug happening
around each readahead IO from _xfs_buf_ioapply, and the unplug was
causing the IO to be issued immediately. Hence no opportunity was
being given to the elevator to merge adjacent readahead requests and
dispatch them as a single IO.

Add plugging around the inode chunk readahead dispatch loop tin
bulkstat to ensure that we don't unplug the queue between adjacent
inode buffer readahead IOs and so we get fewer, larger IO requests
hitting the storage subsystemi for bulkstat.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_itable.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 2ea7d40..06d004d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -383,11 +383,13 @@ xfs_bulkstat(
 			 * Also start read-ahead now for this chunk.
 			 */
 			if (r.ir_freecount < XFS_INODES_PER_CHUNK) {
+				struct blk_plug	plug;
 				/*
 				 * Loop over all clusters in the next chunk.
 				 * Do a readahead if there are any allocated
 				 * inodes in that cluster.
 				 */
+				blk_start_plug(&plug);
 				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
 				for (chunkidx = 0;
 				     chunkidx < XFS_INODES_PER_CHUNK;
@@ -399,6 +401,7 @@ xfs_bulkstat(
 							agbno, nbcluster,
 							&xfs_inode_buf_ops);
 				}
+				blk_finish_plug(&plug);
 				irbp->ir_startino = r.ir_startino;
 				irbp->ir_freecount = r.ir_freecount;
 				irbp->ir_free = r.ir_free;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
