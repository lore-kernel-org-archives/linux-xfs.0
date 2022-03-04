Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C955BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 07:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiCDH0P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Mar 2022 02:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236030AbiCDH0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Mar 2022 02:26:14 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A52FB190B6C
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 23:25:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4657C533C24;
        Fri,  4 Mar 2022 18:25:24 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nQ2JY-001Kuc-Fb; Fri, 04 Mar 2022 18:25:24 +1100
Date:   Fri, 4 Mar 2022 18:25:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode
 explicitly rather than through iop_committing()
Message-ID: <20220304072524.GI59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-14-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6221bee5
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=_z7d9AJ45aGD6SRB-ksA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:34PM +0530, Chandan Babu R wrote:
> In order to be able to upgrade inodes to XFS_DIFLAG2_NREXT64, a future commit
> will perform such an upgrade in a transaction context. This requires the
> transaction to be rolled once. Hence inodes which have been added to the
> tranasction (via xfs_trans_ijoin()) with non-zero value for lock_flags
> argument would cause the inode to be unlocked when the transaction is rolled.
> 
> To prevent this from happening in the case of realtime bitmap/summary inodes,
> this commit now unlocks the inode explictly rather than through
> iop_committing() call back.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index b8c79ee791af..a70140b35e8b 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -780,6 +780,7 @@ xfs_growfs_rt_alloc(
>  	int			resblks;	/* space reservation */
>  	enum xfs_blft		buf_type;
>  	struct xfs_trans	*tp;
> +	bool			unlock_inode;
>  
>  	if (ip == mp->m_rsumip)
>  		buf_type = XFS_BLFT_RTSUMMARY_BUF;
> @@ -802,7 +803,8 @@ xfs_growfs_rt_alloc(
>  		 * Lock the inode.
>  		 */
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, ip, 0);
> +		unlock_inode = true;
>  
>  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
> @@ -823,8 +825,11 @@ xfs_growfs_rt_alloc(
>  		 * Free any blocks freed up in the transaction, then commit.
>  		 */
>  		error = xfs_trans_commit(tp);
> -		if (error)
> +                unlock_inode = false;
> +                xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +                if (error)
>  			return error;
> +

whitespace damage.

>  		/*
>  		 * Now we need to clear the allocated blocks.
>  		 * Do this one block per transaction, to keep it simple.
> @@ -874,6 +879,8 @@ xfs_growfs_rt_alloc(
>  
>  out_trans_cancel:
>  	xfs_trans_cancel(tp);
> +	if (unlock_inode)
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;

That's kinda messy, IMO. If you create a new error stack like:

out_trans_cancel:
	xfs_trans_cancel(tp);
	return error;

out_cancel_unlock:
	xfs_trans_cancel(tp);
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	return error;

Then you can get rid of the unlock_inode variable and just change
the if (error) goto ... jumps in the appropriate places where
unlock on cancel is needed. That seems much cleaner and easier to
verify.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
