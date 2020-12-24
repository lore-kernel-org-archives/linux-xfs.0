Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFB8C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Dec 2020 19:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D1D522512
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Dec 2020 19:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgLXTgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Dec 2020 14:36:14 -0500
Received: from sandeen.net ([63.231.237.45]:49084 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbgLXTgO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Dec 2020 14:36:14 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C3F1815D6C;
        Thu, 24 Dec 2020 13:34:27 -0600 (CST)
To:     Fengfei Xi <xi.fengfei@h3c.com>, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        tian.xianting@h3c.com
References: <20201224095142.7201-1-xi.fengfei@h3c.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: fix system crash caused by null bp->b_pages
Message-ID: <63d75865-84c6-0f76-81a2-058f4cad1d84@sandeen.net>
Date:   Thu, 24 Dec 2020 13:35:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224095142.7201-1-xi.fengfei@h3c.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/24/20 3:51 AM, Fengfei Xi wrote:
> We have encountered the following problems several times:
>     1、A raid slot or hardware problem causes block device loss.
>     2、Continue to issue IO requests to the problematic block device.
>     3、The system possibly crash after a few hours.

What kernel is this on?

> dmesg log as below:
> [15205901.268313] blk_partition_remap: fail for partition 1

I think this message has been gone since kernel v4.16...

If you're testing this on an old kernel, can you reproduce it on a
current kernel?

> [15205901.319309] blk_partition_remap: fail for partition 1
> [15205901.319341] blk_partition_remap: fail for partition 1
> [15205901.319873] sysctl (3998546): drop_caches: 3

What performed the drop_caches immediately before the BUG?  Does
the BUG happen without drop_caches?

> [15205901.371379] BUG: unable to handle kernel NULL pointer dereference at

was something lost here?  "dereference at" ... what?

> [15205901.372602] IP: xfs_buf_offset+0x32/0x60 [xfs]
> [15205901.373605] PGD 0 P4D 0
> [15205901.374690] Oops: 0000 [#1] SMP
> [15205901.375629] Modules linked in:
> [15205901.382445] CPU: 6 PID: 18545 Comm: xfsaild/sdh1 Kdump: loaded Tainted: G
> [15205901.384728] Hardware name:
> [15205901.385830] task: ffff885216939e80 task.stack: ffffb28ba9b38000
> [15205901.386974] RIP: 0010:xfs_buf_offset+0x32/0x60 [xfs]
> [15205901.388044] RSP: 0018:ffffb28ba9b3bc68 EFLAGS: 00010246
> [15205901.389021] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000b
> [15205901.390016] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88627bebf000
> [15205901.391075] RBP: ffffb28ba9b3bc98 R08: ffff88627bebf000 R09: 00000001802a000d
> [15205901.392031] R10: ffff88521f3a0240 R11: ffff88627bebf000 R12: ffff88521041e000
> [15205901.392950] R13: 0000000000000020 R14: ffff88627bebf000 R15: 0000000000000000
> [15205901.393858] FS:  0000000000000000(0000) GS:ffff88521f380000(0000) knlGS:0000000000000000
> [15205901.394774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [15205901.395756] CR2: 0000000000000000 CR3: 000000099bc09001 CR4: 00000000007606e0
> [15205901.396904] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [15205901.397869] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [15205901.398836] PKRU: 55555554
> [15205901.400111] Call Trace:
> [15205901.401058]  ? xfs_inode_buf_verify+0x8e/0xf0 [xfs]
> [15205901.402069]  ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> [15205901.403060]  xfs_inode_buf_write_verify+0x10/0x20 [xfs]
> [15205901.404017]  _xfs_buf_ioapply+0x88/0x410 [xfs]
> [15205901.404990]  ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> [15205901.405929]  xfs_buf_submit+0x63/0x200 [xfs]
> [15205901.406801]  xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> [15205901.407675]  ? xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
> [15205901.408540]  ? xfs_inode_item_push+0xb7/0x190 [xfs]
> [15205901.409395]  xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
> [15205901.410249]  xfsaild+0x29a/0x780 [xfs]
> [15205901.411121]  kthread+0x109/0x140
> [15205901.411981]  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> [15205901.412785]  ? kthread_park+0x60/0x60
> [15205901.413578]  ret_from_fork+0x2a/0x40
> 
> The "obvious" cause is that the bp->b_pages was NULL in function
> xfs_buf_offset. Analyzing vmcore, we found that b_pages=NULL but
> b_page_count=16, so b_pages is set to NULL for some reason.

this can happen, for example _xfs_buf_get_pages sets the count, but may
fail the allocation, and leave the count set while the pointer is NULL.
> 
> crash> struct xfs_buf ffff88627bebf000 | less
>     ...
>   b_pages = 0x0,
>   b_page_array = {0x0, 0x0},
>   b_maps = 0xffff88627bebf118,
>   __b_map = {
>     bm_bn = 512,
>     bm_len = 128
>   },
>   b_map_count = 1,
>   b_io_length = 128,
>   b_pin_count = {
>     counter = 0
>   },
>   b_io_remaining = {
>     counter = 1
>   },
>   b_page_count = 16,
>   b_offset = 0,
>   b_error = 0,
>     ...
> 
> To avoid system crash, we can add the check of 'bp->b_pages' to
> xfs_inode_buf_verify(). If b_pages == NULL, we mark the buffer
> as -EFSCORRUPTED and the IO will not dispatched.
> 
> Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>
> Reviewed-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index c667c63f2..5a485c51f 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -45,6 +45,17 @@ xfs_inode_buf_verify(
>  	int		i;
>  	int		ni;
>  
> +	/*
> +	 * Don't crash and mark buffer EFSCORRUPTED when b_pages is NULL
> +	 */
> +	if (!bp->b_pages) {
> +		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> +		xfs_alert(mp,
> +			"xfs_buf(%p) b_pages corruption detected at %pS\n",
> +			bp, __return_address);
> +		return;
> +	}

This seems fairly ad hoc.

I think we need a better idea of how we got here; why should inode buffers
be uniquely impacted (or defensively protected?)  Can you reproduce this
using virtual devices so the test can be scripted?

-Eric
