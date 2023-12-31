Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A620BBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnF8ZWLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D23C433C8;
	Sun, 31 Dec 2023 20:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055272;
	bh=YsudRee/ls7MJNQV/J4h/Xtvv94ix6Avc8kKU5u3jWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KnF8ZWLosyqMd1OGBTsaUEzKPdXncA1VadBOLxRfvC+0YffGDRdmLMHdQmiiYy0Mn
	 Xg1HWRK/Vj5p9vYcD08r+qTfdEt5hli53Mm6iUpC6rtBrH8q/VxGbJaKH8flAqlDAP
	 Ov4AaxkhYJo5XXlSbmYAE5kVc2dRanXwwZbdCt5JaAk9+GGKLsCew75+XN8HOgyLiy
	 ICO4/5rMZa9TkKUaOxDuAfdW2Ve7CiyYjIKP9N3w1MgtgoQz2V/SlPVJWtHIS9ZTnX
	 5zjjSjqSGlxrp8bsjURzPVn37O09+vlFsYeu57+Gb6rLq/EpDdtQB0YRCYwerYbZU8
	 5jmC3jmtoJEhQ==
Date: Sun, 31 Dec 2023 12:41:11 -0800
Subject: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404838032.1754231.9577214018653873457.stgit@frogsfrogsfrogs>
In-Reply-To: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
References: <170404837990.1754231.2175141512934229542.stgit@frogsfrogsfrogs>
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
index 1ff867075026d..8b38a1a87954f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1012,6 +1012,33 @@ xfs_inobt_first_free_inode(
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
@@ -1264,6 +1291,13 @@ xfs_dialloc_ag_inobt(
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
@@ -1539,6 +1573,12 @@ xfs_dialloc_ag(
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

