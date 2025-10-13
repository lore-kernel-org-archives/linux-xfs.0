Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E48035948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323782; cv=none; b=AFcWBIBUB6R0P90VWDDmfukiE9LNKY0x5qrtoUkdeRbnyrvDCb6asC7SHn091HlU7cIRTRdnekRkVx0m1AwjROAqgRRtLZWqvq+CXeGKEyXEF3xjEKVk2ivzGg9nF9ex147kvS53bwL3s4TxCcQrUe8638ITZVyGLppORilTPMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323782; c=relaxed/simple;
	bh=vL9Ie08AuqnOs9Yn/m3TE2TKayVGohS6EskpzB8iAZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lp9PzOQ/fd/fgTLcIyeYrmIDzHN1xrQfKvvUmKJQSmItpbNm/Aa628kZANYB1TrrTKfL4HQhhn7qVxgAc3qcmR12XiTgAe9O4Nwomi3T4gR/XFXogJXf3EJsoIDKSbqeWYfhRphz/5QIbM8oqqHQ3WoVsYIKNV2YnsIDbcJAhSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XNVilNyp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XNVilNyp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HkAPO4s9uv77QtCy69r7IvhXpVFDPa13FBYgYBrPbzI=; b=XNVilNyp8rjCt7ALNPOpsWDeXB
	b6gJ/bQ/hd7QZxANB9v/SXlcZlb0KQw598ZMoF0VZQZ6B0N317fkE/JhY1cA5awFwL9wxvNd12hC8
	Xw2WYqqog1u4JjI65dZ8VsjK+cFXYEZzpNtquFY/m8h9+a4kC90eiY31PT9LsA2WjGBNRQeV9MimC
	LBdKxgXGQM48nKXP0L3ruz0SynX74M0Bc3O2kUfjkQbtudJHPP5rupsihkkSyp0SpfafHUFGI7JGd
	lTyZVqDyABYEn2mJezFhvxxa0cXcvBSowBnQkyN4oKchsC/9w2cQpwWd6Vlzb2X6QjpjFgsj++0a5
	xSm23wyA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88d2-0000000C7h9-2MSk;
	Mon, 13 Oct 2025 02:49:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/17] xfs: return the dquot unlocked from xfs_qm_dqget
Date: Mon, 13 Oct 2025 11:48:11 +0900
Message-ID: <20251013024851.4110053-11-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
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
index 67bdc872996a..f7b1add43a2c 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -181,6 +181,7 @@ xqcheck_commit_dqtype(
 		if (error)
 			return error;
 
+		mutex_lock(&dq->q_qlock);
 		error = xqcheck_commit_dquot(xqc, dqtype, dq);
 		xfs_qm_dqrele(dq);
 		if (error)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index fa493520bea6..98593b380e94 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -896,7 +896,7 @@ xfs_qm_dqget_checks(
 
 /*
  * Given the file system, id, and type (UDQUOT/GDQUOT/PDQUOT), return a
- * locked dquot, doing an allocation (if requested) as needed.
+ * dquot, doing an allocation (if requested) as needed.
  */
 int
 xfs_qm_dqget(
@@ -938,7 +938,6 @@ xfs_qm_dqget(
 	trace_xfs_dqget_miss(dqp);
 found:
 	*O_dqpp = dqp;
-	mutex_lock(&dqp->q_qlock);
 	return 0;
 }
 
@@ -1093,6 +1092,7 @@ xfs_qm_dqget_next(
 		else if (error != 0)
 			break;
 
+		mutex_lock(&dqp->q_qlock);
 		if (!XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
 			*dqpp = dqp;
 			return 0;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9e173a4b18eb..7fbb89fcdeb9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1268,6 +1268,7 @@ xfs_qm_quotacheck_dqadjust(
 		return error;
 	}
 
+	mutex_lock(&dqp->q_qlock);
 	error = xfs_dquot_attach_buf(NULL, dqp);
 	if (error)
 		return error;
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

