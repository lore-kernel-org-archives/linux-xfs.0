Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935207AbdADOdw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 09:33:52 -0500
Date: Wed, 4 Jan 2017 09:33:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: bump up reserved blocks in xfs_alloc_set_aside
Message-ID: <20170104143350.GA41989@bfoster.bfoster>
References: <1482436822-31546-1-git-send-email-hch@lst.de>
 <1482436822-31546-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482436822-31546-2-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Thu, Dec 22, 2016 at 09:00:18PM +0100, Christoph Hellwig wrote:
> Setting aside 4 blocks globally for bmbt splits isn't all that useful,
> as different threads can allocate space in parallel.  Bump it to 4
> blocks per AG to allow each thread that is currently doing an
> allocation to dip into it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Presumably this patch addresses the potential deadlock issues from the
previous version, but the commit log description makes no mention of it
whatsoever. While the code seems fine, I think the commit log
description needs more information wrt to that situation and the
relationship/dependency with minleft.

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

The comment above xfs_alloc_set_aside() already touches on the writeback
situation, but why 4 blocks per ag? Wasn't the intent to use
worst_indlen() since that's the base for minleft?

Also, it looks like this causes a regression in xfs/004. On a quick
look, we might just need a test update however...

Brian

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
