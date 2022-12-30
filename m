Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D0FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiLaCS4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbiLaCSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:18:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC451C900
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BA4061CAA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87CBC433D2;
        Sat, 31 Dec 2022 02:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453133;
        bh=wHDQAieVYbfcAMx75NHZ105v/TRMe7GupuHNBfwYL70=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FIVWaKl3J1uArlqhVGoK105Htdhgytr0c7nKL/ogb2A5RoPhmR4APZv8UwhQ8jejE
         ++aFDcdgfYqlqQ483ZjW3SesS5Z/iCumneCxVrShz1HfVsW8pZvzI0yt8BwIgXoNiK
         /YiIg1c92XnxJGaAnVi8ftLsoEolRH0JSnEzxLksz09jP1HXJQ4YFq1yAZrYi3CmMz
         knYRbuPofLOFvTWciFWX2f2rdqK1mAFEsDZvS2nkXc5wf2nBypdOlE1i54WoeNz9Ub
         xL8lJdfxCCoQaS4yf3ukh5H6TSzEki3LfJKc7AQdQOLGZ83fkkqulhOFRWSMrrhkSe
         8De1szHmmLpvg==
Subject: [PATCH 35/46] xfs_repair: don't let metadata and regular files mix
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876390.725900.744751966113087822.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index cf517f77173..eae64a0556f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2354,6 +2354,7 @@ process_dinode_int(
 	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
+	bool			is_meta = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2926,6 +2927,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
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
@@ -3012,6 +3025,14 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
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
index 8a1a39ec60c..0027593ae31 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -274,6 +274,7 @@ typedef struct ino_tree_node  {
 	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
 	uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
+	uint64_t		ino_was_meta;	/* bit == 1 if metadata */
 	uint8_t			nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -541,6 +542,24 @@ static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
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
index 0dd7a2f060f..ef74e64f308 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -253,6 +253,7 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ino_was_rl = 0;
 	irec->ino_is_rl = 0;
+	irec->ino_was_meta = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/phase6.c b/repair/phase6.c
index 4bdea2a2a38..3e740079235 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1905,6 +1905,38 @@ longform_dir2_entry_check_data(
 			continue;
 		}
 
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadata_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 "\n"),
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
+		if (xfs_is_metadata_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 "\n"),
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
@@ -2815,6 +2847,37 @@ shortform_dir2_entry_check(
 						ino_dirty);
 			continue;
 		}
+
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadata_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 "\n"),
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
+		if (xfs_is_metadata_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 "\n"),
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

