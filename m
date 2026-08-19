Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F101C220F2A
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098498; cv=none; b=jNETU/x7vIbUOGtAPQsLKGrZaR6yn0EVRuyhhRNRgg9YSKdHGL7c7nyxaPNmQV0vINb0S3Hyj5MhLFc7vdHk6wXeHIpPClN+J5p13O2kg0o/TnO4Sx8E9tWuMKIviRRxYB3QmDfRnFw/3HXhNpdnXcTzDk0ymwCTNy+m7yHtwUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098498; c=relaxed/simple;
	bh=i4b/ZWj1uWdhwQq2nawBMRNHchXEoyu8sj+sFFKPraw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkcU7P0e6ztrURf15xwZfH91rHYaCa2RVNuEeVktjWkCpnaBGiMyuMCutiGI6FVhYNl5yknRZ4VjfC1QpdJ4CMK7ZSQGA5F/WNLjgKXfRFMCNy1mspNRhnDx9wZoAwAJO9sgKErziwm1Xlmm31WjfDuU+YUA9AuNv1zY1FH11Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rn/yZmkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rn/yZmkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0401F00A3A;
	Wed, 19 Aug 2026 00:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098495;
	bh=2QXzil5bQGRj+fhyO+f+inWLrldsTmXoZtPr9xcVj/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rn/yZmkJph9M1SVVDtrB6nr+CabVXgQ8sRsanat4k/gWLkP3IYSDbTPsxupc5JytS
	 0eNWZ5WyJZxOwUlZ9QaS7t6/c14bC8eOMAm86LwzJ1YuCk6HIttVEZJ573JVslfdIJ
	 FRJ8OroToB1WzqbJ6g25nf4Qs5pVLHpyRTArra7tvJp5//ovH6V+LohjTWZK2wuMZj
	 KO3hA3dJ9veJwMXFWwqz2zZKPGQkycZDpZWDBA/3cD5V/OvlUPHVNhdrUq5MQEhZnp
	 fNWTtdm8eYWpgFP2MBoZ6j3op2GFbBOqePKiRHYoso8BLrV0KZTvcL4xocnELHEZdr
	 mQntgtNOvWotA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 06/38] xfs: factor xfs_blockgc_start_flush() from xfs_blockgc_flush_all()
Date: Wed, 19 Aug 2026 10:12:09 +1000
Message-ID: <20260819001442.1451892-7-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor xfs_blockgc_start_flush() out of xfs_blockgc_flush_all() to
provide an async variant that kicks the per-AG background blockgc
workers without waiting for them to complete.

xfs_blockgc_flush_all() uses synchronous flush_delayed_work() calls
to wait for the blockgc workers and inodegc to finish. This cannot
be used from contexts that hold the ILOCK because the blockgc
workers need to take the ILOCK to scan inodes for reclaimable
speculative preallocations, and the inode we hold the ILOCK on pins
journal space that the workers need to run transactions.

Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_icache.c | 27 +++++++++++++++++++--------
 fs/xfs/xfs_icache.h |  1 +
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 9d8dd30bd927..bad09cb090cc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1596,23 +1596,34 @@ xfs_blockgc_free_space(
 }
 
 /*
- * Reclaim all the free space that we can by scheduling the background blockgc
- * and inodegc workers immediately and waiting for them all to clear.
+ * Kick all the blockgc workers immediately so they start freeing speculative
+ * preallocations. This does not wait for the workers to complete, so callers
+ * that need to wait for space to become available should call
+ * xfs_blockgc_flush_all() instead.
  */
-int
-xfs_blockgc_flush_all(
+void
+xfs_blockgc_start_flush(
 	struct xfs_mount	*mp)
 {
 	struct xfs_perag	*pag = NULL;
 
 	trace_xfs_blockgc_flush_all(mp, __return_address);
 
-	/*
-	 * For each blockgc worker, move its queue time up to now.  If it wasn't
-	 * queued, it will not be requeued.  Then flush whatever is left.
-	 */
 	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		mod_delayed_work(mp->m_blockgc_wq, &pag->pag_blockgc_work, 0);
+}
+
+/*
+ * Reclaim all the free space that we can by scheduling the background blockgc
+ * and inodegc workers immediately and waiting for them all to clear.
+ */
+int
+xfs_blockgc_flush_all(
+	struct xfs_mount	*mp)
+{
+	struct xfs_perag	*pag = NULL;
+
+	xfs_blockgc_start_flush(mp);
 
 	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		flush_delayed_work(&pag->pag_blockgc_work);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 905944dafbe5..e68d13125f7b 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -62,6 +62,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
 int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
+void xfs_blockgc_start_flush(struct xfs_mount *mp);
 int xfs_blockgc_flush_all(struct xfs_mount *mp);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
-- 
2.55.0

