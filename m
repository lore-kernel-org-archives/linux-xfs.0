Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C873101DC
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781033; cv=none; b=cGf+E5uPtGywWeToHlxcD10KHJFHI8/BGu9FhwKWmWk7kx4XXtUrPyC7cuflGnMFqRYniHLF/z2FMYGdZ6of/Npyx918Nico1mPfmgcJ3rdbslKItxuEFMbZFB43x0aEfRut2SyKxvPcGExJoog7VhZSjeeI+l12r5KmVBCondI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781033; c=relaxed/simple;
	bh=otr0nwvOlnOJwwyfIDV88ZEOsgkR04t0x+WVo1mmbNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOiOoQ8j5qhEG5n+O5bpMYzE6DCLNANimfeJuNY4sbZUBx9kgpOc2QxP/Si28JWTTWyGN92zbzqMZHGQ6pAkE7F7IdZNpb8G1FQGRJ1qN0Im/sH2I4+u198ufQutg5/RXBp4Zel/HocQbkr89N+7G/2WlXjzkHgwXpE6mdYyqDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Hm0ZJbG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Hm0ZJbG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q38/ER0CPH74Hg9C7TxFqbuTZMbVdL58ooVkxISyUxA=; b=3Hm0ZJbG6Lq1pae+WeVjxGjd/A
	5DdF3ac3G83fXyfwK6Iwla1FlLjvvvHG6jMOOeAb5sK/Nd2sA5C0Syg2D6QX9bdnH0y98rS8bVSiz
	0EZxWyVosxDXPrGoXRpdF0kBkuVhACQaVMTCOqZspcsybppBtKGDFVjziqw/DTUbIGHj4Ir4d5WCR
	2/7NpM6SVl0zwpMBBLrjXXkYw+oB6XsjaEylFDWH4SVP6kG19mHVUMfTaIg4iWya29gjtyYRv55gn
	St7XN5ZfSepmF9ABFDbNSqL1cCQfd0wolDacct4xtOP9NUhcwG7dx99QOt4zOWvXEkIVZZuJP/yOh
	ic+RUYVw==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRs6-00000005USK-2HaF;
	Mon, 10 Nov 2025 13:23:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/18] xfs: don't treat all radix_tree_insert errors as -EEXIST
Date: Mon, 10 Nov 2025 14:22:55 +0100
Message-ID: <20251110132335.409466-4-hch@lst.de>
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

Return other errors to the caller instead.  Note that there really
shouldn't be any other errors because the entry is preallocated, but
if there were, we'd better return them instead of retrying forever.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 0bd8022e47b4..79e14ee1d7a0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -860,7 +860,6 @@ xfs_qm_dqget_cache_insert(
 	mutex_lock(&qi->qi_tree_lock);
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
-		/* Duplicate found!  Caller must try again. */
 		trace_xfs_dqget_dup(dqp);
 		goto out_unlock;
 	}
@@ -935,13 +934,16 @@ xfs_qm_dqget(
 
 	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
 	if (error) {
-		/*
-		 * Duplicate found. Just throw away the new dquot and start
-		 * over.
-		 */
 		xfs_qm_dqdestroy(dqp);
-		XFS_STATS_INC(mp, xs_qm_dquot_dups);
-		goto restart;
+		if (error == -EEXIST) {
+			/*
+			 * Duplicate found. Just throw away the new dquot and
+			 * start over.
+			 */
+			XFS_STATS_INC(mp, xs_qm_dquot_dups);
+			goto restart;
+		}
+		return error;
 	}
 
 	trace_xfs_dqget_miss(dqp);
@@ -1060,13 +1062,16 @@ xfs_qm_dqget_inode(
 
 	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
 	if (error) {
-		/*
-		 * Duplicate found. Just throw away the new dquot and start
-		 * over.
-		 */
 		xfs_qm_dqdestroy(dqp);
-		XFS_STATS_INC(mp, xs_qm_dquot_dups);
-		goto restart;
+		if (error == -EEXIST) {
+			/*
+			 * Duplicate found. Just throw away the new dquot and
+			 * start over.
+			 */
+			XFS_STATS_INC(mp, xs_qm_dquot_dups);
+			goto restart;
+		}
+		return error;
 	}
 
 dqret:
-- 
2.47.3

