Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcMG8226722 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AAF612A5D4
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:38:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eGHM0To0YxEoTX80 for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:38:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYD-00074n-4M
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:21 +0000
Message-Id: <20110831203821.057004755@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:37:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/14] xfs: remove XFS_QMOPT_DQSUSER
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-kill-XFS_QMOPT_DQSUSER
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

Just read the id 0 dquot from disk directly in xfs_qm_init_quotainfo, instead
of going through dqget and having a special flag to not add the dquot to any
lists.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-08-31 13:35:47.993379064 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-08-31 13:45:57.426708765 +0200
@@ -550,7 +550,7 @@ xfs_qm_dqtobp(
  *
  * If XFS_QMOPT_DQALLOC is set, allocate a dquot on disk if it needed.
  */
-STATIC int
+int
 xfs_qm_dqread(
 	struct xfs_mount	*mp,
 	xfs_dqid_t   		id,
@@ -798,32 +798,17 @@ restart:
 	mutex_unlock(&h->qh_lock);
 
 	error = xfs_qm_dqread(mp, id, type, flags, &dqp);
-	if (error) {
-		if (ip)
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-		return error;
-	}
 
-	/*
-	 * See if this is mount code calling to look at the overall quota limits
-	 * which are stored in the id == 0 user or group's dquot.
-	 * Since we may not have done a quotacheck by this point, just return
-	 * the dquot without attaching it to any hashtables, lists, etc, or even
-	 * taking a reference.
-	 * The caller must dqdestroy this once done.
-	 */
-	if (flags & XFS_QMOPT_DQSUSER) {
-		ASSERT(id == 0);
-		ASSERT(! ip);
-		goto dqret;
-	}
+	if (ip)
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (error)
+		return error;
 
 	/*
 	 * Dquot lock comes after hashlock in the lock ordering
 	 */
 	if (ip) {
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-
 		/*
 		 * A dquot could be attached to this inode by now, since
 		 * we had dropped the ilock.
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-08-31 13:35:48.013379063 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2011-08-31 13:39:19.016711122 +0200
@@ -129,6 +129,8 @@ static inline void xfs_dqunlock_nonotify
 				     (XFS_IS_UQUOTA_ON((d)->q_mount)) : \
 				     (XFS_IS_OQUOTA_ON((d)->q_mount))))
 
+extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
+					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
 extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
 extern void		xfs_qm_dqpurge(xfs_dquot_t *);
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-31 13:35:48.030045730 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-31 13:44:19.213375993 +0200
@@ -859,18 +859,21 @@ xfs_qm_init_quotainfo(
 	/*
 	 * We try to get the limits from the superuser's limits fields.
 	 * This is quite hacky, but it is standard quota practice.
+	 *
 	 * We look at the USR dquot with id == 0 first, but if user quotas
 	 * are not enabled we goto the GRP dquot with id == 0.
 	 * We don't really care to keep separate default limits for user
 	 * and group quotas, at least not at this point.
+	 *
+	 * Since we may not have done a quotacheck by this point, just read
+	 * the dquot without attaching it to any hashtables or lists.
 	 */
-	error = xfs_qm_dqget(mp, NULL, (xfs_dqid_t)0,
-			     XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER : 
-			     (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
-				XFS_DQ_PROJ),
-			     XFS_QMOPT_DQSUSER|XFS_QMOPT_DOWARN,
-			     &dqp);
-	if (! error) {
+	error = xfs_qm_dqread(mp, 0,
+			XFS_IS_UQUOTA_RUNNING(mp) ? XFS_DQ_USER :
+			 (XFS_IS_GQUOTA_RUNNING(mp) ? XFS_DQ_GROUP :
+			  XFS_DQ_PROJ),
+			XFS_QMOPT_DOWARN, &dqp);
+	if (!error) {
 		xfs_disk_dquot_t	*ddqp = &dqp->q_core;
 
 		/*
@@ -897,11 +900,6 @@ xfs_qm_init_quotainfo(
 		qinf->qi_rtbhardlimit = be64_to_cpu(ddqp->d_rtb_hardlimit);
 		qinf->qi_rtbsoftlimit = be64_to_cpu(ddqp->d_rtb_softlimit);
  
-		/*
-		 * We sent the XFS_QMOPT_DQSUSER flag to dqget because
-		 * we don't want this dquot cached. We haven't done a
-		 * quotacheck yet, and quotacheck doesn't like incore dquots.
-		 */
 		xfs_qm_dqdestroy(dqp);
 	} else {
 		qinf->qi_btimelimit = XFS_QM_BTIMELIMIT;
Index: xfs/fs/xfs/xfs_quota.h
===================================================================
--- xfs.orig/fs/xfs/xfs_quota.h	2011-08-31 13:39:37.193377694 +0200
+++ xfs/fs/xfs/xfs_quota.h	2011-08-31 13:40:17.826710784 +0200
@@ -197,7 +197,6 @@ typedef struct xfs_qoff_logformat {
 #define XFS_QMOPT_UQUOTA	0x0000004 /* user dquot requested */
 #define XFS_QMOPT_PQUOTA	0x0000008 /* project dquot requested */
 #define XFS_QMOPT_FORCE_RES	0x0000010 /* ignore quota limits */
-#define XFS_QMOPT_DQSUSER	0x0000020 /* don't cache super users dquot */
 #define XFS_QMOPT_SBVERSION	0x0000040 /* change superblock version num */
 #define XFS_QMOPT_DOWARN        0x0000400 /* increase warning cnt if needed */
 #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
