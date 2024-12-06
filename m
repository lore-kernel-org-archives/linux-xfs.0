Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1353E1F3D3D
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528849; cv=none; b=jWHEObOe4FbPYHFNHAtBjEldOidmKvcebycPfSwygCNhrMnKXMaRUm9f2/OMtwOd4IAHob2tf6quFMNPH1ln1HGMdNTKyar3jZgA9nfBQyevZRly0mhXD+1HgYgGLBGKnnFJAo/VOnkPLnCcttzcRMt2CPYnna3yz05wX6oSJYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528849; c=relaxed/simple;
	bh=quWdXIn0y5kZFuRGNQJw8OXxzEwl/uQBzVAH2+N4zjo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwDbMJm/Sp75pAIXdvhRG+IH55rqlOqNuLdkAN4V1FjuqzRm1EPV6DqVBjE+TuAP+qrxzv/LnYOQlYCIvRZWLhSXLEA/3O3YzE2VU5E1oQlNRMshW9QP3hQGw0bDNyss52eda51rMfjGWh3VGxmO8QEVw80eIF9XMruT3sMBqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/jv7EDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/jv7EDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838ADC4CED1;
	Fri,  6 Dec 2024 23:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528848;
	bh=quWdXIn0y5kZFuRGNQJw8OXxzEwl/uQBzVAH2+N4zjo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=o/jv7EDyFB5kM41JZvOWPf4x3qeGjmrBD71JgBpckDGu4gMMODxA4DIAUysLizzvI
	 ELGHzyBKhboEoZP7U0R3b91NBt88FUr03uU9/TJu6qKQiQZf/+nxITddrIH0W03NxT
	 vcpjHeeFz2pQKtkZxv1kYaqxiLHTo/ZnZxxBHX+leGvlOpBkl94pMtVvY+AznTlZT5
	 jWoeZQNVcaeNxCzInzHBA8hA6YtUbUbSNuXELv2p0J2OVOYIhoUZRvdaE4bGgfsfSO
	 HhQbNu+/fmWMMFmmXJMJuzcEyPtzH8+q/Xl5oWTyVNSEv2tiTt8mKJ8LIc+ndt4UAQ
	 +owQ/e8dQM4Nw==
Date: Fri, 06 Dec 2024 15:47:28 -0800
Subject: [PATCH 30/41] xfs_repair: don't let metadata and regular files mix
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748695.122992.10407812901278086211.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Track whether or not inodes thought they were metadata inodes.  We
cannot allow metadata inodes to appear in the regular directory tree,
and we cannot allow regular inodes to appear in the metadata directory
tree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/dinode.c     |   21 +++++++++++++++++
 repair/incore.h     |   19 +++++++++++++++
 repair/incore_ino.c |    1 +
 repair/phase2.c     |    7 +++++-
 repair/phase6.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 110 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f21a4dd387331b..b9d2d15882c593 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2392,6 +2392,7 @@ process_dinode_int(
 	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
+	bool			is_meta = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2971,6 +2972,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	if (collect_rmaps)
 		record_inode_reflink_flag(mp, dino, agno, ino, lino);
 
+	/* Does this inode think it was metadata? */
+	if (dino->di_version >= 3 &&
+	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
+		struct ino_tree_node	*irec;
+		int			off;
+
+		irec = find_inode_rec(mp, agno, ino);
+		off = get_inode_offset(mp, lino, irec);
+		set_inode_is_meta(irec, off);
+		is_meta = true;
+	}
+
 	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
@@ -3057,6 +3070,14 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	*used = is_free;
 	*isa_dir = 0;
 	blkmap_free(dblkmap);
+	if (is_meta) {
+		struct ino_tree_node	*irec;
+		int			off;
+
+		irec = find_inode_rec(mp, agno, ino);
+		off = get_inode_offset(mp, lino, irec);
+		clear_inode_is_meta(irec, off);
+	}
 	return 1;
 }
 
diff --git a/repair/incore.h b/repair/incore.h
index 4f32ad3377faed..568a8c7cb75b7c 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -271,6 +271,7 @@ typedef struct ino_tree_node  {
 	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
 	uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
+	uint64_t		ino_is_meta;	/* bit == 1 if metadata */
 	uint8_t			nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -538,6 +539,24 @@ static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
 	return (irec->ino_is_rl & IREC_MASK(offset)) != 0;
 }
 
+/*
+ * set/clear/test was inode marked as metadata
+ */
+static inline void set_inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_meta |= IREC_MASK(offset);
+}
+
+static inline void clear_inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_meta &= ~IREC_MASK(offset);
+}
+
+static inline int inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_is_meta & IREC_MASK(offset)) != 0;
+}
+
 /*
  * add_inode_reached() is set on inode I only if I has been reached
  * by an inode P claiming to be the parent and if I is a directory,
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 158e9b4980d984..3189e019faa23d 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -257,6 +257,7 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ino_was_rl = 0;
 	irec->ino_is_rl = 0;
+	irec->ino_is_meta = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/phase2.c b/repair/phase2.c
index 17c16e94a600c2..476a1c74db8c8d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -557,8 +557,10 @@ phase2(
 		 */
 		ino_rec = set_inode_used_alloc(mp, 0,
 				XFS_INO_TO_AGINO(mp, sb->sb_rootino));
-		for (j = 1; j < inuse; j++)
+		for (j = 1; j < inuse; j++) {
 			set_inode_used(ino_rec, j);
+			set_inode_is_meta(ino_rec, j);
+		}
 
 		for (j = inuse; j < XFS_INODES_PER_CHUNK; j++)
 			set_inode_free(ino_rec, j);
@@ -594,6 +596,7 @@ phase2(
 				else
 					do_warn(_("would correct\n"));
 			}
+			set_inode_is_meta(ino_rec, j);
 			j++;
 		}
 
@@ -605,6 +608,7 @@ phase2(
 			else
 				do_warn(_("would correct\n"));
 		}
+		set_inode_is_meta(ino_rec, j);
 		j++;
 
 		if (is_inode_free(ino_rec, j))  {
@@ -615,6 +619,7 @@ phase2(
 			else
 				do_warn(_("would correct\n"));
 		}
+		set_inode_is_meta(ino_rec, j);
 		j++;
 	}
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 95c44352883d7c..f2358bde194e38 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1610,6 +1610,38 @@ longform_dir2_entry_check_data(
 			continue;
 		}
 
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadir_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
+					fname, ip->i_ino, inum, NULLFSINO)) {
+				dep->name[0] = '/';
+				libxfs_dir2_data_log_entry(&da, bp, dep);
+			}
+			continue;
+		}
+
+		/*
+		 * Metadata directories cannot point to regular files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (xfs_is_metadir_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
+					fname, ip->i_ino, inum, NULLFSINO)) {
+				dep->name[0] = '/';
+				libxfs_dir2_data_log_entry(&da, bp, dep);
+			}
+			continue;
+		}
+
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
@@ -2521,6 +2553,37 @@ shortform_dir2_entry_check(
 						ino_dirty);
 			continue;
 		}
+
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadir_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
+					fname, ip->i_ino, lino);
+			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
+						&max_size, &i, &bytes_deleted,
+						ino_dirty);
+			continue;
+		}
+
+		/*
+		 * Metadata directories cannot point to regular files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (xfs_is_metadir_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
+					fname, ip->i_ino, lino);
+			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
+						&max_size, &i, &bytes_deleted,
+						ino_dirty);
+			continue;
+		}
+
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */

