Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45B727C84E;
	Sun,  1 Mar 2026 01:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328199; cv=none; b=SQbHc02NLrzUgDwcq+jWjrRg3CbWY2agcle/uAlZ523bcGbUot0NOIHPGjq+NgeY2U80T9mtQKeviFRmSH4gPmWpr5q8AKetFqnIl2OiUDuUW2l99T0+BGYbFmhX4Jph/w4ThWdmzTsjOlU4hU6eCRYQpOvJOg/+IyqZLJyn+SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328199; c=relaxed/simple;
	bh=Q1+q5JxiC+uVABDopD5CtnLIE9bavt8zSaeCwTYnC8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GXIo752SF2XPVCilf8mvuuh74xsP1YwB+KCCPDRnNpD0v9qfWLSTbbECadYa/GSUsz3pTiUoIyUC5DAuIyhJEN06BH2XAlsQgjVo0psdgch2Hdb1vhKwokYpjeeotjMZyWUn9Z8uEv0MaorJa9Xqxq0kWA6MpqzsTp//tYzANds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dn98Wy/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dn98Wy/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329D7C19424;
	Sun,  1 Mar 2026 01:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328198;
	bh=Q1+q5JxiC+uVABDopD5CtnLIE9bavt8zSaeCwTYnC8U=;
	h=From:To:Cc:Subject:Date:From;
	b=Dn98Wy/v8MpMVsqLJsIxsKRUElbsJroBhY9faxPIVODdmouvxrp4/r3To0I/+rGkt
	 hwNZ/oUO4jUGumBePv5KSnC2Ug0vCum1F6QB5pis9jLOa5N6rntI0hpzrYQyl7ZCLx
	 FMY6UPC/FhFEXzR32J/DSHLlniH8CsMyu6TEdE3O6tPOspTAG/4/OtmQnPZ7Pgjcwc
	 pHws1rfrJwMRFccpbd9gdivL4uxFRRHMjlJHdsnNluYIluD70100grXlqGZ0UzcuS2
	 mBB7zcI7lvFhqZ+8w7v9teJptEckPzdXo1rMqQFwnbxGTohNxOhB/EpSlIJOXbx4O+
	 eC0lLj6UPJPow==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: r772577952@gmail.com,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: get rid of the xchk_xfile_*_descr calls" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:23:15 -0500
Message-ID: <20260301012317.1679941-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 60382993a2e18041f88c7969f567f168cd3b4de3 Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:37 -0800
Subject: [PATCH] xfs: get rid of the xchk_xfile_*_descr calls

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
 fs/xfs/scrub/agheader_repair.c   | 13 ++++---------
 fs/xfs/scrub/alloc_repair.c      |  5 +----
 fs/xfs/scrub/attr_repair.c       | 20 +++++---------------
 fs/xfs/scrub/bmap_repair.c       |  6 +-----
 fs/xfs/scrub/common.h            | 25 -------------------------
 fs/xfs/scrub/dir.c               | 13 ++++---------
 fs/xfs/scrub/dir_repair.c        | 11 +++--------
 fs/xfs/scrub/dirtree.c           | 11 +++--------
 fs/xfs/scrub/ialloc_repair.c     |  5 +----
 fs/xfs/scrub/nlinks.c            |  6 ++----
 fs/xfs/scrub/parent.c            | 11 +++--------
 fs/xfs/scrub/parent_repair.c     | 23 ++++++-----------------
 fs/xfs/scrub/quotacheck.c        | 13 +++----------
 fs/xfs/scrub/refcount_repair.c   | 13 ++-----------
 fs/xfs/scrub/rmap_repair.c       |  5 +----
 fs/xfs/scrub/rtbitmap_repair.c   |  6 ++----
 fs/xfs/scrub/rtrefcount_repair.c | 15 +++------------
 fs/xfs/scrub/rtrmap_repair.c     |  5 +----
 fs/xfs/scrub/rtsummary.c         |  7 ++-----
 19 files changed, 47 insertions(+), 166 deletions(-)

diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 1c09948d841e1..d8e3c51a41b1a 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1708,7 +1708,6 @@ xrep_agi(
 {
 	struct xrep_agi		*ragi;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	unsigned int		i;
 	int			error;
 
@@ -1742,17 +1741,13 @@ xrep_agi(
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
index d84777e233212..f9a9b43271897 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -850,7 +850,6 @@ xrep_allocbt(
 	struct xrep_abt		*ra;
 	struct xfs_mount	*mp = sc->mp;
 	unsigned int		busy_gen;
-	char			*descr;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -876,11 +875,9 @@ xrep_allocbt(
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
index 1da1354f5e064..f9191eae13eea 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1529,7 +1529,6 @@ xrep_xattr_setup_scan(
 	struct xrep_xattr	**rxp)
 {
 	struct xrep_xattr	*rx;
-	char			*descr;
 	int			max_len;
 	int			error;
 
@@ -1555,35 +1554,26 @@ xrep_xattr_setup_scan(
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
index 1d1056d447e05..0a83d58453796 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -923,7 +923,6 @@ xrep_bmap(
 	bool			allow_unwritten)
 {
 	struct xrep_bmap	*rb;
-	char			*descr;
 	xfs_extnum_t		max_bmbt_recs;
 	bool			large_extcount;
 	int			error = 0;
@@ -945,11 +944,8 @@ xrep_bmap(
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
 
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ddbc065c798cd..f2ecc68538f0c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -246,31 +246,6 @@ static inline bool xchk_could_repair(const struct xfs_scrub *sc)
 
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
-			(sc)->sa.pag ? \
-				pag_agno((sc)->sa.pag) : (sc)->sm->sm_agno, \
-			##__VA_ARGS__)
-#define xchk_xfile_ino_descr(sc, fmt, ...) \
-	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): inode 0x%llx " fmt, \
-			(sc)->mp->m_super->s_id, \
-			(sc)->ip ? (sc)->ip->i_ino : (sc)->sm->sm_ino, \
-			##__VA_ARGS__)
-#define xchk_xfile_rtgroup_descr(sc, fmt, ...) \
-	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): rtgroup 0x%x " fmt, \
-			(sc)->mp->m_super->s_id, \
-			(sc)->sa.pag ? \
-				rtg_rgno((sc)->sr.rtg) : (sc)->sm->sm_agno, \
-			##__VA_ARGS__)
-
 /*
  * Setting up a hook to wait for intents to drain is costly -- we have to take
  * the CPU hotplug lock and force an i-cache flush on all CPUs once to set it
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1d98775b4b17f..91228623d016e 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -1102,22 +1102,17 @@ xchk_directory(
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
index d54206f674e2d..dbfcef6fb7da6 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1784,20 +1784,15 @@ xrep_dir_setup_scan(
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
index 529dae105e579..e484f8a0886cd 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -92,7 +92,6 @@ xchk_setup_dirtree(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_dirtree	*dl;
-	char			*descr;
 	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
@@ -116,16 +115,12 @@ xchk_setup_dirtree(
 
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
index bccf2e18d43e1..d206054c1ae3b 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -797,7 +797,6 @@ xrep_iallocbt(
 {
 	struct xrep_ibt		*ri;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	xfs_agino_t		first_agino, last_agino;
 	int			error = 0;
 
@@ -816,11 +815,9 @@ xrep_iallocbt(
 	/* Set up enough storage to handle an AG with nothing but inodes. */
 	xfs_agino_range(mp, pag_agno(sc->sa.pag), &first_agino, &last_agino);
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
index 8bf0bff64b41f..46488aff908cc 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -990,7 +990,6 @@ xchk_nlinks_setup_scan(
 	struct xchk_nlink_ctrs	*xnc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	unsigned long long	max_inos;
 	xfs_agnumber_t		last_agno = mp->m_sb.sb_agcount - 1;
 	xfs_agino_t		first_agino, last_agino;
@@ -1007,10 +1006,9 @@ xchk_nlinks_setup_scan(
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
index 36d505f3e40bd..5a259570b1541 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -755,7 +755,6 @@ xchk_parent_pptr(
 	struct xfs_scrub	*sc)
 {
 	struct xchk_pptrs	*pp;
-	char			*descr;
 	int			error;
 
 	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
@@ -768,16 +767,12 @@ xchk_parent_pptr(
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
index 512a546f8ce11..83a8205ae2f1b 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1497,7 +1497,6 @@ xrep_parent_setup_scan(
 	struct xrep_parent	*rp)
 {
 	struct xfs_scrub	*sc = rp->sc;
-	char			*descr;
 	struct xfs_da_geometry	*geo = sc->mp->m_attr_geo;
 	int			max_len;
 	int			error;
@@ -1525,32 +1524,22 @@ xrep_parent_setup_scan(
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
index 00e0c0e56d824..e8cba19334a02 100644
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
index 46546bf6eb13b..507993e0fb0f3 100644
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
@@ -704,7 +698,6 @@ xrep_refcountbt(
 {
 	struct xrep_refc	*rr;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -717,11 +710,9 @@ xrep_refcountbt(
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
index f27e3c8aa6d5c..ab7053e25e1c7 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -164,14 +164,11 @@ xrep_setup_ag_rmapbt(
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
 
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index fd0d12db55f9c..f4ca86a2ea1bf 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -43,7 +43,6 @@ xrep_setup_rtbitmap(
 	struct xchk_rtbitmap	*rtb)
 {
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	unsigned long long	blocks = mp->m_sb.sb_rbmblocks;
 	int			error;
 
@@ -52,9 +51,8 @@ xrep_setup_rtbitmap(
 		return error;
 
 	/* Create an xfile to hold our reconstructed bitmap. */
-	descr = xchk_xfile_rtgroup_descr(sc, "bitmap file");
-	error = xfile_create(descr, blocks * mp->m_sb.sb_blocksize, &sc->xfile);
-	kfree(descr);
+	error = xfile_create("realtime bitmap file",
+			blocks * mp->m_sb.sb_blocksize, &sc->xfile);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index a092934ed3718..f713daf095fb2 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -128,13 +128,7 @@ int
 xrep_setup_rtrefcountbt(
 	struct xfs_scrub	*sc)
 {
-	char			*descr;
-	int			error;
-
-	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
-	error = xrep_setup_xfbtree(sc, descr);
-	kfree(descr);
-	return error;
+	return xrep_setup_xfbtree(sc, "realtime rmap record bag");
 }
 
 /* Check for any obvious conflicts with this shared/CoW staging extent. */
@@ -704,7 +698,6 @@ xrep_rtrefcountbt(
 {
 	struct xrep_rtrefc	*rr;
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	int			error;
 
 	/* We require the rmapbt to rebuild anything. */
@@ -722,11 +715,9 @@ xrep_rtrefcountbt(
 	rr->sc = sc;
 
 	/* Set up enough storage to handle one refcount record per rt extent. */
-	descr = xchk_xfile_ag_descr(sc, "reference count records");
-	error = xfarray_create(descr, mp->m_sb.sb_rextents,
-			sizeof(struct xfs_refcount_irec),
+	error = xfarray_create("realtime reference count records",
+			mp->m_sb.sb_rextents, sizeof(struct xfs_refcount_irec),
 			&rr->refcount_records);
-	kfree(descr);
 	if (error)
 		goto out_rr;
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 5af94e48d8cfd..4610d6d806487 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -103,14 +103,11 @@ xrep_setup_rtrmapbt(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_rtrmap	*rr;
-	char			*descr;
 	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
 
-	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
-	error = xrep_setup_xfbtree(sc, descr);
-	kfree(descr);
+	error = xrep_setup_xfbtree(sc, "realtime reverse mapping records");
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 712f27f6266c0..b510e6bbbd3e5 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -43,7 +43,6 @@ xchk_setup_rtsummary(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
-	char			*descr;
 	struct xchk_rtsummary	*rts;
 	int			error;
 
@@ -70,10 +69,8 @@ xchk_setup_rtsummary(
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
 
-- 
2.51.0




