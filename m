Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4ML5Hqv255121 for <xfs@oss.sgi.com>; Tue, 22 May 2012 16:05:17 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7KdQUjoZOyk5vOYa for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 15:11:47 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LMBlq9004315
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 18:11:47 -0400
Message-ID: <4FBABDA1.1030205@redhat.com>
Date: Mon, 21 May 2012 17:11:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfs_repair: handle fragmented multiblock dir2 in
	process_leaf_node_dir2()
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

process_leaf_node_dir2() had the following loop:

	while ((dbno = blkmap_next_off(blkmap, ndbno, &t)) < mp->m_dirleafblk) {
		...
		ndbno = dbno + mp->m_dirblkfsbs - 1;
		...
	}

which does not account for fragmented multiblock dir2.

ndbno was blindly being advanced by m_dirblkfsbs, but then
blkmap_next_off() would return the logical block of the next
mapped extent in blkmap, which may be within the current
(fragmented) dir2 multi-block, not the next multi-block,
because the extent index t hadn't been advanced.

Fix this by calling blkmap_next_off() until ndbno has advanced
into the next multiblock dir2 block, thereby keeping
the extent index t straight while properly advancing
ndbno.

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
+		/* Advance through map to last dfs block in this dir block */
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
