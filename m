Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1FA7m1143650 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 09:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03DA81DA0978
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 07:10:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SvA9OnSobVXhbTGl for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 07:10:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NFUNB-0005iO-Kr
	for xfs@oss.sgi.com; Tue, 01 Dec 2009 15:10:37 +0000
Message-Id: <20091201151037.542119951@bombadil.infradead.org>
Date: Tue, 01 Dec 2009 10:05:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] repair: add more fresspace btree checks
References: <20091201150503.958283878@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-freespace-warn
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

Port over additional checks for the freespace btrees from xfs_db, to get
the same btree checking coverage as in xfs_check.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-12-01 13:07:55.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-12-01 13:09:03.000000000 +0000
@@ -462,6 +462,8 @@ scanfunc_allocbt(
 	int			hdr_errors = 0;
 	int			numrecs;
 	int			state;
+	xfs_extlen_t		lastcount = 0;
+	xfs_agblock_t		lastblock = 0;
 
 	assert(magic == XFS_ABTB_MAGIC || magic == XFS_ABTC_MAGIC);
 
@@ -508,8 +510,14 @@ _("%s freespace btree block claimed (sta
 			hdr_errors++;
 		}
 
-		if (hdr_errors)
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_alloc_mnr[0], mp->m_alloc_mxr[0],
+				name, agno, bno);
 			suspect++;
+		}
 
 		rp = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		for (i = 0; i < numrecs; i++) {
@@ -533,6 +541,24 @@ _("%s freespace btree block claimed (sta
 				continue;
 			}
 
+			if (magic == XFS_ABTB_MAGIC) {
+				if (b <= lastblock) {
+					do_warn(_(
+	"out-of-order bno btree record %d (%u %u) block %u/%u\n"),
+						i, b, len, agno, bno);
+				} else {
+					lastblock = b;
+				}
+			} else {
+				if (len < lastcount) {
+					do_warn(_(
+	"out-of-order cnt btree record %d (%u %u) block %u/%u\n"),
+						i, b, len, agno, bno);
+				} else {
+					lastcount = len;
+				}
+			}
+
 			for ( ; b < end; b += blen)  {
 				state = get_bmap_ext(agno, b, end, &blen);
 				switch (state) {
@@ -579,14 +605,17 @@ _("%s freespace btree block claimed (sta
 	 * don't pass bogus tree flag down further if this block
 	 * looked ok.  bail out if two levels in a row look bad.
 	 */
-
-	if (suspect && !hdr_errors)
-		suspect = 0;
-
 	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in bt%s block %u/%u\n"),
+			be16_to_cpu(block->bb_numrecs),
+			mp->m_alloc_mnr[1], mp->m_alloc_mxr[1],
+			name, agno, bno);
 		if (suspect)
 			return;
-		else suspect++;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
 	}
 
 	for (i = 0; i < numrecs; i++)  {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
