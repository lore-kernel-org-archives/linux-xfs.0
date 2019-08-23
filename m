Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82616C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 14:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590E222CEC
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 14:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388273AbfHWOHQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 10:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfHWOHQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 10:07:16 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F384B30833CB;
        Fri, 23 Aug 2019 14:07:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F32C6600F8;
        Fri, 23 Aug 2019 14:07:14 +0000 (UTC)
Date:   Fri, 23 Aug 2019 10:07:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix ABBA deadlock between AGI and AGF in rename()
Message-ID: <20190823140713.GA54025@bfoster>
References: <08753b9e-4da1-ca61-af12-0b4aad8ed516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08753b9e-4da1-ca61-af12-0b4aad8ed516@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 23 Aug 2019 14:07:16 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 12:56:53PM +0800, kaixuxia wrote:
> When performing rename operation with RENAME_WHITEOUT flag, we will
> hold AGF lock to allocate or free extents in manipulating the dirents
> firstly, and then doing the xfs_iunlink_remove() call last to hold
> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> 
> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI. Hence
> the ordering that is imposed by other parts of the code is AGI before
> AGF. So we get an ABBA deadlock between the AGI and AGF here.
> 
...
> 
> In this patch we move the xfs_iunlink_remove() call to
> before acquiring the AGF lock to preserve correct AGI/AGF locking
> order.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 43 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..584b9d1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3282,9 +3282,10 @@ struct xfs_iunlink {
>  					spaceres);
>  
>  	/*
> -	 * Set up the target.
> +	 * Check for expected errors before we dirty the transaction
> +	 * so we can return an error without a transaction abort.
>  	 */
> -	if (target_ip == NULL) {
> +	if (!target_ip) {

Not sure there's really a point to this change now.

>  		/*
>  		 * If there's no space reservation, check the entry will
>  		 * fit before actually inserting it.
> @@ -3294,6 +3295,46 @@ struct xfs_iunlink {
>  			if (error)
>  				goto out_trans_cancel;
>  		}
> +	} else {
> +		/*
> +		 * If target exists and it's a directory, check that whether
> +		 * it can be destroyed.
> +		 */
> +		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
> +		    (!(xfs_dir_isempty(target_ip)) ||
> +		    (VFS_I(target_ip)->i_nlink > 2))) {

^ This line needs one more space of indent because it's encapsulated by
the opening brace one line up. The braces around xfs_dir_isempty() also
look spurious, FWIW. With those nits fixed, the rest looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the patch.

Brian

> +			error = -EEXIST;
> +			goto out_trans_cancel;
> +		}
> +	}
> +
> +	/*
> +	 * Directory entry creation below may acquire the AGF. Remove
> +	 * the whiteout from the unlinked list first to preserve correct
> +	 * AGI/AGF locking order. This dirties the transaction so failures
> +	 * after this point will abort and log recovery will clean up the
> +	 * mess.
> +	 *
> +	 * For whiteouts, we need to bump the link count on the whiteout
> +	 * inode. After this point, we have a real link, clear the tmpfile
> +	 * state flag from the inode so it doesn't accidentally get misused
> +	 * in future.
> +	 */
> +	if (wip) {
> +		ASSERT(VFS_I(wip)->i_nlink == 0);
> +		error = xfs_iunlink_remove(tp, wip);
> +		if (error)
> +			goto out_trans_cancel;
> +
> +		xfs_bumplink(tp, wip);
> +		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> +		VFS_I(wip)->i_state &= ~I_LINKABLE;
> +	}
> +
> +	/*
> +	 * Set up the target.
> +	 */
> +	if (target_ip == NULL) {
>  		/*
>  		 * If target does not exist and the rename crosses
>  		 * directories, adjust the target directory link count
> @@ -3312,22 +3353,6 @@ struct xfs_iunlink {
>  		}
>  	} else { /* target_ip != NULL */
>  		/*
> -		 * If target exists and it's a directory, check that both
> -		 * target and source are directories and that target can be
> -		 * destroyed, or that neither is a directory.
> -		 */
> -		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
> -			/*
> -			 * Make sure target dir is empty.
> -			 */
> -			if (!(xfs_dir_isempty(target_ip)) ||
> -			    (VFS_I(target_ip)->i_nlink > 2)) {
> -				error = -EEXIST;
> -				goto out_trans_cancel;
> -			}
> -		}
> -
> -		/*
>  		 * Link the source inode under the target name.
>  		 * If the source inode is a directory and we are moving
>  		 * it across directories, its ".." entry will be
> @@ -3417,30 +3442,6 @@ struct xfs_iunlink {
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	/*
> -	 * For whiteouts, we need to bump the link count on the whiteout inode.
> -	 * This means that failures all the way up to this point leave the inode
> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> -	 */
> -	if (wip) {
> -		ASSERT(VFS_I(wip)->i_nlink == 0);
> -		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
> -		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> -
> -		/*
> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> -		 * flag from the inode so it doesn't accidentally get misused in
> -		 * future.
> -		 */
> -		VFS_I(wip)->i_state &= ~I_LINKABLE;
> -	}
> -
>  	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
>  	xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);
>  	if (new_parent)
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
