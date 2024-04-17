Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2573FBAF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395711; cv=none; b=a48Kq5UE4GxQORQl4eg02BoeiTjSd5GiInbQo4Jc28Q2dHuCT98VUV2NZXD/Y5QlPQPvFThCVSnjfMyQOk4NcBFG0UFtNgQy1z5Jj7Bzy+abMwo1Z2p0kVIY6UsjVKohWtZJFKwyiKjIlZO9r1gFRKT7l2ZoD7IedLtTiD1rB2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395711; c=relaxed/simple;
	bh=VIeO4YB91Kz/nLYx9kdU8XH+RniAM3ic9ry+inxjb7I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzW3aSyXlGfNN21fvjx1uDxG7FIoeOD+5iflTiv3tRYEAn0Qd3BWBxRgKaj7A3N8r8nFNHZKKcHUWD5CmfvrmDWMSK1LNDq98LnVTbYbArM5LhM1PmeTjn77JlTC8x+35+67C8vXrMdEHdIJrne5f5F3I/hE7ws53x/zpUogaFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZBM3QEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZBM3QEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72B3C072AA;
	Wed, 17 Apr 2024 23:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395710;
	bh=VIeO4YB91Kz/nLYx9kdU8XH+RniAM3ic9ry+inxjb7I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MZBM3QEmZDQuV6XGSqkmX8GMbOtFvEXgWxv4UwBkeStHmprJIw75y6QbjzQqT1E1J
	 ARMaJlcdGUr8uUq0ZUJykSUupUJFNk3Hu+MsG0WlidcncFLNr5gc/ZYqXkhaEQqXlc
	 shPnl2H59u3hliMAtoL+V8iSwLc2omGFA+G4VDs8NSvs0ra8SkhdRp2pZ63uzYoSUY
	 zI11HfnzIf5FBGBgmoKuv5dL7mwQ8tgSKs2GW7VZp3LU95nxhPOauxyobzh7i0igyp
	 whrpU35xo53LPBocfWs/ZTDEEjntzX5wFRZiseiNxCuYYDvq0+6dhQ2sYlhwO8VFuh
	 UQ1bNwtzjP4iw==
Date: Wed, 17 Apr 2024 16:15:10 -0700
Subject: [PATCH 4/4] xfs: invalidate dentries for a file before moving it to
 the orphanage
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339556030.2000000.7320068975384720564.stgit@frogsfrogsfrogs>
In-Reply-To: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
References: <171339555949.2000000.17126642990842191341.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/orphanage.c |   47 ++++++++++++++++++++--------------------------
 fs/xfs/scrub/trace.h     |    2 --
 2 files changed, 20 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 2b142e6de8f3f..7148d8362db83 100644
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
index 4b945007ca6ca..e27daa51cab64 100644
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
 

