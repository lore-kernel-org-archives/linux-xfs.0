Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFFC13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEgt2DFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DE3C433C7;
	Sun, 31 Dec 2023 22:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062155;
	bh=JmzvmOgsePx4ZkN1JXcbHLd9xvilKJjvoQ8UHPBSX1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KEgt2DFl5Jchamlyk5+B1JBJjbEezCT0ePgBX2FQ5NdkUNjj0HOMovG9DN6Y8JfpI
	 gxu8sHKE043/WpAkkgiuzgLpKCNV1DWhmapee/WB2YN8CNeP07GcX5dfYgQ4bF5Waa
	 GrWr7xZedVuCAr/mOviPyNqLRTyQhjaD/wbQf5fEOpbb3ii+jlQRGblw8K1TDJ7Ifq
	 xuEFSOFE6uFiVkJPRn4mKOe1K83Z0PmIF0i1TmfUVln745I+mnfqQMwdpMzbejGTjW
	 kWdS4ZBGfrBFGC0MV0n6rd+5NPflqFoyOdYvYd90z4m/2Y7tyTsx0wYYsxGiretJwf
	 ELL2HXmzzA2wg==
Date: Sun, 31 Dec 2023 14:35:55 -0800
Subject: [PATCH 2/4] xfs: try to avoid allocating from sick inode clusters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404998319.1797172.10634924197446175862.stgit@frogsfrogsfrogs>
In-Reply-To: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
References: <170404998289.1797172.11188208357520292150.stgit@frogsfrogsfrogs>
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
 libxfs/util.c       |    6 ++++++
 libxfs/xfs_ialloc.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index 097362d488d..c1ddaf92c8a 100644
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
index 21577a50f65..46d4515baba 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1007,6 +1007,33 @@ xfs_inobt_first_free_inode(
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
@@ -1259,6 +1286,13 @@ xfs_dialloc_ag_inobt(
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
@@ -1534,6 +1568,12 @@ xfs_dialloc_ag(
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

