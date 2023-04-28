Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3E8C77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 18:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344556AbjD1SZM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 14:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346305AbjD1SZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 14:25:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBBE5FE0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 11:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 254B264428
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 18:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A93AC433D2;
        Fri, 28 Apr 2023 18:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682706292;
        bh=tosyD7klgfrNt1vURlYZ0k5nwcjeeM4m6lrd0MJuUFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9YefFK8KYQtdojU2FplDs0mujL97svUhXEEPqZNQmv0ILv+Lc9jgXKx/TKpCEkfX
         8u5YuzfvxwLkQxGvFz1bDbHvQF7YiX9iNKCeHfiSXp7pWBy4wk2PgyPJvYVrnjS8t1
         10IjZvFmza7JE4do7LaN/EJf+b2WXhJ/4BGPDGXILmK/nIXiYxLwzwmLb6zS2G30sZ
         9Kya4hED6XM0N29E9/VFXp4F/xxFTxOOMSE9UwSTI1zGjcfYqonvVlPRFy1j5nvfjZ
         CiM8KozcIKpF2HyKqI9YoujufrxLcB0J1kX/TlJPrv1yxbN26rhikUFu0S+2Eut3dd
         N7co2HjGCJr4w==
Date:   Fri, 28 Apr 2023 11:24:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Long Li <leo.lilong@huawei.com>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v2] xfs: fix ag count overflow during growfs
Message-ID: <20230428182452.GL59213@frogsfrogsfrogs>
References: <20230428072012.GA1748602@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428072012.GA1748602@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2023 at 03:20:12PM +0800, Long Li wrote:
> I found a corruption during growfs:
> 
>  XFS (loop0): Internal error agbno >= mp->m_sb.sb_agblocks at line 3661 of
>    file fs/xfs/libxfs/xfs_alloc.c.  Caller __xfs_free_extent+0x28e/0x3c0
>  CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x50/0x70
>   xfs_corruption_error+0x134/0x150
>   __xfs_free_extent+0x2c1/0x3c0
>   xfs_ag_extend_space+0x291/0x3e0
>   xfs_growfs_data+0xd72/0xe90
>   xfs_file_ioctl+0x5f9/0x14a0
>   __x64_sys_ioctl+0x13e/0x1c0
>   do_syscall_64+0x39/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  XFS (loop0): Corruption detected. Unmount and run xfs_repair
>  XFS (loop0): Internal error xfs_trans_cancel at line 1097 of file
>    fs/xfs/xfs_trans.c.  Caller xfs_growfs_data+0x691/0xe90
>  CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x50/0x70
>   xfs_error_report+0x93/0xc0
>   xfs_trans_cancel+0x2c0/0x350
>   xfs_growfs_data+0x691/0xe90
>   xfs_file_ioctl+0x5f9/0x14a0
>   __x64_sys_ioctl+0x13e/0x1c0
>   do_syscall_64+0x39/0x80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  RIP: 0033:0x7f2d86706577
> 
> The bug can be reproduced with the following sequence:
> 
>  # truncate -s  1073741824 xfs_test.img
>  # mkfs.xfs -f -b size=1024 -d agcount=4 xfs_test.img
>  # truncate -s 2305843009213693952  xfs_test.img
>  # mount -o loop xfs_test.img /mnt/test
>  # xfs_growfs -D  1125899907891200  /mnt/test
> 
> The root cause is that during growfs, user space passed in a large value
> of newblcoks to xfs_growfs_data_private(), due to current sb_agblocks is
> too small, new AG count will exceed UINT_MAX. Because of AG number type
> is unsigned int and it would overflow, that caused nagcount much smaller
> than the actual value. During AG extent space, delta blocks in
> xfs_resizefs_init_new_ags() will much larger than the actual value due to
> incorrect nagcount, even exceed UINT_MAX. This will cause corruption and
> be detected in __xfs_free_extent. Fix it by add checks for nagcount
> overflow in xfs_growfs_data_private.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
> v2:
> - Check for overflowing of agcount only in xfs_growfs_data_private
> 
>  fs/xfs/xfs_fsops.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 13851c0d640b..084c69a91937 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -116,6 +116,9 @@ xfs_growfs_data_private(
>  	nb_div = nb;
>  	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
>  	nagcount = nb_div + (nb_mod != 0);
> +	/* check for overflow */
> +	if (nagcount < nb_div)
> +		return -EINVAL;
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;

If in->newblocks (aka nb) is just large enough to cause an overflow in
nagcount /and/ 0 < nb_mod < XFS_MIN_AG_BLOCKS, then this change would
make the function return EINVAL whereas before it would've succeeded
because the overflow from the division would be canceled out by the
underflow from the subtraction, right?

Granted, that's a corner case of a corner case, but I don't want to
introduce error returns where there previously were none.

Also, do we want to return EINVAL here, as opposed to growing the
filesystem to up to the maximally allowed 0xFFFFFFFF AGs?

	#define XFS_AGNUMBER_MAX	((xfs_agnumber_t)(-1U))
	u64 nb_div = nb;

	/* nb_div is updated in place */
	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS) {
		nb_div++;
	} else if (nb_mod) {
		nb = nb_div * mp->m_sb.sb_agblocks;
	}
	if (nb_div > XFS_AGNUMBER_MAX) {
		nb_div = XFS_AGNUMBER_MAX;
		nb = min(nb, nb_div * mp->m_sb.sb_agblocks);
	}
	nagcount = nb_div;
	delta = nb - mp->m_sb.sb_dblocks;

--D

>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
> -- 
> 2.31.1
> 
