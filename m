Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A197sW136285 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:09:07 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34313152E48E
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:16:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LcngDLHCial68Fl7 for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:16:07 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD4MU-0003mh-Br
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:58 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD4MA-0003ut-6o
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] repair: don't cache large blkmap allocations
Date: Mon, 10 Oct 2011 12:08:34 +1100
Message-Id: <1318208915-14975-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1318208915-14975-1-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
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
index e290515..5fb27bc 100644
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
index 39a0cb1..fb5e53a 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2807,8 +2807,7 @@ _("bad non-zero extent size %u for non-realtime/extsize inode %" PRIu64 ", "),
 		break;
 	}
 
-	if (dblkmap)
-		blkmap_free(dblkmap);
+	blkmap_free(dblkmap);
 
 	/*
 	 * check nlinks feature, if it's a version 1 inode,
@@ -2827,8 +2826,7 @@ clear_bad_out:
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
