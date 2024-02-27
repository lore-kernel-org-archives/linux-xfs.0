Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E424A2D
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000984; cv=none; b=fcj+xd8hLYl5V4L+FKQDD0rmggX7psRl0Eet/5UH2m3Dp1dQkON7DO479tbG1TgBWiQZ+oSgJDdGlMvkMJiRtzRewvdycop4CKvkhfhih4rAaOWBKqpT4R9QOcsytL9h4+o2w3xoEBz8+5+ARwemxm40inT+TV6haduSaCAqxWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000984; c=relaxed/simple;
	bh=cn3IT08JD8RVUeclcR/PcFm/heOA95VxPqXMMEOAD9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxB1ArPAH4LEuE/eb2J81zdA6VTIJVP+jAQI+ej4xzuVq34De3HAOlELLQRusb1DCpeamy2p8M5gxh1fakg3tClazDvBt5By0PIhbPf8174xYeu4htYaT6R1+4VL/MQmMwnKGlVLPx5UhamCX5ARLR0p8ZlvCvnJy460wjfPnDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDCYe7zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDCYe7zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53D9C433F1;
	Tue, 27 Feb 2024 02:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000984;
	bh=cn3IT08JD8RVUeclcR/PcFm/heOA95VxPqXMMEOAD9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CDCYe7zR7rwwiwZndoU5fE4MBbWyugB4jvzeb0hzmsD2MGkbE9hQYbCWXjfwEnApG
	 aK53LxjIa3Ubulb0W3HyulOP7A31jhvoKcpxkQQ0uLfpzidFXRD14Wl1ZpLk+Kuqmq
	 dPJLhpcKQdpdRpGTFv9tfJz/DtcYmrFwssa2ob0i72p4JbxOMvoVuPPlZuB5aEKz8b
	 vk7jsg2MGMNK4SMOl/wSmVJzRgOJ3Y24BXkW/6R5OE/+0q0R/42pwzmRRKWKKQZjWd
	 YsQlKFVNlxCcT+xpa/Gxe66SHx5vPh79rkF9aELQl7VNg7AJZQgW4H7fm2zF8UCj0L
	 6+8uAMYtHt5jA==
Date: Mon, 26 Feb 2024 18:29:43 -0800
Subject: [PATCH 4/6] xfs: scrub should set preen if attr leaf has holes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013696.939212.6555423507350211535.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/attr.c    |    2 ++
 fs/xfs/scrub/dabtree.c |   16 ++++++++++++++++
 fs/xfs/scrub/dabtree.h |    1 +
 fs/xfs/scrub/trace.h   |    1 +
 4 files changed, 20 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7621e548d7301..ba06be86ac7d4 100644
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
index c71254088dffe..056de4819f866 100644
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
index 4f8c2138a1ec6..d654c125feb4d 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -35,6 +35,7 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 
 /* Check for da btree corruption. */
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8a467e708a375..06d31b9dd0f47 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -365,6 +365,7 @@ DEFINE_EVENT(xchk_fblock_error_class, name, \
 
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
+DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_preen);
 
 #ifdef CONFIG_XFS_QUOTA
 DECLARE_EVENT_CLASS(xchk_dqiter_class,

