Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752063AbcJJMov (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Oct 2016 08:44:51 -0400
Date: Mon, 10 Oct 2016 08:44:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/7] xfs: clear reflink flag if setting realtime flag
Message-ID: <20161010124437.GA18495@bfoster.bfoster>
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147588168294.12127.1609759616316145097.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Fri, Oct 07, 2016 at 04:08:03PM -0700, Darrick J. Wong wrote:
> Since we can only turn on the rt flag if there are no data extents,
> we can safely turn off the reflink flag if the rt flag is being
> turned on.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8b9f31c5..598b97b 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1034,9 +1034,9 @@ xfs_ioctl_setattr_xflags(
>  			return -EINVAL;
>  	}
>  
> -	/* Don't allow us to set realtime mode for a reflinked file. */
> +	/* Clear reflink if we are actually able to set the rt flag. */
>  	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
> -		return -EINVAL;
> +		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>  
>  	/* Don't allow us to set DAX mode for a reflinked file for now. */
>  	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))

This seems fine to me, but don't we still have the original problem in
the code that shortly follows with regard to the DAX flag? In other
words, the fundamental issue was that we clear the reflink flag lazily
(which by itself is perfectly fine), but we have a few spots where we
trust that the inode absolutely has shared extents when the flag is set.

That also might be fine logic in certain contexts, but in these couple
cases we fail requested operations from the user (setting RT, DAX,
etc.). It's not a big deal in that I suppose one can always run an
unshare fallocate, but just could be confusing if somebody is aware of
the already unshared state of a file.

Could we invoke xfs_reflink_clear_inode_flag() somewhere earlier in this
path if the reflink flag is set and any of the conflicting flags have
been requested by the user?

Brian

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
