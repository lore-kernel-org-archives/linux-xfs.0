Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0R3rlGc184581 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 21:53:47 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 868D91A2AB3C
	for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 19:56:10 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VU6aJaTXhVgc7Cmu for <xfs@oss.sgi.com>;
	Wed, 26 Jan 2011 19:56:10 -0800 (PST)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PiIxh-0008FF-Sv
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:55:57 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PiIvF-0004T6-6D
	for xfs@oss.sgi.com; Thu, 27 Jan 2011 14:53:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfs: speculative delayed allocation uses
	rounddown_power_of_2 badly
Date: Thu, 27 Jan 2011 14:53:16 +1100
Message-Id: <1296100401-17135-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1296100401-17135-1-git-send-email-david@fromorbit.com>
References: <1296100401-17135-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

rounddown_power_of_2() returns an undefined result when passed a
value of zero. The specualtive delayed allocation code is doing this
when the inode is zero length. Hence occasionally the preallocation
is much, much larger than is necessary (e.g. 8GB for a 270 _byte_
file). Ensure we don't even pass a zero value to this function so
the result of preallocation is always the desired size.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_iomap.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 55582bd..8a0f044 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -337,7 +337,12 @@ xfs_iomap_prealloc_size(
 		int shift = 0;
 		int64_t freesp;
 
-		alloc_blocks = XFS_B_TO_FSB(mp, ip->i_size);
+		/*
+		 * rounddown_pow_of_two() returns an undefined result
+		 * if we pass in alloc_blocks = 0. Hence the "+ 1" to
+		 * ensure we always pass in a non-zero value.
+		 */
+		alloc_blocks = XFS_B_TO_FSB(mp, ip->i_size) + 1;
 		alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
 					rounddown_pow_of_two(alloc_blocks));
 
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
