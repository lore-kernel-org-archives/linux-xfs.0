Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50266 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeFEEIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 00:08:21 -0400
Date: Mon, 4 Jun 2018 21:08:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: verify extent size hint is valid in inode
 verifier
Message-ID: <20180605040817.GE9437@magnolia>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605024313.18737-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605024313.18737-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 12:43:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are rules for vald extent size hints. We enforce them when
> applications set them, but fuzzers violate those rules and that
> screws us over.
> 
> This results in alignment assertion failures when setting up
> allocations such as this in direct IO:
> 
> XFS: Assertion failed: ap->length, file: fs/xfs/libxfs/xfs_bmap.c, line: 3432
> ....
> Call Trace:
>  xfs_bmap_btalloc+0x415/0x910
>  xfs_bmapi_write+0x71c/0x12e0
>  xfs_iomap_write_direct+0x2a9/0x420
>  xfs_file_iomap_begin+0x4dc/0xa70
>  iomap_apply+0x43/0x100
>  iomap_file_buffered_write+0x62/0x90
>  xfs_file_buffered_aio_write+0xba/0x300
>  __vfs_write+0xd5/0x150
>  vfs_write+0xb6/0x180
>  ksys_write+0x45/0xa0
>  do_syscall_64+0x5a/0x180
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> And from xfs_db:
> 
> core.extsize = 10380288
> 
> Which is not an integer multiple of the block size, and so violates
> Rule #7 for setting extent size hints. Validate extent size hint
> rules in the inode verifier to catch this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index f5fff1ccb61d..be197c91307b 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -385,6 +385,7 @@ xfs_dinode_verify(
>  	xfs_ino_t		ino,
>  	struct xfs_dinode	*dip)
>  {
> +	xfs_failaddr_t		fa;
>  	uint16_t		mode;
>  	uint16_t		flags;
>  	uint64_t		flags2;
> @@ -501,6 +502,12 @@ xfs_dinode_verify(
>  			return __this_address;
>  	}
>  
> +	/* extent size hint validation */
> +	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
> +					mode, be32_to_cpu(dip->di_flags));

What if the cowextsize is garbage?  Do we handle that better, or do we
blow up there too?

--D

> +	if (fa)
> +		return fa;
> +
>  	/* only version 3 or greater inodes are extensively verified here */
>  	if (dip->di_version < 3)
>  		return NULL;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
