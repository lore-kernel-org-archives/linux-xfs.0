Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDE78F5C;
	Mon,  1 Apr 2024 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990156; cv=none; b=ZJOtd9Su+xbMORc0gsec4AjNrauFAmTqGSUZVOIBnNTNsyJX1pQPWYcS395yVn51d1VAelL1hakjEFOtppKgVhH3pShKv7eEY0LLk3xk1XriWKxEEW3wTAfdomtW55oA8Gsh+jKrvxSIobYpeS7q0EuQnLMMJacrZ6o3AQUV8pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990156; c=relaxed/simple;
	bh=MlqOcIYCoMHqKB7YyrX10lv+D1oQkEVU0Isk+5M2K+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HigZbKKCg2fd9bz294dq8qYzDaC4WUCOQIBVE2vyRjsQJARIB1pz0PZEUDj5ad+eQgvNOcE3ZJ5u22ttGP2aUhmda5EOeKSUAM8Fx46V+4IkWSxxEX5FVMDRmfeH+SNbFwikqGYJT6zj/lip+fStOeKKKTCvEbx/NFRmkWq4lUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8TYyixN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8TYyixN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6809C433C7;
	Mon,  1 Apr 2024 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990156;
	bh=MlqOcIYCoMHqKB7YyrX10lv+D1oQkEVU0Isk+5M2K+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8TYyixNbc4HsvUjcRa62/kmcIFhw2VnxErIk2s1ktarArV/Axn6ERNMh9YhaIeFx
	 YaLu27TegfR92Oh7l9scIHed62NaH15bBnld29uK9lB1bWMBptYEI9IUeZWm6KiBFV
	 G4LFPKB/ZZtJd6agz3drnq4fxG0zbSTn8KCbJH4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 263/396] xfs: make xchk_iget safer in the presence of corrupt inode btrees
Date: Mon,  1 Apr 2024 17:45:12 +0200
Message-ID: <20240401152555.747717568@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 3f113c2739b1b068854c7ffed635c2bd790d1492 upstream.

When scrub is trying to iget an inode, ensure that it won't end up
deadlocked on a cycle in the inode btree by using an empty transaction
to store all the buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.c |    6 ++++--
 fs/xfs/scrub/common.h |   25 +++++++++++++++++++++++++
 fs/xfs/scrub/inode.c  |    4 ++--
 3 files changed, 31 insertions(+), 4 deletions(-)

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
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -151,6 +151,11 @@ void xchk_iunlock(struct xfs_scrub *sc,
 
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
 
+/*
+ * Grab the inode at @inum.  The caller must have created a scrub transaction
+ * so that we can confirm the inumber by walking the inobt and not deadlock on
+ * a loop in the inobt.
+ */
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
 		struct xfs_buf **agi_bpp, struct xfs_inode **ipp);
@@ -158,6 +163,26 @@ void xchk_irele(struct xfs_scrub *sc, st
 int xchk_install_handle_inode(struct xfs_scrub *sc, struct xfs_inode *ip);
 
 /*
+ * Safe version of (untrusted) xchk_iget that uses an empty transaction to
+ * avoid deadlocking on loops in the inobt.  This should only be used in a
+ * scrub or repair setup routine, and only prior to grabbing a transaction.
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
+/*
  * Don't bother cross-referencing if we already found corruption or cross
  * referencing discrepancies.
  */
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -94,8 +94,8 @@ xchk_setup_inode(
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
-	/* Try a regular untrusted iget. */
-	error = xchk_iget(sc, sc->sm->sm_ino, &ip);
+	/* Try a safe untrusted iget. */
+	error = xchk_iget_safe(sc, sc->sm->sm_ino, &ip);
 	if (!error)
 		return xchk_install_handle_iscrub(sc, ip);
 	if (error == -ENOENT)


