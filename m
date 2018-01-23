Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeAWMF6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jan 2018 07:05:58 -0500
Date: Tue, 23 Jan 2018 07:05:57 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: call xfs_qm_dqattach before performing reflink
 operations
Message-ID: <20180123120557.GC31825@bfoster.bfoster>
References: <151651282961.28390.17944517354130397779.stgit@magnolia>
 <151651284994.28390.7445163994259507169.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151651284994.28390.7445163994259507169.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Jan 20, 2018 at 09:34:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Ensure that we've attached all the necessary dquots before performing
> reflink operations so that quota accounting is accurate.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5d1ff5a..947d0637 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -54,6 +54,7 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_sb.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_qm.h"
>  
>  /*
>   * Copy on Write of Shared Blocks
> @@ -282,6 +283,10 @@ xfs_reflink_reserve_cow(
>  	 * tree.
>  	 */
>  
> +	error = xfs_qm_dqattach_locked(ip, 0);
> +	if (error)
> +		return error;
> +

The same call exists further down in the function. Was the intent to
move it? I suspect we don't need it twice, at least.

>  	if (!xfs_iext_lookup_extent(ip, ifp, imap->br_startoff, &icur, &got))
>  		eof = true;
>  	if (!eof && got.br_startoff <= imap->br_startoff) {
> @@ -396,6 +401,10 @@ xfs_reflink_allocate_cow(
>  	ASSERT(xfs_is_reflink_inode(ip));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
>  
> +	error = xfs_qm_dqattach_locked(ip, 0);
> +	if (error)
> +		return error;
> +

Similar pattern here, but for this one the assert above suggests we
could have the shared lock. xfs_qm_dqattach_locked() looks like it
expects the exclusive lock (and that's what it looks like the second
call deals with). Hm?

Brian

>  	/*
>  	 * Even if the extent is not shared we might have a preallocation for
>  	 * it in the COW fork.  If so use it.
> @@ -1356,6 +1365,14 @@ xfs_reflink_remap_range(
>  	if (IS_DAX(inode_in) || IS_DAX(inode_out))
>  		goto out_unlock;
>  
> +	/* Attach dquots to both inodes */
> +	ret = xfs_qm_dqattach(src, 0);
> +	if (ret)
> +		goto out_unlock;
> +	ret = xfs_qm_dqattach(dest, 0);
> +	if (ret)
> +		goto out_unlock;
> +
>  	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
>  			&len, is_dedupe);
>  	if (ret <= 0)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
