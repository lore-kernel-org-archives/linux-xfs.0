Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B76ECAAD3
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Sep 2022 22:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiIKWUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiIKWUd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2022 18:20:33 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A9601145B
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 15:20:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-149-49.pa.vic.optusnet.com.au [49.186.149.49])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D90311100985;
        Mon, 12 Sep 2022 08:20:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oXVJQ-006c4W-Ab; Mon, 12 Sep 2022 08:20:24 +1000
Date:   Mon, 12 Sep 2022 08:20:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        zhangshida@kylinos.cn, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix up the comment in xfs_dir2_isleaf
Message-ID: <20220911222024.GY3600936@dread.disaster.area>
References: <20220911033137.4010427-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220911033137.4010427-1-zhangshida@kylinos.cn>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=631e5f2c
        a=XTRC1Ovx3SkpaCW1YxGVGA==:117 a=XTRC1Ovx3SkpaCW1YxGVGA==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
        a=1RTAadx1U3QtmNQZx7oA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 11, 2022 at 11:31:37AM +0800, Stephen Zhang wrote:
> xfs_dir2_isleaf is used to see if the directory is a single-leaf
> form directory, as commented right above the function.
> 
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  fs/xfs/libxfs/xfs_dir2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 76eedc2756b3..1485f53fecf4 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -632,7 +632,7 @@ xfs_dir2_isblock(
>  int
>  xfs_dir2_isleaf(
>  	struct xfs_da_args	*args,
> -	int			*vp)	/* out: 1 is block, 0 is not block */
> +	int			*vp)	/* out: 1 is leaf, 0 is not leaf */
>  {
>  	xfs_fileoff_t		last;	/* last file offset */
>  	int			rval;

If you are going to touch this code to fix a broken comment, then
please clean it up properly.

The "*vp" parameter should be a "bool *isleaf", in which case the
return value is obvious and the comment can be removed. Then the
logic in the function can be cleaned up to be obvious instead of
relying on easy to mistake conditional logic in assignemnts...

IOWs, don't fix the comments - fix the code to be self documenting
to remove the need for comments...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
