Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB77C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NXvEidGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A07DC433C8;
	Sun, 31 Dec 2023 22:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060623;
	bh=D+Fr3kB7TuoDj7TgBD1cgMe+GuJj3YpkynEB62RS5GY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NXvEidGhDPk3Y3K2kVBpExa4IOycovBJlHlMuVCUKliviwgcHtDXHRdvV7D3TmhG+
	 QBNwxZvII0SL/UqGNJ2tCNupg4d6qC8e8EYGe5KEXDX8kXhBJYcwtDHPCPFOXbA8yA
	 Sc9YhW+HLNKR4GpC5VYxH6Cck5JIrhzvuujDtaoTdOQnpL17jMVKC2VsQqPpn/nT3b
	 5YuK1OJHULsYRh3nhM2BuO579KrWMLk1vsRWopUvSwDcLwsRDF3MrGwrWJ6ZUlVwXb
	 uCSlplHogkJyflvOg5xNyTf2H3n2UcUb3Y7qmQ28lV+oIynrqPAZ3myNy4v29Nfsdc
	 MXbRNs4iSsMOw==
Date: Sun, 31 Dec 2023 14:10:22 -0800
Subject: [PATCH 8/8] xfs_repair: support more than INT_MAX block maps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404991244.1793698.1211159366032444089.stgit@frogsfrogsfrogs>
In-Reply-To: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
References: <170404991133.1793698.11944872908755383201.stgit@frogsfrogsfrogs>
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
---
 repair/bmap.c   |   26 ++++++++++++++------------
 repair/bmap.h   |    9 ++++-----
 repair/dinode.c |    2 +-
 repair/dir2.c   |    2 +-
 4 files changed, 20 insertions(+), 19 deletions(-)


diff --git a/repair/bmap.c b/repair/bmap.c
index cd1a8b07b30..9ae28686107 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -34,8 +34,9 @@ blkmap_alloc(
 
 	if (nex < 1)
 		nex = 1;
+	nex = min(nex, XFS_MAX_EXTCNT_DATA_FORK_LARGE);
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
+#ifdef BLKMAP_NEXTS_MAX
 	if (nex > BLKMAP_NEXTS_MAX) {
 		do_warn(
 	_("Number of extents requested in blkmap_alloc (%llu) overflows 32 bits.\n"
@@ -115,7 +116,7 @@ blkmap_get(
 	xfs_fileoff_t	o)
 {
 	bmap_ext_t	*ext = blkmap->exts;
-	int		i;
+	xfs_extnum_t	i;
 
 	for (i = 0; i < blkmap->nexts; i++, ext++) {
 		if (o >= ext->startoff && o < ext->startoff + ext->blockcount)
@@ -137,7 +138,7 @@ blkmap_getn(
 {
 	bmap_ext_t	*bmp = NULL;
 	bmap_ext_t	*ext;
-	int		i;
+	xfs_extnum_t	i;
 	int		nex;
 
 	if (nb == 1) {
@@ -233,7 +234,7 @@ xfs_fileoff_t
 blkmap_next_off(
 	blkmap_t	*blkmap,
 	xfs_fileoff_t	o,
-	int		*t)
+	xfs_extnum_t	*t)
 {
 	bmap_ext_t	*ext;
 
@@ -263,7 +264,7 @@ blkmap_grow(
 {
 	pthread_key_t	key = dblkmap_key;
 	blkmap_t	*new_blkmap;
-	int		new_naexts;
+	xfs_extnum_t	new_naexts;
 
 	/* reduce the number of reallocations for large files */
 	if (blkmap->naexts < 1000)
@@ -278,20 +279,21 @@ blkmap_grow(
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
+#ifdef BLKMAP_NEXTS_MAX
 	if (new_naexts > BLKMAP_NEXTS_MAX) {
 		do_error(
-	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
+	_("Number of extents requested in blkmap_grow (%llu) overflows 32 bits.\n"
 	  "You need a 64 bit system to repair this filesystem.\n"),
-			new_naexts);
+			(unsigned long long)new_naexts);
 		return NULL;
 	}
 #endif
-	if (new_naexts <= 0) {
+	if (new_naexts > XFS_MAX_EXTCNT_DATA_FORK_LARGE) {
 		do_error(
-	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
-	  "maximum number of supported extents (%d).\n"),
-			new_naexts, BLKMAP_NEXTS_MAX);
+	_("Number of extents requested in blkmap_grow (%llu) overflowed the\n"
+	  "maximum number of supported extents (%llu).\n"),
+			(unsigned long long)new_naexts,
+			(unsigned long long)XFS_MAX_EXTCNT_DATA_FORK_LARGE);
 		return NULL;
 	}
 
diff --git a/repair/bmap.h b/repair/bmap.h
index 4b588df8c86..3d6be94441c 100644
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
 
@@ -37,8 +37,6 @@ typedef	struct blkmap {
  */
 #if BITS_PER_LONG == 32
 #define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
-#else
-#define BLKMAP_NEXTS_MAX	INT_MAX
 #endif
 
 extern pthread_key_t dblkmap_key;
@@ -56,6 +54,7 @@ int		blkmap_getn(blkmap_t *blkmap, xfs_fileoff_t o,
 			    xfs_filblks_t nb, bmap_ext_t **bmpp,
 			    bmap_ext_t *bmpp_single);
 xfs_fileoff_t	blkmap_last_off(blkmap_t *blkmap);
-xfs_fileoff_t	blkmap_next_off(blkmap_t *blkmap, xfs_fileoff_t o, int *t);
+xfs_fileoff_t	blkmap_next_off(blkmap_t *blkmap, xfs_fileoff_t o,
+				xfs_extnum_t *t);
 
 #endif /* _XFS_REPAIR_BMAP_H */
diff --git a/repair/dinode.c b/repair/dinode.c
index f2961275cd1..629440fe6de 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1136,7 +1136,7 @@ process_quota_inode(
 	xfs_dqid_t		dqid;
 	xfs_fileoff_t		qbno;
 	int			i;
-	int			t = 0;
+	xfs_extnum_t		t = 0;
 	int			error;
 
 	switch (ino_type) {
diff --git a/repair/dir2.c b/repair/dir2.c
index 022b61b885f..e46ae9ae46f 100644
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
 

