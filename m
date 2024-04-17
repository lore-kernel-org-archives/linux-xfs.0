Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AEA171A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713390394; cv=none; b=JejeIc1plv/U9waNDGCDjUdjQk4yEvjHfl4w2KtFHdp9OMWa7ooOJG7vlxCh0dxUGblW4jHuDMpbgekV7BOVuUnz9N7oyV0SfGPw0/nTgLifooy+ENVJknAdmsvKXK3LSxQ5rPyPxR+oRem3tp7T449JyS5DvpQytj7aG9kg7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713390394; c=relaxed/simple;
	bh=IkuUTzBPp4TL/+z0ECc8ZYZiuf2N+3ffodya7FYudBw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRlyef8Tc04EqjBZ+GZiDGPF+3AEfF9+qyhlKqJdjZLLnNzuWg8NU2Yy/ChqWheFpKpxNCDJ5uvSuRKweGNCPY7KvEcodlT3UMNWnEaVdyGj9/eRUfRmtbJrfpLW3xbOUup0Vc/IfY1V1Kdy539EwRquOgi9LJp3NHPTrhC4eXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yr+0RZEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yr+0RZEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC43C072AA;
	Wed, 17 Apr 2024 21:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713390394;
	bh=IkuUTzBPp4TL/+z0ECc8ZYZiuf2N+3ffodya7FYudBw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yr+0RZEzNyM374zu4G56C/tppRxEaVpjnKgX1Ue+FbMYOvUDd31qaVtlkEscKmIlb
	 71hgzf5iCgx6A0p3s8N+gvMKsAydbvByLcCM5ZB1ZYyaHexLEGjStaMw0Cl7XjMa1A
	 V6TxAkAgUgqqmiveOcpvyGiQH5ZNmVPC5MLZE5cWarnggucBwSk+/9BQIDz8AGTEDH
	 4v42Kct3u7dtYNpXCsURrTEtyRsBRcmku+pZLYBHk9H3aY1ELDyJT7zvDZy4nwL/st
	 61Hz6zdnb9CUiW41SytyZePT1g9oI2SL8Fi/r9As8kffgMQ2xBvLtNsWAitYGeOc+r
	 j/OrJvK8iDQUw==
Date: Wed, 17 Apr 2024 14:46:34 -0700
Subject: [PATCH 8/8] xfs_repair: support more than INT_MAX block maps
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171338845900.1856674.8293398127672313074.stgit@frogsfrogsfrogs>
In-Reply-To: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
References: <171338845773.1856674.2763970395218819820.stgit@frogsfrogsfrogs>
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

Now that it's possible to have more than INT_MAX block mappings attached
to a file fork, expand the counters used by this data structure so that
it can support all possible block mappings.

Note that in practice we're still never going to exceed 4 billion
extents because the previous patch switched off the block mappings for
regular files.  This is still twice as much as memory as previous, but
it's not totally unconstrained.  Hopefully few people bloat the xattr
structures that large.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/bmap.c   |   23 ++++++++++++-----------
 repair/bmap.h   |    7 ++++---
 repair/dinode.c |    2 +-
 repair/dir2.c   |    2 +-
 4 files changed, 18 insertions(+), 16 deletions(-)


diff --git a/repair/bmap.c b/repair/bmap.c
index 7e32fff33..2b4f4fe98 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -43,6 +43,7 @@ blkmap_alloc(
 
 	if (nex < 1)
 		nex = 1;
+	nex = min(nex, XFS_MAX_EXTCNT_DATA_FORK_LARGE);
 
 	if (sizeof(long) == 4 && nex > BLKMAP_NEXTS32_MAX) {
 		do_warn(
@@ -122,7 +123,7 @@ blkmap_get(
 	xfs_fileoff_t	o)
 {
 	bmap_ext_t	*ext = blkmap->exts;
-	int		i;
+	xfs_extnum_t	i;
 
 	for (i = 0; i < blkmap->nexts; i++, ext++) {
 		if (o >= ext->startoff && o < ext->startoff + ext->blockcount)
@@ -144,7 +145,7 @@ blkmap_getn(
 {
 	bmap_ext_t	*bmp = NULL;
 	bmap_ext_t	*ext;
-	int		i;
+	xfs_extnum_t	i;
 	int		nex;
 
 	if (nb == 1) {
@@ -240,7 +241,7 @@ xfs_fileoff_t
 blkmap_next_off(
 	blkmap_t	*blkmap,
 	xfs_fileoff_t	o,
-	int		*t)
+	xfs_extnum_t	*t)
 {
 	bmap_ext_t	*ext;
 
@@ -270,7 +271,7 @@ blkmap_grow(
 {
 	pthread_key_t	key = dblkmap_key;
 	blkmap_t	*new_blkmap;
-	int		new_naexts;
+	xfs_extnum_t	new_naexts;
 
 	/* reduce the number of reallocations for large files */
 	if (blkmap->naexts < 1000)
@@ -287,18 +288,18 @@ blkmap_grow(
 
 	if (sizeof(long) == 4 && new_naexts > BLKMAP_NEXTS32_MAX) {
 		do_error(
-	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
+	_("Number of extents requested in blkmap_grow (%llu) overflows 32 bits.\n"
 	  "You need a 64 bit system to repair this filesystem.\n"),
-			new_naexts);
+			(unsigned long long)new_naexts);
 		return NULL;
 	}
 
-	if (new_naexts <= 0) {
+	if (new_naexts > XFS_MAX_EXTCNT_DATA_FORK_LARGE) {
 		do_error(
-	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
-	  "maximum number of supported extents (%ld).\n"),
-			new_naexts,
-			sizeof(long) == 4 ? BLKMAP_NEXTS32_MAX : INT_MAX);
+	_("Number of extents requested in blkmap_grow (%llu) overflowed the\n"
+	  "maximum number of supported extents (%llu).\n"),
+			(unsigned long long)new_naexts,
+			(unsigned long long)XFS_MAX_EXTCNT_DATA_FORK_LARGE);
 		return NULL;
 	}
 
diff --git a/repair/bmap.h b/repair/bmap.h
index df9602b31..7fa671ce8 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -20,8 +20,8 @@ typedef struct bmap_ext {
  * Block map.
  */
 typedef	struct blkmap {
-	int		naexts;
-	int		nexts;
+	xfs_extnum_t	naexts;
+	xfs_extnum_t	nexts;
 	bmap_ext_t	exts[1];
 } blkmap_t;
 
@@ -43,6 +43,7 @@ int		blkmap_getn(blkmap_t *blkmap, xfs_fileoff_t o,
 			    xfs_filblks_t nb, bmap_ext_t **bmpp,
 			    bmap_ext_t *bmpp_single);
 xfs_fileoff_t	blkmap_last_off(blkmap_t *blkmap);
-xfs_fileoff_t	blkmap_next_off(blkmap_t *blkmap, xfs_fileoff_t o, int *t);
+xfs_fileoff_t	blkmap_next_off(blkmap_t *blkmap, xfs_fileoff_t o,
+				xfs_extnum_t *t);
 
 #endif /* _XFS_REPAIR_BMAP_H */
diff --git a/repair/dinode.c b/repair/dinode.c
index 94f5fdcb4..9d2f71055 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1137,7 +1137,7 @@ process_quota_inode(
 	xfs_dqid_t		dqid;
 	xfs_fileoff_t		qbno;
 	int			i;
-	int			t = 0;
+	xfs_extnum_t		t = 0;
 	int			error;
 
 	switch (ino_type) {
diff --git a/repair/dir2.c b/repair/dir2.c
index 022b61b88..e46ae9ae4 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1327,7 +1327,7 @@ process_leaf_node_dir2(
 	int			i;
 	xfs_fileoff_t		ndbno;
 	int			nex;
-	int			t;
+	xfs_extnum_t		t;
 	bmap_ext_t		lbmp;
 	int			dirty = 0;
 

