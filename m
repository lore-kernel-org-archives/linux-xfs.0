Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB1FA8ks143658 for <xfs@oss.sgi.com>; Tue, 1 Dec 2009 09:10:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D14DF14EC4BF
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2009 07:10:37 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lu8M4Tv6rZl2Zkri for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2009 07:10:37 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NFUNB-0005hr-Fj
	for xfs@oss.sgi.com; Tue, 01 Dec 2009 15:10:37 +0000
Message-Id: <20091201151037.381644480@bombadil.infradead.org>
Date: Tue, 01 Dec 2009 10:05:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] repair: fix freespace btree record validation
References: <20091201150503.958283878@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-extlen
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

MAXEXTLEN is a limit for the bmap btree extent length, not for the freespace
btrees which can fill out the whole u32.  Remove the check which makes
repair skip too large freespace extents.  Also add warnings for freespace
btree records that fail the remaining validations.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-12-01 13:02:49.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-12-01 14:45:14.000000000 +0000
@@ -520,12 +520,18 @@ _("%s freespace btree block claimed (sta
 			len = be32_to_cpu(rp[i].ar_blockcount);
 			end = b + len;
 
-			if (b == 0 || !verify_agbno(mp, agno, b))
-				continue;
-			if (len == 0 || len > MAXEXTLEN)
+			if (b == 0 || !verify_agbno(mp, agno, b)) {
+				do_warn(
+	_("invalid start block %u in record %u of %d btree block %u/%u"),
+					b, i, name, agno, bno);
 				continue;
-			if (!verify_agbno(mp, agno, end - 1))
+			}
+			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
+				do_warn(
+	_("invalid length %u in record %u of %d btree block %u/%u"),
+					len, i, name, agno, bno);
 				continue;
+			}
 
 			for ( ; b < end; b += blen)  {
 				state = get_bmap_ext(agno, b, end, &blen);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
