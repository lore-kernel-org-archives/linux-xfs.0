Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 651607F58
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 04:18:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27F0B8F8035
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2015 02:18:22 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id YtklD8VD7bM4Yw1Q (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Jan 2015 02:18:20 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] xfs: Remove some pointless quota checks
Date: Thu, 15 Jan 2015 11:18:05 +0100
Message-Id: <1421317085-14350-4-git-send-email-jack@suse.cz>
In-Reply-To: <1421317085-14350-1-git-send-email-jack@suse.cz>
References: <1421317085-14350-1-git-send-email-jack@suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>

xfs_fs_get_xstate() and xfs_fs_get_xstatev() check whether there's quota
running before calling xfs_qm_scall_getqstat() or
xfs_qm_scall_getqstatv(). Thus we are certain that superblock supports
quota and xfs_sb_version_hasquota() check is pointless. Similarly we
know that when quota is running, mp->m_quotainfo will be allocated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 59 ++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index a8c673dbff32..784c41b3ad84 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -411,20 +411,12 @@ xfs_qm_scall_getqstat(
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
 	out->qs_version = FS_QSTAT_VERSION;
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		return 0;
-	}
-
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
-	if (q) {
-		uip = q->qi_uquotaip;
-		gip = q->qi_gquotaip;
-		pip = q->qi_pquotaip;
-	}
+	uip = q->qi_uquotaip;
+	gip = q->qi_gquotaip;
+	pip = q->qi_pquotaip;
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
 					0, 0, &uip) == 0)
@@ -470,14 +462,13 @@ xfs_qm_scall_getqstat(
 		if (temppqip)
 			IRELE(pip);
 	}
-	if (q) {
-		out->qs_incoredqs = q->qi_dquots;
-		out->qs_btimelimit = q->qi_btimelimit;
-		out->qs_itimelimit = q->qi_itimelimit;
-		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-		out->qs_bwarnlimit = q->qi_bwarnlimit;
-		out->qs_iwarnlimit = q->qi_iwarnlimit;
-	}
+	out->qs_incoredqs = q->qi_dquots;
+	out->qs_btimelimit = q->qi_btimelimit;
+	out->qs_itimelimit = q->qi_itimelimit;
+	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+	out->qs_bwarnlimit = q->qi_bwarnlimit;
+	out->qs_iwarnlimit = q->qi_iwarnlimit;
+
 	return 0;
 }
 
@@ -498,13 +489,6 @@ xfs_qm_scall_getqstatv(
 	bool                    tempgqip = false;
 	bool                    temppqip = false;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		out->qs_pquota.qfs_ino = NULLFSINO;
-		return 0;
-	}
-
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
@@ -512,11 +496,9 @@ xfs_qm_scall_getqstatv(
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 	out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
-	if (q) {
-		uip = q->qi_uquotaip;
-		gip = q->qi_gquotaip;
-		pip = q->qi_pquotaip;
-	}
+	uip = q->qi_uquotaip;
+	gip = q->qi_gquotaip;
+	pip = q->qi_pquotaip;
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
 					0, 0, &uip) == 0)
@@ -551,14 +533,13 @@ xfs_qm_scall_getqstatv(
 		if (temppqip)
 			IRELE(pip);
 	}
-	if (q) {
-		out->qs_incoredqs = q->qi_dquots;
-		out->qs_btimelimit = q->qi_btimelimit;
-		out->qs_itimelimit = q->qi_itimelimit;
-		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-		out->qs_bwarnlimit = q->qi_bwarnlimit;
-		out->qs_iwarnlimit = q->qi_iwarnlimit;
-	}
+	out->qs_incoredqs = q->qi_dquots;
+	out->qs_btimelimit = q->qi_btimelimit;
+	out->qs_itimelimit = q->qi_itimelimit;
+	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+	out->qs_bwarnlimit = q->qi_bwarnlimit;
+	out->qs_iwarnlimit = q->qi_iwarnlimit;
+
 	return 0;
 }
 
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
