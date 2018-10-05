Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48098 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbeJELAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:14 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 14/15] xfsprogs: eliminate shadow variables
Date: Thu,  4 Oct 2018 23:03:15 -0500
Message-Id: <1538712196-13625-15-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

None of these seem activel harmful, but to avoid confusion, remove all
shadow variables by just renaming them in their local scope.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 db/check.c          | 15 +++++++--------
 db/metadump.c       |  2 +-
 io/mmap.c           |  8 ++++----
 logprint/log_misc.c | 43 ++++++++++++++++++++++---------------------
 repair/scan.c       | 22 +++++++++++-----------
 scrub/xfs_scrub.c   |  9 +++++----
 6 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/db/check.c b/db/check.c
index 754441c..04c3212 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2050,7 +2050,7 @@ process_block_dir_v2(
 	int		nex;
 	xfs_ino_t	parent;
 	int		v;
-	int		x;
+	int		i;
 
 	nex = blkmap_getn(blkmap, 0, mp->m_dir_geo->fsbcount, &bmp);
 	v = id->ilist || verbose;
@@ -2067,9 +2067,9 @@ process_block_dir_v2(
 		make_bbmap(&bbmap, nex, bmp);
 	set_cur(&typtab[TYP_DIR2], XFS_FSB_TO_DADDR(mp, bmp->startblock),
 		mp->m_dir_geo->fsbcount * blkbb, DB_RING_IGN, nex > 1 ? &bbmap : NULL);
-	for (x = 0; !v && x < nex; x++) {
-		for (b = bmp[x].startblock;
-		     !v && b < bmp[x].startblock + bmp[x].blockcount;
+	for (i = 0; !v && i < nex; i++) {
+		for (b = bmp[i].startblock;
+		     !v && b < bmp[i].startblock + bmp[i].blockcount;
 		     b++)
 			v = CHECK_BLIST(b);
 	}
@@ -2998,7 +2998,6 @@ process_leaf_node_dir_v2(
 	int			t = 0;
 	int			v;
 	int			v2;
-	int			x;
 
 	v2 = verbose || id->ilist;
 	v = parent = 0;
@@ -3012,9 +3011,9 @@ process_leaf_node_dir_v2(
 	while ((dbno = blkmap_next_off(blkmap, dbno, &t)) != NULLFILEOFF) {
 		nex = blkmap_getn(blkmap, dbno, mp->m_dir_geo->fsbcount, &bmp);
 		ASSERT(nex > 0);
-		for (v = v2, x = 0; !v && x < nex; x++) {
-			for (b = bmp[x].startblock;
-			     !v && b < bmp[x].startblock + bmp[x].blockcount;
+		for (v = v2, i = 0; !v && i < nex; i++) {
+			for (b = bmp[i].startblock;
+			     !v && b < bmp[i].startblock + bmp[i].blockcount;
 			     b++)
 				v = CHECK_BLIST(b);
 		}
diff --git a/db/metadump.c b/db/metadump.c
index cc2ae9a..8f85f4c 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1515,7 +1515,7 @@ process_dir_data_block(
 		dup = (xfs_dir2_data_unused_t *)ptr;
 
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			int	length = be16_to_cpu(dup->length);
+			length = be16_to_cpu(dup->length);
 			if (dir_offset + length > end_of_data ||
 			    !length || (length & (XFS_DIR2_DATA_ALIGN - 1))) {
 				if (show_warnings)
diff --git a/io/mmap.c b/io/mmap.c
index 44749bb..1130b9b 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -30,7 +30,7 @@ print_mapping(
 	int		index,
 	int		braces)
 {
-	char		buffer[8] = { 0 };
+	char		buf[8] = { 0 };
 	int		i;
 
 	static struct {
@@ -44,16 +44,16 @@ print_mapping(
 	};
 
 	for (i = 0, p = pflags; p->prot != PROT_NONE; i++, p++)
-		buffer[i] = (map->prot & p->prot) ? p->mode : '-';
+		buf[i] = (map->prot & p->prot) ? p->mode : '-';
 
 	if (map->map_sync)
-		sprintf(&buffer[i], " S");
+		sprintf(&buf[i], " S");
 
 	printf("%c%03d%c 0x%lx - 0x%lx %s  %14s (%lld : %ld)\n",
 		braces? '[' : ' ', index, braces? ']' : ' ',
 		(unsigned long)map->addr,
 		(unsigned long)((char *)map->addr + map->length),
-		buffer, map->name ? map->name : "???",
+		buf, map->name ? map->name : "???",
 		(long long)map->offset, (long)map->length);
 }
 
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e29366a..0c51d20 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -192,7 +192,6 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
     int64_t			 blkno;
     xfs_buf_log_format_t lbuf;
     int			 size, blen, map_size, struct_size;
-    __be64		 x, y;
     unsigned short	 flags;
 
     /*
@@ -247,20 +246,22 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		if (be32_to_cpu(head->oh_len) < 4*8) {
 			printf(_("Out of space\n"));
 		} else {
+			__be64		 a, b;
+
 			printf("\n");
 			/*
 			 * memmove because *ptr may not be 8-byte aligned
 			 */
-			memmove(&x, *ptr, sizeof(__be64));
-			memmove(&y, *ptr+8, sizeof(__be64));
-		       printf(_("icount: %llu  ifree: %llu  "),
-			       (unsigned long long) be64_to_cpu(x),
-			       (unsigned long long) be64_to_cpu(y));
-			memmove(&x, *ptr+16, sizeof(__be64));
-			memmove(&y, *ptr+24, sizeof(__be64));
-		       printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) be64_to_cpu(x),
-			       (unsigned long long) be64_to_cpu(y));
+			memmove(&a, *ptr, sizeof(__be64));
+			memmove(&b, *ptr+8, sizeof(__be64));
+			printf(_("icount: %llu  ifree: %llu  "),
+			       (unsigned long long) be64_to_cpu(a),
+			       (unsigned long long) be64_to_cpu(b));
+			memmove(&a, *ptr+16, sizeof(__be64));
+			memmove(&b, *ptr+24, sizeof(__be64));
+			printf(_("fdblks: %llu  frext: %llu\n"),
+			       (unsigned long long) be64_to_cpu(a),
+			       (unsigned long long) be64_to_cpu(b));
 		}
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
@@ -394,15 +395,15 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 		if (print_data) {
 			uint *dp  = (uint *)*ptr;
 			int  nums = be32_to_cpu(head->oh_len) >> 2;
-			int  i = 0;
+			int  j = 0;
 
-			while (i < nums) {
-				if ((i % 8) == 0)
-					printf("%2x ", i);
+			while (j < nums) {
+				if ((j % 8) == 0)
+					printf("%2x ", j);
 				printf("%8x ", *dp);
 				dp++;
-				i++;
-				if ((i % 8) == 0)
+				j++;
+				if ((j % 8) == 0)
 					printf("\n");
 			}
 			printf("\n");
@@ -1185,7 +1186,7 @@ xlog_print_extended_headers(
 	int 			num_hdrs;
 	int 			num_required;
 	char			xhbuf[XLOG_HEADER_SIZE];
-	xlog_rec_ext_header_t	*x;
+	xlog_rec_ext_header_t	*xhdr;
 
 	num_required = howmany(len, XLOG_HEADER_CYCLE_SIZE);
 	num_hdrs = be32_to_cpu(hdr->h_size) / XLOG_HEADER_CYCLE_SIZE;
@@ -1210,7 +1211,7 @@ xlog_print_extended_headers(
 	*ret_num_hdrs = num_hdrs;
 
 	/* don't include 1st header */
-	for (i = 1, x = *ret_xhdrs; i < num_hdrs; i++, (*blkno)++, x++) {
+	for (i = 1, xhdr = *ret_xhdrs; i < num_hdrs; i++, (*blkno)++, xhdr++) {
 	    /* read one extra header blk */
 	    if (read(fd, xhbuf, 512) == 0) {
 		printf(_("%s: physical end of log\n"), progname);
@@ -1240,9 +1241,9 @@ xlog_print_extended_headers(
 	     * will look asymmetric with the 1 hdr normal case
 	     * which does endian coversion on access.
 	     */
-	    x->xh_cycle = ((xlog_rec_ext_header_t*)xhbuf)->xh_cycle;
+	    xhdr->xh_cycle = ((xlog_rec_ext_header_t*)xhbuf)->xh_cycle;
 	    for (j = 0; j < XLOG_HEADER_CYCLE_SIZE / BBSIZE; j++) {
-		x->xh_cycle_data[j] =
+		xhdr->xh_cycle_data[j] =
 		    ((xlog_rec_ext_header_t*)xhbuf)->xh_cycle_data[j];
 	    }
 	}
diff --git a/repair/scan.c b/repair/scan.c
index 65a76e2..12ca314 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -738,7 +738,7 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
 		/*
 		 * XXX - put sibling detection right here.
@@ -749,17 +749,17 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 		 * pointer mismatch, try and extract as much data
 		 * as possible.
 		 */
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
 			switch (magic) {
 			case XFS_ABTB_CRC_MAGIC:
 			case XFS_ABTB_MAGIC:
-				scan_sbtree(bno, level, agno, suspect,
+				scan_sbtree(agbno, level, agno, suspect,
 					    scan_allocbt, 0, magic, priv,
 					    &xfs_allocbt_buf_ops);
 				break;
 			case XFS_ABTC_CRC_MAGIC:
 			case XFS_ABTC_MAGIC:
-				scan_sbtree(bno, level, agno, suspect,
+				scan_sbtree(agbno, level, agno, suspect,
 					    scan_allocbt, 0, magic, priv,
 					    &xfs_allocbt_buf_ops);
 				break;
@@ -1177,7 +1177,7 @@ advance:
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
 		/*
 		 * XXX - put sibling detection right here.
@@ -1199,12 +1199,12 @@ advance:
 			/* Look for impossible flags. */
 			do_warn(
 	_("invalid flags in high key %u of %s btree block %u/%u\n"),
-				i, name, agno, bno);
+				i, name, agno, agbno);
 			continue;
 		}
 
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno, level, agno, suspect, scan_rmapbt, 0,
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
+			scan_sbtree(agbno, level, agno, suspect, scan_rmapbt, 0,
 				    magic, priv, &xfs_rmapbt_buf_ops);
 		}
 	}
@@ -1419,10 +1419,10 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	}
 
 	for (i = 0; i < numrecs; i++)  {
-		xfs_agblock_t		bno = be32_to_cpu(pp[i]);
+		xfs_agblock_t		agbno = be32_to_cpu(pp[i]);
 
-		if (bno != 0 && verify_agbno(mp, agno, bno)) {
-			scan_sbtree(bno, level, agno, suspect, scan_refcbt, 0,
+		if (agbno != 0 && verify_agbno(mp, agno, agbno)) {
+			scan_sbtree(agbno, level, agno, suspect, scan_refcbt, 0,
 				    magic, priv, &xfs_refcountbt_buf_ops);
 		}
 	}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index c611f1f..0f9f765 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -423,7 +423,6 @@ run_scrub_phases(
 	bool			moveon = true;
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
-	unsigned int		nr_threads;
 	int			rshift;
 
 	if (debug && debug_tweak_on("XFS_SCRUB_PHASE"))
@@ -455,12 +454,14 @@ run_scrub_phases(
 		if (!moveon)
 			break;
 		if (sp->estimate_work) {
-			moveon = sp->estimate_work(ctx, &max_work, &nr_threads,
-					&rshift);
+			unsigned int		work_threads;
+
+			moveon = sp->estimate_work(ctx, &max_work,
+					&work_threads, &rshift);
 			if (!moveon)
 				break;
 			moveon = progress_init_phase(ctx, progress_fp, phase,
-					max_work, rshift, nr_threads);
+					max_work, rshift, work_threads);
 		} else {
 			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
 		}
-- 
1.8.3.1
