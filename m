Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B5BC433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 10:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D54BA204FD
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 10:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A1Lf1K7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgIQKxf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 06:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgIQKxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 06:53:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A29DC061756
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 03:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=c0VMlAZUhQhDfQ4cwCsdV2zCuIH+pW80AStTpba5sDM=; b=A1Lf1K7zq47rzBZg8QkjbfGU2d
        ageW4eEL6EmturaviZpzbMZeSUvtwAJWo09rWxMzeLiZiKRLd0963+2xjvCJfYSgqRL/OMXYhl7Ax
        H7aYzUlLlNmi4qhxMQ7Ucoo6U47tgYKYEEAs26qUwClBCfObwUvemBF4W4Ze7DhUo1s2l3ZxIaq5G
        DEj3XZ1fYrn3unsDL+19bKPikHZv88N5kwYFZ1RFPL/1zkzdxL+yoT+hD0Zcsb+nh57ivBgHuWyMA
        neo5dcExvoZ0WZXWajcg9OXQQAt4VgWzehQBVaoYY2ZeWmbKuf9ddTgfzkEJPbJIuj7cwBFbPF8H6
        3dWXL4gg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIrXU-00025n-9U; Thu, 17 Sep 2020 10:53:20 +0000
Date:   Thu, 17 Sep 2020 11:53:20 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH] xfs: Set xfs_buf's b_ops member when zeroing
 bitmap/summary files
Message-ID: <20200917105320.GA7954@infradead.org>
References: <20200917094356.2858-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917094356.2858-1-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 03:13:56PM +0530, Chandan Babu R wrote:
> In xfs_growfs_rt(), we enlarge bitmap and summary files by allocating
> new blocks for both files. For each of the new blocks allocated, we
> allocate an xfs_buf, zero the payload, log the contents and commit the
> transaction. Hence these buffers will eventually find themselves
> appended to list at xfs_ail->ail_buf_list.
> 
> Later, xfs_growfs_rt() loops across all of the new blocks belonging to
> the bitmap inode to set the bitmap values to 1. In doing so, it
> allocates a new transaction and invokes the following sequence of
> functions,
>   - xfs_rtfree_range()
>     - xfs_rtmodify_range()
>       - xfs_rtbuf_get()
>         We pass '&xfs_rtbuf_ops' as the ops pointer to xfs_trans_read_buf().
>         - xfs_trans_read_buf()
> 	  We find the xfs_buf of interest in per-ag hash table, invoke
> 	  xfs_buf_reverify() which ends up assigning '&xfs_rtbuf_ops' to
> 	  xfs_buf->b_ops.
> 
> On the other hand, if xfs_growfs_rt_alloc() had allocated a few blocks
> for the bitmap inode and returned with an error, all the xfs_bufs
> corresponding to the new bitmap blocks that have been allocated would
> continue to be on xfs_ail->ail_buf_list list without ever having a
> non-NULL value assigned to their b_ops members. An AIL flush operation
> would then trigger the following warning message to be printed on the
> console,
> 
>   XFS (loop0): _xfs_buf_ioapply: no buf ops on daddr 0x58 len 8
>   00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   CPU: 3 PID: 449 Comm: xfsaild/loop0 Not tainted 5.8.0-rc4-chandan-00038-g4d8c2b9de9ab-dirty #37
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>   Call Trace:
>    dump_stack+0x57/0x70
>    _xfs_buf_ioapply+0x37c/0x3b0
>    ? xfs_rw_bdev+0x1e0/0x1e0
>    ? xfs_buf_delwri_submit_buffers+0xd4/0x210
>    __xfs_buf_submit+0x6d/0x1f0
>    xfs_buf_delwri_submit_buffers+0xd4/0x210
>    xfsaild+0x2c8/0x9e0
>    ? __switch_to_asm+0x42/0x70
>    ? xfs_trans_ail_cursor_first+0x80/0x80
>    kthread+0xfe/0x140
>    ? kthread_park+0x90/0x90
>    ret_from_fork+0x22/0x30
> 
> This message indicates that the xfs_buf had its b_ops member set to
> NULL.
> 
> This commit fixes the issue by assigning "&xfs_rtbuf_ops" to b_ops
> member of each of the xfs_bufs logged by xfs_growfs_rt_alloc().
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
