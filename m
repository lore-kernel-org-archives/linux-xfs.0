Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C5867F59
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 00:29:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5862F8F8037
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 22:29:40 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wMxjKZIYJZc0rUB4 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 22:29:38 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHp2i-0004rr-0Z
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:32 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHp2h-0001Lr-Vr
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 17:29:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] repair: BMBT prefetch needs to be CRC aware
Date: Mon, 24 Feb 2014 17:29:29 +1100
Message-Id: <1393223369-4696-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1393223369-4696-1-git-send-email-david@fromorbit.com>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
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

I'd been trying to track down a behavioural difference between
non-crc and crc enabled filesystems that was resulting non-crc
filesystem executing prefetch almost 3x faster than CRC filesystems.
After amny ratholes, I finally stumbled on the fact that btree
format directories are not being prefetched due to a missing magic
number check, and it's rejecting all XFS_BMAP_CRC_MAGIC format BMBT
buffers. This makes prefetch on CRC enabled filesystems behave the
same as for non-CRC filesystems.

The difference a single line of code can make on a 50 million inode
filesystem with a single threaded prefetch enabled run is pretty
amazing. It goes from 3,000 iops @ 50MB/s to 2,000 IOPS @ 800MB/s
and the cache hit rate goes from 3% to 49%. The runtime difference:

Unpatched:

Phase           Start           End             Duration
Phase 1:        02/21 18:34:12  02/21 18:34:12
Phase 2:        02/21 18:34:12  02/21 18:34:15  3 seconds
Phase 3:        02/21 18:34:15  02/21 18:40:09  5 minutes, 54 seconds
Phase 4:        02/21 18:40:09  02/21 18:46:36  6 minutes, 27 seconds
Phase 5:        02/21 18:46:36  02/21 18:46:37  1 second
Phase 6:        02/21 18:46:37  02/21 18:52:51  6 minutes, 14 seconds
Phase 7:        02/21 18:52:51  02/21 18:52:52  1 second

Total run time: 18 minutes, 40 seconds

Patched:

Phase           Start           End             Duration
Phase 1:        02/21 19:58:23  02/21 19:58:23
Phase 2:        02/21 19:58:23  02/21 19:58:27  4 seconds
Phase 3:        02/21 19:58:27  02/21 19:59:20  53 seconds
Phase 4:        02/21 19:59:20  02/21 20:00:07  47 seconds
Phase 5:        02/21 20:00:07  02/21 20:00:08  1 second
Phase 6:        02/21 20:00:08  02/21 20:00:50  42 seconds
Phase 7:        02/21 20:00:50  02/21 20:00:50

Total run time: 2 minutes, 27 seconds

Is no less impressive. Shame it's just a regression fix. ;)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/prefetch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 5158863..7e11d1d 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -298,7 +298,8 @@ pf_scanfunc_bmap(
 	/*
 	 * do some validation on the block contents
 	 */
-	if ((be32_to_cpu(block->bb_magic) != XFS_BMAP_MAGIC) ||
+	if ((block->bb_magic != cpu_to_be32(XFS_BMAP_MAGIC) &&
+	     block->bb_magic != cpu_to_be32(XFS_BMAP_CRC_MAGIC)) ||
 			(be16_to_cpu(block->bb_level) != level))
 		return 0;
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
