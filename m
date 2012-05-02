Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q423s6a6244262 for <xfs@oss.sgi.com>; Tue, 1 May 2012 22:54:07 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id B2ILZ2IvniVDKlAi for
	<xfs@oss.sgi.com>; Tue, 01 May 2012 20:54:05 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q423s4jA022273
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 1 May 2012 23:54:05 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q423s3eD005607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 1 May 2012 23:54:04 -0400
Message-ID: <4FA0AFDB.5060009@redhat.com>
Date: Tue, 01 May 2012 22:54:03 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix for fragmented multiblock dirs
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
To: xfs-oss <xfs@oss.sgi.com>

blkmap_getn() was reallocating the bmap_ext_t *bmp array
for each extent in the loop, thereby losing previously
filled-in elements, and generally making a mess of things.

Allocating it only the first time through the loop
fixes this right up.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/bmap.c b/repair/bmap.c
index 2f1c307..c43ca7f 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -168,7 +168,8 @@ blkmap_getn(
 		/*
 		 * rare case - multiple extents for a single dir block
 		 */
-		bmp = malloc(nb * sizeof(bmap_ext_t));
+		if (!bmp)
+			bmp = malloc(nb * sizeof(bmap_ext_t));
 		if (!bmp)
 			do_error(_("blkmap_getn malloc failed (%" PRIu64 " bytes)\n"),
 						nb * sizeof(bmap_ext_t));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
