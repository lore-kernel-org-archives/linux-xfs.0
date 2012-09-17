Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HGotGe186679 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:50:55 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l22H00IVYdRloAkq for
	<xfs@oss.sgi.com>; Mon, 17 Sep 2012 09:52:05 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8HGq5Ze012316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 12:52:05 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-119.phx2.redhat.com
	[10.3.113.119])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8HGpopJ016371
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 12:52:04 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 3/4] xfs: set xfs_initialize_perag() to use
	xfs_set_inode32/64()
Date: Mon, 17 Sep 2012 13:51:41 -0300
Message-Id: <1347900702-23421-4-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
References: <1347900702-23421-1-git-send-email-cmaiolino@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Set xfs_initialize_perag() to use xfs_set_inode32() and xfs_set_inode64()
functions, removing duplicated code

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_mount.c | 43 +++++--------------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 29c2f83..b2bd3a0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -440,7 +440,7 @@ xfs_initialize_perag(
 	xfs_agnumber_t	agcount,
 	xfs_agnumber_t	*maxagi)
 {
-	xfs_agnumber_t	index, max_metadata;
+	xfs_agnumber_t	index;
 	xfs_agnumber_t	first_initialised = 0;
 	xfs_perag_t	*pag;
 	xfs_agino_t	agino;
@@ -500,43 +500,10 @@ xfs_initialize_perag(
 	else
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
 
-	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
-		/*
-		 * Calculate how much should be reserved for inodes to meet
-		 * the max inode percentage.
-		 */
-		if (mp->m_maxicount) {
-			__uint64_t	icount;
-
-			icount = sbp->sb_dblocks * sbp->sb_imax_pct;
-			do_div(icount, 100);
-			icount += sbp->sb_agblocks - 1;
-			do_div(icount, sbp->sb_agblocks);
-			max_metadata = icount;
-		} else {
-			max_metadata = agcount;
-		}
-
-		for (index = 0; index < agcount; index++) {
-			ino = XFS_AGINO_TO_INO(mp, index, agino);
-			if (ino > XFS_MAXINUMBER_32) {
-				index++;
-				break;
-			}
-
-			pag = xfs_perag_get(mp, index);
-			pag->pagi_inodeok = 1;
-			if (index < max_metadata)
-				pag->pagf_metadata = 1;
-			xfs_perag_put(pag);
-		}
-	} else {
-		for (index = 0; index < agcount; index++) {
-			pag = xfs_perag_get(mp, index);
-			pag->pagi_inodeok = 1;
-			xfs_perag_put(pag);
-		}
-	}
+	if (mp->m_flags & XFS_MOUNT_32BITINODES)
+		index = xfs_set_inode32(mp);
+	else
+		index = xfs_set_inode64(mp);
 
 	if (maxagi)
 		*maxagi = index;
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
