Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbeIZQiK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANdwG073171
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mnd5thjs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPlbh013043
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:48 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPlNP032133
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:47 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 13/30] xfsprogs: get directory offset when adding directory name
Date: Wed, 26 Sep 2018 03:23:16 -0700
Message-Id: <1537957413-10630-14-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
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
 libxfs/xfs_dir2.h       |  2 +-
 libxfs/xfs_dir2_block.c |  1 +
 libxfs/xfs_dir2_leaf.c  |  2 ++
 libxfs/xfs_dir2_node.c  |  2 ++
 libxfs/xfs_dir2_sf.c    |  2 ++
 mkfs/proto.c            |  2 +-
 repair/phase6.c         | 16 ++++++++--------
 9 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 84dd865..04a0641 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -71,6 +71,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_dir2_dataptr_t offset;	/* OUT: offset in directory */
 } xfs_da_args_t;
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index b0ad4a8..af6f4b1 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -241,7 +241,8 @@ xfs_dir_createname(
 	struct xfs_inode	*dp,
 	struct xfs_name		*name,
 	xfs_ino_t		inum,		/* new entry inode number */
-	xfs_extlen_t		total)		/* bmap's total block count */
+	xfs_extlen_t		total,		/* bmap's total block count */
+	xfs_dir2_dataptr_t	*offset)	/* OUT entry's dir offset */
 {
 	struct xfs_da_args	*args;
 	int			rval;
@@ -296,6 +297,10 @@ xfs_dir_createname(
 		rval = xfs_dir2_node_addname(args);
 
 out_free:
+	/* return the location that this entry was place in the parent inode */
+	if (offset)
+		*offset = args->offset;
+
 	kmem_free(args);
 	return rval;
 }
@@ -534,7 +539,7 @@ xfs_dir_canenter(
 	xfs_inode_t	*dp,
 	struct xfs_name	*name)		/* name of entry to add */
 {
-	return xfs_dir_createname(tp, dp, name, 0, 0);
+	return xfs_dir_createname(tp, dp, name, 0, 0, NULL);
 }
 
 /*
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index c3e3f6b..c164a38 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
@@ -117,7 +117,7 @@ extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
-				xfs_extlen_t tot);
+				xfs_extlen_t tot, xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 554029c..e52344a 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -543,6 +543,7 @@ xfs_dir2_block_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_byte_to_dataptr((char *)dep - (char *)hdr);
 	/*
 	 * Clean up the bestfree array and log the header, tail, and entry.
 	 */
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index dbe4d2e..df1a214 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -879,6 +879,8 @@ xfs_dir2_leaf_addname(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, use_block,
+						(char *)dep - (char *)hdr);
 	/*
 	 * Need to scan fix up the bestfree table.
 	 */
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index a0d2dce..286c50e 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2024,6 +2024,8 @@ xfs_dir2_node_addname_int(
 	dp->d_ops->data_put_ftype(dep, args->filetype);
 	tagp = dp->d_ops->data_entry_tag_p(dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
+	args->offset = xfs_dir2_db_off_to_dataptr(args->geo, dbno,
+						  (char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(args, dbp, dep);
 	/*
 	 * Rescan the block for bestfree if needed.
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 24a0e61..e4a1519 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -391,6 +391,7 @@ xfs_dir2_sf_addname_easy(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 
 	/*
 	 * Update the header and inode.
@@ -482,6 +483,7 @@ xfs_dir2_sf_addname_hard(
 	memcpy(sfep->name, args->name, sfep->namelen);
 	dp->d_ops->sf_put_ino(sfp, sfep, args->inumber);
 	dp->d_ops->sf_put_ftype(sfep, args->filetype);
+	args->offset = xfs_dir2_byte_to_dataptr(offset);
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
 		sfp->i8count++;
diff --git a/mkfs/proto.c b/mkfs/proto.c
index a51d011..a0b2003 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -314,7 +314,7 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, inum, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, inum, rsv, NULL);
 	if (error)
 		fail(_("directory createname error"), error);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index dd59b1e..db37a6c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1014,7 +1014,7 @@ mk_orphanage(xfs_mount_t *mp)
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
+	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres, NULL);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
@@ -1111,7 +1111,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1124,7 +1124,7 @@ mv_orphanage(
 			libxfs_trans_log_inode(tp, orphanage_ip, XFS_ILOG_CORE);
 
 			err = -libxfs_dir_createname(tp, ino_p, &xfs_name_dotdot,
-					orphanage_ino, nres);
+					orphanage_ino, nres, NULL);
 			if (err)
 				do_error(
 	_("creation of .. entry failed (%d), filesystem may be out of space\n"),
@@ -1145,7 +1145,7 @@ mv_orphanage(
 			libxfs_trans_ijoin(tp, ino_p, 0);
 
 			err = -libxfs_dir_createname(tp, orphanage_ip, &xname,
-						ino, nres);
+						ino, nres, NULL);
 			if (err)
 				do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1193,7 +1193,7 @@ mv_orphanage(
 		libxfs_trans_ijoin(tp, ino_p, 0);
 
 		err = -libxfs_dir_createname(tp, orphanage_ip, &xname, ino,
-						nres);
+						nres, NULL);
 		if (err)
 			do_error(
 	_("name create failed in %s (%d), filesystem may be out of space\n"),
@@ -1361,7 +1361,7 @@ longform_dir2_rebuild(
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						nres);
+						nres, NULL);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"),
@@ -2939,7 +2939,7 @@ process_dir_inode(
 		libxfs_trans_ijoin(tp, ip, 0);
 
 		error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 		if (error)
 			do_error(
 	_("can't make \"..\" entry in root inode %" PRIu64 ", createname error %d\n"), ino, error);
@@ -2991,7 +2991,7 @@ process_dir_inode(
 			libxfs_trans_ijoin(tp, ip, 0);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, nres);
+					ip->i_ino, nres, NULL);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
-- 
2.7.4
