Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18033491DB;
	Fri, 23 Jan 2026 07:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769151804; cv=none; b=BnN26Rw6ho8sgALCbeO7EPpe8lMshbbfOHI27cE1ye5cQDW9O8+bpD5M46gp5UX/mFlPYBWeACwqEaWswGeVwxL5g2WOy6BrFvyernxOQ8CRqW/C0Za8LkLBLwPOuLMzyetT0J4w5TBNFMdA564ogL+XMuZyO5Dpr0aOAxYokX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769151804; c=relaxed/simple;
	bh=HojNe7GdD8+4AS3GDSxnCPSpva0GFKJegnogIcYHHxo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHrsRH0r+picLsOraxvFWMRoTbTiM882WXjaXFjq5QzieLE5LQIPB8HX+rSVjwHX2BC0VimSoI53DHyQNxCqRI57Tk7AqviAw2MV8j0pZUdsSi2qqR5osvMXLRghyhZzQtB/q5JKn1kKfL/QlHiLnoJSU5S1wHjbO/znbhbIPhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+0pvAfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+0pvAfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67944C4CEF1;
	Fri, 23 Jan 2026 07:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769151802;
	bh=HojNe7GdD8+4AS3GDSxnCPSpva0GFKJegnogIcYHHxo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E+0pvAfR6sb6+Z5JYF8WpFZNe2WLRbJaTYQVwz7FJgZbao1WnMMEEgafowX3sIvtn
	 gaJcFgB3uE9oSk5P9l94QNwmC+Fl5a0ezLd/MUP2jLubvGux0OQot5c5TnatT2uJ3D
	 N9CuECF2am6TwH7KH2d3HIxMMvyVYKpOdp88pMb6PI7JWv7KslOYqj9uwKvEn1GXdk
	 uMwbz3w9lR3stnFmcGHzPKU5FM+epvCoLSkOdAZK3EtH1vnHnEVpoIEtTE3o842FKQ
	 o39yIdQ560t6D3fYp40vPpOiSCpbXTlcdQap+DDGC7OW+QF6ergrjVuTcEVhhrYWEi
	 aw4MIXRlMDjVA==
Date: Thu, 22 Jan 2026 23:03:22 -0800
Subject: [PATCH 1/5] xfs: get rid of the xchk_xfile_*_descr calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, linux-xfs@vger.kernel.org,
 r772577952@gmail.com, hch@lst.de
Message-ID: <176915153716.1677852.3636395936252128481.stgit@frogsfrogsfrogs>
In-Reply-To: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
---
 fs/xfs/scrub/common.h            |   25 -------------------------
 fs/xfs/scrub/agheader_repair.c   |   13 ++++---------
 fs/xfs/scrub/alloc_repair.c      |    5 +----
 fs/xfs/scrub/attr_repair.c       |   20 +++++---------------
 fs/xfs/scrub/bmap_repair.c       |    6 +-----
 fs/xfs/scrub/dir.c               |   13 ++++---------
 fs/xfs/scrub/dir_repair.c        |   11 +++--------
 fs/xfs/scrub/dirtree.c           |   11 +++--------
 fs/xfs/scrub/ialloc_repair.c     |    5 +----
 fs/xfs/scrub/nlinks.c            |    6 ++----
 fs/xfs/scrub/parent.c            |   11 +++--------
 fs/xfs/scrub/parent_repair.c     |   23 ++++++-----------------
 fs/xfs/scrub/quotacheck.c        |   13 +++----------
 fs/xfs/scrub/refcount_repair.c   |   13 ++-----------
 fs/xfs/scrub/rmap_repair.c       |    5 +----
 fs/xfs/scrub/rtbitmap_repair.c   |    6 ++----
 fs/xfs/scrub/rtrefcount_repair.c |   15 +++------------
 fs/xfs/scrub/rtrmap_repair.c     |    5 +----
 fs/xfs/scrub/rtsummary.c         |    7 ++-----
 19 files changed, 47 insertions(+), 166 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ddbc065c798cd1..f2ecc68538f0c3 100644
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
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index cd6f0223879f49..a2f6a7f71d8396 100644
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
index bed6a09aa79112..b6fe1f23819eb2 100644
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
index 09d63aa10314b0..eded354dec11ee 100644
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
index 1084213b8e9b88..747cd9389b491d 100644
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
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c877bde71e6280..4f849d98cbdd22 100644
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
index 8d3b550990b58a..7a21b688a47158 100644
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
index 3a9cdf8738b6db..f9c85b8b194fa4 100644
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
index 14e48d3f1912bf..b1d00167d263f4 100644
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
index 091c79e432e592..2ba686e4de8bc5 100644
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
index 11d5de10fd567b..23c195d14494e5 100644
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
index 2949feda627175..897902c54178d4 100644
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
index d412a8359784ee..3b2f4ccde2ec09 100644
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
index 9c8cb5332da042..360fd7354880a7 100644
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
index 17d4a38d735cb8..cfd1cf403b37eb 100644
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
index 203a1a97c5026e..41d6736a529d02 100644
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
index 983362447826de..b35e39cce7ad5a 100644
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
index 7561941a337a1f..749977a66e40ff 100644
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
index 4ac679c1bd29cd..fb78cff2ac3a16 100644
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
 

