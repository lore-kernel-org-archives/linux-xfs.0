Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393A6C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 05:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159842339E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 05:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbfHVFCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:02:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55768 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727781AbfHVFCz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 01:02:55 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1E53E43C435;
        Thu, 22 Aug 2019 15:02:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0fEF-00069M-W2; Thu, 22 Aug 2019 15:01:43 +1000
Date:   Thu, 22 Aug 2019 15:01:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v4] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190822050143.GV1119@dread.disaster.area>
References: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=4idICblQdf1YxnHeVewA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 12:33:23PM +0800, kaixuxia wrote:
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

'So we get an ABBA deadlock between the AGI and AGF here."

Can you also change the subject line to "AGI and AGF" instead of
"agi&agf" which isn't easily searchable? e.g. "xfs: fix ABBA
deadlock between AGI and AGF in rename()".

>  	/*
> -	 * Set up the target.
> +	 * Check for expected errors before we dirty the transaction
> +	 * so we can return an error without a transaction abort.
>  	 */
> -	if (target_ip == NULL) {
> +	if (!target_ip && !spaceres) {
>  		/*
>  		 * If there's no space reservation, check the entry will
>  		 * fit before actually inserting it.
>  		 */
> -		if (!spaceres) {
> -			error = xfs_dir_canenter(tp, target_dp, target_name);
> -			if (error)
> -				goto out_trans_cancel;
> -		}
> +		error = xfs_dir_canenter(tp, target_dp, target_name);
> +		if (error)
> +			goto out_trans_cancel;
> +	} else if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode) &&
> +		  (!(xfs_dir_isempty(target_ip)) ||
> +		  (VFS_I(target_ip)->i_nlink > 2))) {
> +		/*
> +		 * If target exists and it's a directory, check that whether
> +		 * it can be destroyed.
> +		 */
> +		error = -EEXIST;
> +		goto out_trans_cancel;
> +	}

I do think this would be better left separate if statements like
this:

	if (!target_ip) {
		/*
		 * If there's no space reservation, check the entry will
		 * fit before actually inserting it.
		 */
		if (!spaceres) {
			error = xfs_dir_canenter(tp, target_dp, target_name);
			if (error)
				goto out_trans_cancel;
		}
	} else {
		/*
		 * If target exists and it's a directory, check that whether
		 * it can be destroyed.
		 */
		if (S_ISDIR(VFS_I(target_ip)->i_mode) &&
		    (!(xfs_dir_isempty(target_ip)) ||
		    (VFS_I(target_ip)->i_nlink > 2))) {
			error = -EEXIST;
			goto out_trans_cancel;
		}
	}

I find this much easier to read and follow the logic, and we don't
really care if it takes a couple more lines of code to make the
comments and code flow more logically.

> @@ -3419,25 +3431,15 @@ struct xfs_iunlink {
>  
>  	/*
>  	 * For whiteouts, we need to bump the link count on the whiteout inode.

Shouldn't this line be removed as well?

> -	 * This means that failures all the way up to this point leave the inode
> -	 * on the unlinked list and so cleanup is a simple matter of dropping
> -	 * the remaining reference to it. If we fail here after bumping the link
> -	 * count, we're shutting down the filesystem so we'll never see the
> -	 * intermediate state on disk.
> +	 * The whiteout inode has been removed from the unlinked list and log
> +	 * recovery will clean up the mess for the failures up to this point.
> +	 * After this point we have a real link, clear the tmpfile state flag
> +	 * from the inode so it doesn't accidentally get misused in future.
>  	 */
>  	if (wip) {
>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>  		xfs_bumplink(tp, wip);
> -		error = xfs_iunlink_remove(tp, wip);
> -		if (error)
> -			goto out_trans_cancel;
>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
> -
> -		/*
> -		 * Now we have a real link, clear the "I'm a tmpfile" state
> -		 * flag from the inode so it doesn't accidentally get misused in
> -		 * future.
> -		 */
>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>  	}

Why not move all this up into the same branch that removes the
whiteout from the unlinked list? Why separate this logic as none of
what is left here could cause a failure even if it is run earlier?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
