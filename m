Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8uxc4003390 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:56:59 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id KrMnHx8xk1MdrSRF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:56:58 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6Q8uuKG016543
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:56:57 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6Q8utSc009902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 08:56:55 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6Q8utDU015888 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:56:55 -0500
Message-ID: <50110630.7020902@oracle.com>
Date: Thu, 26 Jul 2012 16:56:16 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v5 3/4]xfs: xfs_seek_data() refinements with lookup data buffer
	offset from page cache.
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

Search data buffer offset for given range from page cache for unwritten extents.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_file.c |   88 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 43f5e61..15acd4d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1177,8 +1177,6 @@ xfs_seek_data(
 	struct inode		*inode = file->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	map[2];
-	int			nmap = 2;
 	loff_t			uninitialized_var(offset);
 	xfs_fsize_t		isize;
 	xfs_fileoff_t		fsbno;
@@ -1194,34 +1192,88 @@ xfs_seek_data(
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
-		if (nmap == 1) {
+		/* No extents at given offset, must be beyond EOF */
+		if (nmap == 0) {
 			error = ENXIO;
 			goto out_unlock;
 		}
 
 		offset = max_t(loff_t, start,
-			       XFS_FSB_TO_B(mp, map[1].br_startoff));
+			       XFS_FSB_TO_B(mp, map[0].br_startoff));
+		if (map[0].br_state == XFS_EXT_NORM &&
+		    !isnullstartblock(map[0].br_startblock))
+			break;
+		else {
+			/*
+			 * Landed in an unwritten extent, try to lookup data
+			 * buffer from the page cache before proceeding to
+			 * check the next extent map.  It's a hole if nothing
+			 * was found.
+			 */
+			if (map[0].br_startblock == DELAYSTARTBLOCK ||
+			    map[0].br_state == XFS_EXT_UNWRITTEN) {
+				/* Probing page cache start from offset */
+				if (xfs_find_get_desired_pgoff(inode, &map[0],
+							DATA_OFF, &offset))
+					break;
+			}
+
+			/*
+			 * Found a hole in map[0] and nothing in map[1].
+			 * Probably means that we are reading after EOF.
+			 */
+			if (nmap == 1) {
+				error = ENXIO;
+				goto out_unlock;
+			}
+
+			/*
+			 * We have two mappings, proceed to check map[1].
+			 */
+			offset = max_t(loff_t, start,
+				       XFS_FSB_TO_B(mp, map[1].br_startoff));
+			if (map[1].br_state == XFS_EXT_NORM &&
+			    !isnullstartblock(map[1].br_startblock))
+				break;
+			else {
+				/*
+				 * map[1] is also an unwritten extent, lookup
+				 * data buffer from page cache now.
+				 */
+				if (map[1].br_startblock == DELAYSTARTBLOCK ||
+				    map[1].br_state == XFS_EXT_UNWRITTEN) {
+					if (xfs_find_get_desired_pgoff(inode,
+						&map[1], DATA_OFF, &offset))
+						break;
+				}
+			}
+		}
+
+		/*
+		 * Nothing was found, proceed to the next round of search if
+		 * reading offset not beyond or hit EOF.
+		 */
+		fsbno = map[1].br_startoff + map[1].br_blockcount;
+		start = XFS_FSB_TO_B(mp, fsbno);
+		if (start >= isize) {
+			error = ENXIO;
+			goto out_unlock;
+		}
 	}
 
 	if (offset != file->f_pos)
-- 
1.7.4.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
