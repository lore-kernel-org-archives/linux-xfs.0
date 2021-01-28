Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024ABC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B096864DDC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhA1GDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhA1GDq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6583564DDC;
        Thu, 28 Jan 2021 06:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813784;
        bh=317kZLUQS7W6O//75+YfDqVEBJRZuqiOv2gJ0xHb/Og=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lJJ6gcug+WIg0U+BPSw6twxldleu72d19eB6Ukzngzl4/2f9HpfScq/KzlTEDvxkG
         Kxi9Y+godCnXvBNPMlMX+5LP+K68OpYJDbIHRTvNduBhhkl4wdCSIfYWqiAaukztLt
         YJvEjIy+URCHKLckwld+rdjieZSf6DtJmpmqvkbczEZQHWaeEYxSPGUsY9uUQFZxK/
         aZPVDA4vZ2QELS5h16FZ2U8K01hTqhwVYDFCSN2xtmWydlrPTWhcDYwX3SDOS9FV6M
         ewwZQjtx5ikd9G9yEOZ19uJ8TVLS456gcI0av6/hRVU6CO04lVLwvlwXE7MGCQ65qm
         ztz9NuF1ZLKMw==
Subject: [PATCH 07/11] xfs: flush eof/cowblocks if we can't reserve quota for
 inode creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:00 -0800
Message-ID: <161181378074.1525026.3339149603399013364.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an inode creation is unable to reserve enough quota to handle the
modification, try clearing whatever space the filesystem might have been
hanging onto in the hopes of speeding up the filesystem.  The flushing
behavior will become particularly important when we add deferred inode
inactivation because that will increase the amount of space that isn't
actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c      |   73 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_icache.h      |    2 +
 fs/xfs/xfs_quota.h       |   18 ++++++++++-
 fs/xfs/xfs_trans.c       |    9 +++++-
 fs/xfs/xfs_trans_dquot.c |   36 +++++++++++++++++++++--
 5 files changed, 102 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4a074aa12b52..cd369dd48818 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1646,64 +1646,77 @@ xfs_start_block_reaping(
 }
 
 /*
- * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
- * with multiple quotas, we don't know exactly which quota caused an allocation
- * failure. We make a best effort by including each quota under low free space
- * conditions (less than 1% free space) in the scan.
+ * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
+ * quota caused an allocation failure, so we make a best effort by including
+ * each quota under low free space conditions (less than 1% free space) in the
+ * scan.
  *
  * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
  * (XFS_EOF_FLAGS_SYNC), the caller also must not hold any inode's IOLOCK or
  * MMAPLOCK.
  */
 int
-xfs_blockgc_free_quota(
-	struct xfs_inode	*ip,
+xfs_blockgc_free_dquots(
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
 	unsigned int		eof_flags)
 {
 	struct xfs_eofblocks	eofb = {0};
-	struct xfs_dquot	*dq;
+	struct xfs_mount	*mp = NULL;
 	bool			do_work = false;
 	int			error;
 
+	if (!udqp && !gdqp && !pdqp)
+		return 0;
+	if (udqp)
+		mp = udqp->q_mount;
+	if (!mp && gdqp)
+		mp = gdqp->q_mount;
+	if (!mp && pdqp)
+		mp = pdqp->q_mount;
+
 	/*
 	 * Run a scan to free blocks using the union filter to cover all
 	 * applicable quotas in a single scan.
 	 */
 	eofb.eof_flags = XFS_EOF_FLAGS_UNION | eof_flags;
 
-	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_uid = VFS_I(ip)->i_uid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			do_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
+		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_UID;
+		do_work = true;
 	}
 
-	if (XFS_IS_GQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_GROUP);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_gid = VFS_I(ip)->i_gid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			do_work = true;
-		}
+	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
+		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		eofb.eof_flags |= XFS_EOF_FLAGS_GID;
+		do_work = true;
 	}
 
-	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount)) {
-		dq = xfs_inode_dquot(ip, XFS_DQTYPE_PROJ);
-		if (dq && xfs_dquot_lowsp(dq)) {
-			eofb.eof_prid = ip->i_d.di_projid;
-			eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
-			do_work = true;
-		}
+	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
+		eofb.eof_prid = pdqp->q_id;
+		eofb.eof_flags |= XFS_EOF_FLAGS_PRID;
+		do_work = true;
 	}
 
 	if (!do_work)
 		return 0;
 
-	error = xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	error = xfs_icache_free_eofblocks(mp, &eofb);
 	if (error)
 		return error;
 
-	return xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return xfs_icache_free_cowblocks(mp, &eofb);
+}
+
+/* Run cow/eofblocks scans on the quotas attached to the inode. */
+int
+xfs_blockgc_free_quota(
+	struct xfs_inode	*ip,
+	unsigned int		eof_flags)
+{
+	return xfs_blockgc_free_dquots(xfs_inode_dquot(ip, XFS_DQTYPE_USER),
+			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
+			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d64ea8f5c589..5f520de637f6 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,6 +54,8 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+int xfs_blockgc_free_dquots(struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int eof_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int eof_flags);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index dcdc3cd0361a..7d87a1244256 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -90,7 +90,10 @@ extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
 int xfs_trans_reserve_quota_icreate(struct xfs_trans *tp,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, int64_t dblocks);
+		struct xfs_dquot *pdqp, int64_t dblocks, unsigned int *retry);
+void xfs_trans_cancel_qretry_icreate(struct xfs_trans *tp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -157,7 +160,8 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
 
 static inline int
 xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
-		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t dblocks)
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t dblocks,
+		unsigned int *retry)
 {
 	return 0;
 }
@@ -168,6 +172,16 @@ xfs_trans_cancel_qretry_nblks(struct xfs_trans *tp, struct xfs_inode *ip)
 	ASSERT(0);
 }
 
+static inline void
+xfs_trans_cancel_qretry_icreate(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
+{
+	ASSERT(0);
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3d1f745b721a..7d4823cbd7c0 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1099,17 +1099,24 @@ xfs_trans_alloc_icreate(
 	struct xfs_trans	**tpp)
 {
 	struct xfs_trans	*tp;
+	unsigned int		qretry = 0;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
 	if (error)
 		return error;
 
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks,
+			&qretry);
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;
 	}
+	if (qretry) {
+		xfs_trans_cancel_qretry_icreate(tp, udqp, gdqp, pdqp);
+		goto retry;
+	}
 
 	*tpp = tp;
 	return 0;
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 229e2a20889f..2358c9e35be8 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -893,22 +893,52 @@ xfs_trans_cancel_qretry_nblks(
 	xfs_blockgc_free_quota(ip, 0);
 }
 
-/* Change the quota reservations for an inode creation activity. */
+/*
+ * Change the quota reservations for an inode creation activity.  This doesn't
+ * change the actual usage, just the reservation.  If @retry is not a NULL
+ * pointer, the caller must ensure that *retry is set to zero before the first
+ * time this function is called.
+ *
+ * If the quota reservation fails because we hit a quota limit (and retry is
+ * not a NULL pointer, and *retry is zero), this function will set *retry to
+ * nonzero and return zero.
+ */
 int
 xfs_trans_reserve_quota_icreate(
 	struct xfs_trans	*tp,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	int64_t			dblocks)
+	int64_t			dblocks,
+	unsigned int		*retry)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
-	return xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp, pdqp,
+	error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp, pdqp,
 			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
+	if (!reservation_success(XFS_QMOPT_RES_REGBLKS, retry, &error))
+		return error;
+
+	return 0;
+}
+
+/*
+ * Cancel a transaction and try to clear some space so that we can reserve some
+ * quota.  When this function returns, the transaction will be cancelled.
+ */
+void
+xfs_trans_cancel_qretry_icreate(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
+{
+	xfs_trans_cancel(tp);
+	xfs_blockgc_free_dquots(udqp, gdqp, pdqp, 0);
 }
 
 /*

