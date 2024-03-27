Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC8D20322
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505232; cv=none; b=AfymoLc1YM/3XcKyfP63arS3qOvz1xUoDVoktxnWb46EUSbeYkXyOFFcTt1b4bscTEAS6AkFBTdOQOg8qN8doGUlplsCjz3NsDE+QM1k7NDjJUSlG4OAwWYXfC1t2Ujk2MFH9vSiveRTXkYGA/wiJ6hOUgSLNKCQqYARMZ+Ig4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505232; c=relaxed/simple;
	bh=2sWqOig37wWqhGbcS361IXshqkRzjD0z5BmvMZYrGtc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4EGK01nz7sOZYW62VTc+dByChb7DXFR0jBEHn9UkSjUtKMzG56fF2RFtZ9njvbunHS+R+w36sBMKozydx2joq0lMwK32ZRIOTb72J6xMSVtMZT8By17ugLo2rMhWesU/cvBHx4KR6512G9MIsPLymyfVLmt/374vewrTM9tAgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pw0J2A1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pw0J2A1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0659DC433F1;
	Wed, 27 Mar 2024 02:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505232;
	bh=2sWqOig37wWqhGbcS361IXshqkRzjD0z5BmvMZYrGtc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pw0J2A1paUoVOQ0nX0QkDphEPhgC+SVfInbpxhiAPHfgi1C03IdAUQjhI6OuUFSBZ
	 8cZbhJdYe4Ev9AVVp60vwevLE9ANgnCU9GVa6OCb5PTtr53l/WS2+o0iMwtu9E25Y7
	 +nOK9scDxKVUdIB3wCb8ADtWls4sHJUPM/z92XKknTpt1mhJexl0dU9ZwrNl4DBIqo
	 YUyEnq46QIQNLjXaQ5ymtsF7R+4ivwZKxILYgh3hIb+pypX11Dz3SsTzTjN6vNh1n6
	 HgESdpJTfvzAzpBmF/V8pJr3sHDh/TDXYcaehPUksgwz+pA7zOTGA78FQqHYtxvBk9
	 PVE0ERsVL2HOA==
Date: Tue, 26 Mar 2024 19:07:11 -0700
Subject: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150385152.3220296.8658531433549060600.stgit@frogsfrogsfrogs>
In-Reply-To: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
References: <171150385109.3220296.4235209828218476119.stgit@frogsfrogsfrogs>
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
index e5ac3e5430c4e..8279d90da7e7b 100644
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

