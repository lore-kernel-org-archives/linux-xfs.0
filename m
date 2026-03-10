Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE23B2EB5CD;
	Tue, 10 Mar 2026 21:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773179271; cv=none; b=r9zmvGgiAjPZQVPgpFhhnG3JlkRYNgh8ozADsPmgZMw/qvBjja5DeNjO5fE+5csxvRziJ3WTzN4jbS6b8i0TKIpnFCH2bPtszauwnufceBLe2pX9SVopmW7tzlzBZGYgaJHzLroEFxSt1ibQT4hhDQoZQPK8Fchjeghz3EkoGuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773179271; c=relaxed/simple;
	bh=2bqUi3Hz95zEkGp+c4piES3o/ZD2WdH0G03RW5QK1B8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VYVtPpelmtNQs2Ep5xfuLzTS60t5o6esiYarU3vLRjmQkgOTDIujwA1znsD2Yh7g/W12b3tmeGZrt7xHkv6Z+rbwN7jPJwdao2wH8LJhrGXIkIR39rpl7i2qZkJXAN8QHwWEVgQdfoy0jKDCg0bwRit4rIYaUaHYwvKkX18ZQ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnIaRejd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnIaRejd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48775C19423;
	Tue, 10 Mar 2026 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773179271;
	bh=2bqUi3Hz95zEkGp+c4piES3o/ZD2WdH0G03RW5QK1B8=;
	h=Date:From:To:Cc:Subject:From;
	b=qnIaRejdihYMZ5ZsGs0IFEcsFqzxQ14WYDOj/cyCIpDR5N+0v3aGZw1h+LOscgY4c
	 c6TpgavdBLXlxDH/qi20OSKElCfV0PZy4LKzHdm4qH03luVwH2/DC4hlANvzBqMWkv
	 i0mWe5I8aC/RlQEUlJ23jr0m5rU11H+UDB6KMVM2xOzHi/mdTxBbbmVErVq16phha4
	 z5NGpffax8obbyhboV8r7NxuOteFTWhepx8JN0XCJByGme9/zYzArVRdevhsNSSf5Q
	 mZGtySPyamg3OVWlLZB0XGu8+g3P0aRiDBOQSjF+A3QafdIk9deZtGO+G6+pVa9yCk
	 bJhqSCGJnMfeQ==
Date: Tue, 10 Mar 2026 14:47:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, r772577952@gmail.com,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: [PATCH 6.12] xfs: get rid of the xchk_xfile_*_descr calls
Message-ID: <20260310214750.GB6023@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 60382993a2e18041f88c7969f567f168cd3b4de3 ]

The xchk_xfile_*_descr macros call kasprintf, which can fail to allocate
memory if the formatted string is larger than 16 bytes (or whatever the
nofail guarantees are nowadays).  Some of them could easily exceed that,
and Jiaming Zhang found a few places where that can happen with syzbot.

The descriptions are debugging aids and aren't required to be unique, so
let's just pass in static strings and eliminate this path to failure.
Note this patch touches a number of commits, most of which were merged
between 6.6 and 6.14.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
---
 fs/xfs/scrub/common.h          |   18 ------------------
 fs/xfs/scrub/agheader_repair.c |   13 ++++---------
 fs/xfs/scrub/alloc_repair.c    |    5 +----
 fs/xfs/scrub/attr_repair.c     |   20 +++++---------------
 fs/xfs/scrub/bmap_repair.c     |    6 +-----
 fs/xfs/scrub/dir.c             |   13 ++++---------
 fs/xfs/scrub/dir_repair.c      |   11 +++--------
 fs/xfs/scrub/dirtree.c         |   11 +++--------
 fs/xfs/scrub/ialloc_repair.c   |    5 +----
 fs/xfs/scrub/nlinks.c          |    6 ++----
 fs/xfs/scrub/parent.c          |   11 +++--------
 fs/xfs/scrub/parent_repair.c   |   23 ++++++-----------------
 fs/xfs/scrub/quotacheck.c      |   13 +++----------
 fs/xfs/scrub/refcount_repair.c |   13 ++-----------
 fs/xfs/scrub/rmap_repair.c     |    5 +----
 fs/xfs/scrub/rtsummary.c       |    7 ++-----
 16 files changed, 41 insertions(+), 139 deletions(-)

diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index eb00d48590f200..bd74ac23b72eda 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -201,24 +201,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
-/*
- * Helper macros to allocate and format xfile description strings.
- * Callers must kfree the pointer returned.
- */
-#define xchk_xfile_descr(sc, fmt, ...) \
-	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): " fmt, \
-			(sc)->mp->m_super->s_id, ##__VA_ARGS__)
-#define xchk_xfile_ag_descr(sc, fmt, ...) \
-	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): AG 0x%x " fmt, \
-			(sc)->mp->m_super->s_id, \
-			(sc)->sa.pag ? (sc)->sa.pag->pag_agno : (sc)->sm->sm_agno, \
-			##__VA_ARGS__)
-#define xchk_xfile_ino_descr(sc, fmt, ...) \
-	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): inode 0x%llx " fmt, \
-			(sc)->mp->m_super->s_id, \
-			(sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
-			##__VA_ARGS__)
-
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
  * the CPU hotplug lock and force an i-cache flush on all CPUs once to set it
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index a93686df6f67bb..321009741e584d 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1720,7 +1720,6 @@ xrep_agi(
 {
 	struct xrep_agi		*ragi;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	unsigned int		i;
 	int			error;
 
@@ -1754,17 +1753,13 @@ xrep_agi(
 	xagino_bitmap_init(&ragi->iunlink_bmp);
 	sc->buf_cleanup = xrep_agi_buf_cleanup;
 
-	descr = xchk_xfile_ag_descr(sc, "iunlinked next pointers");
-	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
-			&ragi->iunlink_next);
-	kfree(descr);
+	error = xfarray_create("iunlinked next pointers", 0,
+			sizeof(xfs_agino_t), &ragi->iunlink_next);
 	if (error)
 		return error;
 
-	descr = xchk_xfile_ag_descr(sc, "iunlinked prev pointers");
-	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
-			&ragi->iunlink_prev);
-	kfree(descr);
+	error = xfarray_create("iunlinked prev pointers", 0,
+			sizeof(xfs_agino_t), &ragi->iunlink_prev);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index b43b45fec4f591..1fbe9c8740fa68 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -849,7 +849,6 @@ xrep_allocbt(
 {
 	struct xrep_abt		*ra;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -875,11 +874,9 @@ xrep_allocbt(
 	}
 
 	/* Set up enough storage to handle maximally fragmented free space. */
-	descr = xchk_xfile_ag_descr(sc, "free space records");
-	error = xfarray_create(descr, mp->m_sb.sb_agblocks / 2,
+	error = xfarray_create("free space records", mp->m_sb.sb_agblocks / 2,
 			sizeof(struct xfs_alloc_rec_incore),
 			&ra->free_records);
-	kfree(descr);
 	if (error)
 		goto out_ra;
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 50ab476dddb98a..dd24044c44efd3 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1531,7 +1531,6 @@ xrep_xattr_setup_scan(
 	struct xrep_xattr	**rxp)
 {
 	struct xrep_xattr	*rx;
-	char			*descr;
 	int			max_len;
 	int			error;
 
@@ -1557,35 +1556,26 @@ xrep_xattr_setup_scan(
 		goto out_rx;
 
 	/* Set up some staging for salvaged attribute keys and values */
-	descr = xchk_xfile_ino_descr(sc, "xattr keys");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_xattr_key),
+	error = xfarray_create("xattr keys", 0, sizeof(struct xrep_xattr_key),
 			&rx->xattr_records);
-	kfree(descr);
 	if (error)
 		goto out_rx;
 
-	descr = xchk_xfile_ino_descr(sc, "xattr names");
-	error = xfblob_create(descr, &rx->xattr_blobs);
-	kfree(descr);
+	error = xfblob_create("xattr names", &rx->xattr_blobs);
 	if (error)
 		goto out_keys;
 
 	if (xfs_has_parent(sc->mp)) {
 		ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
 
-		descr = xchk_xfile_ino_descr(sc,
-				"xattr retained parent pointer entries");
-		error = xfarray_create(descr, 0,
+		error = xfarray_create("xattr parent pointer entries", 0,
 				sizeof(struct xrep_xattr_pptr),
 				&rx->pptr_recs);
-		kfree(descr);
 		if (error)
 			goto out_values;
 
-		descr = xchk_xfile_ino_descr(sc,
-				"xattr retained parent pointer names");
-		error = xfblob_create(descr, &rx->pptr_names);
-		kfree(descr);
+		error = xfblob_create("xattr parent pointer names",
+				&rx->pptr_names);
 		if (error)
 			goto out_pprecs;
 
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 4505f4829d53f1..9688b0aa1b8fe4 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -800,7 +800,6 @@ xrep_bmap(
 	bool			allow_unwritten)
 {
 	struct xrep_bmap	*rb;
-	char			*descr;
 	xfs_extnum_t		max_bmbt_recs;
 	bool			large_extcount;
 	int			error = 0;
@@ -822,11 +821,8 @@ xrep_bmap(
 	/* Set up enough storage to handle the max records for this fork. */
 	large_extcount = xfs_has_large_extent_counts(sc->mp);
 	max_bmbt_recs = xfs_iext_max_nextents(large_extcount, whichfork);
-	descr = xchk_xfile_ino_descr(sc, "%s fork mapping records",
-			whichfork == XFS_DATA_FORK ? "data" : "attr");
-	error = xfarray_create(descr, max_bmbt_recs,
+	error = xfarray_create("fork mapping records", max_bmbt_recs,
 			sizeof(struct xfs_bmbt_rec), &rb->bmap_records);
-	kfree(descr);
 	if (error)
 		goto out_rb;
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index bf9199e8df633f..eba6799dd18334 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -1094,22 +1094,17 @@ xchk_directory(
 	sd->xname.name = sd->namebuf;
 
 	if (xfs_has_parent(sc->mp)) {
-		char		*descr;
-
 		/*
 		 * Set up some staging memory for dirents that we can't check
 		 * due to locking contention.
 		 */
-		descr = xchk_xfile_ino_descr(sc, "slow directory entries");
-		error = xfarray_create(descr, 0, sizeof(struct xchk_dirent),
-				&sd->dir_entries);
-		kfree(descr);
+		error = xfarray_create("slow directory entries", 0,
+				sizeof(struct xchk_dirent), &sd->dir_entries);
 		if (error)
 			goto out_sd;
 
-		descr = xchk_xfile_ino_descr(sc, "slow directory entry names");
-		error = xfblob_create(descr, &sd->dir_names);
-		kfree(descr);
+		error = xfblob_create("slow directory entry names",
+				&sd->dir_names);
 		if (error)
 			goto out_entries;
 	}
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index a9e2aa5c3968d6..29c48c4db53b24 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1782,20 +1782,15 @@ xrep_dir_setup_scan(
 	struct xrep_dir		*rd)
 {
 	struct xfs_scrub	*sc = rd->sc;
-	char			*descr;
 	int			error;
 
 	/* Set up some staging memory for salvaging dirents. */
-	descr = xchk_xfile_ino_descr(sc, "directory entries");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_dirent),
-			&rd->dir_entries);
-	kfree(descr);
+	error = xfarray_create("directory entries", 0,
+			sizeof(struct xrep_dirent), &rd->dir_entries);
 	if (error)
 		return error;
 
-	descr = xchk_xfile_ino_descr(sc, "directory entry names");
-	error = xfblob_create(descr, &rd->dir_names);
-	kfree(descr);
+	error = xfblob_create("directory entry names", &rd->dir_names);
 	if (error)
 		goto out_xfarray;
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 73d40a2600a2a6..709b91d023b722 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -96,7 +96,6 @@ xchk_setup_dirtree(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_dirtree	*dl;
-	char			*descr;
 	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
@@ -120,16 +119,12 @@ xchk_setup_dirtree(
 
 	mutex_init(&dl->lock);
 
-	descr = xchk_xfile_ino_descr(sc, "dirtree path steps");
-	error = xfarray_create(descr, 0, sizeof(struct xchk_dirpath_step),
-			&dl->path_steps);
-	kfree(descr);
+	error = xfarray_create("dirtree path steps", 0,
+			sizeof(struct xchk_dirpath_step), &dl->path_steps);
 	if (error)
 		goto out_dl;
 
-	descr = xchk_xfile_ino_descr(sc, "dirtree path names");
-	error = xfblob_create(descr, &dl->path_names);
-	kfree(descr);
+	error = xfblob_create("dirtree path names", &dl->path_names);
 	if (error)
 		goto out_steps;
 
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 6cb2c9d115092e..6a2b248f55367b 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -804,7 +804,6 @@ xrep_iallocbt(
 {
 	struct xrep_ibt		*ri;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	xfs_agino_t		first_agino, last_agino;
 	int			error = 0;
 
@@ -823,11 +822,9 @@ xrep_iallocbt(
 	/* Set up enough storage to handle an AG with nothing but inodes. */
 	xfs_agino_range(mp, sc->sa.pag->pag_agno, &first_agino, &last_agino);
 	last_agino /= XFS_INODES_PER_CHUNK;
-	descr = xchk_xfile_ag_descr(sc, "inode index records");
-	error = xfarray_create(descr, last_agino,
+	error = xfarray_create("inode index records", last_agino,
 			sizeof(struct xfs_inobt_rec_incore),
 			&ri->inode_records);
-	kfree(descr);
 	if (error)
 		goto out_ri;
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 7e917a5e9ca29f..d386ee9e1364f7 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -995,7 +995,6 @@ xchk_nlinks_setup_scan(
 	struct xchk_nlink_ctrs	*xnc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	unsigned long long	max_inos;
 	xfs_agnumber_t		last_agno = mp->m_sb.sb_agcount - 1;
 	xfs_agino_t		first_agino, last_agino;
@@ -1012,10 +1011,9 @@ xchk_nlinks_setup_scan(
 	 */
 	xfs_agino_range(mp, last_agno, &first_agino, &last_agino);
 	max_inos = XFS_AGINO_TO_INO(mp, last_agno, last_agino) + 1;
-	descr = xchk_xfile_descr(sc, "file link counts");
-	error = xfarray_create(descr, min(XFS_MAXINUMBER + 1, max_inos),
+	error = xfarray_create("file link counts",
+			min(XFS_MAXINUMBER + 1, max_inos),
 			sizeof(struct xchk_nlink), &xnc->nlinks);
-	kfree(descr);
 	if (error)
 		goto out_teardown;
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 91e7b51ce0680b..a82d1fb6771678 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -733,7 +733,6 @@ xchk_parent_pptr(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_pptrs	*pp;
-	char			*descr;
 	int			error;
 
 	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
@@ -746,16 +745,12 @@ xchk_parent_pptr(
 	 * Set up some staging memory for parent pointers that we can't check
 	 * due to locking contention.
 	 */
-	descr = xchk_xfile_ino_descr(sc, "slow parent pointer entries");
-	error = xfarray_create(descr, 0, sizeof(struct xchk_pptr),
-			&pp->pptr_entries);
-	kfree(descr);
+	error = xfarray_create("slow parent pointer entries", 0,
+			sizeof(struct xchk_pptr), &pp->pptr_entries);
 	if (error)
 		goto out_pp;
 
-	descr = xchk_xfile_ino_descr(sc, "slow parent pointer names");
-	error = xfblob_create(descr, &pp->pptr_names);
-	kfree(descr);
+	error = xfblob_create("slow parent pointer names", &pp->pptr_names);
 	if (error)
 		goto out_entries;
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 7b42b7f65a0bd3..66ce96319201dd 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1476,7 +1476,6 @@ xrep_parent_setup_scan(
 	struct xrep_parent	*rp)
 {
 	struct xfs_scrub	*sc = rp->sc;
-	char			*descr;
 	struct xfs_da_geometry	*geo = sc->mp->m_attr_geo;
 	int			max_len;
 	int			error;
@@ -1504,32 +1503,22 @@ xrep_parent_setup_scan(
 		goto out_xattr_name;
 
 	/* Set up some staging memory for logging parent pointer updates. */
-	descr = xchk_xfile_ino_descr(sc, "parent pointer entries");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_pptr),
-			&rp->pptr_recs);
-	kfree(descr);
+	error = xfarray_create("parent pointer entries", 0,
+			sizeof(struct xrep_pptr), &rp->pptr_recs);
 	if (error)
 		goto out_xattr_value;
 
-	descr = xchk_xfile_ino_descr(sc, "parent pointer names");
-	error = xfblob_create(descr, &rp->pptr_names);
-	kfree(descr);
+	error = xfblob_create("parent pointer names", &rp->pptr_names);
 	if (error)
 		goto out_recs;
 
 	/* Set up some storage for copying attrs before the mapping exchange */
-	descr = xchk_xfile_ino_descr(sc,
-				"parent pointer retained xattr entries");
-	error = xfarray_create(descr, 0, sizeof(struct xrep_parent_xattr),
-			&rp->xattr_records);
-	kfree(descr);
+	error = xfarray_create("parent pointer xattr entries", 0,
+			sizeof(struct xrep_parent_xattr), &rp->xattr_records);
 	if (error)
 		goto out_names;
 
-	descr = xchk_xfile_ino_descr(sc,
-				"parent pointer retained xattr values");
-	error = xfblob_create(descr, &rp->xattr_blobs);
-	kfree(descr);
+	error = xfblob_create("parent pointer xattr values", &rp->xattr_blobs);
 	if (error)
 		goto out_attr_keys;
 
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index c77eb2de8df71f..28309f9f25e48e 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -741,7 +741,6 @@ xqcheck_setup_scan(
 	struct xfs_scrub	*sc,
 	struct xqcheck		*xqc)
 {
-	char			*descr;
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	unsigned long long	max_dquots = XFS_DQ_ID_MAX + 1ULL;
 	int			error;
@@ -756,28 +755,22 @@ xqcheck_setup_scan(
 
 	error = -ENOMEM;
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_USER)) {
-		descr = xchk_xfile_descr(sc, "user dquot records");
-		error = xfarray_create(descr, max_dquots,
+		error = xfarray_create("user dquot records", max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->ucounts);
-		kfree(descr);
 		if (error)
 			goto out_teardown;
 	}
 
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_GROUP)) {
-		descr = xchk_xfile_descr(sc, "group dquot records");
-		error = xfarray_create(descr, max_dquots,
+		error = xfarray_create("group dquot records", max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->gcounts);
-		kfree(descr);
 		if (error)
 			goto out_teardown;
 	}
 
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_PROJ)) {
-		descr = xchk_xfile_descr(sc, "project dquot records");
-		error = xfarray_create(descr, max_dquots,
+		error = xfarray_create("project dquot records", max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->pcounts);
-		kfree(descr);
 		if (error)
 			goto out_teardown;
 	}
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index a00d7ce7ae5b87..1512e7363de124 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -123,13 +123,7 @@ int
 xrep_setup_ag_refcountbt(
 	struct xfs_scrub	*sc)
 {
-	char			*descr;
-	int			error;
-
-	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
-	error = xrep_setup_xfbtree(sc, descr);
-	kfree(descr);
-	return error;
+	return xrep_setup_xfbtree(sc, "rmap record bag");
 }
 
 /* Check for any obvious conflicts with this shared/CoW staging extent. */
@@ -705,7 +699,6 @@ xrep_refcountbt(
 {
 	struct xrep_refc	*rr;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -718,11 +711,9 @@ xrep_refcountbt(
 	rr->sc = sc;
 
 	/* Set up enough storage to handle one refcount record per block. */
-	descr = xchk_xfile_ag_descr(sc, "reference count records");
-	error = xfarray_create(descr, mp->m_sb.sb_agblocks,
+	error = xfarray_create("reference count records", mp->m_sb.sb_agblocks,
 			sizeof(struct xfs_refcount_irec),
 			&rr->refcount_records);
-	kfree(descr);
 	if (error)
 		goto out_rr;
 
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index e8080eba37d29b..436dcc3fe8545d 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -161,14 +161,11 @@ xrep_setup_ag_rmapbt(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_rmap	*rr;
-	char			*descr;
 	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
 
-	descr = xchk_xfile_ag_descr(sc, "reverse mapping records");
-	error = xrep_setup_xfbtree(sc, descr);
-	kfree(descr);
+	error = xrep_setup_xfbtree(sc, "reverse mapping records");
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 7c7366c98338b0..746990ae0ec1ef 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -42,7 +42,6 @@ xchk_setup_rtsummary(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	struct xchk_rtsummary	*rts;
 	int			error;
 
@@ -62,10 +61,8 @@ xchk_setup_rtsummary(
 	 * Create an xfile to construct a new rtsummary file.  The xfile allows
 	 * us to avoid pinning kernel memory for this purpose.
 	 */
-	descr = xchk_xfile_descr(sc, "realtime summary file");
-	error = xfile_create(descr, XFS_FSB_TO_B(mp, mp->m_rsumblocks),
-			&sc->xfile);
-	kfree(descr);
+	error = xfile_create("realtime summary file",
+			XFS_FSB_TO_B(mp, mp->m_rsumblocks), &sc->xfile);
 	if (error)
 		return error;
 
