Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B48AC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 16:58:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbiKGQ6f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 11:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbiKGQ6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 11:58:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD5140D5
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 08:58:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D7DB81151
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69282C433B5;
        Mon,  7 Nov 2022 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667840309;
        bh=UH9MSw/g20pyUH6E0CLN7IQRi0V3dyoYSScI/p6gO+Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SfhzbagH3a0Y/W+XhQDthzuVxhm6qM2IgdSH+8hWxK0xRQZzCQmJWWZjDRtUJoUkp
         gZxdxE13eG2AQj/vLtIL3pVeVHlcPCxiwAVftc/bIugNueeFiMgOjZueiTU9xr3eE6
         jE2pEV0tcUjnptu3EC0v+HOh9Caz5sxjg4jcxKMK75Ll47K99z0AA1bE1auJTnTLwX
         AR5dx0yBmziZUyk7kRVR4iTSYdi9O87qpo+kBcOxawyGaX5ew/eovM5Db1O/FmoCWj
         E540yW0wb/x5aO+/idkbuWKEszOJgQvCxthJQLQkXBSBquoMfGsH8v/rdzeuXm56vB
         aMuBrvmYrGaEg==
Date:   Mon, 7 Nov 2022 08:58:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        jack.qiu@huawei.com, fangwei1@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com, leo.lilong@huawei.com, zengheng4@huawei.com
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
Message-ID: <Y2k5NTjTRdsDAuhN@magnolia>
References: <20221103113709.251669-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103113709.251669-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
> xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
> it is a fault injection tag, better not use it in the macro ASSERT.
> 
> Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
> > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> It's confusing and strange.

Please be more specific about how this is confusing or strange.

> Instead of using it in ASSERT, replace it with
> xfs_warn.
> 
> Fixes: 27d9ee577dcc ("xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock")
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_btree.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index eef27858a013..637513087c18 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -556,8 +556,11 @@ xfs_btree_islastblock(
>  	struct xfs_buf		*bp;
>  
>  	block = xfs_btree_get_block(cur, level, &bp);
> -	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
> -
> +	ASSERT(block);
> +#if defined(DEBUG) || defined(XFS_WARN)
> +	if (xfs_btree_check_block(cur, block, level, bp))
> +		xfs_warn(cur->bc_mp, "%s: xfs_btree_check_block() error.", __func__);
> +#endif

...because this seems like open-coding ASSERT, possibly without the
panic on errors part.

--D

>  	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
>  		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
>  	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
> -- 
> 2.31.1
> 
