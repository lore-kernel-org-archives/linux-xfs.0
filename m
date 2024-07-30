Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA194A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299465; cv=none; b=DBHquw4I7VesGihzxrFlt0eggkdGixjh1CC3lDwD7sxyb0/KJppyY3bvofGrOHTDok1MgfGRUY8hu9dSqDIPIJEC82lluGHKTSTmEttH0z94huzwLT1iQiwS3eBSR6d3PJScOnRtAwSYoOPvUvAKP6mtFYVpBVfsqv2x8P6ZgWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299465; c=relaxed/simple;
	bh=yoV+PaP3B4jPyUMnVMu8AfI0bewOWJOcuoG55CGezys=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=srA9VFx07XKyWarIuvqov5NemXTydwjMBmwzcKMm2yHlFxCErx/gWXqhjwgBOoPrYu3teYNu/CBaYPeXrvEJLNxNkovU79ve0O8z4pHgbjd91ctBSSKngPCoIQ5ZNGHkOwuEl+U23xVf9FhS2SKuj/2KFfpAEkAxmVDdDVFr++0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lT1K4y5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lT1K4y5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B35C32786;
	Tue, 30 Jul 2024 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299465;
	bh=yoV+PaP3B4jPyUMnVMu8AfI0bewOWJOcuoG55CGezys=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lT1K4y5kLUyGwQISE5On8rO2Z2hV3enzAOI08pmzEqxgyGIBQscXHkpKOtTzQauS4
	 3hjKJEVWzQWvCLNT+I3RpJfsL3kV9HCxZhHr+QNpYTM6bSy5TrDjA0Sh3XTpuAcr8u
	 ie4w37gEfxWzNlHd6Xk8Ipc9sO+ZSF/2TZ3ILLonJZ7vFksU3SMo5jY1peEMBSoWd8
	 HzBM2PHCpQ3nCGxBbk/9Pygxw/PcMeXEf3jtF0y3pUTMM6X/HPM3OmVTFiaQGVuNLL
	 zhOQDGb5wgBcsPHpNc0FYmJx16flAK/pJHUDOSsELc9753VqwGJ6C8VtkO5jNSh7v/
	 IcZxJsLw7Pf8g==
Date: Mon, 29 Jul 2024 17:31:04 -0700
Subject: [PATCH 028/115] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842838.1338752.15052750263469564877.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2935213a6831a0087442d406301c2cdcc87b0f61

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
 libxfs/util.c       |    6 ++++++
 libxfs/xfs_ialloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index 841f4b963..2656c99a8 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -732,6 +732,12 @@ void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
+void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
+		unsigned int *checked)
+{
+	*sick = 0;
+	*checked = 0;
+}
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
 void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork) { }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 992b8348a..d8697561e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1052,6 +1052,33 @@ xfs_inobt_first_free_inode(
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
@@ -1304,6 +1331,13 @@ xfs_dialloc_ag_inobt(
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
@@ -1579,6 +1613,12 @@ xfs_dialloc_ag(
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

