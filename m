Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 480B27F51
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 07:57:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13BA18F8078
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 05:57:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Jh3ssRJJG5CUGycn for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 05:57:39 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0UDvcuV013251
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 08:57:38 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0UDvbaW027971
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 08:57:38 -0500
Message-ID: <52EA5A51.9050100@redhat.com>
Date: Thu, 30 Jan 2014 08:57:37 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: ensure correct timestamp updates from truncate
References: <20140110122700.GA12624@localhost>
	<52CFF402.5080409@oracle.com>	<20140110133306.GA22918@infradead.org>	<52CFFD1C.7050005@oracle.com>	<20140111111045.GA29380@infradead.org>	<52E8FE81.7040402@redhat.com>
	<20140130080652.GA23758@infradead.org>
In-Reply-To: <20140130080652.GA23758@infradead.org>
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
To: xfs@oss.sgi.com

On 01/30/2014 03:06 AM, Christoph Hellwig wrote:
> The VFS doesn't set the proper ATTR_CTIME and ATTR_MTIME values for truncate,
> so filesystems have to manually add them.  The introduction of
> xfs_setattr_time accidentally broke this special case an caused a
> regression in generic/313.  Fix this by removing the local mask variable
> in xfs_setattr_size so that we only have a single place to keep the
> attribute information.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> 

Thanks Christoph!

Reviewed-by: Brian Foster <bfoster@redhat.com>

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 0ce1d75..ce966c5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -714,7 +714,6 @@ xfs_setattr_size(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct inode		*inode = VFS_I(ip);
> -	int			mask = iattr->ia_valid;
>  	xfs_off_t		oldsize, newsize;
>  	struct xfs_trans	*tp;
>  	int			error;
> @@ -735,8 +734,8 @@ xfs_setattr_size(
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
>  	ASSERT(S_ISREG(ip->i_d.di_mode));
> -	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> -			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
> +	ASSERT((iattr->ia_valid & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
> +		ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
>  
>  	oldsize = inode->i_size;
>  	newsize = iattr->ia_size;
> @@ -745,7 +744,7 @@ xfs_setattr_size(
>  	 * Short circuit the truncate case for zero length files.
>  	 */
>  	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
> -		if (!(mask & (ATTR_CTIME|ATTR_MTIME)))
> +		if (!(iattr->ia_valid & (ATTR_CTIME|ATTR_MTIME)))
>  			return 0;
>  
>  		/*
> @@ -833,10 +832,11 @@ xfs_setattr_size(
>  	 * these flags set.  For all other operations the VFS set these flags
>  	 * explicitly if it wants a timestamp update.
>  	 */
> -	if (newsize != oldsize && (!(mask & (ATTR_CTIME | ATTR_MTIME)))) {
> +	if (newsize != oldsize &&
> +	    !(iattr->ia_valid & (ATTR_CTIME | ATTR_MTIME))) {
>  		iattr->ia_ctime = iattr->ia_mtime =
>  			current_fs_time(inode->i_sb);
> -		mask |= ATTR_CTIME | ATTR_MTIME;
> +		iattr->ia_valid |= ATTR_CTIME | ATTR_MTIME;
>  	}
>  
>  	/*
> @@ -872,9 +872,9 @@ xfs_setattr_size(
>  		xfs_inode_clear_eofblocks_tag(ip);
>  	}
>  
> -	if (mask & ATTR_MODE)
> +	if (iattr->ia_valid & ATTR_MODE)
>  		xfs_setattr_mode(ip, iattr);
> -	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
> +	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
>  		xfs_setattr_time(ip, iattr);
>  
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
