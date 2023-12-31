Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FA0BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPrXx16A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF5C433C8;
	Sun, 31 Dec 2023 21:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058495;
	bh=vvo59GPgyPmlVY2fZ5GIDxsfypvoBGG/isjqYMBdtzE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sPrXx16AdsrRz02fOfHqUq2MWdzV75GMY01NTmjtwR1y8//LXOowhx3t/+3tV1kAX
	 5VCIPCcgQeZOGQusWU5L9i0/lqKhZAwFjzXgfPUz9XmPHlhv0LTGixtYmIRW0WJnMK
	 I/i6u6SSeQhBs61rc3wWy4imlmWu/vTlPo6ODQlidUECzmzW90R40W3ekuP523WcdY
	 7ruMvVWfhSqcFSCDzzpGS1LnqmxYI+Y5qWMGYNWijFmntSz7NGc4gV/JKShpz/sSK7
	 ShlQ50SIBUdJ2aezLbjdvfTsTrVEzW+zicKqgD+ldg5NyrOp9tdnOmxqExsEHYvoyq
	 pni1Ml7nkufNg==
Date: Sun, 31 Dec 2023 13:34:55 -0800
Subject: [PATCH 12/39] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850095.1764998.3698658457137800745.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   39 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    2 ++
 fs/xfs/xfs_rtalloc.c             |   21 +++++++++++++++++++-
 3 files changed, 61 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index e60864dd15030..9d2087962c53a 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -609,3 +609,42 @@ xfs_rtrmapbt_create_path(
 	*pathp = path;
 	return 0;
 }
+
+/* Calculate the rtrmap btree size for some records. */
+static unsigned long long
+xfs_rtrmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum rmap btree size.
+ */
+static unsigned long long
+xfs_rtrmapbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrmapbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+xfs_filblks_t
+xfs_rtrmapbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	/* 1/64th (~1.5%) of the space, and enough for 1 record per block. */
+	return max_t(xfs_filblks_t, mp->m_sb.sb_rgblocks >> 6,
+			xfs_rtrmapbt_max_size(mp, mp->m_sb.sb_rgblocks));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 29b698660182d..b7950e6d45d40 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -84,4 +84,6 @@ void xfs_rtrmapbt_destroy_cur_cache(void);
 int xfs_rtrmapbt_create_path(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 		struct xfs_imeta_path **pathp);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 5308554fa93ec..2f2a92672de9a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1560,6 +1560,11 @@ void
 xfs_rt_resv_free(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
+
+	for_each_rtgroup(mp, rgno, rtg)
+		xfs_imeta_resv_free_inode(rtg->rtg_rmapip);
 }
 
 /* Reserve space for rt metadata inodes' space expansion. */
@@ -1567,7 +1572,21 @@ int
 xfs_rt_resv_init(
 	struct xfs_mount	*mp)
 {
-	return 0;
+	struct xfs_rtgroup	*rtg;
+	xfs_filblks_t		ask;
+	xfs_rgnumber_t		rgno;
+	int			error = 0;
+
+	for_each_rtgroup(mp, rgno, rtg) {
+		int		err2;
+
+		ask = xfs_rtrmapbt_calc_reserves(mp);
+		err2 = xfs_imeta_resv_init_inode(rtg->rtg_rmapip, ask);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
 }
 
 static inline int

