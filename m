Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23204 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752112AbcLLWOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 17:14:46 -0500
Date: Tue, 13 Dec 2016 09:14:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: handle error if xfs_btree_get_bufs fails
Message-ID: <20161212221442.GY4326@dastard>
References: <4348f961-deda-8733-1cd7-dd7ca646bb6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4348f961-deda-8733-1cd7-dd7ca646bb6b@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jason L Tibbitts III <tibbs@math.uh.edu>

On Mon, Dec 12, 2016 at 04:00:26PM -0600, Eric Sandeen wrote:
> Jason reported that a corrupted filesystem failed to replay
> the log with a metadata block out of bounds warning:
> 
> XFS (dm-2): _xfs_buf_find: Block out of range: block 0x80270fff8, EOFS 0x9c40000 
> 
> _xfs_buf_find() and xfs_btree_get_bufs() return NULL if
> that happens, and then when xfs_alloc_fix_freelist() calls
> xfs_trans_binval() on that NULL bp, we oops with:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000f8
> 
> We don't handle _xfs_buf_find errors very well, every
> caller higher up the stack gets to guess at why it failed.
> But we should at least handle it somehow.  I chose EIO here
> for lack of a better idea.  :)
> 
> Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index effb64c..d125135 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1640,6 +1640,10 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>  
>  				bp = xfs_btree_get_bufs(args->mp, args->tp,
>  					args->agno, fbno, 0);
> +				if (!bp) {
> +					error = -EIO;
> +					goto error0;
> +				}

If this happens, it's because the filesystem is corrupted, not
because we had an IO error. -EFSCORRUPTED is more appropriate here,
as the comment in _xfs_buf_find() says...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
