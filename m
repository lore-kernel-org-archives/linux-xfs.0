Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751754AbdAIUAA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 15:00:00 -0500
Date: Mon, 9 Jan 2017 14:59:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: bump up reserved blocks in xfs_alloc_set_aside
Message-ID: <20170109195958.GF22368@bfoster.bfoster>
References: <1483991622-2339-1-git-send-email-hch@lst.de>
 <1483991622-2339-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483991622-2339-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Mon, Jan 09, 2017 at 08:53:39PM +0100, Christoph Hellwig wrote:
> Setting aside 4 blocks globally for bmbt splits isn't all that useful,
> as different threads can allocate space in parallel.  Bump it to 4
> blocks per AG to allow each thread that is currently doing an
> allocation to dip into it separately.  Without that we may no have
> enough reserved blocks if there are enough parallel transactions
> in an almost out space file system that all run into bmap btree
> splits.
> 

Thanks.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 5050056..0a46f84 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -95,10 +95,7 @@ unsigned int
>  xfs_alloc_set_aside(
>  	struct xfs_mount	*mp)
>  {
> -	unsigned int		blocks;
> -
> -	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
> -	return blocks;
> +	return mp->m_sb.sb_agcount * (XFS_ALLOC_AGFL_RESERVE + 4);
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
