Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MDgdNx214902 for <xfs@oss.sgi.com>; Tue, 22 May 2012 08:42:39 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id mTCMsLFM1nsA9VQz for <xfs@oss.sgi.com>;
	Tue, 22 May 2012 06:42:38 -0700 (PDT)
Message-ID: <4FBB97CE.5030902@sandeen.net>
Date: Tue, 22 May 2012 08:42:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3 RESEND] xfs_repair: handle fragmented multiblock dir2
	in process_leaf_node_dir2()
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

Resending, first one didn't make it through the mailing list gauntlet

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
