Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11AAF7F58
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 16:53:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78503AC004
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 14:53:19 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id teEhMbTxdwPpumWg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 14:53:18 -0700 (PDT)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 21 Mar 2013 15:53:17 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id B398C1FF004F
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:48:16 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2LLrCZZ346876 for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:53:12 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2LLrBU7024685
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:53:11 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v7 5/5] xfs: Use the new qs_pquota field in fs_quota_stat for
	Q_XGETQSTAT
Date: Thu, 21 Mar 2013 16:52:54 -0500
Message-Id: <1363902774-19292-6-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
References: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

For the Q_XGETQSTAT quota command, if the new version of fs_quota_stat
data structure is used, fill the project quota information.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm_syscalls.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5b90acc..914513b 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -420,20 +420,14 @@ xfs_qm_scall_getqstat(
 	bool                    tempgqip = false;
 	bool                    temppqip = false;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		out->qs_pquota.qfs_ino = NULLFSINO;
+	out->qs_uquota.qfs_ino = NULLFSINO;
+	out->qs_gquota.qfs_ino = NULLFSINO;
+	out->qs_pquota.qfs_ino = NULLFSINO;
+
+	if (!xfs_sb_version_hasquota(&mp->m_sb))
 		return (0);
-	}
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
-							(XFS_ALL_QUOTA_ACCT|
-							 XFS_ALL_QUOTA_ENFD));
-	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
-	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	if (&out->qs_gquota != &out->qs_pquota)
-		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
-
+				(XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD));
 	if (q) {
 		uip = q->qi_uquotaip;
 		gip = q->qi_gquotaip;
@@ -454,21 +448,38 @@ xfs_qm_scall_getqstat(
 					0, 0, &pip) == 0)
 			temppqip = true;
 	}
+
 	if (uip) {
+		out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
 		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
 		if (tempuqip)
 			IRELE(uip);
 	}
 	if (gip) {
+		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
 		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
 		if (tempgqip)
 			IRELE(gip);
 	}
 	if (pip) {
-		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
-		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+		if (out->qs_version >= FS_QSTAT_VERSION_2) {
+			out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
+			out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+			out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+		} else {
+			/*
+			 * In FS_QSTAT_VERSION version, there is no
+			 * qs_pquota, and there is no combined support
+			 * for gquota/pquota. qs_gquota is shared for
+			 * providing the pquota/gquota information to
+			 * the user space.
+			 */
+			out->qs_gquota.qfs_ino = mp->m_sb.sb_pquotino;
+			out->qs_gquota.qfs_nblks = pip->i_d.di_nblocks;
+			out->qs_gquota.qfs_nextents = pip->i_d.di_nextents;
+		}
 		if (temppqip)
 			IRELE(pip);
 	}
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
