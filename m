Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBF1ECAAD4
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 08:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiH2IMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 04:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiH2IMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 04:12:49 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77F69220F8
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 01:12:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-4-169.pa.nsw.optusnet.com.au [49.195.4.169])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D587C10E8E93;
        Mon, 29 Aug 2022 18:12:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oSZsy-001G0u-MI; Mon, 29 Aug 2022 18:12:44 +1000
Date:   Mon, 29 Aug 2022 18:12:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, yi.zhang@huawei.com, houtao1@huawei.com,
        zhengbin13@huawei.com, jack.qiu@huawei.com
Subject: Re: [PATCH] xfs: fix uaf when leaf dir bestcount not match with dir
 data blocks
Message-ID: <20220829081244.GT3600936@dread.disaster.area>
References: <20220829070212.2540615-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829070212.2540615-1-guoxuenan@huawei.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=630c74ff
        a=FOdsZBbW/tHyAhIVFJ0pRA==:117 a=FOdsZBbW/tHyAhIVFJ0pRA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=i0EeH86SAAAA:8 a=7-415B0cAAAA:8
        a=wtxBMAv-dhIfGJAD-QYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 03:02:12PM +0800, Guo Xuenan wrote:
> For leaf dir, there should be as many bestfree slots as there are dir data
> blocks that can fit under i_size. Othrewise, which may cause UAF or
> slab-out-of bound etc.

Nice find, and thanks for the comprehensive description of the
problem!

> Root cause is we don't examin the number bestfree slots, when the slots
> number less than dir data blocks, if we need to allocate new dir data block
> and update the bestfree array, we will use the dir block number as index to
> assign bestfree array, which may cause UAF or other memory access problem.
> This issue can also triggered with test cases xfs/473 from fstests.
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

Ah, so it's verifier deficiency...

Can you turn this reproducer back into a new fstest, please?

[....]

> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index d9b66306a9a7..09414651ac48 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -659,6 +659,20 @@ xfs_dir2_leaf_addname(
>  	bestsp = xfs_dir2_leaf_bests_p(ltp);
>  	length = xfs_dir2_data_entsize(dp->i_mount, args->namelen);
>  
> +	/*
> +	 * There should be as many bestfree slots as there are dir data
> +	 * blocks that can fit under i_size. Othrewise, which may cause
> +	 * serious problems eg. UAF or slab-out-of bound etc.
> +	 */
> +	if (be32_to_cpu(ltp->bestcount) !=
> +			xfs_dir2_byte_to_db(args->geo, dp->i_d.di_size)) {
> +		xfs_buf_ioerror_alert(lbp, __return_address);
> +		if (tp->t_flags & XFS_TRANS_DIRTY)
> +			xfs_force_shutdown(tp->t_mountp,
> +				SHUTDOWN_CORRUPT_INCORE);
> +		return -EFSCORRUPTED;
> +	}
> +

Yeah, that needs to go in xfs_dir3_leaf_check_int() so we catch the
corruption as it comes in off disk (and before an in-memory
corruption might get written back to disk) - we don't need to check
it every time we add an entry to a leaf block.

Indeed, I left a comment in xfs_dir3_leaf_check_int() indicating
that the checking wasn't restrictive enough:

        /*
         * XXX (dgc): This value is not restrictive enough.
         * Should factor in the size of the bests table as well.
         * We can deduce a value for that from i_disk_size.
         */
        if (hdr->count > geo->leaf_max_ents)
                return __this_address;

IOWs, we need update xfs_dir3_leaf_check_int() to check the
bestcount against the size of the bests table as you've done above,
and then also use that table size info to reduce the bound that we
validate the leaf block entry count against, too.

Can you update your fix to validate both these fields correctly
against the size of the bests table in xfs_dir3_leaf_check_int()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
