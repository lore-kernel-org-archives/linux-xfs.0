Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932336AbdIRMow (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 08:44:52 -0400
Date: Mon, 18 Sep 2017 08:44:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: remove redundant re-initialization of total_nr_pages
Message-ID: <20170918124450.GC29965@bfoster.bfoster>
References: <20170918120157.30134-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918120157.30134-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 18, 2017 at 01:01:57PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable total_nr_pages is being initialized and then updated with
> the same value, this latter assignment is redundant and can be
> removed.  Cleans up clang build warning:
> 
> Value stored to 'total_nr_pages' during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index da14658da310..2f97c12ca75e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1258,8 +1258,6 @@ xfs_buf_ioapply_map(
>  	int		size;
>  	int		offset;
>  
> -	total_nr_pages = bp->b_page_count;
> -
>  	/* skip the pages in the buffer before the start offset */
>  	page_index = 0;
>  	offset = *buf_offset;
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
