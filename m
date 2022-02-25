Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470A3C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 05:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiBYFGp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 00:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBYFGp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 00:06:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979E42692B1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 21:06:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37748B82B1F
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 05:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE25C340E7;
        Fri, 25 Feb 2022 05:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645765570;
        bh=Tt36XvYPI8xi6nsX+GHPcXwctC5bgz11y+zTbjHZXOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AHX+EzDwa89ZOeLOTJhmPEOSPBWNW+g9keA8WTcIYYdWr/o06tUVTFUqMDjTQw7eL
         /euVYRNEYF8q3ngWnC40hSY+iuuI/0UyYa+KNDHcnnKjeMps0m8E/0fAhvbiwJwNKP
         /XZD9Ad7m1XGrOUJ+bAQB2J8ejb8/8qw5xkZrL2PbFekfGBFGkhosnQJWLNqFQ71zr
         pp4qfxowLR0eTrwISzBaFQHcmW8LJ1smqeAcBK3oUKjcv6OBi/cZEE8x3Ccx7PL1Ak
         CQrXaaUCGxb13n6tM/bbWZKoRAxYgLzVqBT9JkKnN+xN/yWfzKiG7jwKJBN0i27RT8
         EJp0/Bb4mMXuw==
Date:   Thu, 24 Feb 2022 21:06:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V6 13/17] xfs: xfs_growfs_rt_alloc: Unlock inode
 explicitly rather than through iop_committing()
Message-ID: <20220225050610.GQ8313@magnolia>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-14-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224130211.1346088-14-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 06:32:07PM +0530, Chandan Babu R wrote:
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
>  fs/xfs/xfs_rtalloc.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index b8c79ee791af..379ef99722c5 100644
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

Hmm.  Eventually you could replace all this with a single call to
xfs_trans_alloc_inode, which would fix the quota leak from the rt
metadata file expansion:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=realtime-quotas&id=c82a57844b60bb434103eacf757e47417f94a631

However, as rt+quota are not a supported feature, I'll let that lie for
now.

>  
>  		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
> @@ -824,7 +826,11 @@ xfs_growfs_rt_alloc(
>  		 */
>  		error = xfs_trans_commit(tp);
>  		if (error)
> -			return error;
> +			goto out_trans_cancel;

xfs_trans_commit frees tp even if the commit fails, which means that it
is not correct to call xfs_trans_cancel on tp here.  I think you could
do:

		error = xfs_trans_commit(tp);
		unlock_inode = false;
		xfs_iunlock(ip, XFS_ILOCK_EXCL);
		if (error)
			return error;

Right?

--D

> +
> +		unlock_inode = false;
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
>  		/*
>  		 * Now we need to clear the allocated blocks.
>  		 * Do this one block per transaction, to keep it simple.
> @@ -874,6 +880,8 @@ xfs_growfs_rt_alloc(
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
