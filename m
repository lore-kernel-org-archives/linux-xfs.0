Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EACkFw250497 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:12:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B83E6165518
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:13:41 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	reDHsRg1XRsiCTIm for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:13:41 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11528821-1927428
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 20:43:39 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NVMhj-0007rO-Ir
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:13:27 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NVMdg-0001LD-3c
	for xfs@oss.sgi.com; Thu, 14 Jan 2010 21:09:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfsprogs: fix sign warnings in libxfs
Date: Thu, 14 Jan 2010 21:09:04 +1100
Message-Id: <1263463752-5052-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263463752-5052-1-git-send-email-david@fromorbit.com>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The directory naming is a mix of char and uchar_t and the compiler
warns wheter they cross over. Cast the pointers according to the
destination requirements as it doesn't seem to matter to avoid
the warnings.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/xfs_types.h     |    2 +-
 libxfs/xfs_attr.c       |   10 +++++-----
 libxfs/xfs_attr_leaf.c  |   10 +++++-----
 libxfs/xfs_dir2.c       |    2 +-
 libxfs/xfs_dir2_block.c |    8 ++++----
 libxfs/xfs_dir2_leaf.c  |    4 ++--
 libxfs/xfs_dir2_node.c  |    4 ++--
 libxfs/xfs_dir2_sf.c    |   13 +++++++------
 8 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/include/xfs_types.h b/include/xfs_types.h
index 0f51916..6f566ff 100644
--- a/include/xfs_types.h
+++ b/include/xfs_types.h
@@ -161,7 +161,7 @@ typedef enum {
 } xfs_btnum_t;
 
 struct xfs_name {
-	const char	*name;
+	const uchar_t	*name;
 	int		len;
 };
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7ab37ff..5bd3c2a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -64,7 +64,7 @@ xfs_attr_name_to_xname(
 {
 	if (!aname)
 		return EINVAL;
-	xname->name = aname;
+	xname->name = (const uchar_t *)aname;
 	xname->len = strlen(aname);
 	if (xname->len >= MAXNAMELEN)
 		return EFAULT;		/* match IRIX behaviour */
@@ -103,7 +103,7 @@ xfs_attr_fetch(xfs_inode_t *ip, struct xfs_name *name,
 	memset((char *)&args, 0, sizeof(args));
 	args.name = name->name;
 	args.namelen = name->len;
-	args.value = value;
+	args.value = (uchar_t *)value;
 	args.valuelen = *valuelenp;
 	args.flags = flags;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
@@ -233,7 +233,7 @@ xfs_attr_set_int(xfs_inode_t *dp, struct xfs_name *name,
 	memset((char *)&args, 0, sizeof(args));
 	args.name = name->name;
 	args.namelen = name->len;
-	args.value = value;
+	args.value = (uchar_t *)value;
 	args.valuelen = valuelen;
 	args.flags = flags;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
@@ -1545,7 +1545,7 @@ xfs_attr_rmtval_get(xfs_da_args_t *args)
 	ASSERT(!(args->flags & ATTR_KERNOVAL));
 
 	mp = args->dp->i_mount;
-	dst = args->value;
+	dst = (xfs_caddr_t)args->value;
 	valuelen = args->valuelen;
 	lblkno = args->rmtblkno;
 	while (valuelen > 0) {
@@ -1601,7 +1601,7 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	src = args->value;
+	src = (xfs_caddr_t)args->value;
 
 	/*
 	 * Find a "hole" in the attribute address space large enough for
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index f8f926f..d535752 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -476,11 +476,11 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
-		nargs.name = (char *)sfe->nameval;
+		nargs.name = (uchar_t *)sfe->nameval;
 		nargs.namelen = sfe->namelen;
-		nargs.value = (char *)&sfe->nameval[nargs.namelen];
+		nargs.value = (uchar_t *)&sfe->nameval[nargs.namelen];
 		nargs.valuelen = sfe->valuelen;
-		nargs.hashval = xfs_da_hashname((char *)sfe->nameval,
+		nargs.hashval = xfs_da_hashname((uchar_t *)sfe->nameval,
 						sfe->namelen);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
 		error = xfs_attr_leaf_lookup_int(bp, &nargs); /* set a->index */
@@ -610,9 +610,9 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *bp, xfs_da_args_t *args, int forkoff)
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
 		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
-		nargs.name = (char *)name_loc->nameval;
+		nargs.name = (uchar_t *)name_loc->nameval;
 		nargs.namelen = name_loc->namelen;
-		nargs.value = (char *)&name_loc->nameval[nargs.namelen];
+		nargs.value = (uchar_t *)&name_loc->nameval[nargs.namelen];
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 71134f8..2d2abd1 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -18,7 +18,7 @@
 
 #include <xfs.h>
 
-struct xfs_name xfs_name_dotdot = {"..", 2};
+struct xfs_name xfs_name_dotdot = {(uchar_t *)"..", 2};
 
 extern const struct xfs_nameops xfs_default_nameops;
 
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index d197b0b..d286000 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -36,8 +36,8 @@ static xfs_dahash_t xfs_dir_hash_dot, xfs_dir_hash_dotdot;
 void
 xfs_dir_startup(void)
 {
-	xfs_dir_hash_dot = xfs_da_hashname(".", 1);
-	xfs_dir_hash_dotdot = xfs_da_hashname("..", 2);
+	xfs_dir_hash_dot = xfs_da_hashname((uchar_t *)".", 1);
+	xfs_dir_hash_dotdot = xfs_da_hashname((uchar_t *)"..", 2);
 }
 
 /*
@@ -489,7 +489,7 @@ xfs_dir2_block_lookup(
 	 * Fill in inode number, CI name if appropriate, release the block.
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
+	error = xfs_dir_cilookup_result(args, (char *)dep->name, dep->namelen);
 	xfs_da_brelse(args->trans, bp);
 	return XFS_ERROR(error);
 }
@@ -576,7 +576,7 @@ xfs_dir2_block_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = mp->m_dirnameops->compname(args, (char *)dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			*bpp = bp;
diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
index 9a1aace..356b541 100644
--- a/libxfs/xfs_dir2_leaf.c
+++ b/libxfs/xfs_dir2_leaf.c
@@ -906,7 +906,7 @@ xfs_dir2_leaf_lookup(
 	 * Return the found inode number & CI name if appropriate
 	 */
 	args->inumber = be64_to_cpu(dep->inumber);
-	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
+	error = xfs_dir_cilookup_result(args, (char *)dep->name, dep->namelen);
 	xfs_da_brelse(tp, dbp);
 	xfs_da_brelse(tp, lbp);
 	return XFS_ERROR(error);
@@ -1000,7 +1000,7 @@ xfs_dir2_leaf_lookup_int(
 		 * and buffer. If it's the first case-insensitive match, store
 		 * the index and buffer and continue looking for an exact match.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = mp->m_dirnameops->compname(args, (char *)dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			*indexp = index;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index db88adc..6a92f13 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -612,7 +612,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		 * EEXIST immediately. If it's the first case-insensitive
 		 * match, store the block & inode number and continue looking.
 		 */
-		cmp = mp->m_dirnameops->compname(args, dep->name, dep->namelen);
+		cmp = mp->m_dirnameops->compname(args, (char *)dep->name, dep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			/* If there is a CI match block, drop it */
 			if (args->cmpresult != XFS_CMP_DIFFERENT &&
@@ -1821,7 +1821,7 @@ xfs_dir2_node_lookup(
 
 		dep = (xfs_dir2_data_entry_t *)((char *)state->extrablk.bp->
 						data + state->extrablk.index);
-		rval = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
+		rval = xfs_dir_cilookup_result(args, (char *)dep->name, dep->namelen);
 	}
 	/*
 	 * Release the btree blocks and leaf block.
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 77f30de..06e076d 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -732,8 +732,8 @@ xfs_dir2_sf_lookup(
 		 * number. If it's the first case-insensitive match, store the
 		 * inode number and continue looking for an exact match.
 		 */
-		cmp = dp->i_mount->m_dirnameops->compname(args, sfep->name,
-								sfep->namelen);
+		cmp = dp->i_mount->m_dirnameops->compname(args,
+					(char *)sfep->name, sfep->namelen);
 		if (cmp != XFS_CMP_DIFFERENT && cmp != args->cmpresult) {
 			args->cmpresult = cmp;
 			args->inumber = xfs_dir2_sf_get_inumber(sfp,
@@ -751,7 +751,8 @@ xfs_dir2_sf_lookup(
 	if (!ci_sfep)
 		return XFS_ERROR(ENOENT);
 	/* otherwise process the CI match as required by the caller */
-	error = xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
+	error = xfs_dir_cilookup_result(args, (char *)ci_sfep->name,
+						ci_sfep->namelen);
 	return XFS_ERROR(error);
 }
 
@@ -793,7 +794,7 @@ xfs_dir2_sf_removename(
 	 */
 	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp); i < sfp->hdr.count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-		if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
+		if (xfs_da_compname(args, (char *)sfep->name, sfep->namelen) ==
 								XFS_CMP_EXACT) {
 			ASSERT(xfs_dir2_sf_get_inumber(sfp,
 						xfs_dir2_sf_inumberp(sfep)) ==
@@ -928,8 +929,8 @@ xfs_dir2_sf_replace(
 		for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
 				i < sfp->hdr.count;
 				i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-			if (xfs_da_compname(args, sfep->name, sfep->namelen) ==
-								XFS_CMP_EXACT) {
+			if (xfs_da_compname(args, (char *)sfep->name,
+					sfep->namelen) == XFS_CMP_EXACT) {
 #if XFS_BIG_INUMS || defined(DEBUG)
 				ino = xfs_dir2_sf_get_inumber(sfp,
 					xfs_dir2_sf_inumberp(sfep));
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
