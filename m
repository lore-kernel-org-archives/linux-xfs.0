Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A1363D5
	for <linux-xfs@vger.kernel.org>; Mon, 30 Sep 2024 16:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727714552; cv=none; b=JMAzqHhAvQUqRDyZH4k3OWhgYDFpdjEt7ZhxrLLqPeVwTslekR/Pljcs4jlI3wo/R0mA9vARPlaMr3Z2tnjpEs4DcjasNDDku747a5nU49lAoo/ebN025O8sLJ/VasFJTXVNuBc5okONwvVyziGCjAK9ySVzzo71thCyrPmGCYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727714552; c=relaxed/simple;
	bh=JuNmmxpYoiu7vX9QOzLCy3ca8QCBuXZfuUcEhRwQVC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7kNbyIM/TAPSlGdhwL2y1GdMtPVJ9tVRni2DS41BrQVnZ/mfOADKQpDPWFPmcdJUgc9/FUZc6vAYqaWWSnMkQTEQQLSeDikI8wAQmTrakGrKcTx7OjGn9stnL+nOzzPloNxPYRtq88yrPgruWJJVOcpmYrebdaHQWHaMX9Elr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BbY0LvAe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BbY0LvAe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5vhHAd/fxqML9AjrfE70SrrGbScFsVdNh76QzWU/QbM=; b=BbY0LvAeWByfR/cC9774ekf7Q7
	AGg+R/YNqs0/ppEEn0ZdCpqIIWgENGkC28yWnaisoA+GJsOImJs6iBi7jwMV7HHNLtUGucc//panH
	O892TvenUQwUtOfsxFsw5mffYDYq9WZ9mbmH4MQgEGGhdti9I3wZAYFJ6iFuX911VXQ7SlgmbKGYx
	C+XK3OkRpHMIPRs6i64Hstk27O7zazzijcMTTrXNo1KWzH084bTIsGWn6sD0T5mGL7vxJ9t069I78
	aSjD+mZrNbRNRLDy6kGpRWqi9HbJx03Y5jC9vD5VQQyPoK8NYEWG+nXtTFbvpJivtozOPhaoIUbDc
	28q2FvaA==;
Received: from 2a02-8389-2341-5b80-2b91-e1b6-c99c-08ea.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2b91:e1b6:c99c:8ea] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svJTh-00000000GYL-41g5;
	Mon, 30 Sep 2024 16:42:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: update the file system geometry after recoverying superblock buffers
Date: Mon, 30 Sep 2024 18:41:44 +0200
Message-ID: <20240930164211.2357358-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930164211.2357358-1-hch@lst.de>
References: <20240930164211.2357358-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_log_recover.h |  2 ++
 fs/xfs/xfs_buf_item_recover.c   | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        | 27 +++++++++++++++++++--------
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 521d327e4c89ed..d0e13c84422d0a 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -165,4 +165,6 @@ void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 int xlog_recover_finish_intent(struct xfs_trans *tp,
 		struct xfs_defer_pending *dfp);
 
+int xlog_recover_update_agcount(struct xfs_mount *mp, struct xfs_dsb *dsb);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 09e893cf563cb9..08c129022304a8 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -684,6 +684,28 @@ xlog_recover_do_inode_buffer(
 	return 0;
 }
 
+static int
+xlog_recover_do_sb_buffer(
+	struct xfs_mount		*mp,
+	struct xlog_recover_item	*item,
+	struct xfs_buf			*bp,
+	struct xfs_buf_log_format	*buf_f,
+	xfs_lsn_t			current_lsn)
+{
+	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+	/*
+	 * Update the in-memory superblock and perag structures from the
+	 * primary SB buffer.
+	 *
+	 * This is required because transactions running after growfs may require
+	 * the updated values to be set in a previous fully commit transaction.
+	 */
+	if (xfs_buf_daddr(bp) != 0)
+		return 0;
+	return xlog_recover_update_agcount(mp, bp->b_addr);
+}
+
 /*
  * V5 filesystems know the age of the buffer on disk being recovered. We can
  * have newer objects on disk than we are replaying, and so for these cases we
@@ -967,6 +989,11 @@ xlog_recover_buf_commit_pass2(
 		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
 		if (!dirty)
 			goto out_release;
+	} else if (xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) {
+		error = xlog_recover_do_sb_buffer(mp, item, bp, buf_f,
+				current_lsn);
+		if (error)
+			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6a165ca55da1a8..03701409c7dcd6 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3334,6 +3334,25 @@ xlog_do_log_recovery(
 	return error;
 }
 
+int
+xlog_recover_update_agcount(
+	struct xfs_mount		*mp,
+	struct xfs_dsb			*dsb)
+{
+	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
+	int				error;
+
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	return 0;
+}
+
 /*
  * Do the actual recovery
  */
@@ -3346,7 +3365,6 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3394,13 +3412,6 @@ xlog_do_recover(
 	/* re-initialise in-core superblock and geometry structures */
 	mp->m_features |= xfs_sb_version_to_features(sbp);
 	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
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

