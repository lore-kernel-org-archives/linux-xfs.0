Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DD8xFn004265 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:08:59 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id hOtT1dulUqdIHH4y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 06:08:58 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q7DD8vEY016771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:08:57 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q7DD8uJs028524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:08:57 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q7DD8uJC007529 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:08:56 -0500
Message-ID: <5028FC39.5060809@oracle.com>
Date: Mon, 13 Aug 2012 21:08:09 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v7 3/4] xfs: xfs_seek_data() refinement with unwritten extents
	check up from page cache
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

Improve xfs_seek_data() to search data offset from page cache for unwritten extents.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_file.c |   70 +++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 52 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 023dc9b..43b3718 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1187,8 +1187,6 @@ xfs_seek_data(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	map[2];
-	int			nmap = 2;
 	loff_t			uninitialized_var(offset);
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
@@ -1204,36 +1202,72 @@ xfs_seek_data(
 		goto out_unlock;
 	}
 
-	fsbno = XFS_B_TO_FSBT(mp, start);
-
 	/*
 	 * Try to read extents from the first block indicated
 	 * by fsbno to the end block of the file.
 	 */
+	fsbno = XFS_B_TO_FSBT(mp, start);
 	end = XFS_B_TO_FSB(mp, isize);
+	for (;;) {
+		struct xfs_bmbt_irec	map[2];
+		int			nmap = 2;
+		unsigned int		i;
 
-	error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
-			       XFS_BMAPI_ENTIRE);
-	if (error)
-		goto out_unlock;
+		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
+				       XFS_BMAPI_ENTIRE);
+		if (error)
+			goto out_unlock;
 
-	/*
-	 * Treat unwritten extent as data extent since it might
-	 * contains dirty data in page cache.
-	 */
-	if (map[0].br_startblock != HOLESTARTBLOCK) {
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[0].br_startoff));
-	} else {
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
+			/* Landed in a data extent */
+			if (map[i].br_startblock == DELAYSTARTBLOCK ||
+			    (map[i].br_state == XFS_EXT_NORM &&
+			     !isnullstartblock(map[i].br_startblock)))
+				goto out;
+
+			/*
+			 * Landed in an unwritten extent, try to search data
+			 * from page cache.
+			 */
+			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
+				if (xfs_find_get_desired_pgoff(inode, &map[i],
+							DATA_OFF, &offset))
+					goto out;
+			}
+		}
+
+		/*
+		 * map[0] is hole or its an unwritten extent but
+		 * without data in page cache.  Probably means that
+		 * we are reading after EOF if nothing in map[1].
+		 */
 		if (nmap == 1) {
 			error = ENXIO;
 			goto out_unlock;
 		}
 
-		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[1].br_startoff));
+		/*
+		 * Nothing was found, proceed to the next round of search
+		 * if reading offset not beyond or hit EOF.
+		 */
+		fsbno = map[i - 1].br_startoff + map[i - 1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			error = ENXIO;
+			goto out_unlock;
+		}
 	}
 
+out:
 	if (offset != file->f_pos)
 		file->f_pos = offset;
 
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
