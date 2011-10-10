Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A18rf4136253 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:08:53 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4B4251C78C39
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:08:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LBnRT2BBkxtmRHWT for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:08:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD4MK-0003mV-BM
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:48 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD4MA-0003uq-4x
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 12:08:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] repair: handle memory allocation failure from blkmap_grow
Date: Mon, 10 Oct 2011 12:08:33 +1100
Message-Id: <1318208915-14975-4-git-send-email-david@fromorbit.com>
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

If blkmap_grow fails to allocate a new chunk of memory, it returns
with a null blkmap. The sole caller of blkmap_grow does not check
for this failure, and so will segfault if this error ever occurs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/bmap.c   |   33 ++++++++++++++++++++++-----------
 repair/bmap.h   |    2 +-
 repair/dinode.c |   22 ++++++++++++++++++++--
 3 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 0ff9315..e290515 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -207,29 +207,34 @@ blkmap_next_off(
  */
 static blkmap_t *
 blkmap_grow(
-	blkmap_t	**blkmapp)
+	blkmap_t	*blkmap)
 {
 	pthread_key_t	key = dblkmap_key;
-	blkmap_t	*blkmap = *blkmapp;
+	blkmap_t	*new_blkmap;
+	int		new_naexts = blkmap->naexts + 4;
 
 	if (pthread_getspecific(key) != blkmap) {
 		key = ablkmap_key;
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
-	blkmap->naexts += 4;
-	blkmap = realloc(blkmap, BLKMAP_SIZE(blkmap->naexts));
-	if (blkmap == NULL)
+	new_blkmap = realloc(blkmap, BLKMAP_SIZE(new_naexts));
+	if (!new_blkmap) {
 		do_error(_("realloc failed in blkmap_grow\n"));
-	*blkmapp = blkmap;
-	pthread_setspecific(key, blkmap);
-	return blkmap;
+		return NULL;
+	}
+	new_blkmap->naexts = new_naexts;
+	pthread_setspecific(key, new_blkmap);
+	return new_blkmap;
 }
 
 /*
  * Set an extent into a block map.
+ *
+ * If this function fails, it leaves the blkmapp untouched so the caller can
+ * handle the error and free the blkmap appropriately.
  */
-void
+int
 blkmap_set_ext(
 	blkmap_t	**blkmapp,
 	xfs_dfiloff_t	o,
@@ -239,9 +244,14 @@ blkmap_set_ext(
 	blkmap_t	*blkmap = *blkmapp;
 	xfs_extnum_t	i;
 
-	if (blkmap->nexts == blkmap->naexts)
-		blkmap = blkmap_grow(blkmapp);
+	if (blkmap->nexts == blkmap->naexts) {
+		blkmap = blkmap_grow(blkmap);
+		if (!blkmap)
+			return ENOMEM;
+		*blkmapp = blkmap;
+	}
 
+	ASSERT(blkmap->nexts < blkmap->naexts);
 	for (i = 0; i < blkmap->nexts; i++) {
 		if (blkmap->exts[i].startoff > o) {
 			memmove(blkmap->exts + i + 1,
@@ -255,4 +265,5 @@ blkmap_set_ext(
 	blkmap->exts[i].startblock = b;
 	blkmap->exts[i].blockcount = c;
 	blkmap->nexts++;
+	return 0;
 }
diff --git a/repair/bmap.h b/repair/bmap.h
index 58abf95..118ae1e 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -43,7 +43,7 @@ typedef	struct blkmap {
 blkmap_t	*blkmap_alloc(xfs_extnum_t nex, int whichfork);
 void		blkmap_free(blkmap_t *blkmap);
 
-void		blkmap_set_ext(blkmap_t **blkmapp, xfs_dfiloff_t o,
+int		blkmap_set_ext(blkmap_t **blkmapp, xfs_dfiloff_t o,
 			       xfs_dfsbno_t b, xfs_dfilblks_t c);
 
 xfs_dfsbno_t	blkmap_get(blkmap_t *blkmap, xfs_dfiloff_t o);
diff --git a/repair/dinode.c b/repair/dinode.c
index 5a74538..39a0cb1 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -730,9 +730,27 @@ _("inode %" PRIu64 " - extent offset too large - start %" PRIu64 ", "
 			goto done;
 		}
 
-		if (blkmapp && *blkmapp)
-			blkmap_set_ext(blkmapp, irec.br_startoff,
+		if (blkmapp && *blkmapp) {
+			error = blkmap_set_ext(blkmapp, irec.br_startoff,
 					irec.br_startblock, irec.br_blockcount);
+			if (error) {
+				/*
+				 * we don't want to clear the inode due to an
+				 * internal bmap tracking error, but if we've
+				 * run out of memory then we simply can't
+				 * validate that the filesystem is consistent.
+				 * Hence just abort at this point with an ENOMEM
+				 * error.
+				 */
+				do_abort(
+_("Fatal error: inode %" PRIu64 " - blkmap_set_ext(): %s\n"
+  "\t%s fork, off - %" PRIu64 ", start - %" PRIu64 ", cnt %" PRIu64 "\n"),
+					ino, strerror(error), forkname,
+					irec.br_startoff, irec.br_startblock,
+					irec.br_blockcount);
+			}
+		}
+
 		/*
 		 * Profiling shows that the following loop takes the
 		 * most time in all of xfs_repair.
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
