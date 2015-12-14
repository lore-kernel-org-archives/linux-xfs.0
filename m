Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F6027CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 19:01:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80F4A8F8039
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 17:01:35 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IsT7hSGvy0t1VZOQ for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 17:01:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1a8HVt-0006ox-Nd
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1a8HVt-0000J4-Mq
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] metadump: bounds check btree block regions being zeroed
Date: Mon, 14 Dec 2015 12:01:05 +1100
Message-Id: <1450054866-32720-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1450054866-32720-1-git-send-email-david@fromorbit.com>
References: <1450054866-32720-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Arkadiusz Miskiewicz reported that metadump was crashing on one of
his corrupted filesystems, and the trace indicated that it was
zeroing unused regions in inode btree blocks when it failed. The
btree block had a corrupt nrecs field, which was resulting in an out
of bounds memset() occurring.

Ensure that the region being generated for zeroing is within bounds
before executing the zeroing. While there, abstract the repeated
boiler plate code so that it is simpler to maintain and extend the
zeroing code to new types of btrees in future.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/metadump.c | 93 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 37 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 8cdcb92..cc5d1c7 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -246,6 +246,11 @@ write_buf(
 	return seenint() ? -EINTR : 0;
 }
 
+/*
+ * We could be processing a corrupt block, so we can't trust any of
+ * the offsets or lengths to be within the buffer range. Hence check
+ * carefully!
+ */
 static void
 zero_btree_node(
 	struct xfs_btree_block	*block,
@@ -258,55 +263,64 @@ zero_btree_node(
 	xfs_inobt_key_t		*ikp;
 	xfs_alloc_ptr_t		*app;
 	xfs_alloc_key_t		*akp;
-	void			*zp1, *zp2;
-	int			zlen1, zlen2;
+	char			*zp1, *zp2;
+	char			*key_end;
 
 	nrecs = be16_to_cpu(block->bb_numrecs);
+	if (nrecs < 0)
+		return;
 
 	switch (btype) {
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
+		if (nrecs > mp->m_bmap_dmxr[1])
+			return;
+
 		bkp = XFS_BMBT_KEY_ADDR(mp, block, 1);
 		bpp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-		zp1 = &bkp[nrecs];
-		zlen1 = (char *)&bpp[0] - (char *)&bkp[nrecs];
-		zp2 = &bpp[nrecs];
-		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
-							(char *)&bpp[nrecs];
+		zp1 = (char *)&bkp[nrecs];
+		zp2 = (char *)&bpp[nrecs];
+		key_end = (char *)bpp;
 		break;
 	case TYP_INOBT:
 	case TYP_FINOBT:
+		if (nrecs > mp->m_inobt_mxr[1])
+			return;
+
 		ikp = XFS_INOBT_KEY_ADDR(mp, block, 1);
 		ipp = XFS_INOBT_PTR_ADDR(mp, block, 1, mp->m_inobt_mxr[1]);
-		zp1 = &ikp[nrecs];
-		zlen1 = (char *)&ipp[0] - (char *)&ikp[nrecs];
-		zp2 = &ipp[nrecs];
-		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
-							(char *)&ipp[nrecs];
+		zp1 = (char *)&ikp[nrecs];
+		zp2 = (char *)&ipp[nrecs];
+		key_end = (char *)ipp;
 		break;
 	case TYP_BNOBT:
 	case TYP_CNTBT:
+		if (nrecs > mp->m_alloc_mxr[1])
+			return;
+
 		akp = XFS_ALLOC_KEY_ADDR(mp, block, 1);
 		app = XFS_ALLOC_PTR_ADDR(mp, block, 1, mp->m_alloc_mxr[1]);
-		zp1 = &akp[nrecs];
-		zlen1 = (char *)&app[0] - (char *)&akp[nrecs];
-		zp2 = &app[nrecs];
-		zlen2 = (char *)block + mp->m_sb.sb_blocksize -
-							(char *)&app[nrecs];
+		zp1 = (char *)&akp[nrecs];
+		zp2 = (char *)&app[nrecs];
+		key_end = (char *)app;
 		break;
 	default:
-		zp1 = NULL;
-		break;
+		return;
 	}
 
-	if (zp1 && zp2) {
-		/* Zero from end of keys to beginning of pointers */
-		memset(zp1, 0, zlen1);
-		/* Zero from end of pointers to end of block */
-		memset(zp2, 0, zlen2);
-	}
+
+	/* Zero from end of keys to beginning of pointers */
+	memset(zp1, 0, key_end - zp1);
+
+	/* Zero from end of pointers to end of block */
+	memset(zp2, 0, (char *)block + mp->m_sb.sb_blocksize - zp2);
 }
 
+/*
+ * We could be processing a corrupt block, so we can't trust any of
+ * the offsets or lengths to be within the buffer range. Hence check
+ * carefully!
+ */
 static void
 zero_btree_leaf(
 	struct xfs_btree_block	*block,
@@ -316,38 +330,43 @@ zero_btree_leaf(
 	struct xfs_bmbt_rec	*brp;
 	struct xfs_inobt_rec	*irp;
 	struct xfs_alloc_rec	*arp;
-	void			*zp;
-	int			zlen;
+	char			*zp;
 
 	nrecs = be16_to_cpu(block->bb_numrecs);
+	if (nrecs < 0)
+		return;
 
 	switch (btype) {
 	case TYP_BMAPBTA:
 	case TYP_BMAPBTD:
+		if (nrecs > mp->m_bmap_dmxr[1])
+			return;
+
 		brp = XFS_BMBT_REC_ADDR(mp, block, 1);
-		zp = &brp[nrecs];
-		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&brp[nrecs];
+		zp = (char *)&brp[nrecs];
 		break;
 	case TYP_INOBT:
 	case TYP_FINOBT:
+		if (nrecs > mp->m_inobt_mxr[1])
+			return;
+
 		irp = XFS_INOBT_REC_ADDR(mp, block, 1);
-		zp = &irp[nrecs];
-		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&irp[nrecs];
+		zp = (char *)&irp[nrecs];
 		break;
 	case TYP_BNOBT:
 	case TYP_CNTBT:
+		if (nrecs > mp->m_alloc_mxr[1])
+			return;
+
 		arp = XFS_ALLOC_REC_ADDR(mp, block, 1);
-		zp = &arp[nrecs];
-		zlen = (char *)block + mp->m_sb.sb_blocksize - (char *)&arp[nrecs];
+		zp = (char *)&arp[nrecs];
 		break;
 	default:
-		zp = NULL;
-		break;
+		return;
 	}
 
 	/* Zero from end of records to end of block */
-	if (zp && zlen < mp->m_sb.sb_blocksize)
-		memset(zp, 0, zlen);
+	memset(zp, 0, (char *)block + mp->m_sb.sb_blocksize - zp);
 }
 
 static void
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
