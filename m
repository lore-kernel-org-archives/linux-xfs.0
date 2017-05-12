Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50296 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932443AbdELQXK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 May 2017 12:23:10 -0400
Date: Fri, 12 May 2017 09:23:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: Move handling of missing page into one place in
 xfs_find_get_desired_pgoff()
Message-ID: <20170512162302.GG4519@birch.djwong.org>
References: <20170511165023.29887-1-jack@suse.cz>
 <20170511165023.29887-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511165023.29887-2-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org

On Thu, May 11, 2017 at 06:50:23PM +0200, Jan Kara wrote:
> Currently several places in xfs_find_get_desired_pgoff() handle the case
> of a missing page. Make them all handled in one place after the loop has
> terminated.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_file.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index df51c025adfe..719923b99ba1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1069,10 +1069,6 @@ xfs_find_get_desired_pgoff(
>  				break;
>  
>  			ASSERT(type == HOLE_OFF);
> -			if (lastoff == startoff || lastoff < endoff) {
> -				found = true;
> -				*offset = lastoff;
> -			}
>  			break;
>  		}

Hm.  This leaves the following weird looking hunk:

if (nr_pages == 0) {
	/* Data search found nothing */
	if (type == DATA_OFF)
		break;

	ASSERT(type == HOLE_OFF);
	break;
}

Which could be simplified to:

if (nr_pages == 0) {
	ASSERT(type == HOLE_OFF || type == DATA_OFF);
	break;
}

Right?  Maybe a better cleanup would be to name the enum defining
{HOLE,DATA}_OFF and change the xfs_find_get_desired_pgoff prototype to
use that enum, and then we also get compiler type checking.

The rest of this looks ok I think.

--D

> @@ -1080,11 +1076,8 @@ xfs_find_get_desired_pgoff(
>  		 * At least we found one page. If the current offset is smaller
>  		 * than the first page offset, a hole was found.
>  		 */
> -		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0])) {
> -			found = true;
> -			*offset = lastoff;
> +		if (type == HOLE_OFF && lastoff < page_offset(pvec.pages[0]))
>  			break;
> -		}
>  
>  		for (i = 0; i < nr_pages; i++) {
>  			struct page	*page = pvec.pages[i];
> @@ -1150,21 +1143,20 @@ xfs_find_get_desired_pgoff(
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
