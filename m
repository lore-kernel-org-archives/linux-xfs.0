Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EE3EB7F88
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6F08304053
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:51 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id MRu1EGPUI7vYaRyA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:51 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:50 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 9A3AD3E4003F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:28 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPmHr143732 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:48 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPlk4020113
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:47 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 11/11] xfs: Use new qs_pquota field in fs_quota_stat for
	Q_XGETQSTAT
Date: Thu, 27 Jun 2013 17:25:14 -0500
Message-Id: <1372371914-11370-12-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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
 fs/xfs/xfs_qm_syscalls.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1900022..844423a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -406,6 +406,14 @@ xfs_qm_scall_quotaon(
 
 /*
  * Return quota status information, such as uquota-off, enforcements, etc.
+ *
+ * We support two different versions of the fs_quota_stat structure
+ * here. If the version is FS_QSTAT_VERSION, then there is no
+ * separate project quota fields, and so we write project quota
+ * information into the group quota fields. With FS_QSTAT_VERSION_2,
+ * there is a separate project quota field so we can use that
+ * instead to pass both group and project quota back to user space.
+ *
  */
 int
 xfs_qm_scall_getqstat(
@@ -420,19 +428,15 @@ xfs_qm_scall_getqstat(
 	bool                    tempgqip = false;
 	bool                    temppqip = false;
 
-	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
-		out->qs_uquota.qfs_ino = NULLFSINO;
-		out->qs_gquota.qfs_ino = NULLFSINO;
-		out->qs_pquota.qfs_ino = NULLFSINO;
-		return (0);
-	}
+	out->qs_uquota.qfs_ino = NULLFSINO;
+	out->qs_gquota.qfs_ino = NULLFSINO;
+	out->qs_pquota.qfs_ino = NULLFSINO;
+	if (!xfs_sb_version_hasquota(&mp->m_sb))
+		return 0;
+
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
 							(XFS_ALL_QUOTA_ACCT|
 							 XFS_ALL_QUOTA_ENFD));
-	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
-	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	if (&out->qs_gquota != &out->qs_pquota)
-		out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
 
 	if (q) {
 		uip = q->qi_uquotaip;
@@ -454,21 +458,31 @@ xfs_qm_scall_getqstat(
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
