Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAU9OOLA004489 for <xfs@oss.sgi.com>; Sun, 30 Nov 2008 03:24:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9ECDD16290CB
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2008 01:24:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Kktdhwev4gCGAyqW for
	<xfs@oss.sgi.com>; Sun, 30 Nov 2008 01:24:23 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L6iXO-0004kd-KQ
	for xfs@oss.sgi.com; Sun, 30 Nov 2008 09:24:22 +0000
Date: Sun, 30 Nov 2008 04:24:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: kill unused files db/dbread.[ch]
Message-ID: <20081130092422.GA12324@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfsprogs/db/Makefile
===================================================================
--- xfs-cmds.orig/xfsprogs/db/Makefile	2008-11-28 14:12:02.000000000 +0530
+++ xfs-cmds/xfsprogs/db/Makefile	2008-11-28 14:12:06.000000000 +0530
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_db
 
 HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
-	btblock.h bmroot.h check.h command.h convert.h dbread.h debug.h \
+	btblock.h bmroot.h check.h command.h convert.h debug.h \
 	dir.h dir2.h dir2sf.h dirshort.h dquot.h echo.h faddr.h field.h \
 	flist.h fprint.h frag.h freesp.h hash.h help.h init.h inode.h input.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
Index: xfs-cmds/xfsprogs/db/dbread.c
===================================================================
--- xfs-cmds.orig/xfsprogs/db/dbread.c	2008-11-28 14:12:31.000000000 +0530
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,69 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <xfs/libxfs.h>
-#include "bmap.h"
-#include "dbread.h"
-#include "io.h"
-#include "init.h"
-
-int
-dbread(void *buf, int nblocks, xfs_fileoff_t bno, int whichfork)
-{
-	bmap_ext_t	bm;
-	char		*bp;
-	xfs_dfiloff_t	eb;
-	xfs_dfiloff_t	end;
-	int		i;
-	int		nex;
-
-	nex = 1;
-	end = bno + nblocks;
-	bp = buf;
-	while (bno < end) {
-		bmap(bno, end - bno, whichfork, &nex, &bm);
-		if (nex == 0) {
-			bm.startoff = end;
-			bm.blockcount = 1;
-		}
-		if (bm.startoff > bno) {
-			eb = end < bm.startoff ? end : bm.startoff;
-			i = (int)XFS_FSB_TO_B(mp, eb - bno);
-			memset(bp, 0, i);
-			bp += i;
-			bno = eb;
-		}
-		if (bno == end)
-			break;
-		if (bno > bm.startoff) {
-			bm.blockcount -= bno - bm.startoff;
-			bm.startblock += bno - bm.startoff;
-			bm.startoff = bno;
-		}
-		if (bm.startoff + bm.blockcount > end)
-			bm.blockcount = end - bm.startoff;
-		i = read_bbs(XFS_FSB_TO_DADDR(mp, bm.startblock),
-			     (int)XFS_FSB_TO_BB(mp, bm.blockcount),
-			     (void **)&bp, NULL);
-		if (i)
-			return i;
-		bp += XFS_FSB_TO_B(mp, bm.blockcount);
-		bno += bm.blockcount;
-	}
-	return 0;
-}
Index: xfs-cmds/xfsprogs/db/dbread.h
===================================================================
--- xfs-cmds.orig/xfsprogs/db/dbread.h	2008-11-28 14:12:36.000000000 +0530
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,20 +0,0 @@
-/*
- * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-extern int	dbread(void *buf, int nblocks, xfs_fileoff_t bno,
-		       int whichfork);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
