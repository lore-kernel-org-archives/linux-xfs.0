Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E6897F54
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 20:17:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9A1F30404E
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 18:17:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	37hbA7cW78L58ELe for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 18:17:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WiZQu-0004KG-Rd
	for xfs@oss.sgi.com; Fri, 09 May 2014 11:17:04 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WiZQu-00019H-Qv
	for xfs@oss.sgi.com; Fri, 09 May 2014 11:17:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] repair: don't grind CPUs with large extent lists
Date: Fri,  9 May 2014 11:17:02 +1000
Message-Id: <1399598222-4349-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1399598222-4349-1-git-send-email-david@fromorbit.com>
References: <1399598222-4349-1-git-send-email-david@fromorbit.com>
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

When repairing a large filesystem with fragemented files, xfs_repair
can grind to a halt burning multiple CPUs in blkmap_set_ext().
blkmap_set_ext() inserts extents into the blockmap for the inode
fork and it keeps them in order, even if the inserts are not done in
order.

The ordered insert is highly inefficient - it starts at the first
extent, and simple walks the array to find the insertion point. i.e.
it is an O(n) operation. When we have a fragemented file with a
large number of extents, the cost of the entire mapping operation
is rather costly.

The thing is, we are doing the insertion from an *ordered btree
scan* which is inserting the extents in ascending offset order.
IOWs, we are always inserting the extent at the end of the array
after searching the entire array. i.e. the mapping operation cost is
O(N^2).

Fix this simply by reversing the order of the insert slot search.
Start at the end of the blockmap array when we do almost all
insertions, which brings the overhead of each insertion down to O(1)
complexity. This, in turn, results in the overall map building
operation being reduced to an O(N) operation, and so performance
degrades linearly with increasing extent counts rather than
exponentially.

The result is that the test filesystem (27TB, 30M inodes, at ENOSPC)
takes 5m10s to *fully repair* on my test system, rather that getting
15 (of 60) AGs into phase three and sitting there burning 3-4 CPUs
making no progress for over half an hour.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/bmap.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 14161cb..1e913c5 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -260,7 +260,15 @@ blkmap_grow(
 {
 	pthread_key_t	key = dblkmap_key;
 	blkmap_t	*new_blkmap;
-	int		new_naexts = blkmap->naexts + 4;
+	int		new_naexts;
+
+	/* reduce the number of reallocations for large files */
+	if (blkmap->naexts < 1000)
+		new_naexts = blkmap->naexts + 4;
+	else if (blkmap->naexts < 10000)
+		new_naexts = blkmap->naexts + 100;
+	else
+		new_naexts = blkmap->naexts + 1000;
 
 	if (pthread_getspecific(key) != blkmap) {
 		key = ablkmap_key;
@@ -308,7 +316,7 @@ blkmap_set_ext(
 	xfs_dfilblks_t	c)
 {
 	blkmap_t	*blkmap = *blkmapp;
-	xfs_extnum_t	i;
+	xfs_extnum_t	i = 0;
 
 	if (blkmap->nexts == blkmap->naexts) {
 		blkmap = blkmap_grow(blkmap);
@@ -318,15 +326,27 @@ blkmap_set_ext(
 	}
 
 	ASSERT(blkmap->nexts < blkmap->naexts);
-	for (i = 0; i < blkmap->nexts; i++) {
-		if (blkmap->exts[i].startoff > o) {
-			memmove(blkmap->exts + i + 1,
-				blkmap->exts + i,
-				sizeof(bmap_ext_t) * (blkmap->nexts - i));
+
+	if (blkmap->nexts == 0)
+		goto insert;
+
+	/*
+	 * Do a reverse order search as the most common insertion during
+	 * a bmapbt scan is at the end of the map. Use "plus 1" indexing
+	 * for the loop counter so when we break out we are at the correct index
+	 * for insertion.
+	 */
+	for (i = blkmap->nexts; i > 0; i--) {
+		if (blkmap->exts[i - 1].startoff < o)
 			break;
-		}
 	}
 
+	/* make space for the new extent */
+	memmove(blkmap->exts + i + 1,
+		blkmap->exts + i,
+		sizeof(bmap_ext_t) * (blkmap->nexts - i));
+
+insert:
 	blkmap->exts[i].startoff = o;
 	blkmap->exts[i].startblock = b;
 	blkmap->exts[i].blockcount = c;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
