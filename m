Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE894279E1;
	Wed, 21 Jan 2026 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977624; cv=none; b=TEPdXunyKSE6TzP+bBwlyoVNtsUoi7Oj15yyYE3MryuvqSO9TgxnMUSLsIoPwGGs6bqcL1jdufF75voOz4Vczgsekvuwg2HoPa5xx4gxRKVbiXGzz0qzufNm3cfdiMWlfSrNeqamNhsf9ZGrGPPOUJYCfBL0hjY4f8CxU2gNyhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977624; c=relaxed/simple;
	bh=jdE/Ves3Auer3kZlYOjePF6HShCxVDNNKVlG0Yhpk+w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uT6QUqWc15hu41Ij5yyFFkJwkQ9Z8lk6iqGXohuESg/MxzcqG1+Twwj3LQdH+Uw8V/HFuIFX9U4Fo21TwHKKL6HwNN/YWPR5+VniP/JQlxXi7ypCzJvRYQY50jWHAjYA518Gstq3UD73/yw5MAWbY/eMwJqb4lCB5YCGmUmU+1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlZRt1Ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlZRt1Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F20C116D0;
	Wed, 21 Jan 2026 06:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977624;
	bh=jdE/Ves3Auer3kZlYOjePF6HShCxVDNNKVlG0Yhpk+w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qlZRt1NgoZZNmg8UeK0SSjtyhSiFmYwp6DPpaQ/9NtfpFu9nSiLcwC7gdVQpBVZ7A
	 Acd2Z/Ine/2d0n54+u++YmQMQnvFLdb8XElln0iFoNmWV0To8a9DhKpWyPJFRbT8B/
	 OmFJzhUacikF5AdvvjpRa7FAr/FazAGbXCNuIy9WWF9i2YZRiUIzE7ejfqFkVUcNhS
	 TXRy7Ft8kXq9JW+ySfUTQUOyZOc1ue3XLEuW7kOQhUjxKAQxQb1KBCIv/uKq6UAKyf
	 qc1OIJ2edcpNlsG16ZA0lZ7O7R2j2eexvu5IUcGyMxWVPbQkJl/pejiK3TnGHOfeR8
	 tzKCXo5RTYchw==
Date: Tue, 20 Jan 2026 22:40:23 -0800
Subject: [PATCH 1/4] xfs: check the return value of xchk_xfile_*_descr calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, r772577952@gmail.com,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176897723563.207608.1472219452580720216.stgit@frogsfrogsfrogs>
In-Reply-To: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
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
so let's just add return value checking across the board.  Note that
this patch touches a number of commits, most of which were merged
between 6.6 and 6.14.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.12
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c   |    6 ++++++
 fs/xfs/scrub/alloc_repair.c      |    5 +++++
 fs/xfs/scrub/attr_repair.c       |   20 ++++++++++++++++++++
 fs/xfs/scrub/bmap_repair.c       |    5 +++++
 fs/xfs/scrub/dir.c               |   10 ++++++++++
 fs/xfs/scrub/dir_repair.c        |    8 ++++++++
 fs/xfs/scrub/dirtree.c           |   10 ++++++++++
 fs/xfs/scrub/ialloc_repair.c     |    5 +++++
 fs/xfs/scrub/nlinks.c            |    5 +++++
 fs/xfs/scrub/parent.c            |    8 ++++++++
 fs/xfs/scrub/parent_repair.c     |   20 ++++++++++++++++++++
 fs/xfs/scrub/quotacheck.c        |   15 +++++++++++++++
 fs/xfs/scrub/refcount_repair.c   |    8 ++++++++
 fs/xfs/scrub/rmap_repair.c       |    3 +++
 fs/xfs/scrub/rtbitmap_repair.c   |    3 +++
 fs/xfs/scrub/rtrefcount_repair.c |    8 ++++++++
 fs/xfs/scrub/rtrmap_repair.c     |    3 +++
 fs/xfs/scrub/rtsummary.c         |    3 +++
 18 files changed, 145 insertions(+)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index cd6f0223879f49..8d7762cf5daffd 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1743,6 +1743,9 @@ xrep_agi(
 	sc->buf_cleanup = xrep_agi_buf_cleanup;
 
 	descr = xchk_xfile_ag_descr(sc, "iunlinked next pointers");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
 			&ragi->iunlink_next);
 	kfree(descr);
@@ -1750,6 +1753,9 @@ xrep_agi(
 		return error;
 
 	descr = xchk_xfile_ag_descr(sc, "iunlinked prev pointers");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfarray_create(descr, 0, sizeof(xfs_agino_t),
 			&ragi->iunlink_prev);
 	kfree(descr);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index bed6a09aa79112..2e1d62efba72a7 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -877,6 +877,11 @@ xrep_allocbt(
 
 	/* Set up enough storage to handle maximally fragmented free space. */
 	descr = xchk_xfile_ag_descr(sc, "free space records");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_ra;
+	}
+
 	error = xfarray_create(descr, mp->m_sb.sb_agblocks / 2,
 			sizeof(struct xfs_alloc_rec_incore),
 			&ra->free_records);
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index c7eb94069cafcd..73684ce9b81bc5 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1556,6 +1556,11 @@ xrep_xattr_setup_scan(
 
 	/* Set up some staging for salvaged attribute keys and values */
 	descr = xchk_xfile_ino_descr(sc, "xattr keys");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_rx;
+	}
+
 	error = xfarray_create(descr, 0, sizeof(struct xrep_xattr_key),
 			&rx->xattr_records);
 	kfree(descr);
@@ -1563,6 +1568,11 @@ xrep_xattr_setup_scan(
 		goto out_rx;
 
 	descr = xchk_xfile_ino_descr(sc, "xattr names");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_keys;
+	}
+
 	error = xfblob_create(descr, &rx->xattr_blobs);
 	kfree(descr);
 	if (error)
@@ -1573,6 +1583,11 @@ xrep_xattr_setup_scan(
 
 		descr = xchk_xfile_ino_descr(sc,
 				"xattr retained parent pointer entries");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_values;
+		}
+
 		error = xfarray_create(descr, 0,
 				sizeof(struct xrep_xattr_pptr),
 				&rx->pptr_recs);
@@ -1582,6 +1597,11 @@ xrep_xattr_setup_scan(
 
 		descr = xchk_xfile_ino_descr(sc,
 				"xattr retained parent pointer names");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_pprecs;
+		}
+
 		error = xfblob_create(descr, &rx->pptr_names);
 		kfree(descr);
 		if (error)
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 1084213b8e9b88..74df05142dcf4c 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -947,6 +947,11 @@ xrep_bmap(
 	max_bmbt_recs = xfs_iext_max_nextents(large_extcount, whichfork);
 	descr = xchk_xfile_ino_descr(sc, "%s fork mapping records",
 			whichfork == XFS_DATA_FORK ? "data" : "attr");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_rb;
+	}
+
 	error = xfarray_create(descr, max_bmbt_recs,
 			sizeof(struct xfs_bmbt_rec), &rb->bmap_records);
 	kfree(descr);
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c877bde71e6280..58346d54042b07 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -1109,6 +1109,11 @@ xchk_directory(
 		 * due to locking contention.
 		 */
 		descr = xchk_xfile_ino_descr(sc, "slow directory entries");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_sd;
+		}
+
 		error = xfarray_create(descr, 0, sizeof(struct xchk_dirent),
 				&sd->dir_entries);
 		kfree(descr);
@@ -1116,6 +1121,11 @@ xchk_directory(
 			goto out_sd;
 
 		descr = xchk_xfile_ino_descr(sc, "slow directory entry names");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_entries;
+		}
+
 		error = xfblob_create(descr, &sd->dir_names);
 		kfree(descr);
 		if (error)
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 8d3b550990b58a..50e0af4bdaa63a 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1789,6 +1789,9 @@ xrep_dir_setup_scan(
 
 	/* Set up some staging memory for salvaging dirents. */
 	descr = xchk_xfile_ino_descr(sc, "directory entries");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfarray_create(descr, 0, sizeof(struct xrep_dirent),
 			&rd->dir_entries);
 	kfree(descr);
@@ -1796,6 +1799,11 @@ xrep_dir_setup_scan(
 		return error;
 
 	descr = xchk_xfile_ino_descr(sc, "directory entry names");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_xfarray;
+	}
+
 	error = xfblob_create(descr, &rd->dir_names);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 3a9cdf8738b6db..7f8ad41e3ec20e 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -117,6 +117,11 @@ xchk_setup_dirtree(
 	mutex_init(&dl->lock);
 
 	descr = xchk_xfile_ino_descr(sc, "dirtree path steps");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_dl;
+	}
+
 	error = xfarray_create(descr, 0, sizeof(struct xchk_dirpath_step),
 			&dl->path_steps);
 	kfree(descr);
@@ -124,6 +129,11 @@ xchk_setup_dirtree(
 		goto out_dl;
 
 	descr = xchk_xfile_ino_descr(sc, "dirtree path names");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_steps;
+	}
+
 	error = xfblob_create(descr, &dl->path_names);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 14e48d3f1912bf..3055380cf29271 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -817,6 +817,11 @@ xrep_iallocbt(
 	xfs_agino_range(mp, pag_agno(sc->sa.pag), &first_agino, &last_agino);
 	last_agino /= XFS_INODES_PER_CHUNK;
 	descr = xchk_xfile_ag_descr(sc, "inode index records");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_ri;
+	}
+
 	error = xfarray_create(descr, last_agino,
 			sizeof(struct xfs_inobt_rec_incore),
 			&ri->inode_records);
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 091c79e432e592..c71b065ccb4c45 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -1008,6 +1008,11 @@ xchk_nlinks_setup_scan(
 	xfs_agino_range(mp, last_agno, &first_agino, &last_agino);
 	max_inos = XFS_AGINO_TO_INO(mp, last_agno, last_agino) + 1;
 	descr = xchk_xfile_descr(sc, "file link counts");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_teardown;
+	}
+
 	error = xfarray_create(descr, min(XFS_MAXINUMBER + 1, max_inos),
 			sizeof(struct xchk_nlink), &xnc->nlinks);
 	kfree(descr);
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 11d5de10fd567b..11c70e5d3e03de 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -769,6 +769,9 @@ xchk_parent_pptr(
 	 * due to locking contention.
 	 */
 	descr = xchk_xfile_ino_descr(sc, "slow parent pointer entries");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfarray_create(descr, 0, sizeof(struct xchk_pptr),
 			&pp->pptr_entries);
 	kfree(descr);
@@ -776,6 +779,11 @@ xchk_parent_pptr(
 		goto out_pp;
 
 	descr = xchk_xfile_ino_descr(sc, "slow parent pointer names");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_entries;
+	}
+
 	error = xfblob_create(descr, &pp->pptr_names);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 2949feda627175..8683317f2342df 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -1526,6 +1526,11 @@ xrep_parent_setup_scan(
 
 	/* Set up some staging memory for logging parent pointer updates. */
 	descr = xchk_xfile_ino_descr(sc, "parent pointer entries");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_xattr_value;
+	}
+
 	error = xfarray_create(descr, 0, sizeof(struct xrep_pptr),
 			&rp->pptr_recs);
 	kfree(descr);
@@ -1533,6 +1538,11 @@ xrep_parent_setup_scan(
 		goto out_xattr_value;
 
 	descr = xchk_xfile_ino_descr(sc, "parent pointer names");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_recs;
+	}
+
 	error = xfblob_create(descr, &rp->pptr_names);
 	kfree(descr);
 	if (error)
@@ -1541,6 +1551,11 @@ xrep_parent_setup_scan(
 	/* Set up some storage for copying attrs before the mapping exchange */
 	descr = xchk_xfile_ino_descr(sc,
 				"parent pointer retained xattr entries");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_names;
+	}
+
 	error = xfarray_create(descr, 0, sizeof(struct xrep_parent_xattr),
 			&rp->xattr_records);
 	kfree(descr);
@@ -1549,6 +1564,11 @@ xrep_parent_setup_scan(
 
 	descr = xchk_xfile_ino_descr(sc,
 				"parent pointer retained xattr values");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_attr_keys;
+	}
+
 	error = xfblob_create(descr, &rp->xattr_blobs);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index d412a8359784ee..7d0ad19ddf577d 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -757,6 +757,11 @@ xqcheck_setup_scan(
 	error = -ENOMEM;
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_USER)) {
 		descr = xchk_xfile_descr(sc, "user dquot records");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_teardown;
+		}
+
 		error = xfarray_create(descr, max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->ucounts);
 		kfree(descr);
@@ -766,6 +771,11 @@ xqcheck_setup_scan(
 
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_GROUP)) {
 		descr = xchk_xfile_descr(sc, "group dquot records");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_teardown;
+		}
+
 		error = xfarray_create(descr, max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->gcounts);
 		kfree(descr);
@@ -775,6 +785,11 @@ xqcheck_setup_scan(
 
 	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_PROJ)) {
 		descr = xchk_xfile_descr(sc, "project dquot records");
+		if (!descr) {
+			error = -ENOMEM;
+			goto out_teardown;
+		}
+
 		error = xfarray_create(descr, max_dquots,
 				sizeof(struct xqcheck_dquot), &xqc->pcounts);
 		kfree(descr);
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index 9c8cb5332da042..d53c9a5bb7809c 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -127,6 +127,9 @@ xrep_setup_ag_refcountbt(
 	int			error;
 
 	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
 	return error;
@@ -718,6 +721,11 @@ xrep_refcountbt(
 
 	/* Set up enough storage to handle one refcount record per block. */
 	descr = xchk_xfile_ag_descr(sc, "reference count records");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_rr;
+	}
+
 	error = xfarray_create(descr, mp->m_sb.sb_agblocks,
 			sizeof(struct xfs_refcount_irec),
 			&rr->refcount_records);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 17d4a38d735cb8..c619ba469e36de 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -170,6 +170,9 @@ xrep_setup_ag_rmapbt(
 	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
 
 	descr = xchk_xfile_ag_descr(sc, "reverse mapping records");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 203a1a97c5026e..070347df717c46 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -53,6 +53,9 @@ xrep_setup_rtbitmap(
 
 	/* Create an xfile to hold our reconstructed bitmap. */
 	descr = xchk_xfile_rtgroup_descr(sc, "bitmap file");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfile_create(descr, blocks * mp->m_sb.sb_blocksize, &sc->xfile);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index 983362447826de..029e3e332f605e 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -132,6 +132,9 @@ xrep_setup_rtrefcountbt(
 	int			error;
 
 	descr = xchk_xfile_ag_descr(sc, "rmap record bag");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
 	return error;
@@ -723,6 +726,11 @@ xrep_rtrefcountbt(
 
 	/* Set up enough storage to handle one refcount record per rt extent. */
 	descr = xchk_xfile_ag_descr(sc, "reference count records");
+	if (!descr) {
+		error = -ENOMEM;
+		goto out_rr;
+	}
+
 	error = xfarray_create(descr, mp->m_sb.sb_rextents,
 			sizeof(struct xfs_refcount_irec),
 			&rr->refcount_records);
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 7561941a337a1f..c74d640068d1c8 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -109,6 +109,9 @@ xrep_setup_rtrmapbt(
 	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
 
 	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
 	if (error)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 4ac679c1bd29cd..bf2b96e51d070c 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -71,6 +71,9 @@ xchk_setup_rtsummary(
 	 * us to avoid pinning kernel memory for this purpose.
 	 */
 	descr = xchk_xfile_descr(sc, "realtime summary file");
+	if (!descr)
+		return -ENOMEM;
+
 	error = xfile_create(descr, XFS_FSB_TO_B(mp, mp->m_rsumblocks),
 			&sc->xfile);
 	kfree(descr);

