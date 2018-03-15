Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932686AbeCOPxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Mar 2018 11:53:20 -0400
Date: Thu, 15 Mar 2018 08:53:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180315155316.GY4865@magnolia>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Thu, Mar 15, 2018 at 06:01:34PM +0300, Kirill Tkhai wrote:
> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
> So, it's called for memcg reclaim too, e.g. this list is shrinked
> disproportionality to another lists.
> 
> This looks confusing, so I'm reporting about this.
> Consider this patch as RFC.

So... I think the reasoning here is that xfs doesn't allocate inodes on
behalf of any particular memcg (or put another way the cost of the
inodes is shared by everything in the system) so if the shrinkers get
called because a particular memcg is bumping up against its limits it
makes no sense to try to purge xfs inodes?

Followup questions: does the same reasoning apply to the xfs buffer and
quota shrinkers?  Do any filesystems associate their metadata memory
allocations with a specific memcg?  If not, why not put this in
super_cache_{scan,count}?

--D

> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> ---
>  fs/xfs/xfs_super.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 951271f57d00..124568aefa94 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1788,6 +1788,8 @@ xfs_fs_nr_cached_objects(
>  	struct super_block	*sb,
>  	struct shrink_control	*sc)
>  {
> +	if (sc->memcg)
> +		return 0;
>  	return xfs_reclaim_inodes_count(XFS_M(sb));
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
