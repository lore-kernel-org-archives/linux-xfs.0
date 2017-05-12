Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53800 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756978AbdELIyB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 04:54:01 -0400
Date: Fri, 12 May 2017 10:53:57 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: only return detailed fsmap info if the caller has
 CAP_SYS_ADMIN
Message-ID: <20170512085357.wmq7xclw3zfrnswh@eorzea.usersys.redhat.com>
References: <20170511175511.GC4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511175511.GC4519@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Hi,

> There were a number of handwaving complaints that one could "possibly"
> use inode numbers and extent maps to fingerprint a filesystem hosting
> multiple containers and somehow use the information to guess at the
> contents of other containers and attack them.  Despite the total lack of
> any demonstration that this is actually possible, it's easier to
> restrict access now and broaden it later, so use the rmapbt fsmap
> backends only if the caller has CAP_SYS_ADMIN.  Unprivileged users will
> just have to make do with only getting the free space information.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_fsmap.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 3683819..814ed729 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -828,6 +828,7 @@ xfs_getfsmap(
>  	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
>  	struct xfs_getfsmap_dev		handlers[XFS_GETFSMAP_DEVS];
>  	struct xfs_getfsmap_info	info = { NULL };
> +	bool				use_rmap;
>  	int				i;
>  	int				error = 0;
>  
> @@ -837,12 +838,14 @@ xfs_getfsmap(
>  	    !xfs_getfsmap_is_valid_device(mp, &head->fmh_keys[1]))
>  		return -EINVAL;
>  
> +	use_rmap = capable(CAP_SYS_ADMIN) &&
> +		   xfs_sb_version_hasrmapbt(&mp->m_sb);
>  	head->fmh_entries = 0;
>  
>  	/* Set up our device handlers. */
>  	memset(handlers, 0, sizeof(handlers));
>  	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +	if (use_rmap)
>  		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
>  	else
>  		handlers[0].fn = xfs_getfsmap_datadev_bnobt;
>

I've followed the discussion too, and alhtough it just look as a very remote
theoretical problem, restricting this is simple.

Overall this looks fine to me, but, I just wonder if somebody in the future will
complain to be getting freespace only, instead of the fsmap itself, without
actually getting a permission denied error, or something like that.

This is a minor concern from my side though, so, unless somebody agrees with my
point here, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers.

 --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
