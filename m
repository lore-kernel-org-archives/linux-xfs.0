Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57085 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758176AbdAJLKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 06:10:03 -0500
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
References: <20170110101745.4841-1-jack@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <abd80b67-7cb8-5767-7c9c-2df19d29d7d0@suse.cz>
Date: Tue, 10 Jan 2017 12:09:59 +0100
MIME-Version: 1.0
In-Reply-To: <20170110101745.4841-1-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>, "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Brian Foster <bfoster@redhat.com>, stable <stable@vger.kernel.org>

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
> 
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

Thanks,

I think it's worth for stable inclusion? (4.8+)

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

