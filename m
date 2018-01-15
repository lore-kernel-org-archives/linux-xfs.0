Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932393AbeAOOlV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 09:41:21 -0500
Date: Mon, 15 Jan 2018 09:41:15 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/5] xfs: don't iunlock unlocked inodes
Message-ID: <20180115144114.GB47688@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579465207.8694.2459805113822761321.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579465207.8694.2459805113822761321.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 12, 2018 at 02:04:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't iunlock an unlocked inode, which can happen if the parent pointer
> scrubber bails out with sc->ip unlocked while trying to grab the parent
> directory inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/scrub.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 9c177ea..89178b9 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -193,7 +193,8 @@ xfs_scrub_teardown(
>  		sc->fs_frozen = false;
>  	}
>  	if (sc->ip) {
> -		xfs_iunlock(sc->ip, sc->ilock_flags);
> +		if (sc->ilock_flags)
> +			xfs_iunlock(sc->ip, sc->ilock_flags);
>  		if (sc->ip != ip_in &&
>  		    !xfs_internal_inum(sc->mp, sc->ip->i_ino))
>  			iput(VFS_I(sc->ip));
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
