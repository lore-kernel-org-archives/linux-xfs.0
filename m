Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5943C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871376; cv=none; b=qEh4R6qV5nMhyvvjX97e1U5uYB1SN9pFq4eOsfhHaneEEyS36pqLUEeUTauPDJvuZBKZPFVAdplgvS5+9RpfEIsc5EDJQED8jcOqtESinXJjaCCpYLaygbcRYvpKG4amngo4buLjchFHzCSSZ3O6olfIeWNa1Q8lL0QcKNVNbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871376; c=relaxed/simple;
	bh=tdpSm2OlWp3MR03CofLFrQBVmIhKwkY4nz1TgYcGdqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjnh0R6wkdv0cbGjPtzRNgLyapL19vha7+nOp+VIa30gytNwZu23lizOHyN1pCCDeW0rX7tGjSsIJvJ/64tpa5wkeILx2XjnLvg6Z8bJkoaBN0Zx8DDSMmLG9iw1IL8mVzSYCKRfYZzw2UuhCh59jx1nukBS42cjwLpXm/tA6zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrcIvimP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrcIvimP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329811F000FF;
	Tue, 13 Oct 2026 06:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871375;
	bh=SC0ofdytSloBOhb2M5dcB7+i7bD50UKQWm0/Ah4469M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrcIvimPQLWSVA2JxbkAv0F1D5twPX7fJ/c8GrmL1+lmi97lKS5lVNDVlgsPDSKnU
	 qhnUu34ku0MNSfjEGIsXql/pA8CfDhmOQbNMaHCbNGjpjkLKWTe0QTAeQtmf6xGqBY
	 CJiZXFd8vJClYIxfcikGJ+hih1s8tTr9wYxQxO0WcdBwRDeYK0r3v1zaLI2+E+ub0K
	 qpqZQjdIgiKH4KPFFxwk0gmPTWMTbDpEQOFNPAiIRMBS/enArw6JMco/n7+GmoPvd+
	 zwjylm79jGKI8jgzq36vdh9K0CkpNFiducssjf0joj6LCpNkREB70vg66DhhkFiXPg
	 C8iYUvdY35BPw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 37/48] xfs: validate the logged inode forks during recovery
Date: Tue, 13 Oct 2026 17:01:27 +1100
Message-ID: <20261013060204.3138690-38-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An inode item logs a data and/or attribute fork region alongside the core. The
commit handler trusted these regions. It guarded them only with asserts as it
copied each fork into the on-disk inode. A fork whose format, size or placement
did not agree with the core was replayed regardless.

Verify the logged forks during item validation, once the core has been verified,
so the fork is trusted before replay begins. The contents of the fork regions
are not inspected here. A device inode is handled separately as it holds its
rdev in the format header and logs no data fork region. The asserts the commit
handler used are removed.

The fork size calculation was duplicated between the on-disk inode macros and
the in-memory inode helpers. Add __xfs_inode_fork_size(), keyed on the scalar
fork offset, and route the macros, the in-memory helpers and the new log dinode
check through it so the calculation exists in one place.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h      |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.c  |   2 +-
 fs/xfs/xfs_inode.h              |  43 +++++---
 fs/xfs/xfs_inode_item_recover.c | 168 +++++++++++++++++++++++++++++---
 4 files changed, 185 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1a7a7e60a170..dbb581eb8521 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1099,13 +1099,11 @@ enum xfs_dinode_fmt {
 #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
 
 #define XFS_DFORK_DSIZE(dip,mp) \
-	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
+	__xfs_inode_fork_size(mp, (dip)->di_forkoff, XFS_DATA_FORK)
 #define XFS_DFORK_ASIZE(dip,mp) \
-	((dip)->di_forkoff ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
+	__xfs_inode_fork_size(mp, (dip)->di_forkoff, XFS_ATTR_FORK)
 #define XFS_DFORK_SIZE(dip,mp,w) \
-	((w) == XFS_DATA_FORK ? \
-		XFS_DFORK_DSIZE(dip, mp) : \
-		XFS_DFORK_ASIZE(dip, mp))
+	__xfs_inode_fork_size(mp, (dip)->di_forkoff, w)
 
 #define XFS_DFORK_MAXEXT(dip, mp, w) \
 	(XFS_DFORK_SIZE(dip, mp, w) / sizeof(struct xfs_bmbt_rec))
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 486fe7ab8b61..fac592e1852c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -86,7 +86,7 @@ xfs_iformat_local(
 	 */
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
-	"corrupt inode %llu (bad size %d for local fork, size = %zd).",
+	"corrupt inode %llu (bad size %d for local fork, size = %u).",
 			(unsigned long long)I_INO(ip), size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1602027cd0aa..3f83fe29349e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -135,19 +135,39 @@ static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
 	return ip->i_forkoff << 3;
 }
 
-static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
+/*
+ * Space available to a fork given the inode's fork offset. The on-disk, logged
+ * and in-memory inodes all express the fork offset the same way, so share this
+ * calculation through a scalar helper.
+ */
+static inline unsigned int
+__xfs_inode_fork_size(
+	struct xfs_mount	*mp,
+	uint8_t			forkoff,
+	int			whichfork)
 {
-	if (xfs_inode_has_attr_fork(ip))
-		return xfs_inode_fork_boff(ip);
+	unsigned int		boff = forkoff << 3;
 
-	return XFS_LITINO(ip->i_mount);
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		return forkoff ? boff : XFS_LITINO(mp);
+	case XFS_ATTR_FORK:
+		return forkoff ? XFS_LITINO(mp) - boff : 0;
+	default:
+		return 0;
+	}
+}
+
+static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
+{
+	return __xfs_inode_fork_size(ip->i_mount, ip->i_forkoff,
+			XFS_DATA_FORK);
 }
 
 static inline unsigned int xfs_inode_attr_fork_size(struct xfs_inode *ip)
 {
-	if (xfs_inode_has_attr_fork(ip))
-		return XFS_LITINO(ip->i_mount) - xfs_inode_fork_boff(ip);
-	return 0;
+	return __xfs_inode_fork_size(ip->i_mount, ip->i_forkoff,
+			XFS_ATTR_FORK);
 }
 
 static inline unsigned int
@@ -155,14 +175,7 @@ xfs_inode_fork_size(
 	struct xfs_inode	*ip,
 	int			whichfork)
 {
-	switch (whichfork) {
-	case XFS_DATA_FORK:
-		return xfs_inode_data_fork_size(ip);
-	case XFS_ATTR_FORK:
-		return xfs_inode_attr_fork_size(ip);
-	default:
-		return 0;
-	}
+	return __xfs_inode_fork_size(ip->i_mount, ip->i_forkoff, whichfork);
 }
 
 /* Convert from vfs inode to xfs inode */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 6f25b716b5d1..c5be302bdad7 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -441,6 +441,128 @@ xlog_dinode_verify(
 	return NULL;
 }
 
+/*
+ * Verify the logged data fork against the core and the fork region that carries
+ * it. The core has already been verified, so the mode and fork offset can be
+ * trusted here. The data fork format must be valid for the inode mode, whether
+ * or not the fork was logged. A regular file has no local format data fork. If
+ * the fork was logged, the field logged for it must match that format, and the
+ * region holding it must be the size the format header records. A local or
+ * extents fork is copied verbatim into the inode fork, so it must also fit
+ * within the space the fork offset leaves for it. A btree fork is logged in the
+ * larger expanded form and compressed into the fork on replay, so it does not
+ * get the fit check. The contents of the region are not inspected.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_dfork(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	struct xfs_inode_log_format	*ilfp,
+	struct xlog_recover_item	*item)
+{
+	unsigned int			field = ilfp->ilf_fields & XFS_ILOG_DFORK;
+	unsigned int			fork_size;
+
+	switch (ldip->di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+		if (S_ISREG(ldip->di_mode))
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_META_BTREE:
+		break;
+	default:
+		return __this_address;
+	}
+
+	if (!field)
+		return NULL;
+
+	if (item->ri_buf[2].iov_len != xlog_calc_iovec_len(ilfp->ilf_dsize))
+		return __this_address;
+
+	fork_size = __xfs_inode_fork_size(mp, ldip->di_forkoff, XFS_DATA_FORK);
+
+	switch (ldip->di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+		if (field != XFS_ILOG_DDATA)
+			return __this_address;
+		if (ilfp->ilf_dsize > fork_size)
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (field != XFS_ILOG_DEXT)
+			return __this_address;
+		if (ilfp->ilf_dsize > fork_size)
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_META_BTREE:
+		if (field != XFS_ILOG_DBROOT)
+			return __this_address;
+		break;
+	}
+
+	return NULL;
+}
+
+/*
+ * Verify the logged attribute fork against the core and the fork region that
+ * carries it, as for the data fork. The attribute fork has no local device or
+ * metadata btree format.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_afork(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	struct xfs_inode_log_format	*ilfp,
+	struct xlog_recover_item	*item)
+{
+	unsigned int			field = ilfp->ilf_fields & XFS_ILOG_AFORK;
+	unsigned int			fork_size;
+	unsigned int			region;
+
+	switch (ldip->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		break;
+	default:
+		return __this_address;
+	}
+
+	if (!field)
+		return NULL;
+
+	region = (ilfp->ilf_fields & XFS_ILOG_DFORK) ? 3 : 2;
+	if (item->ri_buf[region].iov_len != xlog_calc_iovec_len(ilfp->ilf_asize))
+		return __this_address;
+
+	fork_size = __xfs_inode_fork_size(mp, ldip->di_forkoff, XFS_ATTR_FORK);
+
+	switch (ldip->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		if (field != XFS_ILOG_ADATA)
+			return __this_address;
+		if (ilfp->ilf_asize > fork_size)
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		if (field != XFS_ILOG_AEXT)
+			return __this_address;
+		if (ilfp->ilf_asize > fork_size)
+			return __this_address;
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		if (field != XFS_ILOG_ABROOT)
+			return __this_address;
+		break;
+	}
+
+	return NULL;
+}
+
 static inline int
 xlog_recover_inode_dbroot(
 	struct xfs_mount	*mp,
@@ -677,6 +799,36 @@ xlog_recover_inode_validate_item(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * A device inode holds its rdev in the format header and logs no data
+	 * fork region. Any other inode has its logged data fork verified against
+	 * the core and the fork offset.
+	 */
+	if (ldip->di_format == XFS_DINODE_FMT_DEV) {
+		if (ilfp->ilf_fields & XFS_ILOG_DFORK) {
+			xfs_warn(log->l_mp,
+				"INODE: device inode 0x%llx logged a data fork.",
+				ilfp->ilf_ino);
+			return -EFSCORRUPTED;
+		}
+	} else {
+		fa = xlog_dinode_verify_dfork(log->l_mp, ldip, ilfp, item);
+		if (fa) {
+			xfs_warn(log->l_mp,
+				"INODE: inode 0x%llx logged data fork failed validation at %pS",
+				ilfp->ilf_ino, fa);
+			return -EFSCORRUPTED;
+		}
+	}
+
+	fa = xlog_dinode_verify_afork(log->l_mp, ldip, ilfp, item);
+	if (fa) {
+		xfs_warn(log->l_mp,
+			"INODE: inode 0x%llx logged attr fork failed validation at %pS",
+			ilfp->ilf_ino, fa);
+		return -EFSCORRUPTED;
+	}
+
 	return 0;
 }
 
@@ -792,10 +944,6 @@ xlog_recover_inode_commit_pass2(
 		goto out_owner_change;
 	len = item->ri_buf[2].iov_len;
 	src = item->ri_buf[2].iov_base;
-	ASSERT(in_f->ilf_size <= 4);
-	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
-	ASSERT(!(fields & XFS_ILOG_DFORK) ||
-	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
 	/*
 	 * The recovered inode is verified only after the fork data has been
@@ -829,10 +977,7 @@ xlog_recover_inode_commit_pass2(
 		break;
 
 	default:
-		/*
-		 * There are no data fork flags set.
-		 */
-		ASSERT((fields & XFS_ILOG_DFORK) == 0);
+		/* No data fork was logged. */
 		break;
 	}
 
@@ -849,7 +994,6 @@ xlog_recover_inode_commit_pass2(
 		}
 		len = item->ri_buf[attr_index].iov_len;
 		src = item->ri_buf[attr_index].iov_base;
-		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
 
 		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
 		case XFS_ILOG_ADATA:
@@ -864,12 +1008,6 @@ xlog_recover_inode_commit_pass2(
 					 len, (struct xfs_bmdr_block *)dest,
 					 XFS_DFORK_ASIZE(dip, mp));
 			break;
-
-		default:
-			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
-			ASSERT(0);
-			error = -EFSCORRUPTED;
-			goto out_release;
 		}
 	}
 
-- 
2.55.0

