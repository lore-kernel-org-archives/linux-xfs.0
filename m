Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8364B26056C
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098502; cv=none; b=kzCDm5OtIGT4T3JkxhmpqUV9bsVxrmhxEqgIpObYgY6D95dzPCqfnrJLUbuHB9M9bnmsFp+3uRUmRIwV5L647dQNJCB17qcGzvB8u9WqAu0CY5Y/pbxTXscaYNn9vfJM3+Y6bjgx88bcxSG6GwrtXAhqx+XlwQkP6Xx3SomTf3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098502; c=relaxed/simple;
	bh=Y2MSAIkC4AkqNa023OEHNzxpWMXHkwtkTH35tf2/h7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imrWq+I7nTo2qjoKFys13eYvJMR/QHw2o2VLalO0LDI2bZuUeTRMY+CmIQMGfzYp3345Cgwu8vQuB7mxwhJ5QOtNEjcRvnJVvge8nhq4o1IIk2jDF5Wh/GOqgS8B2WV9DECKQVaFnX8GOlyv5vTOPHDDwSc2FLbWqbVvl2tZSKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuFmuFo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuFmuFo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC1E1F000E9;
	Wed, 19 Aug 2026 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098496;
	bh=TBOs3H5dfegtjs+dmPT+ezmmBLwelS62pyh4DH1WRJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuFmuFo8qqm8yKB6PwRiDswpIumWhR6Rbvia30jMFq4Mu3p389bNmFuaWUd843NTR
	 CzvwREGVDHzUsrom6YYEtcq4LDS8YnnBKt1f/lBei+r/0fNEtTQJtiMbZ7buBNv40z
	 YmYHTkqWdu/zPkVv0Mjwn1Vg5RluYsrEbcekXj5FuKr/uxyDYjuf8hvTFPyvHg8/yQ
	 DEmCJ/qsMY0eCoCgLkWovdYwuBz7tinU3VJu5obpi/GPDvBEbdNX+6l1tACz+D/Ndd
	 euVUtVWp5POA6eVL8WD+T7+iPTSRAih3L/W1JnwImPPJ4lVMY6IlxNQop/5CCnk98h
	 Sz1vdOo216GlA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 07/38] xfs: add async quota-targeted blockgc flush
Date: Wed, 19 Aug 2026 10:12:10 +1000
Message-ID: <20260819001442.1451892-8-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert xfs_blockgc_free_space() to queue the icwalk scan to the
blockgc workqueue rather than running it inline. The existing
synchronous callers wait for completion via flush_work(). Add a
static xfs_blockgc_free_space_nowait() for contexts that need to
kick a scan without waiting.

Factor xfs_blockgc_dquot_filter() out of xfs_blockgc_free_dquots()
to build the icwalk quota filter separately from running the scan.
This allows both the existing synchronous xfs_blockgc_free_dquots()
and the new async xfs_blockgc_free_quota_nowait() to share the
filter construction.

xfs_blockgc_free_quota_nowait() is the async variant for contexts
that hold the ILOCK and cannot wait for the scan synchronously. The
blockgc workers need the ILOCK to scan inodes for reclaimable
speculative preallocations, and the locked inode pins journal space
that the workers need for transactions.

Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_icache.c | 145 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_icache.h |   1 +
 2 files changed, 116 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index bad09cb090cc..256253bfeac1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1575,24 +1575,75 @@ xfs_blockgc_worker(
 	xfs_blockgc_queue(pag);
 }
 
+struct xfs_blockgc_async_work {
+	struct work_struct	work;
+	struct xfs_mount	*mp;
+	struct xfs_icwalk	icw;
+	int			error;
+	bool			async;
+};
+
+static void
+xfs_blockgc_free_space_worker(
+	struct work_struct	*work)
+{
+	struct xfs_blockgc_async_work *baw = container_of(work,
+					struct xfs_blockgc_async_work, work);
+
+	baw->error = xfs_icwalk(baw->mp, XFS_ICWALK_BLOCKGC, &baw->icw);
+	if (!baw->error)
+		baw->error = xfs_inodegc_flush(baw->mp);
+
+	if (baw->async)
+		kfree(baw);
+}
+
 /*
  * Try to free space in the filesystem by purging inactive inodes, eofblocks
- * and cowblocks.
+ * and cowblocks. The scan is queued to the blockgc workqueue and the caller
+ * waits for it to complete.
  */
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
-	int			error;
+	struct xfs_blockgc_async_work baw = {
+		.mp		= mp,
+		.icw		= *icw,
+		.async		= false,
+	};
 
 	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	error = xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
-	if (error)
-		return error;
+	INIT_WORK_ONSTACK(&baw.work, xfs_blockgc_free_space_worker);
+	queue_work(mp->m_blockgc_wq, &baw.work);
+	flush_work(&baw.work);
+	destroy_work_on_stack(&baw.work);
+	return baw.error;
+}
 
-	return xfs_inodegc_flush(mp);
+/*
+ * Queue a background space reclaim scan without waiting for it to complete.
+ * This is for callers that hold the ILOCK and cannot wait for the scan
+ * synchronously because the blockgc workers need the ILOCK to scan inodes
+ * and the locked inode pins journal space that the workers need for
+ * transactions.
+ */
+static void
+xfs_blockgc_free_space_nowait(
+	struct xfs_mount	*mp,
+	struct xfs_icwalk	*icw)
+{
+	struct xfs_blockgc_async_work *baw;
+
+	baw = kzalloc(sizeof(*baw), GFP_KERNEL | __GFP_NOFAIL);
+	baw->mp = mp;
+	baw->icw = *icw;
+	baw->async = true;
+
+	INIT_WORK(&baw->work, xfs_blockgc_free_space_worker);
+	queue_work(mp->m_blockgc_wq, &baw->work);
 }
 
 /*
@@ -1632,56 +1683,72 @@ xfs_blockgc_flush_all(
 }
 
 /*
- * Run cow/eofblocks scans on the supplied dquots.  We don't know exactly which
- * quota caused an allocation failure, so we make a best effort by including
- * each quota under low free space conditions (less than 1% free space) in the
- * scan.
+ * Build an icwalk filter to free speculative preallocations on inodes in
+ * quota groups that are under low free space conditions. We don't know
+ * exactly which quota caused an allocation failure, so we make a best effort
+ * by including each quota under low free space conditions (less than 1% free
+ * space) in the scan.
  *
- * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
- * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
- * MMAPLOCK.
+ * Returns true if there are quota groups that need scanning, false otherwise.
  */
-int
-xfs_blockgc_free_dquots(
+static bool
+xfs_blockgc_dquot_filter(
 	struct xfs_mount	*mp,
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	unsigned int		iwalk_flags)
+	struct xfs_icwalk	*icw)
 {
-	struct xfs_icwalk	icw = {0};
 	bool			do_work = false;
 
 	if (!udqp && !gdqp && !pdqp)
-		return 0;
+		return false;
 
-	/*
-	 * Run a scan to free blocks using the union filter to cover all
-	 * applicable quotas in a single scan.
-	 */
-	icw.icw_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
+	memset(icw, 0, sizeof(*icw));
+	icw->icw_flags = XFS_ICWALK_FLAG_UNION;
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
-		icw.icw_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
-		icw.icw_flags |= XFS_ICWALK_FLAG_UID;
+		icw->icw_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		icw->icw_flags |= XFS_ICWALK_FLAG_UID;
 		do_work = true;
 	}
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
-		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
-		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
+		icw->icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		icw->icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;
 	}
 
 	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
-		icw.icw_prid = pdqp->q_id;
-		icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
+		icw->icw_prid = pdqp->q_id;
+		icw->icw_flags |= XFS_ICWALK_FLAG_PRID;
 		do_work = true;
 	}
 
-	if (!do_work)
+	return do_work;
+}
+
+/*
+ * Run cow/eofblocks scans on the supplied dquots.
+ *
+ * Callers must not hold any inode's ILOCK.  If requesting a synchronous scan
+ * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
+ * MMAPLOCK.
+ */
+int
+xfs_blockgc_free_dquots(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	unsigned int		iwalk_flags)
+{
+	struct xfs_icwalk	icw;
+
+	if (!xfs_blockgc_dquot_filter(mp, udqp, gdqp, pdqp, &icw))
 		return 0;
 
+	icw.icw_flags |= iwalk_flags;
 	return xfs_blockgc_free_space(mp, &icw);
 }
 
@@ -1697,6 +1764,24 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
 }
 
+/*
+ * Start an async background scan to free speculative preallocations on inodes
+ * in the quota groups attached to the given inode. This does not wait for the
+ * scan to complete and is safe to call with the ILOCK held.
+ */
+void
+xfs_blockgc_free_quota_nowait(
+	struct xfs_inode	*ip)
+{
+	struct xfs_icwalk	icw;
+
+	if (xfs_blockgc_dquot_filter(ip->i_mount,
+			xfs_inode_dquot(ip, XFS_DQTYPE_USER),
+			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
+			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), &icw))
+		xfs_blockgc_free_space_nowait(ip->i_mount, &icw);
+}
+
 /* XFS Inode Cache Walking Code */
 
 /*
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e68d13125f7b..f55cabb9fcf5 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -62,6 +62,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
+void xfs_blockgc_free_quota_nowait(struct xfs_inode *ip);
 void xfs_blockgc_start_flush(struct xfs_mount *mp);
 int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
-- 
2.55.0

