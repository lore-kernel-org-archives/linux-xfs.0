Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D638DECAAD3
	for <linux-xfs@archiver.kernel.org>; Sun, 11 Sep 2022 22:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiIKWis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIKWir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2022 18:38:47 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB0BE1CB15
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 15:38:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-149-49.pa.vic.optusnet.com.au [49.186.149.49])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6199862E698;
        Mon, 12 Sep 2022 08:38:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oXVb5-006cTD-J5; Mon, 12 Sep 2022 08:38:39 +1000
Date:   Mon, 12 Sep 2022 08:38:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Stephen Zhang <starzhangzsd@gmail.com>
Cc:     djwong@kernel.org, dchinner@redhat.com, chandan.babu@oracle.com,
        yang.guang5@zte.com.cn, zhangshida@kylinos.cn,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: eliminate the potential overflow risk in
 xfs_da_grow_inode_int
Message-ID: <20220911223839.GZ3600936@dread.disaster.area>
References: <20220910023839.3964539-1-zhangshida@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220910023839.3964539-1-zhangshida@kylinos.cn>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=631e6373
        a=XTRC1Ovx3SkpaCW1YxGVGA==:117 a=XTRC1Ovx3SkpaCW1YxGVGA==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=7-415B0cAAAA:8
        a=cD3R-YPwg2Xwe9XFdZYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 10, 2022 at 10:38:39AM +0800, Stephen Zhang wrote:
> The problem lies in the for-loop of xfs_da_grow_inode_int:
> ======
> for(){
>         nmap = min(XFS_BMAP_MAX_NMAP, count);
>         ...
>         error = xfs_bmapi_write(...,&mapp[mapi], &nmap);//(..., $1, $2)
>         ...
>         mapi += nmap;
> }
> =====
> where $1 stands for the start address of the array,
> while $2 is used to indicate the size of the array.
> 
> The array $1 will advanced by $nmap in each iteration after
> the allocation of extents.
> But the size $2 still remains constant, which is determined by
> min(XFS_BMAP_MAX_NMAP, count).
> 
> Hence there is a risk of overflow when the remained space in
> the array is less than $2.
> So variablize the array size $2 correspondingly in each iteration
> to eliminate the risk.

Except that xfs_bmapi_write() won't overrun the array....

> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index e7201dc68f43..3ef8c04624cc 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2192,7 +2192,7 @@ xfs_da_grow_inode_int(
>  		 */
>  		mapp = kmem_alloc(sizeof(*mapp) * count, 0);
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
> -			nmap = min(XFS_BMAP_MAX_NMAP, count);
> +			nmap = min(XFS_BMAP_MAX_NMAP, count - mapi);
>  			c = (int)(*bno + count - b);
>  			error = xfs_bmapi_write(tp, dp, b, c,
>  					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,


... because we've allocated a mapp array large enough for one extent
map per filesystem block.

The line:

	c = (int)(*bno + count - b);

calculates the maximum length of the extent remaining to map, and
hence the maximum number of blocks we might need to map.  We're
guaranteed that the array is large enough for all single block maps,
and xfs_bmapi_write() will never overrun the array because it doesn't
map extents beyond the length requested. IOWs, there isn't an array
overrun bug here even though we don't trim the requested number of
maps on the last call.

So the question remains: Why do we need *two* calculations that
calculate the remaining number of blocks to map here? i.e. surely
all we need is this:

-			nmap = min(XFS_BMAP_MAX_NMAP, count);
 			c = (int)(*bno + count - b);
+			nmap = min(XFS_BMAP_MAX_NMAP, c);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
