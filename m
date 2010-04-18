Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3I090DJ096526 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 19:09:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E18952CD6F8
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fdmVKly6ZGjb7552 for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O3I6E-0006r1-Hr
	for xfs@oss.sgi.com; Sun, 18 Apr 2010 00:10:58 +0000
Message-Id: <20100418001058.355165168@bombadil.infradead.org>
Date: Sat, 17 Apr 2010 20:10:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/5] xfs: removed unused XFS_QMOPT_ flags
References: <20100418001041.865247520@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-QMOPTS
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2010-04-17 17:06:47.267003919 -0700
+++ xfs/fs/xfs/xfs_quota.h	2010-04-17 17:06:49.860004198 -0700
@@ -201,9 +201,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
 #define XFS_QMOPT_DQSUSER	0x0000020 /* don't cache super users dquot */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
-#define XFS_QMOPT_QUOTAOFF	0x0000080 /* quotas are being turned off */
-#define XFS_QMOPT_UMOUNTING	0x0000100 /* filesys is being unmounted */
-#define XFS_QMOPT_DOLOG		0x0000200 /* log buf changes (in quotacheck) */
 #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
 #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-04-17 17:06:49.196005874 -0700
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-04-17 17:06:49.863024103 -0700
@@ -321,7 +321,7 @@ xfs_qm_unmount(
 	struct xfs_mount	*mp)
 {
 	if (mp->m_quotainfo) {
-		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
+		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
 		xfs_qm_destroy_quotainfo(mp);
 	}
 }
@@ -1825,7 +1825,7 @@ xfs_qm_quotacheck(
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
 	if (error) {
-		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_QUOTAOFF);
+		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
 		goto error_return;
 	}
 
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-17 17:06:48.725318976 -0700
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-17 17:06:49.869026478 -0700
@@ -200,7 +200,7 @@ xfs_qm_scall_quotaoff(
 	 * So, if we couldn't purge all the dquots from the filesystem,
 	 * we can't get rid of the incore data structures.
 	 */
-	while ((nculprits = xfs_qm_dqpurge_all(mp, dqtype|XFS_QMOPT_QUOTAOFF)))
+	while ((nculprits = xfs_qm_dqpurge_all(mp, dqtype)))
 		delay(10 * nculprits);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
