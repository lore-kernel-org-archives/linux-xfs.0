Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBLGDpP2033620 for <xfs@oss.sgi.com>; Wed, 21 Dec 2011 10:13:52 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	csj0HzLjzfMZ1L5z for <xfs@oss.sgi.com>;
	Wed, 21 Dec 2011 08:13:50 -0800 (PST)
Date: Wed, 21 Dec 2011 11:13:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: clean up minor sparse warnings
Message-ID: <20111221161349.GB7001@infradead.org>
References: <1324426062-21505-1-git-send-email-david@fromorbit.com>
	<1324426062-21505-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1324426062-21505-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d99a905..2f3f56a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -230,24 +230,22 @@ xfs_open_by_handle(
>  
>  	/* Put open permission in namei format. */
>  	permflag = hreq->oflags;
> -	if ((permflag+1) & O_ACCMODE)
> -		permflag++;
>  	if (permflag & O_TRUNC)
> -		permflag |= 2;
> +		permflag |= O_RDWR;
>  
>  	if ((!(permflag & O_APPEND) || (permflag & O_TRUNC)) &&
> -	    (permflag & FMODE_WRITE) && IS_APPEND(inode)) {
> +	    (OPEN_FMODE(permflag) & FMODE_WRITE) && IS_APPEND(inode)) {
>  		error = -XFS_ERROR(EPERM);
>  		goto out_dput;
>  	}
>  
> -	if ((permflag & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
> +	if ((OPEN_FMODE(permflag) & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
>  		error = -XFS_ERROR(EACCES);
>  		goto out_dput;
>  	}
>  
>  	/* Can't write directories. */
> -	if (S_ISDIR(inode->i_mode) && (permflag & FMODE_WRITE)) {
> +	if (S_ISDIR(inode->i_mode) && (OPEN_FMODE(permflag) & FMODE_WRITE)) {
>  		error = -XFS_ERROR(EISDIR);
>  		goto out_dput;
>  	}

I think this one is complicated enough that is deserves a separate
patch and a better description.

For the other small bits:


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
