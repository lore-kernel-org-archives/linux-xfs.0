Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38423 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965285AbdAKIHz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:07:55 -0500
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
References: <20170110101745.4841-1-jack@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <7ecf901b-ecbd-3914-25c3-1f6f6faf3264@suse.cz>
Date: Wed, 11 Jan 2017 09:07:51 +0100
MIME-Version: 1.0
In-Reply-To: <20170110101745.4841-1-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Brian Foster <bfoster@redhat.com>

On 01/10/2017 11:17 AM, Jan Kara wrote:
> Commit 99579ccec4e2 "xfs: skip dirty pages in ->releasepage()" started
> to skip dirty pages in xfs_vm_releasepage() which also has the effect
> that if a dirty page is truncated, it does not get freed by
> block_invalidatepage() and is lingering in LRU list waiting for reclaim.
> So a simple loop like:
> 
> while true; do
> 	dd if=/dev/zero of=file bs=1M count=100
> 	rm file
> done
> 
> will keep using more and more memory until we hit low watermarks and
> start pagecache reclaim which will eventually reclaim also the truncate
> pages. Keeping these truncated (and thus never usable) pages in memory
> is just a waste of memory, is unnecessarily stressing page cache
> reclaim, and is also confusing users thinking they are running out of
> memory.

Hi,

So the impact is even worse than that, as it's the kernel that is
actually confused, while the user still gets the impression of memory
being available.
According to the reporter, this bug has manifested as anonymous mmap()
returning with ENOMEM in their workload (some benchmark), which does not
happen anymore after switching from xfs to ext4.

Here are the relevant /proc/meminfo counters from a system that is
experiencing the bug (but hasn't exhausted all memory and hit ENOMEM yet):


MemTotal:       65862388 kB
MemFree:         6882888 kB
MemAvailable:   54829584 kB
Buffers:            2248 kB
Cached:          1937376 kB
SwapCached:            0 kB
Active:         14969280 kB
Inactive:       42491396 kB
Active(anon):   10034824 kB
Inactive(anon):     1420 kB
Active(file):    4934456 kB
Inactive(file): 42489976 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        511996 kB
SwapFree:         511996 kB
Dirty:              1452 kB
Writeback:             0 kB
AnonPages:      10034556 kB
Mapped:           143956 kB
Shmem:              1836 kB
...

MemAvailable suggests that most of memory (except anonymous mmaps) is
still available, i.e. free or reclaimable. But there's a large
discrepancy between "Cached", which is based on the NR_FILE_PAGES
counter, and [In]Active(file), which reflects NR_[IN]ACTIVE_FILE
counters. So the truncated pages are not counted towards page cache
anymore, but are still accounted as LRU pages, as they are placed on the
LRU lists waiting for reclaim.

Now MemAvailable is based on NR_FREE_PAGES and NR_[IN]ACTIVE_FILE (I
actually wonder why the value is so high here, it should consider only
half of the file LRU's as available, according to the comment there...
oh, I see, there's a math error there, I'll report that separately...).

And AFAICS, the ENOMEM results of mmap() comes from
__vm_enough_memory(), which in OVERCOMMIT_GUESS mode considers as
available memory (called 'free' there) the sum of NR_FREE_PAGES, and
NR_FILE_PAGES.

So this would explain the ENOMEM, and how this bug is a problem for
workloads that truncate/remove files on xfs, and at the same time rely
on anonymous mmap(). In that case, these mmaps can apparently start
failing if there's no other source of sufficient memory pressure to let
reclaim get rid of the truncated pages on LRU. This should be serious
enough for a stable backport IMHO.

Thanks,
Vlastimil

> So instead of just skipping dirty pages in xfs_vm_releasepage(), return
> to old behavior of skipping them only if they have delalloc or unwritten
> buffers and fix the spurious warnings by warning only if the page is
> clean.
> 
> CC: Brian Foster <bfoster@redhat.com>
> CC: Vlastimil Babka <vbabka@suse.cz>
> Reported-by: Petr Tůma <petr.tuma@d3s.mff.cuni.cz>
> Fixes: 99579ccec4e271c3d4d4e7c946058766812afdab
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_aops.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 0f56fcd3a5d5..670d38ff7dc7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1150,21 +1150,20 @@ xfs_vm_releasepage(
>  	 * the dirty bit cleared. Thus, it can send actual dirty pages to
>  	 * ->releasepage() via shrink_active_list(). Conversely,
>  	 * block_invalidatepage() can send pages that are still marked dirty
> -	 * but otherwise have invalidated buffers.
> -	 *
> -	 * We've historically freed buffers on the latter. Instead, quietly
> -	 * filter out all dirty pages to avoid spurious buffer state warnings.
> -	 * This can likely be removed once shrink_active_list() is fixed.
> +	 * but otherwise have invalidated buffers. So we warn only if the page
> +	 * is clean to avoid spurious warnings when called from
> +	 * shrink_active_list() for a dirty page.
>  	 */
> -	if (PageDirty(page))
> -		return 0;
> -
>  	xfs_count_page_state(page, &delalloc, &unwritten);
>  
> -	if (WARN_ON_ONCE(delalloc))
> +	if (delalloc) {
> +		WARN_ON_ONCE(!PageDirty(page));
>  		return 0;
> -	if (WARN_ON_ONCE(unwritten))
> +	}
> +	if (unwritten) {
> +		WARN_ON_ONCE(!PageDirty(page));
>  		return 0;
> +	}
>  
>  	return try_to_free_buffers(page);
>  }
> 

