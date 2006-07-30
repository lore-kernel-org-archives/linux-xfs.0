Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 20:41:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6U3fVDW028897
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 20:41:31 -0700
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id A79FC18DE2F33
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 22:41:06 -0500 (CDT)
Message-ID: <44CC2A55.6030207@sandeen.net>
Date: Sat, 29 Jul 2006 22:41:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] kill no-op buf macros
Content-Type: multipart/mixed;
 boundary="------------060303000702070608060508"
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060303000702070608060508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It looks like these macros are not particularly interesting... this patch kills 
them.

#define XFS_BUF_BUSY(bp)	do { } while (0)
#define XFS_BUF_ISBUSY(bp)	(1)
#define XFS_BUF_SHUT(bp)	do { } while (0)
#define XFS_BUF_UNSHUT(bp)	do { } while (0)
#define XFS_BUF_ISSHUT(bp)	(0)
#define XFS_BUF_ISUNINITIAL(bp)	(0)
#define XFS_BUF_BP_ISMAPPED(bp)	(1)
#define XFS_BUF_SET_START(bp)			do { } while (0)
#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
#define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
#define XFS_BUF_SET_REF(bp, ref)		do { } while (0)

Thanks,

-Eric

--------------060303000702070608060508
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="kill-buf-macros"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-buf-macros"

 linux-2.6/xfs_buf.h |   16 ----------------
 quota/xfs_dquot.c   |    7 -------
 xfs_alloc.c         |    2 --
 xfs_btree.c         |   13 -------------
 xfs_buf_item.c      |   20 +-------------------
 xfs_da_btree.c      |    9 ---------
 xfs_ialloc.c        |    1 -
 xfs_inode.c         |   13 -------------
 xfs_log.c           |    4 ----
 xfs_log_recover.c   |    2 --
 xfs_mount.c         |    2 --
 xfs_trans_buf.c     |    9 ---------
 12 files changed, 1 insertion(+), 97 deletions(-)

Signed-Off-By: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux-killwantfuncs/linux-2.6/xfs_buf.h
===================================================================
--- xfs-linux-killwantfuncs.orig/linux-2.6/xfs_buf.h
+++ xfs-linux-killwantfuncs/linux-2.6/xfs_buf.h
@@ -274,9 +274,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_UNDONE(bp)	((bp)->b_flags &= ~XBF_DONE)
 #define XFS_BUF_ISDONE(bp)	((bp)->b_flags & XBF_DONE)
 
-#define XFS_BUF_BUSY(bp)	do { } while (0)
-#define XFS_BUF_ISBUSY(bp)	(1)
-
 #define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
 #define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
 #define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
@@ -284,10 +281,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_ORDERED(bp)	((bp)->b_flags |= XBF_ORDERED)
 #define XFS_BUF_UNORDERED(bp)	((bp)->b_flags &= ~XBF_ORDERED)
 
-#define XFS_BUF_SHUT(bp)	do { } while (0)
-#define XFS_BUF_UNSHUT(bp)	do { } while (0)
-#define XFS_BUF_ISSHUT(bp)	(0)
-
 #define XFS_BUF_HOLD(bp)	xfs_buf_hold(bp)
 #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
 #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
@@ -296,10 +289,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
 #define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
 
-#define XFS_BUF_ISUNINITIAL(bp)	(0)
-
-#define XFS_BUF_BP_ISMAPPED(bp)	(1)
-
 #define XFS_BUF_IODONE_FUNC(bp)			((bp)->b_iodone)
 #define XFS_BUF_SET_IODONE_FUNC(bp, func)	((bp)->b_iodone = (func))
 #define XFS_BUF_CLR_IODONE_FUNC(bp)		((bp)->b_iodone = NULL)
@@ -312,7 +301,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_SET_FSPRIVATE2(bp, val)		((bp)->b_fspriv2 = (void*)(val))
 #define XFS_BUF_FSPRIVATE3(bp, type)		((type)(bp)->b_fspriv3)
 #define XFS_BUF_SET_FSPRIVATE3(bp, val)		((bp)->b_fspriv3 = (void*)(val))
-#define XFS_BUF_SET_START(bp)			do { } while (0)
 #define XFS_BUF_SET_BRELSE_FUNC(bp, func)	((bp)->b_relse = (func))
 
 #define XFS_BUF_PTR(bp)			(xfs_caddr_t)((bp)->b_addr)
@@ -323,10 +311,6 @@ extern void xfs_buf_trace(xfs_buf_t *, c
 #define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
 
-#define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	do { } while (0)
-#define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
-#define XFS_BUF_SET_REF(bp, ref)		do { } while (0)
-
 #define XFS_BUF_ISPINNED(bp)	xfs_buf_ispin(bp)
 
 #define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
Index: xfs-linux-killwantfuncs/quota/xfs_dquot.c
===================================================================
--- xfs-linux-killwantfuncs.orig/quota/xfs_dquot.c
+++ xfs-linux-killwantfuncs/quota/xfs_dquot.c
@@ -369,7 +369,6 @@ xfs_qm_init_dquot_blk(
 	int		curid, i;
 
 	ASSERT(tp);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
@@ -609,7 +608,6 @@ xfs_qm_dqtobp(
 		if (error || !bp)
 			return XFS_ERROR(error);
 	}
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	/*
@@ -627,7 +625,6 @@ xfs_qm_dqtobp(
 			xfs_trans_brelse(tp, bp);
 			return XFS_ERROR(EIO);
 		}
-		XFS_BUF_BUSY(bp); /* We dirtied this */
 	}
 
 	*O_bpp = bp;
@@ -680,9 +677,6 @@ xfs_qm_dqread(
 	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
 	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
 
-	/* Mark the buf so that this will stay incore a little longer */
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_DQUOT, XFS_DQUOT_REF);
-
 	/*
 	 * We got the buffer with a xfs_trans_read_buf() (in dqtobp())
 	 * So we need to release with xfs_trans_brelse().
@@ -695,7 +689,6 @@ xfs_qm_dqread(
 	 * this particular dquot was repaired. We still aren't afraid to
 	 * brelse it because we have the changes incore.
 	 */
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	xfs_trans_brelse(tp, bp);
 
Index: xfs-linux-killwantfuncs/xfs_alloc.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_alloc.c
+++ xfs-linux-killwantfuncs/xfs_alloc.c
@@ -409,7 +409,6 @@ xfs_alloc_read_agfl(
 		return error;
 	ASSERT(bp);
 	ASSERT(!XFS_BUF_GETERROR(bp));
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGFL, XFS_AGFL_REF);
 	*bpp = bp;
 	return 0;
 }
@@ -2206,7 +2205,6 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGF, XFS_AGF_REF);
 	*bpp = bp;
 	return 0;
 }
Index: xfs-linux-killwantfuncs/xfs_btree.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_btree.c
+++ xfs-linux-killwantfuncs/xfs_btree.c
@@ -759,9 +759,6 @@ xfs_btree_read_bufl(
 		return error;
 	}
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (bp != NULL) {
-		XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
-	}
 	*bpp = bp;
 	return 0;
 }
@@ -792,16 +789,6 @@ xfs_btree_read_bufs(
 		return error;
 	}
 	ASSERT(!bp || !XFS_BUF_GETERROR(bp));
-	if (bp != NULL) {
-		switch (refval) {
-		case XFS_ALLOC_BTREE_REF:
-			XFS_BUF_SET_VTYPE_REF(bp, B_FS_MAP, refval);
-			break;
-		case XFS_INO_BTREE_REF:
-			XFS_BUF_SET_VTYPE_REF(bp, B_FS_INOMAP, refval);
-			break;
-		}
-	}
 	*bpp = bp;
 	return 0;
 }
Index: xfs-linux-killwantfuncs/xfs_buf_item.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_buf_item.c
+++ xfs-linux-killwantfuncs/xfs_buf_item.c
@@ -234,7 +234,6 @@ xfs_buf_item_format(
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
 	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_BP_ISMAPPED(bp));
 	vecp = log_vector;
 
 	/*
@@ -351,7 +350,6 @@ xfs_buf_item_pin(
 	xfs_buf_t	*bp;
 
 	bp = bip->bli_buf;
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	ASSERT((bip->bli_flags & XFS_BLI_LOGGED) ||
 	       (bip->bli_flags & XFS_BLI_STALE));
@@ -901,7 +899,6 @@ xfs_buf_item_relse(
 	XFS_BUF_SET_FSPRIVATE(bp, bip->bli_item.li_bio_list);
 	if ((XFS_BUF_FSPRIVATE(bp, void *) == NULL) &&
 	    (XFS_BUF_IODONE_FUNC(bp) != NULL)) {
-		ASSERT((XFS_BUF_ISUNINITIAL(bp)) == 0);
 		XFS_BUF_CLR_IODONE_FUNC(bp);
 	}
 
@@ -936,7 +933,6 @@ xfs_buf_attach_iodone(
 {
 	xfs_log_item_t	*head_lip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	lip->li_cb = cb;
@@ -1008,20 +1004,7 @@ xfs_buf_iodone_callbacks(
 			xfs_buf_do_callbacks(bp, lip);
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
-
-			/*
-			 * XFS_SHUT flag gets set when we go thru the
-			 * entire buffer cache and deliberately start
-			 * throwing away delayed write buffers.
-			 * Since there's no biowait done on those,
-			 * we should just brelse them.
-			 */
-			if (XFS_BUF_ISSHUT(bp)) {
-			    XFS_BUF_UNSHUT(bp);
-				xfs_buf_relse(bp);
-			} else {
-				xfs_biodone(bp);
-			}
+			xfs_biodone(bp);
 
 			return;
 		}
@@ -1051,7 +1034,6 @@ xfs_buf_iodone_callbacks(
 			if (!(XFS_BUF_ISSTALE(bp))) {
 				XFS_BUF_DELAYWRITE(bp);
 				XFS_BUF_DONE(bp);
-				XFS_BUF_SET_START(bp);
 			}
 			ASSERT(XFS_BUF_IODONE_FUNC(bp));
 			xfs_buftrace("BUF_IODONE ASYNC", bp);
Index: xfs-linux-killwantfuncs/xfs_da_btree.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_da_btree.c
+++ xfs-linux-killwantfuncs/xfs_da_btree.c
@@ -2033,15 +2033,6 @@ xfs_da_do_buf(
 		}
 		if (!bp)
 			continue;
-		if (caller == 1) {
-			if (whichfork == XFS_ATTR_FORK) {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_ATTR_BTREE,
-						XFS_ATTR_BTREE_REF);
-			} else {
-				XFS_BUF_SET_VTYPE_REF(bp, B_FS_DIR_BTREE,
-						XFS_DIR_BTREE_REF);
-			}
-		}
 		if (bplist) {
 			bplist[nbplist++] = bp;
 		}
Index: xfs-linux-killwantfuncs/xfs_ialloc.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_ialloc.c
+++ xfs-linux-killwantfuncs/xfs_ialloc.c
@@ -1405,7 +1405,6 @@ xfs_ialloc_read_agi(
 	}
 #endif
 
-	XFS_BUF_SET_VTYPE_REF(bp, B_FS_AGI, XFS_AGI_REF);
 	*bpp = bp;
 	return 0;
 }
Index: xfs-linux-killwantfuncs/xfs_inode.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_inode.c
+++ xfs-linux-killwantfuncs/xfs_inode.c
@@ -369,11 +369,6 @@ xfs_itobp(
 	xfs_inobp_check(mp, bp);
 
 	/*
-	 * Mark the buffer as an inode buffer now that it looks good
-	 */
-	XFS_BUF_SET_VTYPE(bp, B_FS_INO);
-
-	/*
 	 * Set *dipp to point to the on-disk inode in the buffer.
 	 */
 	*dipp = (xfs_dinode_t *)xfs_buf_offset(bp, imap.im_boffset);
@@ -978,13 +973,6 @@ xfs_iread(
 	ip->i_delayed_blks = 0;
 
 	/*
-	 * Mark the buffer containing the inode as something to keep
-	 * around for a while.  This helps to keep recently accessed
-	 * meta-data in-core longer.
-	 */
-	 XFS_BUF_SET_REF(bp, XFS_INO_REF);
-
-	/*
 	 * Use xfs_trans_brelse() to release the buffer containing the
 	 * on-disk inode, because it was acquired with xfs_trans_read_buf()
 	 * in xfs_itobp() above.  If tp is NULL, this is just a normal
@@ -3233,7 +3221,6 @@ cluster_corrupt_out:
 			XFS_BUF_CLR_BDSTRAT_FUNC(bp);
 			XFS_BUF_UNDONE(bp);
 			XFS_BUF_STALE(bp);
-			XFS_BUF_SHUT(bp);
 			XFS_BUF_ERROR(bp,EIO);
 			xfs_biodone(bp);
 		} else {
Index: xfs-linux-killwantfuncs/xfs_log.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_log.c
+++ xfs-linux-killwantfuncs/xfs_log.c
@@ -1169,7 +1169,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 	XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	log->l_xbuf = bp;
 
@@ -1224,7 +1223,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_callback_tail = &(iclog->ic_callback);
 		iclog->ic_datap = (char *)iclog->hic_data + log->l_iclog_hsize;
 
-		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
 		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
 		sv_init(&iclog->ic_forcesema, SV_DEFAULT, "iclog-force");
 		sv_init(&iclog->ic_writesema, SV_DEFAULT, "iclog-write");
@@ -1430,7 +1428,6 @@ xlog_sync(xlog_t		*log,
 	}
 	XFS_BUF_SET_PTR(bp, (xfs_caddr_t) &(iclog->ic_header), count);
 	XFS_BUF_SET_FSPRIVATE(bp, iclog);	/* save for later */
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	/*
 	 * Do an ordered write for the log block.
@@ -1468,7 +1465,6 @@ xlog_sync(xlog_t		*log,
 		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
 					    (__psint_t)count), split);
 		XFS_BUF_SET_FSPRIVATE(bp, iclog);
-		XFS_BUF_BUSY(bp);
 		XFS_BUF_ASYNC(bp);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			XFS_BUF_ORDERED(bp);
Index: xfs-linux-killwantfuncs/xfs_log_recover.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_log_recover.c
+++ xfs-linux-killwantfuncs/xfs_log_recover.c
@@ -115,7 +115,6 @@ xlog_bread(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_READ(bp);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
@@ -150,7 +149,6 @@ xlog_bwrite(
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
 	XFS_BUF_ZEROFLAGS(bp);
-	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
 	XFS_BUF_PSEMA(bp, PRIBIO);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
Index: xfs-linux-killwantfuncs/xfs_mount.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_mount.c
+++ xfs-linux-killwantfuncs/xfs_mount.c
@@ -499,7 +499,6 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 		error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
 		goto fail;
 	}
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	/*
@@ -541,7 +540,6 @@ xfs_readsb(xfs_mount_t *mp, int flags)
 			error = bp ? XFS_BUF_GETERROR(bp) : ENOMEM;
 			goto fail;
 		}
-		ASSERT(XFS_BUF_ISBUSY(bp));
 		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 	}
 
Index: xfs-linux-killwantfuncs/xfs_trans_buf.c
===================================================================
--- xfs-linux-killwantfuncs.orig/xfs_trans_buf.c
+++ xfs-linux-killwantfuncs/xfs_trans_buf.c
@@ -649,7 +649,6 @@ xfs_trans_bjoin(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
 
 	/*
@@ -694,7 +693,6 @@ xfs_trans_bhold(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -716,7 +714,6 @@ xfs_trans_bhold_release(xfs_trans_t	*tp,
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -747,7 +744,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	xfs_buf_log_item_t	*bip;
 	xfs_log_item_desc_t	*lidp;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT((first <= last) && (last < XFS_BUF_COUNT(bp)));
@@ -824,7 +820,6 @@ xfs_trans_binval(
 	xfs_log_item_desc_t	*lidp;
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -902,7 +897,6 @@ xfs_trans_inode_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -928,7 +922,6 @@ xfs_trans_stale_inode_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -958,7 +951,6 @@ xfs_trans_inode_alloc_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 
@@ -988,7 +980,6 @@ xfs_trans_dquot_buf(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 	ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 	ASSERT(type == XFS_BLI_UDQUOT_BUF ||

--------------060303000702070608060508--
