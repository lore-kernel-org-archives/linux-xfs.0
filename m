Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42JedQK076311 for <xfs@oss.sgi.com>; Wed, 2 May 2012 14:40:40 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sxf63XV3AnZ9QfgH for
	<xfs@oss.sgi.com>; Wed, 02 May 2012 12:40:38 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q42Jeb9H000909
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 2 May 2012 15:40:38 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q42JeaW7001622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 2 May 2012 15:40:37 -0400
Message-ID: <4FA18DB4.6050901@redhat.com>
Date: Wed, 02 May 2012 14:40:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: fix process_leaf_node_dir2() for fragmented
	multiblock dirs
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

Consider a filesystem with 4k fs blocks and 16k dir blocks, with
extremely fragmented freespace so that a 2 block (32k) directory
ends up with these extents, covering 2 multiblock dir blocks:

index:	phys	len
-----------------
0	10	1
1	12	1
2	14	1
3	16	1
-----------------
4	18	1
5	20	1
6	22	1
7	24	1

The loop in process_leaf_node_dir2() would obtain the first 4 just
fine:

-----------------
0	10	1
1	12	1
2	14	1
3	16	1
-----------------

But then although it advanced ndbno (next block nr) by
an amount relative to mp->m_dirfsbs, it left "t" (the starting
extent number for the search) untouched.

blkmap_next_off() is really designed to be iterated block by block,
as far as I can tell, and if you pass in a block nr which is at
an offset beyond that when extent "t" covers, it will simply return
you the first logical block in extent "t".

So, we advanced the requested block nr by 4, but left t untouched
at 1, and at the top of the loop next time, we get this for the
next 16k "dir block:"

1	12	1
2	14	1
3	16	1
-----------------
4	18	1

This isn't properly aligned with the dir block; the magic for the next
dir block is in phys block 18, not 12, so repair thinks things are 
corrupted and it gets worse from there.

To fix this, just call blkmap_next_off() a few more times in a loop
until we reach the last fs block in our dir block.  Then the outer
loop will find the next block after THAT, and process the next multiblock
dir block properly.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index f9562d7..7a614a8 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -2003,7 +2003,11 @@ process_leaf_node_dir2(
 	ndbno = NULLDFILOFF;
 	while ((dbno = blkmap_next_off(blkmap, ndbno, &t)) < mp->m_dirleafblk) {
 		nex = blkmap_getn(blkmap, dbno, mp->m_dirblkfsbs, &bmp, &lbmp);
-		ndbno = dbno + mp->m_dirblkfsbs - 1;
+		/* Advance through map to last fs block in this dir block */
+		ndbno = dbno;
+		while (ndbno < dbno + mp->m_dirblkfsbs - 1) {
+			ndbno = blkmap_next_off(blkmap, ndbno, &t);
+		}
 		if (nex == 0) {
 			do_warn(
 _("block %" PRIu64 " for directory inode %" PRIu64 " is missing\n"),


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
