Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7H2dhQK234993 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 21:39:44 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C9rqko9J1NNZ3WZm for
	<xfs@oss.sgi.com>; Thu, 16 Aug 2012 19:39:42 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7H2dgeA029963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 22:39:42 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V3] Make inode64 a remountable option
Date: Thu, 16 Aug 2012 23:39:38 -0300
Message-Id: <1345171178-10447-1-git-send-email-cmaiolino@redhat.com>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

Actually, there is no reason about why a user must umount and mount a XFS
filesystem to enable 'inode64' option. So, this patch makes this a remountable
option.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bdaf4cb..98acd26 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -120,12 +120,13 @@ mempool_t *xfs_ioend_pool;
  * in the future, too.
  */
 enum {
-	Opt_barrier, Opt_nobarrier, Opt_err
+	Opt_barrier, Opt_nobarrier, Opt_inode64, Opt_err
 };
 
 static const match_table_t tokens = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
+	{Opt_inode64, "inode64"},
 	{Opt_err, NULL}
 };
 
@@ -1043,6 +1044,7 @@ xfs_fs_remount(
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
+		int i = 0;
 
 		if (!*p)
 			continue;
@@ -1055,6 +1057,20 @@ xfs_fs_remount(
 		case Opt_nobarrier:
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 			break;
+		case Opt_inode64:
+
+			for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+				struct xfs_perag	*pag;
+
+				pag = xfs_perag_get(mp, i);
+				pag->pagi_inodeok = 1;
+				pag->pagf_metadata = 0;
+				xfs_perag_put(pag);
+			}
+			mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
+					 XFS_MOUNT_SMALL_INUMS);
+			mp->m_maxagi = i;
+			break;
 		default:
 			/*
 			 * Logically we would return an error here to prevent
-- 
1.7.11.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
