Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53158 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbfD1Wlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Apr 2019 18:41:49 -0400
Date: Mon, 29 Apr 2019 08:41:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add missing error check in xfs_prepare_shift()
Message-ID: <20190428224145.GG29573@dread.disaster.area>
References: <20190426120633.36420-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426120633.36420-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 26, 2019 at 08:06:33AM -0400, Brian Foster wrote:
> xfs_prepare_shift() fails to check the error return from
> xfs_flush_unmap_range(). If the latter fails, that could lead to an
> insert/collapse range operation over a delalloc range, which is not
> supported.
> 
> Add an error check and return appropriately. This is reproduced
> rarely by generic/475.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_bmap_util.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2db43ff4f8b5..06d07f1e310b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1193,6 +1193,8 @@ xfs_prepare_shift(
>  	 * about to shift down every extent from offset to EOF.
>  	 */
>  	error = xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip));
> +	if (error)
> +		return error;

Urk. My fault.

Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page cache")

Not sure how I screwed up that simple change so obviously and didn't
notice it.

Fix for the fix looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
