Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B399C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Mar 2022 00:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbiCBA0y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Mar 2022 19:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiCBA0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Mar 2022 19:26:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F628D6B5
        for <linux-xfs@vger.kernel.org>; Tue,  1 Mar 2022 16:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF86AB81ECD
        for <linux-xfs@vger.kernel.org>; Wed,  2 Mar 2022 00:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAE1C340EE;
        Wed,  2 Mar 2022 00:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646180761;
        bh=VBWc9FyIUfGTVTa3KV80QxvC7veiflaOOAjVORWX0s8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPmRwIr50+oSyBfOdyAK+RGcBnMHKxq+iFg2UDjPQOyl89PSqikKxw3ToYEv5YjS0
         D6h5VCf+8Dxliff3SrlcToJzB03QShK3clnD6p1T4zHRtJXN9vocPGuX/b9cKpp9Mc
         FPQlgqLD5ytUClLqHRA6ioiV62LpQeHpHKM844un4FXmMxTqzBgrIdskCWje7d4xRW
         8FTTcjmbrq/GMR8ItQ6caUCgQX825lhtasRI60p77f1ReTT0+2ni3a6xd3hfY7EB7n
         XQSy0voddTJJdf9CfECwNA5928L3DXdOcCvG5yjpcpVczsWA0FTReUqC/wWeuY6JYh
         5vhmVMkiW7fiA==
Date:   Tue, 1 Mar 2022 16:26:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V7 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode
 explicitly rather than through iop_committing()
Message-ID: <20220302002600.GK117732@magnolia>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-14-chandan.babu@oracle.com>
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

Whitespace corruption here?

Other than that ... let's see, the ILOCK/ijoin in the inner loop that
zeroes the new bitmap/summary blocks doesn't require an explicit unlock,
so I think this looks fine now.

So with that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
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
>  }
>  
> -- 
> 2.30.2
> 
