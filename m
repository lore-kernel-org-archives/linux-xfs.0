Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NCHZQ130733 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:12:17 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E44F55E0B7
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:12:15 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tWfGll6x11IkMnBR for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:12:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD2XL-0003b8-UW
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:12:03 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD2XB-0002vf-Nt
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] repair: don't cache large blkmap allocations
Date: Mon, 10 Oct 2011 10:11:49 +1100
Message-Id: <1318201910-11144-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1318201910-11144-1-git-send-email-david@fromorbit.com>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
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

We currently use thread local storage for storing blkmap allocations
from one inode to another as a way of reducing the number of short
term allocations we do. However, the stored allocations can only
ever grow, so once we've done a large allocation we never free than
memory even if we never need that much memory again. This can occur
if we have corrupted extent counts in inodes, and can greatly
increase the memory footprint of the repair process.

Hence if the cached blkmap array id greater than a reasonable number
of extents (say 100,000), then don't store the blkmap in TLS and
instead free it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/bmap.c   |   20 +++++++++++++++++++-
 repair/dinode.c |    6 ++----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 3ee5eff..3e53457 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -66,12 +66,30 @@ blkmap_alloc(
 
 /*
  * Free a block map.
+ *
+ * If the map is a large, uncommon size (say for hundreds of thousands of
+ * extents) then free it to release the memory. This prevents us from pinning
+ * large tracts of memory due to corrupted fork values or one-off fragmented
+ * files. Otherwise we have nothing to do but keep the memory around for the
+ * next inode
  */
 void
 blkmap_free(
 	blkmap_t	*blkmap)
 {
-	/* nothing to do! - keep the memory around for the next inode */
+	if (!blkmap)
+		return;
+
+	/* consider more than 100k extents rare */
+	if (blkmap->naexts < 100 * 1024)
+		return;
+
+	if (blkmap == pthread_getspecific(dblkmap_key))
+		pthread_setspecific(dblkmap_key, NULL);
+	else
+		pthread_setspecific(ablkmap_key, NULL);
+
+	free(blkmap);
 }
 
 /*
diff --git a/repair/dinode.c b/repair/dinode.c
index 0cedc28..8ad4e94 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2748,8 +2748,7 @@ process_dinode_int(xfs_mount_t *mp,
 		break;
 	}
 
-	if (dblkmap)
-		blkmap_free(dblkmap);
+	blkmap_free(dblkmap);
 
 	/*
 	 * check nlinks feature, if it's a version 1 inode,
@@ -2768,8 +2767,7 @@ clear_bad_out:
 bad_out:
 	*used = is_free;
 	*isa_dir = 0;
-	if (dblkmap)
-		blkmap_free(dblkmap);
+	blkmap_free(dblkmap);
 	return 1;
 }
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
