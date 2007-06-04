Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 07:40:08 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l54EdxWt019371
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 07:40:00 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l54Edwo6009368
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 16:39:58 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l54EdwoT009366
	for xfs@oss.sgi.com; Mon, 4 Jun 2007 16:39:58 +0200
Date: Mon, 4 Jun 2007 16:39:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] use filldir internally
Message-ID: <20070604143958.GB9081@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently xfs has a rather complicated internal scheme to allow for
different directory formats in IRIX.  This patch rips all code related
to this out and pushes useage of the Linux filldir callback into the
lowlevel directory code.  This does not make the code any less portable
because filldir can be used to create dirents of all possible variations
(including the IRIX ones as proved by the IRIX binary emulation code
under arch/mips/).

This patch get rid of an unessecary copy in the readdir path, about
250 lines of code and one of the last two users of the uio structure.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2007-05-19 00:22:40.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2007-06-01 13:17:15.000000000 +0200
@@ -267,74 +267,29 @@ xfs_file_readdir(
 	void		*dirent,
 	filldir_t	filldir)
 {
-	int		error = 0;
-	bhv_vnode_t	*vp = vn_from_inode(filp->f_path.dentry->d_inode);
-	uio_t		uio;
-	iovec_t		iov;
-	int		eof = 0;
-	caddr_t		read_buf;
-	int		namelen, size = 0;
-	size_t		rlen = PAGE_CACHE_SIZE;
-	xfs_off_t	start_offset, curr_offset;
-	xfs_dirent_t	*dbp = NULL;
-
-	/* Try fairly hard to get memory */
-	do {
-		if ((read_buf = kmalloc(rlen, GFP_KERNEL)))
-			break;
-		rlen >>= 1;
-	} while (rlen >= 1024);
-
-	if (read_buf == NULL)
-		return -ENOMEM;
-
-	uio.uio_iov = &iov;
-	uio.uio_segflg = UIO_SYSSPACE;
-	curr_offset = filp->f_pos;
-	if (filp->f_pos != 0x7fffffff)
-		uio.uio_offset = filp->f_pos;
-	else
-		uio.uio_offset = 0xffffffff;
-
-	while (!eof) {
-		uio.uio_resid = iov.iov_len = rlen;
-		iov.iov_base = read_buf;
-		uio.uio_iovcnt = 1;
-
-		start_offset = uio.uio_offset;
-
-		error = bhv_vop_readdir(vp, &uio, NULL, &eof);
-		if ((uio.uio_offset == start_offset) || error) {
-			size = 0;
-			break;
-		}
-
-		size = rlen - uio.uio_resid;
-		dbp = (xfs_dirent_t *)read_buf;
-		while (size > 0) {
-			namelen = strlen(dbp->d_name);
-
-			if (filldir(dirent, dbp->d_name, namelen,
-					(loff_t) curr_offset & 0x7fffffff,
-					(ino_t) dbp->d_ino,
-					DT_UNKNOWN)) {
-				goto done;
-			}
-			size -= dbp->d_reclen;
-			curr_offset = (loff_t)dbp->d_off /* & 0x7fffffff */;
-			dbp = (xfs_dirent_t *)((char *)dbp + dbp->d_reclen);
-		}
-	}
-done:
-	if (!error) {
-		if (size == 0)
-			filp->f_pos = uio.uio_offset & 0x7fffffff;
-		else if (dbp)
-			filp->f_pos = curr_offset;
-	}
+	struct inode	*inode = filp->f_path.dentry->d_inode;
+	bhv_vnode_t	*vp = vn_from_inode(inode);
+	int		error;
+	size_t		bufsize;
+
+	/*
+	 * The Linux API doesn't pass down the total size of the buffer
+	 * we read into down to the filesystem.  With the filldir concept
+	 * it's not needed for correct information, but the XFS dir2 leaf
+	 * code wants an estimate of the buffer size to calculate it's
+	 * readahead window and size the buffers used for mapping to
+	 * physical blocks.
+	 *
+	 * Try to give it an estimate that's good enough, maybe at some
+	 * point we can change the ->readdir prototype to include the
+	 * buffer size.
+	 */
+	bufsize = (size_t)min_t(loff_t, PAGE_SIZE, inode->i_size);
 
-	kfree(read_buf);
-	return -error;
+	error = bhv_vop_readdir(vp, dirent, bufsize, &filp->f_pos, filldir);
+	if (error)
+		return -error;
+	return 0;
 }
 
 STATIC int
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-05-19 00:22:40.000000000 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2007-06-01 13:17:15.000000000 +0200
@@ -167,8 +167,8 @@ typedef int	(*vop_rename_t)(bhv_desc_t *
 typedef int	(*vop_mkdir_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr *,
 				bhv_vnode_t **, struct cred *);
 typedef int	(*vop_rmdir_t)(bhv_desc_t *, bhv_vname_t *, struct cred *);
-typedef int	(*vop_readdir_t)(bhv_desc_t *, struct uio *, struct cred *,
-				int *);
+typedef int	(*vop_readdir_t)(bhv_desc_t *, void *dirent, size_t bufsize,
+				 xfs_off_t *offset, filldir_t filldir);
 typedef int	(*vop_symlink_t)(bhv_desc_t *, bhv_vname_t *, struct bhv_vattr*,
 				char *, bhv_vnode_t **, struct cred *);
 typedef int	(*vop_readlink_t)(bhv_desc_t *, struct uio *, int,
@@ -278,8 +278,8 @@ typedef struct bhv_vnodeops {
 #define	bhv_vop_mkdir(dp,d,vap,vpp,cr)					\
 		VOP(vop_mkdir, dp)(VNHEAD(dp),d,vap,vpp,cr)
 #define	bhv_vop_rmdir(dp,d,cr)	 	VOP(vop_rmdir, dp)(VNHEAD(dp),d,cr)
-#define	bhv_vop_readdir(vp,uiop,cr,eofp)				\
-		VOP(vop_readdir, vp)(VNHEAD(vp),uiop,cr,eofp)
+#define	bhv_vop_readdir(vp,dirent,bufsize,offset,filldir)		\
+		VOP(vop_readdir, vp)(VNHEAD(vp),dirent,bufsize,offset,filldir)
 #define	bhv_vop_symlink(dvp,d,vap,tnm,vpp,cr)				\
 		VOP(vop_symlink, dvp)(VNHEAD(dvp),d,vap,tnm,vpp,cr)
 #define	bhv_vop_readlink(vp,uiop,fl,cr)					\
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2007-05-21 16:15:11.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2007-06-01 13:17:15.000000000 +0200
@@ -3247,37 +3247,6 @@ xfs_rmdir(
 	goto std_return;
 }
 
-
-/*
- * Read dp's entries starting at uiop->uio_offset and translate them into
- * bufsize bytes worth of struct dirents starting at bufbase.
- */
-STATIC int
-xfs_readdir(
-	bhv_desc_t	*dir_bdp,
-	uio_t		*uiop,
-	cred_t		*credp,
-	int		*eofp)
-{
-	xfs_inode_t	*dp;
-	xfs_trans_t	*tp = NULL;
-	int		error = 0;
-	uint		lock_mode;
-
-	vn_trace_entry(BHV_TO_VNODE(dir_bdp), __FUNCTION__,
-					       (inst_t *)__return_address);
-	dp = XFS_BHVTOI(dir_bdp);
-
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return XFS_ERROR(EIO);
-
-	lock_mode = xfs_ilock_map_shared(dp);
-	error = xfs_dir_getdents(tp, dp, uiop, eofp);
-	xfs_iunlock_map_shared(dp, lock_mode);
-	return error;
-}
-
-
 STATIC int
 xfs_symlink(
 	bhv_desc_t		*dir_bdp,
Index: linux-2.6/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2.c	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2.c	2007-06-01 13:17:15.000000000 +0200
@@ -43,8 +43,6 @@
 #include "xfs_dir2_trace.h"
 #include "xfs_error.h"
 
-static int	xfs_dir2_put_dirent64_direct(xfs_dir2_put_args_t *pa);
-static int	xfs_dir2_put_dirent64_uio(xfs_dir2_put_args_t *pa);
 
 void
 xfs_dir_mount(
@@ -293,47 +291,35 @@ xfs_dir_removename(
  * Read a directory.
  */
 int
-xfs_dir_getdents(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	uio_t		*uio,		/* caller's buffer control */
-	int		*eofp)		/* out: eof reached */
+xfs_readdir(
+	bhv_desc_t	*dir_bdp,
+	void		*dirent,
+	size_t		bufsize,
+	xfs_off_t	*offset,
+	filldir_t	filldir)
 {
-	int		alignment;	/* alignment required for ABI */
-	xfs_dirent_t	*dbp;		/* malloc'ed buffer */
-	xfs_dir2_put_t	put;		/* entry formatting routine */
+	xfs_inode_t	*dp = XFS_BHVTOI(dir_bdp);
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
 
+	vn_trace_entry(BHV_TO_VNODE(dir_bdp), __FUNCTION__,
+					       (inst_t *)__return_address);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return XFS_ERROR(EIO);
+
 	ASSERT((dp->i_d.di_mode & S_IFMT) == S_IFDIR);
 	XFS_STATS_INC(xs_dir_getdents);
-	/*
-	 * If our caller has given us a single contiguous aligned memory buffer,
-	 * just work directly within that buffer.  If it's in user memory,
-	 * lock it down first.
-	 */
-	alignment = sizeof(xfs_off_t) - 1;
-	if ((uio->uio_iovcnt == 1) &&
-	    (((__psint_t)uio->uio_iov[0].iov_base & alignment) == 0) &&
-	    ((uio->uio_iov[0].iov_len & alignment) == 0)) {
-		dbp = NULL;
-		put = xfs_dir2_put_dirent64_direct;
-	} else {
-		dbp = kmem_alloc(sizeof(*dbp) + MAXNAMELEN, KM_SLEEP);
-		put = xfs_dir2_put_dirent64_uio;
-	}
 
-	*eofp = 0;
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
-		rval = xfs_dir2_sf_getdents(dp, uio, eofp, dbp, put);
-	else if ((rval = xfs_dir2_isblock(tp, dp, &v)))
+		rval = xfs_dir2_sf_getdents(dp, dirent, offset, filldir);
+	else if ((rval = xfs_dir2_isblock(NULL, dp, &v)))
 		;
 	else if (v)
-		rval = xfs_dir2_block_getdents(tp, dp, uio, eofp, dbp, put);
+		rval = xfs_dir2_block_getdents(dp, dirent, offset, filldir);
 	else
-		rval = xfs_dir2_leaf_getdents(tp, dp, uio, eofp, dbp, put);
-	if (dbp != NULL)
-		kmem_free(dbp, sizeof(*dbp) + MAXNAMELEN);
+		rval = xfs_dir2_leaf_getdents(dp, dirent, bufsize, offset,
+					      filldir);
 	return rval;
 }
 
@@ -613,77 +599,6 @@ xfs_dir2_isleaf(
 }
 
 /*
- * Getdents put routine for 64-bit ABI, direct form.
- */
-static int
-xfs_dir2_put_dirent64_direct(
-	xfs_dir2_put_args_t	*pa)
-{
-	xfs_dirent_t		*idbp;		/* dirent pointer */
-	iovec_t			*iovp;		/* io vector */
-	int			namelen;	/* entry name length */
-	int			reclen;		/* entry total length */
-	uio_t			*uio;		/* I/O control */
-
-	namelen = pa->namelen;
-	reclen = DIRENTSIZE(namelen);
-	uio = pa->uio;
-	/*
-	 * Won't fit in the remaining space.
-	 */
-	if (reclen > uio->uio_resid) {
-		pa->done = 0;
-		return 0;
-	}
-	iovp = uio->uio_iov;
-	idbp = (xfs_dirent_t *)iovp->iov_base;
-	iovp->iov_base = (char *)idbp + reclen;
-	iovp->iov_len -= reclen;
-	uio->uio_resid -= reclen;
-	idbp->d_reclen = reclen;
-	idbp->d_ino = pa->ino;
-	idbp->d_off = pa->cook;
-	idbp->d_name[namelen] = '\0';
-	pa->done = 1;
-	memcpy(idbp->d_name, pa->name, namelen);
-	return 0;
-}
-
-/*
- * Getdents put routine for 64-bit ABI, uio form.
- */
-static int
-xfs_dir2_put_dirent64_uio(
-	xfs_dir2_put_args_t	*pa)
-{
-	xfs_dirent_t		*idbp;		/* dirent pointer */
-	int			namelen;	/* entry name length */
-	int			reclen;		/* entry total length */
-	int			rval;		/* return value */
-	uio_t			*uio;		/* I/O control */
-
-	namelen = pa->namelen;
-	reclen = DIRENTSIZE(namelen);
-	uio = pa->uio;
-	/*
-	 * Won't fit in the remaining space.
-	 */
-	if (reclen > uio->uio_resid) {
-		pa->done = 0;
-		return 0;
-	}
-	idbp = pa->dbp;
-	idbp->d_reclen = reclen;
-	idbp->d_ino = pa->ino;
-	idbp->d_off = pa->cook;
-	idbp->d_name[namelen] = '\0';
-	memcpy(idbp->d_name, pa->name, namelen);
-	rval = xfs_uio_read((caddr_t)idbp, reclen, uio);
-	pa->done = (rval == 0);
-	return rval;
-}
-
-/*
  * Remove the given block from the directory.
  * This routine is used for data and free blocks, leaf/node are done
  * by xfs_da_shrink_inode.
Index: linux-2.6/fs/xfs/xfs_dir2.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2.h	2007-05-12 15:16:05.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2.h	2007-06-01 13:17:15.000000000 +0200
@@ -60,21 +60,6 @@ typedef	__uint32_t	xfs_dir2_db_t;
 typedef	xfs_off_t	xfs_dir2_off_t;
 
 /*
- * For getdents, argument struct for put routines.
- */
-typedef int (*xfs_dir2_put_t)(struct xfs_dir2_put_args *pa);
-typedef struct xfs_dir2_put_args {
-	xfs_off_t	cook;		/* cookie of (next) entry */
-	xfs_intino_t	ino;		/* inode number */
-	xfs_dirent_t	*dbp;		/* buffer pointer */
-	char		*name;		/* directory entry name */
-	int		namelen;	/* length of name */
-	int		done;		/* output: set if value was stored */
-	xfs_dir2_put_t	put;		/* put function ptr (i/o) */
-	struct uio	*uio;		/* uio control structure */
-} xfs_dir2_put_args_t;
-
-/*
  * Generic directory interface routines
  */
 extern void xfs_dir_startup(void);
@@ -92,8 +77,6 @@ extern int xfs_dir_removename(struct xfs
 				char *name, int namelen, xfs_ino_t ino,
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
-extern int xfs_dir_getdents(struct xfs_trans *tp, struct xfs_inode *dp,
-				uio_t *uio, int *eofp);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				char *name, int namelen, xfs_ino_t inum,
 				xfs_fsblock_t *first,
@@ -101,6 +84,8 @@ extern int xfs_dir_replace(struct xfs_tr
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				char *name, int namelen);
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+extern int xfs_readdir(bhv_desc_t *dir_bdp, void *dirent, size_t bufsize,
+		       xfs_off_t *offset, filldir_t filldir);
 
 /*
  * Utility routines for v2 directories.
Index: linux-2.6/fs/xfs/xfs_dir2_block.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_block.c	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_block.c	2007-06-01 13:17:15.000000000 +0200
@@ -432,12 +432,10 @@ xfs_dir2_block_addname(
  */
 int						/* error */
 xfs_dir2_block_getdents(
-	xfs_trans_t		*tp,		/* transaction (NULL) */
 	xfs_inode_t		*dp,		/* incore inode */
-	uio_t			*uio,		/* caller's buffer control */
-	int			*eofp,		/* eof reached? (out) */
-	xfs_dirent_t		*dbp,		/* caller's buffer */
-	xfs_dir2_put_t		put)		/* abi's formatting function */
+	void			*dirent,
+	xfs_off_t		*offset,
+	filldir_t		filldir)
 {
 	xfs_dir2_block_t	*block;		/* directory block structure */
 	xfs_dabuf_t		*bp;		/* buffer for block */
@@ -447,31 +445,32 @@ xfs_dir2_block_getdents(
 	char			*endptr;	/* end of the data entries */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* filesystem mount point */
-	xfs_dir2_put_args_t	p;		/* arg package for put rtn */
 	char			*ptr;		/* current data entry */
 	int			wantoff;	/* starting block offset */
+	xfs_ino_t		ino;
+	xfs_off_t		cook;
 
 	mp = dp->i_mount;
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(mp, uio->uio_offset) > mp->m_dirdatablk) {
-		*eofp = 1;
+	if (xfs_dir2_dataptr_to_db(mp, *offset) > mp->m_dirdatablk) {
 		return 0;
 	}
 	/*
 	 * Can't read the block, give up, else get dabuf in bp.
 	 */
-	if ((error =
-	    xfs_da_read_buf(tp, dp, mp->m_dirdatablk, -1, &bp, XFS_DATA_FORK))) {
+	error = xfs_da_read_buf(NULL, dp, mp->m_dirdatablk, -1,
+				&bp, XFS_DATA_FORK);
+	if (error)
 		return error;
-	}
+
 	ASSERT(bp != NULL);
 	/*
 	 * Extract the byte offset we start at from the seek pointer.
 	 * We'll skip entries before this.
 	 */
-	wantoff = xfs_dir2_dataptr_to_off(mp, uio->uio_offset);
+	wantoff = xfs_dir2_dataptr_to_off(mp, *offset);
 	block = bp->data;
 	xfs_dir2_data_check(dp, bp);
 	/*
@@ -480,9 +479,7 @@ xfs_dir2_block_getdents(
 	btp = xfs_dir2_block_tail_p(mp, block);
 	ptr = (char *)block->u;
 	endptr = (char *)xfs_dir2_block_leaf_p(btp);
-	p.dbp = dbp;
-	p.put = put;
-	p.uio = uio;
+
 	/*
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
@@ -508,33 +505,24 @@ xfs_dir2_block_getdents(
 		 */
 		if ((char *)dep - (char *)block < wantoff)
 			continue;
-		/*
-		 * Set up argument structure for put routine.
-		 */
-		p.namelen = dep->namelen;
 
-		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+		cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 						    ptr - (char *)block);
-		p.ino = be64_to_cpu(dep->inumber);
+		ino = be64_to_cpu(dep->inumber);
 #if XFS_BIG_INUMS
-		p.ino += mp->m_inoadd;
+		ino += mp->m_inoadd;
 #endif
-		p.name = (char *)dep->name;
-
-		/*
-		 * Put the entry in the caller's buffer.
-		 */
-		error = p.put(&p);
 
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (!p.done) {
-			uio->uio_offset =
-				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+		if (filldir(dirent, dep->name, dep->namelen, cook,
+			    ino, DT_UNKNOWN)) {
+			*offset = xfs_dir2_db_off_to_dataptr(mp,
+					mp->m_dirdatablk,
 					(char *)dep - (char *)block);
-			xfs_da_brelse(tp, bp);
-			return error;
+			xfs_da_brelse(NULL, bp);
+			return 0;
 		}
 	}
 
@@ -542,13 +530,8 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	*eofp = 1;
-
-	uio->uio_offset =
-		xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
-
-	xfs_da_brelse(tp, bp);
-
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+	xfs_da_brelse(NULL, bp);
 	return 0;
 }
 
Index: linux-2.6/fs/xfs/xfs_dir2_block.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_block.h	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_block.h	2007-06-01 13:17:15.000000000 +0200
@@ -80,9 +80,8 @@ xfs_dir2_block_leaf_p(xfs_dir2_block_tai
  * Function declarations.
  */
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
-extern int xfs_dir2_block_getdents(struct xfs_trans *tp, struct xfs_inode *dp,
-				   struct uio *uio, int *eofp,
-				   struct xfs_dirent *dbp, xfs_dir2_put_t put);
+extern int xfs_dir2_block_getdents(struct xfs_inode *dp, void *dirent,
+				   xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
 extern int xfs_dir2_block_replace(struct xfs_da_args *args);
Index: linux-2.6/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_leaf.c	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_leaf.c	2007-06-01 13:17:15.000000000 +0200
@@ -749,12 +749,11 @@ xfs_dir2_leaf_compact_x1(
  */
 int						/* error */
 xfs_dir2_leaf_getdents(
-	xfs_trans_t		*tp,		/* transaction pointer */
 	xfs_inode_t		*dp,		/* incore directory inode */
-	uio_t			*uio,		/* I/O control & vectors */
-	int			*eofp,		/* out: reached end of dir */
-	xfs_dirent_t		*dbp,		/* caller's buffer */
-	xfs_dir2_put_t		put)		/* ABI formatting routine */
+	void			*dirent,
+	size_t			bufsize,
+	xfs_off_t		*offset,
+	filldir_t		filldir)
 {
 	xfs_dabuf_t		*bp;		/* data block buffer */
 	int			byteoff;	/* offset in current block */
@@ -763,7 +762,6 @@ xfs_dir2_leaf_getdents(
 	xfs_dir2_data_t		*data;		/* data block structure */
 	xfs_dir2_data_entry_t	*dep;		/* data entry */
 	xfs_dir2_data_unused_t	*dup;		/* unused entry */
-	int			eof;		/* reached end of directory */
 	int			error = 0;	/* error return value */
 	int			i;		/* temporary loop index */
 	int			j;		/* temporary loop index */
@@ -776,46 +774,38 @@ xfs_dir2_leaf_getdents(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_off_t		newoff;		/* new curoff after new blk */
 	int			nmap;		/* mappings to ask xfs_bmapi */
-	xfs_dir2_put_args_t	*p;		/* formatting arg bundle */
 	char			*ptr = NULL;	/* pointer to current data */
 	int			ra_current;	/* number of read-ahead blks */
 	int			ra_index;	/* *map index for read-ahead */
 	int			ra_offset;	/* map entry offset for ra */
 	int			ra_want;	/* readahead count wanted */
+	xfs_ino_t		ino;
 
 	/*
 	 * If the offset is at or past the largest allowed value,
-	 * give up right away, return eof.
+	 * give up right away.
 	 */
-	if (uio->uio_offset >= XFS_DIR2_MAX_DATAPTR) {
-		*eofp = 1;
+	if (*offset >= XFS_DIR2_MAX_DATAPTR)
 		return 0;
-	}
+
 	mp = dp->i_mount;
-	/*
-	 * Setup formatting arguments.
-	 */
-	p = kmem_alloc(sizeof(*p), KM_SLEEP);
-	p->dbp = dbp;
-	p->put = put;
-	p->uio = uio;
+
 	/*
 	 * Set up to bmap a number of blocks based on the caller's
 	 * buffer size, the directory block size, and the filesystem
 	 * block size.
 	 */
-	map_size =
-		howmany(uio->uio_resid + mp->m_dirblksize,
-			mp->m_sb.sb_blocksize);
+	map_size = howmany(bufsize + mp->m_dirblksize, mp->m_sb.sb_blocksize);
 	map = kmem_alloc(map_size * sizeof(*map), KM_SLEEP);
 	map_valid = ra_index = ra_offset = ra_current = map_blocks = 0;
 	bp = NULL;
-	eof = 1;
+
 	/*
 	 * Inside the loop we keep the main offset value as a byte offset
 	 * in the directory file.
 	 */
-	curoff = xfs_dir2_dataptr_to_byte(mp, uio->uio_offset);
+	curoff = xfs_dir2_dataptr_to_byte(mp, *offset);
+
 	/*
 	 * Force this conversion through db so we truncate the offset
 	 * down to get the start of the data block.
@@ -836,7 +826,7 @@ xfs_dir2_leaf_getdents(
 			 * take it out of the mapping.
 			 */
 			if (bp) {
-				xfs_da_brelse(tp, bp);
+				xfs_da_brelse(NULL, bp);
 				bp = NULL;
 				map_blocks -= mp->m_dirblkfsbs;
 				/*
@@ -862,8 +852,9 @@ xfs_dir2_leaf_getdents(
 			/*
 			 * Recalculate the readahead blocks wanted.
 			 */
-			ra_want = howmany(uio->uio_resid + mp->m_dirblksize,
+			ra_want = howmany(bufsize + mp->m_dirblksize,
 					  mp->m_sb.sb_blocksize) - 1;
+
 			/*
 			 * If we don't have as many as we want, and we haven't
 			 * run out of data blocks, get some more mappings.
@@ -876,7 +867,7 @@ xfs_dir2_leaf_getdents(
 				 * we already have in the table.
 				 */
 				nmap = map_size - map_valid;
-				error = xfs_bmapi(tp, dp,
+				error = xfs_bmapi(NULL, dp,
 					map_off,
 					xfs_dir2_byte_to_da(mp,
 						XFS_DIR2_LEAF_OFFSET) - map_off,
@@ -939,7 +930,7 @@ xfs_dir2_leaf_getdents(
 			 * mapping.
 			 */
 			curdb = xfs_dir2_da_to_db(mp, map->br_startoff);
-			error = xfs_da_read_buf(tp, dp, map->br_startoff,
+			error = xfs_da_read_buf(NULL, dp, map->br_startoff,
 				map->br_blockcount >= mp->m_dirblkfsbs ?
 				    XFS_FSB_TO_DADDR(mp, map->br_startblock) :
 				    -1,
@@ -982,7 +973,7 @@ xfs_dir2_leaf_getdents(
 				 * is a very rare case.
 				 */
 				else if (i > ra_current) {
-					(void)xfs_da_reada_buf(tp, dp,
+					(void)xfs_da_reada_buf(NULL, dp,
 						map[ra_index].br_startoff +
 						ra_offset, XFS_DATA_FORK);
 					ra_current = i;
@@ -1089,46 +1080,39 @@ xfs_dir2_leaf_getdents(
 		 */
 		dep = (xfs_dir2_data_entry_t *)ptr;
 
-		p->namelen = dep->namelen;
-
-		length = xfs_dir2_data_entsize(p->namelen);
-
-		p->cook = xfs_dir2_byte_to_dataptr(mp, curoff + length);
+		length = xfs_dir2_data_entsize(dep->namelen);
 
-		p->ino = be64_to_cpu(dep->inumber);
+		ino = be64_to_cpu(dep->inumber);
 #if XFS_BIG_INUMS
-		p->ino += mp->m_inoadd;
+		ino += mp->m_inoadd;
 #endif
-		p->name = (char *)dep->name;
-
-		error = p->put(p);
 
 		/*
 		 * Won't fit.  Return to caller.
 		 */
-		if (!p->done) {
-			eof = 0;
+		if (filldir(dirent, dep->name, dep->namelen,
+			    xfs_dir2_byte_to_dataptr(mp, curoff + length),
+			    ino, DT_UNKNOWN))
 			break;
-		}
+
 		/*
 		 * Advance to next entry in the block.
 		 */
 		ptr += length;
 		curoff += length;
+		bufsize -= length;
 	}
 
 	/*
 	 * All done.  Set output offset value to current offset.
 	 */
-	*eofp = eof;
 	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
-		uio->uio_offset = XFS_DIR2_MAX_DATAPTR;
+		*offset = XFS_DIR2_MAX_DATAPTR;
 	else
-		uio->uio_offset = xfs_dir2_byte_to_dataptr(mp, curoff);
+		*offset = xfs_dir2_byte_to_dataptr(mp, curoff);
 	kmem_free(map, map_size * sizeof(*map));
-	kmem_free(p, sizeof(*p));
 	if (bp)
-		xfs_da_brelse(tp, bp);
+		xfs_da_brelse(NULL, bp);
 	return error;
 }
 
Index: linux-2.6/fs/xfs/xfs_dir2_leaf.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_leaf.h	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_leaf.h	2007-06-01 13:17:15.000000000 +0200
@@ -232,9 +232,9 @@ extern void xfs_dir2_leaf_compact(struct
 extern void xfs_dir2_leaf_compact_x1(struct xfs_dabuf *bp, int *indexp,
 				     int *lowstalep, int *highstalep,
 				     int *lowlogp, int *highlogp);
-extern int xfs_dir2_leaf_getdents(struct xfs_trans *tp, struct xfs_inode *dp,
-				  struct uio *uio, int *eofp,
-				  struct xfs_dirent *dbp, xfs_dir2_put_t put);
+extern int xfs_dir2_leaf_getdents(struct xfs_inode *dp, void *dirent,
+				  size_t bufsize, xfs_off_t *offset,
+				  filldir_t filldir);
 extern int xfs_dir2_leaf_init(struct xfs_da_args *args, xfs_dir2_db_t bno,
 			      struct xfs_dabuf **bpp, int magic);
 extern void xfs_dir2_leaf_log_ents(struct xfs_trans *tp, struct xfs_dabuf *bp,
Index: linux-2.6/fs/xfs/xfs_dir2_sf.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_sf.c	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_sf.c	2007-06-01 13:17:15.000000000 +0200
@@ -695,19 +695,18 @@ xfs_dir2_sf_create(
 int						/* error */
 xfs_dir2_sf_getdents(
 	xfs_inode_t		*dp,		/* incore directory inode */
-	uio_t			*uio,		/* caller's buffer control */
-	int			*eofp,		/* eof reached? (out) */
-	xfs_dirent_t		*dbp,		/* caller's buffer */
-	xfs_dir2_put_t		put)		/* abi's formatting function */
+	void			*dirent,
+	xfs_off_t		*offset,
+	filldir_t		filldir)
 {
-	int			error;		/* error return value */
 	int			i;		/* shortform entry number */
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	xfs_dir2_dataptr_t	off;		/* current entry's offset */
-	xfs_dir2_put_args_t	p;		/* arg package for put rtn */
 	xfs_dir2_sf_entry_t	*sfep;		/* shortform directory entry */
 	xfs_dir2_sf_t		*sfp;		/* shortform structure */
-	xfs_off_t			dir_offset;
+	xfs_dir2_dataptr_t	dot_offset;
+	xfs_dir2_dataptr_t	dotdot_offset;
+	xfs_ino_t		ino;
 
 	mp = dp->i_mount;
 
@@ -720,8 +719,6 @@ xfs_dir2_sf_getdents(
 		return XFS_ERROR(EIO);
 	}
 
-	dir_offset = uio->uio_offset;
-
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 
@@ -732,108 +729,78 @@ xfs_dir2_sf_getdents(
 	/*
 	 * If the block number in the offset is out of range, we're done.
 	 */
-	if (xfs_dir2_dataptr_to_db(mp, dir_offset) > mp->m_dirdatablk) {
-		*eofp = 1;
+	if (xfs_dir2_dataptr_to_db(mp, *offset) > mp->m_dirdatablk)
 		return 0;
-	}
 
 	/*
-	 * Set up putargs structure.
-	 */
-	p.dbp = dbp;
-	p.put = put;
-	p.uio = uio;
+	 * Precalculate offsets for . and .. as we will always need them.
+	 *
+	 * XXX(hch): the second argument is sometimes 0 and sometimes
+	 * mp->m_dirdatablk.
+	 */
+	dot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+					     XFS_DIR2_DATA_DOT_OFFSET);
+	dotdot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+						XFS_DIR2_DATA_DOTDOT_OFFSET);
+
 	/*
 	 * Put . entry unless we're starting past it.
 	 */
-	if (dir_offset <=
-		    xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					       XFS_DIR2_DATA_DOT_OFFSET)) {
-		p.cook = xfs_dir2_db_off_to_dataptr(mp, 0,
-						XFS_DIR2_DATA_DOTDOT_OFFSET);
-		p.ino = dp->i_ino;
+	if (*offset <= dot_offset) {
+		ino = dp->i_ino;
 #if XFS_BIG_INUMS
-		p.ino += mp->m_inoadd;
+		ino += mp->m_inoadd;
 #endif
-		p.name = ".";
-		p.namelen = 1;
-
-		error = p.put(&p);
-
-		if (!p.done) {
-			uio->uio_offset =
-				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						XFS_DIR2_DATA_DOT_OFFSET);
-			return error;
+		if (filldir(dirent, ".", 1, dotdot_offset, ino, DT_DIR)) {
+			*offset = dot_offset;
+			return 0;
 		}
 	}
 
 	/*
 	 * Put .. entry unless we're starting past it.
 	 */
-	if (dir_offset <=
-		    xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					       XFS_DIR2_DATA_DOTDOT_OFFSET)) {
-		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						XFS_DIR2_DATA_FIRST_OFFSET);
-		p.ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
+	if (*offset <= dotdot_offset) {
+		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
+						  XFS_DIR2_DATA_FIRST_OFFSET);
+		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
 #if XFS_BIG_INUMS
-		p.ino += mp->m_inoadd;
+		ino += mp->m_inoadd;
 #endif
-		p.name = "..";
-		p.namelen = 2;
-
-		error = p.put(&p);
-
-		if (!p.done) {
-			uio->uio_offset =
-				xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					XFS_DIR2_DATA_DOTDOT_OFFSET);
-			return error;
+		if (filldir(dirent, "..", 2, off, ino, DT_DIR)) {
+			*offset = dotdot_offset;
+			return 0;
 		}
 	}
 
 	/*
 	 * Loop while there are more entries and put'ing works.
 	 */
-	for (i = 0, sfep = xfs_dir2_sf_firstentry(sfp);
-		     i < sfp->hdr.count;
-			     i++, sfep = xfs_dir2_sf_nextentry(sfp, sfep)) {
-
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	for (i = 0; i < sfp->hdr.count; i++) {
 		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				xfs_dir2_sf_get_offset(sfep));
 
-		if (dir_offset > off)
+		if (*offset > off) {
+			sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 			continue;
+		}
 
-		p.namelen = sfep->namelen;
-
-		p.cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-			xfs_dir2_sf_get_offset(sfep) +
-			xfs_dir2_data_entsize(p.namelen));
-
-		p.ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
+		ino = xfs_dir2_sf_get_inumber(sfp, xfs_dir2_sf_inumberp(sfep));
 #if XFS_BIG_INUMS
-		p.ino += mp->m_inoadd;
+		ino += mp->m_inoadd;
 #endif
-		p.name = (char *)sfep->name;
 
-		error = p.put(&p);
-
-		if (!p.done) {
-			uio->uio_offset = off;
-			return error;
+		if (filldir(dirent, sfep->name, sfep->namelen,
+			    off + xfs_dir2_data_entsize(sfep->namelen),
+			    ino, DT_UNKNOWN)) {
+			*offset = off;
+			return 0;
 		}
+		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 
-	/*
-	 * They all fit.
-	 */
-	*eofp = 1;
-
-	uio->uio_offset =
-		xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
-
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
 	return 0;
 }
 
Index: linux-2.6/fs/xfs/xfs_dir2_sf.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dir2_sf.h	2007-06-01 13:17:03.000000000 +0200
+++ linux-2.6/fs/xfs/xfs_dir2_sf.h	2007-06-01 13:17:15.000000000 +0200
@@ -169,9 +169,8 @@ extern int xfs_dir2_block_to_sf(struct x
 				int size, xfs_dir2_sf_hdr_t *sfhp);
 extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
 extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
-extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, struct uio *uio,
-				int *eofp, struct xfs_dirent *dbp,
-				xfs_dir2_put_t put);
+extern int xfs_dir2_sf_getdents(struct xfs_inode *dp, void *dirent,
+				xfs_off_t *offset, filldir_t filldir);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
