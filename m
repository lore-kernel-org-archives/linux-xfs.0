Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 19:31:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l732V6bm003064
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 19:31:10 -0700
Message-ID: <46B2911A.60308@sgi.com>
Date: Fri, 03 Aug 2007 12:21:14 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] remove unessecary vfs argument to DM_EVENT_ENABLED
References: <20070802143417.GA30414@lst.de>
In-Reply-To: <20070802143417.GA30414@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

It is looking good Christoph. I built it and ran DMAPI QA and all went fine.
Dave is also looking at it and would provide a feedback.

Regards,
Vlad

Christoph Hellwig wrote:
> We can easily derive the vfs from the inode passed in.  Also kill
> the unused DM_EVENT_ENABLED_IO macro.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-01 19:53:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-01 19:53:42.000000000 +0200
> @@ -3271,8 +3271,7 @@ xfs_dm_send_mmap_event(
>  
>  	xfs_ilock(ip, iolock);
>  	/* If write possible, try a DMAPI write event */
> -	if ((max_event == DM_EVENT_WRITE) &&
> -	    DM_EVENT_ENABLED(vp->v_vfsp, ip, max_event)){
> +	if (max_event == DM_EVENT_WRITE && DM_EVENT_ENABLED(ip, max_event)) {
>  		error = xfs_dm_send_data_event(max_event, vp, offset,
>  					       evsize, 0, &locktype);
>  		goto out_unlock;
> @@ -3281,7 +3280,7 @@ xfs_dm_send_mmap_event(
>  	/* Try a read event if max_event was != DM_EVENT_WRITE or if it
>  	 * was DM_EVENT_WRITE but the WRITE event was not enabled.
>  	 */
> -	if (DM_EVENT_ENABLED (vp->v_vfsp, ip, DM_EVENT_READ)) {
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ)) {
>  		error = xfs_dm_send_data_event(DM_EVENT_READ, vp, offset,
>  					       evsize, 0, &locktype);
>  	}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-08-01 19:53:22.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-08-01 19:53:42.000000000 +0200
> @@ -384,7 +384,7 @@ xfs_file_open_exec(
>  
>  		if (!ip)
>  			return -EINVAL;
> -		if (DM_EVENT_ENABLED(vp->v_vfsp, ip, DM_EVENT_READ))
> +		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ))
>  			return -XFS_SEND_DATA(mp, DM_EVENT_READ, vp,
>  					       0, 0, 0, NULL);
>  	}
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-01 19:53:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-01 19:56:14.000000000 +0200
> @@ -245,8 +245,7 @@ xfs_read(
>  		mutex_lock(&inode->i_mutex);
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  
> -	if (DM_EVENT_ENABLED(vp->v_vfsp, ip, DM_EVENT_READ) &&
> -	    !(ioflags & IO_INVIS)) {
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
>  		bhv_vrwlock_t locktype = VRWLOCK_READ;
>  		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
>  
> @@ -307,8 +306,7 @@ xfs_sendfile(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  
> -	if (DM_EVENT_ENABLED(BHV_TO_VNODE(bdp)->v_vfsp, ip, DM_EVENT_READ) &&
> -	    (!(ioflags & IO_INVIS))) {
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
>  		bhv_vrwlock_t locktype = VRWLOCK_READ;
>  		int error;
>  
> @@ -351,8 +349,7 @@ xfs_splice_read(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  
> -	if (DM_EVENT_ENABLED(BHV_TO_VNODE(bdp)->v_vfsp, ip, DM_EVENT_READ) &&
> -	    (!(ioflags & IO_INVIS))) {
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ) && !(ioflags & IO_INVIS)) {
>  		bhv_vrwlock_t locktype = VRWLOCK_READ;
>  		int error;
>  
> @@ -398,8 +395,7 @@ xfs_splice_write(
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
>  
> -	if (DM_EVENT_ENABLED(BHV_TO_VNODE(bdp)->v_vfsp, ip, DM_EVENT_WRITE) &&
> -	    (!(ioflags & IO_INVIS))) {
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_WRITE) && !(ioflags & IO_INVIS)) {
>  		bhv_vrwlock_t locktype = VRWLOCK_WRITE;
>  		int error;
>  
> @@ -724,7 +720,7 @@ start:
>  		goto out_unlock_mutex;
>  	}
>  
> -	if ((DM_EVENT_ENABLED(vp->v_vfsp, xip, DM_EVENT_WRITE) &&
> +	if ((DM_EVENT_ENABLED(xip, DM_EVENT_WRITE) &&
>  	    !(ioflags & IO_INVIS) && !eventsent)) {
>  		int		dmflags = FILP_DELAY_FLAG(file);
>  
> @@ -876,10 +872,8 @@ retry:
>  	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
>  		ret = wait_on_sync_kiocb(iocb);
>  
> -	if ((ret == -ENOSPC) &&
> -	    DM_EVENT_ENABLED(vp->v_vfsp, xip, DM_EVENT_NOSPACE) &&
> -	    !(ioflags & IO_INVIS)) {
> -
> +	if (ret == -ENOSPC &&
> +	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
>  		xfs_rwunlock(bdp, locktype);
>  		if (need_i_mutex)
>  			mutex_unlock(&inode->i_mutex);
> Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2007-08-01 19:53:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2007-08-01 19:53:42.000000000 +0200
> @@ -5811,10 +5811,9 @@ xfs_getbmap(
>  	 *	could misinterpret holes in a DMAPI file as true holes,
>  	 *	when in fact they may represent offline user data.
>  	 */
> -	if (   (interface & BMV_IF_NO_DMAPI_READ) == 0
> -	    && DM_EVENT_ENABLED(vp->v_vfsp, ip, DM_EVENT_READ)
> -	    && whichfork == XFS_DATA_FORK) {
> -
> +	if ((interface & BMV_IF_NO_DMAPI_READ) == 0 &&
> +	    DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
> +	    whichfork == XFS_DATA_FORK) {
>  		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, 0, 0, 0, NULL);
>  		if (error)
>  			return XFS_ERROR(error);
> Index: linux-2.6-xfs/fs/xfs/xfs_dmapi.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_dmapi.h	2007-08-01 19:53:16.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_dmapi.h	2007-08-01 19:53:42.000000000 +0200
> @@ -67,18 +67,12 @@ typedef enum {
>  #define HAVE_DM_RIGHT_T
>  
>  /* Defines for determining if an event message should be sent. */
> -#define	DM_EVENT_ENABLED(vfsp, ip, event) ( \
> -	unlikely ((vfsp)->vfs_flag & VFS_DMI) && \
> +#define	DM_EVENT_ENABLED(ip, event) ( \
> +	unlikely (XFS_MTOVFS((ip)->i_mount)->vfs_flag & VFS_DMI) && \
>  		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
>  		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
>  	)
>  
> -#define	DM_EVENT_ENABLED_IO(vfsp, io, event) ( \
> -	unlikely ((vfsp)->vfs_flag & VFS_DMI) && \
> -		( ((io)->io_dmevmask & (1 << event)) || \
> -		  ((io)->io_mount->m_dmevmask & (1 << event)) ) \
> -	)
> -
>  #define DM_XFS_VALID_FS_EVENTS		( \
>  	(1 << DM_EVENT_PREUNMOUNT)	| \
>  	(1 << DM_EVENT_UNMOUNT)		| \
> Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2007-08-01 19:53:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2007-08-01 19:53:42.000000000 +0200
> @@ -264,9 +264,8 @@ xfs_rename(
>  	src_dp = XFS_BHVTOI(src_dir_bdp);
>  	mp = src_dp->i_mount;
>  
> -	if (DM_EVENT_ENABLED(src_dir_vp->v_vfsp, src_dp, DM_EVENT_RENAME) ||
> -	    DM_EVENT_ENABLED(target_dir_vp->v_vfsp,
> -				target_dp, DM_EVENT_RENAME)) {
> +	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
> +	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
>  					src_dir_vp, DM_RIGHT_NULL,
>  					target_dir_vp, DM_RIGHT_NULL,
> @@ -603,9 +602,8 @@ xfs_rename(
>  	/* Fall through to std_return with error = 0 or errno from
>  	 * xfs_trans_commit	 */
>  std_return:
> -	if (DM_EVENT_ENABLED(src_dir_vp->v_vfsp, src_dp, DM_EVENT_POSTRENAME) ||
> -	    DM_EVENT_ENABLED(target_dir_vp->v_vfsp,
> -				target_dp, DM_EVENT_POSTRENAME)) {
> +	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_POSTRENAME) ||
> +	    DM_EVENT_ENABLED(target_dp, DM_EVENT_POSTRENAME)) {
>  		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
>  					src_dir_vp, DM_RIGHT_NULL,
>  					target_dir_vp, DM_RIGHT_NULL,
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-01 19:53:27.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-01 19:58:06.000000000 +0200
> @@ -337,7 +337,7 @@ xfs_setattr(
>  			}
>  		}
>  	} else {
> -		if (DM_EVENT_ENABLED (vp->v_vfsp, ip, DM_EVENT_TRUNCATE) &&
> +		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
>  		    !(flags & ATTR_DMI)) {
>  			int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
>  			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, vp,
> @@ -896,7 +896,7 @@ xfs_setattr(
>  		return code;
>  	}
>  
> -	if (DM_EVENT_ENABLED(vp->v_vfsp, ip, DM_EVENT_ATTRIBUTE) &&
> +	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
>  	    !(flags & ATTR_DMI)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, vp, DM_RIGHT_NULL,
>  					NULL, DM_RIGHT_NULL, NULL, NULL,
> @@ -1651,8 +1651,7 @@ xfs_inactive(
>  
>  	mp = ip->i_mount;
>  
> -	if (ip->i_d.di_nlink == 0 &&
> -	    DM_EVENT_ENABLED(vp->v_vfsp, ip, DM_EVENT_DESTROY)) {
> +	if (ip->i_d.di_nlink == 0 && DM_EVENT_ENABLED(ip, DM_EVENT_DESTROY)) {
>  		(void) XFS_SEND_DESTROY(mp, vp, DM_RIGHT_NULL);
>  	}
>  
> @@ -1907,7 +1906,7 @@ xfs_create(
>  	dm_di_mode = vap->va_mode;
>  	namelen = VNAMELEN(dentry);
>  
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_CREATE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
>  				dir_vp, DM_RIGHT_NULL, NULL,
>  				DM_RIGHT_NULL, name, NULL,
> @@ -2072,9 +2071,8 @@ xfs_create(
>  	/* Fallthrough to std_return with error = 0  */
>  
>  std_return:
> -	if ( (*vpp || (error != 0 && dm_event_sent != 0)) &&
> -			DM_EVENT_ENABLED(dir_vp->v_vfsp, XFS_BHVTOI(dir_bdp),
> -							DM_EVENT_POSTCREATE)) {
> +	if ((*vpp || (error != 0 && dm_event_sent != 0)) &&
> +	    DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTCREATE)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
>  			dir_vp, DM_RIGHT_NULL,
>  			*vpp ? vp:NULL,
> @@ -2408,7 +2406,7 @@ xfs_remove(
>  		IRELE(ip);
>  	}
>  
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_REMOVE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dir_vp,
>  					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
>  					name, NULL, dm_di_mode, 0, 0);
> @@ -2584,8 +2582,7 @@ xfs_remove(
>  
>  /*	Fall through to std_return with error = 0 */
>   std_return:
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp,
> -						DM_EVENT_POSTREMOVE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
>  				dir_vp, DM_RIGHT_NULL,
>  				NULL, DM_RIGHT_NULL,
> @@ -2662,7 +2659,7 @@ xfs_link(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
>  
> -	if (DM_EVENT_ENABLED(src_vp->v_vfsp, tdp, DM_EVENT_LINK)) {
> +	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
>  					target_dir_vp, DM_RIGHT_NULL,
>  					src_vp, DM_RIGHT_NULL,
> @@ -2773,8 +2770,7 @@ xfs_link(
>  
>  	/* Fall through to std_return with error = 0. */
>  std_return:
> -	if (DM_EVENT_ENABLED(src_vp->v_vfsp, sip,
> -						DM_EVENT_POSTLINK)) {
> +	if (DM_EVENT_ENABLED(sip, DM_EVENT_POSTLINK)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
>  				target_dir_vp, DM_RIGHT_NULL,
>  				src_vp, DM_RIGHT_NULL,
> @@ -2838,7 +2834,7 @@ xfs_mkdir(
>  	dp_joined_to_trans = B_FALSE;
>  	dm_di_mode = vap->va_mode;
>  
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_CREATE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
>  					dir_vp, DM_RIGHT_NULL, NULL,
>  					DM_RIGHT_NULL, dir_name, NULL,
> @@ -2995,9 +2991,8 @@ xfs_mkdir(
>  	 * xfs_trans_commit. */
>  
>  std_return:
> -	if ( (created || (error != 0 && dm_event_sent != 0)) &&
> -			DM_EVENT_ENABLED(dir_vp->v_vfsp, XFS_BHVTOI(dir_bdp),
> -						DM_EVENT_POSTCREATE)) {
> +	if ((created || (error != 0 && dm_event_sent != 0)) &&
> +	    DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTCREATE)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
>  					dir_vp, DM_RIGHT_NULL,
>  					created ? XFS_ITOV(cdp):NULL,
> @@ -3066,7 +3061,7 @@ xfs_rmdir(
>  		IRELE(cdp);
>  	}
>  
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_REMOVE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
>  					dir_vp, DM_RIGHT_NULL,
>  					NULL, DM_RIGHT_NULL,
> @@ -3255,7 +3250,7 @@ xfs_rmdir(
>  	/* Fall through to std_return with error = 0 or the errno
>  	 * from xfs_trans_commit. */
>   std_return:
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_POSTREMOVE)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
>  					dir_vp, DM_RIGHT_NULL,
>  					NULL, DM_RIGHT_NULL,
> @@ -3359,7 +3354,7 @@ xfs_symlink(
>  		}
>  	}
>  
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, dp, DM_EVENT_SYMLINK)) {
> +	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dir_vp,
>  					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
>  					link_name, target_path, 0, 0, 0);
> @@ -3559,8 +3554,7 @@ xfs_symlink(
>  	/* Fall through to std_return with error = 0 or errno from
>  	 * xfs_trans_commit	*/
>  std_return:
> -	if (DM_EVENT_ENABLED(dir_vp->v_vfsp, XFS_BHVTOI(dir_bdp),
> -			     DM_EVENT_POSTSYMLINK)) {
> +	if (DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTSYMLINK)) {
>  		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
>  					dir_vp, DM_RIGHT_NULL,
>  					error ? NULL : XFS_ITOV(ip),
> @@ -4062,7 +4056,7 @@ xfs_alloc_file_space(
>  	/*	Generate a DMAPI event if needed.	*/
>  	if (alloc_type != 0 && offset < ip->i_size &&
>  			(attr_flags&ATTR_DMI) == 0  &&
> -			DM_EVENT_ENABLED(XFS_MTOVFS(mp), ip, DM_EVENT_WRITE)) {
> +			DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
>  		xfs_off_t           end_dmi_offset;
>  
>  		end_dmi_offset = offset+len;
> @@ -4176,9 +4170,8 @@ retry:
>  		allocatesize_fsb -= allocated_fsb;
>  	}
>  dmapi_enospc_check:
> -	if (error == ENOSPC && (attr_flags&ATTR_DMI) == 0 &&
> -	    DM_EVENT_ENABLED(XFS_MTOVFS(mp), ip, DM_EVENT_NOSPACE)) {
> -
> +	if (error == ENOSPC && (attr_flags & ATTR_DMI) == 0 &&
> +	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE)) {
>  		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
>  				XFS_ITOV(ip), DM_RIGHT_NULL,
>  				XFS_ITOV(ip), DM_RIGHT_NULL,
> @@ -4322,9 +4315,8 @@ xfs_free_file_space(
>  	end_dmi_offset = offset + len;
>  	endoffset_fsb = XFS_B_TO_FSBT(mp, end_dmi_offset);
>  
> -	if (offset < ip->i_size &&
> -	    (attr_flags & ATTR_DMI) == 0 &&
> -	    DM_EVENT_ENABLED(XFS_MTOVFS(mp), ip, DM_EVENT_WRITE)) {
> +	if (offset < ip->i_size && (attr_flags & ATTR_DMI) == 0 &&
> +	    DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
>  		if (end_dmi_offset > ip->i_size)
>  			end_dmi_offset = ip->i_size;
>  		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, vp,
>
>   
