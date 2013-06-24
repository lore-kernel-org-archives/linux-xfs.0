Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BCE3A7F51
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 21:48:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CC0E8F8035
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:48:44 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id fGHZwKUpjDMsZ9Is (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 19:48:43 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Sun, 23 Jun 2013 20:48:42 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 2AA163E4003F
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:21 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5O2meIY160590 for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:40 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5O2md5j008911
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:48:39 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v9 6/6] xfs: Use new qs_pquota field in fs_quota_stat for
	Q_XGETQSTAT
Date: Sun, 23 Jun 2013 21:48:27 -0500
Message-Id: <1372042107-27332-7-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
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
index 1918f48..8711f37 100644
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
