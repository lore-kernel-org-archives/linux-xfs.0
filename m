Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7A712E1E9
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929389; cv=none; b=LcfzqVU7yTNlGbOy39AG0vRiePznwty6cgr4D/3CkBRTqlxKLO9VrlByWYq+mNiFmkFW3EQj+uevcl85MrQDDmjKynt4LvInUVi7ml78yLYd2vL7Qz/IA/4+Xmm73YzvoFnY3UIMdMZXhBqgJflqWemTxM7iYbjn8xg4yi5ekxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929389; c=relaxed/simple;
	bh=uzbSM4yoQdxZxyyBhJnMsyW8DXk0+Kpgc0iUWeQbGk0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2eNNFuTV2Q+IN0bH4uXBDP1DSjtak7YZqstxFW9QjbioOHTf2+iqVdEHVrX4Y7ttwQKNH8w13Hajd/wb8jazr95ZmYxW3ak7T2rSTOTi/pk91xWu4xysRjgu7ePEPL38i0xQ6ohjYIwOyJGEAUBSrKnGSppQ8Rip5sxG/iwJEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+Tcx8fD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+Tcx8fD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BF3C116B1;
	Wed, 24 Apr 2024 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929389;
	bh=uzbSM4yoQdxZxyyBhJnMsyW8DXk0+Kpgc0iUWeQbGk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z+Tcx8fDd+FO2LrD3SWuuvrxlmlsI/JvsqfNohWHNNkBBDWquQXHFhJ9TcPdSeXYW
	 XP51QQ1p2L8bv0Xpq/xxUojeS7amKJ8yP4QLblaA8WYHY0Q0Jy9kg+/CbLGDcxoSQH
	 u+wyC+m45zchG5l8R4Pj3xjKZ52cegRORV7EKMiYbUXyQTjjBGZAaQwVcBasAPMKGi
	 A4Gi/ws4pBvjU7pK9Da/ciFltTWr2F9QLPl7QL4pLZVOx5+BDAmbAxDrRisob4IbIR
	 VzKbPKQPnw0RNOIePgD8LYPjlruPVXWAXN1ggFYoKXuuThoxl2gUenNUoLZKQmUmyj
	 Wfse0LZo97v1Q==
Date: Tue, 23 Apr 2024 20:29:48 -0700
Subject: [PATCH 4/4] xfs: invalidate dentries for a file before moving it to
 the orphanage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392786464.1907482.17907129310276500940.stgit@frogsfrogsfrogs>
In-Reply-To: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
References: <171392786386.1907482.12122730497500276549.stgit@frogsfrogsfrogs>
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

Invalidate the cached dentries that point to the file that we're moving
to lost+found before we actually move it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/orphanage.c |   47 ++++++++++++++++++++--------------------------
 fs/xfs/scrub/trace.h     |    2 --
 2 files changed, 20 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 2b142e6de8f3..7148d8362db8 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -434,16 +434,17 @@ xrep_adoption_check_dcache(
 {
 	struct qstr		qname = QSTR_INIT(adopt->xname->name,
 						  adopt->xname->len);
+	struct xfs_scrub	*sc = adopt->sc;
 	struct dentry		*d_orphanage, *d_child;
 	int			error = 0;
 
-	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	d_orphanage = d_find_alias(VFS_I(sc->orphanage));
 	if (!d_orphanage)
 		return 0;
 
 	d_child = d_hash_and_lookup(d_orphanage, &qname);
 	if (d_child) {
-		trace_xrep_adoption_check_child(adopt->sc->mp, d_child);
+		trace_xrep_adoption_check_child(sc->mp, d_child);
 
 		if (d_is_positive(d_child)) {
 			ASSERT(d_is_negative(d_child));
@@ -454,33 +455,15 @@ xrep_adoption_check_dcache(
 	}
 
 	dput(d_orphanage);
-	if (error)
-		return error;
-
-	/*
-	 * Do we need to update d_parent of the dentry for the file being
-	 * repaired?  There shouldn't be a hashed dentry with a parent since
-	 * the file had nonzero nlink but wasn't connected to any parent dir.
-	 */
-	d_child = d_find_alias(VFS_I(adopt->sc->ip));
-	if (!d_child)
-		return 0;
-
-	trace_xrep_adoption_check_alias(adopt->sc->mp, d_child);
-
-	if (d_child->d_parent && !d_unhashed(d_child)) {
-		ASSERT(d_child->d_parent == NULL || d_unhashed(d_child));
-		error = -EFSCORRUPTED;
-	}
-
-	dput(d_child);
 	return error;
 }
 
 /*
- * Remove all negative dentries from the dcache.  There should not be any
- * positive entries, since we've maintained our lock on the orphanage
- * directory.
+ * Invalidate all dentries for the name that was added to the orphanage
+ * directory, and all dentries pointing to the child inode that was moved.
+ *
+ * There should not be any positive entries for the name, since we've
+ * maintained our lock on the orphanage directory.
  */
 static void
 xrep_adoption_zap_dcache(
@@ -488,15 +471,17 @@ xrep_adoption_zap_dcache(
 {
 	struct qstr		qname = QSTR_INIT(adopt->xname->name,
 						  adopt->xname->len);
+	struct xfs_scrub	*sc = adopt->sc;
 	struct dentry		*d_orphanage, *d_child;
 
-	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	/* Invalidate all dentries for the adoption name */
+	d_orphanage = d_find_alias(VFS_I(sc->orphanage));
 	if (!d_orphanage)
 		return;
 
 	d_child = d_hash_and_lookup(d_orphanage, &qname);
 	while (d_child != NULL) {
-		trace_xrep_adoption_invalidate_child(adopt->sc->mp, d_child);
+		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
 
 		ASSERT(d_is_negative(d_child));
 		d_invalidate(d_child);
@@ -505,6 +490,14 @@ xrep_adoption_zap_dcache(
 	}
 
 	dput(d_orphanage);
+
+	/* Invalidate all the dentries pointing down to this file. */
+	while ((d_child = d_find_alias(VFS_I(sc->ip))) != NULL) {
+		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
+
+		d_invalidate(d_child);
+		dput(d_child);
+	}
 }
 
 /*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4b945007ca6c..e27daa51cab6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3265,8 +3265,6 @@ DEFINE_EVENT(xrep_dentry_class, name, \
 	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry), \
 	TP_ARGS(mp, dentry))
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_child);
-DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_alias);
-DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_dentry);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_invalidate_child);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_dirtree_delete_child);
 

