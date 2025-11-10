Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449B23C516
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781051; cv=none; b=idYqADbb8/pF9bJLkztc6JzHwIGwdqAyiv5JKbjiSt711AUVsnF3srl15hJY9hX2ULaTjwZIJW8OJOvcnDiv16GO9YkXkPN4nKhkCZeIAZoadLl0K7yYIWHT0Zo/K82G50xCWJ2fNUeuglG00mJc1ly8pe1+Sko86nlYN19r2xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781051; c=relaxed/simple;
	bh=iooA8TnJMOXFjwmizgZdn8/QvXeAcF7Dmmq+S6ywLlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paEbctEh9hUtrQttE1qr9/xKb6mbrgd6u+jcgd4FUpN8jT5w3cVNDCUK87aBT9CAr/VWZ9KyTpUf2zJAUwwCKo+wOLvR50iCTwzd7YVdIDITolg0qfTPWYkY3XdQnSKXw1+5B2/vz6jiUBUTZzhilfIeup42OZNnNqWXAbluNo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t17zmeQL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t17zmeQL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9UHmGZblE8Htd1Ygk/wkBpGCY+sR8qqO8Qm71izUiAk=; b=t17zmeQL+UNE5n5TtIetTLxrL9
	AbnhCU1tizpD4LzW0NyRYpIHelQMmBoDQ+4/spbSyStc+ibokgiDNiPF3nNsElpSNbI/iGyOjM71r
	rsQ+SwWI2kc8HEp8MpfzyzOQ6SPTGs9iZWIGVbS4rLkb+NqghFVUz7l+wcNYtdf8wws7TLApStlu4
	hRgi+8ZVcRReK+NmywSiRp/Oc8YA7LQC9RYpKNmPyrRJ+hpVISQ1cfwPHzzZKejzTdzbUZtOAEprz
	wzy2pe9vITQZvylkxjVq9pkvmeQDfq68lExSX43mUrCRiUxpaefKLYUMj5iemRQLVUqh5MyEep3LR
	9ZicT3Hg==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsN-00000005USv-3afF;
	Mon, 10 Nov 2025 13:24:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 07/18] xfs: consolidate q_qlock locking in xfs_qm_dqget and xfs_qm_dqget_inode
Date: Mon, 10 Nov 2025 14:22:59 +0100
Message-ID: <20251110132335.409466-8-hch@lst.de>
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

Move taking q_qlock from the cache lookup / insert helpers into the
main functions and do it just before returning to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 52c521a1402d..8b4434e6df09 100644
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
@@ -861,8 +859,6 @@ xfs_qm_dqget_cache_insert(
 		goto out_unlock;
 	}
 
-	/* Return a locked dquot to the caller, with a reference taken. */
-	mutex_lock(&dqp->q_qlock);
 	lockref_init(&dqp->q_lockref);
 	qi->qi_dquots++;
 
@@ -920,10 +916,8 @@ xfs_qm_dqget(
 
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
@@ -944,7 +938,9 @@ xfs_qm_dqget(
 	}
 
 	trace_xfs_dqget_miss(dqp);
+found:
 	*O_dqpp = dqp;
+	mutex_lock(&dqp->q_qlock);
 	return 0;
 }
 
@@ -1019,10 +1015,8 @@ xfs_qm_dqget_inode(
 
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
@@ -1048,7 +1042,6 @@ xfs_qm_dqget_inode(
 		if (dqp1) {
 			xfs_qm_dqdestroy(dqp);
 			dqp = dqp1;
-			mutex_lock(&dqp->q_qlock);
 			goto dqret;
 		}
 	} else {
@@ -1074,7 +1067,9 @@ xfs_qm_dqget_inode(
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

