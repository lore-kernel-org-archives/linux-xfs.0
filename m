Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9725B7CA4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 07:38:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3281D8F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3qhHxTKxWRI5L3TD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:06 -0700 (PDT)
Date: Thu, 25 Aug 2016 08:38:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: factor our a helper to calculate the EOF
	alignment
Message-ID: <20160825123804.GB25041@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471816273-28940-3-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 11:51:11PM +0200, Christoph Hellwig wrote:
> And drop the pointless mp argument to xfs_iomap_eof_align_last_fsb,
> while we're at it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index ba3592f..918511a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -70,15 +70,13 @@ xfs_bmbt_to_iomap(
>  	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
>  }
>  
> -STATIC int
> -xfs_iomap_eof_align_last_fsb(
> -	xfs_mount_t	*mp,
> -	xfs_inode_t	*ip,
> -	xfs_extlen_t	extsize,
> -	xfs_fileoff_t	*last_fsb)
> +static xfs_extlen_t
> +xfs_eof_alignment(
> +	struct xfs_inode	*ip,
> +	xfs_extlen_t		extsize)
>  {
> -	xfs_extlen_t	align = 0;
> -	int		eof, error;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_extlen_t		align = 0;
>  
>  	if (!XFS_IS_REALTIME_INODE(ip)) {
>  		/*
> @@ -109,8 +107,21 @@ xfs_iomap_eof_align_last_fsb(
>  			align = extsize;
>  	}
>  
> +	return align;
> +}
> +
> +STATIC int
> +xfs_iomap_eof_align_last_fsb(
> +	struct xfs_inode	*ip,
> +	xfs_extlen_t		extsize,
> +	xfs_fileoff_t		*last_fsb)
> +{
> +	xfs_extlen_t		align = xfs_eof_alignment(ip, extsize);
> +
>  	if (align) {
>  		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);
> +		int		eof, error;
> +
>  		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
>  		if (error)
>  			return error;
> @@ -180,7 +191,7 @@ xfs_iomap_write_direct(
>  		 */
>  		ASSERT(XFS_IFORK_PTR(ip, XFS_DATA_FORK)->if_flags &
>  								XFS_IFEXTENTS);
> -		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
> +		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
>  		if (error)
>  			goto out_unlock;
>  	} else {
> @@ -638,7 +649,7 @@ retry:
>  	}
>  
>  	if (prealloc || extsz) {
> -		error = xfs_iomap_eof_align_last_fsb(mp, ip, extsz, &last_fsb);
> +		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
>  		if (error)
>  			return error;
>  	}
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
