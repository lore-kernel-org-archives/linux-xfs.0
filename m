Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38177 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752079AbeCORtG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 13:49:06 -0400
Date: Thu, 15 Mar 2018 18:49:03 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180315174903.GM23100@dhcp22.suse.cz>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
> So, it's called for memcg reclaim too, e.g. this list is shrinked
> disproportionality to another lists.
> 
> This looks confusing, so I'm reporting about this.
> Consider this patch as RFC.

Could you be more specific about the problem you are trying to solve?
Because we do skip shrinkers which are not memcg aware by
shrink_slab:
		/*
		 * If kernel memory accounting is disabled, we ignore
		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
		 * passing NULL for memcg.
		 */
		if (memcg_kmem_enabled() &&
		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
			continue;

Or am I missing something?
 
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

-- 
Michal Hocko
SUSE Labs
