Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64EuIFs221640 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 09:56:18 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TriVtk8RRfgcSQF7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 07:56:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SmR03-0002kj-W7
	for xfs@oss.sgi.com; Wed, 04 Jul 2012 14:56:16 +0000
Message-Id: <20120704145615.870767549@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 10:54:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/7] xfs: add a short cut to xfs_dialloc for the non-NULL agbp
	case
References: <20120704145444.863203951@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dialloc-shortcut-second-call
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

In this case we already have selected an AG and know it has free space
beause the buffer lock never got released.  Jump directly into xfs_dialloc_ag
and short cut the AG selection loop.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_ialloc.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2012-07-02 12:23:49.299108893 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2012-07-02 12:24:18.305775386 +0200
@@ -634,6 +634,10 @@ xfs_dialloc_ag(
 
 	pag = xfs_perag_get(mp, agno);
 
+	ASSERT(pag->pagi_init);
+	ASSERT(pag->pagi_inodeok);
+	ASSERT(pag->pagi_freecount > 0);
+
  restart_pagno:
 	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno);
 	/*
@@ -907,32 +911,32 @@ xfs_dialloc(
 	xfs_agnumber_t		tagno;
 	struct xfs_perag	*pag;
 
-	if (*IO_agbp == NULL) {
-		/*
-		 * We do not have an agbp, so select an initial allocation
-		 * group for inode allocation.
-		 */
-		agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
-		/*
-		 * Couldn't find an allocation group satisfying the
-		 * criteria, give up.
-		 */
-		if (!agbp) {
-			*inop = NULLFSINO;
-			return 0;
-		}
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-	} else {
+	if (*IO_agbp) {
 		/*
-		 * Continue where we left off before.  In this case, we
+		 * If the caller passes in a pointer to the AGI buffer,
+		 * continue where we left off before.  In this case, we
 		 * know that the allocation group has free inodes.
 		 */
 		agbp = *IO_agbp;
-		agi = XFS_BUF_TO_AGI(agbp);
-		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
-		ASSERT(be32_to_cpu(agi->agi_freecount) > 0);
+		goto out_alloc;
 	}
+
+	/*
+	 * We do not have an agbp, so select an initial allocation
+	 * group for inode allocation.
+	 */
+	agbp = xfs_ialloc_ag_select(tp, parent, mode, okalloc);
+
+	/*
+	 * Couldn't find an allocation group satisfying the
+	 * criteria, give up.
+	 */
+	if (!agbp) {
+		*inop = NULLFSINO;
+		return 0;
+	}
+	agi = XFS_BUF_TO_AGI(agbp);
+
 	mp = tp->t_mountp;
 	agno = be32_to_cpu(agi->agi_seqno);
 	tagno = agno;
@@ -1012,6 +1016,7 @@ nextag:
 		ASSERT(agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC));
 	}
 
+out_alloc:
 	*IO_agbp = NULL;
 	return xfs_dialloc_ag(tp, agbp, parent, inop);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
