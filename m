Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49946157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225027; cv=none; b=bEgP0A5Jd/jQlsXSShTvNjc8fQ3g5Jti+rgA04Q+iDeRQgCa7zsKrd29wz3TyT50SMk8GYzySO6AaRoDNe6r3aOGs9dzNrqAQKMb7BdnTZuI5pl8HZXv9PzESzlso5z2oMlQVFvL6Vt1cCBezXpBdsEpIkh85XvBTXXBoSDGpC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225027; c=relaxed/simple;
	bh=2rWW5Tz0EJnX+pPJjFPlj0UeANaEKmDZ5JlrWgPbkvo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P9kOtV0IYjtq92uwFC9S6WCjrog4fSi+Fb0T0S1mI6gBFwtUqvZhAXjMCt22ryjbfk3gxbj0DqAfMYqhVWSK/RjVCYgJyitcnND5t9rJmy/6OzXXH/Jx/aJiptQlvfBBt5BGBl85/Fliw8BX8ELZzQiuiDNSMC9lXB+jvoyzFrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erSwr1V2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erSwr1V2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27660C113CC;
	Mon, 15 Apr 2024 23:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225027;
	bh=2rWW5Tz0EJnX+pPJjFPlj0UeANaEKmDZ5JlrWgPbkvo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=erSwr1V2vTMxATX5DygMZX7bux8w0R4hV14ksxVIANhQNsz9JVtTIW0uJCJ4HelAk
	 TxbBGgug5aF3uV6YH49bJEEGUet2Qk4MVgbjuD+EmRujaNJF5Ox1FowhG8jQDLum/L
	 zaO1P8bJMH6h3Wx81t9MDhTbVGEcefVa7t/bhyW3f0GOEjkE6hZWcdXSz/YwQ4oDrz
	 gnLyRWh3FlNGsQVKbsKZvnIkL+FOLpB2KLe/RwJ4AeK2DL70IU5+bOX/7VPlxHDE53
	 LguaV8PiyuxTvkzVKvflxLqdJAnjotSGHH9C1SdOutEAopr46cPZmNNPJ85ga0Zhbf
	 RLIFrHM9+WJng==
Date: Mon, 15 Apr 2024 16:50:26 -0700
Subject: [PATCH 5/7] xfs: scrub should set preen if attr leaf has holes
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383166.88776.10579203400754158984.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
References: <171322383061.88776.6099178844393502891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If an attr block indicates that it could use compaction, set the preen
flag to have the attr fork rebuilt, since the attr fork rebuilder can
take care of that for us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c    |    2 ++
 fs/xfs/scrub/dabtree.c |   16 ++++++++++++++++
 fs/xfs/scrub/dabtree.h |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 4 files changed, 20 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7621e548d730..ba06be86ac7d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -428,6 +428,8 @@ xchk_xattr_block(
 		xchk_da_set_corrupt(ds, level);
 	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, 0, hdrsize))
 		xchk_da_set_corrupt(ds, level);
+	if (leafhdr.holes)
+		xchk_da_set_preen(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index c71254088dff..056de4819f86 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -78,6 +78,22 @@ xchk_da_set_corrupt(
 			__return_address);
 }
 
+/* Flag a da btree node in need of optimization. */
+void
+xchk_da_set_preen(
+	struct xchk_da_btree	*ds,
+	int			level)
+{
+	struct xfs_scrub	*sc = ds->sc;
+
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
+	trace_xchk_fblock_preen(sc, ds->dargs.whichfork,
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
+}
+
+/* Find an entry at a certain level in a da btree. */
 static struct xfs_da_node_entry *
 xchk_da_btree_node_entry(
 	struct xchk_da_btree		*ds,
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 4f8c2138a1ec..d654c125feb4 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -35,6 +35,7 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 
 /* Check for da btree corruption. */
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 026813205b47..ffaff7722bf2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -365,6 +365,7 @@ DEFINE_EVENT(xchk_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_preen);
 
 #ifdef CONFIG_XFS_QUOTA
 DECLARE_EVENT_CLASS(xchk_dqiter_class,

