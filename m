Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7FDC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uHjqsweE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41DEEC433C7;
	Sun, 31 Dec 2023 23:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066095;
	bh=xJE6aIicalWzdsK4RiB/lHliCyNdc5IFeurqiSchu8k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uHjqsweE8z+a7rpHAe9g4MMlw0mkHK8KdjAlm+cvCN54HqUmyphZT/tS+IMio8CIt
	 Vxw/+8SLpboickhYpCLFE9g+p8/9a5PDhJI9b0Y3n+3hlfZzZFCLC+Ku/mUR5Eb50R
	 TXR5v+ZwT6J4Il1+Fx6P2rDKtTuTtqcCAhdGSwngf+clZO4cSzKTs5L7MGGOkm+bWP
	 hxaSRiY8EZgcOz2nTQ4ld1SCLYyjvGD07XMLx5n1iu5SptyxdJJgFQKbLoOTt6Wf8n
	 vCSWHF0RCsKVvPHIo0LSq/EJ7ZmhX8g91WxA/z85K5DmqJg42sOULbLWJBXQrtkRDZ
	 yc5TYDlLsJc2w==
Date: Sun, 31 Dec 2023 15:41:34 -0800
Subject: [PATCH 46/58] xfs_repair: don't let metadata and regular files mix
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010560.1809361.13344497598278668677.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Track whether or not inodes thought they were metadata inodes.  We
cannot allow metadata inodes to appear in the regular directory tree,
and we cannot allow regular inodes to appear in the metadata directory
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c     |   21 +++++++++++++++++
 repair/incore.h     |   19 +++++++++++++++
 repair/incore_ino.c |    1 +
 repair/phase6.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 4af7c91d5c9..7c3e5d86404 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2361,6 +2361,7 @@ process_dinode_int(
 	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
+	bool			is_meta = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2933,6 +2934,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	if (collect_rmaps)
 		record_inode_reflink_flag(mp, dino, agno, ino, lino);
 
+	/* Does this inode think it was metadata? */
+	if (dino->di_version >= 3 &&
+	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR))) {
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
@@ -3019,6 +3032,14 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
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
index 9ad5f1972d3..90eb1242cd8 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -271,6 +271,7 @@ typedef struct ino_tree_node  {
 	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
 	uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
+	uint64_t		ino_was_meta;	/* bit == 1 if metadata */
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
+	irec->ino_was_meta |= IREC_MASK(offset);
+}
+
+static inline void clear_inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_was_meta &= ~IREC_MASK(offset);
+}
+
+static inline int inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_was_meta & IREC_MASK(offset)) != 0;
+}
+
 /*
  * add_inode_reached() is set on inode I only if I has been reached
  * by an inode P claiming to be the parent and if I is a directory,
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index b0b41a2cc5c..e33f7cef758 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -254,6 +254,7 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ino_was_rl = 0;
 	irec->ino_is_rl = 0;
+	irec->ino_was_meta = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/phase6.c b/repair/phase6.c
index 05e0b8ac593..21bd2b75050 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2020,6 +2020,38 @@ longform_dir2_entry_check_data(
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
+					fname, ip->i_ino, inum)) {
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
+					fname, ip->i_ino, inum)) {
+				dep->name[0] = '/';
+				libxfs_dir2_data_log_entry(&da, bp, dep);
+			}
+			continue;
+		}
+
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
@@ -2931,6 +2963,37 @@ shortform_dir2_entry_check(
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

