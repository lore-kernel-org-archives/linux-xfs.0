Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F37337F56
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 17:27:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3896304067
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:27:29 -0700 (PDT)
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159]) by
	cuda.sgi.com with ESMTP id ryWpqZyFM5N2xTCO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 15:27:28 -0700 (PDT)
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Aug 2013 16:27:28 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 244AE3E4003F
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:26:55 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r76MRIB3384212 for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:18 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r76MRI5E011721
	for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:18 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 2/3] xfs: Add support for the Q_XGETQSTATV
Date: Tue,  6 Aug 2013 17:27:08 -0500
Message-Id: <1375828029-26360-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>

For XFS, add support for Q_XGETQSTATV quotactl command.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm.h          |    2 +
 fs/xfs/xfs_qm_syscalls.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_quotaops.c    |   13 +++++++
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 579d6a0..670cd44 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -160,6 +160,8 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct fs_disk_quota *);
 extern int		xfs_qm_scall_getqstat(struct xfs_mount *,
 					struct fs_quota_stat *);
+extern int		xfs_qm_scall_getqstatv(struct xfs_mount *,
+					struct fs_quota_statv *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8d9e4c7..721aabe 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -406,6 +406,7 @@ xfs_qm_scall_quotaon(
 
 /*
  * Return quota status information, such as uquota-off, enforcements, etc.
+ * for Q_XGETQSTAT command.
  */
 int
 xfs_qm_scall_getqstat(
@@ -493,6 +494,87 @@ xfs_qm_scall_getqstat(
 	return 0;
 }
 
+/*
+ * Return quota status information, such as uquota-off, enforcements, etc.
+ * for Q_XGETQSTATV command, to support separate project quota field.
+ */
+int
+xfs_qm_scall_getqstatv(
+	struct xfs_mount	*mp,
+	struct fs_quota_statv	*out)
+{
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	struct xfs_inode	*uip = NULL;
+	struct xfs_inode	*gip = NULL;
+	struct xfs_inode	*pip = NULL;
+	bool                    tempuqip = false;
+	bool                    tempgqip = false;
+	bool                    temppqip = false;
+
+	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
+		out->qs_uquota.qfs_ino = NULLFSINO;
+		out->qs_gquota.qfs_ino = NULLFSINO;
+		out->qs_pquota.qfs_ino = NULLFSINO;
+		return (0);
+	}
+
+	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
+							(XFS_ALL_QUOTA_ACCT|
+							 XFS_ALL_QUOTA_ENFD));
+	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
+	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
+	out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
+
+	if (q) {
+		uip = q->qi_uquotaip;
+		gip = q->qi_gquotaip;
+		pip = q->qi_pquotaip;
+	}
+	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
+					0, 0, &uip) == 0)
+			tempuqip = true;
+	}
+	if (!gip && mp->m_sb.sb_gquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
+					0, 0, &gip) == 0)
+			tempgqip = true;
+	}
+	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
+		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
+					0, 0, &pip) == 0)
+			temppqip = true;
+	}
+	if (uip) {
+		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
+		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
+		if (tempuqip)
+			IRELE(uip);
+	}
+
+	if (gip) {
+		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
+		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
+		if (tempgqip)
+			IRELE(gip);
+	}
+	if (pip) {
+		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
+		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
+		if (temppqip)
+			IRELE(pip);
+	}
+	if (q) {
+		out->qs_incoredqs = q->qi_dquots;
+		out->qs_btimelimit = q->qi_btimelimit;
+		out->qs_itimelimit = q->qi_itimelimit;
+		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+		out->qs_bwarnlimit = q->qi_bwarnlimit;
+		out->qs_iwarnlimit = q->qi_iwarnlimit;
+	}
+	return 0;
+}
+
 #define XFS_DQ_MASK \
 	(FS_DQ_LIMIT_MASK | FS_DQ_TIMER_MASK | FS_DQ_WARNS_MASK)
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 20e30f9..fe945e5 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -54,6 +54,18 @@ xfs_fs_get_xstate(
 }
 
 STATIC int
+xfs_fs_get_xstatev(
+	struct super_block	*sb,
+	struct fs_quota_statv	*fqs)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return -ENOSYS;
+	return -xfs_qm_scall_getqstatv(mp, fqs);
+}
+
+STATIC int
 xfs_fs_set_xstate(
 	struct super_block	*sb,
 	unsigned int		uflags,
@@ -133,6 +145,7 @@ xfs_fs_set_dqblk(
 }
 
 const struct quotactl_ops xfs_quotactl_operations = {
+	.get_xstatev		= xfs_fs_get_xstatev,
 	.get_xstate		= xfs_fs_get_xstate,
 	.set_xstate		= xfs_fs_set_xstate,
 	.get_dqblk		= xfs_fs_get_dqblk,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
