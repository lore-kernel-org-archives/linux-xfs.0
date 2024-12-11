Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0CB1E9B36
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907417; cv=none; b=pMDdgvk+Q4fq7nLNlDakoAAVxFAkX+IXPf8i9Xlq1TyManIj9/S1VVrONXHs5OTmM4KuqxiSN558o7lw5ekUZo8DHWa5ynnpnMfx//LneezMeNaCOTa70wZ4BJPePMtIVKH68HIR1KnDAUoTm6jt/DsvHSgEbfWUpHy6zbh1CHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907417; c=relaxed/simple;
	bh=FfmMn/uf2Bso/Rk1lw/Tp7m7+We8z5OiGgOxmpPp5Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIVn5umoKSTpRa9r9DNtKHT5GltCR0ZXrj3jz8q4S26gRjh45lPB5JgNqa9Oeo7GsjI35wTcDgS9yI8UI74mUqniuyIjtrssaVUAVPAJnbfZDrfrnwYf3ogLEPKk5kWBu+EyrRu43F4wMW4D8m5YVlMNeCfL2VHvWyQ0zIJXkMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3mRHko1P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3mRHko1P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CLwweDVYFp78YCErnnGykDuS0a4KDKHlTtqu+nLMFqg=; b=3mRHko1PwrL2uXjeJ9Eo7mwtZY
	1JOmG799m81uCE7S8gYf0QX51LbokqTMnMxHAsqSfqo40AaY8k5ykGKySokoySAo1UlRgOiWWKdhz
	YrVonqV+g0vskz5m5YbpDvwxfsIhiz6F61//FVC+ijpSCfTkD5TF+vskYsIiNsi6O/2V9sy3gchg0
	Wpv72ZTYS9hz5mjPJmYEG9DB7yjhDqZBi/Cu2gt9TwlvGt4ZpblOrqkPPMuhT6dOW9YpRqmRPWnSf
	A2M6jYsyEqkN+tnovgTQJwsMc828PJa/K+nBU6pTIv1RdyrGr0276fBcAwcbb9SoyJmFF6jA58ZPE
	qp8leMlg==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWc-0000000EJ2Q-0iJk;
	Wed, 11 Dec 2024 08:56:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/43] xfs: refactor xfs_fs_statfs
Date: Wed, 11 Dec 2024 09:54:31 +0100
Message-ID: <20241211085636.1380516-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out helper for data, rt data and inode related informations,
and assing f_bavail once instead of in three places.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_bhv.c |   2 +-
 fs/xfs/xfs_super.c  | 128 ++++++++++++++++++++++++++------------------
 2 files changed, 78 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 847ba29630e9..6d5de3fa58e8 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -34,7 +34,7 @@ xfs_fill_statvfs_from_dquot(
 		blkres->hardlimit;
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
+		statp->f_bfree =
 			(statp->f_blocks > blkres->reserved) ?
 			 (statp->f_blocks - blkres->reserved) : 0;
 	}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bfa8cc927009..a74a0cc1f6f6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -819,20 +819,74 @@ xfs_fs_sync_fs(
 	return 0;
 }
 
+static xfs_extlen_t
+xfs_internal_log_size(
+	struct xfs_mount	*mp)
+{
+	if (!mp->m_sb.sb_logstart)
+		return 0;
+	return mp->m_sb.sb_logblocks;
+}
+
+static void
+xfs_statfs_data(
+	struct xfs_mount	*mp,
+	struct kstatfs		*st)
+{
+	int64_t			fdblocks =
+		percpu_counter_sum(&mp->m_fdblocks);
+
+	/* make sure st->f_bfree does not underflow */
+	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
+	st->f_blocks = mp->m_sb.sb_dblocks - xfs_internal_log_size(mp);
+}
+
+/*
+ * When stat(v)fs is called on a file with the realtime bit set or a directory
+ * with the rtinherit bit, report freespace information for the RT device
+ * instead of the main data device.
+ */
+static void
+xfs_statfs_rt(
+	struct xfs_mount	*mp,
+	struct kstatfs		*st)
+{
+	int64_t			freertx =
+		percpu_counter_sum_positive(&mp->m_frextents);
+
+	st->f_bfree = xfs_rtbxlen_to_blen(mp, freertx);
+	st->f_blocks = mp->m_sb.sb_rblocks;
+}
+
+static void
+xfs_statfs_inodes(
+	struct xfs_mount	*mp,
+	struct kstatfs		*st)
+{
+	uint64_t		icount = percpu_counter_sum(&mp->m_icount);
+	uint64_t		ifree = percpu_counter_sum(&mp->m_ifree);
+	uint64_t		fakeinos = XFS_FSB_TO_INO(mp, st->f_bfree);
+
+	st->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
+	if (M_IGEO(mp)->maxicount)
+		st->f_files = min_t(typeof(st->f_files), st->f_files,
+					M_IGEO(mp)->maxicount);
+
+	/* If sb_icount overshot maxicount, report actual allocation */
+	st->f_files = max_t(typeof(st->f_files), st->f_files,
+			mp->m_sb.sb_icount);
+
+	/* Make sure st->f_ffree does not underflow */
+	st->f_ffree = max_t(int64_t, 0, st->f_files - (icount - ifree));
+}
+
 STATIC int
 xfs_fs_statfs(
 	struct dentry		*dentry,
-	struct kstatfs		*statp)
+	struct kstatfs		*st)
 {
 	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
 	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
-	uint64_t		fakeinos, id;
-	uint64_t		icount;
-	uint64_t		ifree;
-	uint64_t		fdblocks;
-	xfs_extlen_t		lsize;
-	int64_t			ffree;
 
 	/*
 	 * Expedite background inodegc but don't wait. We do not want to block
@@ -840,56 +894,28 @@ xfs_fs_statfs(
 	 */
 	xfs_inodegc_push(mp);
 
-	statp->f_type = XFS_SUPER_MAGIC;
-	statp->f_namelen = MAXNAMELEN - 1;
-
-	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
-	statp->f_fsid = u64_to_fsid(id);
-
-	icount = percpu_counter_sum(&mp->m_icount);
-	ifree = percpu_counter_sum(&mp->m_ifree);
-	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
-
-	statp->f_bsize = sbp->sb_blocksize;
-	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
-	statp->f_blocks = sbp->sb_dblocks - lsize;
-
-	/* make sure statp->f_bfree does not underflow */
-	statp->f_bfree = max_t(int64_t, 0,
-				fdblocks - xfs_fdblocks_unavailable(mp));
-	statp->f_bavail = statp->f_bfree;
-
-	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
-	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
-	if (M_IGEO(mp)->maxicount)
-		statp->f_files = min_t(typeof(statp->f_files),
-					statp->f_files,
-					M_IGEO(mp)->maxicount);
-
-	/* If sb_icount overshot maxicount, report actual allocation */
-	statp->f_files = max_t(typeof(statp->f_files),
-					statp->f_files,
-					sbp->sb_icount);
-
-	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (icount - ifree);
-	statp->f_ffree = max_t(int64_t, ffree, 0);
+	st->f_type = XFS_SUPER_MAGIC;
+	st->f_namelen = MAXNAMELEN - 1;
+	st->f_bsize = mp->m_sb.sb_blocksize;
+	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev));
+		
+	xfs_statfs_data(mp, st);
+	xfs_statfs_inodes(mp, st);
 
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
-	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
-		s64	freertx;
-
-		statp->f_blocks = sbp->sb_rblocks;
-		freertx = percpu_counter_sum_positive(&mp->m_frextents);
-		statp->f_bavail = statp->f_bfree =
-			xfs_rtbxlen_to_blen(mp, freertx);
-	}
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME)))
+		xfs_statfs_rt(mp, st);
 
 	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
-		xfs_qm_statvfs(ip, statp);
+		xfs_qm_statvfs(ip, st);
 
+	/*
+	 * XFS does not distinguish between blocks available to privileged and
+	 * unprivileged users.
+	 */
+	st->f_bavail = st->f_bfree;
 	return 0;
 }
 
-- 
2.45.2

