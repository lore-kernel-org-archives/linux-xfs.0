Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C9CF7F53
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C5EA304032
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:47 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	C2ZznvuFdHGCPrOU for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004Yb-OX
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-00064c-LM
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 49/50] xfs: Add write support for
	dirent filetype field
Date: Mon, 12 Aug 2013 20:50:10 +1000
Message-Id: <1376304611-22994-50-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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

With write support, add the feature flag to the
XFS_SB_FEAT_INCOMPAT_ALL mask so we can now mount filesystems with
this feature set.

Performance of directory recursion is now much improved. Parallel
walk of ~50 million directory entries across hundreds of directories
improves significantly. Unpatched, no CRCs:

Walking via ls -R

real    3m19.886s
user    6m36.960s
sys     28m19.087s

THis is doing roughly 500 getdents() calls per second, and 250,000
inode lookups per second to determine the inode type at roughly
17,000 read IOPS. CPU usage is 90% kernel space.

With dtype support patched in and the fileset recreated with CRCs
enabled:

Walking via ls -R

real    0m31.316s
user    6m32.975s
sys     0m21.111s

This is doing roughly 3500 getdents() calls per second at 16,000
IOPS. There are no inode lookups at all. CPU usages is almost 100%
userspace.

This is a big win for recursive directory walks that only need to
find file names and file types.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2.c       |  3 +++
 fs/xfs/xfs_dir2_block.c |  7 +++++++
 fs/xfs/xfs_dir2_data.c  |  2 ++
 fs/xfs/xfs_dir2_leaf.c  |  3 +++
 fs/xfs/xfs_dir2_node.c  |  3 +++
 fs/xfs/xfs_dir2_sf.c    | 35 +++++++++++++++++++++++++++--------
 fs/xfs/xfs_sb.h         |  3 ++-
 7 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index f9825b1..d3ff96c 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -209,6 +209,7 @@ xfs_dir_createname(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = inum;
 	args.dp = dp;
@@ -283,6 +284,7 @@ xfs_dir_lookup(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
@@ -338,6 +340,7 @@ xfs_dir_removename(
 	memset(&args, 0, sizeof(xfs_da_args_t));
 	args.name = name->name;
 	args.namelen = name->len;
+	args.filetype = name->type;
 	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
 	args.inumber = ino;
 	args.dp = dp;
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 1cd2f56..0957aa9 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -549,6 +549,7 @@ xfs_dir2_block_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, args->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -641,6 +642,7 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(args->trans, bp);
 	return XFS_ERROR(error);
@@ -873,6 +875,7 @@ xfs_dir2_block_replace(
 	 * Change the inode number to the new value.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	xfs_dir2_data_log_entry(args->trans, bp, dep);
 	xfs_dir3_data_check(dp, bp);
 	return 0;
@@ -1159,6 +1162,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
+	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
@@ -1172,6 +1176,7 @@ xfs_dir2_sf_to_block(
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
+	xfs_dir3_dirent_put_ftype(mp, dep, XFS_DIR3_FT_DIR);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, bp, dep);
@@ -1219,6 +1224,8 @@ xfs_dir2_sf_to_block(
 		dep = (xfs_dir2_data_entry_t *)((char *)hdr + newoffset);
 		dep->inumber = cpu_to_be64(xfs_dir3_sfe_get_ino(mp, sfp, sfep));
 		dep->namelen = sfep->namelen;
+		xfs_dir3_dirent_put_ftype(mp, dep,
+					xfs_dir3_sfe_get_ftype(mp, sfp, sfep));
 		memcpy(dep->name, sfep->name, dep->namelen);
 		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
diff --git a/fs/xfs/xfs_dir2_data.c b/fs/xfs/xfs_dir2_data.c
index 1b59e43..47e1326 100644
--- a/fs/xfs/xfs_dir2_data.c
+++ b/fs/xfs/xfs_dir2_data.c
@@ -149,6 +149,8 @@ __xfs_dir3_data_check(
 		XFS_WANT_CORRUPTED_RETURN(
 			be16_to_cpu(*xfs_dir3_data_entry_tag_p(mp, dep)) ==
 					       (char *)dep - (char *)hdr);
+		XFS_WANT_CORRUPTED_RETURN(
+			xfs_dir3_dirent_get_ftype(mp, dep) < XFS_DIR3_FT_MAX);
 		count++;
 		lastfree = 0;
 		if (hdr->magic == cpu_to_be32(XFS_DIR2_BLOCK_MAGIC) ||
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index 887b1bd..08984ee 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -897,6 +897,7 @@ xfs_dir2_leaf_addname(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	/*
@@ -1225,6 +1226,7 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
+	args->filetype = xfs_dir3_dirent_get_ftype(dp->i_mount, dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
@@ -1555,6 +1557,7 @@ xfs_dir2_leaf_replace(
 	 * Put the new inode number in, log it.
 	 */
 	dep->inumber = cpu_to_be64(args->inumber);
+	xfs_dir3_dirent_put_ftype(dp->i_mount, dep, args->filetype);
 	tp = args->trans;
 	xfs_dir2_data_log_entry(tp, dbp, dep);
 	xfs_dir3_leaf_check(dp->i_mount, lbp);
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 49f1e9e..4c3dba7 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -816,6 +816,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				xfs_trans_brelse(tp, state->extrablk.bp);
 			args->cmpresult = cmp;
 			args->inumber = be64_to_cpu(dep->inumber);
+			args->filetype = xfs_dir3_dirent_get_ftype(mp, dep);
 			*indexp = index;
 			state->extravalid = 1;
 			state->extrablk.bp = curbp;
@@ -2007,6 +2008,7 @@ xfs_dir2_node_addname_int(
 	dep->inumber = cpu_to_be64(args->inumber);
 	dep->namelen = args->namelen;
 	memcpy(dep->name, args->name, dep->namelen);
+	xfs_dir3_dirent_put_ftype(mp, dep, args->filetype);
 	tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 	*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 	xfs_dir2_data_log_entry(tp, dbp, dep);
@@ -2227,6 +2229,7 @@ xfs_dir2_node_replace(
 		 * Fill in the new inode number and log the entry.
 		 */
 		dep->inumber = cpu_to_be64(inum);
+		xfs_dir3_dirent_put_ftype(state->mp, dep, args->filetype);
 		xfs_dir2_data_log_entry(args->trans, state->extrablk.bp, dep);
 		rval = 0;
 	}
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index bd14e1a..bb6e284 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -333,6 +333,8 @@ xfs_dir2_block_to_sf(
 			memcpy(sfep->name, dep->name, dep->namelen);
 			xfs_dir3_sfe_put_ino(mp, sfp, sfep,
 					     be64_to_cpu(dep->inumber));
+			xfs_dir3_sfe_put_ftype(mp, sfp, sfep,
+					xfs_dir3_dirent_get_ftype(mp, dep));
 
 			sfep = xfs_dir3_sf_nextentry(mp, sfp, sfep);
 		}
@@ -496,6 +498,8 @@ xfs_dir2_sf_addname_easy(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep, args->filetype);
+
 	/*
 	 * Update the header and inode.
 	 */
@@ -589,6 +593,7 @@ xfs_dir2_sf_addname_hard(
 	xfs_dir2_sf_put_offset(sfep, offset);
 	memcpy(sfep->name, args->name, sfep->namelen);
 	xfs_dir3_sfe_put_ino(mp, sfp, sfep, args->inumber);
+	xfs_dir3_sfe_put_ftype(mp, sfp, sfep, args->filetype);
 	sfp->count++;
 #if XFS_BIG_INUMS
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
@@ -825,6 +830,7 @@ xfs_dir2_sf_lookup(
 	if (args->namelen == 1 && args->name[0] == '.') {
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
+		args->filetype = XFS_DIR3_FT_DIR;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -834,6 +840,7 @@ xfs_dir2_sf_lookup(
 	    args->name[0] == '.' && args->name[1] == '.') {
 		args->inumber = xfs_dir2_sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
+		args->filetype = XFS_DIR3_FT_DIR;
 		return XFS_ERROR(EEXIST);
 	}
 	/*
@@ -853,6 +860,8 @@ xfs_dir2_sf_lookup(
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir3_sfe_get_ino(dp->i_mount,
 							     sfp, sfep);
+			args->filetype = xfs_dir3_sfe_get_ftype(dp->i_mount,
+								sfp, sfep);
 			if (cmp == XFS_CMP_EXACT)
 				return XFS_ERROR(EEXIST);
 			ci_sfep = sfep;
@@ -1052,6 +1061,8 @@ xfs_dir2_sf_replace(
 #endif
 				xfs_dir3_sfe_put_ino(dp->i_mount, sfp, sfep,
 						     args->inumber);
+				xfs_dir3_sfe_put_ftype(dp->i_mount, sfp, sfep,
+						       args->filetype);
 				break;
 			}
 		}
@@ -1118,10 +1129,12 @@ xfs_dir2_sf_toino4(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
+	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino4(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
@@ -1159,13 +1172,15 @@ xfs_dir2_sf_toino4(
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
@@ -1193,10 +1208,12 @@ xfs_dir2_sf_toino8(
 	int			oldsize;	/* old inode size */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
+	struct xfs_mount	*mp;
 
 	trace_xfs_dir2_sf_toino8(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 
 	/*
 	 * Copy the old directory to the buffer.
@@ -1234,13 +1251,15 @@ xfs_dir2_sf_toino8(
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
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index 3c297a4..c8d8898 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -594,7 +594,8 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
-#define XFS_SB_FEAT_INCOMPAT_ALL 0
+#define XFS_SB_FEAT_INCOMPAT_ALL \
+		(XFS_SB_FEAT_INCOMPAT_FTYPE)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
