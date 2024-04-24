Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0585C46
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929123; cv=none; b=mpJBYhFs4ewUZPCwac+BxGD0WNDkhktm3yn5/3eiQxh01HhnOmDenrd45FVDs9EF09SqPigmn+wBQsmN+mBNUYmquTZd7K/8SsfPGwgFJfEiNJg6bdwT4wePcxJ7sTFrnlBDIBmNRPwwBh9Utf7sRtiZM8Se8a/gjSpEbBBolh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929123; c=relaxed/simple;
	bh=xwobEpzD/mI7dBAJE7inuYimu2fqhFrJhSyz2qLJ+i4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qgfGp0WzwxFwoauReqtz8y4gmAnJ3N8Y9wBTsIZtGQzAcPNJhssfuvjLY69DJM0eszRKKBZzw62Gzv31Zqd4cV+AZ/jBk5N3r2aJApugnMsxch6sCfpD0W4qz3TUAqSs53NXLDXbBdAHF/pdv52vD7NP1yRa17wPB0LSezceGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tdtq0j6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tdtq0j6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF87BC116B1;
	Wed, 24 Apr 2024 03:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929123;
	bh=xwobEpzD/mI7dBAJE7inuYimu2fqhFrJhSyz2qLJ+i4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tdtq0j6RWpeQXZ1O1nSFwHdCmIG57qqF7stME1kOZ91OjptNA5xaNpidb/GGLHQn6
	 OzIcRN2QCA1KINw0+bmr76Q/JxZSE85xqMhK5JKSzXPyqnDlyPGJIEYGfzeCHiny1N
	 9PG3RUMwAO6Hk78w21j2lqzCIhC+O+Ijjv1EvM0e3VyrzxoUjCNz0X0R53Ltamljh0
	 FhlWZny4z8lF1Y4ymsS+gR2gs/Cr9BySR/dwJoWMvVmsymXG1IMZb4tr3BBBxdzgoS
	 5DtelnjUATCCAo2+GtHbmEYDRdyybxYoY5yQEAovDdQDPn2kB8o2qo0yQM41PqJWNu
	 PeyL5iA8JCsyw==
Date: Tue, 23 Apr 2024 20:25:22 -0700
Subject: [PATCH 12/16] xfs: add a per-leaf block callback to xchk_xattr_walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784855.1906420.2572974536996614087.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

Add a second callback function to xchk_xattr_walk so that we can do
something in between attr leaf blocks.  This will be used by the next
patch to see if we should flush cached parent pointer updates to
constrain memory usage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c       |    2 +-
 fs/xfs/scrub/dir_repair.c |    2 +-
 fs/xfs/scrub/listxattr.c  |   10 +++++++++-
 fs/xfs/scrub/listxattr.h  |    4 +++-
 fs/xfs/scrub/nlinks.c     |    3 ++-
 fs/xfs/scrub/parent.c     |    7 ++++---
 6 files changed, 20 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b550f3e34ffc..708334f9b2bd 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -675,7 +675,7 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		return error;
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 60e31da4451e..e968150fe0f0 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1288,7 +1288,7 @@ xrep_dir_scan_file(
 		goto scan_done;
 	}
 
-	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_pptr, rd);
+	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_pptr, NULL, rd);
 	if (error)
 		goto scan_done;
 
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index cbe5911ecbbc..256ff7700c94 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -221,6 +221,7 @@ xchk_xattr_walk_node(
 	struct xfs_scrub		*sc,
 	struct xfs_inode		*ip,
 	xchk_xattr_fn			attr_fn,
+	xchk_xattrleaf_fn		leaf_fn,
 	void				*priv)
 {
 	struct xfs_attr3_icleaf_hdr	leafhdr;
@@ -252,6 +253,12 @@ xchk_xattr_walk_node(
 
 		xfs_trans_brelse(sc->tp, leaf_bp);
 
+		if (leaf_fn) {
+			error = leaf_fn(sc, priv);
+			if (error)
+				goto out_bitmap;
+		}
+
 		/* Make sure we haven't seen this new leaf already. */
 		len = 1;
 		if (xdab_bitmap_test(&seen_dablks, leafhdr.forw, &len)) {
@@ -288,6 +295,7 @@ xchk_xattr_walk(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip,
 	xchk_xattr_fn		attr_fn,
+	xchk_xattrleaf_fn	leaf_fn,
 	void			*priv)
 {
 	int			error;
@@ -308,5 +316,5 @@ xchk_xattr_walk(
 	if (xfs_attr_is_leaf(ip))
 		return xchk_xattr_walk_leaf(sc, ip, attr_fn, priv);
 
-	return xchk_xattr_walk_node(sc, ip, attr_fn, priv);
+	return xchk_xattr_walk_node(sc, ip, attr_fn, leaf_fn, priv);
 }
diff --git a/fs/xfs/scrub/listxattr.h b/fs/xfs/scrub/listxattr.h
index 48fe89d05946..703cfb7b14cf 100644
--- a/fs/xfs/scrub/listxattr.h
+++ b/fs/xfs/scrub/listxattr.h
@@ -11,7 +11,9 @@ typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
 		unsigned int namelen, const void *value, unsigned int valuelen,
 		void *priv);
 
+typedef int (*xchk_xattrleaf_fn)(struct xfs_scrub *sc, void *priv);
+
 int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
-		xchk_xattr_fn attr_fn, void *priv);
+		xchk_xattr_fn attr_fn, xchk_xattrleaf_fn leaf_fn, void *priv);
 
 #endif /* __XFS_SCRUB_LISTXATTR_H__ */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index d27b32e6f33d..80aee30886c4 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -434,7 +434,8 @@ xchk_nlinks_collect_dir(
 			goto out_unlock;
 		}
 
-		error = xchk_xattr_walk(sc, dp, xchk_nlinks_collect_pptr, xnc);
+		error = xchk_xattr_walk(sc, dp, xchk_nlinks_collect_pptr, NULL,
+				xnc);
 		if (error == -ECANCELED) {
 			error = 0;
 			goto out_unlock;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 068691434be1..733c410a2279 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -317,7 +317,7 @@ xchk_parent_pptr_and_dotdot(
 		return 0;
 
 	/* Otherwise, walk the pptrs again, and check. */
-	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_dotdot, pp);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_dotdot, NULL, pp);
 	if (error == -ECANCELED) {
 		/* Found a parent pointer that matches dotdot. */
 		return 0;
@@ -699,7 +699,8 @@ xchk_parent_count_pptrs(
 	 */
 	if (pp->need_revalidate) {
 		pp->pptrs_found = 0;
-		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr, pp);
+		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr,
+				NULL, pp);
 		if (error == -EFSCORRUPTED) {
 			/* Found a bad parent pointer */
 			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
@@ -758,7 +759,7 @@ xchk_parent_pptr(
 	if (error)
 		goto out_entries;
 
-	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, NULL, pp);
 	if (error == -ECANCELED) {
 		error = 0;
 		goto out_names;

