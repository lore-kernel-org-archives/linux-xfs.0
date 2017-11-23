Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:18128 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbdKWQRr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 11:17:47 -0500
Subject: Re: [PATCH] xfs: handle register_shrinker error
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20171123120828.31881-1-mhocko@kernel.org>
        <20171123132633.GB21798@infradead.org>
        <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
        <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
        <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
In-Reply-To: <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
Message-Id: <201711240117.DDH05249.LMOOFQFJOHFStV@I-love.SAKURA.ne.jp>
Date: Fri, 24 Nov 2017 01:17:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: mhocko@kernel.org
Cc: hch@infradead.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Michal Hocko wrote:
> Hmm, you are right. I have (blindly) followed the current code flow
> which is wrong as well. The following should do the trick. Should I
> split that into two patches?

Well, xfs_alloc_buftarg() needs to be more careful.

xfs_alloc_buftarg(
        struct xfs_mount        *mp,
        struct block_device     *bdev,
        struct dax_device       *dax_dev)
{
        xfs_buftarg_t           *btp;

        btp = kmem_zalloc(sizeof(*btp), KM_SLEEP | KM_NOFS); // This is GFP_NOFS context. But...

        btp->bt_mount = mp;
        btp->bt_dev =  bdev->bd_dev;
        btp->bt_bdev = bdev;
        btp->bt_daxdev = dax_dev;

        if (xfs_setsize_buftarg_early(btp, bdev))
                goto error;

        if (list_lru_init(&btp->bt_lru)) // This is GFP_KERNEL context.
                goto error;

        if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL)) // This is GFP_KERNEL context.
                goto error; // Need to undo list_lru_init() before kmem_free().

        btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
        btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
        btp->bt_shrinker.seeks = DEFAULT_SEEKS;
        btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
        register_shrinker(&btp->bt_shrinker); // This is GFP_KERNEL context.
        return btp;

error:
        kmem_free(btp);
        return NULL;
}
