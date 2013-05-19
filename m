Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D5FB29E06
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 18:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DAF648F8033
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 16:51:44 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lqzddEBojFoXinE4 for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 16:51:43 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeDO2-00069x-TA
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeDO2-0003z3-Qb
	for xfs@oss.sgi.com; Mon, 20 May 2013 09:51:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/14] xfs: remote attribute tail zeroing does too much
Date: Mon, 20 May 2013 09:51:18 +1000
Message-Id: <1369007481-15185-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

When an attribute data does not fill then entire remote block, we
zero the remaining part of the buffer. This, however, needs to take
into account that the buffer has a header, and so the offset where
zeroing starts and the length of zeroing need to take this into
account. Otherwise we end up with zeros over the end of the
attribute value when CRCs are enabled.

While there, make sure we only ask to map an extent that covers the
remaining range of the attribute, rather than asking every time for
the full length of remote data. If the remote attribute blocks are
contiguous with other parts of the attribute tree, it will map those
blocks as well and we can potentially zero them incorrectly. We can
also get buffer size mistmatches when trying to read or remove the
remote attribute, and this can lead to not finding the correct
buffer when looking it up in cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_remote.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index bcdc07c..e207bf0 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -296,10 +296,7 @@ xfs_attr_rmtval_set(
 	 * and we may not need that many, so we have to handle this when
 	 * allocating the blocks below. 
 	 */
-	if (!crcs)
-		blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
-	else
-		blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
+	blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
 
 	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
 						   XFS_ATTR_FORK);
@@ -394,8 +391,11 @@ xfs_attr_rmtval_set(
 	 */
 	lblkno = args->rmtblkno;
 	valuelen = args->valuelen;
+	blkcnt = args->rmtblkcnt;
 	while (valuelen > 0) {
 		int	byte_cnt;
+		int	hdr_size;
+		int	dblkcnt;
 		char	*buf;
 
 		/*
@@ -404,7 +404,7 @@ xfs_attr_rmtval_set(
 		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
-				       args->rmtblkcnt, &map, &nmap,
+				       blkcnt, &map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
 		if (error)
 			return(error);
@@ -413,26 +413,25 @@ xfs_attr_rmtval_set(
 		       (map.br_startblock != HOLESTARTBLOCK));
 
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
-		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
+		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt, 0);
+		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0);
 		if (!bp)
 			return ENOMEM;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
-
-		byte_cnt = BBTOB(bp->b_length);
-		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, byte_cnt);
-		if (valuelen < byte_cnt)
-			byte_cnt = valuelen;
-
 		buf = bp->b_addr;
-		buf += xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
+
+		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
+		byte_cnt = min_t(int, valuelen, byte_cnt);
+		hdr_size = xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
 					     byte_cnt, bp);
-		memcpy(buf, src, byte_cnt);
+		ASSERT(hdr_size + byte_cnt <= BBTOB(bp->b_length));
 
-		if (byte_cnt < BBTOB(bp->b_length))
-			xfs_buf_zero(bp, byte_cnt,
-				     BBTOB(bp->b_length) - byte_cnt);
+		memcpy(buf + hdr_size, src, byte_cnt);
+
+		if (byte_cnt + hdr_size < BBTOB(bp->b_length))
+			xfs_buf_zero(bp, byte_cnt + hdr_size,
+				     BBTOB(bp->b_length) - byte_cnt - hdr_size);
 
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
@@ -442,9 +441,9 @@ xfs_attr_rmtval_set(
 		src += byte_cnt;
 		valuelen -= byte_cnt;
 		offset += byte_cnt;
-		hdrcnt--;
 
 		lblkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
 	}
 	ASSERT(valuelen == 0);
 	return 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
