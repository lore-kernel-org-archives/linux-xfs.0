Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D8417F55
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:15:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADD2AAC005
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:15:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id cSBIhibZCQo0PXDV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 07:15:22 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/8] quota: Wire up Q_GETXSTATE and Q_GETXSTATV calls to work
	with ->get_state
Date: Wed,  4 Mar 2015 16:15:07 +0100
Message-Id: <1425482113-1977-3-git-send-email-jack@suse.cz>
In-Reply-To: <1425482113-1977-1-git-send-email-jack@suse.cz>
References: <1425482113-1977-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Add appropriate conversion functions so that filesystems supporting
->get_state() method can be queried using Q_GETXSTATE and Q_GETXSTATV
calls.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 138 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 134 insertions(+), 4 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 00d50fca1005..83939ff4c444 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -269,25 +269,152 @@ static int quota_disable(struct super_block *sb, void __user *addr)
 	return sb->s_qcop->quota_disable(sb, flags);
 }
 
+static int quota_state_to_flags(struct qc_state *state)
+{
+	int flags = 0;
+
+	if (state->s_state[USRQUOTA].flags & QCI_ACCT_ENABLED)
+		flags |= FS_QUOTA_UDQ_ACCT;
+	if (state->s_state[USRQUOTA].flags & QCI_LIMITS_ENFORCED)
+		flags |= FS_QUOTA_UDQ_ENFD;
+	if (state->s_state[GRPQUOTA].flags & QCI_ACCT_ENABLED)
+		flags |= FS_QUOTA_GDQ_ACCT;
+	if (state->s_state[GRPQUOTA].flags & QCI_LIMITS_ENFORCED)
+		flags |= FS_QUOTA_GDQ_ENFD;
+	if (state->s_state[PRJQUOTA].flags & QCI_ACCT_ENABLED)
+		flags |= FS_QUOTA_PDQ_ACCT;
+	if (state->s_state[PRJQUOTA].flags & QCI_LIMITS_ENFORCED)
+		flags |= FS_QUOTA_PDQ_ENFD;
+	return flags;
+}
+
+static int quota_getstate(struct super_block *sb, struct fs_quota_stat *fqs)
+{
+	int type;
+	struct qc_state state;
+	int ret;
+
+	ret = sb->s_qcop->get_state(sb, &state);
+	if (ret < 0)
+		return ret;
+
+	memset(fqs, 0, sizeof(*fqs));
+	fqs->qs_version = FS_QSTAT_VERSION;
+	fqs->qs_flags = quota_state_to_flags(&state);
+	/* No quota enabled? */
+	if (!fqs->qs_flags)
+		return -ENOSYS;
+	fqs->qs_incoredqs = state.s_incoredqs;
+	/*
+	 * GETXSTATE quotactl has space for just one set of time limits so
+	 * report them for the first enabled quota type
+	 */
+	for (type = 0; type < XQM_MAXQUOTAS; type++)
+		if (state.s_state[type].flags & QCI_ACCT_ENABLED)
+			break;
+	BUG_ON(type == XQM_MAXQUOTAS);
+	fqs->qs_btimelimit = state.s_state[type].spc_timelimit;
+	fqs->qs_itimelimit = state.s_state[type].ino_timelimit;
+	fqs->qs_rtbtimelimit = state.s_state[type].rt_spc_timelimit;
+	fqs->qs_bwarnlimit = state.s_state[type].spc_warnlimit;
+	fqs->qs_iwarnlimit = state.s_state[type].ino_warnlimit;
+	if (state.s_state[USRQUOTA].flags & QCI_ACCT_ENABLED) {
+		fqs->qs_uquota.qfs_ino = state.s_state[USRQUOTA].ino;
+		fqs->qs_uquota.qfs_nblks = state.s_state[USRQUOTA].blocks;
+		fqs->qs_uquota.qfs_nextents = state.s_state[USRQUOTA].nextents;
+	}
+	if (state.s_state[GRPQUOTA].flags & QCI_ACCT_ENABLED) {
+		fqs->qs_gquota.qfs_ino = state.s_state[GRPQUOTA].ino;
+		fqs->qs_gquota.qfs_nblks = state.s_state[GRPQUOTA].blocks;
+		fqs->qs_gquota.qfs_nextents = state.s_state[GRPQUOTA].nextents;
+	}
+	if (state.s_state[PRJQUOTA].flags & QCI_ACCT_ENABLED) {
+		/*
+		 * Q_XGETQSTAT doesn't have room for both group and project
+		 * quotas.  So, allow the project quota values to be copied out
+		 * only if there is no group quota information available.
+		 */
+		if (!(state.s_state[GRPQUOTA].flags & QCI_ACCT_ENABLED)) {
+			fqs->qs_gquota.qfs_ino = state.s_state[PRJQUOTA].ino;
+			fqs->qs_gquota.qfs_nblks =
+					state.s_state[PRJQUOTA].blocks;
+			fqs->qs_gquota.qfs_nextents =
+					state.s_state[PRJQUOTA].nextents;
+		}
+	}
+	return 0;
+}
+
 static int quota_getxstate(struct super_block *sb, void __user *addr)
 {
 	struct fs_quota_stat fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstate)
+	if (!sb->s_qcop->get_xstate && !sb->s_qcop->get_state)
 		return -ENOSYS;
-	ret = sb->s_qcop->get_xstate(sb, &fqs);
+	if (sb->s_qcop->get_state)
+		ret = quota_getstate(sb, &fqs);
+	else
+		ret = sb->s_qcop->get_xstate(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
 }
 
+static int quota_getstatev(struct super_block *sb, struct fs_quota_statv *fqs)
+{
+	int type;
+	struct qc_state state;
+	int ret;
+
+	ret = sb->s_qcop->get_state(sb, &state);
+	if (ret < 0)
+		return ret;
+
+	memset(fqs, 0, sizeof(*fqs));
+	fqs->qs_version = FS_QSTAT_VERSION;
+	fqs->qs_flags = quota_state_to_flags(&state);
+	/* No quota enabled? */
+	if (!fqs->qs_flags)
+		return -ENOSYS;
+	fqs->qs_incoredqs = state.s_incoredqs;
+	/*
+	 * GETXSTATV quotactl has space for just one set of time limits so
+	 * report them for the first enabled quota type
+	 */
+	for (type = 0; type < XQM_MAXQUOTAS; type++)
+		if (state.s_state[type].flags & QCI_ACCT_ENABLED)
+			break;
+	BUG_ON(type == XQM_MAXQUOTAS);
+	fqs->qs_btimelimit = state.s_state[type].spc_timelimit;
+	fqs->qs_itimelimit = state.s_state[type].ino_timelimit;
+	fqs->qs_rtbtimelimit = state.s_state[type].rt_spc_timelimit;
+	fqs->qs_bwarnlimit = state.s_state[type].spc_warnlimit;
+	fqs->qs_iwarnlimit = state.s_state[type].ino_warnlimit;
+	if (state.s_state[USRQUOTA].flags & QCI_ACCT_ENABLED) {
+		fqs->qs_uquota.qfs_ino = state.s_state[USRQUOTA].ino;
+		fqs->qs_uquota.qfs_nblks = state.s_state[USRQUOTA].blocks;
+		fqs->qs_uquota.qfs_nextents = state.s_state[USRQUOTA].nextents;
+	}
+	if (state.s_state[GRPQUOTA].flags & QCI_ACCT_ENABLED) {
+		fqs->qs_gquota.qfs_ino = state.s_state[GRPQUOTA].ino;
+		fqs->qs_gquota.qfs_nblks = state.s_state[GRPQUOTA].blocks;
+		fqs->qs_gquota.qfs_nextents = state.s_state[GRPQUOTA].nextents;
+	}
+	if (state.s_state[PRJQUOTA].flags & QCI_ACCT_ENABLED) {
+		fqs->qs_pquota.qfs_ino = state.s_state[PRJQUOTA].ino;
+		fqs->qs_pquota.qfs_nblks = state.s_state[PRJQUOTA].blocks;
+		fqs->qs_pquota.qfs_nextents = state.s_state[PRJQUOTA].nextents;
+	}
+	return 0;
+}
+
 static int quota_getxstatev(struct super_block *sb, void __user *addr)
 {
 	struct fs_quota_statv fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstatev)
+	if (!sb->s_qcop->get_xstatev && !sb->s_qcop->get_state)
 		return -ENOSYS;
 
 	memset(&fqs, 0, sizeof(fqs));
@@ -301,7 +428,10 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	default:
 		return -EINVAL;
 	}
-	ret = sb->s_qcop->get_xstatev(sb, &fqs);
+	if (sb->s_qcop->get_state)
+		ret = quota_getstatev(sb, &fqs);
+	else
+		ret = sb->s_qcop->get_xstatev(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
