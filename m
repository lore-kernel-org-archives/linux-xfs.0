Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE10CC3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 15:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9999320651
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 15:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfHSPNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 11:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbfHSPNi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 11:13:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63CDB3001836;
        Mon, 19 Aug 2019 15:13:38 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D5A780696;
        Mon, 19 Aug 2019 15:13:37 +0000 (UTC)
Date:   Mon, 19 Aug 2019 11:13:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH V2] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190819151335.GB2875@bfoster>
References: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8eda2397-b7fb-6dd4-a448-a81628b48edc@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 19 Aug 2019 15:13:38 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 09:06:39PM +0800, kaixuxia wrote:
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
> In this patch we move the xfs_iunlink_remove() call to between
> xfs_dir_canenter() and xfs_dir_createname(). By doing xfs_iunlink
> _remove() firstly, we remove the AGI/AGF lock inversion problem.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_inode.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6467d5e..48691f2 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3294,6 +3294,18 @@ struct xfs_iunlink {
>  			if (error)
>  				goto out_trans_cancel;
>  		}
> +
> +		/*
> +		 * Handle the whiteout inode and acquire the AGI lock, so
> +		 * fix the AGI/AGF lock inversion problem.
> +		 */

The comment could be a little more specific. For example:

"Directory entry creation may acquire the AGF. Remove the whiteout from
the unlinked list first to preserve correct AGI/AGF locking order."

> +		if (wip) {
> +			ASSERT(VFS_I(wip)->i_nlink == 0);
> +			error = xfs_iunlink_remove(tp, wip);
> +			if (error)
> +				goto out_trans_cancel;
> +		}
> +
>  		/*
>  		 * If target does not exist and the rename crosses
>  		 * directories, adjust the target directory link count
> @@ -3428,9 +3440,11 @@ struct xfs_iunlink {
>  	if (wip) {
>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>  		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
> +		if (target_ip != NULL) {
> +			error = xfs_iunlink_remove(tp, wip);
> +			if (error)
> +				goto out_trans_cancel;
> +		}

The comment above this hunk needs to be updated. I'm also not a big fan
of this factoring of doing the removal in the if branch above and then
encoding the else logic down here. It might be cleaner and more
consistent to have a call in each branch of the if/else above.

FWIW, I'm also curious if this could be cleaned up further by pulling
the -ENOSPC/-EEXIST checks out of the earlier branch, following that
with the whiteout removal, and then doing the dir_create/replace. For
example, something like:

	/* error checks before we dirty the transaction */
	if (!target_ip && !spaceres) {
		error = xfs_dir_canenter();
		...
	} else if (S_ISDIR() && !(empty || nlink > 2))
		error = -EEXIST;
		...
	}

	if (wip) {
		...
		xfs_iunlink_remove();
	}

	if (!target_ip) {
		xfs_dir_create();
		...
	} else {
		xfs_dir_replace();
		...
	}

... but that may not be any cleaner..? It could also be done as a
followup cleanup patch as well.

Brian

>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> 
>  		/*
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
