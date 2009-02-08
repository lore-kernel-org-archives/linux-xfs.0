Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n18LFrJt195151 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 15:15:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0EBDFB6C1
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 13:15:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oiHBvhlE7vGgPGkL for
	<xfs@oss.sgi.com>; Sun, 08 Feb 2009 13:15:16 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LWGzj-0003wZ-UB
	for xfs@oss.sgi.com; Sun, 08 Feb 2009 21:15:15 +0000
Date: Sun, 8 Feb 2009 16:15:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfs_db: fix wrong sibling pointers offset for the bmbt attr block
Message-ID: <20090208211515.GB22118@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The attr bmbt should use long, not short pointers.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/btblock.c
===================================================================
--- xfsprogs-dev.orig/db/btblock.c	2009-02-08 22:13:05.225944103 +0100
+++ xfsprogs-dev/db/btblock.c	2009-02-08 22:13:14.143944165 +0100
@@ -227,8 +227,8 @@ const field_t	bmapbtd_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
 	{ "level", FLDT_UINT16D, OI(OFF(level)), C1, 0, TYP_NONE },
 	{ "numrecs", FLDT_UINT16D, OI(OFF(numrecs)), C1, 0, TYP_NONE },
-	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.s.bb_leftsib)), C1, 0, TYP_BMAPBTD },
-	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.s.bb_rightsib)), C1, 0, TYP_BMAPBTD },
+	{ "leftsib", FLDT_DFSBNO, OI(OFF(u.l.bb_leftsib)), C1, 0, TYP_BMAPBTD },
+	{ "rightsib", FLDT_DFSBNO, OI(OFF(u.l.bb_rightsib)), C1, 0, TYP_BMAPBTD },
 	{ "recs", FLDT_BMAPBTDREC, btblock_rec_offset, btblock_rec_count,
 	  FLD_ARRAY|FLD_ABASE1|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "keys", FLDT_BMAPBTDKEY, btblock_key_offset, btblock_key_count,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
