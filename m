Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751314AbeCOTc2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 15:32:28 -0400
Date: Thu, 15 Mar 2018 20:32:24 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] xfs, memcg: Call xfs_fs_nr_cached_objects() only in
 case of global reclaim
Message-ID: <20180315193224.GV23100@dhcp22.suse.cz>
References: <152112607662.7371.16175767692798928059.stgit@localhost.localdomain>
 <20180315174903.GM23100@dhcp22.suse.cz>
 <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6a9bf24-50e6-8e60-94af-28e99c51f516@virtuozzo.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Thu 15-03-18 22:28:43, Kirill Tkhai wrote:
> On 15.03.2018 20:49, Michal Hocko wrote:
> > On Thu 15-03-18 18:01:34, Kirill Tkhai wrote:
> >> xfs_reclaim_inodes_count(XFS_M(sb)) does not care about memcg.
> >> So, it's called for memcg reclaim too, e.g. this list is shrinked
> >> disproportionality to another lists.
> >>
> >> This looks confusing, so I'm reporting about this.
> >> Consider this patch as RFC.
> > 
> > Could you be more specific about the problem you are trying to solve?
> > Because we do skip shrinkers which are not memcg aware by
> > shrink_slab:
> > 		/*
> > 		 * If kernel memory accounting is disabled, we ignore
> > 		 * SHRINKER_MEMCG_AWARE flag and call all shrinkers
> > 		 * passing NULL for memcg.
> > 		 */
> > 		if (memcg_kmem_enabled() &&
> > 		    !!memcg != !!(shrinker->flags & SHRINKER_MEMCG_AWARE))
> > 			continue;
> > 
> > Or am I missing something?
> 
> sb->s_op->nr_cached_objects is a sub-method of generic super_cache_count().
> super_cache_count() is owned and only called by superblock's shrinker,
> which does have SHRINKER_MEMCG_AWARE flag.

Ohh, I see. I thought it was a standard "top-level" shrinker.
-- 
Michal Hocko
SUSE Labs
