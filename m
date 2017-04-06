Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754573AbdDFQ64 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 12:58:56 -0400
Date: Thu, 6 Apr 2017 12:58:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: actually report xattr extents via iomap
Message-ID: <20170406165854.GA52095@bfoster.bfoster>
References: <20170406160356.GY4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170406160356.GY4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>

On Thu, Apr 06, 2017 at 09:03:56AM -0700, Darrick J. Wong wrote:
> Apparently FIEMAP for xattrs has been broken since we switched to
> the iomap backend because of an incorrect check for xattr presence.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 288ee5b..4f118a1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1173,7 +1173,7 @@ xfs_xattr_iomap_begin(
>  	lockmode = xfs_ilock_data_map_shared(ip);
>  
>  	/* if there are no attribute fork or extents, return ENOENT */
> -	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
> +	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
>  		error = -ENOENT;
>  		goto out_unlock;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
