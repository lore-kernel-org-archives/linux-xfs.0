Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12GGV4J061702 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:16:32 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	URFKp1tSSRk6a8tT (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Feb 2012 08:16:31 -0800 (PST)
Message-Id: <20120202161629.317451273@bombadil.infradead.org>
Date: Thu, 02 Feb 2012 11:14:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: include reservations in quota reporting
References: <20120202161409.303465214@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-report-delalloc-reservations
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

Report all quota usage including the currently pending reservations.  This
avoids the need to flush delalloc space before gathering quota information,
and matches quota enforcement, which already takes the reservations into
account.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_qm_bhv.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_bhv.c	2012-02-02 15:06:42.624326140 +0100
+++ xfs/fs/xfs/xfs_qm_bhv.c	2012-02-02 15:06:43.077657017 +0100
@@ -40,28 +40,28 @@
 STATIC void
 xfs_fill_statvfs_from_dquot(
 	struct kstatfs		*statp,
-	xfs_disk_dquot_t	*dp)
+	struct xfs_dquot	*dqp)
 {
 	__uint64_t		limit;
 
-	limit = dp->d_blk_softlimit ?
-		be64_to_cpu(dp->d_blk_softlimit) :
-		be64_to_cpu(dp->d_blk_hardlimit);
+	limit = dqp->q_core.d_blk_softlimit ?
+		be64_to_cpu(dqp->q_core.d_blk_softlimit) :
+		be64_to_cpu(dqp->q_core.d_blk_hardlimit);
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > be64_to_cpu(dp->d_bcount)) ?
-			 (statp->f_blocks - be64_to_cpu(dp->d_bcount)) : 0;
+			(statp->f_blocks > dqp->q_res_bcount) ?
+			 (statp->f_blocks - dqp->q_res_bcount) : 0;
 	}
 
-	limit = dp->d_ino_softlimit ?
-		be64_to_cpu(dp->d_ino_softlimit) :
-		be64_to_cpu(dp->d_ino_hardlimit);
+	limit = dqp->q_core.d_ino_softlimit ?
+		be64_to_cpu(dqp->q_core.d_ino_softlimit) :
+		be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 	if (limit && statp->f_files > limit) {
 		statp->f_files = limit;
 		statp->f_ffree =
-			(statp->f_files > be64_to_cpu(dp->d_icount)) ?
-			 (statp->f_ffree - be64_to_cpu(dp->d_icount)) : 0;
+			(statp->f_files > dqp->q_res_icount) ?
+			 (statp->f_ffree - dqp->q_res_icount) : 0;
 	}
 }
 
@@ -82,7 +82,7 @@ xfs_qm_statvfs(
 	xfs_dquot_t		*dqp;
 
 	if (!xfs_qm_dqget(mp, NULL, xfs_get_projid(ip), XFS_DQ_PROJ, 0, &dqp)) {
-		xfs_fill_statvfs_from_dquot(statp, &dqp->q_core);
+		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
 }
Index: xfs/fs/xfs/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm_syscalls.c	2012-02-02 15:06:42.837658317 +0100
+++ xfs/fs/xfs/xfs_qm_syscalls.c	2012-02-02 15:07:31.894059224 +0100
@@ -758,8 +758,8 @@ xfs_qm_scall_getquota(
 		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
 	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
-	dst->d_bcount = XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_bcount));
-	dst->d_icount = be64_to_cpu(dqp->q_core.d_icount);
+	dst->d_bcount = XFS_FSB_TO_BB(mp, dqp->q_res_bcount);
+	dst->d_icount = dqp->q_res_icount;
 	dst->d_btimer = be32_to_cpu(dqp->q_core.d_btimer);
 	dst->d_itimer = be32_to_cpu(dqp->q_core.d_itimer);
 	dst->d_iwarns = be16_to_cpu(dqp->q_core.d_iwarns);
@@ -768,7 +768,7 @@ xfs_qm_scall_getquota(
 		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
 	dst->d_rtb_softlimit =
 		XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
-	dst->d_rtbcount = XFS_FSB_TO_BB(mp, be64_to_cpu(dqp->q_core.d_rtbcount));
+	dst->d_rtbcount = XFS_FSB_TO_BB(mp, dqp->q_res_rtbcount);
 	dst->d_rtbtimer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 	dst->d_rtbwarns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
