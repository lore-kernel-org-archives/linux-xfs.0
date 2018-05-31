Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37858 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbeEaXss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 19:48:48 -0400
Date: Thu, 31 May 2018 16:48:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix error handling in xfs_refcount_insert()
Message-ID: <20180531234843.GF7825@magnolia>
References: <20180531234625.31925-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531234625.31925-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 01, 2018 at 09:46:25AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/475 fired an assert failure just after the filesystem was
> shut down:
> 
> XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_refcount.c, line: 182
> .....
> Call Trace:
>  xfs_refcount_insert+0x151/0x190
>  xfs_refcount_adjust_extents.constprop.11+0x9c/0x470
>  xfs_refcount_adjust.constprop.10+0xb0/0x270
>  xfs_refcount_finish_one+0x25a/0x420
>  xfs_trans_log_finish_refcount_update+0x2a/0x40
>  xfs_refcount_update_finish_item+0x35/0xa0
>  xfs_defer_finish+0x15e/0x4d0
>  xfs_reflink_remap_extent+0x1bc/0x610
>  xfs_reflink_remap_blocks+0x6e/0x280
>  xfs_reflink_remap_range+0x311/0x530
>  vfs_clone_file_range+0x119/0x200
>  ....
> 
> If xfs_btree_insert() returns an error, the corruption check fires
> instead of passing the error back the caller. The corruption check
> should be after we've checked for an error, not before, thereby
> avoiding assert failures if the filesystem shuts down during a
> refcount btree record insert.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

HAAA I ARE DUMMM

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index ae07a85d9bd5..235a9cf7265f 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -165,7 +165,10 @@ xfs_refcount_insert(
>  	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
>  	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
>  	error = xfs_btree_insert(cur, i);
> +	if (error)
> +		goto out_error;
>  	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
> +
>  out_error:
>  	if (error)
>  		trace_xfs_refcount_insert_error(cur->bc_mp,
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
