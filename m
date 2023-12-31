Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89888BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Up15CKmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CA8C433C8;
	Sun, 31 Dec 2023 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059262;
	bh=2V6R5jbIGh5H1Han7a9SUUCwTBzDY2NZAyDOWoivsM0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Up15CKmJFZ/RKREco6AC3HHy4hOTSjNvSgAMfaJ9/G4vIwvRZ9b3CYZoXUtadi9B/
	 V7MP33hjh25u39crexqYsm5NWaeWqZtgeXXx1aatBmuskYBpy3zh7ncHFaZG9El7Xl
	 gIsILzp1wB+oYAtyDMsrVUhT+mVBMZFMGmjemN+ccb73Kzz3WvLb2fJyWcNPw3m4G6
	 5zRgAUeJmpacmcOdpaMwF3OzrAX/H0FTeA8XrFCpCpMDFh8/oBDhHiUug9ki1FP3Sv
	 YOubJb74y47oDUnZSawrnq+NIQrLYj/5SWWpm90tglDTJG50vS6DQsQxPzia46KVKn
	 iqSVaYED2hXdw==
Date: Sun, 31 Dec 2023 13:47:41 -0800
Subject: [PATCH 12/44] xfs: add metadata reservations for realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851776.1766284.11118894100439868574.stgit@frogsfrogsfrogs>
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

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   39 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    4 +++
 fs/xfs/xfs_rtalloc.c                 |    9 +++++++-
 3 files changed, 51 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ead6baf6de7e4..e1e8a3ea32091 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -491,3 +491,42 @@ xfs_rtrefcountbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrefcount btree size for some records. */
+unsigned long long
+xfs_rtrefcountbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrefc_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+static unsigned long long
+xfs_rtrefcountbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrefc_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrefcountbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ * We need enough space to hold one record for every rt extent in the rtgroup.
+ */
+xfs_filblks_t
+xfs_rtrefcountbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	return xfs_rtrefcountbt_max_size(mp,
+			xfs_rtb_to_rtx(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index ff49e95d1a490..045f7b1f72833 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -72,4 +72,8 @@ void xfs_rtrefcountbt_destroy_cur_cache(void);
 int xfs_rtrefcountbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4102a46ed274d..14e17c2b39ef0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1711,8 +1711,10 @@ xfs_rt_resv_free(
 	struct xfs_rtgroup	*rtg;
 	xfs_rgnumber_t		rgno;
 
-	for_each_rtgroup(mp, rgno, rtg)
+	for_each_rtgroup(mp, rgno, rtg) {
+		xfs_imeta_resv_free_inode(rtg->rtg_refcountip);
 		xfs_imeta_resv_free_inode(rtg->rtg_rmapip);
+	}
 }
 
 /* Reserve space for rt metadata inodes' space expansion. */
@@ -1732,6 +1734,11 @@ xfs_rt_resv_init(
 		err2 = xfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
 		if (err2 && !error)
 			error = err2;
+
+		ask = xfs_rtrefcountbt_calc_reserves(mp);
+		err2 = xfs_imeta_resv_init_inode(rtg->rtg_refcountip, ask);
+		if (err2 && !error)
+			error = err2;
 	}
 
 	return error;

