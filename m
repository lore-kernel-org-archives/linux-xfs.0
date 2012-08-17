Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7HLKA3F098114 for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 16:20:11 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KioMIB5trIJIm0PV for
	<xfs@oss.sgi.com>; Fri, 17 Aug 2012 14:19:42 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7HLJfME031817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 Aug 2012 17:19:41 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH V4] Make inode64 a remountable option
Date: Fri, 17 Aug 2012 18:19:38 -0300
Message-Id: <1345238378-10123-1-git-send-email-cmaiolino@redhat.com>
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
 fs/xfs/xfs_super.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bdaf4cb..f1f2968 100644
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
 
@@ -1030,6 +1031,30 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 	xfs_reserve_blocks(mp, &resblks, NULL);
 }
 
+STATIC void
+xfs_set_inode64(struct xfs_mount *mp)
+{
+	int i = 0;
+
+	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, i);
+		pag->pagi_inodeok = 1;
+		pag->pagf_metadata = 0;
+		xfs_perag_put(pag);
+	}
+
+	/* There is no need for lock protection on m_flags,
+	 * the rw_semaphore of the VFS superblock is locked
+	 * during mount/umount/remount operations, so this is
+	 * enough to avoid concurency on the m_flags field
+	 */
+	mp->m_flags &= ~(XFS_MOUNT_32BITINODES |
+			 XFS_MOUNT_SMALL_INUMS);
+	mp->m_maxagi = i;
+}
+
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
@@ -1055,6 +1080,9 @@ xfs_fs_remount(
 		case Opt_nobarrier:
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 			break;
+		case Opt_inode64:
+			xfs_set_inode64(mp);
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
