Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36421 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdITTiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 15:38:24 -0400
Date: Wed, 20 Sep 2017 12:37:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: slab corruption in generic/388
Message-ID: <20170920193754.GG7112@magnolia>
References: <20170920145740.GA9685@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920145740.GA9685@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 07:57:40AM -0700, Christoph Hellwig wrote:
> Recently I've a few of these warnings in generic/388 with a 4k
> filesystem on x86_64, v5 file system with reflink and rmap
> enabled but otherwise defaults.  If someones got and idea where
> this might be from I'm curious, otherwise I'll add it to my TODO list.
> 
> [ 5062.894006] XFS (sdb): xfs_do_force_shutdown(0x1) called from line 236 of file fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffff8156cb46
> [ 5062.908923] XFS (sdb): xfs_imap_to_bp: xfs_trans_read_buf() returned error -5.
> [ 5062.986682] XFS (sdb): Unmounting Filesystem
> [ 5063.008740] XFS (sdb): EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!
> [ 5063.010063] XFS (sdb): EXPERIMENTAL reflink feature enabled. Use at your own risk!
> [ 5063.011543] XFS (sdb): Mounting V5 Filesystem
> [ 5063.299537] XFS (sdb): Starting recovery (logdev: internal)
> [ 5063.305221] XFS (sdb): Ending recovery (logdev: internal)
> [ 5063.355721] Slab corruption (Tainted: G        W      ): xfs_rui_item start=ffff88003908f708, len=672
> [ 5063.357058] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 5063.357842] Last user: [<ffffffff815dfa2c>](xfs_rui_item_free+0x1c/0x30)
> [ 5063.358712] 080: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk

Assuming this trace is from 4.14, something decremented rui_refcount
after the xfs_rui_log_item got freed.

--D

> [ 5063.359813] Single bit error detected. Probably bad RAM.
> [ 5063.360512] Run memtest86+ or a similar memory test tool.
> [ 5063.361216] Prev obj: start=ffff88003908f450, len=672
> [ 5063.361876] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 5063.362836] Last user: [<ffffffff815dfa2c>](xfs_rui_item_free+0x1c/0x30)
> [ 5063.363704] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 5063.364708] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 5063.365729] Next obj: start=ffff88003908f9c0, len=672
> [ 5063.366397] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b
> [ 5063.367101] Last user: [<ffffffff815dfa2c>](xfs_rui_item_free+0x1c/0x30)
> [ 5063.367846] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 5063.368637] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 5065.460847] XFS (sdb): Unmounting Filesystem
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
