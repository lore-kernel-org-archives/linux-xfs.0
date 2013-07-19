Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3AF2804E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52206AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	YObskts76lgCF1Tj for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:39 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004Ii-Je
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002Mu-Hm
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 48/49] xfs: Add write support for dirent filetype field
Date: Fri, 19 Jul 2013 16:45:23 +1000
Message-Id: <1374216324-8781-49-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add support to propagate and add filetype values into the on-disk
directs. This involves passing the filetype into the xfs_da_args
structure along with the name and namelength for direct operations,
and encoding it into the dirent at the same time we write the inode
number into the dirent.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_sb.h        |  3 ++-
 libxfs/xfs_dir2_block.c |  7 +++++++
 libxfs/xfs_dir2_data.c  |  2 ++
 libxfs/xfs_dir2_leaf.c  |  3 +++
 libxfs/xfs_dir2_node.c  |  3 +++
 libxfs/xfs_dir2_sf.c    | 35 +++++++++++++++++++++++++++--------
 6 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index c5b1c04..4851137 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -594,7 +594,8 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
-#define XFS_SB_FEAT_INCOMPAT_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_ALL \
+		(XFS_SB_FEAT_INCOMPAT_FTYPE)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 615eea9..3e4bc53 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -530,6 +530,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -622,6 +623,7 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(args->trans, bp);
 	return XFS_ERROR(error);
@@ -854,6 +856,7 @@ xfs_dir2_block_replace(
 	 * Change the inode number to the new value.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	xfs_dir2_data_log_entry(args->trans, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
@@ -1140,6 +1143,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
+	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
@@ -1153,6 +1157,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
+	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
@@ -1200,6 +1205,8 @@ xfs_dir2_sf_to_block(
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
 		dep->inumber = cpu_to_be64(xfs_dir3_sfe_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
+		xfs_dir3_dirent_put_ftype(mp, dep,
+					xfs_dir3_sfe_get_ftype(mp, sfp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index ea9ba91..189699f 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -133,6 +133,8 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(
 			be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) ==
 					       (char *)dep - (char *)hdr);
+		XFS_WANT_CORRUPTED_RETURN(
+			xfs_dir3_dirent_get_ftype(mp, dep) < XFS_DIR3_FT_MAX);
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 04ad083..7ec2f19 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -878,6 +878,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -1207,6 +1208,7 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	args->filetype = xfs_dir3_dirent_get_ftype(dp->i_mount, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
@@ -1537,6 +1539,7 @@ xfs_dir2_leaf_replace(
 	 * Put the new inode number in, log it.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
+	xfs_dir3_dirent_put_ftype(dp->i_mount, dep, args->filetype);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	xfs_dir3_leaf_check(dp->i_mount, lbp);
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 5b118d5..10d1d81 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -798,6 +798,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				xfs_trans_brelse(tp, state->extrablk.bp);
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
+			args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
@@ -1989,6 +1990,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
@@ -2209,6 +2211,7 @@ xfs_dir2_node_replace(
 		 * Fill in the new inode number and log the entry.
 		 */
 		dep->inumber = cpu_to_be64(inum);
+		xfs_dir3_dirent_put_ftype(state->mp, dep, args->filetype);
 		xfs_dir2_data_log_entry(args->trans, state->extrablk.bp, dep);
 		rval = 0;
 	}
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 2791d99..740cab0 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -316,6 +316,8 @@ xfs_dir2_block_to_sf(
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir3_sfe_put_ino(mp, sfp, sfep,
 					     be64_to_cpu(dep->inumber));
+			xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+					xfs_dir3_dirent_get_ftype(mp, dep));
 
 			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 		}
@@ -479,6 +481,8 @@ xfs_dir2_sf_addname_easy(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep, args->filetype);
+
 	/*
 	 * Update the header and inode.
 	 */
@@ -572,6 +576,7 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir3_sfe_put_ino(mp, sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ftype(mp, sfp, sfep, args->filetype);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -808,6 +813,7 @@ xfs_dir2_sf_lookup(
 	if (args->namelen == 1 && args->name[0] == '.') {
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
+		args->filetype = XFS_DIR3_FT_DIR;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -817,6 +823,7 @@ xfs_dir2_sf_lookup(
 	    args->name[0] == '.' && args->name[1] == '.') {
 		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
+		args->filetype = XFS_DIR3_FT_DIR;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -836,6 +843,8 @@ xfs_dir2_sf_lookup(
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir3_sfe_get_ino(dp->i_mount,
 							     sfp, sfep);
+			args->filetype = xfs_dir3_sfe_get_ftype(dp->i_mount,
+								sfp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -1035,6 +1044,8 @@ xfs_dir2_sf_replace(
 #endif
 				xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
 						     args->inumber);
+				xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep,
+						       args->filetype);
 				break;
 			}
 		}
@@ -1101,10 +1112,12 @@ xfs_dir2_sf_toino4(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
+	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino4(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
@@ -1142,13 +1155,15 @@ xfs_dir2_sf_toino4(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep),
-		  oldsfep = xfs_dir3_sf_nextentry(dp->i_mount, oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep),
+		  oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
-			xfs_dir3_sfe_get_ino(dp->i_mount, oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ino(mp, sfp, sfep,
+			xfs_dir3_sfe_get_ino(mp, oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+			xfs_dir3_sfe_get_ftype(mp, oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
@@ -1176,10 +1191,12 @@ xfs_dir2_sf_toino8(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
+	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino8(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
@@ -1217,13 +1234,15 @@ xfs_dir2_sf_toino8(
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp),
 		    oldsfep = xfs_dir2_sf_firstentry(oldsfp);
 	     i < sfp->count;
-	     i++, sfep = xfs_dir3_sf_nextentry(dp->i_mount, sfp, sfep),
-		  oldsfep = xfs_dir3_sf_nextentry(dp->i_mount, oldsfp, oldsfep)) {
+	     i++, sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep),
+		  oldsfep = xfs_dir3_sf_nextentry(mp, oldsfp, oldsfep)) {
 		sfep->namelen = oldsfep->namelen;
 		sfep->offset = oldsfep->offset;
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
-			xfs_dir3_sfe_get_ino(dp->i_mount, oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ino(mp, sfp, sfep,
+			xfs_dir3_sfe_get_ino(mp, oldsfp, oldsfep));
+		xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+			xfs_dir3_sfe_get_ftype(mp, oldsfp, oldsfep));
 	}
 	/*
 	 * Clean up the inode.
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
