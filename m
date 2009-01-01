Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n01Mex7o031902 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 16:40:59 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A141B1BF865F
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 14:40:56 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id UBcJiTI2IK8pWVwB for
	<xfs@oss.sgi.com>; Thu, 01 Jan 2009 14:40:56 -0800 (PST)
Message-Id: <20090101224057.147361063@sandeen.net>
References: <20090101224009.616367334@sandeen.net>
Date: Thu, 01 Jan 2009 16:40:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [patch 2/4] Remove macro-to-function indirections in attr code
Content-Disposition: inline; filename=ATTR_SHOUTING
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs/fs/xfs/xfs_attr_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.c
+++ xfs/fs/xfs/xfs_attr_leaf.c
@@ -736,7 +736,7 @@ xfs_attr_shortform_allfit(xfs_dabuf_t *b
 			continue;		/* don't copy partial entries */
 		if (!(entry->flags & XFS_ATTR_LOCAL))
 			return(0);
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+		name_loc = xfs_attr_leaf_name_local(leaf, i);
 		if (name_loc->namelen >= XFS_ATTR_SF_ENTSIZE_MAX)
 			return(0);
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
@@ -823,7 +823,7 @@ xfs_attr_leaf_to_shortform(xfs_dabuf_t *
 		if (!entry->nameidx)
 			continue;
 		ASSERT(entry->flags & XFS_ATTR_LOCAL);
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+		name_loc = xfs_attr_leaf_name_local(leaf, i);
 		nargs.name = (char *)name_loc->nameval;
 		nargs.namelen = name_loc->namelen;
 		nargs.value = (char *)&name_loc->nameval[nargs.namelen];
@@ -1141,14 +1141,14 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 	 * as part of this transaction (a split operation for example).
 	 */
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		name_loc->namelen = args->namelen;
 		name_loc->valuelen = cpu_to_be16(args->valuelen);
 		memcpy((char *)name_loc->nameval, args->name, args->namelen);
 		memcpy((char *)&name_loc->nameval[args->namelen], args->value,
 				   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->namelen = args->namelen;
 		memcpy((char *)name_rmt->name, args->name, args->namelen);
 		entry->flags |= XFS_ATTR_INCOMPLETE;
@@ -1159,7 +1159,7 @@ xfs_attr_leaf_add_work(xfs_dabuf_t *bp, 
 		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
 	}
 	xfs_da_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, XFS_ATTR_LEAF_NAME(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   xfs_attr_leaf_entsize(leaf, args->index)));
 
 	/*
@@ -1749,10 +1749,10 @@ xfs_attr_leaf_remove(xfs_dabuf_t *bp, xf
 	/*
 	 * Compress the remaining entries and zero out the removed stuff.
 	 */
-	memset(XFS_ATTR_LEAF_NAME(leaf, args->index), 0, entsize);
+	memset(xfs_attr_leaf_name(leaf, args->index), 0, entsize);
 	be16_add_cpu(&hdr->usedbytes, -entsize);
 	xfs_da_log_buf(args->trans, bp,
-	     XFS_DA_LOGRANGE(leaf, XFS_ATTR_LEAF_NAME(leaf, args->index),
+	     XFS_DA_LOGRANGE(leaf, xfs_attr_leaf_name(leaf, args->index),
 				   entsize));
 
 	tmp = (be16_to_cpu(hdr->count) - args->index)
@@ -1985,7 +1985,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
-			name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, probe);
+			name_loc = xfs_attr_leaf_name_local(leaf, probe);
 			if (name_loc->namelen != args->namelen)
 				continue;
 			if (memcmp(args->name, (char *)name_loc->nameval, args->namelen) != 0)
@@ -1995,7 +1995,7 @@ xfs_attr_leaf_lookup_int(xfs_dabuf_t *bp
 			args->index = probe;
 			return(XFS_ERROR(EEXIST));
 		} else {
-			name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, probe);
+			name_rmt = xfs_attr_leaf_name_remote(leaf, probe);
 			if (name_rmt->namelen != args->namelen)
 				continue;
 			if (memcmp(args->name, (char *)name_rmt->name,
@@ -2035,7 +2035,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, 
 
 	entry = &leaf->entries[args->index];
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		ASSERT(name_loc->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_loc->nameval, args->namelen) == 0);
 		valuelen = be16_to_cpu(name_loc->valuelen);
@@ -2050,7 +2050,7 @@ xfs_attr_leaf_getvalue(xfs_dabuf_t *bp, 
 		args->valuelen = valuelen;
 		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		ASSERT(name_rmt->namelen == args->namelen);
 		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 		valuelen = be32_to_cpu(name_rmt->valuelen);
@@ -2143,7 +2143,7 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 		 * off for 6.2, should be revisited later.
 		 */
 		if (entry_s->flags & XFS_ATTR_INCOMPLETE) { /* skip partials? */
-			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
+			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
 			be16_add_cpu(&hdr_s->usedbytes, -tmp);
 			be16_add_cpu(&hdr_s->count, -1);
 			entry_d--;	/* to compensate for ++ in loop hdr */
@@ -2160,11 +2160,11 @@ xfs_attr_leaf_moveents(xfs_attr_leafbloc
 			entry_d->flags = entry_s->flags;
 			ASSERT(be16_to_cpu(entry_d->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memmove(XFS_ATTR_LEAF_NAME(leaf_d, desti),
-				XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), tmp);
+			memmove(xfs_attr_leaf_name(leaf_d, desti),
+				xfs_attr_leaf_name(leaf_s, start_s + i), tmp);
 			ASSERT(be16_to_cpu(entry_s->nameidx) + tmp
 							<= XFS_LBSIZE(mp));
-			memset(XFS_ATTR_LEAF_NAME(leaf_s, start_s + i), 0, tmp);
+			memset(xfs_attr_leaf_name(leaf_s, start_s + i), 0, tmp);
 			be16_add_cpu(&hdr_s->usedbytes, -tmp);
 			be16_add_cpu(&hdr_d->usedbytes, tmp);
 			be16_add_cpu(&hdr_s->count, -1);
@@ -2276,12 +2276,12 @@ xfs_attr_leaf_entsize(xfs_attr_leafblock
 
 	ASSERT(be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC);
 	if (leaf->entries[index].flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, index);
-		size = XFS_ATTR_LEAF_ENTSIZE_LOCAL(name_loc->namelen,
+		name_loc = xfs_attr_leaf_name_local(leaf, index);
+		size = xfs_attr_leaf_entsize_local(name_loc->namelen,
 						   be16_to_cpu(name_loc->valuelen));
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, index);
-		size = XFS_ATTR_LEAF_ENTSIZE_REMOTE(name_rmt->namelen);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, index);
+		size = xfs_attr_leaf_entsize_remote(name_rmt->namelen);
 	}
 	return(size);
 }
@@ -2297,13 +2297,13 @@ xfs_attr_leaf_newentsize(int namelen, in
 {
 	int size;
 
-	size = XFS_ATTR_LEAF_ENTSIZE_LOCAL(namelen, valuelen);
-	if (size < XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(blocksize)) {
+	size = xfs_attr_leaf_entsize_local(namelen, valuelen);
+	if (size < xfs_attr_leaf_entsize_local_max(blocksize)) {
 		if (local) {
 			*local = 1;
 		}
 	} else {
-		size = XFS_ATTR_LEAF_ENTSIZE_REMOTE(namelen);
+		size = xfs_attr_leaf_entsize_remote(namelen);
 		if (local) {
 			*local = 0;
 		}
@@ -2372,7 +2372,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			xfs_attr_leaf_name_local_t *name_loc =
-				XFS_ATTR_LEAF_NAME_LOCAL(leaf, i);
+				xfs_attr_leaf_name_local(leaf, i);
 
 			retval = context->put_listent(context,
 						entry->flags,
@@ -2384,7 +2384,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, 
 				return retval;
 		} else {
 			xfs_attr_leaf_name_remote_t *name_rmt =
-				XFS_ATTR_LEAF_NAME_REMOTE(leaf, i);
+				xfs_attr_leaf_name_remote(leaf, i);
 
 			int valuelen = be32_to_cpu(name_rmt->valuelen);
 
@@ -2468,11 +2468,11 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *a
 
 #ifdef DEBUG
 	if (entry->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf, args->index);
 		namelen = name_loc->namelen;
 		name = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		namelen = name_rmt->namelen;
 		name = (char *)name_rmt->name;
 	}
@@ -2487,7 +2487,7 @@ xfs_attr_leaf_clearflag(xfs_da_args_t *a
 
 	if (args->rmtblkno) {
 		ASSERT((entry->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_da_log_buf(args->trans, bp,
@@ -2534,7 +2534,7 @@ xfs_attr_leaf_setflag(xfs_da_args_t *arg
 	xfs_da_log_buf(args->trans, bp,
 			XFS_DA_LOGRANGE(leaf, entry, sizeof(*entry)));
 	if ((entry->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf, args->index);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_da_log_buf(args->trans, bp,
@@ -2607,20 +2607,20 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *a
 
 #ifdef DEBUG
 	if (entry1->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf1, args->index);
+		name_loc = xfs_attr_leaf_name_local(leaf1, args->index);
 		namelen1 = name_loc->namelen;
 		name1 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf1, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
 		namelen1 = name_rmt->namelen;
 		name1 = (char *)name_rmt->name;
 	}
 	if (entry2->flags & XFS_ATTR_LOCAL) {
-		name_loc = XFS_ATTR_LEAF_NAME_LOCAL(leaf2, args->index2);
+		name_loc = xfs_attr_leaf_name_local(leaf2, args->index2);
 		namelen2 = name_loc->namelen;
 		name2 = (char *)name_loc->nameval;
 	} else {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf2, args->index2);
+		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
 		namelen2 = name_rmt->namelen;
 		name2 = (char *)name_rmt->name;
 	}
@@ -2637,7 +2637,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *a
 			  XFS_DA_LOGRANGE(leaf1, entry1, sizeof(*entry1)));
 	if (args->rmtblkno) {
 		ASSERT((entry1->flags & XFS_ATTR_LOCAL) == 0);
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf1, args->index);
+		name_rmt = xfs_attr_leaf_name_remote(leaf1, args->index);
 		name_rmt->valueblk = cpu_to_be32(args->rmtblkno);
 		name_rmt->valuelen = cpu_to_be32(args->valuelen);
 		xfs_da_log_buf(args->trans, bp1,
@@ -2648,7 +2648,7 @@ xfs_attr_leaf_flipflags(xfs_da_args_t *a
 	xfs_da_log_buf(args->trans, bp2,
 			  XFS_DA_LOGRANGE(leaf2, entry2, sizeof(*entry2)));
 	if ((entry2->flags & XFS_ATTR_LOCAL) == 0) {
-		name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf2, args->index2);
+		name_rmt = xfs_attr_leaf_name_remote(leaf2, args->index2);
 		name_rmt->valueblk = 0;
 		name_rmt->valuelen = 0;
 		xfs_da_log_buf(args->trans, bp2,
@@ -2855,7 +2855,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **tra
 	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
 		if (be16_to_cpu(entry->nameidx) &&
 		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, i);
+			name_rmt = xfs_attr_leaf_name_remote(leaf, i);
 			if (name_rmt->valueblk)
 				count++;
 		}
@@ -2883,7 +2883,7 @@ xfs_attr_leaf_inactive(xfs_trans_t **tra
 	for (i = 0; i < be16_to_cpu(leaf->hdr.count); entry++, i++) {
 		if (be16_to_cpu(entry->nameidx) &&
 		    ((entry->flags & XFS_ATTR_LOCAL) == 0)) {
-			name_rmt = XFS_ATTR_LEAF_NAME_REMOTE(leaf, i);
+			name_rmt = xfs_attr_leaf_name_remote(leaf, i);
 			if (name_rmt->valueblk) {
 				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
 				lp->valuelen = XFS_B_TO_FSB(dp->i_mount,
Index: xfs/fs/xfs/xfs_attr_leaf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_attr_leaf.h
+++ xfs/fs/xfs/xfs_attr_leaf.h
@@ -151,8 +151,6 @@ typedef struct xfs_attr_leafblock {
 /*
  * Cast typed pointers for "local" and "remote" name/value structs.
  */
-#define XFS_ATTR_LEAF_NAME_REMOTE(leafp,idx)	\
-	xfs_attr_leaf_name_remote(leafp,idx)
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
@@ -160,8 +158,6 @@ xfs_attr_leaf_name_remote(xfs_attr_leafb
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME_LOCAL(leafp,idx)	\
-	xfs_attr_leaf_name_local(leafp,idx)
 static inline xfs_attr_leaf_name_local_t *
 xfs_attr_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
 {
@@ -169,8 +165,6 @@ xfs_attr_leaf_name_local(xfs_attr_leafbl
 		&((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
 }
 
-#define XFS_ATTR_LEAF_NAME(leafp,idx)		\
-	xfs_attr_leaf_name(leafp,idx)
 static inline char *xfs_attr_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 {
 	return &((char *)leafp)[be16_to_cpu(leafp->entries[idx].nameidx)];
@@ -181,24 +175,18 @@ static inline char *xfs_attr_leaf_name(x
  * a "local" name/value structure, a "remote" name/value structure, and
  * a pointer which might be either.
  */
-#define XFS_ATTR_LEAF_ENTSIZE_REMOTE(nlen)	\
-	xfs_attr_leaf_entsize_remote(nlen)
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL(nlen,vlen)	\
-	xfs_attr_leaf_entsize_local(nlen,vlen)
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
 	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-#define XFS_ATTR_LEAF_ENTSIZE_LOCAL_MAX(bsize)	\
-	xfs_attr_leaf_entsize_local_max(bsize)
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
 {
 	return (((bsize) >> 1) + ((bsize) >> 2));

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
