Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF11F10E5
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711178; cv=none; b=Q34PLb7XAAzrC/+N7t9k9DwR8WY5bibk/7cAxHWf3LrSjhbF7H0K8ZAyvMt5iaAmPdTEIfR8rKAW1OyBEqqNskJcd+7GOwX1e2MXGyfvbTEy5/pSjJ4iUXbjbCxsBwENITL15lHbTBOe5/BM5NQlWWPDyTsY3yWgQsIQqNysXc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711178; c=relaxed/simple;
	bh=1/3xXftZx+2sVV49D6PoB6tgXdTeulSYZdXkcVN79qg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkQaYP+OOySkPZiZ6tjzW1AzC6O7b9wjKKgTYwT0u7AHuLB/SiTYv4gjqZ0ChutpBMzw/jrjRNijHXZfd5pnFw9a9xWeqUJP/2MKrTmy9o+uFw850CoXAhUJ/X3xVn2S/Yxdh5dk3xYLwwN+MSKe9/u+msISvXDJDnee54693ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2UBBiva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2UBBiva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D60C433C7;
	Wed, 10 Apr 2024 01:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711178;
	bh=1/3xXftZx+2sVV49D6PoB6tgXdTeulSYZdXkcVN79qg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L2UBBivadt0W7qiGdzU0tq7xUVGAapmEG3NcrQAwhIbCaGaaYy25+hBFvag+8ailn
	 gBzaTZfhtojzyUIONulfPZock+W6zq2WkWYJ0bEZMbgkWaP+N1Swp09sRaCrII2pJs
	 OW3R0TBmhCrY4yxmStLT9ePIBV5zAxHuDYZ1y5nn5O71zTSzFX7SNVd/hl+GMVsGHV
	 uUv/w8JipqxuiS31CTofuJ+1Qa41CdxcK1SPoOGRw6/HSbtcBuG8moA5iNYokjqF08
	 EZBgaEpaZgIXD+BY4pkpU5lFjFjYAyfBUbkDNwvEJ4IIgnmkxC/uiIasHYU/AYMOLS
	 3zQT6vzDii89g==
Date: Tue, 09 Apr 2024 18:06:17 -0700
Subject: [PATCH 10/14] xfs: add a per-leaf block callback to xchk_xattr_walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971153.3632937.2520789896532879492.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/scrub/attr.c       |    2 +-
 fs/xfs/scrub/dir_repair.c |    2 +-
 fs/xfs/scrub/listxattr.c  |   10 +++++++++-
 fs/xfs/scrub/listxattr.h  |    4 +++-
 fs/xfs/scrub/nlinks.c     |    3 ++-
 fs/xfs/scrub/parent.c     |    7 ++++---
 6 files changed, 20 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index b91234bbd58aa..cba09ad9d45dc 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -661,7 +661,7 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		return error;
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 24c46211d9243..a8932d97ae886 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1285,7 +1285,7 @@ xrep_dir_scan_file(
 		goto scan_done;
 	}
 
-	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_pptr, rd);
+	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_pptr, NULL, rd);
 	if (error)
 		goto scan_done;
 
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index cbe5911ecbbcf..256ff7700c942 100644
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
index 48fe89d05946b..703cfb7b14cfd 100644
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
index a733e4e178de4..124a8d6b7a04d 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -431,7 +431,8 @@ xchk_nlinks_collect_dir(
 			goto out_unlock;
 		}
 
-		error = xchk_xattr_walk(sc, dp, xchk_nlinks_collect_pptr, xnc);
+		error = xchk_xattr_walk(sc, dp, xchk_nlinks_collect_pptr, NULL,
+				xnc);
 		if (error == -ECANCELED) {
 			error = 0;
 			goto out_unlock;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 57b49fbf97a30..8f92a54c6d981 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -314,7 +314,7 @@ xchk_parent_pptr_and_dotdot(
 		return 0;
 
 	/* Otherwise, walk the pptrs again, and check. */
-	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_dotdot, pp);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_dotdot, NULL, pp);
 	if (error == -ECANCELED) {
 		/* Found a parent pointer that matches dotdot. */
 		return 0;
@@ -692,7 +692,8 @@ xchk_parent_count_pptrs(
 	 */
 	if (pp->need_revalidate) {
 		pp->pptrs_found = 0;
-		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr, pp);
+		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr,
+				NULL, pp);
 		if (error == -EFSCORRUPTED) {
 			/* Found a bad parent pointer */
 			xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
@@ -751,7 +752,7 @@ xchk_parent_pptr(
 	if (error)
 		goto out_entries;
 
-	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, NULL, pp);
 	if (error == -ECANCELED) {
 		error = 0;
 		goto out_names;

