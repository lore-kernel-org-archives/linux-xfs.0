Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD4113777E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885929; cv=none; b=RrKb1f3gID6Df5+OnrUQGYf5yDA2SIHNsImyIc+HzRVGBtUGh6OsY1ZXMD1hyzwx/SE/2lg9O+t7spDwn4HqNDEdGsP5DTIGK7jXXQ8+PCnPHLR5AT3CLFT0lHUhM5uKTslYUSBbv2nNjEDEU0TnAZmkYxpcodN8XaJ8dsxy3ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885929; c=relaxed/simple;
	bh=aD7ecbBxIMfo3MvUyRBzWHSzQAoN6Z2DaOoXYVy5ZpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sO2GqhpA+xXWPvYNGfiZxlUJSe95h8xcdY6GlUJPj5dwdlqwYe9FBigFtpI3OTmTLPRedakrzorHIbZqawThkbv+xYEZssM8pIP4hZ72s6YZdhYF3EKkCMgL53zgQ7cGHt3LSMPtyQPT5C1mw7FRHZJTuB8bLKfohSoy9qbimJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w/QDgggW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w/QDgggW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ewnch4OjKHvB0dLNffXF96fR868v4KSZkQE50F7hr3g=; b=w/QDgggWd3yEYo5EfbnW33AOVz
	mTDCZUmuHK8ZWhI89zIZtBmiCPp1E+iAJ1MDTcxauf44XVebTH2cxpDDRUQ1mynvh7RT1PUK2b6mm
	CKxGCvw5xAIfE4wZ85uYxkZj7jadxhx1iXAv8k/SZ3lq7acLL5uEixSs9fNLdbRTc8447bxZejxBR
	DhcK20Z2pFpYa/oTS67A0osBFJE56tyoL4V1cTz822BQ6KWheWjR3F0ZyeA2L+dQwapBQKc0uGL/D
	t59V0UnUaPZZQ2Iws7uOI7uRZJGxzcQV9gKb/MNo6VhD5VUCjCM3dXV+k+T3SHSTVW4Ew0fH4a/7W
	UwaNokRg==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ECt-00000003pdv-3gr1;
	Mon, 14 Oct 2024 06:05:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: update the file system geometry after recoverying superblock buffers
Date: Mon, 14 Oct 2024 08:04:52 +0200
Message-ID: <20241014060516.245606-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Primary superblock buffers that change the file system geometry after a
growfs operation can affect the operation of later CIL checkpoints that
make use of the newly added space and allocation groups.

Apply the changes to the in-memory structures as part of recovery pass 2,
to ensure recovery works fine for such cases.

In the future we should apply the logic to other updates such as features
bits as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item_recover.c | 52 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c      |  8 ------
 2 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 09e893cf563cb9..edf1162a8c9dd0 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -22,6 +22,9 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_quota.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_sb.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -684,6 +687,49 @@ xlog_recover_do_inode_buffer(
 	return 0;
 }
 
+/*
+ * Update the in-memory superblock and perag structures from the primary SB
+ * buffer.
+ *
+ * This is required because transactions running after growfs may require the
+ * updated values to be set in a previous fully commit transaction.
+ */
+static int
+xlog_recover_do_primary_sb_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
+	int				error;
+
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+	/*
+	 * Update the in-core super block from the freshly recovered on-disk one.
+	 */
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+
+	/*
+	 * Initialize the new perags, and also update various block and inode
+	 * allocator setting based off the number of AGs or total blocks.
+	 * Because of the latter this also needs to happen if the agcount did
+	 * not change.
+	 */
+	error = xfs_initialize_perag(mp, orig_agcount,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
+			&mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	return 0;
+}
+
 /*
  * V5 filesystems know the age of the buffer on disk being recovered. We can
  * have newer objects on disk than we are replaying, and so for these cases we
@@ -967,6 +1013,12 @@ xlog_recover_buf_commit_pass2(
 		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 		if (!dirty)
 			goto out_release;
+	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
+			xfs_buf_daddr(bp) == 0) {
+		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
+				current_lsn);
+		if (error)
+			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 60d46338f51792..08b8938e4efb7d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3346,7 +3346,6 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	xfs_agnumber_t		orig_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3394,13 +3393,6 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, orig_agcount, sbp->sb_agcount,
-			sbp->sb_dblocks, &mp->m_maxagi);
-	if (error) {
-		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
-		return error;
-	}
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
-- 
2.45.2

