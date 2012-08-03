Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q736BxoL044888 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:59 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id Pb4r7ZXuCZxQ7agP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 23:11:58 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q736BvDx006544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:58 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q736Bv6g022424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:57 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q736Bu4M019467 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:56 -0500
Message-ID: <501B6B82.10405@oracle.com>
Date: Fri, 03 Aug 2012 14:11:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v6 4/4] xfs: xfs_seek_hole()  refinement with lookup hole
	offset from page cache
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com

xfs_seek_hole() refinement with hole searching from page cache for unwritten extent.


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 69 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e852e52..0ab27eb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1295,9 +1295,9 @@ xfs_seek_hole(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			uninitialized_var(offset);
-	loff_t			holeoff;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		end;
 	uint			lock;
 	int			error;
 
@@ -1313,21 +1313,80 @@ xfs_seek_hole(
 	}
 
 	fsbno = XFS_B_TO_FSBT(mp, start);
-	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
-	if (error)
-		goto out_unlock;
+	end = XFS_B_TO_FSB(mp, isize);
+
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+
+		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
+
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
+			error = ENXIO;
+			goto out_unlock;
+		}
 
-	holeoff = XFS_FSB_TO_B(mp, fsbno);
-	if (holeoff <= start)
 		offset = start;
-	else {
+		/* Landed in a hole */
+		if (map[0].br_startblock == HOLESTARTBLOCK)
+			break;
+
 		/*
-		 * xfs_bmap_first_unused() could return a value bigger than
-		 * isize if there are no more holes past the supplied offset.
+		 * Landed in an unwritten extent, try to search hole from
+		 * page cache.
 		 */
-		offset = min_t(loff_t, holeoff, isize);
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			if (xfs_find_get_desired_pgoff(inode, &map[0],
+						       HOLE_OFF, &offset))
+				break;
+		}
+
+		/*
+		 * map[0] contains data or its unwritten but contains
+		 * data in page cache, probably means that we are
+		 * reading after EOF.  We should fix offset to point
+		 * to the end of the file(i.e., there is an implicit
+		 * hole at the end of any file).
+		 */
+		if (nmap == 1) {
+			offset = isize;
+			break;
+		}
+
+		/* We have two mappings, proceed to check map[1] */
+		offset = XFS_FSB_TO_B(mp, map[1].br_startoff);
+		if (map[1].br_startblock == HOLESTARTBLOCK)
+			break;
+
+		if (map[1].br_state == XFS_EXT_UNWRITTEN) {
+			if (xfs_find_get_desired_pgoff(inode, &map[1],
+						       HOLE_OFF, &offset))
+				break;
+		}
+
+		/*
+		 * Both mappings contains data, proceed to the next round of
+		 * search if the current reading offset not beyond or hit EOF.
+		 */
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			offset = isize;
+			break;
+		}
 	}
 
+	/*
+	 * At this point, we must have found a hole.  However, the returned
+	 * offset may be bigger than the file size as it may be aligned to
+	 * page boundary for unwritten extents, we need to deal with this
+	 * situation in particular.
+	 */
+	offset = min_t(loff_t, offset, isize);
 	if (offset != file->f_pos)
 		file->f_pos = offset;
 
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
