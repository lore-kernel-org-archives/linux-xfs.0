Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC9BE7F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 09:20:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A15508F8040
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 07:20:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7EdqH9y7aYv7WJ40 for
	<xfs@oss.sgi.com>; Thu, 30 May 2013 07:20:27 -0700 (PDT)
Message-ID: <51A75F7A.6040302@redhat.com>
Date: Thu, 30 May 2013 10:17:30 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/9] xfs: kill suid/sgid through the truncate path.
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/27/2013 02:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS has failed to kill suid/sgid bits correctly when truncating
> files of non-zero size since commit c4ed4243 ("xfs: split
> xfs_setattr") introduced in the 3.1 kernel. Fix it.
> 

The code makes sense and I can easily hit an assert when truncating
(extending) a suid file on a debug kernel without this patch (and I see
the suid dropped with the patch).

The changelog seems slightly misleading (implying any truncate of a zero
sized file should work, when really only 0->0 size truncates work), but
not a big deal...

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Fix it.
> 
> cc: stable kernel <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iops.c |   47 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index d82efaa..ca9ecaa 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -455,6 +455,28 @@ xfs_vn_getattr(
>  	return 0;
>  }
>  
> +static void
> +xfs_setattr_mode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct iattr		*iattr)
> +{
> +	struct inode	*inode = VFS_I(ip);
> +	umode_t		mode = iattr->ia_mode;
> +
> +	ASSERT(tp);
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +
> +	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +		mode &= ~S_ISGID;
> +
> +	ip->i_d.di_mode &= S_IFMT;
> +	ip->i_d.di_mode |= mode & ~S_IFMT;
> +
> +	inode->i_mode &= S_IFMT;
> +	inode->i_mode |= mode & ~S_IFMT;
> +}
> +
>  int
>  xfs_setattr_nonsize(
>  	struct xfs_inode	*ip,
> @@ -606,18 +628,8 @@ xfs_setattr_nonsize(
>  	/*
>  	 * Change file access modes.
>  	 */
> -	if (mask & ATTR_MODE) {
> -		umode_t mode = iattr->ia_mode;
> -
> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -			mode &= ~S_ISGID;
> -
> -		ip->i_d.di_mode &= S_IFMT;
> -		ip->i_d.di_mode |= mode & ~S_IFMT;
> -
> -		inode->i_mode &= S_IFMT;
> -		inode->i_mode |= mode & ~S_IFMT;
> -	}
> +	if (mask & ATTR_MODE)
> +		xfs_setattr_mode(tp, ip, iattr);
>  
>  	/*
>  	 * Change file access or modified times.
> @@ -714,9 +726,8 @@ xfs_setattr_size(
>  		return XFS_ERROR(error);
>  
>  	ASSERT(S_ISREG(ip->i_d.di_mode));
> -	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> -			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
> -			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> +			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
>  	if (!(flags & XFS_ATTR_NOLOCK)) {
>  		lock_flags |= XFS_IOLOCK_EXCL;
> @@ -860,6 +871,12 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> +	/*
> +	 * Change file access modes.
> +	 */
> +	if (mask & ATTR_MODE)
> +		xfs_setattr_mode(tp, ip, iattr);
> +
>  	if (mask & ATTR_CTIME) {
>  		inode->i_ctime = iattr->ia_ctime;
>  		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
