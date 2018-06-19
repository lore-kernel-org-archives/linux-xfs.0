Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57280 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753136AbeFSEyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 00:54:10 -0400
Date: Mon, 18 Jun 2018 21:54:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: transactionless xfs_bunmapi shouldn't do format
 conversion
Message-ID: <20180619045405.GI8128@magnolia>
References: <20180619024128.22669-1-david@fromorbit.com>
 <20180619024128.22669-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619024128.22669-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 12:41:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are punching out a delalloc extent, xfs_bunmapi() does not
> have a transaction context and should not ever need to convert the
> on-disk extent format. If such a thing is attempted (e.g. via a
> corrupt inode extent count in extent format) then we should abort
> with an EFSCORRUPTED error. Unfortunately, we don't do that and
> crash instead:
> 
>  XFS (loop0): page discard on page 0000000005fd24f3, inode 0x75e5, offset 0.
>  ==================================================================
>  BUG: KASAN: null-ptr-deref in xfs_alloc_get_freelist+0x115/0x350
>  Read of size 8 at addr 0000000000000028 by task a.out/1406
>  CPU: 0 PID: 1406 Comm: a.out Not tainted 4.17.0-rc4-kasan #2
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>  Call Trace:
>   dump_stack+0x7b/0xb5
>   kasan_report+0x10c/0x390
>   __asan_load8+0x54/0x90
>   xfs_alloc_get_freelist+0x115/0x350
>   xfs_alloc_fix_freelist+0x35b/0x830
>   xfs_alloc_vextent+0x215/0x990
>   xfs_bmap_extents_to_btree+0x30d/0x940
> .....
> 
> By returning an error here, we avoid such crashes when punching out
> a delalloc page because we don't try to fix up an AG freelist
> without a transaction. Hence we get an error like so:

Um, isn't erroring out here leaving a dirty bomb in the in-core metadata?
Like you say:

> XFS (loop0): page discard on page ffffea00040ae640, inode 0x75e5, offset 0.
> XFS (loop0): page discard unable to remove delalloc mapping.

We know the fs is corrupt, we might as well shut down now rather than
let this burp out later.

I get that people don't want to touch well seasoned code, but
xfs_bunmapi is this big unwieldly function that's crying out for a
refactor.  It's 330 lines long and can be called from various contexts
(data/attr fork, punch delalloc, etc.)...

...it's also weird that xfs_bmap_punch_delalloc_range calls xfs_bunmapi
with no transaction and a xfs_defer that we dump on the ground.

So yes, I think the patch does fix the crash, but it's kinda gross.

Thoughts?

--D

> And the filesystem continues to operate and the stale mapping is
> cleaned up when the inode is reclaimed.
> 
> Reported-by: Wen Xu <wen.xu@gatech.edu>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 01628f0c9a0c..6967ce8088d2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5458,10 +5458,18 @@ __xfs_bunmapi(
>  		*rlen = end - start + 1;
>  
>  	/*
> -	 * Convert to a btree if necessary.
> +	 * Convert the BMBT root format if necessary. This should only occur in
> +	 * transaction contexts and not when removing delalloc extents from
> +	 * the in-core extent tree. If we don't have a transaction, then we've
> +	 * got some form of corruption somewhere, so return an error
> +	 * immediately.
>  	 */
>  	if (xfs_bmap_needs_btree(ip, whichfork)) {
>  		ASSERT(cur == NULL);
> +		if (!tp) {
> +			error = -EFSCORRUPTED;
> +			goto error0;
> +		}
>  		error = xfs_bmap_extents_to_btree(tp, ip, firstblock, dfops,
>  			&cur, 0, &tmp_logflags, whichfork);
>  		logflags |= tmp_logflags;
> @@ -5473,6 +5481,10 @@ __xfs_bunmapi(
>  	 */
>  	else if (xfs_bmap_wants_extents(ip, whichfork)) {
>  		ASSERT(cur != NULL);
> +		if (!tp) {
> +			error = -EFSCORRUPTED;
> +			goto error0;
> +		}
>  		error = xfs_bmap_btree_to_extents(tp, ip, cur, &tmp_logflags,
>  			whichfork);
>  		logflags |= tmp_logflags;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
