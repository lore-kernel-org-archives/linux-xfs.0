Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDWM78088940 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:32:22 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NOab9anxY9pl213E for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:33:35 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8KDXZT4016429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:35 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-73.phx2.redhat.com
	[10.3.113.73])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8KDXRt7019074
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:34 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5/6] xfs: add inode64->inode32 transition into
	xfs_set_inode32()
Date: Thu, 20 Sep 2012 10:32:40 -0300
Message-Id: <1348147961-7520-6-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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

To make inode32 a remountable option, xfs_set_inode32() should be able to make a
transition from inode64 option, disabling inode allocation on higher AGs.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 966f56c..3329296 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -603,6 +603,7 @@ xfs_agnumber_t
 xfs_set_inode32(struct xfs_mount *mp)
 {
 	xfs_agnumber_t	index = 0;
+	xfs_agnumber_t	maxagi = 0;
 	xfs_sb_t	*sbp = &mp->m_sb;
 	xfs_agnumber_t	max_metadata;
 	xfs_agino_t	agino =	XFS_OFFBNO_TO_AGINO(mp, sbp->sb_agblocks -1, 0);
@@ -626,18 +627,26 @@ xfs_set_inode32(struct xfs_mount *mp)
 
 	for (index = 0; index < sbp->sb_agcount; index++) {
 		ino = XFS_AGINO_TO_INO(mp, index, agino);
+
 		if (ino > XFS_MAXINUMBER_32) {
-			index++;
-			break;
+			pag = xfs_perag_get(mp, index);
+			pag->pagi_inodeok = 0;
+			pag->pagf_metadata = 0;
+			xfs_perag_put(pag);
+			continue;
 		}
 
 		pag = xfs_perag_get(mp, index);
 		pag->pagi_inodeok = 1;
+		maxagi++;
 		if (index < max_metadata)
 			pag->pagf_metadata = 1;
 		xfs_perag_put(pag);
 	}
-	return index;
+	mp->m_flags |= (XFS_MOUNT_32BITINODES |
+			XFS_MOUNT_SMALL_INUMS);
+
+	return maxagi;
 }
 
 xfs_agnumber_t
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
