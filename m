Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28841 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751508AbdC0RW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 13:22:26 -0400
Date: Mon, 27 Mar 2017 10:22:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Request 2aa6ba7b5ad3 ("clear _XBF_PAGES from buffers when
 readahead page") for 4.4 stable inclusion
Message-ID: <20170327172210.GJ5722@birch.djwong.org>
References: <20170325074856.GA20773@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170325074856.GA20773@localhost>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ivan Kozik <ivan@ludios.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com

On Sat, Mar 25, 2017 at 07:49:00AM +0000, Ivan Kozik wrote:
> Hi,
> 
> I would like to request that this patch be included in the 4.4 stable tree.  It 
> fixes the Bad page state issue discovered at 
> http://oss.sgi.com/archives/xfs/2016-08/msg00617.html ('"Bad page state" errors 
> when calling BULKSTAT under memory pressure?')
> 
> I tested the patch (no changes needed) by applying it to 4.4.52, running a 
> program to use almost all of my free memory, then running xfs_fsr on a 
> filesystem with > 1.5M files.  Before patch: kernel screams with Bad page state 
> / "count:-1" within a minute.  After patch: no complaints from the kernel. 
> I repeated the test several times and on another machine that was affected. 
> I have not seen any problems five days later.

FWIW this looks fine for 4.4, so
Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

(It's probably ok for all the stable kernels too, but I haven't tested
any of them so I won't make such a claim at this time.)

--D

> 
> Thanks,
> 
> Ivan
> 
> >From 2aa6ba7b5ad3189cc27f14540aa2f57f0ed8df4b Mon Sep 17 00:00:00 2001
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> Date: Wed, 25 Jan 2017 20:24:57 -0800
> Subject: [PATCH] xfs: clear _XBF_PAGES from buffers when readahead page
> 
> If we try to allocate memory pages to back an xfs_buf that we're trying
> to read, it's possible that we'll be so short on memory that the page
> allocation fails.  For a blocking read we'll just wait, but for
> readahead we simply dump all the pages we've collected so far.
> 
> Unfortunately, after dumping the pages we neglect to clear the
> _XBF_PAGES state, which means that the subsequent call to xfs_buf_free
> thinks that b_pages still points to pages we own.  It then double-frees
> the b_pages pages.
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
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7f0a01f7b592..ac3b4db519df 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -422,6 +422,7 @@ retry:
>  out_free_pages:
>  	for (i = 0; i < bp->b_page_count; i++)
>  		__free_page(bp->b_pages[i]);
> +	bp->b_flags &= ~_XBF_PAGES;
>  	return error;
>  }
>  
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
