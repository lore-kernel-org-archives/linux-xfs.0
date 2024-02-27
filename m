Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230BFBEA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709001250; cv=none; b=E5DqQgmpCJGBiJ+M66Yiv7zeeiqfT8AiOs2bZUHEnJsjouEpdS8PU+DCdis7N/woCx6eIhRiesatjO+sBZ2IYZ5EZCjX9SbP5fdYB4btRG0JmTYjEJVy37faAb+yorioO9ir8de4osiTsZnrs9byWKYOClnRmdCrjVJGn8xgiKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709001250; c=relaxed/simple;
	bh=jUP00XaIazqmIAk/vTLv2DO5UNXO+fCl3FuRKD+/lz4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gpDbV3XjvWY+P9p9z2HFxRAQbCpHoDAAflINAeWXOrL3ukkzGqbGNe2MKX85seTvE9VwaTsPn723ivGSN7vPfSfOup91jpApZBDuJLEXep4BJjoAPPEqqM8GERSA9Oo+elf1I5gqVdqvptKWm1I8p7MygfbALLdFylNeyL16WZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slyfK4FM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slyfK4FM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB450C433F1;
	Tue, 27 Feb 2024 02:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709001249;
	bh=jUP00XaIazqmIAk/vTLv2DO5UNXO+fCl3FuRKD+/lz4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=slyfK4FMQQ4iZIq/joBXwPoVowtr+dwSVBua5jIOf7rlD9/+ViijLY+gMKIEAZ/79
	 +hR5JsO7BR0uXoXUBFq2SxzCQeU3b1gdffWECodamoituRH9dn/eZsuJZmDt6aQdSZ
	 wHTIo7U4PWeCFgE+5BdcivgHU+isGY2PiRlPO4+gqbyPg1Be/x0Jcrq8g7ZN2qME5A
	 C76RxKW0iOmcreGXxw8TBweRPQArNWLA9xh1rqM+k5itayVqvpbT01uSWwS4BCuVHM
	 rAr4RazUinNtOrGSvr7YP9U7rXvRYCor5nua3AxLCPB814ezP8NO6mXTWqC6/C6inY
	 x6uQBHYwHrkyA==
Date: Mon, 26 Feb 2024 18:34:09 -0800
Subject: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900016075.940004.12735354681652774834.stgit@frogsfrogsfrogs>
In-Reply-To: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
References: <170900016032.940004.10036483809627191806.stgit@frogsfrogsfrogs>
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

