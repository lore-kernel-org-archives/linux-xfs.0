Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3FEBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOX/xOmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC99C433C7;
	Sun, 31 Dec 2023 21:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057087;
	bh=v70jB/4/cp/ZoIDa6ydgwCdkpwdITvkxA4PsIdL+4Qs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dOX/xOmwYSrD2JBYDXvYHSivLDVy6wEIsjGQvM+3882hu7JRpX4ESFJXA8+IotcjX
	 50MSRFIj2Sm9/ZZXnTHwDGfi0kKKTu8uoFT06H/Mun2PWI5HpnDXr+WIbVL/5w1mCS
	 pEoYMIoGMZ5q0WAq1i8rgHzEBmqTyQAHg70iICEsNNmmfsZSPnZUtQpPVypUxJySyv
	 G+pChE4GO0baRgFHC26ekXXta1Q6Rbe2r3EtlSstxdqu44njteLyVrdDVxhGwF5Og9
	 a0psZUcvG0ckesYKzohjTZ/usk6Xh0Ca+HmljcQOK61JagiDBMY9azJUKo9ToLUBgq
	 1aVX4g3kaf7Vg==
Date: Sun, 31 Dec 2023 13:11:26 -0800
Subject: [PATCH 20/32] xfs: don't count metadata directory files to quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404845188.1760491.8439131182244027443.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
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

Files in the metadata directory tree are internal to the filesystem.
Don't count the inodes or the blocks they use in the root dquot because
users do not need to know about their resource usage.  This will also
quiet down complaints about dquot usage not matching du output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c       |    1 +
 fs/xfs/xfs_qm.c          |   11 +++++++++++
 fs/xfs/xfs_quota.h       |    5 +++++
 fs/xfs/xfs_trans_dquot.c |    6 ++++++
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bc1893a4b6738..55b2bc1d7d5db 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -979,6 +979,7 @@ xfs_qm_dqget_inode(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	id = xfs_qm_id_for_quotatype(ip, type);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 1d28f0982840c..a6b5193190c4c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -305,6 +305,8 @@ xfs_qm_need_dqattach(
 		return false;
 	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
 	return true;
 }
 
@@ -327,6 +329,7 @@ xfs_qm_dqattach_locked(
 		return 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
@@ -1253,6 +1256,10 @@ xfs_qm_dqusage_adjust(
 		}
 	}
 
+	/* Metadata directory files are not accounted to user-visible quotas. */
+	if (xfs_is_metadir_inode(ip))
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1775,6 +1782,8 @@ xfs_qm_vop_dqalloc(
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
+	ASSERT(!xfs_is_metadir_inode(ip));
+
 	lockflags = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockflags);
 
@@ -1904,6 +1913,7 @@ xfs_qm_vop_chown(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	/* old dquot */
 	prevdq = *IO_olddq;
@@ -1991,6 +2001,7 @@ xfs_qm_vop_create_dqattach(
 		return;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index fe63489d91b2f..55320c9ff1367 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -29,6 +29,11 @@ struct xfs_buf;
 	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
 	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
 
+#define XFS_IS_DQDETACHED(mp, ip) \
+	((ip)->i_udquot == NULL || \
+	 (ip)->i_gdquot == NULL || \
+	 (ip)->i_pdquot == NULL)
+
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 833a65be05705..6983e35b7c2b7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -156,6 +156,8 @@ xfs_trans_mod_ino_dquot(
 	unsigned int			field,
 	int64_t				delta)
 {
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(mp, ip));
+
 	xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
@@ -236,6 +238,8 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(mp, ip));
+
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		xfs_trans_mod_ino_dquot(tp, ip, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
@@ -951,6 +955,8 @@ xfs_trans_reserve_quota_nblks(
 
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
+	if (xfs_is_metadir_inode(ip))
+		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));

