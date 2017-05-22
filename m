Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758295AbdEVRut (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 13:50:49 -0400
Date: Mon, 22 May 2017 13:50:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: Fix off-by-in in loop termination in
 xfs_find_get_desired_pgoff()
Message-ID: <20170522175045.GB1473@bfoster.bfoster>
References: <20170518104850.14508-1-jack@suse.cz>
 <20170518104850.14508-3-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170518104850.14508-3-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Thu, May 18, 2017 at 12:48:49PM +0200, Jan Kara wrote:
> There is an off-by-one error in loop termination conditions in
> xfs_find_get_desired_pgoff() since 'end' may index a page beyond end of
> desired range if 'endoff' is page aligned. It doesn't have any visible
> effects but still it is good to fix it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f371812e20c6..3714b5736fd3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1043,7 +1043,7 @@ xfs_find_get_desired_pgoff(
>  
>  	index = startoff >> PAGE_SHIFT;
>  	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
> -	end = endoff >> PAGE_SHIFT;
> +	end = (endoff - 1) >> PAGE_SHIFT;

Hmm.. I think this messes with the want count for the pagevec_lookup().
E.g.:

# xfs_io -fc "truncate 0" -c "falloc 0 16k" -c "pwrite 0 16k" -c "seek -h 0" /mnt/file 
wrote 16384/16384 bytes at offset 0
16 KiB, 4 ops; 0.0000 sec (200.321 MiB/sec and 51282.0513 ops/sec)
Whence  Result
HOLE    12288

Brian

>  	do {
>  		int		want;
>  		unsigned	nr_pages;
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
