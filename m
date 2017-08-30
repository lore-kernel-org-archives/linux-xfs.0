Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51319 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdH3QYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:24:31 -0400
Date: Wed, 30 Aug 2017 09:24:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove unused flags arg from
 xfs_file_iomap_begin_delay
Message-ID: <20170830162402.GP4757@magnolia>
References: <8f1f6b47-988f-6cba-181d-d0be01fa3aa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f1f6b47-988f-6cba-181d-d0be01fa3aa2@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Wed, Aug 30, 2017 at 10:53:22AM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1b625d0..79cb5b3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -520,7 +520,6 @@
>  	struct inode		*inode,
>  	loff_t			offset,
>  	loff_t			count,
> -	unsigned		flags,
>  	struct iomap		*iomap)
>  {
>  	struct xfs_inode	*ip = XFS_I(inode);
> @@ -984,8 +983,7 @@ static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
>  	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
>  			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>  		/* Reserve delalloc blocks for regular writeback. */
> -		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> -				iomap);
> +		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
>  	}
>  
>  	if (need_excl_ilock(ip, flags)) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
