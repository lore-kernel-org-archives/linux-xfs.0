Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbeLQRk0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 12:40:26 -0500
Date: Mon, 17 Dec 2018 09:40:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH v2 2/3] xfs: Fix bulkstat compat ioctls on x32
 userspace.
Message-ID: <20181217174018.GH24487@magnolia>
References: <20181215012259.28358-1-nbowler@draconx.ca>
 <20181215012259.28358-3-nbowler@draconx.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215012259.28358-3-nbowler@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>

On Fri, Dec 14, 2018 at 08:22:58PM -0500, Nick Bowler wrote:
> The bulkstat family of ioctls are problematic on x32, because there is
> a mixup of native 32-bit and 64-bit conventions.  The xfs_fsop_bulkreq
> struct contains pointers and 32-bit integers so that matches the native
> 32-bit layout, and that means the ioctl implementation goes into the
> regular compat path on x32.
> 
> However, the 'ubuffer' member of that struct in turn refers to either
> struct xfs_inogrp or xfs_bstat (or an array of these).  On x32, those
> structures match the native 64-bit layout.  The compat implementation
> writes out the 32-bit version of these structures.  This is not the
> expected format for x32 userspace, causing problems.
> 
> Fortunately the functions which actually output these xfs_inogrp and
> xfs_bstat structures have an easy way to select which output format
> is required, so we just need a little tweak to select the right format
> on x32.
> 
> Signed-off-by: Nick Bowler <nbowler@draconx.ca>
> ---
>  fs/xfs/xfs_ioctl32.c | 34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 4c34efcbf7e8..1cdc75dca779 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -241,6 +241,32 @@ xfs_compat_ioc_bulkstat(
>  	int			done;
>  	int			error;
>  
> +	/*
> +	 * Output structure handling functions.  Depending on the command,
> +	 * either the xfs_bstat and xfs_inogrp structures are written out
> +	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
> +	 * functions and structure size are the correct ones to use ...
> +	 */
> +	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
> +	bulkstat_one_pf	bs_one_func = xfs_bulkstat_one_compat;
> +	size_t bs_one_size = sizeof(compat_xfs_bstat_t);
> +
> +#ifdef CONFIG_X86_X32
> +	if (in_x32_syscall()) {
> +		/*
> +		 * ... but on x32 the input xfs_fsop_bulkreq has pointers
> +		 * which must be handled in the "compat" (32-bit) way, while
> +		 * the xfs_bstat and xfs_inogrp structures follow native 64-
> +		 * bit layout convention.  So adjust accordingly, otherwise
> +		 * the data written out in compat layout will not match what
> +		 * x32 userspace expects.
> +		 */
> +		inumbers_func = xfs_inumbers_fmt;
> +		bs_one_func = xfs_bulkstat_one;
> +		bs_one_size = sizeof(xfs_bstat_t);

struct xfs_bstat, not xfs_bstat_t, because we're gradually getting rid
of the structure typedefs.  If I don't hear any other objections in the
next day or so I'll fix this when I pull in this patch.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	}
> +#endif
> +
>  	/* done = 1 if there are more stats to get and if bulkstat */
>  	/* should be called again (unused here, but used in dmapi) */
>  
> @@ -272,15 +298,15 @@ xfs_compat_ioc_bulkstat(
>  
>  	if (cmd == XFS_IOC_FSINUMBERS_32) {
>  		error = xfs_inumbers(mp, &inlast, &count,
> -				bulkreq.ubuffer, xfs_inumbers_fmt_compat);
> +				bulkreq.ubuffer, inumbers_func);
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
>  		int res;
>  
> -		error = xfs_bulkstat_one_compat(mp, inlast, bulkreq.ubuffer,
> -				sizeof(compat_xfs_bstat_t), NULL, &res);
> +		error = bs_one_func(mp, inlast, bulkreq.ubuffer,
> +				bs_one_size, NULL, &res);
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_32) {
>  		error = xfs_bulkstat(mp, &inlast, &count,
> -			xfs_bulkstat_one_compat, sizeof(compat_xfs_bstat_t),
> +			bs_one_func, bs_one_size,
>  			bulkreq.ubuffer, &done);
>  	} else
>  		error = -EINVAL;
> -- 
> 2.16.1
> 
