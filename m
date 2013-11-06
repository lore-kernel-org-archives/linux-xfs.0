Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5EA4129E2E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8934AC005
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:46 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PH7i8TERYkcitaxZ for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:45 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003P3-MD
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-000058-LP
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 36/37] repair: Increase default repair parallelism on large
	filesystems
Date: Wed,  6 Nov 2013 12:07:22 +1100
Message-Id: <1383700043-32305-37-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

Large filesystems or high AG count filesystems generally have more
inherent parallelism in the backing storage. We shoul dmake use of
this by default to speed up repair times. Make xfs_repair use an
"auto-stride" configuration on filesystems with enough AGs to be
considered "multidisk" configurations.

This difference in elaspsed time to repair a 100TB filesystem with
50 million inodes in it with all metadata in flash is:

		Time	IOPS	BW	CPU	RAM
vanilla:	2719s	 2900	 55MB/s	 25%	0.95GB
patched:	 908s	varied	varied	varied	2.33GB

With the patched kernel, there were IO peaks of over 1.3GB/s during
AG scanning. Some phases now run at noticably different speeds
	- phase 3 ran at ~180% CPU, 18,000 IOPS and 130MB/s,
	- phase 4 ran at ~280% CPU, 12,000 IOPS and 100MB/s
	- the other phases were similar to the vanilla repair.

Memory usage is increased because of the increased buffer cache
size as a result of concurrent AG scanning using it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/xfs_repair.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 78f8363..a863337 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -614,6 +614,23 @@ main(int argc, char **argv)
 	inodes_per_cluster = MAX(mp->m_sb.sb_inopblock,
 			XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
 
+	/*
+	 * Automatic striding for high agcount filesystems.
+	 *
+	 * More AGs indicates that the filesystem is either large or can handle
+	 * more IO parallelism. Either way, we should try to process multiple
+	 * AGs at a time in such a configuration to try to saturate the
+	 * underlying storage and speed the repair process. Only do this if
+	 * prefetching is enabled.
+	 *
+	 * Given mkfs defaults for 16AGs for "multidisk" configurations, we want
+	 * to target these for an increase in thread count. Hence a stride value
+	 * of 15 is chosen to ensure we get at least 2 AGs being scanned at once
+	 * on such filesystems.
+	 */
+	if (!ag_stride && glob_agcount >= 16 && do_prefetch)
+		ag_stride = 15;
+
 	if (ag_stride) {
 		thread_count = (glob_agcount + ag_stride - 1) / ag_stride;
 		thread_init();
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
