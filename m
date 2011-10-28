Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3gib145431 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 546461CC6FBC
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tHQ97zzhxfKEvMQl for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHo-00035K-NJ
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:40 +0000
Message-Id: <20111028100340.674710590@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 28/45] xfs: kill xfs_qm_dqinit_core
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-kill-xfs_qm_dqinit_core
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

Merge into it's only caller, which also obsoletes the comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:05.872671537 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:06.408674693 +0200
@@ -155,24 +155,6 @@ xfs_qm_dqdestroy(
 }
 
 /*
- * This is what a 'fresh' dquot inside a dquot chunk looks like on disk.
- */
-STATIC void
-xfs_qm_dqinit_core(
-	xfs_dqid_t	id,
-	uint		type,
-	xfs_dqblk_t	*d)
-{
-	/*
-	 * Caller has zero'd the entire dquot 'chunk' already.
-	 */
-	d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
-	d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
-	d->dd_diskdq.d_id = cpu_to_be32(id);
-	d->dd_diskdq.d_flags = type;
-}
-
-/*
  * If default limits are in force, push them into the dquot now.
  * We overwrite the dquot limits only if they are zero and this
  * is not the root dquot.
@@ -328,8 +310,13 @@ xfs_qm_init_dquot_blk(
 	curid = id - (id % q->qi_dqperchunk);
 	ASSERT(curid >= 0);
 	memset(d, 0, BBTOB(q->qi_dqchunklen));
-	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++)
-		xfs_qm_dqinit_core(curid, type, d);
+	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++) {
+		d->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
+		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
+		d->dd_diskdq.d_id = cpu_to_be32(curid);
+		d->dd_diskdq.d_flags = type;
+	}
+
 	xfs_trans_dquot_buf(tp, bp,
 			    (type & XFS_DQ_USER ? XFS_BLF_UDQUOT_BUF :
 			    ((type & XFS_DQ_PROJ) ? XFS_BLF_PDQUOT_BUF :

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
