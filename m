Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4914A13AD
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871899; cv=none; b=nLLLMMqi3cxXSB6dmaCht85gal3+glpvwRuUFQZaj9/F1IXPlyQsawKsIIt2KDqyQ+/EGZMMbQYM9rwMcyxpFnky6uCr9AVSNvbktREBU0yAesIeYOj8fM7XT7vJp51mwHZgEbL4IDVkdmIxbGjj83uOY0EJy/Wh8qKlZRbFZMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871899; c=relaxed/simple;
	bh=VgFwi9lLax2gQGL1l4Z9LrQN96tNN7flwJQsDcRTsFU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vs2n3+QGVoZsT17l8FsW9OuJ+65OBXze7CJ0Qd47gBhkcX5jNwbN6uPYuEPS+6vuIL0A8tBfwQvyD2IWkzxnKscCfY8T2MixLlII2I/TFgyLgu5XIaC6W3o0QkV63mBeX3QOoY2cdQdFOzB8hC8GMkSWrGwDKv5jMbMuQEiZlhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAY7FqMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAY7FqMl"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5E1251F00893;
	Tue, 13 Oct 2026 06:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871888;
	bh=t43j+gx2AiuNBnCDCXncJTHFdsd4Cl2yLUgjAy80V/Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=BAY7FqMlcn5Ukq6sDu+94yRGwLlWgdSlDkrm5DIQY/zRttYRfqoiav3f2R32XcL3/
	 mp67L/KvXXEwH9SXMrt5JxzxHdflrGofifbM2HhyBgi2a6yDPEw5Eo/Whvk3YzSyJh
	 ntUfKJeHQnYWW/fPcVYnHnkEbJ7pOazWO3KVPhaCQ/2QZEEhf5Rb/BdnMHFncRKJKq
	 p9G54U1xTpkazR2Ev1munJ0bD8XqqxR6hpon6upN4Wh7S2kyL6+ACYiTNcJijDcCKD
	 JPuCSbWEOzd4XUn1OExoRI55ZQuDdiajn+5YOuW4jycOxOCmf+fB3ecJ/C8Qt8ymNv
	 D8ExVrJsLcX1w==
Date: Mon, 12 Oct 2026 23:11:27 -0700
Subject: [PATCH 12/12] xfs: refactor inode forkoff to byte conversions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179186108108.1898896.16447874565212812355.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
References: <179186107760.1898896.12318125940367230627.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A reviewer suggested that I formalize the conversion between the inode
forkoff field and actual byte count, so let's add a few conversion
macros and a helper function to compute the default forkoff; and then
adjust the codebase to use them.

No functional changes intended.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.h       |    6 ++++++
 fs/xfs/libxfs/xfs_format.h     |    6 +++++-
 fs/xfs/xfs_inode.h             |    2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c  |   12 ++++++------
 fs/xfs/libxfs/xfs_bmap.c       |    4 ++--
 fs/xfs/libxfs/xfs_inode_buf.c  |    4 ++--
 fs/xfs/libxfs/xfs_inode_util.c |    2 +-
 fs/xfs/scrub/inode.c           |    2 +-
 fs/xfs/scrub/inode_repair.c    |    4 ++--
 9 files changed, 26 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fada..d3c7641e36f5e2 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -213,6 +213,12 @@ void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
+
+static inline uint xfs_inode_default_forkoff(struct xfs_inode *ip)
+{
+	return XFS_B_TO_FORKOFFT(xfs_default_attroffset(ip));
+}
+
 int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1a7a7e60a170c4..469e879149ac21 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1096,7 +1096,11 @@ enum xfs_dinode_fmt {
 /*
  * Inode data & attribute fork sizes, per inode.
  */
-#define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
+#define XFS_B_TO_FORKOFFT(b)		((b) >> 3)
+#define XFS_B_TO_FORKOFF(b)		XFS_B_TO_FORKOFFT((b) + 7)
+#define XFS_FORKOFF_TO_B(f)		((int)(f) << 3)
+
+#define XFS_DFORK_BOFF(dip)		XFS_FORKOFF_TO_B((dip)->di_forkoff)
 
 #define XFS_DFORK_DSIZE(dip,mp) \
 	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1602027cd0aa5d..53a1997b98660b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -132,7 +132,7 @@ xfs_ifork_ptr(
 
 static inline unsigned int xfs_inode_fork_boff(struct xfs_inode *ip)
 {
-	return ip->i_forkoff << 3;
+	return XFS_FORKOFF_TO_B(ip->i_forkoff);
 }
 
 static inline unsigned int xfs_inode_data_fork_size(struct xfs_inode *ip)
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2c80f4fd0b78de..1cefd41a2f9e01 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -720,10 +720,10 @@ xfs_attr_shortform_bytesfit(
 		return 0;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp) - bytes) >> 3;
+	offset = XFS_B_TO_FORKOFFT(XFS_LITINO(mp) - bytes);
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_DEV) {
-		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		minforkoff = XFS_B_TO_FORKOFF(sizeof(xfs_dev_t));
 		return (offset >= minforkoff) ? minforkoff : 0;
 	}
 
@@ -779,12 +779,12 @@ xfs_attr_shortform_bytesfit(
 	 * A data fork btree root must have space for at least
 	 * MINDBTPTRS key/ptr pairs if the data fork is small or empty.
 	 */
-	minforkoff = max_t(int64_t, dsize, xfs_bmdr_space_calc(MINDBTPTRS));
-	minforkoff = roundup(minforkoff, 8) >> 3;
+	minforkoff = XFS_B_TO_FORKOFF(
+			max_t(int64_t, dsize, xfs_bmdr_space_calc(MINDBTPTRS)));
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS);
-	maxforkoff = maxforkoff >> 3;	/* rounded down */
+	maxforkoff = XFS_B_TO_FORKOFFT(
+			XFS_LITINO(mp) - xfs_bmdr_space_calc(MINABTPTRS));
 
 	if (offset >= maxforkoff)
 		return maxforkoff;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d64defeda645ed..7e463314af4dcc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -221,7 +221,7 @@ xfs_bmap_forkoff_reset(
 	if (whichfork == XFS_ATTR_FORK &&
 	    ip->i_df.if_format != XFS_DINODE_FMT_DEV &&
 	    ip->i_df.if_format != XFS_DINODE_FMT_BTREE) {
-		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
+		uint	dfl_forkoff = xfs_inode_default_forkoff(ip);
 
 		if (dfl_forkoff > ip->i_forkoff)
 			ip->i_forkoff = dfl_forkoff;
@@ -997,7 +997,7 @@ xfs_bmap_set_attrforkoff(
 	struct xfs_inode	*ip,
 	int			size)
 {
-	int			default_size = xfs_default_attroffset(ip) >> 3;
+	int			default_size = xfs_inode_default_forkoff(ip);
 
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0340e2189921db..df77dd5c97611c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -490,7 +490,7 @@ xfs_dinode_verify_forkoff(
 
 	switch (dip->di_format)  {
 	case XFS_DINODE_FMT_DEV:
-		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
+		if (dip->di_forkoff != XFS_B_TO_FORKOFF(sizeof(xfs_dev_t)))
 			return __this_address;
 		break;
 	case XFS_DINODE_FMT_META_BTREE:
@@ -500,7 +500,7 @@ xfs_dinode_verify_forkoff(
 	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
 	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
 	case XFS_DINODE_FMT_BTREE:
-		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
+		if (dip->di_forkoff >= XFS_B_TO_FORKOFFT(XFS_LITINO(mp)))
 			return __this_address;
 		break;
 	default:
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 258ac3d0d486e6..e63bb1fad9c014 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -346,7 +346,7 @@ xfs_inode_init(
 	}
 
 	if (xfs_icreate_want_attrfork(mp, args)) {
-		ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
+		ip->i_forkoff = xfs_inode_default_forkoff(ip);
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 
 		if (!xfs_has_attr(mp)) {
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6cded1eb6c2b6f..bb8d2bc008e019 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -607,7 +607,7 @@ xchk_dinode(
 	}
 
 	/* di_forkoff */
-	if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
+	if (dip->di_forkoff >= XFS_B_TO_FORKOFFT(XFS_LITINO(mp)))
 		xchk_ino_set_corrupt(sc, ino);
 	if (naextents != 0 && dip->di_forkoff == 0)
 		xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index a42ce1d014dfb3..c6f221254f0bb0 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1490,7 +1490,7 @@ xrep_dinode_ensure_forkoff(
 
 			/* Otherwise, just slide the attr fork up. */
 			before = XFS_DFORK_APTR(dip);
-			dip->di_forkoff = bmdr_minsz >> 3;
+			dip->di_forkoff = XFS_B_TO_FORKOFFT(bmdr_minsz);
 			after = XFS_DFORK_APTR(dip);
 			memmove(after, before, XFS_DFORK_ASIZE(dip, sc->mp));
 		}
@@ -1522,7 +1522,7 @@ xrep_dinode_ensure_forkoff(
 			 * fork is empty, so we don't have any old contents to
 			 * move here.
 			 */
-			dip->di_forkoff = (lit_sz - bmdr_minsz) >> 3;
+			dip->di_forkoff = XFS_B_TO_FORKOFFT(lit_sz - bmdr_minsz);
 		}
 	}
 }

