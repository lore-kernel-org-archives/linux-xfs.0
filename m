Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273082E852
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225340; cv=none; b=ATf1OxhreksY/rf+X8JON+J0pa2mY5TA0yDdjIiQzBF4zbWKxyVNlAv099uZEbqCs3G9k/G7Rm75w6R6EFUVgVqWz7CnaEJZLOL2qZKsAysfa3Wntwsa0RkkZTUlAAcP91Qf4Fv0KSvG2T3+uS0A91CBvGwTmfRINn7PVSsddfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225340; c=relaxed/simple;
	bh=jvrWEKl4fTWm9G2k7pNN+6P+D6rJdWlx2p9TLGSJQGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZss0SsQ1gSPu9bLQJQK4XUUGAlH7rNYupH9XOUdrxQeRx/ezK+vn2JVyEW38VRFDCH7P9fLwY6FfadEyyqsHu58NSBafpM6+eNBwmH8X5ikG9ReZdpmiGGfaRL+fBtsge42Mh+syVqnAI/RHEgYtoLR4iHYo0urP46BtyJk9cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CpngSvfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CpngSvfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DA2C113CC;
	Mon, 15 Apr 2024 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225339;
	bh=jvrWEKl4fTWm9G2k7pNN+6P+D6rJdWlx2p9TLGSJQGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CpngSvfvWZ66pF0Sv1rqywoUjTKQKS09ZV9/UiZwx4hqNSTEJ0dz6lOj+zfBW7RW4
	 W21OmGWO4Tz0lyJvhA0S1riob3sRuEnwP8d7Q5UipGJlZAz3rGji7BD7vOcxw4FdpT
	 qJNwENbY/EVt3G5go5ywMFlKK578r3xmLjWNmsoh07qwBX0anfv+1bPyZdi93FxZff
	 TH7TaUZsxyINGgi7myxoL5hZsixkBmuztZ0N9FiF9EldmaKgLxfv9Etw8tSKte0Zf4
	 3V8jswm4kUAR3aqA9CaLLQNX4IOqc89iYxxdf8DBtTBUV+ttpurtOAoniVTg0nb2ST
	 1nI9yLcLAo6tQ==
Date: Mon, 15 Apr 2024 16:55:39 -0700
Subject: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322385424.91610.798083417529129061.stgit@frogsfrogsfrogs>
In-Reply-To: <171322385380.91610.2309150776734623689.stgit@frogsfrogsfrogs>
References: <171322385380.91610.2309150776734623689.stgit@frogsfrogsfrogs>
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

I noticed that xfs/413 and xfs/375 occasionally failed while fuzzing
core.mode of an inode.  The root cause of these problems is that the
field we fuzzed (core.mode or core.magic, typically) causes the entire
inode cluster buffer verification to fail, which affects several inodes
at once.  The repair process tries to create either a /lost+found or a
temporary repair file, but regrettably it picks the same inode cluster
that we just corrupted, with the result that repair triggers the demise
of the filesystem.

Try avoid this by making the inode allocation path detect when the perag
health status indicates that someone has found bad inode cluster
buffers, and try to read the inode cluster buffer.  If the cluster
buffer fails the verifiers, try another AG.  This isn't foolproof and
can result in premature ENOSPC, but that might be better than shutting
down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ialloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index cb37f0007731..14c81f227c5b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1057,6 +1057,33 @@ xfs_inobt_first_free_inode(
 	return xfs_lowbit64(realfree);
 }
 
+/*
+ * If this AG has corrupt inodes, check if allocating this inode would fail
+ * with corruption errors.  Returns 0 if we're clear, or EAGAIN to try again
+ * somewhere else.
+ */
+static int
+xfs_dialloc_check_ino(
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino)
+{
+	struct xfs_imap		imap;
+	struct xfs_buf		*bp;
+	int			error;
+
+	error = xfs_imap(pag, tp, ino, &imap, 0);
+	if (error)
+		return -EAGAIN;
+
+	error = xfs_imap_to_bp(pag->pag_mount, tp, &imap, &bp);
+	if (error)
+		return -EAGAIN;
+
+	xfs_trans_brelse(tp, bp);
+	return 0;
+}
+
 /*
  * Allocate an inode using the inobt-only algorithm.
  */
@@ -1309,6 +1336,13 @@ xfs_dialloc_ag_inobt(
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+
+	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
+		error = xfs_dialloc_check_ino(pag, tp, ino);
+		if (error)
+			goto error0;
+	}
+
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 	error = xfs_inobt_update(cur, &rec);
@@ -1584,6 +1618,12 @@ xfs_dialloc_ag(
 				   XFS_INODES_PER_CHUNK) == 0);
 	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
 
+	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
+		error = xfs_dialloc_check_ino(pag, tp, ino);
+		if (error)
+			goto error_cur;
+	}
+
 	/*
 	 * Modify or remove the finobt record.
 	 */

