Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8BD4C9F;
	Thu, 26 Sep 2024 00:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727312235; cv=none; b=jSzjtemOZazv1PI4rgR3Zv+gjHYQuOFlN3gs8jIHQgu7idKNaS2wqvQGbFyOs+bmhNYuyXWKyLVp6PJfkL1/ma3eQxaB4A4S3CUKHtF2tRNl9HNzBzeSrQWi7hmA2HJhfdfQEhl4qV81Er3+ivWh3qFjvXUiXFf7WXOCl1HE45Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727312235; c=relaxed/simple;
	bh=qW0K5uatFHE7rR5shvVmbsF8Wpm+9mRBf4+83NfGVGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F+uoSFC8zHS6PU8iy5j4MrTSWYBWA+Lq/IQcDhIX6wQjE8qqJvYWervTLfI+pSnwnQPO+aPj4gUk10H0gmSsDukLEC5af3w1J0fL93VVO0jkWQp/daZBfL9ZXFdP5r3cwZ3/kHCXdmo18ldT70HO6ugmGvQYtd1BBgrWquRniEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VJJctTdc; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VJJctTdc"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7e6afa8baeaso339588a12.3;
        Wed, 25 Sep 2024 17:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727312233; x=1727917033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IvbQlSbyqhVDU32DfnPYwRf9tiBCmk8+kNrAPBvQAfg=;
        b=VJJctTdcI2dr/sejGJcxASdEYxpVlz6ktHWfUBbI8zIUOWQ9/dKWyZg/CIi7qfoPS5
         CwF2NksETxbkogQzPBf7mvvZYla2lzdiQ6GqGp/JSTLfaVhqebW59dMMbLoRrbLIWSU4
         LxSvMziP4BLYr6cjfRo6+duKok4s+fSIcFOdhmNFaNE7NhR6622+NWUTCxmTQPFVaQHx
         j4jUaFVT2UgXKEstuKNpS+yk//Q5oxKPRRO1ojTzyaoJz9wTMnhAV40qzuQpU0WInQO3
         nfKjVXTeztW23hmmuy3omlxCGBa1MfNq0mbZRYtH3JbuKHsIqZdZh6wEtpreLLKnCTuz
         pfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727312233; x=1727917033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IvbQlSbyqhVDU32DfnPYwRf9tiBCmk8+kNrAPBvQAfg=;
        b=shN8yaqmWI5NStYyvbRvnC/MfBlHlnZ7PUCkwAXIIGlyZRbT7rkGYKlBJnkBcD/4aU
         QlLzIXx+pMJz2pKOA+OVBAmqxBO70KF7+FgI1jeYCdIkOdCqgewDRu4VhSKpwBwH6Gl2
         TJHNxkK44fUbUQbS1M8H/DY3iIs/5T2//R8MlQm9WBlyxhOkmg7K+nPesXDNl608PcG/
         hBKP+RJRXbrOTpPFCAjkeM2jzfNV9Dds+GxEzJMD/6QVqSjzeEfQ1qfNIDyPnAUztGHl
         FBAoQUSx6cMx/Q/ATwBKMf8t+mGFEFMsRNoFV6IVEoUzUEkN/AzDrMtOo0WgHGSYt716
         RMaw==
X-Gm-Message-State: AOJu0YzNnU4XNDol8wGWD5GTXRrR+YFZfUIuMYJu9NIN58poxzaIPMhS
	AFReWpbTH0jCkN6Ig3QJ+sALluyEBAM9VWiUvbt97zTZFuoyDGL8H1aZ6Dh7
X-Google-Smtp-Source: AGHT+IHNHF77vdHvmLnBe81F9Ogv9q38n42FmSAbbrtHMsM4blSpQ7C7aiGeeGwST4eMCXPKTsJSIA==
X-Received: by 2002:a17:90a:f596:b0:2c9:7611:e15d with SMTP id 98e67ed59e1d1-2e06ae7752cmr5703436a91.20.1727312232582;
        Wed, 25 Sep 2024 17:57:12 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:7284:a33f:e55:3131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e06e2da3e7sm2093238a91.57.2024.09.25.17.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 17:57:12 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 27/26] xfs: journal geometry is not properly bounds checked
Date: Wed, 25 Sep 2024 17:57:05 -0700
Message-ID: <20240926005705.2896598-1-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit f1e1765aad7de7a8b8102044fc6a44684bc36180 ]

If the journal geometry results in a sector or log stripe unit
validation problem, it indicates that we cannot set the log up to
safely write to the the journal. In these cases, we must abort the
mount because the corruption needs external intervention to resolve.
Similarly, a journal that is too large cannot be written to safely,
either, so we shouldn't allow those geometries to mount, either.

If the log is too small, we risk having transaction reservations
overruning the available log space and the system hanging waiting
for space it can never provide. This is purely a runtime hang issue,
not a corruption issue as per the first cases listed above. We abort
mounts of the log is too small for V5 filesystems, but we must allow
v4 filesystems to mount because, historically, there was no log size
validity checking and so some systems may still be out there with
undersized logs.

The problem is that on V4 filesystems, when we discover a log
geometry problem, we skip all the remaining checks and then allow
the log to continue mounting. This mean that if one of the log size
checks fails, we skip the log stripe unit check. i.e. we allow the
mount because a "non-fatal" geometry is violated, and then fail to
check the hard fail geometries that should fail the mount.

Move all these fatal checks to the superblock verifier, and add a
new check for the two log sector size geometry variables having the
same values. This will prevent any attempt to mount a log that has
invalid or inconsistent geometries long before we attempt to mount
the log.

However, for the minimum log size checks, we can only do that once
we've setup up the log and calculated all the iclog sizes and
roundoffs. Hence this needs to remain in the log mount code after
the log has been initialised. It is also the only case where we
should allow a v4 filesystem to continue running, so leave that
handling in place, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---

Notes:
    A new fix for the latest 6.1.y backport series just came in. Ran
    some tests on it as well and all looks good. Please include with
    the original set.

    Thanks,
    Leah

 fs/xfs/libxfs/xfs_sb.c | 56 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log.c       | 47 +++++++++++------------------------
 2 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index bf2cca78304e..c24a38272cb7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -413,7 +413,6 @@ xfs_validate_sb_common(
 	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
 	    sbp->sb_inodelog > XFS_DINODE_MAX_LOG			||
 	    sbp->sb_inodesize != (1 << sbp->sb_inodelog)		||
-	    sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE			||
 	    sbp->sb_inopblock != howmany(sbp->sb_blocksize,sbp->sb_inodesize) ||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) < XFS_MIN_AG_BYTES	||
 	    XFS_FSB_TO_B(mp, sbp->sb_agblocks) > XFS_MAX_AG_BYTES	||
@@ -431,6 +430,61 @@ xfs_validate_sb_common(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Logs that are too large are not supported at all. Reject them
+	 * outright. Logs that are too small are tolerated on v4 filesystems,
+	 * but we can only check that when mounting the log. Hence we skip
+	 * those checks here.
+	 */
+	if (sbp->sb_logblocks > XFS_MAX_LOG_BLOCKS) {
+		xfs_notice(mp,
+		"Log size 0x%x blocks too large, maximum size is 0x%llx blocks",
+			 sbp->sb_logblocks, XFS_MAX_LOG_BLOCKS);
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_FSB_TO_B(mp, sbp->sb_logblocks) > XFS_MAX_LOG_BYTES) {
+		xfs_warn(mp,
+		"log size 0x%llx bytes too large, maximum size is 0x%llx bytes",
+			 XFS_FSB_TO_B(mp, sbp->sb_logblocks),
+			 XFS_MAX_LOG_BYTES);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Do not allow filesystems with corrupted log sector or stripe units to
+	 * be mounted. We cannot safely size the iclogs or write to the log if
+	 * the log stripe unit is not valid.
+	 */
+	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT) {
+		if (sbp->sb_logsectsize != (1U << sbp->sb_logsectlog)) {
+			xfs_notice(mp,
+			"log sector size in bytes/log2 (0x%x/0x%x) must match",
+				sbp->sb_logsectsize, 1U << sbp->sb_logsectlog);
+			return -EFSCORRUPTED;
+		}
+	} else if (sbp->sb_logsectsize || sbp->sb_logsectlog) {
+		xfs_notice(mp,
+		"log sector size in bytes/log2 (0x%x/0x%x) are not zero",
+			sbp->sb_logsectsize, sbp->sb_logsectlog);
+		return -EFSCORRUPTED;
+	}
+
+	if (sbp->sb_logsunit > 1) {
+		if (sbp->sb_logsunit % sbp->sb_blocksize) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes must be a multiple of block size",
+				sbp->sb_logsunit);
+			return -EFSCORRUPTED;
+		}
+		if (sbp->sb_logsunit > XLOG_MAX_RECORD_BSIZE) {
+			xfs_notice(mp,
+		"log stripe unit 0x%x bytes over maximum size (0x%x bytes)",
+				sbp->sb_logsunit, XLOG_MAX_RECORD_BSIZE);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	/* Validate the realtime geometry; stolen from xfs_repair */
 	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
 	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE) {
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d9aa5eab02c3..59c982297503 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -639,7 +639,6 @@ xfs_log_mount(
 	int		num_bblks)
 {
 	struct xlog	*log;
-	bool		fatal = xfs_has_crc(mp);
 	int		error = 0;
 	int		min_logfsbs;
 
@@ -661,53 +660,37 @@ xfs_log_mount(
 	mp->m_log = log;
 
 	/*
-	 * Validate the given log space and drop a critical message via syslog
-	 * if the log size is too small that would lead to some unexpected
-	 * situations in transaction log space reservation stage.
+	 * Now that we have set up the log and it's internal geometry
+	 * parameters, we can validate the given log space and drop a critical
+	 * message via syslog if the log size is too small. A log that is too
+	 * small can lead to unexpected situations in transaction log space
+	 * reservation stage. The superblock verifier has already validated all
+	 * the other log geometry constraints, so we don't have to check those
+	 * here.
 	 *
-	 * Note: we can't just reject the mount if the validation fails.  This
-	 * would mean that people would have to downgrade their kernel just to
-	 * remedy the situation as there is no way to grow the log (short of
-	 * black magic surgery with xfs_db).
+	 * Note: For v4 filesystems, we can't just reject the mount if the
+	 * validation fails.  This would mean that people would have to
+	 * downgrade their kernel just to remedy the situation as there is no
+	 * way to grow the log (short of black magic surgery with xfs_db).
 	 *
-	 * We can, however, reject mounts for CRC format filesystems, as the
+	 * We can, however, reject mounts for V5 format filesystems, as the
 	 * mkfs binary being used to make the filesystem should never create a
 	 * filesystem with a log that is too small.
 	 */
 	min_logfsbs = xfs_log_calc_minimum_size(mp);
-
 	if (mp->m_sb.sb_logblocks < min_logfsbs) {
 		xfs_warn(mp,
 		"Log size %d blocks too small, minimum size is %d blocks",
 			 mp->m_sb.sb_logblocks, min_logfsbs);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logblocks > XFS_MAX_LOG_BLOCKS) {
-		xfs_warn(mp,
-		"Log size %d blocks too large, maximum size is %lld blocks",
-			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
-		error = -EINVAL;
-	} else if (XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks) > XFS_MAX_LOG_BYTES) {
-		xfs_warn(mp,
-		"log size %lld bytes too large, maximum size is %lld bytes",
-			 XFS_FSB_TO_B(mp, mp->m_sb.sb_logblocks),
-			 XFS_MAX_LOG_BYTES);
-		error = -EINVAL;
-	} else if (mp->m_sb.sb_logsunit > 1 &&
-		   mp->m_sb.sb_logsunit % mp->m_sb.sb_blocksize) {
-		xfs_warn(mp,
-		"log stripe unit %u bytes must be a multiple of block size",
-			 mp->m_sb.sb_logsunit);
-		error = -EINVAL;
-		fatal = true;
-	}
-	if (error) {
+
 		/*
 		 * Log check errors are always fatal on v5; or whenever bad
 		 * metadata leads to a crash.
 		 */
-		if (fatal) {
+		if (xfs_has_crc(mp)) {
 			xfs_crit(mp, "AAIEEE! Log failed size checks. Abort!");
 			ASSERT(0);
+			error = -EINVAL;
 			goto out_free_log;
 		}
 		xfs_crit(mp, "Log size out of supported range.");
-- 
2.46.0.792.g87dc391469-goog

