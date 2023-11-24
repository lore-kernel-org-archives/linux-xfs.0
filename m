Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71983DB80
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lh9VLhpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840E9C433C8;
	Fri, 24 Nov 2023 23:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869614;
	bh=L4cX/e8I1fs1eO/n/4EwXAW6ENdZ9+tr7Kf5PAYRfNo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lh9VLhpmtf64b43w7/VuMLS2x4rLTg3bASY7yJY2g2DBIg6jnWZNBr7espfFjUwfs
	 6tGzrhH3WTwrhZ76hvRpEgC6yID3b/zxK+GuPuktlx67DtUpMLghMBtrxDWN9Xutr9
	 zaD2zhJ2pXod3NdaPlnlciu6XuE4V8t8XdjmdHn7RgT8cDS0XvFWnj7LReE6lkkZBw
	 ETgoWSzUwqdD7c8a3/Y/YhRCxFcbwJXfM0/hsV0ttCO+yR9Nkfl2KgKCweX2QNFGMY
	 xTr3QM75+e4BBQS/6EHPl12jvGRjclRYbWEUcKZ3LpIdOm/4ox7u04df8b9nGcunN1
	 HM/CGo+UeavsA==
Date: Fri, 24 Nov 2023 15:46:54 -0800
Subject: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <170086925774.2768713.17299783083709212096.stgit@frogsfrogsfrogs>
In-Reply-To: <170086925757.2768713.18061984370448871279.stgit@frogsfrogsfrogs>
References: <170086925757.2768713.18061984370448871279.stgit@frogsfrogsfrogs>
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

When scrub is trying to iget an inode, ensure that it won't end up
deadlocked on a cycle in the inode btree by using an empty transaction
to store all the buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |   19 +++++++++++++++++++
 fs/xfs/scrub/inode.c  |    4 ++--
 3 files changed, 25 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index de24532fe0830..23944fcc1a6ca 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -733,6 +733,8 @@ xchk_iget(
 	xfs_ino_t		inum,
 	struct xfs_inode	**ipp)
 {
+	ASSERT(sc->tp != NULL);
+
 	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
 }
 
@@ -882,8 +884,8 @@ xchk_iget_for_scrubbing(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_inode(sc, ip);
 	if (error == -ENOENT)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index cabdc0e16838c..a39dbe6be1e59 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -157,6 +157,25 @@ int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 void xchk_irele(struct xfs_scrub *sc, struct xfs_inode *ip);
 int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
+/*
+ * Safe version of (untrusted) xchk_iget that uses an empty transaction to
+ * avoid deadlocking on loops in the inobt.
+ */
+static inline int
+xchk_iget_safe(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp)
+{
+	int	error;
+
+	ASSERT(sc->tp == NULL);
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+	error = xchk_iget(sc, inum, ipp);
+	xchk_trans_cancel(sc);
+	return error;
+}
+
 /*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 889f556bc98f6..b7a93380a1ab0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -95,8 +95,8 @@ xchk_setup_inode(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_iscrub(sc, ip);
 	if (error == -ENOENT)

