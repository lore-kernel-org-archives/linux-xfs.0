Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbdCOPA5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 11:00:57 -0400
Date: Wed, 15 Mar 2017 11:00:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs: pass total block res. as total xfs_bmapi_write() parameter
Message-ID: <20170315150055.GB24729@bfoster.bfoster>
References: <153397e1-ba41-20b3-455e-d622c234bc3a@gmail.com>
 <1489580654-29669-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489580654-29669-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: stable@vger.kernel.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, david@fromorbit.com

On Wed, Mar 15, 2017 at 02:24:14PM +0200, Nikolay Borisov wrote:
> From: Brian Foster <bfoster@redhat.com>
> 
> The total field from struct xfs_alloc_arg is a bit of an unknown
> commodity. It is documented as the total block requirement for the
> transaction and is used in this manner from most call sites by virtue of
> passing the total block reservation of the transaction associated with
> an allocation. Several xfs_bmapi_write() callers pass hardcoded values
> of 0 or 1 for the total block requirement, which is a historical oddity
> without any clear reasoning.
> 
> The xfs_iomap_write_direct() caller, for example, passes 0 for the total
> block requirement. This has been determined to cause problems in the
> form of ABBA deadlocks of AGF buffers due to incorrect AG selection in
> the block allocator. Specifically, the xfs_alloc_space_available()
> function incorrectly selects an AG that doesn't actually have sufficient
> space for the allocation. This occurs because the args.total field is 0
> and thus the remaining free space check on the AG doesn't actually
> consider the size of the allocation request. This locks the AGF buffer,
> the allocation attempt proceeds and ultimately fails (in
> xfs_alloc_fix_minleft()), and xfs_alloc_vexent() moves on to the next
> AG. In turn, this can lead to incorrect AG locking order (if the
> allocator wraps around, attempting to lock AG 0 after acquiring AG N)
> and thus deadlock if racing with another operation. This problem has
> been reproduced via generic/299 on smallish (1GB) ramdisk test devices.
> 
> To avoid this problem, replace the undocumented hardcoded total
> parameters from the iomap and utility callers to pass the block
> reservation used for the associated transaction. This is consistent with
> other xfs_bmapi_write() callers throughout XFS. The assumption is that
> the total field allows the selection of an AG that can handle the entire
> operation rather than simply the allocation/range being requested (e.g.,
> resulting btree splits, etc.). This addresses the aforementioned
> generic/299 hang by ensuring AG selection only occurs when the
> allocation can be satisfied by the AG.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Here is the backport for 3.12 
> 

Seems fine to me, thanks. FWIW:

Acked-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 2 +-
>  fs/xfs/xfs_iomap.c     | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2843a0426bca..66172581dacb 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1146,7 +1146,7 @@ retry:
>  		xfs_bmap_init(&free_list, &firstfsb);
>  		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
>  					allocatesize_fsb, alloc_type, &firstfsb,
> -					0, imapp, &nimaps, &free_list);
> +					resblks, imapp, &nimaps, &free_list);
>  		if (error) {
>  			goto error0;
>  		}
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 43e31b0b288b..da87415ac561 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -217,7 +217,7 @@ xfs_iomap_write_direct(
>  	xfs_bmap_init(&free_list, &firstfsb);
>  	nimaps = 1;
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flag,
> -				&firstfsb, 0, imap, &nimaps, &free_list);
> +				&firstfsb, resblks, imap, &nimaps, &free_list);
>  	if (error)
>  		goto out_bmap_cancel;
>  
> @@ -762,7 +762,7 @@ xfs_iomap_write_allocate(
>  			error = xfs_bmapi_write(tp, ip, map_start_fsb,
>  						count_fsb,
>  						XFS_BMAPI_STACK_SWITCH,
> -						&first_block, 1,
> +						&first_block, nres,
>  						imap, &nimaps, &free_list);
>  			if (error)
>  				goto trans_cancel;
> @@ -877,8 +877,8 @@ xfs_iomap_write_unwritten(
>  		xfs_bmap_init(&free_list, &firstfsb);
>  		nimaps = 1;
>  		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -				  XFS_BMAPI_CONVERT, &firstfsb,
> -				  1, &imap, &nimaps, &free_list);
> +					XFS_BMAPI_CONVERT, &firstfsb, resblks,
> +					&imap, &nimaps, &free_list);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
