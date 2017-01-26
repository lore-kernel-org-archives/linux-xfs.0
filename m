Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46478 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752682AbdAZDjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 22:39:17 -0500
Subject: Re: [PATCH] xfs: clear _XBF_PAGES from buffers when readahead page
 allocation fails
References: <20170126030854.GC2584@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e5a631e1-891d-aa8e-7a09-ca693d98bbf1@sandeen.net>
Date: Wed, 25 Jan 2017 21:39:15 -0600
MIME-Version: 1.0
In-Reply-To: <20170126030854.GC2584@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 1/25/17 9:08 PM, Darrick J. Wong wrote:
> If we try to allocate memory pages to back an xfs_buf that we're trying
> to read, it's possible that we'll be so short on memory that the page
> allocation fails.  For a blocking read we'll just wait, but for
> readahead we simply dump all the pages we've collected so far.
> 
> Unfortunately, after dumping the pages we neglect to clear the
> _XBF_PAGES state, which means that other code might think that b_pages
> still points to pages we own.  If that other code is the buffer shrinker
> and nobody else has grabbed the buffer, _buftarg_wait_rele will release
> the buffer, which will see _XBF_PAGES and double-free the b_pages pages.
> 
> This results in screaming about negative page refcounts from the memory
> manager, which xfs oughtn't be triggering.  To reproduce this case,
> mount a filesystem where the size of the inodes far outweighs the
> availalble memory (a ~500M inode filesystem on a VM with 300MB memory
> did the trick here) and run bulkstat in parallel with other memory
> eating processes to put a huge load on the system.  The "check summary"
> phase of xfs_scrub also works for this purpose.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_buf.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7f0a01f..ac3b4db 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -422,6 +422,7 @@ xfs_buf_allocate_memory(
>  out_free_pages:
>  	for (i = 0; i < bp->b_page_count; i++)
>  		__free_page(bp->b_pages[i]);
> +	bp->b_flags &= ~_XBF_PAGES;
>  	return error;
>  }

If xfs_buf_allocate_memory() fails, its one caller immediately
frees the bp.  xfs_buf_free then looks at _XBF_PAGES, and
if set will call __free_page on each page.

I think that's where the double free is coming from, right?

-Eric
