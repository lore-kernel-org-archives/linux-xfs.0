Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56216 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727761AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/18] xfsprogs: don't shadow global libxfs_init x variable
Date: Wed, 10 Oct 2018 15:01:16 -0500
Message-Id: <1539201682-22198-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

We use the variable 'x' for the global libxfs_init structure, but several
other functions think 'x' is a nice convenient local var too, and sparse
complains.  Rename these local variables (or in some cases re-use existing
loop counter vars when x was used for this purpose).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 db/check.c          | 15 +++++++--------
 logprint/log_misc.c | 31 ++++++++++++++++---------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/db/check.c b/db/check.c
index 683e176..352aab3 100644
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
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index e29366a..99d9920 100644
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
-- 
1.8.3.1
