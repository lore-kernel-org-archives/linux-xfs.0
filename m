Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751075AbdAJMnV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Jan 2017 07:43:21 -0500
Date: Tue, 10 Jan 2017 07:43:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Timely free truncated dirty pages
Message-ID: <20170110124320.GA3321@bfoster.bfoster>
References: <20170110101745.4841-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170110101745.4841-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Petr Tuma <petr.tuma@d3s.mff.cuni.cz>, Vlastimil Babka <vbabka@suse.cz>

On Tue, Jan 10, 2017 at 11:17:45AM +0100, Jan Kara wrote:
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
> ---

Ugh, so this is closer to the alternative I was considering at the time
this was posted. Thanks for the fix. The code looks fine, I'd just like
to update the comment...

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

Could you fold in something like the following?

-	 * but otherwise have invalidated buffers. So we warn only if the page
-	 * is clean to avoid spurious warnings when called from
-	 * shrink_active_list() for a dirty page.
+	 * but otherwise have invalidated buffers.
+	 *
+	 * We want to release the latter to avoid unnecessary buildup of the
+	 * LRU, skip the former and warn if we've left any lingering
+	 * delalloc/unwritten buffers on clean pages. Skip pages with delalloc
+	 * or unwritten buffers and warn if the page is not dirty. Otherwise
+	 * try to release the buffers.

Brian

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
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
