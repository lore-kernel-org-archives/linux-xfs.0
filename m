Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C425A7F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 18:29:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54CD7AC003
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 16:29:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ab8S71IuG5GO9GSL for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 16:29:17 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47NTGDo027647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 7 May 2014 19:29:16 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s47NTEsN031711
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 19:29:16 -0400
Message-ID: <536AC1CB.8060601@redhat.com>
Date: Wed, 07 May 2014 18:29:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: don't unlock prefetch tree to read discontig
	buffers
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

The way discontiguous buffers are currently handled in
prefetch is by unlocking the prefetch tree and reading
them one at a time in pf_read_discontig(), inside the
normal loop of searching for buffers to read in a more
optimized fashion.

But by unlocking the tree, we allow other threads to come
in and find buffers which we've already stashed locally
on our bplist[].  If 2 threads think they own the same
set of buffers, they may both try to delete them from
the prefetch btree, and the second one to arrive will not
find it, resulting in:

	fatal error -- prefetch corruption

Fix this by maintaining 2 lists; the original bplist,
and a new one containing only discontiguous buffers.

The original list can be seek-optimized as before,
and the discontiguous list can be read one by one
before we do the seek-optimized reads, after all of the
tree manipulation has been completed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/prefetch.c b/repair/prefetch.c
index 65fedf5..2a8008f 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -444,28 +444,7 @@ pf_read_inode_dirs(
 }
 
 /*
- * Discontiguous buffers require multiple IOs to fill, so we can't use any
- * linearising, hole filling algorithms on them to avoid seeks. Just remove them
- * for the prefetch queue and read them straight into the cache and release
- * them.
- */
-static void
-pf_read_discontig(
-	struct prefetch_args	*args,
-	struct xfs_buf		*bp)
-{
-	if (!btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp, bp->b_bn)))
-		do_error(_("prefetch corruption\n"));
-
-	pthread_mutex_unlock(&args->lock);
-	libxfs_readbufr_map(mp->m_ddev_targp, bp, 0);
-	bp->b_flags |= LIBXFS_B_UNCHECKED;
-	libxfs_putbuf(bp);
-	pthread_mutex_lock(&args->lock);
-}
-
-/*
- * pf_batch_read must be called with the lock locked.
+ * pf_batch_read must be called with the args->lock mutex locked.
  */
 static void
 pf_batch_read(
@@ -474,7 +453,8 @@ pf_batch_read(
 	void			*buf)
 {
 	xfs_buf_t		*bplist[MAX_BUFS];
-	unsigned int		num;
+	xfs_buf_t		*bplist_disc[MAX_BUFS];
+	unsigned int		num, num_disc;
 	off64_t			first_off, last_off, next_off;
 	int			len, size;
 	int			i;
@@ -484,7 +464,7 @@ pf_batch_read(
 	char			*pbuf;
 
 	for (;;) {
-		num = 0;
+		num = num_disc = 0;
 		if (which == PF_SECONDARY) {
 			bplist[0] = btree_find(args->io_queue, 0, &fsbno);
 			max_fsbno = MIN(fsbno + pf_max_fsbs,
@@ -494,18 +474,22 @@ pf_batch_read(
 						args->last_bno_read, &fsbno);
 			max_fsbno = fsbno + pf_max_fsbs;
 		}
+
 		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
 			/*
-			 * Handle discontiguous buffers outside the seek
-			 * optimised IO loop below.
+ 			 * Discontiguous buffers require multiple IOs to fill,
+ 			 * so we can't use any linearising, hole filling
+ 			 * algorithms on them to avoid seeks. Just move them
+ 			 * to their own list and read them individually later.
 			 */
 			if ((bplist[num]->b_flags & LIBXFS_B_DISCONTIG)) {
-				pf_read_discontig(args, bplist[num]);
-				bplist[num] = NULL;
+				bplist_disc[num_disc] = bplist[num];
+				num_disc++;
 			} else if (which != PF_META_ONLY ||
 				   !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
 				num++;
-			if (num == MAX_BUFS)
+
+			if (num == MAX_BUFS || num_disc == MAX_BUFS)
 				break;
 			bplist[num] = btree_lookup_next(args->io_queue, &fsbno);
 		}
@@ -541,12 +525,19 @@ pf_batch_read(
 			num = i;
 		}
 
+		/* Take everything we found out of the tree */
 		for (i = 0; i < num; i++) {
 			if (btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp,
 					XFS_BUF_ADDR(bplist[i]))) == NULL)
 				do_error(_("prefetch corruption\n"));
 		}
 
+		for (i = 0; i < num_disc; i++) {
+			if (btree_delete(args->io_queue, XFS_DADDR_TO_FSB(mp,
+					XFS_BUF_ADDR(bplist_disc[i]))) == NULL)
+				do_error(_("prefetch corruption\n"));
+		}
+
 		if (which == PF_PRIMARY) {
 			for (inode_bufs = 0, i = 0; i < num; i++) {
 				if (B_IS_INODE(XFS_BUF_PRIORITY(bplist[i])))
@@ -566,6 +557,12 @@ pf_batch_read(
 #endif
 		pthread_mutex_unlock(&args->lock);
 
+		/* Read discontig buffers individually, if any */
+		for (i = 0; i < num_disc; i++) {
+			libxfs_readbufr_map(mp->m_ddev_targp, bplist_disc[i], 0);
+			bplist_disc[i]->b_flags |= LIBXFS_B_UNCHECKED;
+			libxfs_putbuf(bplist_disc[i]);
+		}
 		/*
 		 * now read the data and put into the xfs_but_t's
 		 */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
