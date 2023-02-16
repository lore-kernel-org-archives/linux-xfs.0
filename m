Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19459C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBPUyv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBPUyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C3352CF3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:54:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AB7DB829BC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8AC43444;
        Thu, 16 Feb 2023 20:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580873;
        bh=zs6Lb14BGUmoz2qTVA7UlZhI6IuDHzwoAzm7FvpO9eE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=N00HdKnzrPtWwpXNM/iRJp39qT+YvG5mEhXBAWdAmxPqPHtiuQkFId58be/RvxVTI
         97DqL4/2roVOB1cU+ZJAb8+/Y1L9mDtwRVxf6IV6NSKpNkTtB6pg4eq0UjYtTIcNnA
         ZAKvuU/KDLU+ClEkMHTw/hN3eVcyHauv81Q14dXIaKBCHXErGuVJSqu56tXA72V1gP
         DUMkL1l3YoPGJPaw4aXTVGbDXnrMozqnTgIlkT8pInRywdi6c4n3oE/pn4RvBl6Cpq
         1JbUObqba2NqeBxbwxmnj2BEmPGV7zGPuwIAOtMvwOjTBu2oWI6l16aEBWoF0jEqNM
         ARktdtpzRlq/Q==
Date:   Thu, 16 Feb 2023 12:54:33 -0800
Subject: [PATCH 04/25] xfsprogs: get directory offset when adding directory
 name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657878951.3476112.6748533618671731957.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 libxfs/xfs_da_btree.h   |    1 +
 libxfs/xfs_dir2.c       |    9 +++++++--
 libxfs/xfs_dir2.h       |    2 +-
 libxfs/xfs_dir2_block.c |    1 +
 libxfs/xfs_dir2_leaf.c  |    2 ++
 libxfs/xfs_dir2_node.c  |    2 ++
 libxfs/xfs_dir2_sf.c    |    2 ++
 mkfs/proto.c            |    2 +-
 repair/phase6.c         |   16 ++++++++--------
 9 files changed, 25 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index a4b29827..90b86d00 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -81,6 +81,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d6a19296..409d74a1 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -256,7 +256,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -311,6 +312,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -549,7 +554,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index dd39f17d..d9695447 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -40,7 +40,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index bb9301b7..fb5b4179 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -570,6 +570,7 @@ xfs_dir2_block_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 5da66006..2dac830c 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -868,6 +868,8 @@ xfs_dir2_leaf_addname(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index c0eb335c..45fb218f 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1971,6 +1971,8 @@ xfs_dir2_node_addname_int(
 	xfs_dir2_data_put_ftype(dp->i_mount, dep, args->filetype);
 	tagp = xfs_dir2_data_entry_tag_p(dp->i_mount, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 
 	/* Rescan the freespace and log the data block if needed. */
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 08b36c95..a3f1e657 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -485,6 +485,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -575,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
 	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 68ecdbf3..6b6a070f 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -328,7 +328,7 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, NULL);
 	if (error)
 		fail(_("directory createname error"), error);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 0be2c9c9..d1e9c0d9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -973,7 +973,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
+	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, NULL);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1070,7 +1070,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1082,7 +1082,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, nres);
+					orphanage_ino, nres, NULL);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d)\n"), err);
@@ -1104,7 +1104,7 @@ mv_orphanage(
 
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1151,7 +1151,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						nres);
+						nres, NULL);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d)\n"), ORPHANAGE, err);
@@ -1334,7 +1334,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						nres);
+						nres, NULL);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
@@ -2943,7 +2943,7 @@ _("error %d fixing shortform directory %llu\n"),
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 		if (error)
 			do_error(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
@@ -2998,7 +2998,7 @@ _("error %d fixing shortform directory %llu\n"),
 			libxfs_trans_ijoin(tp, ip, 0);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),

