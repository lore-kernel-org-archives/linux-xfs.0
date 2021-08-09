Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 566F9C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 07:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310A260F4B
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 07:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbhHIHDP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 03:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhHIHDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 03:03:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09233C0613CF
        for <linux-xfs@vger.kernel.org>; Mon,  9 Aug 2021 00:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=f/w3z+Exg7HoAV7MLCcnRh3v8+STRjOwqvpX6zXe6zE=; b=N7SKrzMtDvYDJ3bhV/f4/x6j2d
        WmttF+U5ksFmqVuoTXl4zVUpS30gldvJyidHmb3ALGsfnmbhbLgGnCKTlCqGMgUUg94JZqKfhx4Nb
        Wca8EdIjkPL9rQDh4ptvvzbppjgb4o05yL/BkBVys7QDIRuY6vahpxjN9D/zaSOqu4Rp2peS1MeZd
        K6ZCNbUgETYkdL8U0hlQpSxQteGoiSVbbjLJ2V6HeGcso3gLHhEdIIgw5vfaAoSuQ5V3iocbQH7lQ
        rouBg8d0K2wvGjYyj8qygZjNLPigNlH7+ab3Aa44MgeR9VpHX6iIjjlcJlVolbJYoo0qH+lt0Fotw
        5T9vQxmg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCzIc-00AjhW-AK; Mon, 09 Aug 2021 07:02:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 4/4] xfs: remove the active vs running quota differentiation
Date:   Mon,  9 Aug 2021 08:59:38 +0200
Message-Id: <20210809065938.1199181-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809065938.1199181-1-hch@lst.de>
References: <20210809065938.1199181-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These only made a difference when quotaoff supported disabling quota
accounting on a mounted file system, so we can switch everyone to use
a single set of flags and helpers now. Note that the *QUOTA_ON naming
for the helpers is kept as it was the much more commonly used one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_quota_defs.h | 30 +++-----------------
 fs/xfs/scrub/quota.c           |  2 +-
 fs/xfs/xfs_dquot.c             |  3 --
 fs/xfs/xfs_ioctl.c             |  2 +-
 fs/xfs/xfs_iops.c              |  4 +--
 fs/xfs/xfs_mount.c             |  4 +--
 fs/xfs/xfs_qm.c                | 26 ++++++++---------
 fs/xfs/xfs_qm_syscalls.c       |  2 +-
 fs/xfs/xfs_quotaops.c          | 30 +++++++-------------
 fs/xfs/xfs_super.c             | 51 ++++++++++++++--------------------
 fs/xfs/xfs_trans_dquot.c       | 11 ++++----
 11 files changed, 58 insertions(+), 107 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 0f0af4e3503293..a02c5062f9b292 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -60,36 +60,14 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQUOT_LOGRES(mp)	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
-#define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
-#define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
-#define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
-#define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
+#define XFS_IS_UQUOTA_ON(mp)		((mp)->m_qflags & XFS_UQUOTA_ACCT)
+#define XFS_IS_PQUOTA_ON(mp)		((mp)->m_qflags & XFS_PQUOTA_ACCT)
+#define XFS_IS_GQUOTA_ON(mp)		((mp)->m_qflags & XFS_GQUOTA_ACCT)
 #define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
 #define XFS_IS_GQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_GQUOTA_ENFD)
 #define XFS_IS_PQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_PQUOTA_ENFD)
 
-/*
- * Incore only flags for quotaoff - these bits get cleared when quota(s)
- * are in the process of getting turned off. These flags are in m_qflags but
- * never in sb_qflags.
- */
-#define XFS_UQUOTA_ACTIVE	0x1000  /* uquotas are being turned off */
-#define XFS_GQUOTA_ACTIVE	0x2000  /* gquotas are being turned off */
-#define XFS_PQUOTA_ACTIVE	0x4000  /* pquotas are being turned off */
-#define XFS_ALL_QUOTA_ACTIVE	\
-	(XFS_UQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE)
-
-/*
- * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
- * quota will be not be switched off as long as that inode lock is held.
- */
-#define XFS_IS_QUOTA_ON(mp)	((mp)->m_qflags & (XFS_UQUOTA_ACTIVE | \
-						   XFS_GQUOTA_ACTIVE | \
-						   XFS_PQUOTA_ACTIVE))
-#define XFS_IS_UQUOTA_ON(mp)	((mp)->m_qflags & XFS_UQUOTA_ACTIVE)
-#define XFS_IS_GQUOTA_ON(mp)	((mp)->m_qflags & XFS_GQUOTA_ACTIVE)
-#define XFS_IS_PQUOTA_ON(mp)	((mp)->m_qflags & XFS_PQUOTA_ACTIVE)
-
 /*
  * Flags to tell various functions what to do. Not all of these are meaningful
  * to a single function. None of these XFS_QMOPT_* flags are meant to have
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index acbb9839d42fbd..3cccd6d5b57755 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -42,7 +42,7 @@ xchk_setup_quota(
 	xfs_dqtype_t		dqtype;
 	int			error;
 
-	if (!XFS_IS_QUOTA_RUNNING(sc->mp) || !XFS_IS_QUOTA_ON(sc->mp))
+	if (!XFS_IS_QUOTA_ON(sc->mp))
 		return -ENOENT;
 
 	dqtype = xchk_quota_to_dqtype(sc);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ecd5059d6928f7..c301b18b7685b1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -847,9 +847,6 @@ xfs_qm_dqget_checks(
 	struct xfs_mount	*mp,
 	xfs_dqtype_t		type)
 {
-	if (WARN_ON_ONCE(!XFS_IS_QUOTA_RUNNING(mp)))
-		return -ESRCH;
-
 	switch (type) {
 	case XFS_DQTYPE_USER:
 		if (!XFS_IS_UQUOTA_ON(mp))
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 16039ea10ac99c..e2d995502cd81b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1450,7 +1450,7 @@ xfs_fileattr_set(
 
 	/* Change the ownerships and register project quota modifications */
 	if (ip->i_projid != fa->fsx_projid) {
-		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
+		if (XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 93c082db04b78c..327d65ef1e268c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -778,7 +778,7 @@ xfs_setattr_nonsize(
 		 * in the transaction.
 		 */
 		if (!uid_eq(iuid, uid)) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_UQUOTA_ON(mp)) {
+			if (XFS_IS_UQUOTA_ON(mp)) {
 				ASSERT(mask & ATTR_UID);
 				ASSERT(udqp);
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
@@ -787,7 +787,7 @@ xfs_setattr_nonsize(
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
-			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
+			if (XFS_IS_GQUOTA_ON(mp)) {
 				ASSERT(xfs_sb_version_has_pquotino(&mp->m_sb) ||
 				       !XFS_IS_PQUOTA_ON(mp));
 				ASSERT(mask & ATTR_GID);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d0755494597f99..baf7b323cb15eb 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -836,13 +836,11 @@ xfs_mountfs(
 	/*
 	 * Initialise the XFS quota management subsystem for this mount
 	 */
-	if (XFS_IS_QUOTA_RUNNING(mp)) {
+	if (XFS_IS_QUOTA_ON(mp)) {
 		error = xfs_qm_newmount(mp, &quotamount, &quotaflags);
 		if (error)
 			goto out_rtunmount;
 	} else {
-		ASSERT(!XFS_IS_QUOTA_ON(mp));
-
 		/*
 		 * If a file system had quotas running earlier, but decided to
 		 * mount without -o uquota/pquota/gquota options, revoke the
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2b34273d0405e7..351d99bc52e5f8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -295,8 +295,6 @@ xfs_qm_need_dqattach(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return false;
 	if (!XFS_IS_QUOTA_ON(mp))
 		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
@@ -631,7 +629,7 @@ xfs_qm_init_quotainfo(
 	struct xfs_quotainfo	*qinf;
 	int			error;
 
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+	ASSERT(XFS_IS_QUOTA_ON(mp));
 
 	qinf = mp->m_quotainfo = kmem_zalloc(sizeof(struct xfs_quotainfo), 0);
 
@@ -676,11 +674,11 @@ xfs_qm_init_quotainfo(
 	xfs_qm_init_timelimits(mp, XFS_DQTYPE_GROUP);
 	xfs_qm_init_timelimits(mp, XFS_DQTYPE_PROJ);
 
-	if (XFS_IS_UQUOTA_RUNNING(mp))
+	if (XFS_IS_UQUOTA_ON(mp))
 		xfs_qm_set_defquota(mp, XFS_DQTYPE_USER, qinf);
-	if (XFS_IS_GQUOTA_RUNNING(mp))
+	if (XFS_IS_GQUOTA_ON(mp))
 		xfs_qm_set_defquota(mp, XFS_DQTYPE_GROUP, qinf);
-	if (XFS_IS_PQUOTA_RUNNING(mp))
+	if (XFS_IS_PQUOTA_ON(mp))
 		xfs_qm_set_defquota(mp, XFS_DQTYPE_PROJ, qinf);
 
 	qinf->qi_shrinker.count_objects = xfs_qm_shrink_count;
@@ -1143,7 +1141,7 @@ xfs_qm_dqusage_adjust(
 	xfs_filblks_t		rtblks = 0;	/* total rt blks */
 	int			error;
 
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+	ASSERT(XFS_IS_QUOTA_ON(mp));
 
 	/*
 	 * rootino must have its resources accounted for, not so with the quota
@@ -1284,7 +1282,7 @@ xfs_qm_quotacheck(
 	flags = 0;
 
 	ASSERT(uip || gip || pip);
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+	ASSERT(XFS_IS_QUOTA_ON(mp));
 
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
@@ -1414,7 +1412,7 @@ xfs_qm_mount_quotas(
 		goto write_changes;
 	}
 
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+	ASSERT(XFS_IS_QUOTA_ON(mp));
 
 	/*
 	 * Allocate the quotainfo structure inside the mount struct, and
@@ -1469,7 +1467,7 @@ xfs_qm_mount_quotas(
 			 * the incore structures are convinced that quotas are
 			 * off, but the on disk superblock doesn't know that !
 			 */
-			ASSERT(!(XFS_IS_QUOTA_RUNNING(mp)));
+			ASSERT(!(XFS_IS_QUOTA_ON(mp)));
 			xfs_alert(mp, "%s: Superblock update failed!",
 				__func__);
 		}
@@ -1641,7 +1639,7 @@ xfs_qm_vop_dqalloc(
 	int			error;
 	uint			lockflags;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	lockflags = XFS_ILOCK_EXCL;
@@ -1772,7 +1770,7 @@ xfs_qm_vop_chown(
 
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
+	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
 
 	/* old dquot */
 	prevdq = *IO_olddq;
@@ -1825,7 +1823,7 @@ xfs_qm_vop_rename_dqattach(
 	struct xfs_mount	*mp = i_tab[0]->i_mount;
 	int			i;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	for (i = 0; (i < 4 && i_tab[i]); i++) {
@@ -1856,7 +1854,7 @@ xfs_qm_vop_create_dqattach(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index d16deb75dc83d7..982cd6613a4cfd 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -204,7 +204,7 @@ xfs_qm_scall_quotaon(
 	     (mp->m_qflags & XFS_GQUOTA_ACCT)))
 		return 0;
 
-	if (! XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return -ESRCH;
 
 	/*
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 88d70c236a5445..07989bd677289a 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -60,18 +60,18 @@ xfs_fs_get_quota_state(
 	struct xfs_quotainfo *q = mp->m_quotainfo;
 
 	memset(state, 0, sizeof(*state));
-	if (!XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 	state->s_incoredqs = q->qi_dquots;
-	if (XFS_IS_UQUOTA_RUNNING(mp))
+	if (XFS_IS_UQUOTA_ON(mp))
 		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
 	if (XFS_IS_UQUOTA_ENFORCED(mp))
 		state->s_state[USRQUOTA].flags |= QCI_LIMITS_ENFORCED;
-	if (XFS_IS_GQUOTA_RUNNING(mp))
+	if (XFS_IS_GQUOTA_ON(mp))
 		state->s_state[GRPQUOTA].flags |= QCI_ACCT_ENABLED;
 	if (XFS_IS_GQUOTA_ENFORCED(mp))
 		state->s_state[GRPQUOTA].flags |= QCI_LIMITS_ENFORCED;
-	if (XFS_IS_PQUOTA_RUNNING(mp))
+	if (XFS_IS_PQUOTA_ON(mp))
 		state->s_state[PRJQUOTA].flags |= QCI_ACCT_ENABLED;
 	if (XFS_IS_PQUOTA_ENFORCED(mp))
 		state->s_state[PRJQUOTA].flags |= QCI_LIMITS_ENFORCED;
@@ -114,10 +114,8 @@ xfs_fs_set_info(
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
+		return -ENOSYS;
 	if (info->i_fieldmask & ~XFS_QC_SETINFO_MASK)
 		return -EINVAL;
 	if ((info->i_fieldmask & XFS_QC_SETINFO_MASK) == 0)
@@ -164,7 +162,7 @@ xfs_quota_enable(
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return -ENOSYS;
 
 	return xfs_qm_scall_quotaon(mp, xfs_quota_flags(uflags));
@@ -179,10 +177,8 @@ xfs_quota_disable(
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
-		return -EINVAL;
+		return -ENOSYS;
 
 	return xfs_qm_scall_quotaoff(mp, xfs_quota_flags(uflags));
 }
@@ -223,10 +219,8 @@ xfs_fs_get_dqblk(
 	struct xfs_mount	*mp = XFS_M(sb);
 	xfs_dqid_t		id;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
+		return -ENOSYS;
 
 	id = from_kqid(&init_user_ns, qid);
 	return xfs_qm_scall_getquota(mp, id, xfs_quota_type(qid.type), qdq);
@@ -243,10 +237,8 @@ xfs_fs_get_nextdqblk(
 	struct xfs_mount	*mp = XFS_M(sb);
 	xfs_dqid_t		id;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
+		return -ENOSYS;
 
 	id = from_kqid(&init_user_ns, *qid);
 	ret = xfs_qm_scall_getquota_next(mp, &id, xfs_quota_type(qid->type),
@@ -269,10 +261,8 @@ xfs_fs_set_dqblk(
 
 	if (sb_rdonly(sb))
 		return -EROFS;
-	if (!XFS_IS_QUOTA_RUNNING(mp))
-		return -ENOSYS;
 	if (!XFS_IS_QUOTA_ON(mp))
-		return -ESRCH;
+		return -ENOSYS;
 
 	return xfs_qm_scall_setqlim(mp, from_kqid(&init_user_ns, qid),
 				     xfs_quota_type(qid.type), qdq);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2c9e26a44546b8..36fc81e52dc22a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -201,25 +201,20 @@ xfs_fs_show_options(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_UQUOTA_ENFD)
-			seq_puts(m, ",usrquota");
-		else
-			seq_puts(m, ",uqnoenforce");
-	}
+	if (mp->m_qflags & XFS_UQUOTA_ENFD)
+		seq_puts(m, ",usrquota");
+	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
+		seq_puts(m, ",uqnoenforce");
 
-	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-			seq_puts(m, ",prjquota");
-		else
-			seq_puts(m, ",pqnoenforce");
-	}
-	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
-		if (mp->m_qflags & XFS_GQUOTA_ENFD)
-			seq_puts(m, ",grpquota");
-		else
-			seq_puts(m, ",gqnoenforce");
-	}
+	if (mp->m_qflags & XFS_PQUOTA_ENFD)
+		seq_puts(m, ",prjquota");
+	else if (mp->m_qflags & XFS_PQUOTA_ACCT)
+		seq_puts(m, ",pqnoenforce");
+
+	if (mp->m_qflags & XFS_GQUOTA_ENFD)
+		seq_puts(m, ",grpquota");
+	else if (mp->m_qflags & XFS_GQUOTA_ACCT)
+		seq_puts(m, ",gqnoenforce");
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
@@ -962,8 +957,8 @@ xfs_finish_flags(
 		return -EROFS;
 	}
 
-	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
-	    (mp->m_qflags & (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)) &&
+	if ((mp->m_qflags & XFS_GQUOTA_ACCT) &&
+	    (mp->m_qflags & XFS_PQUOTA_ACCT) &&
 	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
 		xfs_warn(mp,
 		  "Super block does not support project and group quota together");
@@ -1228,35 +1223,31 @@ xfs_fs_parse_param(
 	case Opt_noquota:
 		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-		parsing_mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
 		return 0;
 	case Opt_quota:
 	case Opt_uquota:
 	case Opt_usrquota:
-		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-				 XFS_UQUOTA_ENFD);
+		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ENFD);
 		return 0;
 	case Opt_qnoenforce:
 	case Opt_uqnoenforce:
-		parsing_mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		parsing_mp->m_qflags |= XFS_UQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_UQUOTA_ENFD;
 		return 0;
 	case Opt_pquota:
 	case Opt_prjquota:
-		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-				 XFS_PQUOTA_ENFD);
+		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ENFD);
 		return 0;
 	case Opt_pqnoenforce:
-		parsing_mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		parsing_mp->m_qflags |= XFS_PQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_PQUOTA_ENFD;
 		return 0;
 	case Opt_gquota:
 	case Opt_grpquota:
-		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-				 XFS_GQUOTA_ENFD);
+		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ENFD);
 		return 0;
 	case Opt_gqnoenforce:
-		parsing_mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		parsing_mp->m_qflags |= XFS_GQUOTA_ACCT;
 		parsing_mp->m_qflags &= ~XFS_GQUOTA_ENFD;
 		return 0;
 	case Opt_discard:
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b7e4b05a559bdb..eb76bc5bed9d0a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -132,8 +132,7 @@ xfs_trans_mod_dquot_byino(
 {
 	xfs_mount_t	*mp = tp->t_mountp;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) ||
-	    !XFS_IS_QUOTA_ON(mp) ||
+	if (!XFS_IS_QUOTA_ON(mp) ||
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
@@ -192,7 +191,7 @@ xfs_trans_mod_dquot(
 	struct xfs_dqtrx	*qtrx;
 
 	ASSERT(tp);
-	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
+	ASSERT(XFS_IS_QUOTA_ON(tp->t_mountp));
 	qtrx = NULL;
 
 	if (!delta)
@@ -738,7 +737,7 @@ xfs_trans_reserve_quota_bydquots(
 {
 	int		error;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
@@ -795,7 +794,7 @@ xfs_trans_reserve_quota_nblks(
 	unsigned int		qflags = 0;
 	int			error;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
@@ -836,7 +835,7 @@ xfs_trans_reserve_quota_icreate(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	return xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp, pdqp,
-- 
2.30.2

