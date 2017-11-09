Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52619 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752753AbdKICBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 21:01:47 -0500
Date: Thu, 9 Nov 2017 13:01:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: always release btree buffers when refcountbt
 checks fail
Message-ID: <20171109020119.GJ4094@dastard>
References: <20171108002636.GD26910@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108002636.GD26910@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 07, 2017 at 04:26:36PM -0800, Darrick J. Wong wrote:
> During phase 4 of repair, we compare the refcount records we've computed
> against what's in the refcount btree.  If the btree is corrupt the
> libxfs refcount calls will fail, but on our way out of the function we
> don't make sure to clear all the btree cursor's buffer pointers.  This
> leads to a repair deadlock in xfs/372 when fuzzing ptrs[1] to -1U
> because we forgot to release a buffer.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/rmap.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 01d6f0f..d51590b 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1359,7 +1359,8 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
>  
>  err:
>  	if (bt_cur)
> -		libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
> +		libxfs_btree_del_cursor(bt_cur, error ? XFS_BTREE_ERROR :
> +							XFS_BTREE_NOERROR);

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
