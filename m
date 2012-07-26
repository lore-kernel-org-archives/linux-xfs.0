Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFXch4048849 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:33:38 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id 6sy1659SX7cm5blP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 08:33:36 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6QFXZ8t004624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:33:36 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6QFXYDj015949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:33:35 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6QFXYCo004548 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:33:34 -0500
Message-ID: <50116326.6080701@oracle.com>
Date: Thu, 26 Jul 2012 23:32:54 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v5 4/4]xfs: xfs_seek_hole() refinements with lookup hole offset
	from page cache.
References: <50110636.2010602@oracle.com>
In-Reply-To: <50110636.2010602@oracle.com>
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

Search possbile hole offset for given range from page cache for
unwritten and delayed-allocation extents.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_file.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b1158b3..9ff732b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1301,9 +1301,9 @@ xfs_seek_hole(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	loff_t			uninitialized_var(offset);
-	loff_t			holeoff;
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
+	xfs_filblks_t		end;
 	uint			lock;
 	int			error;
 
@@ -1319,21 +1319,91 @@ xfs_seek_hole(
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
+		/* Landed in a hole, return */
+		if (map[0].br_startblock == HOLESTARTBLOCK)
+			break;
+		else {
+			/*
+			 * Landed in an unwritten extent, try to lookup page
+			 * cache to find holes.
+			 */
+			if (map[0].br_state == XFS_EXT_UNWRITTEN ||
+			    isnullstartblock(map[0].br_startblock)) {
+				/* Probing page cache start from offset */
+				if (xfs_find_get_desired_pgoff(inode, &map[0],
+							HOLE_OFF, &offset))
+					break;
+			}
+
+			/*
+			 * map[0] is unwritten and there is no hole past
+			 * offset, probably means that we are reading after
+			 * EOF.  Hence, we should fix offset to point to the
+			 * end of the file(i.e., there is an implicit hole at
+			 * the end of any file).
+			 */
+			if (nmap == 1) {
+				offset = isize;
+				break;
+			}
+
+			/* We have two mappings, proceed to check map[1] */
+			offset = XFS_FSB_TO_B(mp, map[1].br_startoff);
+			if (map[1].br_startblock == HOLESTARTBLOCK)
+				break;
+			else {
+				/*
+				 * map[1] is also an unwritten extent, try
+				 * to lookup hole from the page cache again.
+				 */
+				if (map[1].br_state == XFS_EXT_UNWRITTEN ||
+				    isnullstartblock(map[1].br_startblock)) {
+					if (xfs_find_get_desired_pgoff(inode,
+						&map[1], HOLE_OFF, &offset))
+						break;
+				}
+			}
+		}
+
 		/*
-		 * xfs_bmap_first_unused() could return a value bigger than
-		 * isize if there are no more holes past the supplied offset.
+		 * Both mappings contains data, proceed to the next round of
+		 * search if the current reading offset not beyond or hit EOF.
 		 */
-		offset = min_t(loff_t, holeoff, isize);
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			offset = isize;
+			break;
+		}
 	}
 
+	/*
+	 * Come to here, we must have found a hole.  However, the returned
+	 * offset might be greater than the file size as it might be fixed
+	 * to block buffer unit boundary at page cache lookup procedure for
+	 * unwritten and delayed-allocation extents, we need to deal with
+	 * this situation in particular.
+	 */
+	offset = min_t(loff_t, offset, isize);
+
 	if (offset != file->f_pos)
 		file->f_pos = offset;
 
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
