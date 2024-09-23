Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C587919CC0D;
	Mon, 23 Sep 2024 15:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.143.211.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727107085; cv=none; b=e6CuKOP1qJhKn7KsRxT8u3iXGVAt5gylkAwuwuvvGSU8h2GGrRi8fENvY/npiBE1YvBSCm6JOOKFPMgjVLKCw2j5jprrOkILITVpqnuOsQ21+YLGVlCPp6k5QbKYioWd2ona3Vdi81YkVZ5Fv+rWB3H+jJq5rsJOeItl0Jg+vjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727107085; c=relaxed/simple;
	bh=asKAv2JLEFJ2mcEgCv3pY9YGphfMlPIjUcQ7DN7iGjo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tu4aXSJ3xH+Qo4yBb5VVU501D6z5v7DAXPX7Y/6svosO6QZ60JwF7CggyfTPhr+alHjp+Lue4XPCqSh/baZWAUxhK5O876RuS9r85c4Wvh8+JjLIdXrfVifJvpTEXvgqsPr1ktEP6WV3jJ1Z2S7sVDuRb+dR947A1xyn2kT8EJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru; spf=pass smtp.mailfrom=swemel.ru; dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b=J0ttHLyr; arc=none smtp.client-ip=95.143.211.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=swemel.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=swemel.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=swemel.ru header.i=@swemel.ru header.b="J0ttHLyr"
From: Andrey Kalachev <kalachev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
	t=1727107073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/T/lRwwZdTLkO2iXWLTT0Ql8AA5YQmz02ed6HhgKic8=;
	b=J0ttHLyr2D9NBOqNFKdFYllsKgs4vKcXsZOCq7n1WA5hjiB+uHG21vOp2ek+XDauC4IPti
	EjL/tvmcf9HIrKGFnR3J8FNCm9/9irM0u4PaCDWa+0xOyDLiI8JhBMEG27fQpFlT8dIdHA
	bH4tXE+1mDDi54urojJ7nv2PY/v3eAI=
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	kalachev@swemel.ru,
	lvc-project@linuxtesting.org,
	syzbot+66f256de193ab682584f@syzkaller.appspotmail.com,
	syzbot+904ffc7f25c759741787@syzkaller.appspotmail.com
Subject: [PATCH 5.15.y, 6.1.y] xfs: journal geometry is not properly bounds checked
Date: Mon, 23 Sep 2024 18:57:52 +0300
Message-Id: <20240923155752.8443-4-kalachev@swemel.ru>
In-Reply-To: <20240923155752.8443-1-kalachev@swemel.ru>
References: <20240923155752.8443-1-kalachev@swemel.ru>
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
Signed-off-by: Andrey Kalachev <kalachev@swemel.ru>
---
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
2.30.2

