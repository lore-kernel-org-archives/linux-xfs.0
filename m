Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 13:55:16 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lBALsjUW013424
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:54:50 -0800
Date: Mon, 10 Dec 2007 18:04:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: [review please] Re: DMAPI problem with the new filldir implementation
Message-ID: <20071210070458.GI4714@sgi.com>
References: <475879DB.40705@sgi.com> <20071207002922.GQ115527101@sgi.com> <20071207014940.GS115527101@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207014940.GS115527101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Vlad Apostolov <vapo@sgi.com>, Christoph Hellwig <hch@infradead.org>, Mark Goodwin <markgw@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

This passes xfsqa and various other handrolled tests I've thrown
at it. Can i get some eyeballs on this, please?

Cheers,

Dave.

On Fri, Dec 07, 2007 at 12:49:40PM +1100, David Chinner wrote:
> On Fri, Dec 07, 2007 at 11:29:22AM +1100, David Chinner wrote:
> > (cc xfs-dev and xfs@oss)
> > 
> > On Fri, Dec 07, 2007 at 09:38:19AM +1100, Vlad Apostolov wrote:
> > > Hi Christoph and Dave,
> > > 
> > > It looks like we may have a problem caused by this patch:
> > > 
> > > http://oss.sgi.com/archives/xfs/2007-07/msg00338.html
> > > 
> > > It makes XFS test 144 to fail if the inode size is 2k. I did
> > > some investigation and I think xfs_readdir() returns incorrect
> > > next location for shortform directories. When the inode size is
> > > 2k, more dir entries fit inline in the inode and test 144
> > > dm_get_dirattrs() starts using the shortform.
> > > 
> > > I think this code here
> > > 
> > >        if (filldir(dirent, sfep->name, sfep->namelen,
> > >                off + xfs_dir2_data_entsize(sfep->namelen),
> > >                ino, DT_UNKNOWN)) {
> > > 
> > > adds some offset "xfs_dir2_data_entsize(sfep->namelen)" to the
> > > next location pointer, which appears to be incorrect and causes
> > > directory entries to be skipped on the next call of dm_get_dirattrs().
> > 
> > It's supposed to be the offset of the next dirent:
> > 
> >        On Linux, the dirent structure is defined as follows:
> > 
> >           struct dirent {
> >               ino_t          d_ino;       /* inode number */
> > >>>>>>        off_t          d_off;       /* offset to the next dirent */
> >               unsigned short d_reclen;    /* length of this record */
> >               unsigned char  d_type;      /* type of file */
> >               char           d_name[256]; /* filename */
> >           };
> > 
> > However, looking at the generic filldir() implementation in fs/readdir.c,
> > I see that it:
> > 
> >         dirent = buf->previous;
> >         if (dirent) {
> >                 if (__put_user(offset, &dirent->d_off))
> >                         goto efault;
> >         }
> > 
> > Puts the offset in the *previous* dirent, not the current one. That
> > means that the three calls to XFs makes to filldir() are all incorrect;
> > they should be passing the offset of the current object, not the next
> > object as teh filldir code stuffs it in the previous dirent.
> > 
> > The reason that dmapi is failing here is that it uses teh offset as the
> > cookie to to indicate the next inode to read. However, getdents uses the
> > filp->f_pos:
> > 
> >         error = vfs_readdir(file, filldir, &buf);
> >         if (error < 0)
> >                 goto out_putf;
> >         error = buf.error;
> >         lastdirent = buf.previous;
> >         if (lastdirent) {
> >                 if (put_user(file->f_pos, &lastdirent->d_off))
> >                         error = -EFAULT;
> >                 else
> >                         error = count - buf.count;
> >         }
> > 
> > and xfs_file_readdir uses that as teh offset for lookups and keeps it up
> > to date correctly. hence the getdents code is overwritting the incorrect
> > value XFS has been stuffing in there and hence we haven't seen this
> > on normal syscalls.
> 
> Except that the hack to go back to double buffering relies on the
> filldir offset being pushed off to be the next dirent, and hence
> with the patch I sent we set filp->f_pos incorrectly in
> xfs_file_readdir().....
> 
> <sigh>
> 
> > Ok, patch attached. passes 144 on all inode sizes, otherwise mostly
> > untested.
> 
> I did say mostly untested :/
> 
> Updated patch below (which passes 006 but is still mostly untested).
> 
> Cheers,
> 
> dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> ---
>  fs/xfs/dmapi/xfs_dm.c       |    4 ----
>  fs/xfs/linux-2.6/xfs_file.c |    4 ++--
>  fs/xfs/xfs_dir2_block.c     |    6 ++----
>  fs/xfs/xfs_dir2_leaf.c      |    2 +-
>  fs/xfs/xfs_dir2_sf.c        |    9 +++------
>  5 files changed, 8 insertions(+), 17 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_block.c	2007-08-23 23:03:09.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_block.c	2007-12-07 10:23:14.933645761 +1100
> @@ -508,7 +508,7 @@ xfs_dir2_block_getdents(
>  			continue;
>  
>  		cook = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
> -						    ptr - (char *)block);
> +					    (char *)dep - (char *)block);
>  		ino = be64_to_cpu(dep->inumber);
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
> @@ -519,9 +519,7 @@ xfs_dir2_block_getdents(
>  		 */
>  		if (filldir(dirent, dep->name, dep->namelen, cook,
>  			    ino, DT_UNKNOWN)) {
> -			*offset = xfs_dir2_db_off_to_dataptr(mp,
> -					mp->m_dirdatablk,
> -					(char *)dep - (char *)block);
> +			*offset = cook;
>  			xfs_da_brelse(NULL, bp);
>  			return 0;
>  		}
> Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_leaf.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_leaf.c	2007-08-24 22:24:45.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_leaf.c	2007-12-07 10:18:17.623544813 +1100
> @@ -1091,7 +1091,7 @@ xfs_dir2_leaf_getdents(
>  		 * Won't fit.  Return to caller.
>  		 */
>  		if (filldir(dirent, dep->name, dep->namelen,
> -			    xfs_dir2_byte_to_dataptr(mp, curoff + length),
> +			    xfs_dir2_byte_to_dataptr(mp, curoff),
>  			    ino, DT_UNKNOWN))
>  			break;
>  
> Index: 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_dir2_sf.c	2007-08-23 23:03:09.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_dir2_sf.c	2007-12-07 10:20:57.887115812 +1100
> @@ -752,7 +752,7 @@ xfs_dir2_sf_getdents(
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
>  #endif
> -		if (filldir(dirent, ".", 1, dotdot_offset, ino, DT_DIR)) {
> +		if (filldir(dirent, ".", 1, dot_offset, ino, DT_DIR)) {
>  			*offset = dot_offset;
>  			return 0;
>  		}
> @@ -762,13 +762,11 @@ xfs_dir2_sf_getdents(
>  	 * Put .. entry unless we're starting past it.
>  	 */
>  	if (*offset <= dotdot_offset) {
> -		off = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
> -						  XFS_DIR2_DATA_FIRST_OFFSET);
>  		ino = xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent);
>  #if XFS_BIG_INUMS
>  		ino += mp->m_inoadd;
>  #endif
> -		if (filldir(dirent, "..", 2, off, ino, DT_DIR)) {
> +		if (filldir(dirent, "..", 2, dotdot_offset, ino, DT_DIR)) {
>  			*offset = dotdot_offset;
>  			return 0;
>  		}
> @@ -793,8 +791,7 @@ xfs_dir2_sf_getdents(
>  #endif
>  
>  		if (filldir(dirent, sfep->name, sfep->namelen,
> -			    off + xfs_dir2_data_entsize(sfep->namelen),
> -			    ino, DT_UNKNOWN)) {
> +					    off, ino, DT_UNKNOWN)) {
>  			*offset = off;
>  			return 0;
>  		}
> Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-12-03 17:11:46.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-12-07 11:25:42.678472255 +1100
> @@ -1772,7 +1772,6 @@ xfs_dm_get_dioinfo(
>  
>  typedef struct dm_readdir_cb {
>  	xfs_mount_t		*mp;
> -	xfs_off_t		lastoff;
>  	char __user		*ubuf;
>  	dm_stat_t __user	*lastbuf;
>  	size_t			spaceleft;
> @@ -1834,7 +1833,6 @@ dm_filldir(void *__buf, const char *name
>  	cb->spaceleft -= statp->_link;
>  	cb->nwritten += statp->_link;
>  	cb->ubuf += statp->_link;
> -	cb->lastoff = offset;
>  
>  	return 0;
>  
> @@ -1910,8 +1908,6 @@ xfs_dm_get_dirattrs_rvp(
>  		goto out_kfree;
>  	}
>  
> -	loc = cb->lastoff;
> -
>  	error = -EFAULT;
>  	if (cb->lastbuf && put_user(0, &cb->lastbuf->_link))
>  		goto out_kfree;
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_file.c	2007-12-03 18:41:26.000000000 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_file.c	2007-12-07 12:36:52.123061435 +1100
> @@ -357,13 +357,13 @@ xfs_file_readdir(
>  
>  			reclen = sizeof(struct hack_dirent) + de->namlen;
>  			size -= reclen;
> -			curr_offset = de->offset /* & 0x7fffffff */;
>  			de = (struct hack_dirent *)((char *)de + reclen);
> +			curr_offset = de->offset /* & 0x7fffffff */;
>  		}
>  	}
>  
>   done:
> - 	if (!error) {
> +	if (!error) {
>  		if (size == 0)
>  			filp->f_pos = offset & 0x7fffffff;
>  		else if (de)

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
