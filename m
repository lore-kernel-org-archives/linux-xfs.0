Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBMJ5iFe150654 for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 13:05:44 -0600
Received: from mail.parknet.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49A9D11F6CE
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2009 11:06:26 -0800 (PST)
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6]) by
	cuda.sgi.com with ESMTP id 6XLtjNqQlaq8VRNG for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2009 11:06:26 -0800 (PST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <20091222174500.GA7063@lst.de>
Date: Wed, 23 Dec 2009 04:06:20 +0900
In-Reply-To: <20091222174500.GA7063@lst.de> (Christoph Hellwig's message of
	"Tue, 22 Dec 2009 18:45:00 +0100")
Message-ID: <87aaxarfpv.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, Eric Blake <ebb9@byu.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> This patch which I had in my QA queue for a while should fix all the
> timestamp update issues in XFS:

Thanks for fixing this.

> Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-12-21 16:24:28.470990760 +0100
> +++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-12-21 16:32:41.348990760 +0100
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
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_acl.c	2009-12-21 16:31:51.838990759 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_acl.c	2009-12-21 16:32:17.471990759 +0100
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
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
