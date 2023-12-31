Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A27BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYady9W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E4CC433C8;
	Sun, 31 Dec 2023 20:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055412;
	bh=5FLwU91xQRNHOh1bmF9BgoJ0gP4x3EX7cw6e9GSYaXc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aYady9W5owyFGaZnDVdRCW8OJEsEjmndOOSV2iQgNCxUFnDbmxfC9oYE9WexGLeVh
	 HZ/LlqiAxmHK+jzFIIb6tJTseuqPIXIV8mltis2jH6E9wtKHhtXHYOHlcUng4e9rlz
	 fbMVPmdQCeIoXB85pc37DGvyHQy8fCotB+Bq5JkURU9EzNxsYYack0N9NNR9YoBP7c
	 OXEYmaygGJ0AAvgEqh0gGv50j0ZBHKL02KrMcOKf/FAg6b5Y7HDw8DokN47fJ27sEq
	 yfSsLTJF7RrzHFhTfPOz9kE7HMF9/gA28e4SQZqr3WDKqNuc82s0rEmRWjqLTMTDn1
	 mGkppEKMgPeQA==
Date: Sun, 31 Dec 2023 12:43:32 -0800
Subject: [PATCH 2/7] xfs: Increase XFS_QM_TRANS_MAXDQS to 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404839937.1756291.17990224398073775898.stgit@frogsfrogsfrogs>
In-Reply-To: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
References: <170404839888.1756291.10910474860265774109.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

With parent pointers enabled, a rename operation can update up to 5
inodes: src_dp, target_dp, src_ip, target_ip and wip.  This causes
their dquots to a be attached to the transaction chain, so we need
to increase XFS_QM_TRANS_MAXDQS.  This patch also add a helper
function xfs_dqlockn to lock an arbitrary number of dquots.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c       |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot.h       |    1 +
 fs/xfs/xfs_qm.h          |    2 +-
 fs/xfs/xfs_trans_dquot.c |   15 ++++++++++-----
 4 files changed, 53 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8703495c2fdc6..bc1893a4b6738 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1363,6 +1363,47 @@ xfs_dqlock2(
 	}
 }
 
+static int
+xfs_dqtrx_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_dqtrx	*qa = a;
+	const struct xfs_dqtrx	*qb = b;
+
+	if (qa->qt_dquot->q_id > qb->qt_dquot->q_id)
+		return 1;
+	if (qa->qt_dquot->q_id < qb->qt_dquot->q_id)
+		return -1;
+	return 0;
+}
+
+void
+xfs_dqlockn(
+	struct xfs_dqtrx	*q)
+{
+	unsigned int		i;
+
+	BUILD_BUG_ON(XFS_QM_TRANS_MAXDQS > MAX_LOCKDEP_SUBCLASSES);
+
+	/* Sort in order of dquot id, do not allow duplicates */
+	for (i = 0; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++) {
+		unsigned int	j;
+
+		for (j = 0; j < i; j++)
+			ASSERT(q[i].qt_dquot != q[j].qt_dquot);
+	}
+	if (i == 0)
+		return;
+
+	sort(q, i, sizeof(struct xfs_dqtrx), xfs_dqtrx_cmp, NULL);
+
+	mutex_lock(&q[0].qt_dquot->q_qlock);
+	for (i = 1; i < XFS_QM_TRANS_MAXDQS && q[i].qt_dquot != NULL; i++)
+		mutex_lock_nested(&q[i].qt_dquot->q_qlock,
+				XFS_QLOCK_NESTED + i - 1);
+}
+
 int __init
 xfs_qm_init(void)
 {
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 956272d9b302f..677bb2dc9ac91 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -223,6 +223,7 @@ int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index f5993012bf98f..6e09dfcd13e25 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -136,7 +136,7 @@ enum {
 	XFS_QM_TRANS_PRJ,
 	XFS_QM_TRANS_DQTYPES
 };
-#define XFS_QM_TRANS_MAXDQS		2
+#define XFS_QM_TRANS_MAXDQS		5
 struct xfs_dquot_acct {
 	struct xfs_dqtrx	dqs[XFS_QM_TRANS_DQTYPES][XFS_QM_TRANS_MAXDQS];
 };
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index f5e9d76fb9a2f..833a65be05705 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -368,24 +368,29 @@ xfs_trans_mod_dquot(
 
 /*
  * Given an array of dqtrx structures, lock all the dquots associated and join
- * them to the transaction, provided they have been modified.  We know that the
- * highest number of dquots of one type - usr, grp and prj - involved in a
- * transaction is 3 so we don't need to make this very generic.
+ * them to the transaction, provided they have been modified.
  */
 STATIC void
 xfs_trans_dqlockedjoin(
 	struct xfs_trans	*tp,
 	struct xfs_dqtrx	*q)
 {
+	unsigned int		i;
 	ASSERT(q[0].qt_dquot != NULL);
 	if (q[1].qt_dquot == NULL) {
 		xfs_dqlock(q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
-	} else {
-		ASSERT(XFS_QM_TRANS_MAXDQS == 2);
+	} else if (q[2].qt_dquot == NULL) {
 		xfs_dqlock2(q[0].qt_dquot, q[1].qt_dquot);
 		xfs_trans_dqjoin(tp, q[0].qt_dquot);
 		xfs_trans_dqjoin(tp, q[1].qt_dquot);
+	} else {
+		xfs_dqlockn(q);
+		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			if (q[i].qt_dquot == NULL)
+				break;
+			xfs_trans_dqjoin(tp, q[i].qt_dquot);
+		}
 	}
 }
 

