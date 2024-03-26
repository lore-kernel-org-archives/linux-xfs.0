Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC491292D8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423658; cv=none; b=BUnkgdj91w6UZqCtXuxfTgF96s36YnJB2lfr40jJ4KDglb7RkUD4TSH7bb2INS5d4IkEx6uYWtZCT2ZhebcGnccVI9m3WtUETbcoSrafqorz8Dd7LkPY95dn5SYtOICDlZe1/EEv3M1nLECmOOT2bc8btFi8unCOG/NoPqxyPWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423658; c=relaxed/simple;
	bh=ai+wdEXqiZZie6iNmDmNAn8/TnFgifQjqxdXn8/AAt0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQcGAlZ2e1PLXIeBqWx8KINBNzZmcN2HtAG90to7Wqh3CIRHuWt/dpFyLufyLkz26Zp+FUCp18SPNKH2my/Hkviy5tikM5i7K/1L5k5G85M4/ERVgmbRY4lsNZIFVy25FXHu1iK1ualjP3/try2h2i3bvPag58njqFHWv/K8Rms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TU+SqGrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TU+SqGrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F0CC433F1;
	Tue, 26 Mar 2024 03:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423658;
	bh=ai+wdEXqiZZie6iNmDmNAn8/TnFgifQjqxdXn8/AAt0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TU+SqGrGptP5kWWzvAT1sSEFJEf3HL7Ie3ZCFHHpmMybW10oF8R/wieavpbthxwpo
	 iUVxkGnPGAJZTaII349pSNcp9iP4S9bPMOTw4Tzxw4+PmWc9osHuIuYB+X0xnevRNp
	 Q1sLzJ2nR2te4vdZynRopiM0EEko+AtEFR3qPZKaHpNe2tt2Y7Bedelm35bT4Kn4kd
	 RJMtCE9SttXgQ6FQCWLhZpleMgIns9ypL5E2pQMEeiTdcDkUsFMzO12HmOrvFEPvnz
	 uDKD/9t9Fiei3DFhvVgD7AVWqDZDYEpODdk4O4DcyWrEpCBOlkOhBOpTrcI9qxkVC4
	 VNafDvjg17fYw==
Date: Mon, 25 Mar 2024 20:27:37 -0700
Subject: [PATCH 8/8] xfs_repair: support more than INT_MAX block maps
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130470.2214793.4372715230712256609.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
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
index 7e32fff33594..2b4f4fe9803c 100644
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
index df9602b31e48..7fa671ce8b37 100644
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
index 94f5fdcb4a37..9d2f71055ebd 100644
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
index 022b61b885f6..e46ae9ae46f7 100644
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
 

