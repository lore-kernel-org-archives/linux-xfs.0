Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AE307F73
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:48:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C2028F8037
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 10:48:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Zqi973DYHbmnaeTt for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 10:48:48 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5D6AB63C5FD4
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 12:48:47 -0500 (CDT)
Message-ID: <534EC282.7010905@sandeen.net>
Date: Wed, 16 Apr 2014 12:48:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs: Nuke XFS_ERROR macro
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

XFS_ERROR was designed long ago to trap return values,
but it's not runtime configurable, it's not consistently used,
and we can do the same thing today with systemtap, using
something like:

probe module("xfs").function("xfs_*").return { if (@defined($return) && $return == VALUE) { ... } }

Just nuke XFS_ERROR and associated bits.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 75df77d..05ab4ed 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -308,14 +308,14 @@ xfs_map_blocks(
 	int			nimaps = 1;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
 		if (nonblocking)
-			return -XFS_ERROR(EAGAIN);
+			return -EAGAIN;
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
 	}
 
@@ -332,14 +332,14 @@ xfs_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
-		return -XFS_ERROR(error);
+		return -error;
 
 	if (type == XFS_IO_DELALLOC &&
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
 		error = xfs_iomap_write_allocate(ip, offset, imap);
 		if (!error)
 			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
-		return -XFS_ERROR(error);
+		return -error;
 	}
 
 #ifdef DEBUG
@@ -1216,7 +1216,7 @@ __xfs_get_blocks(
 	int			new = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	offset = (xfs_off_t)iblock << inode->i_blkbits;
 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 95de302..ab0218b 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -538,7 +538,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	 * Decide on what work routines to call based on the inode size.
 	 */
 	if (!xfs_inode_hasattr(dp)) {
-		error = XFS_ERROR(ENOATTR);
+		error = ENOATTR;
 		goto out;
 	}
 	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
@@ -605,7 +605,7 @@ xfs_attr_remove(
 	xfs_ilock(dp, XFS_ILOCK_SHARED);
 	if (!xfs_inode_hasattr(dp)) {
 		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return XFS_ERROR(ENOATTR);
+		return ENOATTR;
 	}
 	xfs_iunlock(dp, XFS_ILOCK_SHARED);
 
@@ -640,14 +640,14 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
 	    args->valuelen >= XFS_ATTR_SF_ENTSIZE_MAX)
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 
 	newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
 	newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
 
 	forkoff = xfs_attr_shortform_bytesfit(args->dp, newsize);
 	if (!forkoff)
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 
 	xfs_attr_shortform_add(args, forkoff);
 	return 0;
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index b39e588..f19d1ef 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -227,7 +227,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	node = bp->b_addr;
@@ -277,7 +277,7 @@ xfs_attr3_node_inactive(
 							child_bp);
 				break;
 			default:
-				error = XFS_ERROR(EIO);
+				error = EIO;
 				xfs_trans_brelse(*trans, child_bp);
 				break;
 			}
@@ -360,7 +360,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
-		error = XFS_ERROR(EIO);
+		error = EIO;
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index b9d9170..5e21b67 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -546,7 +546,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 		break;
 	}
 	if (i == end)
-		return XFS_ERROR(ENOATTR);
+		return ENOATTR;
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
@@ -610,9 +610,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 			continue;
 		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
 			continue;
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	}
-	return XFS_ERROR(ENOATTR);
+	return ENOATTR;
 }
 
 /*
@@ -639,18 +639,18 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			continue;
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = sfe->valuelen;
-			return XFS_ERROR(EEXIST);
+			return EEXIST;
 		}
 		if (args->valuelen < sfe->valuelen) {
 			args->valuelen = sfe->valuelen;
-			return XFS_ERROR(ERANGE);
+			return ERANGE;
 		}
 		args->valuelen = sfe->valuelen;
 		memcpy(args->value, &sfe->nameval[args->namelen],
 						    args->valuelen);
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	}
-	return XFS_ERROR(ENOATTR);
+	return ENOATTR;
 }
 
 /*
@@ -1106,7 +1106,7 @@ xfs_attr3_leaf_add(
 	 * no good and we should just give up.
 	 */
 	if (!ichdr.holes && sum < entsize)
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 
 	/*
 	 * Compact the entries to coalesce free space.
@@ -2127,7 +2127,7 @@ xfs_attr3_leaf_lookup_int(
 	}
 	if (probe == ichdr.count || be32_to_cpu(entry->hashval) != hashval) {
 		args->index = probe;
-		return XFS_ERROR(ENOATTR);
+		return ENOATTR;
 	}
 
 	/*
@@ -2156,7 +2156,7 @@ xfs_attr3_leaf_lookup_int(
 			if (!xfs_attr_namesp_match(args->flags, entry->flags))
 				continue;
 			args->index = probe;
-			return XFS_ERROR(EEXIST);
+			return EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
 			if (name_rmt->namelen != args->namelen)
@@ -2172,11 +2172,11 @@ xfs_attr3_leaf_lookup_int(
 			args->rmtblkcnt = xfs_attr3_rmt_blocks(
 							args->dp->i_mount,
 							args->valuelen);
-			return XFS_ERROR(EEXIST);
+			return EEXIST;
 		}
 	}
 	args->index = probe;
-	return XFS_ERROR(ENOATTR);
+	return ENOATTR;
 }
 
 /*
@@ -2212,7 +2212,7 @@ xfs_attr3_leaf_getvalue(
 		}
 		if (args->valuelen < valuelen) {
 			args->valuelen = valuelen;
-			return XFS_ERROR(ERANGE);
+			return ERANGE;
 		}
 		args->valuelen = valuelen;
 		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
@@ -2230,7 +2230,7 @@ xfs_attr3_leaf_getvalue(
 		}
 		if (args->valuelen < valuelen) {
 			args->valuelen = valuelen;
-			return XFS_ERROR(ERANGE);
+			return ERANGE;
 		}
 		args->valuelen = valuelen;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 3e9a65a..e38425a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -150,7 +150,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe);
 			kmem_free(sbuf);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 
 		sbp->entno = i;
@@ -308,7 +308,7 @@ xfs_attr_node_list(xfs_attr_list_context_t *context)
 						     context->dp->i_mount,
 						     node);
 				xfs_trans_brelse(NULL, bp);
-				return XFS_ERROR(EFSCORRUPTED);
+				return EFSCORRUPTED;
 			}
 
 			dp->d_ops->node_hdr_from_disk(&nodehdr, node);
@@ -494,11 +494,11 @@ xfs_attr_leaf_list(xfs_attr_list_context_t *context)
 	context->cursor->blkno = 0;
 	error = xfs_attr3_leaf_read(NULL, context->dp, 0, -1, &bp);
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	error = xfs_attr3_leaf_list_int(bp, context);
 	xfs_trans_brelse(NULL, bp);
-	return XFS_ERROR(error);
+	return error;
 }
 
 int
@@ -614,16 +614,16 @@ xfs_attr_list(
 	 * Validate the cursor.
 	 */
 	if (cursor->pad1 || cursor->pad2)
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	if ((cursor->initted == 0) &&
 	    (cursor->hashval || cursor->blkno || cursor->offset))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 
 	/*
 	 * Check for a properly aligned buffer.
 	 */
 	if (((long)buffer) & (sizeof(int)-1))
-		return XFS_ERROR(EFAULT);
+		return EFAULT;
 	if (flags & ATTR_KERNOVAL)
 		bufsize = 0;
 
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 5b6092e..cd72b90 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1034,7 +1034,7 @@ xfs_bmap_add_attrfork_btree(
 			goto error0;
 		if (stat == 0) {
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		}
 		*firstblock = cur->bc_private.b.firstblock;
 		cur->bc_private.b.allocated = 0;
@@ -1192,7 +1192,7 @@ xfs_bmap_add_attrfork(
 		break;
 	default:
 		ASSERT(0);
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto trans_cancel;
 	}
 
@@ -1399,7 +1399,7 @@ xfs_bmap_read_extents(
 	return 0;
 error0:
 	xfs_trans_brelse(tp, bp);
-	return XFS_ERROR(EFSCORRUPTED);
+	return EFSCORRUPTED;
 }
 
 
@@ -1576,7 +1576,7 @@ xfs_bmap_last_before(
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
-	       return XFS_ERROR(EIO);
+	       return EIO;
 	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
 		*last_block = 0;
 		return 0;
@@ -1691,7 +1691,7 @@ xfs_bmap_last_offset(
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-	       return XFS_ERROR(EIO);
+	       return EIO;
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -3324,7 +3324,7 @@ xfs_bmap_extsize_align(
 		if (orig_off < align_off ||
 		    orig_end > align_off + align_alen ||
 		    align_alen - temp < orig_alen)
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		/*
 		 * Try to fix it by moving the start up.
 		 */
@@ -3349,7 +3349,7 @@ xfs_bmap_extsize_align(
 		 * Result doesn't cover the request, fail it.
 		 */
 		if (orig_off < align_off || orig_end > align_off + align_alen)
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 	} else {
 		ASSERT(orig_off >= align_off);
 		ASSERT(orig_end <= align_off + align_alen);
@@ -4020,11 +4020,11 @@ xfs_bmapi_read(
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_read", XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	XFS_STATS_INC(xs_blk_mapr);
 
@@ -4215,11 +4215,11 @@ xfs_bmapi_delay(
 	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_delay", XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	XFS_STATS_INC(xs_blk_mapw);
 
@@ -4509,11 +4509,11 @@ xfs_bmapi_write(
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmapi_write", XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
@@ -4930,7 +4930,7 @@ xfs_bmap_del_extent(
 					xfs_bmbt_set_blockcount(ep,
 						got.br_blockcount);
 					flags = 0;
-					error = XFS_ERROR(ENOSPC);
+					error = ENOSPC;
 					goto done;
 				}
 				XFS_WANT_CORRUPTED_GOTO(i == 1, done);
@@ -5048,11 +5048,11 @@ xfs_bunmapi(
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_bunmapi", XFS_ERRLEVEL_LOW,
 				 ip->i_mount);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	mp = ip->i_mount;
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(len > 0);
@@ -5297,7 +5297,7 @@ xfs_bunmapi(
 		    del.br_startoff > got.br_startoff &&
 		    del.br_startoff + del.br_blockcount <
 		    got.br_startoff + got.br_blockcount) {
-			error = XFS_ERROR(ENOSPC);
+			error = ENOSPC;
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
@@ -5420,11 +5420,11 @@ xfs_bmap_shift_extents(
 	     mp, XFS_ERRTAG_BMAPIFORMAT, XFS_RANDOM_BMAPIFORMAT))) {
 		XFS_ERROR_REPORT("xfs_bmap_shift_extents",
 				 XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	ASSERT(current_ext != NULL);
 
@@ -5483,14 +5483,14 @@ xfs_bmap_shift_extents(
 						*current_ext - 1), &left);
 
 			if (startoff < left.br_startoff + left.br_blockcount)
-				error = XFS_ERROR(EINVAL);
+				error = EINVAL;
 		} else if (offset_shift_fsb > got.br_startoff) {
 			/*
 			 * When first extent is shifted, offset_shift_fsb
 			 * should be less than the stating offset of
 			 * the first extent.
 			 */
-			error = XFS_ERROR(EINVAL);
+			error = EINVAL;
 		}
 
 		if (error)
diff --git a/fs/xfs/xfs_bmap_btree.c b/fs/xfs/xfs_bmap_btree.c
index 818d546..116a5da 100644
--- a/fs/xfs/xfs_bmap_btree.c
+++ b/fs/xfs/xfs_bmap_btree.c
@@ -555,7 +555,7 @@ xfs_bmbt_alloc_block(
 	args.minlen = args.maxlen = args.prod = 1;
 	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
 	if (!args.wasdel && xfs_trans_get_block_res(args.tp) == 0) {
-		error = XFS_ERROR(ENOSPC);
+		error = ENOSPC;
 		goto error0;
 	}
 	error = xfs_alloc_vextent(&args);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 01f6a64..039192b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -408,7 +408,7 @@ xfs_bmap_count_tree(
 			xfs_trans_brelse(tp, bp);
 			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
 					 XFS_ERRLEVEL_LOW, mp);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		xfs_trans_brelse(tp, bp);
 	} else {
@@ -475,7 +475,7 @@ xfs_bmap_count_blocks(
 	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
 		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
 				 mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	return 0;
@@ -567,13 +567,13 @@ xfs_getbmap(
 			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
 			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
 			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
-				return XFS_ERROR(EINVAL);
+				return EINVAL;
 		} else if (unlikely(
 			   ip->i_d.di_aformat != 0 &&
 			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
 			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
 					 ip->i_mount);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 
 		prealloced = 0;
@@ -582,7 +582,7 @@ xfs_getbmap(
 		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
 		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 
 		if (xfs_get_extsz_hint(ip) ||
 		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
@@ -602,20 +602,20 @@ xfs_getbmap(
 		bmv->bmv_entries = 0;
 		return 0;
 	} else if (bmv->bmv_length < 0) {
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	nex = bmv->bmv_count - 1;
 	if (nex <= 0)
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	bmvend = bmv->bmv_offset + bmv->bmv_length;
 
 
 	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 	out = kmem_zalloc_large(bmv->bmv_count * sizeof(struct getbmapx), 0);
 	if (!out)
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	if (whichfork == XFS_DATA_FORK) {
@@ -998,14 +998,14 @@ xfs_alloc_file_space(
 	trace_xfs_alloc_file_space(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		return error;
 
 	if (len <= 0)
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
@@ -1108,7 +1108,7 @@ xfs_alloc_file_space(
 		allocated_fsb = imapp->br_blockcount;
 
 		if (nimaps == 0) {
-			error = XFS_ERROR(ENOSPC);
+			error = ENOSPC;
 			break;
 		}
 
@@ -1169,7 +1169,7 @@ xfs_zero_remaining_bytes(
 					mp->m_rtdev_targp : mp->m_ddev_targp,
 				  BTOBB(mp->m_sb.sb_blocksize), 0);
 	if (!bp)
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 
 	xfs_buf_unlock(bp);
 
@@ -1201,7 +1201,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 
 		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			break;
 		}
 		xfs_buf_iorequest(bp);
@@ -1219,7 +1219,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_WRITE(bp);
 
 		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			break;
 		}
 		xfs_buf_iorequest(bp);
@@ -1670,7 +1670,7 @@ xfs_swap_extents(
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
-		error = XFS_ERROR(ENOMEM);
+		error = ENOMEM;
 		goto out;
 	}
 
@@ -1685,13 +1685,13 @@ xfs_swap_extents(
 
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_unlock;
 	}
 
 	/* Verify both files are either real-time or non-realtime */
 	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_unlock;
 	}
 
@@ -1702,7 +1702,7 @@ xfs_swap_extents(
 
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_unlock;
 	}
 
@@ -1710,7 +1710,7 @@ xfs_swap_extents(
 	if (sxp->sx_offset != 0 ||
 	    sxp->sx_length != ip->i_d.di_size ||
 	    sxp->sx_length != tip->i_d.di_size) {
-		error = XFS_ERROR(EFAULT);
+		error = EFAULT;
 		goto out_unlock;
 	}
 
@@ -1737,7 +1737,7 @@ xfs_swap_extents(
 	    (sbp->bs_ctime.tv_nsec != VFS_I(ip)->i_ctime.tv_nsec) ||
 	    (sbp->bs_mtime.tv_sec != VFS_I(ip)->i_mtime.tv_sec) ||
 	    (sbp->bs_mtime.tv_nsec != VFS_I(ip)->i_mtime.tv_nsec)) {
-		error = XFS_ERROR(EBUSY);
+		error = EBUSY;
 		goto out_unlock;
 	}
 
@@ -1748,7 +1748,7 @@ xfs_swap_extents(
 	 * until we have switched the extents.
 	 */
 	if (VN_MAPPED(VFS_I(ip))) {
-		error = XFS_ERROR(EBUSY);
+		error = EBUSY;
 		goto out_unlock;
 	}
 
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index e80d59f..1a890e0 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -90,7 +90,7 @@ xfs_btree_check_lblock(
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -138,7 +138,7 @@ xfs_btree_check_sblock(
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index e0588bd..e8e583f 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -1578,7 +1578,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		if (((retval == ENOENT) || (retval == ENOATTR)) &&
 		    (blk->hashval == args->hashval)) {
@@ -1590,7 +1590,7 @@ xfs_da3_node_lookup_int(
 				continue;
 			} else if (blk->magic == XFS_ATTR_LEAF_MAGIC) {
 				/* path_shift() gives ENOENT */
-				retval = XFS_ERROR(ENOATTR);
+				retval = ENOATTR;
 			}
 		}
 		break;
@@ -1858,7 +1858,7 @@ xfs_da3_path_shift(
 		}
 	}
 	if (level < 0) {
-		*result = XFS_ERROR(ENOENT);	/* we're out of our tree */
+		*result = ENOENT;	/* we're out of our tree */
 		ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 		return 0;
 	}
@@ -2067,7 +2067,7 @@ xfs_da_grow_inode_int(
 	if (got != count || mapp[0].br_startoff != *bno ||
 	    mapp[mapi - 1].br_startoff + mapp[mapi - 1].br_blockcount !=
 	    *bno + count) {
-		error = XFS_ERROR(ENOSPC);
+		error = ENOSPC;
 		goto out_free_map;
 	}
 
@@ -2165,7 +2165,7 @@ xfs_da3_swap_lastblock(
 	if (unlikely(lastoff == 0)) {
 		XFS_ERROR_REPORT("xfs_da_swap_lastblock(1)", XFS_ERRLEVEL_LOW,
 				 mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	/*
 	 * Read the last block in the btree space.
@@ -2216,7 +2216,7 @@ xfs_da3_swap_lastblock(
 		    sib_info->magic != dead_info->magic)) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(2)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		sib_info->forw = cpu_to_be32(dead_blkno);
@@ -2238,7 +2238,7 @@ xfs_da3_swap_lastblock(
 		       sib_info->magic != dead_info->magic)) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		sib_info->back = cpu_to_be32(dead_blkno);
@@ -2261,7 +2261,7 @@ xfs_da3_swap_lastblock(
 		if (level >= 0 && level != par_hdr.level + 1) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(4)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		level = par_hdr.level;
@@ -2274,7 +2274,7 @@ xfs_da3_swap_lastblock(
 		if (entno == par_hdr.count) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(5)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		par_blkno = be32_to_cpu(btree[entno].before);
@@ -2301,7 +2301,7 @@ xfs_da3_swap_lastblock(
 		if (unlikely(par_blkno == 0)) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(6)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		error = xfs_da3_node_read(tp, dp, par_blkno, -1, &par_buf, w);
@@ -2312,7 +2312,7 @@ xfs_da3_swap_lastblock(
 		if (par_hdr.level != level) {
 			XFS_ERROR_REPORT("xfs_da_swap_lastblock(7)",
 					 XFS_ERRLEVEL_LOW, mp);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			goto done;
 		}
 		btree = dp->d_ops->node_tree_p(par_node);
@@ -2508,7 +2508,7 @@ xfs_dabuf_map(
 	}
 
 	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
-		error = mappedbno == -2 ? -1 : XFS_ERROR(EFSCORRUPTED);
+		error = mappedbno == -2 ? -1 : EFSCORRUPTED;
 		if (unlikely(error == EFSCORRUPTED)) {
 			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 				int i;
@@ -2569,7 +2569,7 @@ xfs_da_get_buf(
 
 	bp = xfs_trans_get_buf_map(trans, dp->i_mount->m_ddev_targp,
 				    mapp, nmap, 0);
-	error = bp ? bp->b_error : XFS_ERROR(EIO);
+	error = bp ? bp->b_error : EIO;
 	if (error) {
 		xfs_trans_brelse(trans, bp);
 		goto out_free;
@@ -2661,7 +2661,7 @@ xfs_da_read_buf(
 			trace_xfs_da_btree_corrupt(bp, _RET_IP_);
 			XFS_CORRUPTION_ERROR("xfs_da_do_buf(2)",
 					     XFS_ERRLEVEL_LOW, mp, info);
-			error = XFS_ERROR(EFSCORRUPTED);
+			error = EFSCORRUPTED;
 			xfs_trans_brelse(trans, bp);
 			goto out_free;
 		}
diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
index fda4625..dd7d3c7 100644
--- a/fs/xfs/xfs_dir2.c
+++ b/fs/xfs/xfs_dir2.c
@@ -166,7 +166,7 @@ xfs_dir_ino_validate(
 		xfs_warn(mp, "Invalid inode number 0x%Lx",
 				(unsigned long long) ino);
 		XFS_ERROR_REPORT("xfs_dir_ino_validate", XFS_ERRLEVEL_LOW, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 4f6a38c..cedec22 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -394,7 +394,7 @@ xfs_dir2_block_addname(
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
 		xfs_trans_brelse(tp, bp);
 		if (!dup)
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		return 0;
 	}
 
@@ -404,7 +404,7 @@ xfs_dir2_block_addname(
 	if (!dup) {
 		/* Don't have a space reservation: return no-space.  */
 		if (args->total == 0)
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		/*
 		 * Convert to the next larger format.
 		 * Then add the new entry in that format.
@@ -648,7 +648,7 @@ xfs_dir2_block_lookup(
 	args->filetype = dp->d_ops->data_get_ftype(dep);
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(args->trans, bp);
-	return XFS_ERROR(error);
+	return error;
 }
 
 /*
@@ -704,7 +704,7 @@ xfs_dir2_block_lookup_int(
 		if (low > high) {
 			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 			xfs_trans_brelse(tp, bp);
-			return XFS_ERROR(ENOENT);
+			return ENOENT;
 		}
 	}
 	/*
@@ -752,7 +752,7 @@ xfs_dir2_block_lookup_int(
 	 * No match, release the buffer and return ENOENT.
 	 */
 	xfs_trans_brelse(tp, bp);
-	return XFS_ERROR(ENOENT);
+	return ENOENT;
 }
 
 /*
@@ -1090,7 +1090,7 @@ xfs_dir2_sf_to_block(
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
diff --git a/fs/xfs/xfs_dir2_leaf.c b/fs/xfs/xfs_dir2_leaf.c
index d36e97d..cedaece 100644
--- a/fs/xfs/xfs_dir2_leaf.c
+++ b/fs/xfs/xfs_dir2_leaf.c
@@ -729,7 +729,7 @@ xfs_dir2_leaf_addname(
 		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) ||
 							args->total == 0) {
 			xfs_trans_brelse(tp, lbp);
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		}
 		/*
 		 * Convert to node form.
@@ -753,7 +753,7 @@ xfs_dir2_leaf_addname(
 	 */
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK) {
 		xfs_trans_brelse(tp, lbp);
-		return use_block == -1 ? XFS_ERROR(ENOSPC) : 0;
+		return use_block == -1 ? ENOSPC : 0;
 	}
 	/*
 	 * If no allocations are allowed, return now before we've
@@ -761,7 +761,7 @@ xfs_dir2_leaf_addname(
 	 */
 	if (args->total == 0 && use_block == -1) {
 		xfs_trans_brelse(tp, lbp);
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 	}
 	/*
 	 * Need to compact the leaf entries, removing stale ones.
@@ -1194,7 +1194,7 @@ xfs_dir2_leaf_lookup(
 	error = xfs_dir_cilookup_result(args, dep->name, dep->namelen);
 	xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
-	return XFS_ERROR(error);
+	return error;
 }
 
 /*
@@ -1327,7 +1327,7 @@ xfs_dir2_leaf_lookup_int(
 	if (dbp)
 		xfs_trans_brelse(tp, dbp);
 	xfs_trans_brelse(tp, lbp);
-	return XFS_ERROR(ENOENT);
+	return ENOENT;
 }
 
 /*
diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index cb434d7..db20ecb 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -406,7 +406,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0)
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 
 	/*
 	 * If there are already the maximum number of leaf entries in
@@ -417,7 +417,7 @@ xfs_dir2_leafn_add(
 
 	if (leafhdr.count == dp->d_ops->leaf_max_ents(mp)) {
 		if (!leafhdr.stale)
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		compact = leafhdr.stale > 1;
 	} else
 		compact = 0;
@@ -626,7 +626,7 @@ xfs_dir2_leafn_lookup_for_addname(
 							XFS_ERRLEVEL_LOW, mp);
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
-				return XFS_ERROR(EFSCORRUPTED);
+				return EFSCORRUPTED;
 			}
 			curfdb = newfdb;
 			if (be16_to_cpu(bests[fi]) >= length)
@@ -657,7 +657,7 @@ out:
 	 * Return the index, that will be the insertion point.
 	 */
 	*indexp = index;
-	return XFS_ERROR(ENOENT);
+	return ENOENT;
 }
 
 /*
@@ -783,7 +783,7 @@ xfs_dir2_leafn_lookup_for_entry(
 			curbp->b_ops = &xfs_dir3_data_buf_ops;
 			xfs_trans_buf_set_type(tp, curbp, XFS_BLFT_DIR_DATA_BUF);
 			if (cmp == XFS_CMP_EXACT)
-				return XFS_ERROR(EEXIST);
+				return EEXIST;
 		}
 	}
 	ASSERT(index == leafhdr.count || (args->op_flags & XFS_DA_OP_OKNOENT));
@@ -806,7 +806,7 @@ xfs_dir2_leafn_lookup_for_entry(
 		state->extravalid = 0;
 	}
 	*indexp = index;
-	return XFS_ERROR(ENOENT);
+	return ENOENT;
 }
 
 /*
@@ -1811,7 +1811,7 @@ xfs_dir2_node_addname_int(
 		 * Not allowed to allocate, return failure.
 		 */
 		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 
 		/*
 		 * Allocate and initialize the new data block.
@@ -1871,7 +1871,7 @@ xfs_dir2_node_addname_int(
 				}
 				XFS_ERROR_REPORT("xfs_dir2_node_addname_int",
 						 XFS_ERRLEVEL_LOW, mp);
-				return XFS_ERROR(EFSCORRUPTED);
+				return EFSCORRUPTED;
 			}
 
 			/*
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index aead369..808aadd 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -96,7 +96,7 @@ xfs_dir2_sf_getdents(
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
@@ -679,7 +679,7 @@ xfs_readdir(
 	trace_xfs_readdir(dp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 	XFS_STATS_INC(xs_dir_getdents);
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 3725fb1..089bfd1 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -307,7 +307,7 @@ xfs_dir2_sf_addname(
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -350,7 +350,7 @@ xfs_dir2_sf_addname(
 		 * Just checking or no space reservation, it doesn't fit.
 		 */
 		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		/*
 		 * Convert to block form then add the name.
 		 */
@@ -743,7 +743,7 @@ xfs_dir2_sf_lookup(
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -756,7 +756,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = dp->i_ino;
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	}
 	/*
 	 * Special case for ..
@@ -766,7 +766,7 @@ xfs_dir2_sf_lookup(
 		args->inumber = dp->d_ops->sf_get_parent_ino(sfp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	}
 	/*
 	 * Loop over all the entries trying to match ours.
@@ -786,7 +786,7 @@ xfs_dir2_sf_lookup(
 			args->inumber = dp->d_ops->sf_get_ino(sfp, sfep);
 			args->filetype = dp->d_ops->sf_get_ftype(sfep);
 			if (cmp == XFS_CMP_EXACT)
-				return XFS_ERROR(EEXIST);
+				return EEXIST;
 			ci_sfep = sfep;
 		}
 	}
@@ -796,10 +796,10 @@ xfs_dir2_sf_lookup(
 	 * If a case-insensitive match was not found, return ENOENT.
 	 */
 	if (!ci_sfep)
-		return XFS_ERROR(ENOENT);
+		return ENOENT;
 	/* otherwise process the CI match as required by the caller */
 	error = xfs_dir_cilookup_result(args, ci_sfep->name, ci_sfep->namelen);
-	return XFS_ERROR(error);
+	return error;
 }
 
 /*
@@ -829,7 +829,7 @@ xfs_dir2_sf_removename(
 	 */
 	if (oldsize < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == oldsize);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -852,7 +852,7 @@ xfs_dir2_sf_removename(
 	 * Didn't find it.
 	 */
 	if (i == sfp->count)
-		return XFS_ERROR(ENOENT);
+		return ENOENT;
 	/*
 	 * Calculate sizes.
 	 */
@@ -919,7 +919,7 @@ xfs_dir2_sf_replace(
 	 */
 	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -995,7 +995,7 @@ xfs_dir2_sf_replace(
 			if (i8elevated)
 				xfs_dir2_sf_toino4(args);
 #endif
-			return XFS_ERROR(ENOENT);
+			return ENOENT;
 		}
 	}
 #if XFS_BIG_INUMS
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 4f11ef0..3fee16e 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -166,11 +166,11 @@ xfs_ioc_trim(
 	int			error, last_error = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (!blk_queue_discard(q))
-		return -XFS_ERROR(EOPNOTSUPP);
+		return -EOPNOTSUPP;
 	if (copy_from_user(&range, urange, sizeof(range)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
@@ -182,7 +182,7 @@ xfs_ioc_trim(
 	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
 	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)) ||
 	    range.len < mp->m_sb.sb_blocksize)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
@@ -206,7 +206,7 @@ xfs_ioc_trim(
 
 	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
 	if (copy_to_user(urange, &range, sizeof(range)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 53f6610..ff31d31 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -426,7 +426,7 @@ xfs_qm_dqrepair(
 
 	if (error) {
 		ASSERT(*bpp == NULL);
-		return XFS_ERROR(error);
+		return error;
 	}
 	(*bpp)->b_ops = &xfs_dquot_buf_ops;
 
@@ -442,7 +442,7 @@ xfs_qm_dqrepair(
 		if (error) {
 			/* repair failed, we're screwed */
 			xfs_trans_brelse(tp, *bpp);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 	}
 
@@ -539,7 +539,7 @@ xfs_qm_dqtobp(
 
 		if (error) {
 			ASSERT(bp == NULL);
-			return XFS_ERROR(error);
+			return error;
 		}
 	}
 
@@ -796,7 +796,7 @@ restart:
 		} else {
 			/* inode stays locked on return */
 			xfs_qm_dqdestroy(dqp);
-			return XFS_ERROR(ESRCH);
+			return ESRCH;
 		}
 	}
 
@@ -1003,7 +1003,7 @@ xfs_qm_dqflush(
 					     SHUTDOWN_CORRUPT_INCORE);
 		else
 			spin_unlock(&mp->m_ail->xa_lock);
-		error = XFS_ERROR(EIO);
+		error = EIO;
 		goto out_unlock;
 	}
 
@@ -1029,7 +1029,7 @@ xfs_qm_dqflush(
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/* This is the only portion of data that needs to persist */
@@ -1082,7 +1082,7 @@ xfs_qm_dqflush(
 
 out_unlock:
 	xfs_dqfunlock(dqp);
-	return XFS_ERROR(EIO);
+	return EIO;
 }
 
 /*
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index edac5b0..14f98c2 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -27,29 +27,6 @@
 
 #ifdef DEBUG
 
-int	xfs_etrap[XFS_ERROR_NTRAP] = {
-	0,
-};
-
-int
-xfs_error_trap(int e)
-{
-	int i;
-
-	if (!e)
-		return 0;
-	for (i = 0; i < XFS_ERROR_NTRAP; i++) {
-		if (xfs_etrap[i] == 0)
-			break;
-		if (e != xfs_etrap[i])
-			continue;
-		xfs_notice(NULL, "%s: error %d", __func__, e);
-		BUG();
-		break;
-	}
-	return e;
-}
-
 int	xfs_etest[XFS_NUM_INJECT_ERROR];
 int64_t	xfs_etest_fsid[XFS_NUM_INJECT_ERROR];
 char *	xfs_etest_fsname[XFS_NUM_INJECT_ERROR];
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c1c57d4..a2b5b4c 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -18,15 +18,6 @@
 #ifndef	__XFS_ERROR_H__
 #define	__XFS_ERROR_H__
 
-#ifdef DEBUG
-#define	XFS_ERROR_NTRAP	10
-extern int	xfs_etrap[XFS_ERROR_NTRAP];
-extern int	xfs_error_trap(int);
-#define	XFS_ERROR(e)	xfs_error_trap(e)
-#else
-#define	XFS_ERROR(e)	(e)
-#endif
-
 struct xfs_mount;
 
 extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
@@ -56,7 +47,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 		if (unlikely(!fs_is_ok)) { \
 			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_GOTO", \
 					 XFS_ERRLEVEL_LOW, NULL); \
-			error = XFS_ERROR(EFSCORRUPTED); \
+			error = EFSCORRUPTED; \
 			goto l; \
 		} \
 	}
@@ -68,7 +59,7 @@ extern void xfs_verifier_error(struct xfs_buf *bp);
 		if (unlikely(!fs_is_ok)) { \
 			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_RETURN", \
 					 XFS_ERRLEVEL_LOW, NULL); \
-			return XFS_ERROR(EFSCORRUPTED); \
+			return EFSCORRUPTED; \
 		} \
 	}
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 79e96ce..169e5ba 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -179,7 +179,7 @@ xfs_file_fsync(
 		return error;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
@@ -265,7 +265,7 @@ xfs_file_aio_read(
 		if ((pos | size) & target->bt_logical_sectormask) {
 			if (pos == i_size_read(inode))
 				return 0;
-			return -XFS_ERROR(EINVAL);
+			return -EINVAL;
 		}
 	}
 
@@ -644,7 +644,7 @@ xfs_file_dio_aio_write(
 
 	/* DIO must be aligned to device logical sector size */
 	if ((pos | count) & target->bt_logical_sectormask)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	/* "unaligned" here means not aligned to a filesystem block */
 	if ((pos & mp->m_blockmask) || ((pos + count) & mp->m_blockmask))
@@ -1339,7 +1339,7 @@ xfs_seek_hole(
 	int			error;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	lock = xfs_ilock_data_map_shared(ip);
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 02fb943..fc03147 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -169,7 +169,7 @@ xfs_growfs_data_private(
 	nb = in->newblocks;
 	pct = in->imaxpct;
 	if (nb < mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
@@ -192,7 +192,7 @@ xfs_growfs_data_private(
 		nagcount--;
 		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
 		if (nb < mp->m_sb.sb_dblocks)
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 	}
 	new = nb - mp->m_sb.sb_dblocks;
 	oagcount = mp->m_sb.sb_agcount;
@@ -545,17 +545,17 @@ xfs_growfs_log_private(
 
 	nb = in->newblocks;
 	if (nb < XFS_MIN_LOG_BLOCKS || nb < XFS_B_TO_FSB(mp, XFS_MIN_LOG_BYTES))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	if (nb == mp->m_sb.sb_logblocks &&
 	    in->isint == (mp->m_sb.sb_logstart != 0))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	/*
 	 * Moving the log is hard, need new interfaces to sync
 	 * the log first, hold off all activity while moving it.
 	 * Can have shorter or longer log in the same space,
 	 * or transform internal to external log or vice versa.
 	 */
-	return XFS_ERROR(ENOSYS);
+	return ENOSYS;
 }
 
 /*
@@ -573,9 +573,9 @@ xfs_growfs_data(
 	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return XFS_ERROR(EPERM);
+		return EPERM;
 	if (!mutex_trylock(&mp->m_growlock))
-		return XFS_ERROR(EWOULDBLOCK);
+		return EWOULDBLOCK;
 	error = xfs_growfs_data_private(mp, in);
 	mutex_unlock(&mp->m_growlock);
 	return error;
@@ -589,9 +589,9 @@ xfs_growfs_log(
 	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return XFS_ERROR(EPERM);
+		return EPERM;
 	if (!mutex_trylock(&mp->m_growlock))
-		return XFS_ERROR(EWOULDBLOCK);
+		return EWOULDBLOCK;
 	error = xfs_growfs_log_private(mp, in);
 	mutex_unlock(&mp->m_growlock);
 	return error;
@@ -787,7 +787,7 @@ xfs_fs_goingdown(
 				SHUTDOWN_FORCE_UMOUNT | SHUTDOWN_LOG_IO_ERROR);
 		break;
 	default:
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 8f711db..dc57fbf 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -325,7 +325,7 @@ xfs_ialloc_ag_alloc(
 	newlen = args.mp->m_ialloc_inos;
 	if (args.mp->m_maxicount &&
 	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 	args.minlen = args.maxlen = args.mp->m_ialloc_blks;
 	/*
 	 * First try to allocate inodes contiguous with the last-allocated
@@ -1095,7 +1095,7 @@ out_alloc:
 	return xfs_dialloc_ag(tp, agbp, parent, inop);
 out_error:
 	xfs_perag_put(pag);
-	return XFS_ERROR(error);
+	return error;
 }
 
 /*
@@ -1137,7 +1137,7 @@ xfs_difree(
 		xfs_warn(mp, "%s: agno >= mp->m_sb.sb_agcount (%d >= %d).",
 			__func__, agno, mp->m_sb.sb_agcount);
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
 	if (inode != XFS_AGINO_TO_INO(mp, agno, agino))  {
@@ -1145,14 +1145,14 @@ xfs_difree(
 			__func__, (unsigned long long)inode,
 			(unsigned long long)XFS_AGINO_TO_INO(mp, agno, agino));
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (agbno >= mp->m_sb.sb_agblocks)  {
 		xfs_warn(mp, "%s: agbno >= mp->m_sb.sb_agblocks (%d >= %d).",
 			__func__, agbno, mp->m_sb.sb_agblocks);
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	/*
 	 * Get the allocation group header.
@@ -1366,7 +1366,7 @@ xfs_imap(
 		 * as they can be invalid without implying corruption.
 		 */
 		if (flags & XFS_IGET_UNTRUSTED)
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_alert(mp,
 				"%s: agno (%d) >= mp->m_sb.sb_agcount (%d)",
@@ -1386,7 +1386,7 @@ xfs_imap(
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	blks_per_cluster = xfs_icluster_size_fsb(mp);
@@ -1459,7 +1459,7 @@ out_map:
 			__func__, (unsigned long long) imap->im_blkno,
 			(unsigned long long) imap->im_len,
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks));
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	return 0;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 98d3524..11b7932 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -658,7 +658,7 @@ xfs_inode_ag_iterator(
 				break;
 		}
 	}
-	return XFS_ERROR(last_error);
+	return last_error;
 }
 
 int
@@ -687,7 +687,7 @@ xfs_inode_ag_iterator_tag(
 				break;
 		}
 	}
-	return XFS_ERROR(last_error);
+	return last_error;
 }
 
 /*
@@ -1132,7 +1132,7 @@ restart:
 		trylock = 0;
 		goto restart;
 	}
-	return XFS_ERROR(last_error);
+	return last_error;
 }
 
 int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5e7a38f..a5a40cc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -583,7 +583,7 @@ xfs_lookup(
 	trace_xfs_lookup(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
 	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
@@ -923,7 +923,7 @@ xfs_dir_ialloc(
 	}
 	if (!ialloc_context && !ip) {
 		*ipp = NULL;
-		return XFS_ERROR(ENOSPC);
+		return ENOSPC;
 	}
 
 	/*
@@ -1164,7 +1164,7 @@ xfs_create(
 	trace_xfs_create(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	prid = xfs_get_initial_prid(dp);
 
@@ -1349,7 +1349,7 @@ xfs_create_tmpfile(
 	uint			resblks;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	prid = xfs_get_initial_prid(dp);
 
@@ -1457,7 +1457,7 @@ xfs_link(
 	ASSERT(!S_ISDIR(sip->i_d.di_mode));
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	error = xfs_qm_dqattach(sip, 0);
 	if (error)
@@ -1492,7 +1492,7 @@ xfs_link(
 	 */
 	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (xfs_get_projid(tdp) != xfs_get_projid(sip)))) {
-		error = XFS_ERROR(EXDEV);
+		error = EXDEV;
 		goto error_return;
 	}
 
@@ -2552,7 +2552,7 @@ xfs_remove(
 	trace_xfs_remove(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
@@ -2604,11 +2604,11 @@ xfs_remove(
 	if (is_dir) {
 		ASSERT(ip->i_d.di_nlink >= 2);
 		if (ip->i_d.di_nlink != 2) {
-			error = XFS_ERROR(ENOTEMPTY);
+			error = ENOTEMPTY;
 			goto out_trans_cancel;
 		}
 		if (!xfs_dir_isempty(ip)) {
-			error = XFS_ERROR(ENOTEMPTY);
+			error = ENOTEMPTY;
 			goto out_trans_cancel;
 		}
 
@@ -2814,7 +2814,7 @@ xfs_rename(
 	 */
 	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
 		     (xfs_get_projid(target_dp) != xfs_get_projid(src_ip)))) {
-		error = XFS_ERROR(EXDEV);
+		error = EXDEV;
 		goto error_return;
 	}
 
@@ -2862,7 +2862,7 @@ xfs_rename(
 			 */
 			if (!(xfs_dir_isempty(target_ip)) ||
 			    (target_ip->i_d.di_nlink > 2)) {
-				error = XFS_ERROR(EEXIST);
+				error = EEXIST;
 				goto error_return;
 			}
 		}
@@ -3136,7 +3136,7 @@ cluster_corrupt_out:
 	xfs_iflush_abort(iq, false);
 	kmem_free(ilist);
 	xfs_perag_put(pag);
-	return XFS_ERROR(EFSCORRUPTED);
+	return EFSCORRUPTED;
 }
 
 /*
@@ -3191,7 +3191,7 @@ xfs_iflush(
 	 * as we wait for an empty AIL as part of the unmount process.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = XFS_ERROR(EIO);
+		error = EIO;
 		goto abort_out;
 	}
 
@@ -3234,7 +3234,7 @@ corrupt_out:
 	xfs_buf_relse(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 cluster_corrupt_out:
-	error = XFS_ERROR(EFSCORRUPTED);
+	error = EFSCORRUPTED;
 abort_out:
 	/*
 	 * Unlocks the flush lock
@@ -3428,5 +3428,5 @@ xfs_iflush_int(
 	return 0;
 
 corrupt_out:
-	return XFS_ERROR(EFSCORRUPTED);
+	return EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 24e9939..4f7b9ad 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -181,7 +181,7 @@ xfs_imap_to_bp(
 
 		if (error == EFSCORRUPTED &&
 		    (iget_flags & XFS_IGET_UNTRUSTED))
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 
 		xfs_warn(mp, "%s: xfs_trans_read_buf() returned error %d.",
 			__func__, error);
@@ -390,7 +390,7 @@ xfs_iread(
 				__func__, ip->i_ino);
 
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, dip);
-		error = XFS_ERROR(EFSCORRUPTED);
+		error = EFSCORRUPTED;
 		goto out_brelse;
 	}
 
diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
index 5515f38..7e8a105 100644
--- a/fs/xfs/xfs_inode_fork.c
+++ b/fs/xfs/xfs_inode_fork.c
@@ -102,7 +102,7 @@ xfs_iformat_fork(
 				be64_to_cpu(dip->di_nblocks));
 		XFS_CORRUPTION_ERROR("xfs_iformat(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (unlikely(dip->di_forkoff > ip->i_mount->m_sb.sb_inodesize)) {
@@ -111,7 +111,7 @@ xfs_iformat_fork(
 			dip->di_forkoff);
 		XFS_CORRUPTION_ERROR("xfs_iformat(2)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
@@ -121,7 +121,7 @@ xfs_iformat_fork(
 			ip->i_ino);
 		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
 				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	switch (ip->i_d.di_mode & S_IFMT) {
@@ -132,7 +132,7 @@ xfs_iformat_fork(
 		if (unlikely(dip->di_format != XFS_DINODE_FMT_DEV)) {
 			XFS_CORRUPTION_ERROR("xfs_iformat(3)", XFS_ERRLEVEL_LOW,
 					      ip->i_mount, dip);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		ip->i_d.di_size = 0;
 		ip->i_df.if_u2.if_rdev = xfs_dinode_get_rdev(dip);
@@ -153,7 +153,7 @@ xfs_iformat_fork(
 				XFS_CORRUPTION_ERROR("xfs_iformat(4)",
 						     XFS_ERRLEVEL_LOW,
 						     ip->i_mount, dip);
-				return XFS_ERROR(EFSCORRUPTED);
+				return EFSCORRUPTED;
 			}
 
 			di_size = be64_to_cpu(dip->di_size);
@@ -166,7 +166,7 @@ xfs_iformat_fork(
 				XFS_CORRUPTION_ERROR("xfs_iformat(5)",
 						     XFS_ERRLEVEL_LOW,
 						     ip->i_mount, dip);
-				return XFS_ERROR(EFSCORRUPTED);
+				return EFSCORRUPTED;
 			}
 
 			size = (int)di_size;
@@ -181,13 +181,13 @@ xfs_iformat_fork(
 		default:
 			XFS_ERROR_REPORT("xfs_iformat(6)", XFS_ERRLEVEL_LOW,
 					 ip->i_mount);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		break;
 
 	default:
 		XFS_ERROR_REPORT("xfs_iformat(7)", XFS_ERRLEVEL_LOW, ip->i_mount);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	if (error) {
 		return error;
@@ -211,7 +211,7 @@ xfs_iformat_fork(
 			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
 					     XFS_ERRLEVEL_LOW,
 					     ip->i_mount, dip);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
@@ -223,7 +223,7 @@ xfs_iformat_fork(
 		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
 		break;
 	default:
-		error = XFS_ERROR(EFSCORRUPTED);
+		error = EFSCORRUPTED;
 		break;
 	}
 	if (error) {
@@ -266,7 +266,7 @@ xfs_iformat_local(
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		XFS_CORRUPTION_ERROR("xfs_iformat_local", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	real_size = 0;
@@ -322,7 +322,7 @@ xfs_iformat_extents(
 			(unsigned long long) ip->i_ino, nex);
 		XFS_CORRUPTION_ERROR("xfs_iformat_extents(1)", XFS_ERRLEVEL_LOW,
 				     ip->i_mount, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	ifp->if_real_bytes = 0;
@@ -350,7 +350,7 @@ xfs_iformat_extents(
 					XFS_ERROR_REPORT("xfs_iformat_extents(2)",
 							 XFS_ERRLEVEL_LOW,
 							 ip->i_mount);
-					return XFS_ERROR(EFSCORRUPTED);
+					return EFSCORRUPTED;
 				}
 	}
 	ifp->if_flags |= XFS_IFEXTENTS;
@@ -399,7 +399,7 @@ xfs_iformat_btree(
 					(unsigned long long) ip->i_ino);
 		XFS_CORRUPTION_ERROR("xfs_iformat_btree", XFS_ERRLEVEL_LOW,
 					 mp, dip);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	ifp->if_broot_bytes = size;
@@ -436,7 +436,7 @@ xfs_iread_extents(
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
 				 ip->i_mount);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b18776..2afe0d1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -207,7 +207,7 @@ xfs_open_by_handle(
 	struct path		path;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
 	if (IS_ERR(dentry))
@@ -216,7 +216,7 @@ xfs_open_by_handle(
 
 	/* Restrict xfs_open_by_handle to directories & regular files. */
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
-		error = -XFS_ERROR(EPERM);
+		error = -EPERM;
 		goto out_dput;
 	}
 
@@ -228,18 +228,18 @@ xfs_open_by_handle(
 	fmode = OPEN_FMODE(permflag);
 	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
 	    (fmode & FMODE_WRITE) && IS_APPEND(inode)) {
-		error = -XFS_ERROR(EPERM);
+		error = -EPERM;
 		goto out_dput;
 	}
 
 	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
-		error = -XFS_ERROR(EACCES);
+		error = -EACCES;
 		goto out_dput;
 	}
 
 	/* Can't write directories. */
 	if (S_ISDIR(inode->i_mode) && (fmode & FMODE_WRITE)) {
-		error = -XFS_ERROR(EISDIR);
+		error = -EISDIR;
 		goto out_dput;
 	}
 
@@ -282,7 +282,7 @@ xfs_readlink_by_handle(
 	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
 	if (IS_ERR(dentry))
@@ -290,18 +290,18 @@ xfs_readlink_by_handle(
 
 	/* Restrict this handle operation to symlinks only. */
 	if (!S_ISLNK(dentry->d_inode->i_mode)) {
-		error = -XFS_ERROR(EINVAL);
+		error = -EINVAL;
 		goto out_dput;
 	}
 
 	if (copy_from_user(&olen, hreq->ohandlen, sizeof(__u32))) {
-		error = -XFS_ERROR(EFAULT);
+		error = -EFAULT;
 		goto out_dput;
 	}
 
 	link = kmalloc(MAXPATHLEN+1, GFP_KERNEL);
 	if (!link) {
-		error = -XFS_ERROR(ENOMEM);
+		error = -ENOMEM;
 		goto out_dput;
 	}
 
@@ -330,10 +330,10 @@ xfs_set_dmattrs(
 	int		error;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return XFS_ERROR(EPERM);
+		return EPERM;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SET_DMATTRS);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
@@ -364,9 +364,9 @@ xfs_fssetdm_by_handle(
 	struct dentry		*dentry;
 
 	if (!capable(CAP_MKNOD))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&dmhreq, arg, sizeof(xfs_fsop_setdm_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	error = mnt_want_write_file(parfilp);
 	if (error)
@@ -379,12 +379,12 @@ xfs_fssetdm_by_handle(
 	}
 
 	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
-		error = -XFS_ERROR(EPERM);
+		error = -EPERM;
 		goto out;
 	}
 
 	if (copy_from_user(&fsd, dmhreq.data, sizeof(fsd))) {
-		error = -XFS_ERROR(EFAULT);
+		error = -EFAULT;
 		goto out;
 	}
 
@@ -409,18 +409,18 @@ xfs_attrlist_by_handle(
 	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	if (al_hreq.buflen < sizeof(struct attrlist) ||
 	    al_hreq.buflen > XATTR_LIST_MAX)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	/*
 	 * Reject flags, only allow namespaces.
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
@@ -524,9 +524,9 @@ xfs_attrmulti_by_handle(
 	unsigned char		*attr_name;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&am_hreq, arg, sizeof(xfs_fsop_attrmulti_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	/* overflow check */
 	if (am_hreq.opcount >= INT_MAX / sizeof(xfs_attr_multiop_t))
@@ -592,7 +592,7 @@ xfs_attrmulti_by_handle(
 	}
 
 	if (copy_to_user(am_hreq.ops, ops, size))
-		error = XFS_ERROR(EFAULT);
+		error = EFAULT;
 
 	kfree(attr_name);
  out_kfree_ops:
@@ -624,16 +624,16 @@ xfs_ioc_space(
 	 */
 	if (!xfs_sb_version_hasextflgbit(&ip->i_mount->m_sb) &&
 	    !capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 
 	if (inode->i_flags & (S_IMMUTABLE|S_APPEND))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 
 	if (!(filp->f_mode & FMODE_WRITE))
-		return -XFS_ERROR(EBADF);
+		return -EBADF;
 
 	if (!S_ISREG(inode->i_mode))
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	error = mnt_want_write_file(filp);
 	if (error)
@@ -651,7 +651,7 @@ xfs_ioc_space(
 		bf->l_start += XFS_ISIZE(ip);
 		break;
 	default:
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_unlock;
 	}
 
@@ -668,7 +668,7 @@ xfs_ioc_space(
 	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_UNRESVSP64:
 		if (bf->l_len <= 0) {
-			error = XFS_ERROR(EINVAL);
+			error = EINVAL;
 			goto out_unlock;
 		}
 		break;
@@ -681,7 +681,7 @@ xfs_ioc_space(
 	    bf->l_start > mp->m_super->s_maxbytes ||
 	    bf->l_start + bf->l_len < 0 ||
 	    bf->l_start + bf->l_len >= mp->m_super->s_maxbytes) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_unlock;
 	}
 
@@ -722,7 +722,7 @@ xfs_ioc_space(
 		break;
 	default:
 		ASSERT(0);
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 	}
 
 	if (error)
@@ -780,19 +780,19 @@ xfs_ioc_bulkstat(
 		return -EPERM;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	if ((count = bulkreq.icount) <= 0)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	if (bulkreq.ubuffer == NULL)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	if (cmd == XFS_IOC_FSINUMBERS)
 		error = xfs_inumbers(mp, &inlast, &count,
@@ -811,10 +811,10 @@ xfs_ioc_bulkstat(
 	if (bulkreq.ocount != NULL) {
 		if (copy_to_user(bulkreq.lastip, &inlast,
 						sizeof(xfs_ino_t)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 	}
 
 	return 0;
@@ -838,7 +838,7 @@ xfs_ioc_fsgeometry_v1(
 	 * xfs_fsop_geom_t that xfs_fs_geometry() fills in.
 	 */
 	if (copy_to_user(arg, &fsgeo, sizeof(xfs_fsop_geom_v1_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -855,7 +855,7 @@ xfs_ioc_fsgeometry(
 		return -error;
 
 	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -1040,16 +1040,16 @@ xfs_ioctl_setattr(
 	trace_xfs_ioctl_setattr(ip);
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
+		return EROFS;
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	/*
 	 * Disallow 32bit project ids when projid32bit feature is not enabled.
 	 */
 	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
 			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 
 	/*
 	 * If disk quotas is on, we make sure that the dquots do exist on disk,
@@ -1087,7 +1087,7 @@ xfs_ioctl_setattr(
 	 * CAP_FSETID capability is applicable.
 	 */
 	if (!inode_owner_or_capable(VFS_I(ip))) {
-		code = XFS_ERROR(EPERM);
+		code = EPERM;
 		goto error_return;
 	}
 
@@ -1098,7 +1098,7 @@ xfs_ioctl_setattr(
 	 */
 	if (mask & FSX_PROJID) {
 		if (current_user_ns() != &init_user_ns) {
-			code = XFS_ERROR(EINVAL);
+			code = EINVAL;
 			goto error_return;
 		}
 
@@ -1121,7 +1121,7 @@ xfs_ioctl_setattr(
 		if (ip->i_d.di_nextents &&
 		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
 		     fa->fsx_extsize)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			code = EINVAL;	/* EFBIG? */
 			goto error_return;
 		}
 
@@ -1140,7 +1140,7 @@ xfs_ioctl_setattr(
 
 			extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
 			if (extsize_fsb > MAXEXTLEN) {
-				code = XFS_ERROR(EINVAL);
+				code = EINVAL;
 				goto error_return;
 			}
 
@@ -1152,13 +1152,13 @@ xfs_ioctl_setattr(
 			} else {
 				size = mp->m_sb.sb_blocksize;
 				if (extsize_fsb > mp->m_sb.sb_agblocks / 2) {
-					code = XFS_ERROR(EINVAL);
+					code = EINVAL;
 					goto error_return;
 				}
 			}
 
 			if (fa->fsx_extsize % size) {
-				code = XFS_ERROR(EINVAL);
+				code = EINVAL;
 				goto error_return;
 			}
 		}
@@ -1172,7 +1172,7 @@ xfs_ioctl_setattr(
 		if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
 		    (XFS_IS_REALTIME_INODE(ip)) !=
 		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
-			code = XFS_ERROR(EINVAL);	/* EFBIG? */
+			code = EINVAL;	/* EFBIG? */
 			goto error_return;
 		}
 
@@ -1183,7 +1183,7 @@ xfs_ioctl_setattr(
 			if ((mp->m_sb.sb_rblocks == 0) ||
 			    (mp->m_sb.sb_rextsize == 0) ||
 			    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize)) {
-				code = XFS_ERROR(EINVAL);
+				code = EINVAL;
 				goto error_return;
 			}
 		}
@@ -1197,7 +1197,7 @@ xfs_ioctl_setattr(
 		     (fa->fsx_xflags &
 				(XFS_XFLAG_IMMUTABLE | XFS_XFLAG_APPEND))) &&
 		    !capable(CAP_LINUX_IMMUTABLE)) {
-			code = XFS_ERROR(EPERM);
+			code = EPERM;
 			goto error_return;
 		}
 	}
@@ -1362,7 +1362,7 @@ xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
 
 	/* copy only getbmap portion (not getbmapx) */
 	if (copy_to_user(base, bmv, sizeof(struct getbmap)))
-		return XFS_ERROR(EFAULT);
+		return EFAULT;
 
 	*ap += sizeof(struct getbmap);
 	return 0;
@@ -1379,10 +1379,10 @@ xfs_ioc_getbmap(
 	int			error;
 
 	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	bmx.bmv_iflags = (cmd == XFS_IOC_GETBMAPA ? BMV_IF_ATTRFORK : 0);
 	if (ioflags & IO_INVIS)
@@ -1395,7 +1395,7 @@ xfs_ioc_getbmap(
 
 	/* copy back header - only size of getbmap */
 	if (copy_to_user(arg, &bmx, sizeof(struct getbmap)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -1405,7 +1405,7 @@ xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
 	struct getbmapx __user	*base = *ap;
 
 	if (copy_to_user(base, bmv, sizeof(struct getbmapx)))
-		return XFS_ERROR(EFAULT);
+		return EFAULT;
 
 	*ap += sizeof(struct getbmapx);
 	return 0;
@@ -1420,13 +1420,13 @@ xfs_ioc_getbmapx(
 	int			error;
 
 	if (copy_from_user(&bmx, arg, sizeof(bmx)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	if (bmx.bmv_count < 2)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	if (bmx.bmv_iflags & (~BMV_IF_VALID))
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
 			    (struct getbmapx *)arg+1);
@@ -1435,7 +1435,7 @@ xfs_ioc_getbmapx(
 
 	/* copy back header */
 	if (copy_to_user(arg, &bmx, sizeof(struct getbmapx)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	return 0;
 }
@@ -1451,33 +1451,33 @@ xfs_ioc_swapext(
 	/* Pull information for the target fd */
 	f = fdget((int)sxp->sx_fdtarget);
 	if (!f.file) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out;
 	}
 
 	if (!(f.file->f_mode & FMODE_WRITE) ||
 	    !(f.file->f_mode & FMODE_READ) ||
 	    (f.file->f_flags & O_APPEND)) {
-		error = XFS_ERROR(EBADF);
+		error = EBADF;
 		goto out_put_file;
 	}
 
 	tmp = fdget((int)sxp->sx_fdtmp);
 	if (!tmp.file) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_put_file;
 	}
 
 	if (!(tmp.file->f_mode & FMODE_WRITE) ||
 	    !(tmp.file->f_mode & FMODE_READ) ||
 	    (tmp.file->f_flags & O_APPEND)) {
-		error = XFS_ERROR(EBADF);
+		error = EBADF;
 		goto out_put_tmp_file;
 	}
 
 	if (IS_SWAPFILE(file_inode(f.file)) ||
 	    IS_SWAPFILE(file_inode(tmp.file))) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_put_tmp_file;
 	}
 
@@ -1485,17 +1485,17 @@ xfs_ioc_swapext(
 	tip = XFS_I(file_inode(tmp.file));
 
 	if (ip->i_mount != tip->i_mount) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_put_tmp_file;
 	}
 
 	if (ip->i_ino == tip->i_ino) {
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto out_put_tmp_file;
 	}
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		error = XFS_ERROR(EIO);
+		error = EIO;
 		goto out_put_tmp_file;
 	}
 
@@ -1548,7 +1548,7 @@ xfs_file_ioctl(
 		xfs_flock64_t		bf;
 
 		if (copy_from_user(&bf, arg, sizeof(bf)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
 	}
 	case XFS_IOC_DIOINFO: {
@@ -1561,7 +1561,7 @@ xfs_file_ioctl(
 		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
 
 		if (copy_to_user(arg, &da, sizeof(da)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return 0;
 	}
 
@@ -1594,7 +1594,7 @@ xfs_file_ioctl(
 		struct fsdmidata	dmi;
 
 		if (copy_from_user(&dmi, arg, sizeof(dmi)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = mnt_want_write_file(filp);
 		if (error)
@@ -1619,14 +1619,14 @@ xfs_file_ioctl(
 		xfs_fsop_handlereq_t	hreq;
 
 		if (copy_from_user(&hreq, arg, sizeof(hreq)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_find_handle(cmd, &hreq);
 	}
 	case XFS_IOC_OPEN_BY_HANDLE: {
 		xfs_fsop_handlereq_t	hreq;
 
 		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_open_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_FSSETDM_BY_HANDLE:
@@ -1636,7 +1636,7 @@ xfs_file_ioctl(
 		xfs_fsop_handlereq_t	hreq;
 
 		if (copy_from_user(&hreq, arg, sizeof(xfs_fsop_handlereq_t)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_readlink_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
@@ -1649,7 +1649,7 @@ xfs_file_ioctl(
 		struct xfs_swapext	sxp;
 
 		if (copy_from_user(&sxp, arg, sizeof(xfs_swapext_t)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
@@ -1666,7 +1666,7 @@ xfs_file_ioctl(
 			return -error;
 
 		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return 0;
 	}
 
@@ -1678,10 +1678,10 @@ xfs_file_ioctl(
 			return -EPERM;
 
 		if (mp->m_flags & XFS_MOUNT_RDONLY)
-			return -XFS_ERROR(EROFS);
+			return -EROFS;
 
 		if (copy_from_user(&inout, arg, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = mnt_want_write_file(filp);
 		if (error)
@@ -1695,7 +1695,7 @@ xfs_file_ioctl(
 			return -error;
 
 		if (copy_to_user(arg, &inout, sizeof(inout)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return 0;
 	}
 
@@ -1710,7 +1710,7 @@ xfs_file_ioctl(
 			return -error;
 
 		if (copy_to_user(arg, &out, sizeof(out)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		return 0;
 	}
@@ -1719,7 +1719,7 @@ xfs_file_ioctl(
 		xfs_growfs_data_t in;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = mnt_want_write_file(filp);
 		if (error)
@@ -1733,7 +1733,7 @@ xfs_file_ioctl(
 		xfs_growfs_log_t in;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = mnt_want_write_file(filp);
 		if (error)
@@ -1747,7 +1747,7 @@ xfs_file_ioctl(
 		xfs_growfs_rt_t in;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = mnt_want_write_file(filp);
 		if (error)
@@ -1764,7 +1764,7 @@ xfs_file_ioctl(
 			return -EPERM;
 
 		if (get_user(in, (__uint32_t __user *)arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = xfs_fs_goingdown(mp, in);
 		return -error;
@@ -1777,7 +1777,7 @@ xfs_file_ioctl(
 			return -EPERM;
 
 		if (copy_from_user(&in, arg, sizeof(in)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = xfs_errortag_add(in.errtag, mp);
 		return -error;
@@ -1798,10 +1798,10 @@ xfs_file_ioctl(
 			return -EPERM;
 
 		if (mp->m_flags & XFS_MOUNT_RDONLY)
-			return -XFS_ERROR(EROFS);
+			return -EROFS;
 
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		error = xfs_fs_eofblocks_from_user(&eofb, &keofb);
 		if (error)
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a7992f8..8916c13 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -56,7 +56,7 @@ xfs_compat_flock64_copyin(
 	    get_user(bf->l_sysid,	&arg32->l_sysid) ||
 	    get_user(bf->l_pid,		&arg32->l_pid) ||
 	    copy_from_user(bf->l_pad,	&arg32->l_pad,	4*sizeof(u32)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -73,7 +73,7 @@ xfs_compat_ioc_fsgeometry_v1(
 		return -error;
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -84,7 +84,7 @@ xfs_compat_growfs_data_copyin(
 {
 	if (get_user(in->newblocks, &arg32->newblocks) ||
 	    get_user(in->imaxpct,   &arg32->imaxpct))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -95,7 +95,7 @@ xfs_compat_growfs_rt_copyin(
 {
 	if (get_user(in->newblocks, &arg32->newblocks) ||
 	    get_user(in->extsize,   &arg32->extsize))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -113,7 +113,7 @@ xfs_inumbers_fmt_compat(
 		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
 		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
 		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 	}
 	*written = count * sizeof(*p32);
 	return 0;
@@ -132,7 +132,7 @@ xfs_ioctl32_bstime_copyin(
 
 	if (get_user(sec32,		&bstime32->tv_sec)	||
 	    get_user(bstime->tv_nsec,	&bstime32->tv_nsec))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	bstime->tv_sec = sec32;
 	return 0;
 }
@@ -164,7 +164,7 @@ xfs_ioctl32_bstat_copyin(
 	    get_user(bstat->bs_dmevmask, &bstat32->bs_dmevmask)	||
 	    get_user(bstat->bs_dmstate,	&bstat32->bs_dmstate)	||
 	    get_user(bstat->bs_aextents, &bstat32->bs_aextents))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -180,7 +180,7 @@ xfs_bstime_store_compat(
 	sec32 = p->tv_sec;
 	if (put_user(sec32, &p32->tv_sec) ||
 	    put_user(p->tv_nsec, &p32->tv_nsec))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	return 0;
 }
 
@@ -195,7 +195,7 @@ xfs_bulkstat_one_fmt_compat(
 	compat_xfs_bstat_t	__user *p32 = ubuffer;
 
 	if (ubsize < sizeof(*p32))
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 
 	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
 	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
@@ -218,7 +218,7 @@ xfs_bulkstat_one_fmt_compat(
 	    put_user(buffer->bs_dmevmask, &p32->bs_dmevmask)	||
 	    put_user(buffer->bs_dmstate,  &p32->bs_dmstate)	||
 	    put_user(buffer->bs_aextents, &p32->bs_aextents))
-		return XFS_ERROR(EFAULT);
+		return EFAULT;
 	if (ubused)
 		*ubused = sizeof(*p32);
 	return 0;
@@ -256,30 +256,30 @@ xfs_compat_ioc_bulkstat(
 	/* should be called again (unused here, but used in dmapi) */
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	if (get_user(addr, &p32->lastip))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	bulkreq.lastip = compat_ptr(addr);
 	if (get_user(bulkreq.icount, &p32->icount) ||
 	    get_user(addr, &p32->ubuffer))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	bulkreq.ubuffer = compat_ptr(addr);
 	if (get_user(addr, &p32->ocount))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	bulkreq.ocount = compat_ptr(addr);
 
 	if (copy_from_user(&inlast, bulkreq.lastip, sizeof(__s64)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	if ((count = bulkreq.icount) <= 0)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	if (bulkreq.ubuffer == NULL)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	if (cmd == XFS_IOC_FSINUMBERS_32) {
 		error = xfs_inumbers(mp, &inlast, &count,
@@ -294,17 +294,17 @@ xfs_compat_ioc_bulkstat(
 			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
 			bulkreq.ubuffer, &done);
 	} else
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 	if (error)
 		return -error;
 
 	if (bulkreq.ocount != NULL) {
 		if (copy_to_user(bulkreq.lastip, &inlast,
 						sizeof(xfs_ino_t)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 
 		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 	}
 
 	return 0;
@@ -318,7 +318,7 @@ xfs_compat_handlereq_copyin(
 	compat_xfs_fsop_handlereq_t	hreq32;
 
 	if (copy_from_user(&hreq32, arg32, sizeof(compat_xfs_fsop_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	hreq->fd = hreq32.fd;
 	hreq->path = compat_ptr(hreq32.path);
@@ -352,19 +352,19 @@ xfs_compat_attrlist_by_handle(
 	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 	if (al_hreq.buflen < sizeof(struct attrlist) ||
 	    al_hreq.buflen > XATTR_LIST_MAX)
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	/*
 	 * Reject flags, only allow namespaces.
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -XFS_ERROR(EINVAL);
+		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
@@ -404,10 +404,10 @@ xfs_compat_attrmulti_by_handle(
 	unsigned char				*attr_name;
 
 	if (!capable(CAP_SYS_ADMIN))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&am_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrmulti_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	/* overflow check */
 	if (am_hreq.opcount >= INT_MAX / sizeof(compat_xfs_attr_multiop_t))
@@ -474,7 +474,7 @@ xfs_compat_attrmulti_by_handle(
 	}
 
 	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
-		error = XFS_ERROR(EFAULT);
+		error = EFAULT;
 
 	kfree(attr_name);
  out_kfree_ops:
@@ -495,22 +495,22 @@ xfs_compat_fssetdm_by_handle(
 	struct dentry		*dentry;
 
 	if (!capable(CAP_MKNOD))
-		return -XFS_ERROR(EPERM);
+		return -EPERM;
 	if (copy_from_user(&dmhreq, arg,
 			   sizeof(compat_xfs_fsop_setdm_handlereq_t)))
-		return -XFS_ERROR(EFAULT);
+		return -EFAULT;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &dmhreq.hreq);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
 	if (IS_IMMUTABLE(dentry->d_inode) || IS_APPEND(dentry->d_inode)) {
-		error = -XFS_ERROR(EPERM);
+		error = -EPERM;
 		goto out;
 	}
 
 	if (copy_from_user(&fsd, compat_ptr(dmhreq.data), sizeof(fsd))) {
-		error = -XFS_ERROR(EFAULT);
+		error = -EFAULT;
 		goto out;
 	}
 
@@ -587,7 +587,7 @@ xfs_file_compat_ioctl(
 		struct xfs_flock64	bf;
 
 		if (xfs_compat_flock64_copyin(&bf, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, &bf);
 	}
@@ -597,7 +597,7 @@ xfs_file_compat_ioctl(
 		struct xfs_growfs_data	in;
 
 		if (xfs_compat_growfs_data_copyin(&in, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
@@ -609,7 +609,7 @@ xfs_file_compat_ioctl(
 		struct xfs_growfs_rt	in;
 
 		if (xfs_compat_growfs_rt_copyin(&in, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
@@ -632,7 +632,7 @@ xfs_file_compat_ioctl(
 		if (copy_from_user(&sxp, sxu,
 				   offsetof(struct xfs_swapext, sx_stat)) ||
 		    xfs_ioctl32_bstat_copyin(&sxp.sx_stat, &sxu->sx_stat))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		error = mnt_want_write_file(filp);
 		if (error)
 			return error;
@@ -650,7 +650,7 @@ xfs_file_compat_ioctl(
 		struct xfs_fsop_handlereq	hreq;
 
 		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
 		return xfs_find_handle(cmd, &hreq);
 	}
@@ -658,14 +658,14 @@ xfs_file_compat_ioctl(
 		struct xfs_fsop_handlereq	hreq;
 
 		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_open_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_READLINK_BY_HANDLE_32: {
 		struct xfs_fsop_handlereq	hreq;
 
 		if (xfs_compat_handlereq_copyin(&hreq, arg))
-			return -XFS_ERROR(EFAULT);
+			return -EFAULT;
 		return xfs_readlink_by_handle(filp, &hreq);
 	}
 	case XFS_IOC_ATTRLIST_BY_HANDLE_32:
@@ -675,6 +675,6 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSSETDM_BY_HANDLE_32:
 		return xfs_compat_fssetdm_by_handle(filp, arg);
 	default:
-		return -XFS_ERROR(ENOIOCTLCMD);
+		return -ENOIOCTLCMD;
 	}
 }
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3b80eba..2bf7d12 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -138,7 +138,7 @@ xfs_iomap_write_direct(
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
@@ -148,7 +148,7 @@ xfs_iomap_write_direct(
 	if ((offset + count) > XFS_ISIZE(ip)) {
 		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
 		if (error)
-			return XFS_ERROR(error);
+			return error;
 	} else {
 		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = MIN(last_fsb, (xfs_fileoff_t)
@@ -188,7 +188,7 @@ xfs_iomap_write_direct(
 	 */
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return XFS_ERROR(error);
+		return error;
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -225,7 +225,7 @@ xfs_iomap_write_direct(
 	 * Copy any maps to caller's array and return any error.
 	 */
 	if (nimaps == 0) {
-		error = XFS_ERROR(ENOSPC);
+		error = ENOSPC;
 		goto out_unlock;
 	}
 
@@ -552,7 +552,7 @@ xfs_iomap_write_delay(
 	 */
 	error = xfs_qm_dqattach_locked(ip, 0);
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
@@ -600,7 +600,7 @@ retry:
 	case EDQUOT:
 		break;
 	default:
-		return XFS_ERROR(error);
+		return error;
 	}
 
 	/*
@@ -614,7 +614,7 @@ retry:
 			error = 0;
 			goto retry;
 		}
-		return XFS_ERROR(error ? error : ENOSPC);
+		return error ? error : ENOSPC;
 	}
 
 	if (!(imap[0].br_startblock || XFS_IS_REALTIME_INODE(ip)))
@@ -663,7 +663,7 @@ xfs_iomap_write_allocate(
 	 */
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = imap->br_blockcount;
@@ -690,7 +690,7 @@ xfs_iomap_write_allocate(
 						  nres, 0);
 			if (error) {
 				xfs_trans_cancel(tp, 0);
-				return XFS_ERROR(error);
+				return error;
 			}
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			xfs_trans_ijoin(tp, ip, 0);
@@ -794,7 +794,7 @@ trans_cancel:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
 error0:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return XFS_ERROR(error);
+	return error;
 }
 
 int
@@ -854,7 +854,7 @@ xfs_iomap_write_unwritten(
 					  resblks, 0);
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			return XFS_ERROR(error);
+			return error;
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -893,7 +893,7 @@ xfs_iomap_write_unwritten(
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
-			return XFS_ERROR(error);
+			return error;
 
 		if (!(imap.br_startblock || XFS_IS_REALTIME_INODE(ip)))
 			return xfs_alert_fsblock_zero(ip, &imap);
@@ -916,5 +916,5 @@ error_on_bmapi_transaction:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return XFS_ERROR(error);
+	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 89b07e4..1342884 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -420,7 +420,7 @@ xfs_vn_getattr(
 	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return -XFS_ERROR(EIO);
+		return -EIO;
 
 	stat->size = XFS_ISIZE(ip);
 	stat->dev = inode->i_sb->s_dev;
@@ -525,14 +525,14 @@ xfs_setattr_nonsize(
 	/* If acls are being inherited, we already have this checked */
 	if (!(flags & XFS_ATTR_NOACL)) {
 		if (mp->m_flags & XFS_MOUNT_RDONLY)
-			return XFS_ERROR(EROFS);
+			return EROFS;
 
 		if (XFS_FORCED_SHUTDOWN(mp))
-			return XFS_ERROR(EIO);
+			return EIO;
 
 		error = -inode_change_ok(inode, iattr);
 		if (error)
-			return XFS_ERROR(error);
+			return error;
 	}
 
 	ASSERT((mask & ATTR_SIZE) == 0);
@@ -682,7 +682,7 @@ xfs_setattr_nonsize(
 	xfs_qm_dqrele(gdqp);
 
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	/*
 	 * XXX(hch): Updating the ACL entries is not atomic vs the i_mode
@@ -694,7 +694,7 @@ xfs_setattr_nonsize(
 	if ((mask & ATTR_MODE) && !(flags & XFS_ATTR_NOACL)) {
 		error = -posix_acl_chmod(inode, inode->i_mode);
 		if (error)
-			return XFS_ERROR(error);
+			return error;
 	}
 
 	return 0;
@@ -727,14 +727,14 @@ xfs_setattr_size(
 	trace_xfs_setattr(ip);
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		return XFS_ERROR(EROFS);
+		return EROFS;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	error = -inode_change_ok(inode, iattr);
 	if (error)
-		return XFS_ERROR(error);
+		return error;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(S_ISREG(ip->i_d.di_mode));
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f463382..6dc5edd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -67,11 +67,11 @@ xfs_bulkstat_one_int(
 	*stat = BULKSTAT_RV_NOTHING;
 
 	if (!buffer || xfs_internal_inum(mp, ino))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 
 	buf = kmem_alloc(sizeof(*buf), KM_SLEEP | KM_MAYFAIL);
 	if (!buf)
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 
 	error = xfs_iget(mp, NULL, ino,
 			 (XFS_IGET_DONTCACHE | XFS_IGET_UNTRUSTED),
@@ -154,9 +154,9 @@ xfs_bulkstat_one_fmt(
 	const xfs_bstat_t	*buffer)
 {
 	if (ubsize < sizeof(*buffer))
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 	if (copy_to_user(ubuffer, buffer, sizeof(*buffer)))
-		return XFS_ERROR(EFAULT);
+		return EFAULT;
 	if (ubused)
 		*ubused = sizeof(*buffer);
 	return 0;
@@ -551,7 +551,7 @@ xfs_bulkstat_single(
 			return error;
 		if (count == 0 || (xfs_ino_t)*lastinop != ino)
 			return error == EFSCORRUPTED ?
-				XFS_ERROR(EINVAL) : error;
+				EINVAL : error;
 		else
 			return 0;
 	}
@@ -659,7 +659,7 @@ xfs_inumbers(
 		if (bufidx == bcount) {
 			long written;
 			if (formatter(ubuffer, buffer, bufidx, &written)) {
-				error = XFS_ERROR(EFAULT);
+				error = EFAULT;
 				break;
 			}
 			ubuffer += written;
@@ -686,7 +686,7 @@ xfs_inumbers(
 		if (bufidx) {
 			long written;
 			if (formatter(ubuffer, buffer, bufidx, &written))
-				error = XFS_ERROR(EFAULT);
+				error = EFAULT;
 			else
 				*count += bufidx;
 		}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8497a00..493ac0d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -283,7 +283,7 @@ xlog_grant_head_wait(
 	return 0;
 shutdown:
 	list_del_init(&tic->t_queue);
-	return XFS_ERROR(EIO);
+	return EIO;
 }
 
 /*
@@ -377,7 +377,7 @@ xfs_log_regrant(
 	int			error = 0;
 
 	if (XLOG_FORCED_SHUTDOWN(log))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	XFS_STATS_INC(xs_try_logspace);
 
@@ -446,7 +446,7 @@ xfs_log_reserve(
 	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	XFS_STATS_INC(xs_try_logspace);
 
@@ -454,7 +454,7 @@ xfs_log_reserve(
 	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
 				KM_SLEEP | KM_MAYFAIL);
 	if (!tic)
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 
 	tic->t_trans_type = t_type;
 	*ticp = tic;
@@ -2323,7 +2323,7 @@ xlog_write(
 
 			ophdr = xlog_write_setup_ophdr(log, ptr, ticket, flags);
 			if (!ophdr)
-				return XFS_ERROR(EIO);
+				return EIO;
 
 			xlog_write_adv_cnt(&ptr, &len, &log_offset,
 					   sizeof(struct xlog_op_header));
@@ -2822,7 +2822,7 @@ restart:
 	spin_lock(&log->l_icloglock);
 	if (XLOG_FORCED_SHUTDOWN(log)) {
 		spin_unlock(&log->l_icloglock);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	iclog = log->l_iclog;
@@ -3010,7 +3010,7 @@ xlog_state_release_iclog(
 	int		sync = 0;	/* do we sync? */
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR)
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
 	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
@@ -3018,7 +3018,7 @@ xlog_state_release_iclog(
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
 	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
@@ -3135,7 +3135,7 @@ _xfs_log_force(
 	iclog = log->l_iclog;
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/* If the head iclog is not active nor dirty, we just attach
@@ -3173,7 +3173,7 @@ _xfs_log_force(
 				spin_unlock(&log->l_icloglock);
 
 				if (xlog_state_release_iclog(log, iclog))
-					return XFS_ERROR(EIO);
+					return EIO;
 
 				if (log_flushed)
 					*log_flushed = 1;
@@ -3209,7 +3209,7 @@ maybe_sleep:
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR) {
 			spin_unlock(&log->l_icloglock);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
 		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
@@ -3219,7 +3219,7 @@ maybe_sleep:
 		 * and the memory read should be atomic.
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR)
-			return XFS_ERROR(EIO);
+			return EIO;
 		if (log_flushed)
 			*log_flushed = 1;
 	} else {
@@ -3287,7 +3287,7 @@ try_again:
 	iclog = log->l_iclog;
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
 		spin_unlock(&log->l_icloglock);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	do {
@@ -3338,7 +3338,7 @@ try_again:
 			xlog_state_switch_iclogs(log, iclog, 0);
 			spin_unlock(&log->l_icloglock);
 			if (xlog_state_release_iclog(log, iclog))
-				return XFS_ERROR(EIO);
+				return EIO;
 			if (log_flushed)
 				*log_flushed = 1;
 			spin_lock(&log->l_icloglock);
@@ -3353,7 +3353,7 @@ try_again:
 			 */
 			if (iclog->ic_state & XLOG_STATE_IOERROR) {
 				spin_unlock(&log->l_icloglock);
-				return XFS_ERROR(EIO);
+				return EIO;
 			}
 			XFS_STATS_INC(xs_log_force_sleep);
 			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
@@ -3363,7 +3363,7 @@ try_again:
 			 * and the memory read should be atomic.
 			 */
 			if (iclog->ic_state & XLOG_STATE_IOERROR)
-				return XFS_ERROR(EIO);
+				return EIO;
 
 			if (log_flushed)
 				*log_flushed = 1;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 7e54553..b0cc05a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -615,7 +615,7 @@ out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
 	xlog_cil_committed(ctx, XFS_LI_ABORTED);
-	return XFS_ERROR(EIO);
+	return EIO;
 }
 
 static void
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ae82df0..1aa5a67 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -194,7 +194,7 @@ xlog_bread_noalign(
 	bp->b_error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(log->l_mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	xfs_buf_iorequest(bp);
 	error = xfs_buf_iowait(bp);
@@ -330,14 +330,14 @@ xlog_header_check_recover(
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_recover(1)",
 				 XFS_ERRLEVEL_HIGH, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	} else if (unlikely(!uuid_equal(&mp->m_sb.sb_uuid, &head->h_fs_uuid))) {
 		xfs_warn(mp,
 	"dirty log entry has mismatched uuid - can't recover");
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_recover(2)",
 				 XFS_ERRLEVEL_HIGH, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -364,7 +364,7 @@ xlog_header_check_mount(
 		xlog_header_check_dump(mp, head);
 		XFS_ERROR_REPORT("xlog_header_check_mount",
 				 XFS_ERRLEVEL_HIGH, mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -539,7 +539,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto out;
 		}
 
@@ -820,7 +820,7 @@ validate_head:
 		/* start ptr at last block ptr before head_blk */
 		if ((error = xlog_find_verify_log_record(log, start_blk,
 							&head_blk, 0)) == -1) {
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto bp_err;
 		} else if (error)
 			goto bp_err;
@@ -838,7 +838,7 @@ validate_head:
 			if ((error = xlog_find_verify_log_record(log,
 							start_blk, &new_blk,
 							(int)head_blk)) == -1) {
-				error = XFS_ERROR(EIO);
+				error = EIO;
 				goto bp_err;
 			} else if (error)
 				goto bp_err;
@@ -961,7 +961,7 @@ xlog_find_tail(
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
 		xlog_put_bp(bp);
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/* find blk_no of tail of log */
@@ -1141,7 +1141,7 @@ xlog_find_zeroed(
 		 */
 		xfs_warn(log->l_mp,
 			"Log inconsistent or not a log (last==0, first!=1)");
-		error = XFS_ERROR(EINVAL);
+		error = EINVAL;
 		goto bp_err;
 	}
 
@@ -1181,7 +1181,7 @@ xlog_find_zeroed(
 	 */
 	if ((error = xlog_find_verify_log_record(log, start_blk,
 				&last_blk, 0)) == -1) {
-	    error = XFS_ERROR(EIO);
+	    error = EIO;
 	    goto bp_err;
 	} else if (error)
 	    goto bp_err;
@@ -1354,7 +1354,7 @@ xlog_clear_stale_blocks(
 		if (unlikely(head_block < tail_block || head_block >= log->l_logBBsize)) {
 			XFS_ERROR_REPORT("xlog_clear_stale_blocks(1)",
 					 XFS_ERRLEVEL_LOW, log->l_mp);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		tail_distance = tail_block + (log->l_logBBsize - head_block);
 	} else {
@@ -1366,7 +1366,7 @@ xlog_clear_stale_blocks(
 		if (unlikely(head_block >= tail_block || head_cycle != (tail_cycle + 1))){
 			XFS_ERROR_REPORT("xlog_clear_stale_blocks(2)",
 					 XFS_ERRLEVEL_LOW, log->l_mp);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 		tail_distance = tail_block - head_block;
 	}
@@ -1551,7 +1551,7 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 		if (len == sizeof(xfs_trans_header_t))
 			xlog_recover_add_item(&trans->r_itemq);
@@ -1581,7 +1581,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -1702,7 +1702,7 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
-			error = XFS_ERROR(EIO);
+			error = EIO;
 			goto out;
 		}
 	}
@@ -1943,7 +1943,7 @@ xlog_recover_do_inode_buffer(
 				item, bp);
 			XFS_ERROR_REPORT("xlog_recover_do_inode_buf",
 					 XFS_ERRLEVEL_LOW, mp);
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 
 		buffer_nextp = (xfs_agino_t *)xfs_buf_offset(bp,
@@ -2494,7 +2494,7 @@ xlog_recover_buffer_pass2(
 	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
 			  buf_flags, NULL);
 	if (!bp)
-		return XFS_ERROR(ENOMEM);
+		return ENOMEM;
 	error = bp->b_error;
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_recover_do..(read#1)");
@@ -2917,7 +2917,7 @@ out_release:
 error:
 	if (need_free)
 		kmem_free(in_f);
-	return XFS_ERROR(error);
+	return error;
 }
 
 /*
@@ -2974,12 +2974,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/*
@@ -3005,7 +3005,7 @@ xlog_recover_dquot_pass2(
 	error = xfs_dqcheck(mp, recddq, dq_f->qlf_id, 0, XFS_QMOPT_DOWARN,
 			   "xlog_recover_dquot_pass2 (log copy)");
 	if (error)
-		return XFS_ERROR(EIO);
+		return EIO;
 	ASSERT(dq_f->qlf_len == 1);
 
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dq_f->qlf_blkno,
@@ -3026,7 +3026,7 @@ xlog_recover_dquot_pass2(
 			   "xlog_recover_dquot_pass2");
 	if (error) {
 		xfs_buf_relse(bp);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/*
@@ -3387,7 +3387,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3423,7 +3423,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 }
 
@@ -3559,7 +3559,7 @@ xlog_recover_process_data(
 
 	/* check the log format matches our own - else we can't recover */
 	if (xlog_header_check_recover(log->l_mp, rhead))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	while ((dp < lp) && num_logops) {
 		ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
@@ -3570,7 +3570,7 @@ xlog_recover_process_data(
 			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 					__func__, ohead->oh_clientid);
 			ASSERT(0);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 		tid = be32_to_cpu(ohead->oh_tid);
 		hash = XLOG_RHASH(tid);
@@ -3584,7 +3584,7 @@ xlog_recover_process_data(
 				xfs_warn(log->l_mp, "%s: bad length 0x%x",
 					__func__, be32_to_cpu(ohead->oh_len));
 				WARN_ON(1);
-				return XFS_ERROR(EIO);
+				return EIO;
 			}
 			flags = ohead->oh_flags & ~XLOG_END_TRANS;
 			if (flags & XLOG_WAS_CONT_TRANS)
@@ -3606,7 +3606,7 @@ xlog_recover_process_data(
 				xfs_warn(log->l_mp, "%s: bad transaction",
 					__func__);
 				ASSERT(0);
-				error = XFS_ERROR(EIO);
+				error = EIO;
 				break;
 			case 0:
 			case XLOG_CONTINUE_TRANS:
@@ -3617,7 +3617,7 @@ xlog_recover_process_data(
 				xfs_warn(log->l_mp, "%s: bad flag 0x%x",
 					__func__, flags);
 				ASSERT(0);
-				error = XFS_ERROR(EIO);
+				error = EIO;
 				break;
 			}
 			if (error) {
@@ -3668,7 +3668,7 @@ xlog_recover_process_efi(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip, efip->efi_format.efi_nextents);
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 	}
 
@@ -4017,14 +4017,14 @@ xlog_valid_rec_header(
 	if (unlikely(rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(1)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	if (unlikely(
 	    (!rhead->h_version ||
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
@@ -4032,12 +4032,12 @@ xlog_valid_rec_header(
 	if (unlikely( hlen <= 0 || hlen > INT_MAX )) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(2)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	if (unlikely( blkno > log->l_logBBsize || blkno > INT_MAX )) {
 		XFS_ERROR_REPORT("xlog_valid_rec_header(3)",
 				XFS_ERRLEVEL_LOW, log->l_mp);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -4414,7 +4414,7 @@ xlog_do_recover(
 
 	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
 		xfs_buf_relse(bp);
-		return XFS_ERROR(EIO);
+		return EIO;
 	}
 
 	xfs_buf_iorequest(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 993cb19..982e8c7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -76,7 +76,7 @@ xfs_uuid_mount(
 
 	if (uuid_is_nil(uuid)) {
 		xfs_warn(mp, "Filesystem has nil UUID - can't mount");
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	mutex_lock(&xfs_uuid_table_mutex);
@@ -104,7 +104,7 @@ xfs_uuid_mount(
  out_duplicate:
 	mutex_unlock(&xfs_uuid_table_mutex);
 	xfs_warn(mp, "Filesystem has duplicate UUID %pU - can't mount", uuid);
-	return XFS_ERROR(EINVAL);
+	return EINVAL;
 }
 
 STATIC void
@@ -381,7 +381,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 			xfs_warn(mp,
 		"alignment check failed: sunit/swidth vs. blocksize(%d)",
 				sbp->sb_blocksize);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		} else {
 			/*
 			 * Convert the stripe unit and width to FSBs.
@@ -391,14 +391,14 @@ xfs_update_alignment(xfs_mount_t *mp)
 				xfs_warn(mp,
 			"alignment check failed: sunit/swidth vs. agsize(%d)",
 					 sbp->sb_agblocks);
-				return XFS_ERROR(EINVAL);
+				return EINVAL;
 			} else if (mp->m_dalign) {
 				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
 			} else {
 				xfs_warn(mp,
 			"alignment check failed: sunit(%d) less than bsize(%d)",
 					 mp->m_dalign, sbp->sb_blocksize);
-				return XFS_ERROR(EINVAL);
+				return EINVAL;
 			}
 		}
 
@@ -418,7 +418,7 @@ xfs_update_alignment(xfs_mount_t *mp)
 		} else {
 			xfs_warn(mp,
 	"cannot change alignment: superblock does not support data alignment");
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
@@ -545,7 +545,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
 		xfs_warn(mp, "filesystem size mismatch detected");
-		return XFS_ERROR(EFBIG);
+		return EFBIG;
 	}
 	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
@@ -560,7 +560,7 @@ xfs_check_sizes(xfs_mount_t *mp)
 		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
 			xfs_warn(mp, "log size mismatch detected");
-			return XFS_ERROR(EFBIG);
+			return EFBIG;
 		}
 		bp = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
@@ -802,7 +802,7 @@ xfs_mountfs(
 	if (!sbp->sb_logblocks) {
 		xfs_warn(mp, "no log defined");
 		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
-		error = XFS_ERROR(EFSCORRUPTED);
+		error = EFSCORRUPTED;
 		goto out_free_perag;
 	}
 
@@ -862,7 +862,7 @@ xfs_mountfs(
 		xfs_iunlock(rip, XFS_ILOCK_EXCL);
 		XFS_ERROR_REPORT("xfs_mountfs_int(2)", XFS_ERRLEVEL_LOW,
 				 mp);
-		error = XFS_ERROR(EFSCORRUPTED);
+		error = EFSCORRUPTED;
 		goto out_rele_rip;
 	}
 	mp->m_rootip = rip;	/* save it */
@@ -1135,7 +1135,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter += delta;
 		if (lcounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_icount = lcounter;
 		return 0;
@@ -1144,7 +1144,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter += delta;
 		if (lcounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_ifree = lcounter;
 		return 0;
@@ -1174,7 +1174,7 @@ xfs_mod_incore_sb_unlocked(
 			 * blocks if were allowed to.
 			 */
 			if (!rsvd)
-				return XFS_ERROR(ENOSPC);
+				return ENOSPC;
 
 			lcounter = (long long)mp->m_resblks_avail + delta;
 			if (lcounter >= 0) {
@@ -1185,7 +1185,7 @@ xfs_mod_incore_sb_unlocked(
 				"Filesystem \"%s\": reserve blocks depleted! "
 				"Consider increasing reserve pool size.",
 				mp->m_fsname);
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		}
 
 		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);
@@ -1194,7 +1194,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter = (long long)mp->m_sb.sb_frextents;
 		lcounter += delta;
 		if (lcounter < 0) {
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		}
 		mp->m_sb.sb_frextents = lcounter;
 		return 0;
@@ -1203,7 +1203,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter += delta;
 		if (lcounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_dblocks = lcounter;
 		return 0;
@@ -1212,7 +1212,7 @@ xfs_mod_incore_sb_unlocked(
 		scounter += delta;
 		if (scounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_agcount = scounter;
 		return 0;
@@ -1221,7 +1221,7 @@ xfs_mod_incore_sb_unlocked(
 		scounter += delta;
 		if (scounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_imax_pct = scounter;
 		return 0;
@@ -1230,7 +1230,7 @@ xfs_mod_incore_sb_unlocked(
 		scounter += delta;
 		if (scounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_rextsize = scounter;
 		return 0;
@@ -1239,7 +1239,7 @@ xfs_mod_incore_sb_unlocked(
 		scounter += delta;
 		if (scounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_rbmblocks = scounter;
 		return 0;
@@ -1248,7 +1248,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter += delta;
 		if (lcounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_rblocks = lcounter;
 		return 0;
@@ -1257,7 +1257,7 @@ xfs_mod_incore_sb_unlocked(
 		lcounter += delta;
 		if (lcounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_rextents = lcounter;
 		return 0;
@@ -1266,13 +1266,13 @@ xfs_mod_incore_sb_unlocked(
 		scounter += delta;
 		if (scounter < 0) {
 			ASSERT(0);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 		mp->m_sb.sb_rextslog = scounter;
 		return 0;
 	default:
 		ASSERT(0);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 273ab51..7bf3b83 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1397,7 +1397,7 @@ xfs_qm_dqusage_adjust(
 	 */
 	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
 		*res = BULKSTAT_RV_NOTHING;
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	/*
@@ -1664,7 +1664,7 @@ xfs_qm_init_quotainos(
 			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
 					     0, 0, &uip);
 			if (error)
-				return XFS_ERROR(error);
+				return error;
 		}
 		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
@@ -1734,7 +1734,7 @@ error_rele:
 		IRELE(gip);
 	if (pip)
 		IRELE(pip);
-	return XFS_ERROR(error);
+	return error;
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index e9be63a..fa97973 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -117,7 +117,7 @@ xfs_qm_newmount(
 			(uquotaondisk ? " usrquota" : ""),
 			(gquotaondisk ? " grpquota" : ""),
 			(pquotaondisk ? " prjquota" : ""));
-		return XFS_ERROR(EPERM);
+		return EPERM;
 	}
 
 	if (XFS_IS_QUOTA_ON(mp) || quotaondisk) {
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 8b0edbd..8c77225 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -67,7 +67,7 @@ xfs_qm_scall_quotaoff(
 	 * errno == EEXIST here.
 	 */
 	if ((mp->m_qflags & flags) == 0)
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	error = 0;
 
 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
@@ -283,7 +283,7 @@ xfs_qm_scall_trunc_qfiles(
 	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0) {
 		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
 			__func__, flags, mp->m_qflags);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	if (flags & XFS_DQ_USER) {
@@ -327,7 +327,7 @@ xfs_qm_scall_quotaon(
 	if (flags == 0) {
 		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
 			__func__, mp->m_qflags);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	/* No fs can turn on quotas with a delayed effect */
@@ -350,13 +350,13 @@ xfs_qm_scall_quotaon(
 		xfs_debug(mp,
 			"%s: Can't enforce without acct, flags=%x sbflags=%x",
 			__func__, flags, mp->m_sb.sb_qflags);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	/*
 	 * If everything's up to-date incore, then don't waste time.
 	 */
 	if ((mp->m_qflags & flags) == flags)
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 
 	/*
 	 * Change sb_qflags on disk but not incore mp->qflags
@@ -371,7 +371,7 @@ xfs_qm_scall_quotaon(
 	 * There's nothing to change if it's the same.
 	 */
 	if ((qf & flags) == flags && sbflags == 0)
-		return XFS_ERROR(EEXIST);
+		return EEXIST;
 	sbflags |= XFS_SB_QFLAGS;
 
 	if ((error = xfs_qm_write_sb_changes(mp, sbflags)))
@@ -389,7 +389,7 @@ xfs_qm_scall_quotaon(
 		return 0;
 
 	if (! XFS_IS_QUOTA_RUNNING(mp))
-		return XFS_ERROR(ESRCH);
+		return ESRCH;
 
 	/*
 	 * Switch on quota enforcement in core.
@@ -849,7 +849,7 @@ xfs_qm_scall_getquota(
 	 * our utility programs are concerned.
 	 */
 	if (XFS_IS_DQUOT_UNINITIALIZED(dqp)) {
-		error = XFS_ERROR(ENOENT);
+		error = ENOENT;
 		goto out_put;
 	}
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ec5ca65..1a98a78 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -863,7 +863,7 @@ xfs_growfs_rt_alloc(
 					XFS_BMAPI_METADATA, &firstblock,
 					resblks, &map, &nmap, &flist);
 		if (!error && nmap < 1)
-			error = XFS_ERROR(ENOSPC);
+			error = ENOSPC;
 		if (error)
 			goto error_cancel;
 		/*
@@ -903,7 +903,7 @@ xfs_growfs_rt_alloc(
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 				mp->m_bsize, 0);
 			if (bp == NULL) {
-				error = XFS_ERROR(EIO);
+				error = EIO;
 error_cancel:
 				xfs_trans_cancel(tp, cancelflags);
 				goto error;
@@ -962,11 +962,11 @@ xfs_growfs_rt(
 	 * Initial error checking.
 	 */
 	if (!capable(CAP_SYS_ADMIN))
-		return XFS_ERROR(EPERM);
+		return EPERM;
 	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
 	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
 	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
 		return error;
 	/*
@@ -1001,7 +1001,7 @@ xfs_growfs_rt(
 	 * since we'll log basically the whole summary file at once.
 	 */
 	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	/*
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
@@ -1247,7 +1247,7 @@ xfs_rtmount_init(
 	if (mp->m_rtdev_targp == NULL) {
 		xfs_warn(mp,
 	"Filesystem has a realtime volume, use rtdev=device option");
-		return XFS_ERROR(ENODEV);
+		return ENODEV;
 	}
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
 	mp->m_rsumsize =
@@ -1263,7 +1263,7 @@ xfs_rtmount_init(
 		xfs_warn(mp, "realtime mount -- %llu != %llu",
 			(unsigned long long) XFS_BB_TO_FSB(mp, d),
 			(unsigned long long) mp->m_sb.sb_rblocks);
-		return XFS_ERROR(EFBIG);
+		return EFBIG;
 	}
 	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 0c0e41b..fd195ff 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -186,13 +186,13 @@ xfs_mount_validate_sb(
 	 */
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		xfs_warn(mp, "bad magic number");
-		return XFS_ERROR(EWRONGFS);
+		return EWRONGFS;
 	}
 
 
 	if (!xfs_sb_good_version(sbp)) {
 		xfs_warn(mp, "bad version");
-		return XFS_ERROR(EWRONGFS);
+		return EWRONGFS;
 	}
 
 	/*
@@ -224,7 +224,7 @@ xfs_mount_validate_sb(
 				xfs_warn(mp,
 "Attempted to mount read-only compatible filesystem read-write.\n"
 "Filesystem can only be safely mounted read only.");
-				return XFS_ERROR(EINVAL);
+				return EINVAL;
 			}
 		}
 		if (xfs_sb_has_incompat_feature(sbp,
@@ -234,7 +234,7 @@ xfs_mount_validate_sb(
 "Filesystem can not be safely mounted by this kernel.",
 				(sbp->sb_features_incompat &
 						XFS_SB_FEAT_INCOMPAT_UNKNOWN));
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 	}
 
@@ -242,13 +242,13 @@ xfs_mount_validate_sb(
 		if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
 			xfs_notice(mp,
 			   "Version 5 of Super block has XFS_OQUOTA bits.");
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 		}
 	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
 				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
 			xfs_notice(mp,
 "Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
-			return XFS_ERROR(EFSCORRUPTED);
+			return EFSCORRUPTED;
 	}
 
 	if (unlikely(
@@ -256,7 +256,7 @@ xfs_mount_validate_sb(
 		xfs_warn(mp,
 		"filesystem is marked as having an external log; "
 		"specify logdev on the mount command line.");
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	if (unlikely(
@@ -264,7 +264,7 @@ xfs_mount_validate_sb(
 		xfs_warn(mp,
 		"filesystem is marked as having an internal log; "
 		"do not specify logdev on the mount command line.");
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	/*
@@ -297,7 +297,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
 	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
 		xfs_notice(mp, "SB sanity check failed");
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	/*
@@ -308,7 +308,7 @@ xfs_mount_validate_sb(
 		"File system with blocksize %d bytes. "
 		"Only pagesize (%ld) or less will currently work.",
 				sbp->sb_blocksize, PAGE_SIZE);
-		return XFS_ERROR(ENOSYS);
+		return ENOSYS;
 	}
 
 	/*
@@ -323,19 +323,19 @@ xfs_mount_validate_sb(
 	default:
 		xfs_warn(mp, "inode size of %d bytes not supported",
 				sbp->sb_inodesize);
-		return XFS_ERROR(ENOSYS);
+		return ENOSYS;
 	}
 
 	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
 		xfs_warn(mp,
 		"file system too large to be mounted on this system.");
-		return XFS_ERROR(EFBIG);
+		return EFBIG;
 	}
 
 	if (check_inprogress && sbp->sb_inprogress) {
 		xfs_warn(mp, "Offline file system operation in progress!");
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	/*
@@ -343,7 +343,7 @@ xfs_mount_validate_sb(
 	 */
 	if (unlikely(!xfs_sb_version_hasdirv2(sbp))) {
 		xfs_warn(mp, "file system using version 1 directory format");
-		return XFS_ERROR(ENOSYS);
+		return ENOSYS;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2053767..527bb0c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -446,7 +446,7 @@ done:
 	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
 		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
 			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 	if (mp->m_logbsize != -1 &&
 	    mp->m_logbsize !=  0 &&
@@ -456,7 +456,7 @@ done:
 		xfs_warn(mp,
 			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
 			mp->m_logbsize);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	if (iosizelog) {
@@ -465,7 +465,7 @@ done:
 			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
 				iosizelog, XFS_MIN_IO_LOG,
 				XFS_MAX_IO_LOG);
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
@@ -1341,14 +1341,14 @@ xfs_finish_flags(
 			   mp->m_logbsize < mp->m_sb.sb_logsunit) {
 			xfs_warn(mp,
 		"logbuf size must be greater than or equal to log stripe size");
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 	} else {
 		/* Fail a mount if the logbuf is larger than 32K */
 		if (mp->m_logbsize > XLOG_BIG_RECORD_BSIZE) {
 			xfs_warn(mp,
 		"logbuf size for version 1 logs must be 16K or 32K");
-			return XFS_ERROR(EINVAL);
+			return EINVAL;
 		}
 	}
 
@@ -1360,7 +1360,7 @@ xfs_finish_flags(
 		xfs_warn(mp,
 "Cannot mount a V5 filesystem as %s. %s is always enabled for V5 filesystems.",
 			MNTOPT_NOATTR2, MNTOPT_ATTR2);
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	/*
@@ -1377,7 +1377,7 @@ xfs_finish_flags(
 	if ((mp->m_sb.sb_flags & XFS_SBF_READONLY) && !ronly) {
 		xfs_warn(mp,
 			"cannot mount a read-only filesystem as read-write");
-		return XFS_ERROR(EROFS);
+		return EROFS;
 	}
 
 	if ((mp->m_qflags & (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE)) &&
@@ -1385,7 +1385,7 @@ xfs_finish_flags(
 	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
 		xfs_warn(mp,
 		  "Super block does not support project and group quota together");
-		return XFS_ERROR(EINVAL);
+		return EINVAL;
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 52979aa..0f4f30d 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -75,7 +75,7 @@ xfs_readlink_bmap(
 		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
 				  &xfs_symlink_buf_ops);
 		if (!bp)
-			return XFS_ERROR(ENOMEM);
+			return ENOMEM;
 		error = bp->b_error;
 		if (error) {
 			xfs_buf_ioerror_alert(bp, __func__);
@@ -134,7 +134,7 @@ xfs_readlink(
 	trace_xfs_readlink(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
@@ -147,7 +147,7 @@ xfs_readlink(
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		error = XFS_ERROR(EFSCORRUPTED);
+		error = EFSCORRUPTED;
 		goto out;
 	}
 
@@ -202,14 +202,14 @@ xfs_symlink(
 	trace_xfs_symlink(dp, link_name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	/*
 	 * Check component lengths of the target path name.
 	 */
 	pathlen = strlen(target_path);
 	if (pathlen >= MAXPATHLEN)      /* total string too long */
-		return XFS_ERROR(ENAMETOOLONG);
+		return ENAMETOOLONG;
 
 	udqp = gdqp = NULL;
 	prid = xfs_get_initial_prid(dp);
@@ -253,7 +253,7 @@ xfs_symlink(
 	 * Check whether the directory allows new symlinks or not.
 	 */
 	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
-		error = XFS_ERROR(EPERM);
+		error = EPERM;
 		goto error_return;
 	}
 
@@ -561,7 +561,7 @@ xfs_inactive_symlink(
 	trace_xfs_inactive_symlink(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -579,7 +579,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
-		return XFS_ERROR(EFSCORRUPTED);
+		return EFSCORRUPTED;
 	}
 
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f13452c..b701470 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -190,7 +190,7 @@ xfs_trans_reserve(
 					  -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
-			return XFS_ERROR(ENOSPC);
+			return ENOSPC;
 		}
 		tp->t_blk_res += blocks;
 	}
@@ -241,7 +241,7 @@ xfs_trans_reserve(
 		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
 					  -((int64_t)rtextents), rsvd);
 		if (error) {
-			error = XFS_ERROR(ENOSPC);
+			error = ENOSPC;
 			goto undo_log;
 		}
 		tp->t_rtx_res += rtextents;
@@ -874,7 +874,7 @@ xfs_trans_commit(
 		goto out_unreserve;
 
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = XFS_ERROR(EIO);
+		error = EIO;
 		goto out_unreserve;
 	}
 
@@ -917,7 +917,7 @@ out_unreserve:
 	if (tp->t_ticket) {
 		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, log_flags);
 		if (commit_lsn == -1 && !error)
-			error = XFS_ERROR(EIO);
+			error = EIO;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_FSTRANS);
 	xfs_trans_free_items(tp, NULLCOMMITLSN, error ? XFS_TRANS_ABORT : 0);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 73106f2..d35430f 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -267,7 +267,7 @@ xfs_trans_read_buf_map(
 		bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
 		if (!bp)
 			return (flags & XBF_TRYLOCK) ?
-					EAGAIN : XFS_ERROR(ENOMEM);
+					EAGAIN : ENOMEM;
 
 		if (bp->b_error) {
 			error = bp->b_error;
@@ -287,7 +287,7 @@ xfs_trans_read_buf_map(
 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
 					xfs_buf_relse(bp);
 					xfs_debug(mp, "Returning error!");
-					return XFS_ERROR(EIO);
+					return EIO;
 				}
 			}
 		}
@@ -355,7 +355,7 @@ xfs_trans_read_buf_map(
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 			*bpp = NULL;
-			return XFS_ERROR(EIO);
+			return EIO;
 		}
 
 
@@ -372,7 +372,7 @@ xfs_trans_read_buf_map(
 	if (bp == NULL) {
 		*bpp = NULL;
 		return (flags & XBF_TRYLOCK) ?
-					0 : XFS_ERROR(ENOMEM);
+					0 : ENOMEM;
 	}
 	if (bp->b_error) {
 		error = bp->b_error;
@@ -396,7 +396,7 @@ xfs_trans_read_buf_map(
 						   SHUTDOWN_META_IO_ERROR);
 				xfs_buf_relse(bp);
 				xfs_debug(mp, "Returning trans error!");
-				return XFS_ERROR(EIO);
+				return EIO;
 			}
 		}
 	}
@@ -414,7 +414,7 @@ shutdown_abort:
 	trace_xfs_trans_read_buf_shut(bp, _RET_IP_);
 	xfs_buf_relse(bp);
 	*bpp = NULL;
-	return XFS_ERROR(EIO);
+	return EIO;
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
