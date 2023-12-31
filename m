Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3168BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMXrFhVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46819C433C8;
	Sun, 31 Dec 2023 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059356;
	bh=l64/J+v96V9Ccvk6RUoJhwDQRCQuVppz7OXNr2GAT+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LMXrFhVcXbqyr9QAxAsI2cjLiSp8/QRWey2PWwvQqJX1mYICoJVvymKYSDtgTnT0Q
	 TdrYoQqGrYBcpT/wovDVCQCFpzjcqaL73Srbj5QjyRFSDpwrsAVVheePb1YAZMuDdX
	 FZuDQ4dd6c5Hzwe+Q+JHEAJsWhyqVEbaTPOV7JzybvMGj7fqj/UnTAelH7FrT8Y9aL
	 oWcW7fJ7ShsFm53gzplA2QgwuAvN64BhJIhIBVAcKQDuxz9zAMbUbTqAOTSkZ11uN4
	 HS8gcynCcOuEv/gOChH1RKpuZhKcgW6/gdndZhIV97IGrHDoR95Lt03sonAtJqhw3t
	 U6KCMHkYQcG/w==
Date: Sun, 31 Dec 2023 13:49:15 -0800
Subject: [PATCH 18/44] xfs: refactor reflink quota updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851872.1766284.4369986026573308387.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Hoist all quota updates for reflink into a helper function, since things
are about to become more complicated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a10d43a1a7da4..8e352b23dacf2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -753,6 +753,35 @@ xfs_reflink_cancel_cow_range(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/*
+ * Update quota accounting for a remapping operation.  When we're remapping
+ * something from the CoW fork to the data fork, we must update the quota
+ * accounting for delayed allocations.  For remapping from the data fork to the
+ * data fork, use regular block accounting.
+ */
+static inline void
+xfs_reflink_update_quota(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	bool			is_cow,
+	int64_t			blocks)
+{
+	unsigned int		qflag;
+
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		qflag = is_cow ? XFS_TRANS_DQ_DELRTBCOUNT :
+				 XFS_TRANS_DQ_RTBCOUNT;
+	} else {
+		qflag = is_cow ? XFS_TRANS_DQ_DELBCOUNT :
+				 XFS_TRANS_DQ_BCOUNT;
+	}
+	xfs_trans_mod_dquot_byino(tp, ip, qflag, blocks);
+}
+#else
+# define xfs_reflink_update_quota(tp, ip, is_cow, blocks)	((void)0)
+#endif
+
 /*
  * Remap part of the CoW fork into the data fork.
  *
@@ -856,8 +885,7 @@ xfs_reflink_end_cow_extent(
 		 */
 		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
 		xfs_refcount_decrease_extent(tp, isrt, &data);
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				-data.br_blockcount);
+		xfs_reflink_update_quota(tp, ip, false, -data.br_blockcount);
 	} else if (data.br_startblock == DELAYSTARTBLOCK) {
 		int		done;
 
@@ -882,8 +910,7 @@ xfs_reflink_end_cow_extent(
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &del);
 
 	/* Charge this new data fork mapping to the on-disk quota. */
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_DELBCOUNT,
-			(long)del.br_blockcount);
+	xfs_reflink_update_quota(tp, ip, true, del.br_blockcount);
 
 	/* Remove the mapping from the CoW fork. */
 	xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
@@ -1373,7 +1400,7 @@ xfs_reflink_remap_extent(
 		qdelta += dmap->br_blockcount;
 	}
 
-	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
+	xfs_reflink_update_quota(tp, ip, false, qdelta);
 
 	/* Update dest isize if needed. */
 	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);

