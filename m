Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43490 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932652AbcI1QT5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Sep 2016 12:19:57 -0400
Date: Wed, 28 Sep 2016 12:19:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/63] xfs: return an error when an inline directory is
 too small
Message-ID: <20160928161954.GA8852@bfoster.bfoster>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
 <147503122305.30303.17555276635568155992.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147503122305.30303.17555276635568155992.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

On Tue, Sep 27, 2016 at 07:53:43PM -0700, Darrick J. Wong wrote:
> If the size of an inline directory is so small that it doesn't
> even cover the required header size, return an error to userspace
> instead of ASSERTing and returning 0 like everything's ok.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dir2_readdir.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index f44f799..2981698 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -84,7 +84,8 @@ xfs_dir2_sf_getdents(
>  
>  	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>  
> -	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
> +	if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
> +		return -EFSCORRUPTED;
>  
>  	/*
>  	 * If the block number in the offset is out of range, we're done.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
