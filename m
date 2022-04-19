Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D65C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 05:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbiDSFmK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 01:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDSFmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 01:42:09 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B322527FF0;
        Mon, 18 Apr 2022 22:39:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4D68068AFE; Tue, 19 Apr 2022 07:39:24 +0200 (CEST)
Date:   Tue, 19 Apr 2022 07:39:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220419053924.GA31720@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com> <20220415051844.GA22762@lst.de> <YllQVT6n472eUB7+@T590> <20220416054913.GA7405@lst.de> <YlqGZ7W9rg0eNt9A@T590> <20220418051234.GA3559@lst.de> <Yl0e/YBPGydwVAE7@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl0e/YBPGydwVAE7@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 18, 2022 at 04:19:09PM +0800, Ming Lei wrote:
> But there isn't any such users from module now. Maybe never, since sync
> polled dio becomes legacy after io_uring is invented.

I thought about that a bit, but if we decided synchronous polled I/O
is not in major user anymore (which I think) and we think it is enough
of a burden to support (which I'm not sure of, but this patch points to)
then it might be time to remove it.

> Do we have such potential use case in which explicit flush plug is
> needed except for polled io in __blkdev_direct_IO_simple() and swap_readpage()?
> 
> If there is, I am happy to add one flag for bypassing plug in blk core
> code.

I think the point is that we need to offer sensible APIs for I/O
methods we want to support.

> > 
> > > iomap is one good example to show this point, since it does flush the plug
> > > before call bio_poll(), see __iomap_dio_rw().
> > 
> > iomap does not do a manual plug flush anywhere.
> > 
> > iomap does finish the plug before polling, which makes sense.
> > 
> > Now of course __blkdev_direct_IO_simple doesn't even use a plug
> > to start with, so I'm wondering what plug this patch even tries
> > to flush?
>  
> At least blkdev_write_iter(), and __swap_writepage() might call
> into ->direct_IO with one plug too.
> 
> Not mention loop driver can call into ->direct_IO directly, and we
> should have applied plug for batching submission in loop_process_work().

The loop driver still calls through the read/write iter method, and
the swap code ->direct_IO path is not used for block devices (and
completley broken right now, see the patch series from Neil).

But the loop driver is a good point, even for the iomap case as the
blk_finish_plug would only flush the plug that is on-stack in
__iomap_dio_rw, it would not help you with any plug holder by caller
higher in the stack.
