Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F63CECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Sep 2022 01:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiILBb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Sep 2022 21:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiILBb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Sep 2022 21:31:58 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5606C23BFE
        for <linux-xfs@vger.kernel.org>; Sun, 11 Sep 2022 18:31:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-149-49.pa.vic.optusnet.com.au [49.186.149.49])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E6D6462DFC8;
        Mon, 12 Sep 2022 11:31:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oXYIk-006fS6-1y; Mon, 12 Sep 2022 11:31:54 +1000
Date:   Mon, 12 Sep 2022 11:31:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH v2] xfs: fix uaf when leaf dir bestcount not match with
 dir data blocks
Message-ID: <20220912013154.GB3600936@dread.disaster.area>
References: <20220831121639.3060527-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831121639.3060527-1-guoxuenan@huawei.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=631e8c0c
        a=XTRC1Ovx3SkpaCW1YxGVGA==:117 a=XTRC1Ovx3SkpaCW1YxGVGA==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ReYYYOgS4Q7m7cgRrO8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 31, 2022 at 08:16:39PM +0800, Guo Xuenan wrote:
> For leaf dir, In most cases, there should be as many bestfree slots
> as the dir data blocks that can fit under i_size (except for [1]).
> 
> Root cause is we don't examin the number bestfree slots, when the slots
> number less than dir data blocks, if we need to allocate new dir data
> block and update the bestfree array, we will use the dir block number as
> index to assign bestfree array, while we did not check the leaf buf
> boundary which may cause UAF or other memory access problem. This issue
> can also triggered with test cases xfs/473 from fstests.
> 
> Considering the special case [1] , only add check bestfree array boundary,
> to avoid UAF or slab-out-of bound.
> 
> [1] https://lore.kernel.org/all/163961697197.3129691.1911552605195534271.stgit@magnolia/
> 
> Simplify the testcase xfs/473 with commands below:
> DEV=/dev/sdb
> MP=/mnt/sdb
> WORKDIR=/mnt/sdb/341 #1. mkfs create new xfs image
> mkfs.xfs -f ${DEV}
> mount ${DEV} ${MP}
> mkdir -p ${WORKDIR}
> for i in `seq 1 341` #2. create leaf dir with 341 entries file name len 8
> do
>     touch ${WORKDIR}/$(printf "%08d" ${i})
> done
> inode=$(ls -i ${MP} | cut -d' ' -f1)
> umount ${MP}         #3. xfs_db set bestcount to 0
> xfs_db -x ${DEV} -c "inode ${inode}" -c "dblock 8388608" \
> -c "write ltail.bestcount 0"
> mount ${DEV} ${MP}
> touch ${WORKDIR}/{1..100}.txt #4. touch new file, reproduce
.....
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d9b66306a9a7..4b2a72b3a6f3 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -819,6 +819,18 @@ xfs_dir2_leaf_addname(
>  		 */
>  		else
>  			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
> +		/*
> +		 * An abnormal corner case, bestfree count less than data
> +		 * blocks, add a condition to avoid UAF or slab-out-of bound.
> +		 */
> +		if ((char *)(&bestsp[use_block]) > (char *)ltp) {
> +			xfs_trans_brelse(tp, lbp);
> +			if (tp->t_flags & XFS_TRANS_DIRTY)
> +				xfs_force_shutdown(tp->t_mountp,
> +						SHUTDOWN_CORRUPT_ONDISK);
> +			return -EFSCORRUPTED;
> +		}
> +

As I explained here:

https://lore.kernel.org/linux-xfs/20220829081244.GT3600936@dread.disaster.area/

We don't check for overruns caused by on-disk format corruptions in
every operation - we catch the corruption when the metadata is first
read into memory via the verifier.

Please add a check for a corrupt/mismatched best sizes array to
xfs_dir3_leaf_check_int() so that the corruption is detected on
first read and the internal directory code is never exposed to such
issues.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
