Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KN3dSh165416 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 18:03:40 -0500
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id WHeS4Wr6MBvr5byA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Jul 2012 16:03:38 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 20 Jul 2012 19:03:36 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 375676E8039
	for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:03:34 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q6KN3Ysi290458 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 19:03:34 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q6L4Y9kr018314 for <xfs@oss.sgi.com>; Sat, 21 Jul 2012 00:34:10 -0400
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 20 Jul 2012 18:03:05 -0500
Message-Id: <20120720230305.20477.41556.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120720230202.20477.69766.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v6 PATCH 5/5] xfs: Add a new field to fs_quota_stat to get
	pquota information
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Use separate structure for filling the project quota information
for the Q_XGETQSTAT quota command.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm_syscalls.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index f011cf3..482efc0 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -421,7 +421,6 @@ xfs_qm_scall_getqstat(
 	tempuqip = tempgqip = temppqip = B_FALSE;
 	memset(out, 0, sizeof(fs_quota_stat_t));
 
-	out->qs_version = FS_QSTAT_VERSION;
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
@@ -434,8 +433,6 @@ xfs_qm_scall_getqstat(
 	out->qs_pad = 0;
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	if (&out->qs_gquota != &out->qs_pquota)
-		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
@@ -452,11 +449,6 @@ xfs_qm_scall_getqstat(
 					0, 0, &gip) == 0)
 			tempgqip = B_TRUE;
 	}
-	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					0, 0, &pip) == 0)
-			temppqip = B_TRUE;
-	}
 	if (uip) {
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
@@ -469,11 +461,19 @@ xfs_qm_scall_getqstat(
 		if (tempgqip)
 			IRELE(gip);
 	}
-	if (pip) {
-		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
-		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
-		if (temppqip)
-			IRELE(pip);
+	if (out->qs_version >= FS_QSTAT_VERSION_2) {
+		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
+		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+						0, 0, &pip) == 0)
+				temppqip = B_TRUE;
+		}
+		if (pip) {
+			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+			if (temppqip)
+				IRELE(pip);
+		}
 	}
 	if (q) {
 		out->qs_incoredqs = q->qi_dquots;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
