Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FCBC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E75220721
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 21:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgEDVZp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 17:25:45 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41501 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgEDVZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 17:25:44 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 661EC3A2DF9;
        Tue,  5 May 2020 07:25:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jViaq-0008Es-Bo; Tue, 05 May 2020 07:25:40 +1000
Date:   Tue, 5 May 2020 07:25:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: xfs: fix a possible data race in
 xfs_inode_set_reclaim_tag()
Message-ID: <20200504212540.GK2040@dread.disaster.area>
References: <20200504161530.14059-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504161530.14059-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=pGLkceISAAAA:8 a=7-415B0cAAAA:8
        a=6-RQ5ys-hy-pMIlWX7oA:9 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 05, 2020 at 12:15:30AM +0800, Jia-Ju Bai wrote:
> We find that xfs_inode_set_reclaim_tag() and xfs_reclaim_inode() are
> concurrently executed at runtime in the following call contexts:
> 
> Thread1:
>   xfs_fs_put_super()
>     xfs_unmountfs()
>       xfs_rtunmount_inodes()
>         xfs_irele()
>           xfs_fs_destroy_inode()
>             xfs_inode_set_reclaim_tag()
> 
> Thread2:
>   xfs_reclaim_worker()
>     xfs_reclaim_inodes()
>       xfs_reclaim_inodes_ag()
>         xfs_reclaim_inode()
> 
> In xfs_inode_set_reclaim_tag():
>   pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>   ...
>   spin_lock(&ip->i_flags_lock);
> 
> In xfs_reclaim_inode():
>   spin_lock(&ip->i_flags_lock);
>   ...
>   ip->i_ino = 0;
>   spin_unlock(&ip->i_flags_lock);
> 
> Thus, a data race can occur for ip->i_ino.
> 
> To fix this data race, the spinlock ip->i_flags_lock is used to protect
> the access to ip->i_ino in xfs_inode_set_reclaim_tag().
> 
> This data race is found by our concurrency fuzzer.

This data race cannot happen.

xfs_reclaim_inode() will not be called on this inode until -after-
the XFS_ICI_RECLAIM_TAG is set in the radix tree for this inode, and
setting that is protected by the i_flags_lock.

So while the xfs_perag_get() call doesn't lock the ip->i_ino access,
there is are -multiple_ iflags_lock lock/unlock cycles before
ip->i_ino is cleared in the reclaim worker. Hence there is a full
unlock->lock memory barrier for the ip->i_ino reset inside the
critical section vs xfs_inode_set_reclaim_tag().

Hence even if the reclaim worker could access the inode before the
XFS_ICI_RECLAIM_TAG is set, no data race exists here.

> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  fs/xfs/xfs_icache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 8bf1d15be3f6..a2de08222ff5 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -229,9 +229,9 @@ xfs_inode_set_reclaim_tag(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_perag	*pag;
>  
> +	spin_lock(&ip->i_flags_lock);
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
> -	spin_lock(&ip->i_flags_lock);

Also, this creates a lock inversion deadlock here with
xfs_iget_cache_hit() clearing the XFS_IRECLAIMABLE flag.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
