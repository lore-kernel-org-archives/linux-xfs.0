Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF2322579E
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781048; cv=none; b=NDJAbNqvsLV65f0Y/hLMJSRFV2OHiDQIGAroqrRMh9Yh42CzSipjr3JpmsaqVM23ql2nzbpsqf9REm2NIqHw1dw0MZe5RXpx756LNPI2KLiDAFdAAZwjqcI87C1/dl/NdsrmzgLGRXVM8MEXfs6M12c7Ij4sIr+O6gi+0Wy3+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781048; c=relaxed/simple;
	bh=dNI6vbg3ZgBa/s1ZFHlxGT5xUg6oaEej0S3z2WTq10I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e728qExMczk/qMwvxZPplU7hFULdRT2TZ/k9jIZIdH+sppb//T+Dv//of9iGyoeP1jrpbqeO81iK6svsszE7iSwuKEOKWr9g19YDFJ8KSK7FEd1HwQBHqOX88kXWukR/rc5vf56uvRtjH+eOeIXwtu7GtZgOkQMta8lVDbKHmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CT0Nwi8z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CT0Nwi8z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AnOWs6xzwwYVPD201a1Caq6ss6cAizHtk0VMcnRvKl8=; b=CT0Nwi8zUm7Yl+CRpqrjLVkKRP
	Dq7UkXa8kaOx313/k1sGdFgGr0W0k2P/glV2rvRsWhedwwn0vfMeCd/YBIXhxBJOxFaaR78Gp9M0X
	0WvSP5iOOSoEB2XYCFAPslKZ3OiPwa0PiWTYA11S4MMGimYPKVMYG/J9BrEqclrwdBZzlF4tpByAS
	58kcPNJbwLIktPR6xPYZ4UrtjFapFbw+lnLVNHYvtUCzGzwFaI0LdeofWOCpi9tN9SYq993WXKGYi
	e7perTxNYF3SkVwAcfpRsheIAPSC+5BsHceSeFZYWEigN+qbTc0v3piaAxqNJ8XWfwDbVTZu+38Ep
	hWrPn0tQ==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsJ-00000005USn-1kas;
	Mon, 10 Nov 2025 13:24:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/18] xfs: remove xfs_qm_dqput and optimize dropping dquot references
Date: Mon, 10 Nov 2025 14:22:58 +0100
Message-ID: <20251110132335.409466-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

With the new lockref-based dquot reference counting, there is no need to
hold q_qlock for dropping the reference.  Make xfs_qm_dqrele the main
function to drop dquot references without taking q_qlock and convert all
callers of xfs_qm_dqput to unlock q_qlock and call xfs_qm_dqrele instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c             |  3 ++-
 fs/xfs/scrub/quota_repair.c      |  3 ++-
 fs/xfs/scrub/quotacheck.c        |  6 +++--
 fs/xfs/scrub/quotacheck_repair.c |  6 +++--
 fs/xfs/xfs_dquot.c               | 45 +++++++-------------------------
 fs/xfs/xfs_dquot.h               |  1 -
 fs/xfs/xfs_qm.c                  |  6 +++--
 fs/xfs/xfs_qm_bhv.c              |  3 ++-
 fs/xfs/xfs_qm_syscalls.c         |  6 +++--
 fs/xfs/xfs_trace.h               |  3 +--
 10 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index c78cf9f96cf6..cfcd0fb66845 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -330,7 +330,8 @@ xchk_quota(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xchk_quota_item(&sqi, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 8c89c6cc2950..d4ce9e56d3ef 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -513,7 +513,8 @@ xrep_quota_problems(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xrep_quota_item(&rqi, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index e4105aaafe84..180449f654f6 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -636,7 +636,8 @@ xqcheck_walk_observations(
 			return error;
 
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
 
@@ -674,7 +675,8 @@ xqcheck_compare_dqtype(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 415314911499..11153e24b565 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -156,7 +156,8 @@ xqcheck_commit_dqtype(
 	xchk_dqiter_init(&cursor, sc, dqtype);
 	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			break;
 	}
@@ -187,7 +188,8 @@ xqcheck_commit_dqtype(
 			return error;
 
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
-		xfs_qm_dqput(dq);
+		mutex_unlock(&dq->q_qlock);
+		xfs_qm_dqrele(dq);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 34c325524ab9..52c521a1402d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1105,62 +1105,35 @@ xfs_qm_dqget_next(
 			return 0;
 		}
 
-		xfs_qm_dqput(dqp);
+		mutex_unlock(&dqp->q_qlock);
+		xfs_qm_dqrele(dqp);
 	}
 
 	return error;
 }
 
 /*
- * Release a reference to the dquot (decrement ref-count) and unlock it.
- *
- * If there is a group quota attached to this dquot, carefully release that
- * too without tripping over deadlocks'n'stuff.
+ * Release a reference to the dquot.
  */
 void
-xfs_qm_dqput(
+xfs_qm_dqrele(
 	struct xfs_dquot	*dqp)
 {
-	ASSERT(XFS_DQ_IS_LOCKED(dqp));
+	if (!dqp)
+		return;
 
-	trace_xfs_dqput(dqp);
+	trace_xfs_dqrele(dqp);
 
 	if (lockref_put_or_lock(&dqp->q_lockref))
-		goto out_unlock;
-
+		return;
 	if (!--dqp->q_lockref.count) {
 		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
-		trace_xfs_dqput_free(dqp);
 
+		trace_xfs_dqrele_free(dqp);
 		if (list_lru_add_obj(&qi->qi_lru, &dqp->q_lru))
 			XFS_STATS_INC(dqp->q_mount, xs_qm_dquot_unused);
 	}
 	spin_unlock(&dqp->q_lockref.lock);
-out_unlock:
-	mutex_unlock(&dqp->q_qlock);
-}
-
-/*
- * Release a dquot. Flush it if dirty, then dqput() it.
- * dquot must not be locked.
- */
-void
-xfs_qm_dqrele(
-	struct xfs_dquot	*dqp)
-{
-	if (!dqp)
-		return;
-
-	trace_xfs_dqrele(dqp);
-
-	mutex_lock(&dqp->q_qlock);
-	/*
-	 * We don't care to flush it if the dquot is dirty here.
-	 * That will create stutters that we want to avoid.
-	 * Instead we do a delayed write when we try to reclaim
-	 * a dirty dquot. Also xfs_sync will take part of the burden...
-	 */
-	xfs_qm_dqput(dqp);
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c56fbc39d089..bbb824adca82 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -218,7 +218,6 @@ int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
 				xfs_dqid_t id, xfs_dqtype_t type,
 				struct xfs_dquot **dqpp);
-void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
 void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 void		xfs_dqlockn(struct xfs_dqtrx *q);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f98f9fdac0b5..5e6aefb17f19 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1346,7 +1346,8 @@ xfs_qm_quotacheck_dqadjust(
 
 	dqp->q_flags |= XFS_DQFLAG_DIRTY;
 out_unlock:
-	xfs_qm_dqput(dqp);
+	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqrele(dqp);
 	return error;
 }
 
@@ -1487,7 +1488,8 @@ xfs_qm_flush_one(
 		xfs_buf_delwri_queue(bp, buffer_list);
 	xfs_buf_relse(bp);
 out_unlock:
-	xfs_qm_dqput(dqp);
+	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqrele(dqp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 245d754f382a..e5a30b12253c 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -74,7 +74,8 @@ xfs_qm_statvfs(
 
 	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
-		xfs_qm_dqput(dqp);
+		mutex_unlock(&dqp->q_qlock);
+		xfs_qm_dqrele(dqp);
 	}
 }
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 59ef382900fe..441f9806cddb 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -467,7 +467,8 @@ xfs_qm_scall_getquota(
 	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
 
 out_put:
-	xfs_qm_dqput(dqp);
+	mutex_unlock(&dqp->q_qlock);
+	xfs_qm_dqrele(dqp);
 	return error;
 }
 
@@ -497,7 +498,8 @@ xfs_qm_scall_getquota_next(
 	*id = dqp->q_id;
 
 	xfs_qm_scall_getquota_fill_qc(mp, type, dqp, dst);
+	mutex_unlock(&dqp->q_qlock);
 
-	xfs_qm_dqput(dqp);
+	xfs_qm_dqrele(dqp);
 	return error;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 46d21eb11ccb..fccc032b3c6c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1409,9 +1409,8 @@ DEFINE_DQUOT_EVENT(xfs_dqget_hit);
 DEFINE_DQUOT_EVENT(xfs_dqget_miss);
 DEFINE_DQUOT_EVENT(xfs_dqget_freeing);
 DEFINE_DQUOT_EVENT(xfs_dqget_dup);
-DEFINE_DQUOT_EVENT(xfs_dqput);
-DEFINE_DQUOT_EVENT(xfs_dqput_free);
 DEFINE_DQUOT_EVENT(xfs_dqrele);
+DEFINE_DQUOT_EVENT(xfs_dqrele_free);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
 DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
-- 
2.47.3

