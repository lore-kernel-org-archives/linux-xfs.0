Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AB7218D72
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191427; cv=none; b=lIubMoARranX/geX3qYjxgLaVkE7qUE3KoRpa/U/8Xfa9jk6EHqPcC3G1ahe4mo1ToWpOBiWMCP1yZ6FzkqZonLznbA4qxLrliqeCU4ZIdYnKcekL/+FbcDO+ctgzp/6UvNNXbo3IMQbHe11n6Wi7cfoT0/G5HaHAy8us4m2Gfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191427; c=relaxed/simple;
	bh=BNFWjkLUzE0vCwCjD48h24sd9P0c8J8fCAn2eHmK+ZA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lv3rHpToXpbsBviIEdME6ftgz9lrmO6I/S9rH5fA6Vl7tcoVT7F7Mcn1Z6oxD3QGonrR67Qi6qFJvp8UsmbKMBRqxHJjT24WveHoOz2Ai8zPYDL+BNbXVBQaXrnh8kRAsQCgBm3sfmY9HX3oVgHhVr6QZelwTS1yCdDJkHpEtvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnQ5xBYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnQ5xBYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1764C4CEC3;
	Thu, 17 Oct 2024 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191426;
	bh=BNFWjkLUzE0vCwCjD48h24sd9P0c8J8fCAn2eHmK+ZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gnQ5xBYsMgv4jHSwWc4gVIMmi/XpSUyRk6KzFtsFIi8Nr3DsLh55aG/P5dn79s2EN
	 +NPNHZDOtgHrEmz9Qr5bZRHF11pomoG24MucHEDEC7pXUxQSLK/J15782ksf/QyX8h
	 03DDvasHTqjOXQkF7qKW8h05VomhaHBAtEjkC2Iwx5hTu8gTtJCBmJYgbEU3gpe51H
	 iT2TTPljzXHOgldGaius2ZjhmWoFxgYZAUAJyhdjltF8qkdYawqgOFcpKJxyrISZGG
	 HYHzo1mU70fmjvYxwolV05bTBFTYSPm05pjQqBP4tP8xzRYo4QQ/b0RjJmW2wCB4aK
	 uf6YeVI0HEu8g==
Date: Thu, 17 Oct 2024 11:57:06 -0700
Subject: [PATCH 14/29] xfs: don't count metadata directory files to quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069691.3451313.5825170122895722304.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c       |    1 +
 fs/xfs/xfs_qm.c          |   11 +++++++++++
 fs/xfs/xfs_quota.h       |    5 +++++
 fs/xfs/xfs_trans_dquot.c |    6 ++++++
 4 files changed, 23 insertions(+)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c1b211c260a9d5..3bf47458c517af 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -983,6 +983,7 @@ xfs_qm_dqget_inode(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(xfs_inode_dquot(ip, type) == NULL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	id = xfs_qm_id_for_quotatype(ip, type);
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d0674d84af3ec5..ec983cca9adaed 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -304,6 +304,8 @@ xfs_qm_need_dqattach(
 		return false;
 	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
 	return true;
 }
 
@@ -326,6 +328,7 @@ xfs_qm_dqattach_locked(
 		return 0;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
 		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
@@ -1204,6 +1207,10 @@ xfs_qm_dqusage_adjust(
 		}
 	}
 
+	/* Metadata directory files are not accounted to user-visible quotas. */
+	if (xfs_is_metadir_inode(ip))
+		goto error0;
+
 	ASSERT(ip->i_delayed_blks == 0);
 
 	if (XFS_IS_REALTIME_INODE(ip)) {
@@ -1754,6 +1761,8 @@ xfs_qm_vop_dqalloc(
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
+	ASSERT(!xfs_is_metadir_inode(ip));
+
 	lockflags = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockflags);
 
@@ -1883,6 +1892,7 @@ xfs_qm_vop_chown(
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	/* old dquot */
 	prevdq = *IO_olddq;
@@ -1970,6 +1980,7 @@ xfs_qm_vop_create_dqattach(
 		return;
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 23d71a55bbc006..645761997bf2d9 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -29,6 +29,11 @@ struct xfs_buf;
 	 (XFS_IS_GQUOTA_ON(mp) && (ip)->i_gdquot == NULL) || \
 	 (XFS_IS_PQUOTA_ON(mp) && (ip)->i_pdquot == NULL))
 
+#define XFS_IS_DQDETACHED(ip) \
+	((ip)->i_udquot == NULL && \
+	 (ip)->i_gdquot == NULL && \
+	 (ip)->i_pdquot == NULL)
+
 #define XFS_QM_NEED_QUOTACHECK(mp) \
 	((XFS_IS_UQUOTA_ON(mp) && \
 		(mp->m_sb.sb_qflags & XFS_UQUOTA_CHKD) == 0) || \
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b368e13424c4f4..ca7df018290e0e 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -156,6 +156,8 @@ xfs_trans_mod_ino_dquot(
 	unsigned int			field,
 	int64_t				delta)
 {
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
+
 	xfs_trans_mod_dquot(tp, dqp, field, delta);
 
 	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
@@ -247,6 +249,8 @@ xfs_trans_mod_dquot_byino(
 	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
 		return;
 
+	ASSERT(!xfs_is_metadir_inode(ip) || XFS_IS_DQDETACHED(ip));
+
 	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
 		xfs_trans_mod_ino_dquot(tp, ip, ip->i_udquot, field, delta);
 	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
@@ -962,6 +966,8 @@ xfs_trans_reserve_quota_nblks(
 
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
+	if (xfs_is_metadir_inode(ip))
+		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);

