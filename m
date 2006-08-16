Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 21:30:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G4TpDW007339
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 21:30:03 -0700
Date: Wed, 16 Aug 2006 14:28:01 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fsblock zero - don't panic
Message-ID: <20060816142800.D2762042@wobbly.melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com> <20060811032626.GF50254148@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060811032626.GF50254148@melbourne.sgi.com>; from dgc@sgi.com on Fri, Aug 11, 2006 at 01:26:26PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 11, 2006 at 01:26:26PM +1000, David Chinner wrote:
> ...
> Looks OK.

Thanks mate.

> ...
> If you are hinting this branch to be unlikely, then we should also
> check the start block first before checking the io_flags.  We only
> need to check the io_flags if we are actually accessing block zero.

I've rolled this into a new version.  I also got prodded to still
provide an option to panic on detecting this, for debugging - so I
rewrote this to report through the panic_mask mechanism, which now
gives us the option to optionally panic if need be... could you do
a second pass over this for me?

cheers.

-- 
Nathan


Index: xfs-linux/xfs_bmap.c
===================================================================
--- xfs-linux.orig/xfs_bmap.c	2006-08-15 15:22:53.198187750 +1000
+++ xfs-linux/xfs_bmap.c	2006-08-16 12:40:49.669518000 +1000
@@ -3705,7 +3705,7 @@ STATIC xfs_bmbt_rec_t *                 
 xfs_bmap_search_extents(
 	xfs_inode_t     *ip,            /* incore inode pointer */
 	xfs_fileoff_t   bno,            /* block number searched for */
-	int             whichfork,      /* data or attr fork */
+	int             fork,      	/* data or attr fork */
 	int             *eofp,          /* out: end of file found */
 	xfs_extnum_t    *lastxp,        /* out: last extent index */
 	xfs_bmbt_irec_t *gotp,          /* out: extent entry found */
@@ -3713,25 +3713,28 @@ xfs_bmap_search_extents(
 {
 	xfs_ifork_t	*ifp;		/* inode fork pointer */
 	xfs_bmbt_rec_t  *ep;            /* extent record pointer */
-	int		rt;		/* realtime flag    */
 
 	XFS_STATS_INC(xs_look_exlist);
-	ifp = XFS_IFORK_PTR(ip, whichfork);
+	ifp = XFS_IFORK_PTR(ip, fork);
 
 	ep = xfs_bmap_search_multi_extents(ifp, bno, eofp, lastxp, gotp, prevp);
 
-	rt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
-	if (unlikely(!rt && !gotp->br_startblock && (*lastxp != NULLEXTNUM))) {
-                cmn_err(CE_PANIC,"Access to block zero: fs: <%s> inode: %lld "
-			"start_block : %llx start_off : %llx blkcnt : %llx "
-			"extent-state : %x \n",
-			(ip->i_mount)->m_fsname, (long long)ip->i_ino,
+	if (unlikely(!(gotp->br_startblock) && (*lastxp != NULLEXTNUM) &&
+		     !(XFS_IS_REALTIME_INODE(ip) && fork == XFS_DATA_FORK))) {
+		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
+				"Access to block zero in inode %llu "
+				"start_block: %llx start_off: %llx "
+				"blkcnt: %llx extent-state: %x lastx: %x\n",
+			(unsigned long long)ip->i_ino,
 			(unsigned long long)gotp->br_startblock,
 			(unsigned long long)gotp->br_startoff,
 			(unsigned long long)gotp->br_blockcount,
-			gotp->br_state);
-        }
-        return ep;
+			gotp->br_state, *lastxp);
+		*lastxp = NULLEXTNUM;
+		*eofp = 1;
+		return NULL;
+	}
+	return ep;
 }
 
 
Index: xfs-linux/xfs_iomap.c
===================================================================
--- xfs-linux.orig/xfs_iomap.c	2006-08-15 15:22:53.238190250 +1000
+++ xfs-linux/xfs_iomap.c	2006-08-16 12:40:41.385000250 +1000
@@ -536,23 +536,27 @@ xfs_iomap_write_direct(
 	 * Copy any maps to caller's array and return any error.
 	 */
 	if (nimaps == 0) {
-		error = (ENOSPC);
+		error = ENOSPC;
 		goto error_out;
 	}
 
-	*ret_imap = imap;
-	*nmaps = 1;
-	if ( !(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
-                cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: %lld "
-                        "start_block : %llx start_off : %llx blkcnt : %llx "
-                        "extent-state : %x \n",
-                        (ip->i_mount)->m_fsname,
-                        (long long)ip->i_ino,
-                        (unsigned long long)ret_imap->br_startblock,
+	if (unlikely(!ret_imap->br_startblock &&
+		     !(io->io_flags & XFS_IOCORE_RT))) {
+		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
+				"Access to block zero in inode %llu "
+				"start_block: %llx start_off: %llx "
+				"blkcnt: %llx extent-state: %x\n",
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ret_imap->br_startblock,
 			(unsigned long long)ret_imap->br_startoff,
-                        (unsigned long long)ret_imap->br_blockcount,
+			(unsigned long long)ret_imap->br_blockcount,
 			ret_imap->br_state);
-        }
+		error = EFSCORRUPTED;
+		goto error_out;
+	}
+
+	*ret_imap = imap;
+	*nmaps = 1;
 	return 0;
 
 error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
@@ -715,16 +719,18 @@ retry:
 		goto retry;
 	}
 
-	if (!(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {
-		cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: %lld "
-                        "start_block : %llx start_off : %llx blkcnt : %llx "
-                        "extent-state : %x \n",
-                        (ip->i_mount)->m_fsname,
-                        (long long)ip->i_ino,
-                        (unsigned long long)ret_imap->br_startblock,
+	if (unlikely(!ret_imap->br_startblock &&
+		     !(io->io_flags & XFS_IOCORE_RT))) {
+		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
+				"Access to block zero in inode %llu "
+				"start_block: %llx start_off: %llx "
+				"blkcnt: %llx extent-state: %x\n",
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ret_imap->br_startblock,
 			(unsigned long long)ret_imap->br_startoff,
-                        (unsigned long long)ret_imap->br_blockcount,
+			(unsigned long long)ret_imap->br_blockcount,
 			ret_imap->br_state);
+		return XFS_ERROR(EFSCORRUPTED);
 	}
 
 	*ret_imap = imap[0];
@@ -855,16 +861,14 @@ xfs_iomap_write_allocate(
 		 * See if we were able to allocate an extent that
 		 * covers at least part of the callers request
 		 */
-
 		for (i = 0; i < nimaps; i++) {
-			if (!(io->io_flags & XFS_IOCORE_RT)  &&
-			    !imap[i].br_startblock) {
-				cmn_err(CE_PANIC,"Access to block zero:  "
-					"fs <%s> inode: %lld "
-					"start_block : %llx start_off : %llx "
-					"blkcnt : %llx extent-state : %x \n",
-					(ip->i_mount)->m_fsname,
-					(long long)ip->i_ino,
+			if (unlikely(!imap[i].br_startblock &&
+				     !(io->io_flags & XFS_IOCORE_RT))) {
+				xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, mp,
+					"Access to block zero in inode %llu "
+					"start_block: %llx start_off: %llx "
+					"blkcnt: %llx extent-state: %x\n",
+					(unsigned long long)ip->i_ino,
 					(unsigned long long)
 						imap[i].br_startblock,
 					(unsigned long long)
@@ -872,7 +876,8 @@ xfs_iomap_write_allocate(
 					(unsigned long long)
 				        	imap[i].br_blockcount,
 					imap[i].br_state);
-                        }
+				return XFS_ERROR(EFSCORRUPTED);
+			}
 			if ((offset_fsb >= imap[i].br_startoff) &&
 			    (offset_fsb < (imap[i].br_startoff +
 					   imap[i].br_blockcount))) {
@@ -951,7 +956,7 @@ xfs_iomap_write_unwritten(
 		}
 		if (error) {
 			xfs_trans_cancel(tp, 0);
-			goto error0;
+			return XFS_ERROR(error);
 		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -977,19 +982,21 @@ xfs_iomap_write_unwritten(
 		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES, NULL);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
-			goto error0;
+			return XFS_ERROR(error);
 
-		if ( !(io->io_flags & XFS_IOCORE_RT)  && !imap.br_startblock) {
-			cmn_err(CE_PANIC,"Access to block zero:  fs <%s> "
-				"inode: %lld start_block : %llx start_off : "
-				"%llx blkcnt : %llx extent-state : %x \n",
-				(ip->i_mount)->m_fsname,
-				(long long)ip->i_ino,
+		if (unlikely(!imap.br_startblock &&
+			     !(io->io_flags & XFS_IOCORE_RT))) {
+				xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, mp,
+					"Access to block zero in inode %llu "
+					"start_block: %llx start_off: %llx "
+					"blkcnt: %llx extent-state: %x\n",
+				(unsigned long long)ip->i_ino,
 				(unsigned long long)imap.br_startblock,
 				(unsigned long long)imap.br_startoff,
 				(unsigned long long)imap.br_blockcount,
 				imap.br_state);
-        	}
+			return XFS_ERROR(EFSCORRUPTED);
+		}
 
 		if ((numblks_fsb = imap.br_blockcount) == 0) {
 			/*
@@ -1009,6 +1016,5 @@ error_on_bmapi_transaction:
 	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp, (XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-error0:
 	return XFS_ERROR(error);
 }
Index: xfs-linux/linux-2.4/xfs_globals.c
===================================================================
--- xfs-linux.orig/linux-2.4/xfs_globals.c	2006-08-16 11:35:46.090456000 +1000
+++ xfs-linux/linux-2.4/xfs_globals.c	2006-08-16 11:35:51.546797000 +1000
@@ -37,7 +37,7 @@ xfs_param_t xfs_params = {
 	.restrict_chown	= {	0,	1,	1	},
 	.sgid_inherit	= {	0,	0,	1	},
 	.symlink_mode	= {	0,	0,	1	},
-	.panic_mask	= {	0,	0,	127	},
+	.panic_mask	= {	0,	0,	255	},
 	.error_level	= {	0,	3,	11	},
 	.syncd_timer	= {	1*100,	30*100,	60*100	},
 	.probe_dmapi	= {	0,	0,	1	},
Index: xfs-linux/linux-2.6/xfs_globals.c
===================================================================
--- xfs-linux.orig/linux-2.6/xfs_globals.c	2006-08-16 11:35:46.182461750 +1000
+++ xfs-linux/linux-2.6/xfs_globals.c	2006-08-16 11:36:59.859066250 +1000
@@ -34,7 +34,7 @@ xfs_param_t xfs_params = {
 	.restrict_chown	= {	0,		1,		1	},
 	.sgid_inherit	= {	0,		0,		1	},
 	.symlink_mode	= {	0,		0,		1	},
-	.panic_mask	= {	0,		0,		127	},
+	.panic_mask	= {	0,		0,		255	},
 	.error_level	= {	0,		3,		11	},
 	.syncd_timer	= {	1*100,		30*100,		7200*100},
 	.probe_dmapi	= {	0,		0,		1	},
Index: xfs-linux/xfs_error.h
===================================================================
--- xfs-linux.orig/xfs_error.h	2006-08-16 11:35:03.599800500 +1000
+++ xfs-linux/xfs_error.h	2006-08-16 12:40:15.755398500 +1000
@@ -167,6 +167,7 @@ extern int xfs_errortag_clearall_umount(
 #define		XFS_PTAG_SHUTDOWN_CORRUPT	0x00000010
 #define		XFS_PTAG_SHUTDOWN_IOERROR	0x00000020
 #define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
+#define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
 
 struct xfs_mount;
 /* PRINTFLIKE4 */
