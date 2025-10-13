Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCC735948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323771; cv=none; b=rZWKSFbHVl2GRydwCwlv7Hshf+aLhk/+LcHCXhR9muvfmAZ3WI0ffajkPLtWTdAjoEMH22jsXfCKXwPF4coQq5t0F4QBzbK2J+UwtpNbSxjL6k42xm/w5UOCiC+cmg7jwsCvmIcZks44YlByCAQKDJKdecUaw9r1vkF0OnxQLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323771; c=relaxed/simple;
	bh=UMh9Uw6mj2u1Xtzt7igqVfbZBOYJc11ZMZqKg7ilWHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF71C3f02Hx+NnlZRH+sh0Poee42+V2KaztEQRJiophnO5enE7hhpgAPI001PEA0xtcgsWIxEHmpra5W7CMNjtr4Sb/Eekw27ZI/pKK9icvUAB/UKwxEi8MB1J1Gj/GbJF67mGnQeVmWuXy+CVueEwFFd2YY6fizUlUnDdG377o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RU4ZS5+B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RU4ZS5+B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MMfE5aq9kCG8lMoYdz2da5OLmZXl0nGxR5tvfRFw40w=; b=RU4ZS5+BtOXx5xWf2jtr6AzgoV
	mJWZkpP/jUgy/gLm5Vk45HacA7WBRrinWAKSFzoG9ZLHtC87EazWYsC4Tc/8X5cPMOjCkss6dqozk
	ESZjZMLuVoSQoAV5EWRGQ3hu51iU26S/7KfPTk622btUfhj5fom5sOtbNVX94z5VetkNZMhL1vadu
	sqjbBURlUq+AqaFdKwT2sYE6JIuDFcnK33Chrpuwxfs7eF5/RTA1E+R+J8fsmfoEDiVxZrZR9iI7h
	xFXFrlI9+wPI4bbgnnK0QSMux6CqcV8GUed5e4/V+CG6uEPZQTOVd3JmqYHU22h0JNSV2OqddFis1
	k4WH/iYQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cq-0000000C7fb-3qsw;
	Mon, 13 Oct 2025 02:49:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/17] xfs: consolidate q_qlock locking in xfs_qm_dqget and xfs_qm_dqget_inode
Date: Mon, 13 Oct 2025 11:48:08 +0900
Message-ID: <20251013024851.4110053-8-hch@lst.de>
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

Move taking q_qlock from the cache lookup / insert helpers into the
main functions and do it just before returning to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ceddbbb41999..a6030c53a1f9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -826,15 +826,13 @@ xfs_qm_dqget_cache_lookup(
 
 	trace_xfs_dqget_hit(dqp);
 	XFS_STATS_INC(mp, xs_qm_dqcachehits);
-	mutex_lock(&dqp->q_qlock);
 	return dqp;
 }
 
 /*
  * Try to insert a new dquot into the in-core cache.  If an error occurs the
  * caller should throw away the dquot and start over.  Otherwise, the dquot
- * is returned locked (and held by the cache) as if there had been a cache
- * hit.
+ * is returned (and held by the cache) as if there had been a cache hit.
  *
  * The insert needs to be done under memalloc_nofs context because the radix
  * tree can do memory allocation during insert. The qi->qi_tree_lock is taken in
@@ -862,8 +860,6 @@ xfs_qm_dqget_cache_insert(
 		goto out_unlock;
 	}
 
-	/* Return a locked dquot to the caller, with a reference taken. */
-	mutex_lock(&dqp->q_qlock);
 	lockref_init(&dqp->q_lockref);
 	qi->qi_dquots++;
 
@@ -921,10 +917,8 @@ xfs_qm_dqget(
 
 restart:
 	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
-	if (dqp) {
-		*O_dqpp = dqp;
-		return 0;
-	}
+	if (dqp)
+		goto found;
 
 	error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
 	if (error)
@@ -942,7 +936,9 @@ xfs_qm_dqget(
 	}
 
 	trace_xfs_dqget_miss(dqp);
+found:
 	*O_dqpp = dqp;
+	mutex_lock(&dqp->q_qlock);
 	return 0;
 }
 
@@ -1017,10 +1013,8 @@ xfs_qm_dqget_inode(
 
 restart:
 	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
-	if (dqp) {
-		*O_dqpp = dqp;
-		return 0;
-	}
+	if (dqp)
+		goto found;
 
 	/*
 	 * Dquot cache miss. We don't want to keep the inode lock across
@@ -1046,7 +1040,6 @@ xfs_qm_dqget_inode(
 		if (dqp1) {
 			xfs_qm_dqdestroy(dqp);
 			dqp = dqp1;
-			mutex_lock(&dqp->q_qlock);
 			goto dqret;
 		}
 	} else {
@@ -1069,7 +1062,9 @@ xfs_qm_dqget_inode(
 dqret:
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	trace_xfs_dqget_miss(dqp);
+found:
 	*O_dqpp = dqp;
+	mutex_lock(&dqp->q_qlock);
 	return 0;
 }
 
-- 
2.47.3

