Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66lkK014543 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A30601051AB
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	KYe0vSbdJiya9fLP for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bt-0005K1-VY
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:46 +0000
Message-Id: <20110824060645.920227383@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 25/25] xfs: cleanup xfs_bmap.h
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmap-header-cleanup
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

Convert all function prototypes to the short form used elsewhere, and
remove duplicates of comments already placed at the function body.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-08-23 21:14:45.412027859 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-08-23 21:17:13.324559881 +0200
@@ -156,121 +156,29 @@ typedef struct xfs_bmalloca {
 	{ BMAP_RIGHT_FILLING,	"RF" }, \
 	{ BMAP_ATTRFORK,	"ATTR" }
 
-/*
- * Add bmap trace insert entries for all the contents of the extent list.
- *
- * Quite excessive tracing.  Only do this for debug builds.
- */
 #if defined(__KERNEL) && defined(DEBUG)
-void
-xfs_bmap_trace_exlist(
-	struct xfs_inode	*ip,		/* incore inode pointer */
-	xfs_extnum_t		cnt,		/* count of entries in list */
-	int			whichfork,
-	unsigned long		caller_ip);	/* data or attr fork */
+void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
+		int whichfork, unsigned long caller_ip);
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
 	xfs_bmap_trace_exlist(ip,c,w, _THIS_IP_)
 #else
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
 #endif
 
-/*
- * Convert inode from non-attributed to attributed.
- * Must not be in a transaction, ip must not be locked.
- */
-int					/* error code */
-xfs_bmap_add_attrfork(
-	struct xfs_inode	*ip,	/* incore inode pointer */
-	int			size,	/* space needed for new attribute */
-	int			rsvd);	/* flag for reserved block allocation */
-
-/*
- * Add the extent to the list of extents to be free at transaction end.
- * The list is maintained sorted (by block number).
- */
-void
-xfs_bmap_add_free(
-	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	struct xfs_mount	*mp);		/* mount point structure */
-
-/*
- * Routine to clean up the free list data structure when
- * an error occurs during a transaction.
- */
-void
-xfs_bmap_cancel(
-	xfs_bmap_free_t		*flist);	/* free list to clean up */
-
-/*
- * Compute and fill in the value of the maximum depth of a bmap btree
- * in this filesystem.  Done once, during mount.
- */
-void
-xfs_bmap_compute_maxlevels(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	int			whichfork);	/* data or attr fork */
-
-/*
- * Returns the file-relative block number of the first unused block in the file.
- * This is the lowest-address hole if the file has holes, else the first block
- * past the end of file.
- */
-int						/* error */
-xfs_bmap_first_unused(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	xfs_extlen_t		len,		/* size of hole to find */
-	xfs_fileoff_t		*unused,	/* unused block num */
-	int			whichfork);	/* data or attr fork */
-
-/*
- * Returns the file-relative block number of the last block + 1 before
- * last_block (input value) in the file.
- * This is not based on i_size, it is based on the extent list.
- * Returns 0 for local files, as they do not have an extent list.
- */
-int						/* error */
-xfs_bmap_last_before(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	xfs_fileoff_t		*last_block,	/* last block */
-	int			whichfork);	/* data or attr fork */
-
-/*
- * Returns the file-relative block number of the first block past eof in
- * the file.  This is not based on i_size, it is based on the extent list.
- * Returns 0 for local files, as they do not have an extent list.
- */
-int						/* error */
-xfs_bmap_last_offset(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	xfs_fileoff_t		*unused,	/* last block num */
-	int			whichfork);	/* data or attr fork */
-
-/*
- * Returns whether the selected fork of the inode has exactly one
- * block or not.  For the data fork we check this matches di_size,
- * implying the file's range is 0..bsize-1.
- */
-int
-xfs_bmap_one_block(
-	struct xfs_inode	*ip,		/* incore inode */
-	int			whichfork);	/* data or attr fork */
-
-/*
- * Read in the extents to iu_extents.
- * All inode fields are set up by caller, we just traverse the btree
- * and copy the records in.
- */
-int						/* error */
-xfs_bmap_read_extents(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	int			whichfork);	/* data or attr fork */
-
+int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+void	xfs_bmap_add_free(xfs_fsblock_t bno, xfs_filblks_t len,
+		struct xfs_bmap_free *flist, struct xfs_mount *mp);
+void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
+void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
+int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
+int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t *last_block, int whichfork);
+int	xfs_bmap_last_offset(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t *unused, int whichfork);
+int	xfs_bmap_one_block(struct xfs_inode *ip, int whichfork);
+int	xfs_bmap_read_extents(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork);
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
@@ -282,95 +190,28 @@ int	xfs_bmapi_write(struct xfs_trans *tp
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
 		struct xfs_bmbt_irec *mval, int *nmap,
 		struct xfs_bmap_free *flist);
-
-/*
- * Unmap (remove) blocks from a file.
- * If nexts is nonzero then the number of extents to remove is limited to
- * that value.  If not all extents in the block range can be removed then
- * *done is set.
- */
-int						/* error */
-xfs_bunmapi(
-	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_inode	*ip,		/* incore inode */
-	xfs_fileoff_t		bno,		/* starting offset to unmap */
-	xfs_filblks_t		len,		/* length to unmap in file */
-	int			flags,		/* XFS_BMAPI_... */
-	xfs_extnum_t		nexts,		/* number of extents max */
-	xfs_fsblock_t		*firstblock,	/* first allocated block
-						   controls a.g. for allocs */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	int			*done);		/* set if not done yet */
-
-/*
- * Check an extent list, which has just been read, for
- * any bit in the extent flag field.
- */
-int
-xfs_check_nostate_extents(
-	struct xfs_ifork	*ifp,
-	xfs_extnum_t		idx,
-	xfs_extnum_t		num);
-
-uint
-xfs_default_attroffset(
-	struct xfs_inode	*ip);
+int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
+		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
+		struct xfs_bmap_free *flist, int *done);
+int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
+		xfs_extnum_t num);
+uint	xfs_default_attroffset(struct xfs_inode *ip);
 
 #ifdef __KERNEL__
-
-/*
- * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
- * caller.  Frees all the extents that need freeing, which must be done
- * last due to locking considerations.
- *
- * Return 1 if the given transaction was committed and a new one allocated,
- * and 0 otherwise.
- */
-int						/* error */
-xfs_bmap_finish(
-	struct xfs_trans	**tp,		/* transaction pointer addr */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	int			*committed);	/* xact committed or not */
-
 /* bmap to userspace formatter - copy to user & advance pointer */
 typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
 
-/*
- * Get inode's extents as described in bmv, and format for output.
- */
-int						/* error code */
-xfs_getbmap(
-	xfs_inode_t		*ip,
-	struct getbmapx		*bmv,		/* user bmap structure */
-	xfs_bmap_format_t	formatter,	/* format to user */
-	void			*arg);		/* formatter arg */
-
-/*
- * Check if the endoff is outside the last extent. If so the caller will grow
- * the allocation to a stripe unit boundary
- */
-int
-xfs_bmap_eof(
-	struct xfs_inode        *ip,
-	xfs_fileoff_t           endoff,
-	int                     whichfork,
-	int                     *eof);
-
-/*
- * Count fsblocks of the given fork.
- */
-int
-xfs_bmap_count_blocks(
-	xfs_trans_t		*tp,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	int			*count);
-
-int
-xfs_bmap_punch_delalloc_range(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length);
+int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
+		int *committed);
+int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
+		xfs_bmap_format_t formatter, void *arg);
+int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
+		int whichfork, int *eof);
+int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, int *count);
+int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
+		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
