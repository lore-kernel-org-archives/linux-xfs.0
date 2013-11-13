Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 06F917FA1
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 00:41:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E09038F8035
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 22:41:23 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EpliGtWH4SVeuCNf for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 22:41:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VgU8O-0005cI-H5
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VgU8O-0006k4-Fv
	for xfs@oss.sgi.com; Wed, 13 Nov 2013 17:41:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 34/36] repair: prefetching is turned off unnecessarily
Date: Wed, 13 Nov 2013 17:40:58 +1100
Message-Id: <1384324860-25677-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1384324860-25677-1-git-send-email-david@fromorbit.com>
References: <1384324860-25677-1-git-send-email-david@fromorbit.com>
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

When we have a large filesystem, prefetching is only enabled when
there is a significant amount of RAM available - roughly 16GB RAM
for every 100TB of disk space. For large filesystems, this memory
usage calculation is mostly derived from the memory needed to track
used space rather than inodes. That is, for a 100TB filesystem with
50 million inodes, only 50M * 4 bytes or 200MB of the the required
16GB of RAM is used for tracking inodes. Hence with prefetching
turned off, such a filesystem only uses 230MB of memory to run
repair to completion.

With prefetching turned on, this increases to about 900MB of RAM,
but it is still far, far less than the predicted 16GB of RAM needed
to enable prefetching. Hence we are turning off prefetching when we
really don't need to and hence large filesystems are being checked
slower than they could be.

This patch makes prefetching always be enabled, but adds warnings in
the case that we might not have enough memory to complete
successfully and if it fails to run again with prefetching disabled:

  Memory available for repair (12031MB) may not be sufficient.
  At least 13044MB is needed to repair this filesystem efficiently
  If repair fails due to lack of memory, please
  turn prefetching off (-P) to reduce the memory footprint.

A similar warning is also added when prefetching is disabled and
xfs_repair exhausts memory then more RAM/swap should be added to the
system.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/xfs_repair.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 77a040e..78f8363 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -674,34 +674,36 @@ main(int argc, char **argv)
 				mp->m_sb.sb_dblocks >> (10 + 1));
 
 		if (max_mem <= mem_used) {
-			/*
-			 * Turn off prefetch and minimise libxfs cache if
-			 * physical memory is deemed insufficient
-			 */
 			if (max_mem_specified) {
 				do_abort(
 	_("Required memory for repair is greater that the maximum specified\n"
 	  "with the -m option. Please increase it to at least %lu.\n"),
 					mem_used / 1024);
-			} else {
-				do_warn(
-	_("Not enough RAM available for repair to enable prefetching.\n"
-	  "This will be _slow_.\n"
-	  "You need at least %luMB RAM to run with prefetching enabled.\n"),
-					mem_used * 1280 / (1024 * 1024));
 			}
-			do_prefetch = 0;
-			libxfs_bhash_size = 64;
-		} else {
-			max_mem -= mem_used;
-			if (max_mem >= (1 << 30))
-				max_mem = 1 << 30;
-			libxfs_bhash_size = max_mem / (HASH_CACHE_RATIO *
-					(mp->m_inode_cluster_size >> 10));
-			if (libxfs_bhash_size < 512)
-				libxfs_bhash_size = 512;
+			do_warn(
+	_("Memory available for repair (%luMB) may not be sufficient.\n"
+	  "At least %luMB is needed to repair this filesystem efficiently\n"
+	  "If repair fails due to lack of memory, please\n"),
+				max_mem / 1024, mem_used / 1024);
+			if (do_prefetch)
+				do_warn(
+	_("turn prefetching off (-P) to reduce the memory footprint.\n"));
+			else
+				do_warn(
+	_("increase system RAM and/or swap space to at least %luMB.\n"),
+			mem_used * 2 / 1024);
+
+			max_mem = mem_used;
 		}
 
+		max_mem -= mem_used;
+		if (max_mem >= (1 << 30))
+			max_mem = 1 << 30;
+		libxfs_bhash_size = max_mem / (HASH_CACHE_RATIO *
+				(mp->m_inode_cluster_size >> 10));
+		if (libxfs_bhash_size < 512)
+			libxfs_bhash_size = 512;
+
 		if (verbose)
 			do_log(_("        - block cache size set to %d entries\n"),
 				libxfs_bhash_size * HASH_CACHE_RATIO);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
