Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81Nu2A5217223 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 18:56:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A36415A5E95
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 16:56:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GPasp8SC58vVDZAv for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 16:56:59 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MidDb-00044x-Ju
	for xfs@oss.sgi.com; Tue, 01 Sep 2009 23:56:55 +0000
Date: Tue, 1 Sep 2009 19:56:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: un-static xfs_inobt_lookup
Message-ID: <20090901235655.GA15321@infradead.org>
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


xfs_inobt_lookup is also used in xfs_itable.c, remove the STATIC modifier
from it's declaration to fix non-debug builds.

This was already fixed in my git tree vs the version last posted to the
list.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:28.515468366 -0300
+++ xfs/fs/xfs/xfs_ialloc.c	2009-09-01 20:47:33.867913011 -0300
@@ -59,7 +59,7 @@ xfs_ialloc_cluster_alignment(
 /*
  * Lookup a record by ino in the btree given by cur.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_inobt_lookup(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agino_t		ino,	/* starting inode of chunk */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
