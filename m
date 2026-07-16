Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411CE442FB4
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224109; cv=none; b=EQ+a8XIOB2Y4jMHLBkuZs4rJsJ6zYSgDMknQ2QWU0DvqWN9mXiSbNpqAaQ5RzIe93eext00y+28/tHYGULE2O5Zi94RdCdbnrC/OcWY4l5N58SAiPb8zcpkibDP/aOLnr5nAdhgZ+h3WYYIu35KQyfXlICzj1hBo+HwkZimrPX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224109; c=relaxed/simple;
	bh=YGc51cKV08fdpk/zlvxKW9ZeOUArG4qQ7egV/9qqy68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M+ZcNNT8Qcv+GryIQVC/RcGRodFHuXTPcJ42xbUW0exCQay5CsB76hq+B5lzsMmapcClxAd7J9fC+hk65OVxUMG0cxkH4hZ2IleUE+oZi4gOfFNl87CuuAOth692fQumOnqQRtBWa6GfmaR3QqtMUX5RKMWFXCQ0v9HN2epJ1S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WC+JPqyE; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WC+JPqyE"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso7669155b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 10:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784224106; x=1784828906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oufZTAHkcj+wRfEHH3PxAhK7cPvNxgoKw6tBSv9kYLQ=;
        b=WC+JPqyETg2tR/XRWySwqde3UaGtYiX2+Hmidf4KRHHTSBtQWxWj/Y3TpJ4tCKhgi4
         uPT/KvYq/F6N0UBvEEXh9wZ8C5gTqnJDZ2iRxs3iP0t1EY04mEokVxmwVVWjWx12/CPs
         bKw1TONFubSV/HwNobLxTFkqAYoP0LHEs6k1U3y71wM/5JichY/9FFAmkVSnA0cv2W5A
         Kff2DnZ4UW9QywI+anmxaOlTuiBJJWuZFCQk4r4/q+0C3WGEtG5ktFz/1ryAM5IApopE
         15pgftC2HmOWyl9rdwuBKnTfm8g+ixLUQCoHboXpC5B5u4EHqtAippNe1QTRyDppSRGv
         1NXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784224106; x=1784828906;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oufZTAHkcj+wRfEHH3PxAhK7cPvNxgoKw6tBSv9kYLQ=;
        b=d9IK5dAS0cBi1+LpLvUSfaBQhNEHoqnFES1E40O58k1xiuCaOvK+kgtf9OLH9bJtXp
         ulRvQADqFBs+SB1tFGo3oqzKXxOA2UfqbUmUoVbjd5l5mVYSl4cYjIkLAxVz1x8PZjjy
         p++NKHmE1bhlIQIoqzBiu+P1YHWF6hQV/4b1SF9fdRCJieV0bMmWEcvb+ZWVw7VUCQAg
         guXz8zML+UHFz0Pn7mK7pnrqn6qQw73Ro2lBpHl8hVCGNqZtDB7vBsJ/sSztOGivQWyz
         +93gTII3kI+AkFVodhjSLhQw0cJp26UIbyNElXDgAdBHTtJvfsqWYdndD5OmoI+/fpEM
         E6NA==
X-Gm-Message-State: AOJu0YwYWivnUSVEiF3ogUkJZ270TlnPBffe5WR3YvMmDQHCXw02IZkd
	3wZ2uOfqZmjvCYtzL7BbTQbO5pWgr76rx205pjlMrKY3VUEqNgS9Xn3W
X-Gm-Gg: AfdE7ckWHMzyjnLNBPPcxoM6JZTeOhftgGULx0R5+lLAY9tyAk4s1qkkglV4Df4QjXE
	LrW8HgSAgWOjVMsf3BhR8ozU7NZ/e6kLNhzvIY6GUrfjvaQx+b40Py2252A0A+wMGcDfyrpSEOu
	UKEDp8zdJF4yzkttLrANENxRImjdTzFhhPorgwO+uaSjb5xb8we3PgbROEJL6XZJ539weUnwfJz
	wd1KotAqNr/+CC3NjJEhv8ZyJom1LX6aXqBVLk4WPThiYPkJ87Pa2Cabv6NBPEGTzepTodXSVoZ
	HsQtE5HtWNd+aS1ZIZWffzRf/7luk9F1qexfwhLdf6mcgtYkDibXlDahEDQ8mZUNlWzILmgcDuA
	M8rSs8HQw9QOzgSeYqVgqRHbeUDIsoVHG/oPdYcHkTEiNxnRbz4ojUgbObsPFHQkkdlW2vi+lOm
	gqwsPPQfwTXWNcNDtW9HQvhkfDacOsRK4jsYpNdgHfNtf+t3o=
X-Received: by 2002:a05:6a21:6b02:b0:3c3:96dd:9ecc with SMTP id adf61e73a8af0-3c396dda171mr2914910637.57.1784224105501;
        Thu, 16 Jul 2026 10:48:25 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6c10dcsm15626484eec.23.2026.07.16.10.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 10:48:25 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] xfs: validate inode log item regions during recovery
Date: Thu, 16 Jul 2026 10:48:12 -0700
Message-ID: <20260716174813.3627911-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recover_inode_commit_pass2() replays an XFS_LI_INODE item straight
out of the log: it dereferences ri_buf[1] as the log dinode and copies the
data and attr forks from ri_buf[2]/ri_buf[attr_index], but never checks
that those regions were logged or that the dinode geometry agrees with the
mount. ri_buf is sized by the item's ilf_size, bounded only to
[1, XLOG_MAX_REGIONS_IN_ITEM]; the number of regions actually filled in
(ri_cnt) and the fork copies are guarded only by ASSERT()s, which compile
out in production.

A crafted image mounted for log recovery can thus hit a NULL dereference of
an absent region, an out-of-bounds read from a di_version or di_forkoff
that disagrees with the mount, or an overflow of the inode fork by an
oversized local or extent region. An item declaring a second region that
is never logged faults on the log dinode:

 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: xlog_recover_inode_commit_pass2 (fs/xfs/xfs_inode_item_recover.c:370)
 Call Trace:
  xlog_recover_items_pass2 (fs/xfs/xfs_log_recover.c:2011)
  xlog_recover_commit_trans (fs/xfs/xfs_log_recover.c:2078)
  xlog_recovery_process_trans (fs/xfs/xfs_log_recover.c:2328)
  xlog_recover_process_data (fs/xfs/xfs_log_recover.c:2502)
  xlog_recover (fs/xfs/xfs_log_recover.c:3486)
  xfs_log_mount (fs/xfs/xfs_log.c:667)
  xfs_mountfs (fs/xfs/xfs_mount.c:1039)
  xfs_fs_fill_super (fs/xfs/xfs_super.c:1965)
  get_tree_bdev_flags (fs/super.c:1680)
  vfs_get_tree (fs/super.c:1803)
  __x64_sys_mount (fs/namespace.c:4433)

Validate the regions before use: require ri_cnt to cover the regions
ilf_fields implies, the log dinode to be present and at least a log dinode
in size, and di_version to match the mount. Replace the di_forkoff check,
which can never fire (di_forkoff is a u8 of 8-byte units, sb_inodesize a
byte count of at least 256), with xfs_dinode_verify_forkoff() (exported
here), and bound the local and extent fork copies against the destination
fork. The btree-root formats are logged in their larger in-core form and
converted on the way in, so they are not bounded by the on-disk fork size.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.h   |  2 ++
 fs/xfs/xfs_inode_item_recover.c | 59 ++++++++++++++++++++++++---------
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 336ef843f2fe..71311c4fc2ed 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -479,7 +479,7 @@ xfs_dinode_verify_fork(
 	return NULL;
 }
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dinode_verify_forkoff(
 	struct xfs_dinode	*dip,
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f3624532b023..d120675f6c07 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -27,6 +27,8 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_forkoff(struct xfs_dinode *dip,
+			   struct xfs_mount *mp);
 xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
 		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 169a8fe3bf0a..8ebc8eaf9e03 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -366,6 +366,13 @@ xlog_recover_inode_commit_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
+	/* ri_buf[1] may be absent or shorter than a log dinode */
+	if (XFS_IS_CORRUPT(mp, item->ri_cnt < 2) ||
+	    XFS_IS_CORRUPT(mp,
+			   item->ri_buf[1].iov_len < xfs_log_dinode_size(mp))) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 	ldip = item->ri_buf[1].iov_base;
 	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
 		xfs_alert(mp,
@@ -374,6 +381,11 @@ xlog_recover_inode_commit_pass2(
 		error = -EFSCORRUPTED;
 		goto out_release;
 	}
+	/* the size gate and fork offsets assume the mount's inode version */
+	if (XFS_IS_CORRUPT(mp, !xfs_dinode_good_version(mp, ldip->di_version))) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	/*
 	 * If the inode has an LSN in it, recover the inode only if the on-disk
@@ -462,15 +474,6 @@ xlog_recover_inode_commit_pass2(
 	if (error)
 		goto out_release;
 
-	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("Bad log dinode fork offset",
-				XFS_ERRLEVEL_LOW, mp, ldip, sizeof(*ldip));
-		xfs_alert(mp,
-			"Bad inode 0x%llx, di_forkoff 0x%x",
-			in_f->ilf_ino, ldip->di_forkoff);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 	isize = xfs_log_dinode_size(mp);
 	if (unlikely(item->ri_buf[1].iov_len > isize)) {
 		XFS_CORRUPTION_ERROR("Bad log dinode size", XFS_ERRLEVEL_LOW,
@@ -495,6 +498,30 @@ xlog_recover_inode_commit_pass2(
 	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
 
 	fields = in_f->ilf_fields;
+
+	/* forks are otherwise ASSERT-only; check di_forkoff and presence */
+	if (fields & (XFS_ILOG_DFORK | XFS_ILOG_AFORK)) {
+		if (XFS_IS_CORRUPT(mp, xfs_dinode_verify_forkoff(dip, mp) != NULL)) {
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+	if (fields & XFS_ILOG_DFORK) {
+		if (XFS_IS_CORRUPT(mp, item->ri_cnt < 3) ||
+		    XFS_IS_CORRUPT(mp, item->ri_buf[2].iov_base == NULL)) {
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+	if (fields & XFS_ILOG_AFORK) {
+		attr_index = (fields & XFS_ILOG_DFORK) ? 3 : 2;
+
+		if (XFS_IS_CORRUPT(mp, item->ri_cnt < attr_index + 1) ||
+		    XFS_IS_CORRUPT(mp, item->ri_buf[attr_index].iov_base == NULL)) {
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
 	if (fields & XFS_ILOG_DEV)
 		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
 
@@ -510,6 +537,10 @@ xlog_recover_inode_commit_pass2(
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
+		if (XFS_IS_CORRUPT(mp, len > XFS_DFORK_DSIZE(dip, mp))) {
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
 		memcpy(XFS_DFORK_DPTR(dip), src, len);
 		break;
 
@@ -533,11 +564,6 @@ xlog_recover_inode_commit_pass2(
 	 * transaction.
 	 */
 	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
-		if (in_f->ilf_fields & XFS_ILOG_DFORK) {
-			attr_index = 3;
-		} else {
-			attr_index = 2;
-		}
 		len = item->ri_buf[attr_index].iov_len;
 		src = item->ri_buf[attr_index].iov_base;
 		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
@@ -546,7 +572,10 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
+			if (XFS_IS_CORRUPT(mp, len > XFS_DFORK_ASIZE(dip, mp))) {
+				error = -EFSCORRUPTED;
+				goto out_release;
+			}
 			memcpy(dest, src, len);
 			break;
 
-- 
2.43.0

