Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7004F37E2EE
	for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 11:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784460632; cv=none; b=GhzDg6OtcREraQASWIY2oj9YNcUkOj2ehmpyG6Ml2ShEsSk8zA2PNv0UkC636nThDtLUoPtgb7PnQIgxFhbKwSQQIqHIWNgWzB39IrAFB6yQ8zJskbVtcA2Ez3lU3p9JKhx1s5MwG5mZ/8GGcCoKjdeg6N9zzEwrbm6/Q5ywAuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784460632; c=relaxed/simple;
	bh=4hQ/kd46tBOE54pT9yNBScCOaCV7TAEvDaGupEqi+l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tT7X/Ay8cI1sRkhpbXg9Q6ZQCQ1e+7aO/AWsdfXmlnA7DAJdHmiHLHf4e/DIwlpQeJCB9NBkujCJ0owNfkLWtuSPn0uJa6ah6m+Sp9SaGkGOcNtkNQplheoOBzOpTjnlOqGqkedm1x5fiaBfZsLOiQBBkmb3IMkTpCpvbMYPPpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sujxJqox; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sujxJqox"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ccdb73f0e1so52023005ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 19 Jul 2026 04:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784460627; x=1785065427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LfwjIb9K32R1YmqSTFqp7DJ6+dJC07T6UPOCV+XSImc=;
        b=sujxJqoxkVE1efe3AvZZhaSciTdz98+357t+7rC4sFKecZ7F5tyuXzGdivO8VSxLBS
         v+lOxmS20YFul7Wjh55D8tMXguAjy1bfiqVUIOH+2AkpDbHoWA1e0Btc1Sh6i9e5hZdX
         lisU13Npr0Lta+KOTCeEMoVhwVgAtHwidvtzdv9w9snbAOe+bcRsYpF9nraqDnN5estG
         bxV8jlidI8Lra+DQOzjGQDftI7pz9qc/63w7K++T8EVzrI40w3PThFkIYZTdmLvxwK14
         I8oZmQVHrPcE0EHe9RgPhF9STOKQc0zfaH4nb7oXgX7DAMeGrrLqUnv6QvcgI2WhrTYA
         2Rgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784460627; x=1785065427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LfwjIb9K32R1YmqSTFqp7DJ6+dJC07T6UPOCV+XSImc=;
        b=DTbbHQ/4yERSgJ1T+961j9+jxx40gV2/fVqa/qKQMb7Am28gF9u6yltPLsQMLlLR0z
         HEnSKSMFTA9Hu8IrlHKS5TaASAFz+GKpJ02/TV8RLWgQWMlAWl8G79yCrHGsgS/wpUXN
         k5DIeCp4uQarpJkr4usni5iT8g9OhcVT7hwe6umuhyh/q2nBjkm93wZgcy84EqLFbHJ1
         sV/6LAJ38ByJnqcl/XIHl9I42I5enmBjYN93pa+//EKRtRELgsWn9dp/CfBMPqsHQI0l
         /Qdc43GwFD+KfdH2pKYWeOBlNFIdVntPscFxPBah61GPumVeNc0Nf42JlPIrkkKuSp8x
         bDrg==
X-Gm-Message-State: AOJu0YzHAsi5IBVid9N/Bg2qnG19X8LSAGgM+pXe653GNCu8a7g+XAaw
	LvS4bvJyR2WJCDol/MiHjONI6a6X+x5A+dB4lXM14V2AkKrrqM6kTy2O
X-Gm-Gg: AfdE7cmLMjZqTLJFGnnlDEvoBdHovLqVaU0i1mvdk5Y/gjjkZjO9V8w6zeqitmNY3Ds
	PTD7FvC04/Zj5BmoEYIMByd1BhDW549X214+omqvq2851P9ZUUniKFHX9FYn/4QrOKq0qQe/qJW
	3WrQuf3yXI5FOEezm4lR8JP6veBZwBZyjTBFuffm1sV9dYeaxGAU+s0Ms9LKd1Z3HKM8fAA3l99
	ocG3GNXRcPRTKSwAdVxXuJKJirTFQRqr7pR9SAx7b+kuYQ/zNsYjelfOcrajBWjoswlhfwvCxh2
	zrqof7Br52zQof6wbjUvFvAyrrAhJEnlhNnfv9WpUIWaD1YKiygXZyH2sGmKOO0sE97n1TKx2yU
	Pa+OFjYiND+mLWUZjqCg0SWAtGpoSFogNGFpOwvrFdv7XSs2GxllCevVPhOdiheF+Gh9S0qKcKM
	oDt8z+4SoLJgQNgx5xnv8IS/9aWO+QRbpEorzCcIDwUVi2e+3XXl15uwX7LQ==
X-Received: by 2002:a17:902:e80e:b0:2cc:8267:31b5 with SMTP id d9443c01a7336-2cf3489a830mr103197365ad.19.1784460627295;
        Sun, 19 Jul 2026 04:30:27 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2ddfb35sm22035031c88.14.2026.07.19.04.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 04:30:26 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xmei5@asu.edu,
	Weiming Shi <bestswngs@gmail.com>,
	Dave Chinner <dgc@kernel.org>
Subject: [PATCH v3 3/3] xfs: add an inode log item recovery verifier
Date: Sun, 19 Jul 2026 04:29:23 -0700
Message-ID: <20260719112923.226550-4-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719112923.226550-1-bestswngs@gmail.com>
References: <20260719112923.226550-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous patches let each log item type validate its own formatted
structures through an xlog_recover_item_ops->verify method, run once the
item is fully decoded. Add the first verifier, for inode items.

Log recovery previously validated a recovered inode item's structures
inside the pass2 decode and replay code, one open-coded check at a time,
which was hard to read and to audit for what was still unchecked.
xlog_recover_inode_verify() instead checks in one place that the core and
each fork region implied by ilf_fields is declared, that the log dinode is
present and large enough, that its version matches the mount, that
di_forkoff is within the literal area, and that the verbatim-copied fork
regions fit their destination fork.

Because the log dinode checks now run before pass2, drop the equivalent
open-coded checks (the log dinode magic and the dead di_forkoff bound)
from xlog_recover_inode_commit_pass2(). The checks that need the on-disk
inode buffer (its magic, the LSN and di_flushiter replay-ordering
decisions, the di_mode/di_format consistency, and the final
xfs_dinode_verify()) cannot be hoisted and stay in pass2.

This covers the self-contained log dinode structure. The btree-root fork
formats are converted from a larger in-core form on replay and their
record count is not bounded here yet; clamping xfs_bmbt_to_bmdr() and the
rt btree converters against the destination fork is left as follow-up.

Suggested-by: Dave Chinner <dgc@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_inode_item_recover.c | 87 +++++++++++++++++++++++++++------
 1 file changed, 71 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 6b6ac92964d0..8308f064cecc 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -367,13 +367,6 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 	ldip = item->ri_buf[1].iov_base;
-	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
-		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %lld",
-			__func__, item, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
 
 	/*
 	 * If the inode has an LSN in it, recover the inode only if the on-disk
@@ -462,15 +455,6 @@ xlog_recover_inode_commit_pass2(
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
@@ -597,10 +581,81 @@ xlog_recover_inode_commit_pass2(
 	return error;
 }
 
+/*
+ * Validate the log dinode and fork regions of a decoded inode item.  Checks
+ * that need the on-disk inode buffer stay in xlog_recover_inode_commit_pass2().
+ */
+STATIC int
+xlog_recover_inode_verify(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_inode_log_format	*in_f;
+	struct xfs_inode_log_format	in_f_buf;
+	struct xfs_log_dinode		*ldip;
+	unsigned int			litino = XFS_LITINO(mp);
+	unsigned int			dsize, asize;
+	int				attr_index;
+	int				error;
+
+	if (item->ri_buf[0].iov_len == sizeof(struct xfs_inode_log_format)) {
+		in_f = item->ri_buf[0].iov_base;
+	} else {
+		in_f = &in_f_buf;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			return error;
+	}
+
+	/* The inode core is always logged as the log dinode in ri_buf[1]. */
+	if (XFS_IS_CORRUPT(mp, in_f->ilf_size < 2) ||
+	    XFS_IS_CORRUPT(mp,
+			   item->ri_buf[1].iov_len < xfs_log_dinode_size(mp)))
+		return -EFSCORRUPTED;
+
+	ldip = item->ri_buf[1].iov_base;
+	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC) ||
+	    XFS_IS_CORRUPT(mp, !xfs_dinode_good_version(mp, ldip->di_version)) ||
+	    XFS_IS_CORRUPT(mp, ldip->di_forkoff >= (litino >> 3)))
+		return -EFSCORRUPTED;
+
+	if (ldip->di_forkoff) {
+		dsize = ldip->di_forkoff << 3;
+		asize = litino - (ldip->di_forkoff << 3);
+	} else {
+		dsize = litino;
+		asize = 0;
+	}
+
+	/*
+	 * Btree-root forks are logged in a larger in-core form and converted on
+	 * replay, so their region is not bounded by the on-disk fork size here.
+	 */
+	if (in_f->ilf_fields & XFS_ILOG_DFORK) {
+		if (XFS_IS_CORRUPT(mp, in_f->ilf_size < 3))
+			return -EFSCORRUPTED;
+		if ((in_f->ilf_fields & XFS_ILOG_DFORK) != XFS_ILOG_DBROOT &&
+		    XFS_IS_CORRUPT(mp, item->ri_buf[2].iov_len > dsize))
+			return -EFSCORRUPTED;
+	}
+	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		attr_index = (in_f->ilf_fields & XFS_ILOG_DFORK) ? 3 : 2;
+		if (XFS_IS_CORRUPT(mp, in_f->ilf_size < attr_index + 1))
+			return -EFSCORRUPTED;
+		if ((in_f->ilf_fields & XFS_ILOG_AFORK) != XFS_ILOG_ABROOT &&
+		    XFS_IS_CORRUPT(mp, item->ri_buf[attr_index].iov_len > asize))
+			return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
 	.max_regions		= 4,
 	.min_regions		= 2,
+	.verify			= xlog_recover_inode_verify,
 	.ra_pass2		= xlog_recover_inode_ra_pass2,
 	.commit_pass2		= xlog_recover_inode_commit_pass2,
 };
-- 
2.43.0

