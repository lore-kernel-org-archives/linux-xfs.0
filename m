Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E431EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Nov 2022 04:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiK3ERr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 23:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiK3ERp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 23:17:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43AD27B21
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 20:17:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B72EB819FA
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 04:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B96C433D7;
        Wed, 30 Nov 2022 04:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669781861;
        bh=o/7FDwRxhRvWuUkgskn03yYWnOUAIV1twcW92y45QV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=brkzIZxH7Epk9jhdRHy4h6tnO+rS11KZ+7gusB1i2xSILXWlVW23ATmdXwLaV+2Zy
         7HRUu/eOklR82+IZ3Q73t5HaCEqDn2q4QFoVw9r6fC3Uuq3dGtf3OfNT1pYAV+F3VY
         rkrpkSkzZY27OaGrw+NauJjBbPVP2dM9cmsGe9sZyQdFPLhpWTB/pq8E15sCK6OBS3
         D40aBOyBcObBipBPBlMF4wzHuHZO2E1bMkKlQag57wPJ8gwwFc4ekiaOPbAPZOOyZd
         Lf74/fKhew/F3eE1F221IOy8INN99GNAgzJy4ivmP66TEqeCv/LQGujuOtckY9YEQ4
         sUJiYx+Cm38DQ==
Date:   Tue, 29 Nov 2022 20:17:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        jack.qiu@huawei.com, fangwei1@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com, leo.lilong@huawei.com
Subject: Re: [PATCH v2] xfs: get rid of assert from xfs_btree_islastblock
Message-ID: <Y4bZZP1z9aeoJYNV@magnolia>
References: <20221130040237.2434259-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130040237.2434259-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 12:02:37PM +0800, Guo Xuenan wrote:
> xfs_btree_check_block contains debugging knobs. With XFS_DEBUG setting up,
> turn on the debugging knob can trigger the assert of xfs_btree_islastblock,
> test script as follows:
> 
> while true
> do
>     mount $disk $mountpoint
>     fsstress -d $testdir -l 0 -n 10000 -p 4 >/dev/null
>     echo 1 > /sys/fs/xfs/sda/errortag/btree_chk_sblk
>     sleep 10
>     umount $mountpoint
> done
> 
> Kick off fsstress and only *then* turn on the debugging knob. If it
> happens that the knob gets turned on after the cntbt lookup succeeds
> but before the call to xfs_btree_islastblock, then we *can* end up in
> the situation where a previously checked btree block suddenly starts
> returning EFSCORRUPTED from xfs_btree_check_block. Kaboom.
> 
> Darrick give a very detailed explanation as follows:
> Looking back at commit 27d9ee577dcce, I think the point of all this was
> to make sure that the cursor has actually performed a lookup, and that
> the btree block at whatever level we're asking about is ok.
> 
> If the caller hasn't ever done a lookup, the bc_levels array will be
> empty, so cur->bc_levels[level].bp pointer will be NULL.  The call to
> xfs_btree_get_block will crash anyway, so the "ASSERT(block);" part is
> pointless.
> 
> If the caller did a lookup but the lookup failed due to block
> corruption, the corresponding cur->bc_levels[level].bp pointer will also
> be NULL, and we'll still crash.  The "ASSERT(xfs_btree_check_block);"
> logic is also unnecessary.
> 
> If the cursor level points to an inode root, the block buffer will be
> incore, so it had better always be consistent.
> 
> If the caller ignores a failed lookup after a successful one and calls
> this function, the cursor state is garbage and the assert wouldn't have
> tripped anyway. So get rid of the assert.
> 
> Fixes: 27d9ee577dcc ("xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock")
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>

Seems fine to me, but what does everyone else think?

Tentatively,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index eef27858a013..29c4b4ccb909 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -556,7 +556,6 @@ xfs_btree_islastblock(
>  	struct xfs_buf		*bp;
>  
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
>  
>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
> -- 
> 2.31.1
> 
