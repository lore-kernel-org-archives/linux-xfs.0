Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 793427F8B
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A553304082
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:38:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id sNTl5gATBGN3oBVw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:38:03 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 20/25] xfs: Convert to using ->get_state callback
Date: Thu, 18 Dec 2014 16:37:34 +0100
Message-Id: <1418917059-23870-21-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Convert xfs to use ->get_state callback instead of ->get_xstate and
->get_xstatev.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm.h          |   6 +-
 fs/xfs/xfs_qm_syscalls.c | 219 ++++++++++++-----------------------------------
 fs/xfs/xfs_quotaops.c    |  26 +-----
 3 files changed, 58 insertions(+), 193 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 41f6c0b9d51c..f40506f20bd5 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -169,10 +169,8 @@ extern int		xfs_qm_scall_getquota(struct xfs_mount *, xfs_dqid_t,
 					uint, struct qc_dqblk *);
 extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
-extern int		xfs_qm_scall_getqstat(struct xfs_mount *,
-					struct fs_quota_stat *);
-extern int		xfs_qm_scall_getqstatv(struct xfs_mount *,
-					struct fs_quota_statv *);
+extern int		xfs_qm_scall_getstate(struct xfs_mount *,
+					struct qc_state *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8cb5090dcdbc..b3429a5dfc7b 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -38,7 +38,6 @@
 STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
 STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
 					uint);
-STATIC uint	xfs_qm_export_flags(uint);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -389,156 +388,66 @@ xfs_qm_scall_quotaon(
 	return 0;
 }
 
-
-/*
- * Return quota status information, such as uquota-off, enforcements, etc.
- * for Q_XGETQSTAT command.
- */
-int
-xfs_qm_scall_getqstat(
-	struct xfs_mount	*mp,
-	struct fs_quota_stat	*out)
+static void xfs_qm_fill_state(struct qc_type_state *tstate,
+			      struct xfs_mount *mp,
+			      struct xfs_inode *ip,
+			      xfs_ino_t ino)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_inode	*uip = NULL;
-	struct xfs_inode	*gip = NULL;
-	struct xfs_inode	*pip = NULL;
-	bool                    tempuqip = false;
-	bool                    tempgqip = false;
-	bool                    temppqip = false;
-
-	memset(out, 0, sizeof(fs_quota_stat_t));
-
-	out->qs_version = FS_QSTAT_VERSION;
-	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
-							(XFS_ALL_QUOTA_ACCT|
-							 XFS_ALL_QUOTA_ENFD));
-	uip = q->qi_uquotaip;
-	gip = q->qi_gquotaip;
-	pip = q->qi_pquotaip;
-	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					0, 0, &uip) == 0)
-			tempuqip = true;
-	}
-	if (!gip && mp->m_sb.sb_gquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					0, 0, &gip) == 0)
-			tempgqip = true;
-	}
-	/*
-	 * Q_XGETQSTAT doesn't have room for both group and project quotas.
-	 * So, allow the project quota values to be copied out only if
-	 * there is no group quota information available.
-	 */
-	if (!gip) {
-		if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
-			if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-						0, 0, &pip) == 0)
-				temppqip = true;
-		}
-	} else
-		pip = NULL;
-	if (uip) {
-		out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
-		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
-		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
-		if (tempuqip)
-			IRELE(uip);
-	}
-
-	if (gip) {
-		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
-		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
-		if (tempgqip)
-			IRELE(gip);
-	}
-	if (pip) {
-		out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-		out->qs_gquota.qfs_nblks = pip->i_d.di_nblocks;
-		out->qs_gquota.qfs_nextents = pip->i_d.di_nextents;
-		if (temppqip)
-			IRELE(pip);
-	}
-	out->qs_incoredqs = q->qi_dquots;
-	out->qs_btimelimit = q->qi_btimelimit;
-	out->qs_itimelimit = q->qi_itimelimit;
-	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-	out->qs_bwarnlimit = q->qi_bwarnlimit;
-	out->qs_iwarnlimit = q->qi_iwarnlimit;
-
-	return 0;
+	struct xfs_quotainfo *q = mp->m_quotainfo;
+	bool tempqip = false;
+
+	tstate->ino = ino;
+	if (!ip && ino == NULLFSINO)
+		return;
+	if (!ip) {
+		if (xfs_iget(mp, NULL, ino, 0, 0, &ip))
+			return;
+		tempqip = true;
+	}
+	tstate->flags |= QCI_SYSFILE;
+	tstate->blocks = ip->i_d.di_nblocks;
+	tstate->nextents = ip->i_d.di_nextents;
+	tstate->spc_timelimit = q->qi_btimelimit;
+	tstate->ino_timelimit = q->qi_itimelimit;
+	tstate->rt_spc_timelimit = q->qi_rtbtimelimit;
+	tstate->spc_warnlimit = q->qi_bwarnlimit;
+	tstate->ino_warnlimit = q->qi_iwarnlimit;
+	tstate->rt_spc_warnlimit = q->qi_rtbwarnlimit;
+	if (tempqip)
+		IRELE(ip);
 }
 
 /*
- * Return quota status information, such as uquota-off, enforcements, etc.
- * for Q_XGETQSTATV command, to support separate project quota field.
+ * Return quota status information, such as enforcements, quota file inode
+ * numbers etc.
  */
-int
-xfs_qm_scall_getqstatv(
-	struct xfs_mount	*mp,
-	struct fs_quota_statv	*out)
+int xfs_qm_scall_getstate(struct xfs_mount *mp, struct qc_state *state)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	struct xfs_inode	*uip = NULL;
-	struct xfs_inode	*gip = NULL;
-	struct xfs_inode	*pip = NULL;
-	bool                    tempuqip = false;
-	bool                    tempgqip = false;
-	bool                    temppqip = false;
-
-	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
-							(XFS_ALL_QUOTA_ACCT|
-							 XFS_ALL_QUOTA_ENFD));
-	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
-	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
-	out->qs_pquota.qfs_ino = mp->m_sb.sb_pquotino;
-
-	uip = q->qi_uquotaip;
-	gip = q->qi_gquotaip;
-	pip = q->qi_pquotaip;
-	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					0, 0, &uip) == 0)
-			tempuqip = true;
-	}
-	if (!gip && mp->m_sb.sb_gquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					0, 0, &gip) == 0)
-			tempgqip = true;
-	}
-	if (!pip && mp->m_sb.sb_pquotino != NULLFSINO) {
-		if (xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					0, 0, &pip) == 0)
-			temppqip = true;
-	}
-	if (uip) {
-		out->qs_uquota.qfs_nblks = uip->i_d.di_nblocks;
-		out->qs_uquota.qfs_nextents = uip->i_d.di_nextents;
-		if (tempuqip)
-			IRELE(uip);
-	}
-
-	if (gip) {
-		out->qs_gquota.qfs_nblks = gip->i_d.di_nblocks;
-		out->qs_gquota.qfs_nextents = gip->i_d.di_nextents;
-		if (tempgqip)
-			IRELE(gip);
-	}
-	if (pip) {
-		out->qs_pquota.qfs_nblks = pip->i_d.di_nblocks;
-		out->qs_pquota.qfs_nextents = pip->i_d.di_nextents;
-		if (temppqip)
-			IRELE(pip);
-	}
-	out->qs_incoredqs = q->qi_dquots;
-	out->qs_btimelimit = q->qi_btimelimit;
-	out->qs_itimelimit = q->qi_itimelimit;
-	out->qs_rtbtimelimit = q->qi_rtbtimelimit;
-	out->qs_bwarnlimit = q->qi_bwarnlimit;
-	out->qs_iwarnlimit = q->qi_iwarnlimit;
+	struct xfs_quotainfo *q = mp->m_quotainfo;
 
+	memset(state, 0, sizeof(*state));
+	if (!XFS_IS_QUOTA_RUNNING(mp))
+		return 0;
+	state->s_incoredqs = q->qi_dquots;
+	if (XFS_IS_UQUOTA_RUNNING(mp))
+		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
+	if (XFS_IS_UQUOTA_ENFORCED(mp))
+		state->s_state[USRQUOTA].flags |= QCI_LIMITS_ENFORCED;
+	if (XFS_IS_GQUOTA_RUNNING(mp))
+		state->s_state[GRPQUOTA].flags |= QCI_ACCT_ENABLED;
+	if (XFS_IS_GQUOTA_ENFORCED(mp))
+		state->s_state[GRPQUOTA].flags |= QCI_LIMITS_ENFORCED;
+	if (XFS_IS_PQUOTA_RUNNING(mp))
+		state->s_state[PRJQUOTA].flags |= QCI_ACCT_ENABLED;
+	if (XFS_IS_PQUOTA_ENFORCED(mp))
+		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
+
+	xfs_qm_fill_state(&state->s_state[USRQUOTA], mp, q->qi_uquotaip,
+			  mp->m_sb.sb_uquotino);
+	xfs_qm_fill_state(&state->s_state[GRPQUOTA], mp, q->qi_gquotaip,
+			  mp->m_sb.sb_gquotino);
+	xfs_qm_fill_state(&state->s_state[PRJQUOTA], mp, q->qi_pquotaip,
+			  mp->m_sb.sb_pquotino);
 	return 0;
 }
 
@@ -873,28 +782,6 @@ out_put:
 	return error;
 }
 
-STATIC uint
-xfs_qm_export_flags(
-	uint flags)
-{
-	uint uflags;
-
-	uflags = 0;
-	if (flags & XFS_UQUOTA_ACCT)
-		uflags |= FS_QUOTA_UDQ_ACCT;
-	if (flags & XFS_GQUOTA_ACCT)
-		uflags |= FS_QUOTA_GDQ_ACCT;
-	if (flags & XFS_PQUOTA_ACCT)
-		uflags |= FS_QUOTA_PDQ_ACCT;
-	if (flags & XFS_UQUOTA_ENFD)
-		uflags |= FS_QUOTA_UDQ_ENFD;
-	if (flags & XFS_GQUOTA_ENFD)
-		uflags |= FS_QUOTA_GDQ_ENFD;
-	if (flags & XFS_PQUOTA_ENFD)
-		uflags |= FS_QUOTA_PDQ_ENFD;
-	return uflags;
-}
-
 
 STATIC int
 xfs_dqrele_inode(
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 35f4d968e5aa..698e6faac519 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -40,28 +40,9 @@ xfs_quota_type(int type)
 	}
 }
 
-STATIC int
-xfs_fs_get_xstate(
-	struct super_block	*sb,
-	struct fs_quota_stat	*fqs)
+static int xfs_fs_get_quota_state(struct super_block *sb, struct qc_state *s)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	return xfs_qm_scall_getqstat(mp, fqs);
-}
-
-STATIC int
-xfs_fs_get_xstatev(
-	struct super_block	*sb,
-	struct fs_quota_statv	*fqs)
-{
-	struct xfs_mount	*mp = XFS_M(sb);
-
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
-	return xfs_qm_scall_getqstatv(mp, fqs);
+	return xfs_qm_scall_getstate(XFS_M(sb), s);
 }
 
 static unsigned int xfs_quota_flags(unsigned int uflags)
@@ -177,8 +158,7 @@ xfs_fs_set_dqblk(
 }
 
 const struct quotactl_ops xfs_quotactl_operations = {
-	.get_xstatev		= xfs_fs_get_xstatev,
-	.get_xstate		= xfs_fs_get_xstate,
+	.get_state		= xfs_fs_get_quota_state,
 	.quota_enable		= xfs_quota_enable,
 	.quota_disable		= xfs_quota_disable,
 	.rm_xquota		= xfs_fs_rm_xquota,
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
