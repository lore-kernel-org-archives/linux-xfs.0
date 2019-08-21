Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36264C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 11:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 092862082F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 11:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfHULZg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 07:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbfHULZg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 07:25:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB70F81F01;
        Wed, 21 Aug 2019 11:25:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14BCD7987;
        Wed, 21 Aug 2019 11:25:35 +0000 (UTC)
Date:   Wed, 21 Aug 2019 07:25:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190821112533.GB16669@bfoster>
References: <cc2a0c81-ee9e-d2bd-9cc0-025873f394c0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc2a0c81-ee9e-d2bd-9cc0-025873f394c0@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 21 Aug 2019 11:25:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 12:46:18PM +0800, kaixuxia wrote:
> When performing rename operation with RENAME_WHITEOUT flag, we will
> hold AGF lock to allocate or free extents in manipulating the dirents
> firstly, and then doing the xfs_iunlink_remove() call last to hold
> AGI lock to modify the tmpfile info, so we the lock order AGI->AGF.
> 
> The big problem here is that we have an ordering constraint on AGF
> and AGI locking - inode allocation locks the AGI, then can allocate
> a new extent for new inodes, locking the AGF after the AGI. Hence
> the ordering that is imposed by other parts of the code is AGI before
> AGF. So we get the ABBA agi&agf deadlock here.
> 
...
> 
> In this patch we move the xfs_iunlink_remove() call to
> before acquiring the AGF lock to preserve correct AGI/AGF locking
> order.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

FYI, I see this when I pull in this patch:

warning: Patch sent with format=flowed; space at the end of lines might be lost.

Not sure what it means or if it matters. :P

Otherwise this looks much better to me generally. Just some nits..

>  fs/xfs/xfs_inode.c | 61 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..cf06568 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3282,7 +3282,8 @@ struct xfs_iunlink {
>  					spaceres);
> 
>  	/*
> -	 * Set up the target.
> +	 * Error checks before we dirty the transaction, return
> +	 * the error code if check failed and the filesystem is clean.

I'm not sure what "filesystem is clean" refers to here. I think you mean
transaction, but I'm wondering if something like the following is a bit
more clear:

"Check for expected errors before we dirty the transaction so we can
return an error without a transaction abort."

>  	 */
>  	if (target_ip == NULL) {
>  		/*
> @@ -3294,6 +3295,40 @@ struct xfs_iunlink {
>  			if (error)
>  				goto out_trans_cancel;
>  		}
> +	} else {
> +		/*
> +		 * If target exists and it's a directory, check that both
> +		 * target and source are directories and that target can be
> +		 * destroyed, or that neither is a directory.
> +		 */

Interesting that the existing comment refers to checking the source
inode, but that doesn't happen in the code. That's not a bug in this
patch, but are we missing a check here or is the comment stale?

> +		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
> +			/*
> +			 * Make sure target dir is empty.
> +			 */
> +			if (!(xfs_dir_isempty(target_ip)) ||
> +			    (VFS_I(target_ip)->i_nlink > 2)) {
> +				error = -EEXIST;
> +				goto out_trans_cancel;
> +			}
> +		}
> +	}

Code seems fine, but I think we could save some lines by condensing the
logic a bit. For example:

	/*
	 * ...
	 */
	if (!target_ip && !spaceres) {
		/* check for a no res dentry creation */
		error = xfs_dir_canenter();
		...
	} else if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode) &&
		   (!(xfs_dir_isempty(target_ip)) || 
		    (VFS_I(target_ip)->i_nlink > 2)))
		/* can't rename over a non-empty directory */
		error = -EEXIST;
		goto out_trans_cancel;
	}

Hm? Note that we use an 80 column limit, but we also want to expand
short lines to that limit as much as possible and use alignment to make
logic easier to read.

> +
> +	/*
> +	 * Directory entry creation below may acquire the AGF. Remove
> +	 * the whiteout from the unlinked list first to preserve correct
> +	 * AGI/AGF locking order.
> +	 */
> +	if (wip) {
> +		ASSERT(VFS_I(wip)->i_nlink == 0);
> +		error = xfs_iunlink_remove(tp, wip);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
> +	/*
> +	 * Set up the target.
> +	 */
> +	if (target_ip == NULL) {
>  		/*
>  		 * If target does not exist and the rename crosses
>  		 * directories, adjust the target directory link count
> @@ -3312,22 +3347,6 @@ struct xfs_iunlink {
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
> @@ -3421,16 +3440,12 @@ struct xfs_iunlink {
>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
>  	 * This means that failures all the way up to this point leave the inode
>  	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> +	 * the remaining reference to it. Move the xfs_iunlink_remove() call to
> +	 * before acquiring the AGF lock to preserve correct AGI/AGF locking order.

With this change, the earlier part of this comment about failures up
this point leaving the whiteout on the unlinked list is no longer true.
We've already removed it earlier in the function. Also, the new bit
about "moving" the call is confusing because it describes more what this
patch does vs the current code.

I'd suggest a new comment that combines with the one within this branch
(not shown in the patch). For example:

        /*
         * For whiteouts, we need to bump the link count on the whiteout inode.
         * This means that failures all the way up to this point leave the inode
         * on the unlinked list and so cleanup is a simple matter of dropping
         * the remaining reference to it. If we fail here after bumping the link
         * count, we're shutting down the filesystem so we'll never see the
         * intermediate state on disk.
         */

And then remove the comment inside the branch. FWIW, you could also add
a sentence to the earlier comment where the wip is removed like: "This
dirties the transaction so failures after this point will abort and log
recovery will clean up the mess."

Brian

>  	 */
>  	if (wip) {
>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>  		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> 
>  		/*
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
