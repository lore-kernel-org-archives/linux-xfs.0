Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B368D1B6CEB
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 04:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742786; cv=none; b=PqGq+NHf2/cWKzvIqOUuzOAWlj3NyrH2k+wsZjNFR3/egzNLXbVQ7txGxTgzXv9reJ7MQCVNu9AipCt3TqN2f/+Nt+eKfgP7GgY77mvDQRa8Tg6ZYrRGqp1PGHQAnwNEa1mOxzIcw8+AD1Ar0NGhrxjlKP0Y0nqmywiG9pNEdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742786; c=relaxed/simple;
	bh=jA4BWRqBvpxBltY6LkM7CaTd714mx3FBVAfEVyGnCMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWHdbw2s222WLmYUlt2OyWoDb5d9GjHP3gFK406DQfZ6iogt1xJMw4KveCSuvQQmstj6AwNGq7qSpDzzCe0cjWergM7cCk7B6WJEMXPo/aSX4ZYmsziAl9bxOsfOXKPI0IbRwuMlZBHz2OXjuyDYzn01saSZAHCwJH6ohrAC5q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X/QLJfhL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X/QLJfhL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ix8Raiu4FcPqGLF7HD2AsWZdK45IeGD8T2tMtoTHMis=; b=X/QLJfhLOrKN+LFmKA0ZRFE+vE
	kWOCQtAcIkQEk42T5O9MVgtcWno0GBTpy82bieI7U8Iqf3AW4ijTI4YWrR6gEbJSt5cb2UokF910t
	DEeL4XK2dNWlR/UyGLZaJLIicmKTHf9BjEbYbru2bxXSMZ0jwY+FGmKy0PoinKIzPRfcpBYqnxCAD
	2zca08l8NtyXt/E9hsguat1m/sj4cMnJog2hYASskIEzbCjY9SjVREjpws22FoeOk1QyH0zuhgq7z
	nCs7mJD7s641LTz/1T8uoR8YTuVlWaUO1u6/J4nUbYhlc4zjGHxqUu/on7AdP/zXuv0pKR7xkFWUa
	iOOyykIA==;
Received: from 2a02-8389-2341-5b80-421b-ad95-8448-da51.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:421b:ad95:8448:da51] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXC8O-00000003zWr-0YCd;
	Mon, 13 Jan 2025 04:33:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: refactor xfs_fs_statfs
Date: Mon, 13 Jan 2025 05:32:59 +0100
Message-ID: <20250113043259.2054322-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113043259.2054322-1-hch@lst.de>
References: <20250113043259.2054322-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split out helpers for data, rt data and inode related information, and
assigning f_bavail once instead of in three places.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm_bhv.c |   1 -
 fs/xfs/xfs_super.c  | 132 ++++++++++++++++++++++++++------------------
 2 files changed, 78 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index db5b8afd9d1b..37f1230e7584 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -40,7 +40,6 @@ xfs_fill_statvfs_from_dquot(
 
 		statp->f_blocks = min(statp->f_blocks, limit);
 		statp->f_bfree = min(statp->f_bfree, remaining);
-		statp->f_bavail = min(statp->f_bavail, remaining);
 	}
 
 	limit = dqp->q_ino.softlimit ?
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 20cc00b992a6..809ac6d1813c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -819,81 +819,105 @@ xfs_fs_sync_fs(
 	return 0;
 }
 
-STATIC int
-xfs_fs_statfs(
-	struct dentry		*dentry,
-	struct kstatfs		*statp)
+static xfs_extlen_t
+xfs_internal_log_size(
+	struct xfs_mount	*mp)
 {
-	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
-	xfs_sb_t		*sbp = &mp->m_sb;
-	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
-	uint64_t		fakeinos, id;
-	uint64_t		icount;
-	uint64_t		ifree;
-	uint64_t		fdblocks;
-	xfs_extlen_t		lsize;
-	int64_t			ffree;
-
-	/*
-	 * Expedite background inodegc but don't wait. We do not want to block
-	 * here waiting hours for a billion extent file to be truncated.
-	 */
-	xfs_inodegc_push(mp);
-
-	statp->f_type = XFS_SUPER_MAGIC;
-	statp->f_namelen = MAXNAMELEN - 1;
-
-	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
-	statp->f_fsid = u64_to_fsid(id);
+	if (!mp->m_sb.sb_logstart)
+		return 0;
+	return mp->m_sb.sb_logblocks;
+}
 
-	icount = percpu_counter_sum(&mp->m_icount);
-	ifree = percpu_counter_sum(&mp->m_ifree);
-	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
+static void
+xfs_statfs_data(
+	struct xfs_mount	*mp,
+	struct kstatfs		*st)
+{
+	int64_t			fdblocks =
+		percpu_counter_sum(&mp->m_fdblocks);
 
-	statp->f_bsize = sbp->sb_blocksize;
-	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
+	/* make sure st->f_bfree does not underflow */
+	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
 	/*
 	 * sb_dblocks can change during growfs, but nothing cares about reporting
 	 * the old or new value during growfs.
 	 */
-	statp->f_blocks = sbp->sb_dblocks - lsize;
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
+	st->f_bfree = xfs_rtbxlen_to_blen(mp,
+			percpu_counter_sum_positive(&mp->m_frextents));
+	st->f_blocks = mp->m_sb.sb_rblocks;
+}
 
-	/* make sure statp->f_bfree does not underflow */
-	statp->f_bfree = max_t(int64_t, 0,
-				fdblocks - xfs_fdblocks_unavailable(mp));
-	statp->f_bavail = statp->f_bfree;
+static void
+xfs_statfs_inodes(
+	struct xfs_mount	*mp,
+	struct kstatfs		*st)
+{
+	uint64_t		icount = percpu_counter_sum(&mp->m_icount);
+	uint64_t		ifree = percpu_counter_sum(&mp->m_ifree);
+	uint64_t		fakeinos = XFS_FSB_TO_INO(mp, st->f_bfree);
 
-	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
-	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
+	st->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
 	if (M_IGEO(mp)->maxicount)
-		statp->f_files = min_t(typeof(statp->f_files),
-					statp->f_files,
+		st->f_files = min_t(typeof(st->f_files), st->f_files,
 					M_IGEO(mp)->maxicount);
 
 	/* If sb_icount overshot maxicount, report actual allocation */
-	statp->f_files = max_t(typeof(statp->f_files),
-					statp->f_files,
-					sbp->sb_icount);
+	st->f_files = max_t(typeof(st->f_files), st->f_files,
+			mp->m_sb.sb_icount);
 
-	/* make sure statp->f_ffree does not underflow */
-	ffree = statp->f_files - (icount - ifree);
-	statp->f_ffree = max_t(int64_t, ffree, 0);
+	/* Make sure st->f_ffree does not underflow */
+	st->f_ffree = max_t(int64_t, 0, st->f_files - (icount - ifree));
+}
 
-	if (XFS_IS_REALTIME_MOUNT(mp) &&
-	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
-		s64	freertx;
+STATIC int
+xfs_fs_statfs(
+	struct dentry		*dentry,
+	struct kstatfs		*st)
+{
+	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
+	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 
-		statp->f_blocks = sbp->sb_rblocks;
-		freertx = percpu_counter_sum_positive(&mp->m_frextents);
-		statp->f_bavail = statp->f_bfree =
-			xfs_rtbxlen_to_blen(mp, freertx);
-	}
+	/*
+	 * Expedite background inodegc but don't wait. We do not want to block
+	 * here waiting hours for a billion extent file to be truncated.
+	 */
+	xfs_inodegc_push(mp);
+
+	st->f_type = XFS_SUPER_MAGIC;
+	st->f_namelen = MAXNAMELEN - 1;
+	st->f_bsize = mp->m_sb.sb_blocksize;
+	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev));
+
+	xfs_statfs_data(mp, st);
+	xfs_statfs_inodes(mp, st);
+
+	if (XFS_IS_REALTIME_MOUNT(mp) &&
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

