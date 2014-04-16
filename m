Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E14037F75
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:44:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D29A9304089
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:44:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HgtCjeBYLd7c9t1t for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 10:44:17 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3705363C5FD4
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:44:16 -0500 (CDT)
Message-ID: <534EC173.7010903@sandeen.net>
Date: Wed, 16 Apr 2014 12:44:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: return is not a function
References: <534EC073.8090006@sandeen.net>
In-Reply-To: <534EC073.8090006@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

return is not a function.  "return(EIO);" is silly;
"return (EIO);" moreso.  return is not a function.
Nuke the pointless parens.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 01b6a01..95de302 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -151,7 +151,7 @@ xfs_attr_get_int(
 
 	if (error == EEXIST)
 		error = 0;
-	return(error);
+	return error;
 }
 
 int
@@ -169,7 +169,7 @@ xfs_attr_get(
 	XFS_STATS_INC(xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return(EIO);
+		return EIO;
 
 	error = xfs_attr_name_to_xname(&xname, name);
 	if (error)
@@ -178,7 +178,7 @@ xfs_attr_get(
 	lock_mode = xfs_ilock_attr_map_shared(ip);
 	error = xfs_attr_get_int(ip, &xname, value, valuelenp, flags);
 	xfs_iunlock(ip, lock_mode);
-	return(error);
+	return error;
 }
 
 /*
@@ -254,7 +254,7 @@ xfs_attr_set_int(
 			      XFS_ATTR_SF_ENTSIZE_BYNAME(name->len, valuelen);
 
 		if ((error = xfs_bmap_add_attrfork(dp, sf_size, rsvd)))
-			return(error);
+			return error;
 	}
 
 	/*
@@ -303,7 +303,7 @@ xfs_attr_set_int(
 	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
-		return(error);
+		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
@@ -313,7 +313,7 @@ xfs_attr_set_int(
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
-		return (error);
+		return error;
 	}
 
 	xfs_trans_ijoin(args.trans, dp, 0);
@@ -426,14 +426,14 @@ xfs_attr_set_int(
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	return(error);
+	return error;
 
 out:
 	if (args.trans)
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return(error);
+	return error;
 }
 
 int
@@ -450,7 +450,7 @@ xfs_attr_set(
 	XFS_STATS_INC(xs_attr_set);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+		return EIO;
 
 	error = xfs_attr_name_to_xname(&xname, name);
 	if (error)
@@ -524,7 +524,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
-		return(error);
+		return error;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -574,14 +574,14 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	return(error);
+	return error;
 
 out:
 	if (args.trans)
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return(error);
+	return error;
 }
 
 int
@@ -596,7 +596,7 @@ xfs_attr_remove(
 	XFS_STATS_INC(xs_attr_remove);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
+		return EIO;
 
 	error = xfs_attr_name_to_xname(&xname, name);
 	if (error)
@@ -630,27 +630,27 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 
 	retval = xfs_attr_shortform_lookup(args);
 	if ((args->flags & ATTR_REPLACE) && (retval == ENOATTR)) {
-		return(retval);
+		return retval;
 	} else if (retval == EEXIST) {
 		if (args->flags & ATTR_CREATE)
-			return(retval);
+			return retval;
 		retval = xfs_attr_shortform_remove(args);
 		ASSERT(retval == 0);
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
 	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
-		return(XFS_ERROR(ENOSPC));
+		return XFS_ERROR(ENOSPC);
 
 	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
 	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
 
 	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
 	if (!forkoff)
-		return(XFS_ERROR(ENOSPC));
+		return XFS_ERROR(ENOSPC);
 
 	xfs_attr_shortform_add(args, forkoff);
-	return(0);
+	return 0;
 }
 
 
@@ -726,7 +726,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
-			return(error);
+			return error;
 		}
 
 		/*
@@ -742,13 +742,13 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 */
 		error = xfs_trans_roll(&args->trans, dp);
 		if (error)
-			return (error);
+			return error;
 
 		/*
 		 * Fob the whole rest of the problem off on the Btree code.
 		 */
 		error = xfs_attr_node_addname(args);
-		return(error);
+		return error;
 	}
 
 	/*
@@ -757,7 +757,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	 */
 	error = xfs_trans_roll(&args->trans, dp);
 	if (error)
-		return (error);
+		return error;
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -768,7 +768,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_rmtval_set(args);
 		if (error)
-			return(error);
+			return error;
 	}
 
 	/*
@@ -784,7 +784,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		 */
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
-			return(error);
+			return error;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -797,7 +797,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 		if (args->rmtblkno) {
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
-				return(error);
+				return error;
 		}
 
 		/*
@@ -827,7 +827,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 				ASSERT(committed);
 				args->trans = NULL;
 				xfs_bmap_cancel(args->flist);
-				return(error);
+				return error;
 			}
 
 			/*
@@ -1107,7 +1107,7 @@ restart:
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_rmtval_set(args);
 		if (error)
-			return(error);
+			return error;
 	}
 
 	/*
@@ -1136,7 +1136,7 @@ restart:
 		if (args->rmtblkno) {
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
-				return(error);
+				return error;
 		}
 
 		/*
@@ -1211,8 +1211,8 @@ out:
 	if (state)
 		xfs_da_state_free(state);
 	if (error)
-		return(error);
-	return(retval);
+		return error;
+	return retval;
 }
 
 /*
@@ -1376,7 +1376,7 @@ xfs_attr_node_removename(xfs_da_args_t *args)
 
 out:
 	xfs_da_state_free(state);
-	return(error);
+	return error;
 }
 
 /*
@@ -1424,7 +1424,7 @@ xfs_attr_fillstate(xfs_da_state_t *state)
 		}
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -1455,7 +1455,7 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
 			if (error)
-				return(error);
+				return error;
 		} else {
 			blk->bp = NULL;
 		}
@@ -1474,13 +1474,13 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 						blk->blkno, blk->disk_blkno,
 						&blk->bp, XFS_ATTR_FORK);
 			if (error)
-				return(error);
+				return error;
 		} else {
 			blk->bp = NULL;
 		}
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -1536,5 +1536,5 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	}
 
 	xfs_da_state_free(state);
-	return(retval);
+	return retval;
 }
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 09480c5..b39e588 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -76,7 +76,7 @@ xfs_attr3_leaf_freextent(
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)tblkno, tblkcnt,
 				       &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error) {
-			return(error);
+			return error;
 		}
 		ASSERT(nmap == 1);
 		ASSERT(map.br_startblock != DELAYSTARTBLOCK);
@@ -102,14 +102,14 @@ xfs_attr3_leaf_freextent(
 			 */
 			error = xfs_trans_roll(trans, dp);
 			if (error)
-				return (error);
+				return error;
 		}
 
 		tblkno += map.br_blockcount;
 		tblkcnt -= map.br_blockcount;
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -256,7 +256,7 @@ xfs_attr3_node_inactive(
 		error = xfs_da3_node_read(*trans, dp, child_fsb, -2, &child_bp,
 						XFS_ATTR_FORK);
 		if (error)
-			return(error);
+			return error;
 		if (child_bp) {
 						/* save for re-read later */
 			child_blkno = XFS_BUF_ADDR(child_bp);
@@ -414,7 +414,7 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
 	if (error) {
 		xfs_trans_cancel(trans, 0);
-		return(error);
+		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 
@@ -443,10 +443,10 @@ xfs_attr_inactive(xfs_inode_t *dp)
 	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	return(error);
+	return error;
 
 out:
 	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return(error);
+	return error;
 }
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index fe9587f..b9d9170 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -546,7 +546,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 		break;
 	}
 	if (i == end)
-		return(XFS_ERROR(ENOATTR));
+		return XFS_ERROR(ENOATTR);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
@@ -581,7 +581,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 
 	xfs_sbversion_add_attr2(mp, args->trans);
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -610,9 +610,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 			continue;
 		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
 			continue;
-		return(XFS_ERROR(EEXIST));
+		return XFS_ERROR(EEXIST);
 	}
-	return(XFS_ERROR(ENOATTR));
+	return XFS_ERROR(ENOATTR);
 }
 
 /*
@@ -639,18 +639,18 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			continue;
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = sfe->valuelen;
-			return(XFS_ERROR(EEXIST));
+			return XFS_ERROR(EEXIST);
 		}
 		if (args->valuelen < sfe->valuelen) {
 			args->valuelen = sfe->valuelen;
-			return(XFS_ERROR(ERANGE));
+			return XFS_ERROR(ERANGE);
 		}
 		args->valuelen = sfe->valuelen;
 		memcpy(args->value, &sfe->nameval[args->namelen],
 						    args->valuelen);
-		return(XFS_ERROR(EEXIST));
+		return XFS_ERROR(EEXIST);
 	}
-	return(XFS_ERROR(ENOATTR));
+	return XFS_ERROR(ENOATTR);
 }
 
 /*
@@ -739,7 +739,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 
 out:
 	kmem_free(tmpbuffer);
-	return(error);
+	return error;
 }
 
 /*
@@ -767,12 +767,12 @@ xfs_attr_shortform_allfit(
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
 			continue;		/* don't copy partial entries */
 		if (!(entry->flags & XFS_ATTR_LOCAL))
-			return(0);
+			return 0;
 		name_loc = xfs_attr3_leaf_name_local(leaf, i);
 		if (name_loc->namelen >= XFS_ATTR_SF_ENTSIZE_MAX)
-			return(0);
+			return 0;
 		if (be16_to_cpu(name_loc->valuelen) >= XFS_ATTR_SF_ENTSIZE_MAX)
-			return(0);
+			return 0;
 		bytes += sizeof(struct xfs_attr_sf_entry) - 1
 				+ name_loc->namelen
 				+ be16_to_cpu(name_loc->valuelen);
@@ -1014,10 +1014,10 @@ xfs_attr3_leaf_split(
 	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);
 	error = xfs_da_grow_inode(state->args, &blkno);
 	if (error)
-		return(error);
+		return error;
 	error = xfs_attr3_leaf_create(state->args, blkno, &newblk->bp);
 	if (error)
-		return(error);
+		return error;
 	newblk->blkno = blkno;
 	newblk->magic = XFS_ATTR_LEAF_MAGIC;
 
@@ -1028,7 +1028,7 @@ xfs_attr3_leaf_split(
 	xfs_attr3_leaf_rebalance(state, oldblk, newblk);
 	error = xfs_da3_blk_link(state, oldblk, newblk);
 	if (error)
-		return(error);
+		return error;
 
 	/*
 	 * Save info on "old" attribute for "atomic rename" ops, leaf_add()
@@ -1050,7 +1050,7 @@ xfs_attr3_leaf_split(
 	 */
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
-	return(error);
+	return error;
 }
 
 /*
@@ -1701,7 +1701,7 @@ xfs_attr3_leaf_toosmall(
 		ichdr.usedbytes;
 	if (bytes > (state->blocksize >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -1720,7 +1720,7 @@ xfs_attr3_leaf_toosmall(
 		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 		if (error)
-			return(error);
+			return error;
 		if (retval) {
 			*action = 0;
 		} else {
@@ -1749,7 +1749,7 @@ xfs_attr3_leaf_toosmall(
 		error = xfs_attr3_leaf_read(state->args->trans, state->args->dp,
 					blkno, -1, &bp);
 		if (error)
-			return(error);
+			return error;
 
 		xfs_attr3_leaf_hdr_from_disk(&ichdr2, bp->b_addr);
 
@@ -1765,7 +1765,7 @@ xfs_attr3_leaf_toosmall(
 	}
 	if (i >= 2) {
 		*action = 0;
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -1781,13 +1781,13 @@ xfs_attr3_leaf_toosmall(
 						 0, &retval);
 	}
 	if (error)
-		return(error);
+		return error;
 	if (retval) {
 		*action = 0;
 	} else {
 		*action = 1;
 	}
-	return(0);
+	return 0;
 }
 
 /*
@@ -2486,7 +2486,7 @@ xfs_attr3_leaf_clearflag(
 	 */
 	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
-		return(error);
+		return error;
 
 	leaf = bp->b_addr;
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
@@ -2553,7 +2553,7 @@ xfs_attr3_leaf_setflag(
 	 */
 	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
 	if (error)
-		return(error);
+		return error;
 
 	leaf = bp->b_addr;
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 01db96f..3e9a65a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -52,7 +52,7 @@ xfs_attr_shortform_compare(const void *a, const void *b)
 	if (sa->hash < sb->hash) {
 		return(-1);
 	} else if (sa->hash > sb->hash) {
-		return(1);
+		return 1;
 	} else {
 		return(sa->entno - sb->entno);
 	}
@@ -86,7 +86,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
-		return(0);
+		return 0;
 	cursor = context->cursor;
 	ASSERT(cursor != NULL);
 
@@ -124,7 +124,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 			sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
 		}
 		trace_xfs_attr_list_sf_all(context);
-		return(0);
+		return 0;
 	}
 
 	/* do no more for a search callback */
@@ -188,7 +188,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	}
 	if (i == nsbuf) {
 		kmem_free(sbuf);
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -213,7 +213,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	}
 
 	kmem_free(sbuf);
-	return(0);
+	return 0;
 }
 
 STATIC int
@@ -244,7 +244,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 		error = xfs_da3_node_read(NULL, dp, cursor->blkno, -1,
 					      &bp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != EFSCORRUPTED))
-			return(error);
+			return error;
 		if (bp) {
 			struct xfs_attr_leaf_entry *entries;
 
@@ -295,7 +295,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 						      cursor->blkno, -1, &bp,
 						      XFS_ATTR_FORK);
 			if (error)
-				return(error);
+				return error;
 			node = bp->b_addr;
 			magic = be16_to_cpu(node->hdr.info.magic);
 			if (magic == XFS_ATTR_LEAF_MAGIC ||
@@ -614,7 +614,7 @@ xfs_attr_list(
 	 * Validate the cursor.
 	 */
 	if (cursor->pad1 || cursor->pad2)
-		return(XFS_ERROR(EINVAL));
+		return XFS_ERROR(EINVAL);
 	if ((cursor->initted == 0) &&
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return XFS_ERROR(EINVAL);
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 6e37823..44a57c8 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -448,7 +448,7 @@ xfs_attr_rmtval_set(
 			ASSERT(committed);
 			args->trans = NULL;
 			xfs_bmap_cancel(args->flist);
-			return(error);
+			return error;
 		}
 
 		/*
@@ -469,7 +469,7 @@ xfs_attr_rmtval_set(
 		 */
 		error = xfs_trans_roll(&args->trans, dp);
 		if (error)
-			return (error);
+			return error;
 	}
 
 	/*
@@ -494,7 +494,7 @@ xfs_attr_rmtval_set(
 				       blkcnt, &map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
 		if (error)
-			return(error);
+			return error;
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
@@ -559,7 +559,7 @@ xfs_attr_rmtval_remove(
 		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, &map, &nmap, XFS_BMAPI_ATTRFORK);
 		if (error)
-			return(error);
+			return error;
 		ASSERT(nmap == 1);
 		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 		       (map.br_startblock != HOLESTARTBLOCK));
@@ -618,7 +618,7 @@ xfs_attr_rmtval_remove(
 		 */
 		error = xfs_trans_roll(&args->trans, args->dp);
 		if (error)
-			return (error);
+			return error;
 	}
-	return(0);
+	return 0;
 }
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 6cc5f67..e0588bd 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -315,7 +315,7 @@ xfs_da3_node_create(
 
 	error = xfs_da_get_buf(tp, dp, blkno, -1, &bp, whichfork);
 	if (error)
-		return(error);
+		return error;
 	bp->b_ops = &xfs_da3_node_buf_ops;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	node = bp->b_addr;
@@ -337,7 +337,7 @@ xfs_da3_node_create(
 		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
 
 	*bpp = bp;
-	return(0);
+	return 0;
 }
 
 /*
@@ -386,7 +386,7 @@ xfs_da3_split(
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
 			if ((error != 0) && (error != ENOSPC)) {
-				return(error);	/* GROT: attr is inconsistent */
+				return error;	/* GROT: attr is inconsistent */
 			}
 			if (!error) {
 				addblk = newblk;
@@ -408,7 +408,7 @@ xfs_da3_split(
 							    &state->extrablk);
 			}
 			if (error)
-				return(error);	/* GROT: attr inconsistent */
+				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
@@ -422,7 +422,7 @@ xfs_da3_split(
 							 max - i, &action);
 			addblk->bp = NULL;
 			if (error)
-				return(error);	/* GROT: dir is inconsistent */
+				return error;	/* GROT: dir is inconsistent */
 			/*
 			 * Record the newly split block for the next time thru?
 			 */
@@ -439,7 +439,7 @@ xfs_da3_split(
 		xfs_da3_fixhashpath(state, &state->path);
 	}
 	if (!addblk)
-		return(0);
+		return 0;
 
 	/*
 	 * Split the root node.
@@ -449,7 +449,7 @@ xfs_da3_split(
 	error = xfs_da3_root_split(state, oldblk, addblk);
 	if (error) {
 		addblk->bp = NULL;
-		return(error);	/* GROT: dir is inconsistent */
+		return error;	/* GROT: dir is inconsistent */
 	}
 
 	/*
@@ -492,7 +492,7 @@ xfs_da3_split(
 		    sizeof(node->hdr.info)));
 	}
 	addblk->bp = NULL;
-	return(0);
+	return 0;
 }
 
 /*
@@ -670,18 +670,18 @@ xfs_da3_node_split(
 		 */
 		error = xfs_da_grow_inode(state->args, &blkno);
 		if (error)
-			return(error);	/* GROT: dir is inconsistent */
+			return error;	/* GROT: dir is inconsistent */
 
 		error = xfs_da3_node_create(state->args, blkno, treelevel,
 					   &newblk->bp, state->args->whichfork);
 		if (error)
-			return(error);	/* GROT: dir is inconsistent */
+			return error;	/* GROT: dir is inconsistent */
 		newblk->blkno = blkno;
 		newblk->magic = XFS_DA_NODE_MAGIC;
 		xfs_da3_node_rebalance(state, oldblk, newblk);
 		error = xfs_da3_blk_link(state, oldblk, newblk);
 		if (error)
-			return(error);
+			return error;
 		*result = 1;
 	} else {
 		*result = 0;
@@ -721,7 +721,7 @@ xfs_da3_node_split(
 		}
 	}
 
-	return(0);
+	return 0;
 }
 
 /*
@@ -963,9 +963,9 @@ xfs_da3_join(
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_toosmall(state, &action);
 			if (error)
-				return(error);
+				return error;
 			if (action == 0)
-				return(0);
+				return 0;
 			xfs_attr3_leaf_unbalance(state, drop_blk, save_blk);
 			break;
 		case XFS_DIR2_LEAFN_MAGIC:
@@ -985,7 +985,7 @@ xfs_da3_join(
 			xfs_da3_fixhashpath(state, &state->path);
 			error = xfs_da3_node_toosmall(state, &action);
 			if (error)
-				return(error);
+				return error;
 			if (action == 0)
 				return 0;
 			xfs_da3_node_unbalance(state, drop_blk, save_blk);
@@ -995,12 +995,12 @@ xfs_da3_join(
 		error = xfs_da3_blk_unlink(state, drop_blk, save_blk);
 		xfs_da_state_kill_altpath(state);
 		if (error)
-			return(error);
+			return error;
 		error = xfs_da_shrink_inode(state->args, drop_blk->blkno,
 							 drop_blk->bp);
 		drop_blk->bp = NULL;
 		if (error)
-			return(error);
+			return error;
 	}
 	/*
 	 * We joined all the way to the top.  If it turns out that
@@ -1010,7 +1010,7 @@ xfs_da3_join(
 	xfs_da3_node_remove(state, drop_blk);
 	xfs_da3_fixhashpath(state, &state->path);
 	error = xfs_da3_root_join(state, &state->path.blk[0]);
-	return(error);
+	return error;
 }
 
 #ifdef	DEBUG
@@ -1098,7 +1098,7 @@ xfs_da3_root_join(
 	}
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
-	return(error);
+	return error;
 }
 
 /*
@@ -1141,7 +1141,7 @@ xfs_da3_node_toosmall(
 	dp->d_ops->node_hdr_from_disk(&nodehdr, node);
 	if (nodehdr.count > (state->node_ents >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
-		return(0);	/* blk over 50%, don't try to join */
+		return 0;	/* blk over 50%, don't try to join */
 	}
 
 	/*
@@ -1160,13 +1160,13 @@ xfs_da3_node_toosmall(
 		error = xfs_da3_path_shift(state, &state->altpath, forward,
 						 0, &retval);
 		if (error)
-			return(error);
+			return error;
 		if (retval) {
 			*action = 0;
 		} else {
 			*action = 2;
 		}
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -1193,7 +1193,7 @@ xfs_da3_node_toosmall(
 		error = xfs_da3_node_read(state->args->trans, dp,
 					blkno, -1, &bp, state->args->whichfork);
 		if (error)
-			return(error);
+			return error;
 
 		node = bp->b_addr;
 		dp->d_ops->node_hdr_from_disk(&thdr, node);
@@ -1485,7 +1485,7 @@ xfs_da3_node_lookup_int(
 		if (error) {
 			blk->blkno = 0;
 			state->path.active--;
-			return(error);
+			return error;
 		}
 		curr = blk->bp->b_addr;
 		blk->magic = be16_to_cpu(curr->magic);
@@ -1585,7 +1585,7 @@ xfs_da3_node_lookup_int(
 			error = xfs_da3_path_shift(state, &state->path, 1, 1,
 							 &retval);
 			if (error)
-				return(error);
+				return error;
 			if (retval == 0) {
 				continue;
 			} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
@@ -1596,7 +1596,7 @@ xfs_da3_node_lookup_int(
 		break;
 	}
 	*result = retval;
-	return(0);
+	return 0;
 }
 
 /*========================================================================
@@ -1691,7 +1691,7 @@ xfs_da3_blk_link(
 						be32_to_cpu(old_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
-				return(error);
+				return error;
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == old_info->magic);
@@ -1712,7 +1712,7 @@ xfs_da3_blk_link(
 						be32_to_cpu(old_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
-				return(error);
+				return error;
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == old_info->magic);
@@ -1725,7 +1725,7 @@ xfs_da3_blk_link(
 
 	xfs_trans_log_buf(args->trans, old_blk->bp, 0, sizeof(*tmp_info) - 1);
 	xfs_trans_log_buf(args->trans, new_blk->bp, 0, sizeof(*tmp_info) - 1);
-	return(0);
+	return 0;
 }
 
 /*
@@ -1771,7 +1771,7 @@ xfs_da3_blk_unlink(
 						be32_to_cpu(drop_info->back),
 						-1, &bp, args->whichfork);
 			if (error)
-				return(error);
+				return error;
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
@@ -1788,7 +1788,7 @@ xfs_da3_blk_unlink(
 						be32_to_cpu(drop_info->forw),
 						-1, &bp, args->whichfork);
 			if (error)
-				return(error);
+				return error;
 			ASSERT(bp != NULL);
 			tmp_info = bp->b_addr;
 			ASSERT(tmp_info->magic == save_info->magic);
@@ -1800,7 +1800,7 @@ xfs_da3_blk_unlink(
 	}
 
 	xfs_trans_log_buf(args->trans, save_blk->bp, 0, sizeof(*save_info) - 1);
-	return(0);
+	return 0;
 }
 
 /*
@@ -1860,7 +1860,7 @@ xfs_da3_path_shift(
 	if (level < 0) {
 		*result = XFS_ERROR(ENOENT);	/* we're out of our tree */
 		ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
-		return(0);
+		return 0;
 	}
 
 	/*
@@ -1882,7 +1882,7 @@ xfs_da3_path_shift(
 		error = xfs_da3_node_read(args->trans, dp, blkno, -1,
 					&blk->bp, args->whichfork);
 		if (error)
-			return(error);
+			return error;
 		info = blk->bp->b_addr;
 		ASSERT(info->magic == cpu_to_be16(XFS_DA_NODE_MAGIC) ||
 		       info->magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 868b19f..53f6610 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -327,7 +327,7 @@ xfs_qm_dqalloc(
 	 */
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
-		return (ESRCH);
+		return ESRCH;
 	}
 
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
@@ -400,7 +400,7 @@ xfs_qm_dqalloc(
       error0:
 	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 
-	return (error);
+	return error;
 }
 
 STATIC int
@@ -547,7 +547,7 @@ xfs_qm_dqtobp(
 	*O_bpp = bp;
 	*O_ddpp = bp->b_addr + dqp->q_bufoffset;
 
-	return (0);
+	return 0;
 }
 
 
@@ -715,7 +715,7 @@ xfs_qm_dqget(
 	if ((! XFS_IS_UQUOTA_ON(mp) && type == XFS_DQ_USER) ||
 	    (! XFS_IS_PQUOTA_ON(mp) && type == XFS_DQ_PROJ) ||
 	    (! XFS_IS_GQUOTA_ON(mp) && type == XFS_DQ_GROUP)) {
-		return (ESRCH);
+		return ESRCH;
 	}
 
 #ifdef DEBUG
@@ -723,7 +723,7 @@ xfs_qm_dqget(
 		if ((xfs_dqerror_target == mp->m_ddev_targp) &&
 		    (xfs_dqreq_num++ % xfs_dqerror_mod) == 0) {
 			xfs_debug(mp, "Returning error in dqget");
-			return (EIO);
+			return EIO;
 		}
 	}
 
@@ -829,7 +829,7 @@ restart:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);
 	*O_dqpp = dqp;
-	return (0);
+	return 0;
 }
 
 
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 73514c0..5515f38 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -1693,7 +1693,7 @@ xfs_iext_idx_to_irec(
 	}
 	*idxp = page_idx;
 	*erp_idxp = erp_idx;
-	return(erp);
+	return erp;
 }
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bce53ac..ae82df0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2944,7 +2944,7 @@ xlog_recover_quotaoff_pass1(
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
 		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
 
-	return (0);
+	return 0;
 }
 
 /*
@@ -2969,7 +2969,7 @@ xlog_recover_dquot_pass2(
 	 * Filesystems are required to send in quota flags at mount time.
 	 */
 	if (mp->m_qflags == 0)
-		return (0);
+		return 0;
 
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
@@ -2988,7 +2988,7 @@ xlog_recover_dquot_pass2(
 	type = recddq->d_flags & (XFS_DQ_USER | XFS_DQ_PROJ | XFS_DQ_GROUP);
 	ASSERT(type);
 	if (log->l_quotaoffs_flag & type)
-		return (0);
+		return 0;
 
 	/*
 	 * At this point we know that quota was _not_ turned off.
@@ -3559,7 +3559,7 @@ xlog_recover_process_data(
 
 	/* check the log format matches our own - else we can't recover */
 	if (xlog_header_check_recover(log->l_mp, rhead))
-		return (XFS_ERROR(EIO));
+		return XFS_ERROR(EIO);
 
 	while ((dp < lp) && num_logops) {
 		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
@@ -3570,7 +3570,7 @@ xlog_recover_process_data(
 			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 					__func__, ohead->oh_clientid);
 			ASSERT(0);
-			return (XFS_ERROR(EIO));
+			return XFS_ERROR(EIO);
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
@@ -3584,7 +3584,7 @@ xlog_recover_process_data(
 				xfs_warn(log->l_mp, "%s: bad length 0x%x",
 					__func__, be32_to_cpu(ohead->oh_len));
 				WARN_ON(1);
-				return (XFS_ERROR(EIO));
+				return XFS_ERROR(EIO);
 			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
@@ -4387,7 +4387,7 @@ xlog_do_recover(
 	 * If IO errors happened during recovery, bail out.
 	 */
 	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
-		return (EIO);
+		return EIO;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 348e4d2..273ab51 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1634,7 +1634,7 @@ xfs_qm_quotacheck(
 		}
 	} else
 		xfs_notice(mp, "Quotacheck: Done.");
-	return (error);
+	return error;
 }
 
 /*
@@ -2066,7 +2066,7 @@ xfs_qm_vop_chown_reserve(
 				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
-	return (0);
+	return 0;
 }
 
 int
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 3daf5ea..8b0edbd 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -94,7 +94,7 @@ xfs_qm_scall_quotaoff(
 
 		/* XXX what to do if error ? Revert back to old vals incore ? */
 		error = xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS);
-		return (error);
+		return error;
 	}
 
 	dqtype = 0;
@@ -198,7 +198,7 @@ xfs_qm_scall_quotaoff(
 	if (mp->m_qflags == 0) {
 		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
-		return (0);
+		return 0;
 	}
 
 	/*
@@ -375,7 +375,7 @@ xfs_qm_scall_quotaon(
 	sbflags |= XFS_SB_QFLAGS;
 
 	if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
-		return (error);
+		return error;
 	/*
 	 * If we aren't trying to switch on quota enforcement, we are done.
 	 */
@@ -386,7 +386,7 @@ xfs_qm_scall_quotaon(
 	     ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) !=
 	     (mp->m_qflags & XFS_GQUOTA_ACCT)) ||
 	    (flags & XFS_ALL_QUOTA_ENFD) == 0)
-		return (0);
+		return 0;
 
 	if (! XFS_IS_QUOTA_RUNNING(mp))
 		return XFS_ERROR(ESRCH);
@@ -398,7 +398,7 @@ xfs_qm_scall_quotaon(
 	mp->m_qflags |= (flags & XFS_ALL_QUOTA_ENFD);
 	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
 
-	return (0);
+	return 0;
 }
 
 
@@ -425,7 +425,7 @@ xfs_qm_scall_getqstat(
 	if (!xfs_sb_version_hasquota(&mp->m_sb)) {
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
-		return (0);
+		return 0;
 	}
 
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -513,7 +513,7 @@ xfs_qm_scall_getqstatv(
 		out->qs_uquota.qfs_ino = NULLFSINO;
 		out->qs_gquota.qfs_ino = NULLFSINO;
 		out->qs_pquota.qfs_ino = NULLFSINO;
-		return (0);
+		return 0;
 	}
 
 	out->qs_flags = (__uint16_t) xfs_qm_export_flags(mp->m_qflags &
@@ -757,7 +757,7 @@ xfs_qm_log_quotaoff_end(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_qm_equotaoff, 0, 0);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return (error);
+		return error;
 	}
 
 	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
@@ -771,7 +771,7 @@ xfs_qm_log_quotaoff_end(
 	 */
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
-	return (error);
+	return error;
 }
 
 
@@ -821,7 +821,7 @@ error0:
 		spin_unlock(&mp->m_sb_lock);
 	}
 	*qoffstartp = qoffi;
-	return (error);
+	return error;
 }
 
 
@@ -952,7 +952,7 @@ xfs_qm_export_flags(
 		uflags |= FS_QUOTA_GDQ_ENFD;
 	if (flags & XFS_PQUOTA_ENFD)
 		uflags |= FS_QUOTA_PDQ_ENFD;
-	return (uflags);
+	return uflags;
 }
 
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 54a5732..f13452c 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -190,7 +190,7 @@ xfs_trans_reserve(
 					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-			return (XFS_ERROR(ENOSPC));
+			return XFS_ERROR(ENOSPC);
 		}
 		tp->t_blk_res += blocks;
 	}
@@ -1024,7 +1024,7 @@ xfs_trans_roll(
 	 */
 	error = xfs_trans_commit(trans, 0);
 	if (error)
-		return (error);
+		return error;
 
 	trans = *tpp;
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index b8eef05..73106f2 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -166,7 +166,7 @@ xfs_trans_get_buf_map(
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_get_buf_recur(bip);
-		return (bp);
+		return bp;
 	}
 
 	bp = xfs_buf_get_map(target, map, nmaps, flags);
@@ -178,7 +178,7 @@ xfs_trans_get_buf_map(
 
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_fspriv);
-	return (bp);
+	return bp;
 }
 
 /*
@@ -218,7 +218,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 		ASSERT(atomic_read(&bip->bli_refcount) > 0);
 		bip->bli_recur++;
 		trace_xfs_trans_getsb_recur(bip);
-		return (bp);
+		return bp;
 	}
 
 	bp = xfs_getsb(mp, flags);
@@ -227,7 +227,7 @@ xfs_trans_getsb(xfs_trans_t	*tp,
 
 	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_getsb(bp->b_fspriv);
-	return (bp);
+	return bp;
 }
 
 #ifdef DEBUG

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
