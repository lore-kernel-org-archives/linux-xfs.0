Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35852 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752037AbeEKC2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 22:28:43 -0400
Date: Fri, 11 May 2018 03:28:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v4] fs: don't scan the inode cache before SB_BORN is set
Message-ID: <20180511022841.GZ30522@ZenIV.linux.org.uk>
References: <20180510042132.GS23861@dastard>
 <20180511012057.GV10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511012057.GV10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, May 11, 2018 at 11:20:57AM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> We recently had an oops reported on a 4.14 kernel in
> xfs_reclaim_inodes_count() where sb->s_fs_info pointed to garbage
> and so the m_perag_tree lookup walked into lala land.  It produces
> an oops down this path during the failed mount:
> 
>   radix_tree_gang_lookup_tag+0xc4/0x130
>   xfs_perag_get_tag+0x37/0xf0
>   xfs_reclaim_inodes_count+0x32/0x40
>   xfs_fs_nr_cached_objects+0x11/0x20
>   super_cache_count+0x35/0xc0
>   shrink_slab.part.66+0xb1/0x370
>   shrink_node+0x7e/0x1a0
>   try_to_free_pages+0x199/0x470
>   __alloc_pages_slowpath+0x3a1/0xd20
>   __alloc_pages_nodemask+0x1c3/0x200
>   cache_grow_begin+0x20b/0x2e0
>   fallback_alloc+0x160/0x200
>   kmem_cache_alloc+0x111/0x4e0
> 
> The problem is that the superblock shrinker is running before the
> filesystem structures it depends on have been fully set up. i.e.
> the shrinker is registered in sget(), before ->fill_super() has been
> called, and the shrinker can call into the filesystem before
> fill_super() does it's setup work. Essentially we are exposed to
> both use-after-free and use-before-initialisation bugs here.
> 
> To fix this, add a check for the SB_BORN flag in super_cache_count.
> In general, this flag is not set until ->fs_mount() completes
> successfully, so we know that it is set after the filesystem
> setup has completed. This matches the trylock_super() behaviour
> which will not let super_cache_scan() run if SB_BORN is not set, and
> hence will not allow the superblock shrinker from entering the
> filesystem while it is being set up or after it has failed setup
> and is being torn down.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Umm...  Shouldn't that be Cc: stable, or is there something subtle I'm
missing here?
