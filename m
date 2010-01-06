Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0611EGn001143 for <xfs@oss.sgi.com>; Tue, 5 Jan 2010 19:01:15 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] xfs: fix timestamp handling in xfs_setattr
Date: Tue, 5 Jan 2010 19:02:02 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6913@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091223160913.GA13039@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> We currently have some rather odd code in xfs_setattr for updating the
> a/c/mtime timestampts:
> 
>  - first we do a non-transaction update if all three are updated together
>  - second we implicitly update the ctime for various changes instead of
>    relying on the ATTR_CTIME flag
>  - third we set the timestamps to the current time instead of the arguments
>    in the iattr structure in many cases.
> 
> This patch makes sure we update it in a consistant way:
> 
>  - always transactional
>  - ctime is only updated if ATTR_CTIME is set or we do a size update, which
>    is a special case
>  - always to the times passed in from the caller instead of the current time
> 
> The only non-size caller of xfs_setattr that doesn't come from the VFS is
> updated to set ATTR_CTIME and pass in a valid ctime value.

This looks good to me, although I acknowledge I haven't worked through
it 100%.  Another reviewer would be good.  But even better, I really
want to see the gnulib timestamp unit tests into xfstests to verify
the behavior either way (which you indicated you'd work on...).  In
fact, if you've made any headway on it I'd like to run the tests against
this patch before committing it.

I'll run with this and will synch up with you on the timestamp tests,
and hope for another review.

Despite all that caveat crap...

> Reported-by: Eric Blake <ebb9@byu.net>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>
 
> Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-12-23 13:51:24.706170043 +0100
> +++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-12-23 13:51:30.774170044 +0100
> @@ -70,7 +70,6 @@ xfs_setattr(
>  	uint			commit_flags=0;
>  	uid_t			uid=0, iuid=0;
>  	gid_t			gid=0, igid=0;
> -	int			timeflags = 0;
>  	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
>  	int			need_iolock = 1;
> 
> @@ -135,16 +134,13 @@ xfs_setattr(
>  	if (flags & XFS_ATTR_NOLOCK)
>  		need_iolock = 0;
>  	if (!(mask & ATTR_SIZE)) {
> -		if ((mask != (ATTR_CTIME|ATTR_ATIME|ATTR_MTIME)) ||
> -		    (mp->m_flags & XFS_MOUNT_WSYNC)) {
> -			tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> -			commit_flags = 0;
> -			if ((code = xfs_trans_reserve(tp, 0,
> -						     XFS_ICHANGE_LOG_RES(mp), 0,
> -						     0, 0))) {
> -				lock_flags = 0;
> -				goto error_return;
> -			}
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> +		commit_flags = 0;
> +		code = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp),
> +					 0, 0, 0);
> +		if (code) {
> +			lock_flags = 0;
> +			goto error_return;
>  		}
>  	} else {
>  		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
> @@ -295,15 +291,23 @@ xfs_setattr(
>  		 * or we are explicitly asked to change it. This handles
>  		 * the semantic difference between truncate() and ftruncate()
>  		 * as implemented in the VFS.
> -		 */
> -		if (iattr->ia_size != ip->i_size || (mask & ATTR_CTIME))
> -			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
> +		 *
> +		 * The regular truncate() case without ATTR_CTIME and ATTR_MTIME
> +		 * is a special case where we need to update the times despite
> +		 * not having these flags set.  For all other operations the
> +		 * VFS set these flags explicitly if it wants a timestamp
> +		 * update.
> +		 */
> +		if (iattr->ia_size != ip->i_size &&
> +		    (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
> +			iattr->ia_ctime = iattr->ia_mtime =
> +				current_fs_time(inode->i_sb);
> +			mask |= ATTR_CTIME | ATTR_MTIME;
> +		}
> 
>  		if (iattr->ia_size > ip->i_size) {
>  			ip->i_d.di_size = iattr->ia_size;
>  			ip->i_size = iattr->ia_size;
> -			if (!(flags & XFS_ATTR_DMI))
> -				xfs_ichgtime(ip, XFS_ICHGTIME_CHG);
>  			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>  		} else if (iattr->ia_size <= ip->i_size ||
>  			   (iattr->ia_size == 0 && ip->i_d.di_nextents)) {
> @@ -374,9 +378,6 @@ xfs_setattr(
>  			ip->i_d.di_gid = gid;
>  			inode->i_gid = gid;
>  		}
> -
> -		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
> -		timeflags |= XFS_ICHGTIME_CHG;
>  	}
> 
>  	/*
> @@ -393,51 +394,37 @@ xfs_setattr(
> 
>  		inode->i_mode &= S_IFMT;
>  		inode->i_mode |= mode & ~S_IFMT;
> -
> -		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -		timeflags |= XFS_ICHGTIME_CHG;
>  	}
> 
>  	/*
>  	 * Change file access or modified times.
>  	 */
> -	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
> -		if (mask & ATTR_ATIME) {
> -			inode->i_atime = iattr->ia_atime;
> -			ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
> -			ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
> -			ip->i_update_core = 1;
> -		}
> -		if (mask & ATTR_MTIME) {
> -			inode->i_mtime = iattr->ia_mtime;
> -			ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
> -			ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
> -			timeflags &= ~XFS_ICHGTIME_MOD;
> -			timeflags |= XFS_ICHGTIME_CHG;
> -		}
> -		if (tp && (mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)))
> -			xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
> +	if (mask & ATTR_ATIME) {
> +		inode->i_atime = iattr->ia_atime;
> +		ip->i_d.di_atime.t_sec = iattr->ia_atime.tv_sec;
> +		ip->i_d.di_atime.t_nsec = iattr->ia_atime.tv_nsec;
> +		ip->i_update_core = 1;
>  	}
> -
> -	/*
> -	 * Change file inode change time only if ATTR_CTIME set
> -	 * AND we have been called by a DMI function.
> -	 */
> -
> -	if ((flags & XFS_ATTR_DMI) && (mask & ATTR_CTIME)) {
> +	if (mask & ATTR_CTIME) {
>  		inode->i_ctime = iattr->ia_ctime;
>  		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
>  		ip->i_d.di_ctime.t_nsec = iattr->ia_ctime.tv_nsec;
>  		ip->i_update_core = 1;
> -		timeflags &= ~XFS_ICHGTIME_CHG;
> +	}
> +	if (mask & ATTR_MTIME) {
> +		inode->i_mtime = iattr->ia_mtime;
> +		ip->i_d.di_mtime.t_sec = iattr->ia_mtime.tv_sec;
> +		ip->i_d.di_mtime.t_nsec = iattr->ia_mtime.tv_nsec;
> +		ip->i_update_core = 1;
>  	}
> 
>  	/*
> -	 * Send out timestamp changes that need to be set to the
> -	 * current time.  Not done when called by a DMI function.
> +	 * And finally, log the inode core if any attribute in it
> +	 * has been changed.
>  	 */
> -	if (timeflags && !(flags & XFS_ATTR_DMI))
> -		xfs_ichgtime(ip, timeflags);
> +	if (mask & (ATTR_UID|ATTR_GID|ATTR_MODE|
> +		    ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
>  	XFS_STATS_INC(xs_ig_attrchg);
> 
> @@ -452,12 +439,10 @@ xfs_setattr(
>  	 * mix so this probably isn't worth the trouble to optimize.
>  	 */
>  	code = 0;
> -	if (tp) {
> -		if (mp->m_flags & XFS_MOUNT_WSYNC)
> -			xfs_trans_set_sync(tp);
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(tp);
> 
> -		code = xfs_trans_commit(tp, commit_flags);
> -	}
> +	code = xfs_trans_commit(tp, commit_flags);
> 
>  	xfs_iunlock(ip, lock_flags);
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_acl.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_acl.c	2009-12-23 13:51:24.718170043 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_acl.c	2009-12-23 13:51:30.775170044 +0100
> @@ -251,8 +251,9 @@ xfs_set_mode(struct inode *inode, mode_t
>  	if (mode != inode->i_mode) {
>  		struct iattr iattr;
> 
> -		iattr.ia_valid = ATTR_MODE;
> +		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
>  		iattr.ia_mode = mode;
> +		iattr.ia_ctime = current_fs_time(inode->i_sb);
> 
>  		error = -xfs_setattr(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
