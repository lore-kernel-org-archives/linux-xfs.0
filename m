Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB16X4et027360 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 00:33:05 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id 0D7A38F8173
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2008 22:32:59 -0800 (PST)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com
	[134.14.55.58]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA02969 for
	<xfs@oss.sgi.com>; Mon, 1 Dec 2008 17:32:57 +1100
Date: Mon, 01 Dec 2008 17:34:39 +1100
Subject: [REVIEW] Fix unaligned accesses in IA64 in xfsprogs
From: "Barry Naujok" <bnaujok@sgi.com>
MIME-Version: 1.0
Message-ID: <op.ulg0j1bf3jf8g2@pc-bnaujok.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

xfs_repair is the main culprit when getting disk extents which aren't
properly aligned in memory. This patch does not call
xfs_bmbt_disk_get_all directly anymore but does an unaligned get on
the disk extent record and calls xfs_bmbt_get_all which is host-based
like the rest of the kernel routines do.

===========================================================================
xfsprogs/db/bmap.c
===========================================================================

--- a/xfsprogs/db/bmap.c	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/db/bmap.c	2008-12-01 17:03:17.956547706 +1100
@@ -277,21 +277,17 @@ convert_extent(
  	xfs_dfilblks_t		*cp,
  	int			*fp)
  {
-	xfs_bmbt_irec_t irec, *s = &irec;
-	xfs_bmbt_rec_t rpcopy, *p = &rpcopy;
+	xfs_bmbt_irec_t		irec;
+	xfs_bmbt_rec_host_t	rec;

-	memmove(&rpcopy, rp, sizeof(rpcopy));
-	libxfs_bmbt_disk_get_all(p, s);
-
-	if (s->br_state == XFS_EXT_UNWRITTEN) {
-		*fp = 1;
-	} else {
-		*fp = 0;
-	}
-
-	*op = s->br_startoff;
-	*sp = s->br_startblock;
-	*cp = s->br_blockcount;
+	rec.l0 = get_unaligned_be64(&rp->l0);
+	rec.l1 = get_unaligned_be64(&rp->l1);
+	libxfs_bmbt_get_all(&rec, &irec);
+
+	*fp = irec.br_state == XFS_EXT_UNWRITTEN;
+	*op = irec.br_startoff;
+	*sp = irec.br_startblock;
+	*cp = irec.br_blockcount;
  }

  void

===========================================================================
xfsprogs/include/libxfs.h
===========================================================================

--- a/xfsprogs/include/libxfs.h	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/include/libxfs.h	2008-12-01 16:45:05.941577400 +1100
@@ -502,7 +502,7 @@ xfs_bmbt_rec_host_t *xfs_bmap_search_ext
  #define libxfs_bunmapi			xfs_bunmapi

  /* xfs_bmap_btree.h */
-#define libxfs_bmbt_disk_get_all	xfs_bmbt_disk_get_all
+#define libxfs_bmbt_get_all		xfs_bmbt_get_all

  /* xfs_da_btree.h */
  #define libxfs_da_brelse		xfs_da_brelse

===========================================================================
xfsprogs/include/xfs_arch.h
===========================================================================

--- a/xfsprogs/include/xfs_arch.h	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/include/xfs_arch.h	2008-12-01 17:06:38.819726283 +1100
@@ -71,6 +71,13 @@ static inline void be64_add_cpu(__be64 *
  	*a = cpu_to_be64(be64_to_cpu(*a) + b);
  }

+static inline __u64 get_unaligned_be64(void *ptr)
+{
+	__be64	__tmp;
+	memmove(&__tmp, ptr, 8);
+	return be64_to_cpu(__tmp);
+}
+
  #endif	/* __KERNEL__ */

  /* do we need conversion? */

===========================================================================
xfsprogs/libxfs/xfs.h
===========================================================================

--- a/xfsprogs/libxfs/xfs.h	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/libxfs/xfs.h	2008-12-01 17:05:22.041221304 +1100
@@ -127,14 +127,6 @@ static inline int __do_div(unsigned long
  #define max_t(type,x,y) \
  	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })

-/* only 64 bit accesses used in xfs kernel code */
-static inline __u64 get_unaligned_be64(void *ptr)
-{
-	__be64	__tmp;
-	memmove(&__tmp, ptr, 8);
-	return be64_to_cpu(__tmp);
-}
-
  static inline void put_unaligned(__be64 val, void *ptr)
  {
  	memmove(ptr, &val, 8);

===========================================================================
xfsprogs/repair/dino_chunks.c
===========================================================================

--- a/xfsprogs/repair/dino_chunks.c	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/repair/dino_chunks.c	2008-12-01 16:11:11.549834281 +1100
@@ -609,7 +609,8 @@ process_inode_chunk(
  	if (blks_per_cluster == 0)
  		blks_per_cluster = 1;
  	cluster_count = XFS_INODES_PER_CHUNK / inodes_per_cluster;
-	ASSERT(cluster_count > 0);
+	if (cluster_count == 0)
+		cluster_count = 1;

  	/*
  	 * get all blocks required to read in this chunk (may wind up

===========================================================================
xfsprogs/repair/dinode.c
===========================================================================

--- a/xfsprogs/repair/dinode.c	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/repair/dinode.c	2008-12-01 17:03:40.217799833 +1100
@@ -460,10 +460,13 @@ get_bmbt_reclist(
  	xfs_dfiloff_t		fblock)
  {
  	int			i;
+	xfs_bmbt_rec_host_t	rec;
  	xfs_bmbt_irec_t 	irec;

-	for (i = 0; i < numrecs; i++) {
-		libxfs_bmbt_disk_get_all(rp + i, &irec);
+	for (i = 0; i < numrecs; i++, rp++) {
+		rec.l0 = get_unaligned_be64(&rp->l0);
+		rec.l1 = get_unaligned_be64(&rp->l1);
+		xfs_bmbt_get_all(&rec, &irec);
  		if (irec.br_startoff >= fblock &&
  				irec.br_startoff + irec.br_blockcount < fblock)
  			return (irec.br_startblock + fblock - irec.br_startoff);
@@ -612,6 +615,7 @@ process_bmbt_reclist_int(
  	int			whichfork)
  {
  	xfs_bmbt_irec_t		irec;
+	xfs_bmbt_rec_host_t	rec;
  	xfs_dfilblks_t		cp = 0;		/* prev count */
  	xfs_dfsbno_t		sp = 0;		/* prev start */
  	xfs_dfiloff_t		op = 0;		/* prev offset */
@@ -636,8 +640,10 @@ process_bmbt_reclist_int(
  	else
  		ftype = _("regular");

-	for (i = 0; i < numrecs; i++) {
-		libxfs_bmbt_disk_get_all(rp + i, &irec);
+	for (i = 0; i < numrecs; i++, rp++) {
+		rec.l0 = get_unaligned_be64(&rp->l0);
+		rec.l1 = get_unaligned_be64(&rp->l1);
+		libxfs_bmbt_get_all(&rec, &irec);
  		if (i == 0)
  			*last_key = *first_key = irec.br_startoff;
  		else
@@ -913,14 +919,17 @@ getfunc_extlist(xfs_mount_t		*mp,
  		int			whichfork)
  {
  	xfs_bmbt_irec_t		irec;
+	xfs_bmbt_rec_host_t	rec;
  	xfs_dfsbno_t		final_fsbno = NULLDFSBNO;
-	xfs_bmbt_rec_t		*rootblock = (xfs_bmbt_rec_t *)
+	xfs_bmbt_rec_t		*rp = (xfs_bmbt_rec_t *)
  						XFS_DFORK_PTR(dip, whichfork);
  	xfs_extnum_t		nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
  	int			i;

-	for (i = 0; i < nextents; i++)  {
-		libxfs_bmbt_disk_get_all(rootblock + i, &irec);
+	for (i = 0; i < nextents; i++, rp++)  {
+		rec.l0 = get_unaligned_be64(&rp->l0);
+		rec.l1 = get_unaligned_be64(&rp->l1);
+		libxfs_bmbt_get_all(&rec, &irec);
  		if (irec.br_startoff <= bno &&
  				bno < irec.br_startoff + irec.br_blockcount) {
  			final_fsbno = bno - irec.br_startoff + irec.br_startblock;
@@ -948,6 +957,7 @@ getfunc_btree(xfs_mount_t		*mp,
  	int			found;
  	int			numrecs;
  	xfs_bmbt_rec_t		*rec;
+	xfs_bmbt_rec_host_t	hrec;
  	xfs_bmbt_irec_t		irec;
  	xfs_bmbt_ptr_t		*pp;
  	xfs_bmbt_key_t		*key;
@@ -1072,8 +1082,10 @@ getfunc_btree(xfs_mount_t		*mp,
  			ino, numrecs, mp->m_bmap_dmnr[0]);

  	rec = XFS_BMBT_REC_ADDR(mp, block, 1);
-	for (i = 0; i < numrecs; i++)  {
-		libxfs_bmbt_disk_get_all(rec + i, &irec);
+	for (i = 0; i < numrecs; i++, rec++) {
+		hrec.l0 = get_unaligned_be64(&rec->l0);
+		hrec.l1 = get_unaligned_be64(&rec->l1);
+		libxfs_bmbt_get_all(&hrec, &irec);
  		if (irec.br_startoff <= bno &&
  				bno < irec.br_startoff + irec.br_blockcount) {
  			final_fsbno = bno - irec.br_startoff +
@@ -1387,6 +1399,7 @@ process_symlink_extlist(xfs_mount_t *mp,
  {
  	xfs_dfiloff_t		expected_offset;
  	xfs_bmbt_rec_t		*rp;
+	xfs_bmbt_rec_host_t	rec;
  	xfs_bmbt_irec_t		irec;
  	int			numrecs;
  	int			i;
@@ -1424,8 +1437,10 @@ process_symlink_extlist(xfs_mount_t *mp,
  	max_blocks = max_symlink_blocks;
  	expected_offset = 0;

-	for (i = 0; i < numrecs; i++)  {
-		libxfs_bmbt_disk_get_all(rp + i, &irec);
+	for (i = 0; i < numrecs; i++, rp++)  {
+		rec.l0 = get_unaligned_be64(&rp->l0);
+		rec.l1 = get_unaligned_be64(&rp->l1);
+		libxfs_bmbt_get_all(&rec, &irec);

  		if (irec.br_startoff != expected_offset)  {
  			do_warn(

===========================================================================
xfsprogs/repair/prefetch.c
===========================================================================

--- a/xfsprogs/repair/prefetch.c	2008-12-01 17:10:37.000000000 +1100
+++ b/xfsprogs/repair/prefetch.c	2008-12-01 17:03:46.972965840 +1100
@@ -170,12 +170,15 @@ pf_read_bmbt_reclist(
  	int			numrecs)
  {
  	int			i;
+	xfs_bmbt_rec_host_t	rec;
  	xfs_bmbt_irec_t		irec;
  	xfs_dfilblks_t		cp = 0;		/* prev count */
  	xfs_dfiloff_t		op = 0;		/* prev offset */

-	for (i = 0; i < numrecs; i++) {
-		libxfs_bmbt_disk_get_all(rp + i, &irec);
+	for (i = 0; i < numrecs; i++, rp++) {
+		rec.l0 = get_unaligned_be64(&rp->l0);
+		rec.l1 = get_unaligned_be64(&rp->l1);
+		libxfs_bmbt_get_all(&rec, &irec);

  		if (((i > 0) && (op + cp > irec.br_startoff)) ||
  				(irec.br_blockcount == 0) ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
