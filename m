Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HvhJF034368 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0484341E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eeOl8MIUN6lS91Hr for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:40 -0700 (PDT)
Message-Id: <20090902175840.573208011@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/14] repair: reduce byte swapping in scan_freelist
References: <20090902175531.469184575@bombadil.infradead.org>
Content-Disposition: inline; filename=repair-cleanup-scan_freelist
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
Cc: Barry Naujok <bnaujok@sgi.com>

Store the ag number in a local native endian variable to avoid byteswapping
it over and over again.


Signed-off-by: Barry Naujok <bnaujok@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/repair/scan.c
===================================================================
--- xfsprogs-dev.orig/repair/scan.c	2009-08-21 19:03:26.000000000 +0000
+++ xfsprogs-dev/repair/scan.c	2009-08-21 19:05:32.000000000 +0000
@@ -943,23 +943,26 @@ scan_freelist(
 {
 	xfs_agfl_t	*agfl;
 	xfs_buf_t	*agflbuf;
+	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	int		count;
 	int		i;
 
+	agno = be32_to_cpu(agf->agf_seqno);
+
 	if (XFS_SB_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
-			XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
-			XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
-		set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
-				XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
+	    XFS_AGF_BLOCK(mp) != XFS_AGFL_BLOCK(mp) &&
+	    XFS_AGI_BLOCK(mp) != XFS_AGFL_BLOCK(mp))
+		set_agbno_state(mp, agno, XFS_AGFL_BLOCK(mp), XR_E_FS_MAP);
+
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
-	agflbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp,
-				be32_to_cpu(agf->agf_seqno),
-				XFS_AGFL_DADDR(mp)), XFS_FSS_TO_BB(mp, 1), 0);
+
+	agflbuf = libxfs_readbuf(mp->m_dev,
+				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+				 XFS_FSS_TO_BB(mp, 1), 0);
 	if (!agflbuf)  {
-		do_abort(_("can't read agfl block for ag %d\n"),
-			be32_to_cpu(agf->agf_seqno));
+		do_abort(_("can't read agfl block for ag %d\n"), agno);
 		return;
 	}
 	agfl = XFS_BUF_TO_AGFL(agflbuf);
@@ -967,12 +970,11 @@ scan_freelist(
 	count = 0;
 	for (;;) {
 		bno = be32_to_cpu(agfl->agfl_bno[i]);
-		if (verify_agbno(mp, be32_to_cpu(agf->agf_seqno), bno))
-			set_agbno_state(mp, be32_to_cpu(agf->agf_seqno),
-					bno, XR_E_FREE);
+		if (verify_agbno(mp, agno, bno))
+			set_agbno_state(mp, agno, bno, XR_E_FREE);
 		else
 			do_warn(_("bad agbno %u in agfl, agno %d\n"),
-				bno, be32_to_cpu(agf->agf_seqno));
+				bno, agno);
 		count++;
 		if (i == be32_to_cpu(agf->agf_fllast))
 			break;
@@ -981,8 +983,7 @@ scan_freelist(
 	}
 	if (count != be32_to_cpu(agf->agf_flcount)) {
 		do_warn(_("freeblk count %d != flcount %d in ag %d\n"), count,
-			be32_to_cpu(agf->agf_flcount),
-			be32_to_cpu(agf->agf_seqno));
+			be32_to_cpu(agf->agf_flcount), agno);
 	}
 	libxfs_putbuf(agflbuf);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
