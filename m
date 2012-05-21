Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LMA9nI025131 for <xfs@oss.sgi.com>; Mon, 21 May 2012 17:10:09 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Yu5N49ClfhyB0QXw for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 15:10:08 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LMA7rB024098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 18:10:07 -0400
Message-ID: <4FBABD3E.2050700@redhat.com>
Date: Mon, 21 May 2012 17:10:06 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfs_repair: Fix fragmented multiblock dir2 handling in
	blkmap_getn()
References: <4FBABCAB.20300@redhat.com>
In-Reply-To: <4FBABCAB.20300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

blkmap_getn() contains a loop which populates an array of extents
with mapping information for a dir2 "block," which may consist
of multiple filesystem blocks.

As written, the loop re-allocates the array for each new extent,
leaking the previously allocated memory and worse, losing the
previously filled-in extent information.

Fix this by only allocating the array once, for the maximum
possible number of extents - the number of fs blocks in the dir
block.

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
