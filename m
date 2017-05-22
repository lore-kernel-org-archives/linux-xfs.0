Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758295AbdEVRu4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 13:50:56 -0400
Date: Mon, 22 May 2017 13:50:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: Move handling of missing page into one place in
 xfs_find_get_desired_pgoff()
Message-ID: <20170522175050.GC1473@bfoster.bfoster>
References: <20170518104850.14508-1-jack@suse.cz>
 <20170518104850.14508-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518104850.14508-4-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Thu, May 18, 2017 at 12:48:50PM +0200, Jan Kara wrote:
> Currently several places in xfs_find_get_desired_pgoff() handle the case
> of a missing page. Make them all handled in one place after the loop has
> terminated.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 38 ++++++++------------------------------
>  1 file changed, 8 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 3714b5736fd3..204e81abce05 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1052,29 +1052,8 @@ xfs_find_get_desired_pgoff(
>  		want = min_t(pgoff_t, end - index, PAGEVEC_SIZE);
>  		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>  					  want);
> -		/*
> -		 * No page mapped into given range.  If we are searching holes
> -		 * and if this is the first time we got into the loop, it means
> -		 * that the given offset is landed in a hole, return it.
> -		 *
> -		 * If we have already stepped through some block buffers to find
> -		 * holes but they all contains data.  In this case, the last
> -		 * offset is already updated and pointed to the end of the last
> -		 * mapped page, if it does not reach the endpoint to search,
> -		 * that means there should be a hole between them.
> -		 */
> -		if (nr_pages == 0) {
> -			/* Data search found nothing */
> -			if (type == DATA_OFF)
> -				break;
> -
> -			ASSERT(type == HOLE_OFF);
> -			if (lastoff == startoff || lastoff < endoff) {
> -				found = true;
> -				*offset = lastoff;
> -			}
> +		if (nr_pages == 0)
>  			break;
> -		}
>  
>  		for (i = 0; i < nr_pages; i++) {
>  			struct page	*page = pvec.pages[i];
> @@ -1140,21 +1119,20 @@ xfs_find_get_desired_pgoff(
>  
>  		/*
>  		 * The number of returned pages less than our desired, search
> -		 * done.  In this case, nothing was found for searching data,
> -		 * but we found a hole behind the last offset.
> +		 * done.
>  		 */
> -		if (nr_pages < want) {
> -			if (type == HOLE_OFF) {
> -				*offset = lastoff;
> -				found = true;
> -			}
> +		if (nr_pages < want)
>  			break;
> -		}
>  
>  		index = pvec.pages[i - 1]->index + 1;
>  		pagevec_release(&pvec);
>  	} while (index <= end);
>  
> +	/* No page at lastoff and we are not done - we found a hole. */
> +	if (type == HOLE_OFF && lastoff < endoff) {
> +		*offset = lastoff;
> +		found = true;
> +	}
>  out:
>  	pagevec_release(&pvec);
>  	return found;
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
