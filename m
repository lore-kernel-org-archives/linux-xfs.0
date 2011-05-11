Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7DlQ128053 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E5091EABF96
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id q5UCxsZGGC2Ie7PR for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0K-0005gV-M9
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:12 +0000
Message-Id: <20110511150712.651478046@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/9] xfs: do not do pointer arithmetics on extent records
References: <20110511150402.258164661@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ep-access-3
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

We need to call xfs_iext_get_ext for the previous extent to get a valid
pointer, and can't just do pointer arithmetics as they might be in
different pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-05-11 10:16:58.847733078 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-05-11 10:17:04.803235692 +0200
@@ -5145,9 +5145,12 @@ xfs_bunmapi(
 				 */
 				ASSERT(bno >= del.br_blockcount);
 				bno -= del.br_blockcount;
-				if (bno < got.br_startoff) {
-					if (--lastx >= 0)
-						xfs_bmbt_get_all(--ep, &got);
+				if (got.br_startoff > bno) {
+					if (--lastx >= 0) {
+						ep = xfs_iext_get_ext(ifp,
+								      lastx);
+						xfs_bmbt_get_all(ep, &got);
+					}
 				}
 				continue;
 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
