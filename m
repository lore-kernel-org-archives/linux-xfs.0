Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42526 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdIARw5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 13:52:57 -0400
Date: Fri, 1 Sep 2017 10:52:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: don't set v3 xflags for v2 inodes
Message-ID: <20170901175223.GH3775@magnolia>
References: <20170830155517.GI4757@magnolia>
 <20170830163825.GQ4757@magnolia>
 <20170831131723.GD19544@infradead.org>
 <20170831133420.GB21939@bfoster.bfoster>
 <20170831140932.GB26555@infradead.org>
 <20170831195729.GM3775@magnolia>
 <20170901072149.GA7443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901072149.GA7443@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Fri, Sep 01, 2017 at 12:21:49AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 31, 2017 at 12:57:29PM -0700, Darrick J. Wong wrote:
> > TBH I like this less because now the responsibility for checking valid
> > inputs is split between xfs_ioctl_setattr_xflags and xfs_set_diflags.
> > I'd rather increase the function count by one than morph the setting
> > function into check-and-set.
> 
> I'm not worried about the function count - I'm worried about duplicating
> the information of which flags are stored in di_flags2.  With this patch
> we have one point where we can naturally check this.  In your patch
> we need another define that needs to be kept uptodate.
> 
> If you are worried about the check and set we could move the set into
> the caller, but to me that doesn't seem any cleaner.  Example attached
> below:
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9c0c7a920304..511cd7c830ab 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -931,16 +931,15 @@ xfs_ioc_fsgetxattr(
>  	return 0;
>  }
>  
> -STATIC void
> -xfs_set_diflags(
> +STATIC unsigned int
> +xfs_flags2diflags(
>  	struct xfs_inode	*ip,
>  	unsigned int		xflags)
>  {
> -	unsigned int		di_flags;
> -	uint64_t		di_flags2;
> -
>  	/* can't set PREALLOC this way, just preserve it */
> -	di_flags = (ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> +	unsigned int		di_flags =
> +		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);

ip->i_d.di_flags is uint16_t, so di_flags ought to match, right?

Otherwise, I guess this looks ok, want to send it as a real patch?

--D

> +
>  	if (xflags & FS_XFLAG_IMMUTABLE)
>  		di_flags |= XFS_DIFLAG_IMMUTABLE;
>  	if (xflags & FS_XFLAG_APPEND)
> @@ -970,19 +969,24 @@ xfs_set_diflags(
>  		if (xflags & FS_XFLAG_EXTSIZE)
>  			di_flags |= XFS_DIFLAG_EXTSIZE;
>  	}
> -	ip->i_d.di_flags = di_flags;
>  
> -	/* diflags2 only valid for v3 inodes. */
> -	if (ip->i_d.di_version < 3)
> -		return;
> +	return di_flags;
> +}
> +
> +STATIC uint64_t
> +xfs_flags2diflags2(
> +	struct xfs_inode	*ip,
> +	unsigned int		xflags)
> +{
> +	uint64_t		di_flags2 =
> +		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
>  
> -	di_flags2 = (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
>  	if (xflags & FS_XFLAG_DAX)
>  		di_flags2 |= XFS_DIFLAG2_DAX;
>  	if (xflags & FS_XFLAG_COWEXTSIZE)
>  		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
>  
> -	ip->i_d.di_flags2 = di_flags2;
> +	return di_flags2;
>  }
>  
>  STATIC void
> @@ -1022,6 +1026,7 @@ xfs_ioctl_setattr_xflags(
>  	struct fsxattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	uint64_t		di_flags2;
>  
>  	/* Can't change realtime flag if any extents are allocated. */
>  	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
> @@ -1052,7 +1057,14 @@ xfs_ioctl_setattr_xflags(
>  	    !capable(CAP_LINUX_IMMUTABLE))
>  		return -EPERM;
>  
> -	xfs_set_diflags(ip, fa->fsx_xflags);
> +	/* diflags2 only valid for v3 inodes. */
> +	di_flags2 = xfs_flags2diflags(ip, fa->fsx_xflags);
> +	if (di_flags2 && ip->i_d.di_version < 3)
> +		return -EINVAL;
> +
> +	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
> +	ip->i_d.di_flags2 = di_flags2;
> +
>  	xfs_diflags_to_linux(ip);
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
