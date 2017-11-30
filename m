Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbdK3NrJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 08:47:09 -0500
Date: Thu, 30 Nov 2017 08:47:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: remove unused parameter from xfs_writepage_map
Message-ID: <20171130134707.GB3516@bfoster.bfoster>
References: <151189079681.14861.10709810493861130558.stgit@magnolia>
 <151189080319.14861.3665951105884303570.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151189080319.14861.3665951105884303570.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 28, 2017 at 09:40:03AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The first thing that xfs_writepage_map does is clobber the offset
> parameter.  Since we never use the passed-in value, turn the parameter
> into a local variable.  This gets rid of an UBSAN warning in generic/466.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I thought Dave might have had a patch that addresses this, but no harm
in fixing it on its own:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_aops.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index b0cccf8..21e2d70 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -896,13 +896,13 @@ xfs_writepage_map(
>  	struct writeback_control *wbc,
>  	struct inode		*inode,
>  	struct page		*page,
> -	loff_t			offset,
> -	uint64_t              end_offset)
> +	uint64_t		end_offset)
>  {
>  	LIST_HEAD(submit_list);
>  	struct xfs_ioend	*ioend, *next;
>  	struct buffer_head	*bh, *head;
>  	ssize_t			len = i_blocksize(inode);
> +	uint64_t		offset;
>  	int			error = 0;
>  	int			count = 0;
>  	int			uptodate = 1;
> @@ -1146,7 +1146,7 @@ xfs_do_writepage(
>  		end_offset = offset;
>  	}
>  
> -	return xfs_writepage_map(wpc, wbc, inode, page, offset, end_offset);
> +	return xfs_writepage_map(wpc, wbc, inode, page, end_offset);
>  
>  redirty:
>  	redirty_page_for_writepage(wbc, page);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
