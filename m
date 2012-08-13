Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DD92HF004279 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:09:02 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id tcpq78ByLRG9J94g (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 06:09:01 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q7DD90a5016841
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:09:01 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q7DD90I5016075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:09:00 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q7DD908d025220 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:09:00 -0500
Message-ID: <5028FC3D.8000007@oracle.com>
Date: Mon, 13 Aug 2012 21:08:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v7 4/4] xfs: xfs_seek_hole() refinement with hole searching
	from page cache for unwritten extent
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

Improve xfs_seek_hole() to search hole offset from page cache for unwritten extents.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_file.c |   76 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 43b3718..a537f61 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1288,9 +1288,9 @@ xfs_seek_hole(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			uninitialized_var(offset);
-	loff_t			holeoff;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		end;
 	uint			lock;
 	int			error;
 
@@ -1306,21 +1306,75 @@ xfs_seek_hole(
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
+		unsigned int		i;
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
+
+		for (i = 0; i < nmap; i++) {
+			offset = max_t(loff_t, start,
+				       XFS_FSB_TO_B(mp, map[i].br_startoff));
+
+			/* Landed in a hole */
+			if (map[i].br_startblock == HOLESTARTBLOCK)
+				goto out;
+
+			/*
+			 * Landed in an unwritten extent, try to search hole
+			 * from page cache.
+			 */
+			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
+				if (xfs_find_get_desired_pgoff(inode, &map[i],
+							HOLE_OFF, &offset))
+					goto out;
+			}
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
 
-	holeoff = XFS_FSB_TO_B(mp, fsbno);
-	if (holeoff <= start)
-		offset = start;
-	else {
 		/*
-		 * xfs_bmap_first_unused() could return a value bigger than
-		 * isize if there are no more holes past the supplied offset.
+		 * Both mappings contains data, proceed to the next round of
+		 * search if the current reading offset not beyond or hit EOF.
 		 */
-		offset = min_t(loff_t, holeoff, isize);
+		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			offset = isize;
+			break;
+		}
 	}
 
+out:
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
