Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12GGWWQ061708 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:16:32 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	nxYkb2z1mpmys6or (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 08:16:31 -0800 (PST)
Message-Id: <20120202161629.084820708@bombadil.infradead.org>
Date: Thu, 02 Feb 2012 11:14:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: merge xfs_qm_export_dquot into xfs_qm_scall_getquota
References: <20120202161409.303465214@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-kill-xfs_qm_export_dquot
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
Cc: jack@suse.cz

The is no good reason to have these two separate, and for the next change
I'd need the full struct xfs_dquot in xfs_qm_export_dquot, so better just
fold the code now instead of changing it around.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2012-02-02 13:11:38.368396372 +0100
+++ xfs/fs/xfs/xfs_qm_syscalls.c	2012-02-02 13:17:04.139964850 +0100
@@ -47,9 +47,6 @@ STATIC int	xfs_qm_log_quotaoff_end(xfs_m
 					uint);
 STATIC uint	xfs_qm_export_flags(uint);
 STATIC uint	xfs_qm_export_qtype_flags(uint);
-STATIC void	xfs_qm_export_dquot(xfs_mount_t *, xfs_disk_dquot_t *,
-					fs_disk_quota_t *);
-
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -635,42 +632,6 @@ xfs_qm_scall_setqlim(
 	return error;
 }
 
-int
-xfs_qm_scall_getquota(
-	xfs_mount_t	*mp,
-	xfs_dqid_t	id,
-	uint		type,
-	fs_disk_quota_t *out)
-{
-	xfs_dquot_t	*dqp;
-	int		error;
-
-	/*
-	 * Try to get the dquot. We don't want it allocated on disk, so
-	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
-	 * exist, we'll get ENOENT back.
-	 */
-	if ((error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp))) {
-		return (error);
-	}
-
-	/*
-	 * If everything's NULL, this dquot doesn't quite exist as far as
-	 * our utility programs are concerned.
-	 */
-	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
-		xfs_qm_dqput(dqp);
-		return XFS_ERROR(ENOENT);
-	}
-	/*
-	 * Convert the disk dquot to the exportable format
-	 */
-	xfs_qm_export_dquot(mp, &dqp->q_core, out);
-	xfs_qm_dqput(dqp);
-	return (error ? XFS_ERROR(EFAULT) : 0);
-}
-
-
 STATIC int
 xfs_qm_log_quotaoff_end(
 	xfs_mount_t		*mp,
@@ -759,50 +720,66 @@ error0:
 }
 
 
-/*
- * Translate an internal style on-disk-dquot to the exportable format.
- * The main differences are that the counters/limits are all in Basic
- * Blocks (BBs) instead of the internal FSBs, and all on-disk data has
- * to be converted to the native endianness.
- */
-STATIC void
-xfs_qm_export_dquot(
-	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*src,
+int
+xfs_qm_scall_getquota(
+	struct xfs_mount	*mp,
+	xfs_dqid_t		id,
+	uint			type,
 	struct fs_disk_quota	*dst)
 {
+	struct xfs_dquot	*dqp;
+	int			error;
+
+	/*
+	 * Try to get the dquot. We don't want it allocated on disk, so
+	 * we aren't passing the XFS_QMOPT_DOALLOC flag. If it doesn't
+	 * exist, we'll get ENOENT back.
+	 */
+	error = xfs_qm_dqget(mp, NULL, id, type, 0, &dqp);
+	if (error)
+		return error;
+
+	/*
+	 * If everything's NULL, this dquot doesn't quite exist as far as
+	 * our utility programs are concerned.
+	 */
+	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
+		error = XFS_ERROR(ENOENT);
+		goto out_put;
+	}
+
 	memset(dst, 0, sizeof(*dst));
-	dst->d_version = FS_DQUOT_VERSION;  /* different from src->d_version */
-	dst->d_flags = xfs_qm_export_qtype_flags(src->d_flags);
-	dst->d_id = be32_to_cpu(src->d_id);
+	dst->d_version = FS_DQUOT_VERSION;
+	dst->d_flags = xfs_qm_export_qtype_flags(dqp->q_core.d_flags);
+	dst->d_id = be32_to_cpu(dqp->q_core.d_id);
 	dst->d_blk_hardlimit =
-		XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_blk_hardlimit));
+		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_blk_hardlimit));
 	dst->d_blk_softlimit =
-		XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_blk_softlimit));
-	dst->d_ino_hardlimit = be64_to_cpu(src->d_ino_hardlimit);
-	dst->d_ino_softlimit = be64_to_cpu(src->d_ino_softlimit);
-	dst->d_bcount = XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_bcount));
-	dst->d_icount = be64_to_cpu(src->d_icount);
-	dst->d_btimer = be32_to_cpu(src->d_btimer);
-	dst->d_itimer = be32_to_cpu(src->d_itimer);
-	dst->d_iwarns = be16_to_cpu(src->d_iwarns);
-	dst->d_bwarns = be16_to_cpu(src->d_bwarns);
+		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
+	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
+	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
+	dst->d_bcount = XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_bcount));
+	dst->d_icount = be64_to_cpu(dqp->q_core.d_icount);
+	dst->d_btimer = be32_to_cpu(dqp->q_core.d_btimer);
+	dst->d_itimer = be32_to_cpu(dqp->q_core.d_itimer);
+	dst->d_iwarns = be16_to_cpu(dqp->q_core.d_iwarns);
+	dst->d_bwarns = be16_to_cpu(dqp->q_core.d_bwarns);
 	dst->d_rtb_hardlimit =
-		XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_rtb_hardlimit));
+		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
 	dst->d_rtb_softlimit =
-		XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_rtb_softlimit));
-	dst->d_rtbcount = XFS_FSB_TO_BB(mp, be64_to_cpu(src->d_rtbcount));
-	dst->d_rtbtimer = be32_to_cpu(src->d_rtbtimer);
-	dst->d_rtbwarns = be16_to_cpu(src->d_rtbwarns);
+		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
+	dst->d_rtbcount = XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtbcount));
+	dst->d_rtbtimer = be32_to_cpu(dqp->q_core.d_rtbtimer);
+	dst->d_rtbwarns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 
 	/*
 	 * Internally, we don't reset all the timers when quota enforcement
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_USER) ||
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && dqp->q_core.d_flags == XFS_DQ_USER) ||
 	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
-			(src->d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
+			(dqp->q_core.d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
 		dst->d_btimer = 0;
 		dst->d_itimer = 0;
 		dst->d_rtbtimer = 0;
@@ -823,6 +800,9 @@ xfs_qm_export_dquot(
 		}
 	}
 #endif
+out_put:
+	xfs_qm_dqput(dqp);
+	return error;
 }
 
 STATIC uint

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
