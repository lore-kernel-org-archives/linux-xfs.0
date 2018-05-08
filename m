Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60282 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752321AbeEHEn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fP8t156925
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:28 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2hs4k26st3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w484hR7Y024161
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:27 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w484hRnc029379
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:27 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 08/21] xfsprogs: get directory offset when adding directory name
Date: Mon,  7 May 2018 21:41:06 -0700
Message-Id: <1525754479-12177-9-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Return the directory offset information when adding an entry to the
directory.

This offset will be used as the parent pointer offset in xfs_create,
xfs_symlink, xfs_link and xfs_rename.

[dchinner: forward ported and cleaned up]
[dchinner: no s-o-b from Mark]
[bfoster: rebased, use args->geo in dir code]
[achender: rebased, chaged __uint32_t to xfs_dir2_dataptr_t]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_da_btree.h   |  1 +
 libxfs/xfs_dir2.c       |  9 +++++++--
 libxfs/xfs_dir2.h       |  3 ++-
 libxfs/xfs_dir2_block.c |  1 +
 libxfs/xfs_dir2_leaf.c  |  2 ++
 libxfs/xfs_dir2_node.c  |  2 ++
 libxfs/xfs_dir2_sf.c    |  2 ++
 mkfs/proto.c            |  3 ++-
 repair/phase6.c         | 17 +++++++++--------
 9 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ae6de17..bce96d6 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -86,6 +86,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index d82eaab..cd67e1b 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -255,7 +255,8 @@ xfs_dir_createname(
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_fsblock_t		*first,		/* bmap's firstblock */
 	struct xfs_defer_ops	*dfops,		/* bmap's freeblock list */
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
@@ -557,7 +562,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0);
+	return xfs_dir_createname(tp, dp, name, 0, NULL, NULL, 0, NULL);
 }
 
 /*
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 388d67c..378c654 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -131,7 +131,8 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_fsblock_t *first,
-				struct xfs_defer_ops *dfops, xfs_extlen_t tot);
+				struct xfs_defer_ops *dfops, xfs_extlen_t tot,
+				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index e2c524e..4815d26 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -549,6 +549,7 @@ xfs_dir2_block_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 60f7eb2..949e798 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -887,6 +887,8 @@ xfs_dir2_leaf_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 6d7986c..697e37e 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2032,6 +2032,8 @@ xfs_dir2_node_addname_int(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index fbb9482..e601208 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -403,6 +403,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -494,6 +495,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index bc38345..67c228a 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -331,7 +331,8 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, inum, first, dfops, rsv,
+				       NULL);
 	if (error)
 		fail(_("directory createname error"), error);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 498a3b5..b41cc2b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1061,7 +1061,7 @@ mk_orphanage(xfs_mount_t *mp)
 	 * create the actual entry
 	 */
 	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, &first,
-					&dfops, nres);
+					&dfops, nres, NULL);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1170,7 +1170,7 @@ mv_orphanage(
 
 			libxfs_defer_init(&dfops, &first);
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &dfops, nres);
+						ino, &first, &dfops, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1183,7 +1183,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, &first, &dfops, nres);
+					orphanage_ino, &first, &dfops, nres, NULL);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
@@ -1214,7 +1214,7 @@ mv_orphanage(
 			libxfs_defer_init(&dfops, &first);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, &first, &dfops, nres);
+						ino, &first, &dfops, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1270,7 +1270,7 @@ mv_orphanage(
 
 		libxfs_defer_init(&dfops, &first);
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						&first, &dfops, nres);
+						&first, &dfops, nres, NULL);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1408,7 +1408,8 @@ longform_dir2_rebuild(
 
 		libxfs_defer_init(&dfops, &firstblock);
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						&firstblock, &dfops, nres);
+						&firstblock, &dfops, nres,
+						NULL);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
@@ -3011,7 +3012,7 @@ process_dir_inode(
 		libxfs_defer_init(&dfops, &first);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, &first, &dfops, nres);
+					ip->i_ino, &first, &dfops, nres, NULL);
 		if (error)
 			do_error(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
@@ -3069,7 +3070,7 @@ process_dir_inode(
 			libxfs_defer_init(&dfops, &first);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, &first, &dfops, nres);
+					ip->i_ino, &first, &dfops, nres, NULL);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
-- 
2.7.4

