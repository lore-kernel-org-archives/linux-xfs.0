Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 089197F98
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 15:21:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8A2E0AC008
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 13:21:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y2BQkqMPJfszKtbI for
	<xfs@oss.sgi.com>; Thu, 14 Mar 2013 13:21:13 -0700 (PDT)
Date: Thu, 14 Mar 2013 17:21:09 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Fix WARN_ON(delalloc) in xfs_vm_releasepage()
Message-ID: <20130314202108.GB32283@andromeda.usersys.redhat.com>
References: <1363267854-25602-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363267854-25602-1-git-send-email-jack@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Mar 14, 2013 at 02:30:54PM +0100, Jan Kara wrote:
> When a dirty page is truncated from a file but reclaim gets to it before
> truncate_inode_pages(), we hit WARN_ON(delalloc) in
> xfs_vm_releasepage(). This is because reclaim tries to write the page,
> xfs_vm_writepage() just bails out (leaving page clean) and thus reclaim
> thinks it can continue and calls xfs_vm_releasepage() on page with dirty
> buffers.
> 
> Fix the issue by redirtying the page in xfs_vm_writepage(). This makes
> reclaim stop reclaiming the page and also logically it keeps page in a
> more consistent state where page with dirty buffers has PageDirty set.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_aops.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5f707e5..3244c98 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -953,13 +953,13 @@ xfs_vm_writepage(
>  		unsigned offset_into_page = offset & (PAGE_CACHE_SIZE - 1);
>  
>  		/*
> -		 * Just skip the page if it is fully outside i_size, e.g. due
> -		 * to a truncate operation that is in progress.
> +		 * Skip the page if it is fully outside i_size, e.g. due to a
> +		 * truncate operation that is in progress. We must redirty the
> +		 * page so that reclaim stops reclaiming it. Otherwise
> +		 * xfs_vm_releasepage() is called on it and gets confused.
>  		 */
> -		if (page->index >= end_index + 1 || offset_into_page == 0) {
> -			unlock_page(page);
> -			return 0;
> -		}
> +		if (page->index >= end_index + 1 || offset_into_page == 0)
> +			goto redirty;
>  
>  		/*
>  		 * The page straddles i_size.  It must be zeroed out on each
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Looks Good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
