Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YFDc124016 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:15 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA10A1D2641A
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:27 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	9ky3Vb59DAFEHN8m for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:27 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52939874-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:26 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000Uk-HK
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogv-0002GR-2E
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/12] xfs: convert the quota debug prints to new API
Date: Wed, 12 Jan 2011 11:35:51 +1100
Message-Id: <1294792553-8378-11-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/quota/xfs_qm_syscalls.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
index bdebc18..603ab86 100644
--- a/fs/xfs/quota/xfs_qm_syscalls.c
+++ b/fs/xfs/quota/xfs_qm_syscalls.c
@@ -41,12 +41,6 @@
 #include "xfs_qm.h"
 #include "xfs_trace.h"
 
-#ifdef DEBUG
-# define qdprintk(s, args...)	cmn_err(CE_DEBUG, s, ## args)
-#else
-# define qdprintk(s, args...)	do { } while (0)
-#endif
-
 STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
 STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
 					uint);
@@ -294,7 +288,8 @@ xfs_qm_scall_trunc_qfiles(
 	int		error = 0, error2 = 0;
 
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
-		qdprintk("qtrunc flags=%x m_qflags=%x\n", flags, mp->m_qflags);
+		xfs_debug(mp, "%s: flags=%x m_qflags=%x\n",
+			__func__, flags, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
 
@@ -331,7 +326,8 @@ xfs_qm_scall_quotaon(
 	sbflags = 0;
 
 	if (flags == 0) {
-		qdprintk("quotaon: zero flags, m_qflags=%x\n", mp->m_qflags);
+		xfs_debug(mp, "%s: zero flags, m_qflags=%x\n",
+			__func__, mp->m_qflags);
 		return XFS_ERROR(EINVAL);
 	}
 
@@ -352,8 +348,9 @@ xfs_qm_scall_quotaon(
 	    (flags & XFS_GQUOTA_ACCT) == 0 &&
 	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
 	    (flags & XFS_OQUOTA_ENFD))) {
-		qdprintk("Can't enforce without acct, flags=%x sbflags=%x\n",
-			flags, mp->m_sb.sb_qflags);
+		xfs_debug(mp,
+			"%s: Can't enforce without acct, flags=%x sbflags=%x\n",
+			__func__, flags, mp->m_sb.sb_qflags);
 		return XFS_ERROR(EINVAL);
 	}
 	/*
@@ -541,7 +538,7 @@ xfs_qm_scall_setqlim(
 			q->qi_bsoftlimit = soft;
 		}
 	} else {
-		qdprintk("blkhard %Ld < blksoft %Ld\n", hard, soft);
+		xfs_debug(mp, "blkhard %Ld < blksoft %Ld\n", hard, soft);
 	}
 	hard = (newlim->d_fieldmask & FS_DQ_RTBHARD) ?
 		(xfs_qcnt_t) XFS_BB_TO_FSB(mp, newlim->d_rtb_hardlimit) :
@@ -557,7 +554,7 @@ xfs_qm_scall_setqlim(
 			q->qi_rtbsoftlimit = soft;
 		}
 	} else {
-		qdprintk("rtbhard %Ld < rtbsoft %Ld\n", hard, soft);
+		xfs_debug(mp, "rtbhard %Ld < rtbsoft %Ld\n", hard, soft);
 	}
 
 	hard = (newlim->d_fieldmask & FS_DQ_IHARD) ?
@@ -574,7 +571,7 @@ xfs_qm_scall_setqlim(
 			q->qi_isoftlimit = soft;
 		}
 	} else {
-		qdprintk("ihard %Ld < isoft %Ld\n", hard, soft);
+		xfs_debug(mp, "ihard %Ld < isoft %Ld\n", hard, soft);
 	}
 
 	/*
@@ -1137,8 +1134,8 @@ xfs_qm_internalqcheck_adjust(
 
 	if (ino == mp->m_sb.sb_uquotino || ino == mp->m_sb.sb_gquotino) {
 		*res = BULKSTAT_RV_NOTHING;
-		qdprintk("internalqcheck: ino=%llu, uqino=%llu, gqino=%llu\n",
-			(unsigned long long) ino,
+		xfs_debug(mp, "%s: ino=%llu, uqino=%llu, gqino=%llu\n",
+			__func__, (unsigned long long) ino,
 			(unsigned long long) mp->m_sb.sb_uquotino,
 			(unsigned long long) mp->m_sb.sb_gquotino);
 		return XFS_ERROR(EINVAL);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
