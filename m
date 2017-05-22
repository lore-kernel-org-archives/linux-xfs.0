Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758295AbdEVRug (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 13:50:36 -0400
Date: Mon, 22 May 2017 13:50:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Fix missed holes in SEEK_HOLE implementation
Message-ID: <20170522175032.GA1473@bfoster.bfoster>
References: <20170518104850.14508-1-jack@suse.cz>
 <20170518104850.14508-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518104850.14508-2-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org

On Thu, May 18, 2017 at 12:48:48PM +0200, Jan Kara wrote:
> XFS SEEK_HOLE implementation could miss a hole in an unwritten extent as
> can be seen by the following command:
> 
> xfs_io -c "falloc 0 256k" -c "pwrite 0 56k" -c "pwrite 128k 8k"
>        -c "seek -h 0" file
> wrote 57344/57344 bytes at offset 0
> 56 KiB, 14 ops; 0.0000 sec (49.312 MiB/sec and 12623.9856 ops/sec)
> wrote 8192/8192 bytes at offset 131072
> 8 KiB, 2 ops; 0.0000 sec (70.383 MiB/sec and 18018.0180 ops/sec)
> Whence	Result
> HOLE	139264
> 
> Where we can see that hole at offset 56k was just ignored by SEEK_HOLE
> implementation. The bug is in xfs_find_get_desired_pgoff() which does
> not properly detect the case when pages are not contiguous.
> 
> Fix the problem by properly detecting when found page has larger offset
> than expected.
> 
> CC: stable@vger.kernel.org
> Fixes: d126d43f631f996daeee5006714fed914be32368
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 35703a801372..f371812e20c6 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1076,17 +1076,6 @@ xfs_find_get_desired_pgoff(
>  			break;
>  		}
>  
> -		/*
> -		 * At lease we found one page.  If this is the first time we
> -		 * step into the loop, and if the first page index offset is
> -		 * greater than the given search offset, a hole was found.
> -		 */
> -		if (type == HOLE_OFF && lastoff == startoff &&
> -		    lastoff < page_offset(pvec.pages[0])) {
> -			found = true;
> -			break;
> -		}
> -
>  		for (i = 0; i < nr_pages; i++) {
>  			struct page	*page = pvec.pages[i];
>  			loff_t		b_offset;
> @@ -1098,18 +1087,18 @@ xfs_find_get_desired_pgoff(
>  			 * file mapping. However, page->index will not change
>  			 * because we have a reference on the page.
>  			 *
> -			 * Searching done if the page index is out of range.
> -			 * If the current offset is not reaches the end of
> -			 * the specified search range, there should be a hole
> -			 * between them.
> +			 * If current page offset is beyond where we've ended,
> +			 * we've found a hole.
>  			 */
> -			if (page->index > end) {
> -				if (type == HOLE_OFF && lastoff < endoff) {
> -					*offset = lastoff;
> -					found = true;
> -				}
> +			if (type == HOLE_OFF && lastoff < endoff &&
> +			    lastoff < page_offset(pvec.pages[i])) {
> +				found = true;
> +				*offset = lastoff;
>  				goto out;
>  			}
> +			/* Searching done if the page index is out of range. */
> +			if (page->index > end)
> +				goto out;
>  
>  			lock_page(page);
>  			/*
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
