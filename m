Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89219DF4F
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781063; cv=none; b=moYgjZ3tuN3h7zqdCG5iwstggLugcLITPHvoO3gv++HKDjVGv02HdzT6admw8VK7NQSuOTygrY9yP9/waeMVwfZR9z0hpYP3C/r1bRk0SJEZtIa7yTExM+coolRQWrmWWAPXK+SsGVj6Fr7AbfyImxXx8w/MKAX0eQ1PlM0qXBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781063; c=relaxed/simple;
	bh=2FJp53/MPKncnm7jRNxblgAMVQJv2oZudm4Ra5IVNWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFJ0jf5OYs0Ssx5HU0dhMcWU2CrdolooXUFZZRHrNNgOC7XPdIVeGrMqg/X/YeMpjrW6x4SKZUs0QdyfmB5AtAD4MTBR4ii/lrD6ytjNe5HKappgUpca7iVLTp1LTV9j+Ux5newwgZCp71WYEctoeN0/X9h+HnfY3bb4i0Ulxn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3bm7Gn3g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3bm7Gn3g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7O/sLI5WiO8zxLFjf15u8S0sDyxXCRiV7uSftkIL/a8=; b=3bm7Gn3g6kTMrnlfDUyukhrBj6
	ZRAxtJig/CpsYRfNU7K8ubYyPM4hUNjJutdX1QyliPeY3jU0Z+9tLdG270q2HS9HIf8TG/S5nr6fT
	mSYPrq/xFVKCk+Lo+lWs9cXVp6xmnt8icLRbnHHd1WYuRca16tgaNIQH7yj0nrlnrYLUV0ryvWmR5
	1jINo7OG+JzGxnRyo0ogF+WkCGtLIfel5YxqYz6obiqTK2aHVY/2XOBWH4g5EUdUt1Oc2QNt61m5q
	CcwcH73YDt8prdyt+Tmq8Pyz8Gs7f1YWsxDBIuE9gMd2fEiew0cd4zkvwJAR7oE3aPGwwYa0mHGhZ
	OXSVl7Lw==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsb-00000005UU6-0Etx;
	Mon, 10 Nov 2025 13:24:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 10/18] xfs: return the dquot unlocked from xfs_qm_dqget
Date: Mon, 10 Nov 2025 14:23:02 +0100
Message-ID: <20251110132335.409466-11-hch@lst.de>
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

There is no reason to lock the dquot in xfs_qm_dqget, which just acquires
a reference.  Move the locking to the callers, or remove it in cases where
the caller instantly unlocks the dquot.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/dqiterate.c         | 1 +
 fs/xfs/scrub/quotacheck.c        | 1 +
 fs/xfs/scrub/quotacheck_repair.c | 1 +
 fs/xfs/xfs_dquot.c               | 4 ++--
 fs/xfs/xfs_qm.c                  | 4 +---
 fs/xfs/xfs_qm_bhv.c              | 1 +
 fs/xfs/xfs_qm_syscalls.c         | 2 ++
 7 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
index 20c4daedd48d..6f1185afbf39 100644
--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -205,6 +205,7 @@ xchk_dquot_iter(
 	if (error)
 		return error;
 
+	mutex_lock(&dq->q_qlock);
 	cursor->id = dq->q_id + 1;
 	*dqpp = dq;
 	return 1;
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 180449f654f6..bef63f19cd87 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -635,6 +635,7 @@ xqcheck_walk_observations(
 		if (error)
 			return error;
 
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_compare_dquot(xqc, dqtype, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 11153e24b565..3b23219d43ed 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -187,6 +187,7 @@ xqcheck_commit_dqtype(
 		if (error)
 			return error;
 
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		mutex_unlock(&dq->q_qlock);
 		xfs_qm_dqrele(dq);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 862fec529512..1c9c17892874 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -895,7 +895,7 @@ xfs_qm_dqget_checks(
 
 /*
  * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
- * locked dquot, doing an allocation (if requested) as needed.
+ * dquot, doing an allocation (if requested) as needed.
  */
 int
 xfs_qm_dqget(
@@ -940,7 +940,6 @@ xfs_qm_dqget(
 	trace_xfs_dqget_miss(dqp);
 found:
 	*O_dqpp = dqp;
-	mutex_lock(&dqp->q_qlock);
 	return 0;
 }
 
@@ -1098,6 +1097,7 @@ xfs_qm_dqget_next(
 		else if (error != 0)
 			break;
 
+		mutex_lock(&dqp->q_qlock);
 		if (!XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
 			*dqpp = dqp;
 			return 0;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f3f7947bc4ed..a81b8b7a4e4f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1268,6 +1268,7 @@ xfs_qm_quotacheck_dqadjust(
 		return error;
 	}
 
+	mutex_lock(&dqp->q_qlock);
 	error = xfs_dquot_attach_buf(NULL, dqp);
 	if (error)
 		goto out_unlock;
@@ -1907,7 +1908,6 @@ xfs_qm_vop_dqalloc(
 			/*
 			 * Get the ilock in the right order.
 			 */
-			mutex_unlock(&uq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1929,7 +1929,6 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			mutex_unlock(&gq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
@@ -1947,7 +1946,6 @@ xfs_qm_vop_dqalloc(
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			mutex_unlock(&pq->q_qlock);
 			lockflags = XFS_ILOCK_SHARED;
 			xfs_ilock(ip, lockflags);
 		} else {
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index e5a30b12253c..edc0aef3cf34 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -73,6 +73,7 @@ xfs_qm_statvfs(
 	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQTYPE_PROJ, false, &dqp)) {
+		mutex_lock(&dqp->q_qlock);
 		xfs_fill_statvfs_from_dquot(statp, ip, dqp);
 		mutex_unlock(&dqp->q_qlock);
 		xfs_qm_dqrele(dqp);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 441f9806cddb..6c8924780d7a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -302,6 +302,7 @@ xfs_qm_scall_setqlim(
 		return error;
 	}
 
+	mutex_lock(&dqp->q_qlock);
 	defq = xfs_get_defquota(q, xfs_dquot_type(dqp));
 	mutex_unlock(&dqp->q_qlock);
 
@@ -459,6 +460,7 @@ xfs_qm_scall_getquota(
 	 * If everything's NULL, this dquot doesn't quite exist as far as
 	 * our utility programs are concerned.
 	 */
+	mutex_lock(&dqp->q_qlock);
 	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
 		error = -ENOENT;
 		goto out_put;
-- 
2.47.3

