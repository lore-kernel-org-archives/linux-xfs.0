Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32378C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 07:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349553AbiDSHu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 03:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349563AbiDSHuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 03:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D24F2D1F5
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 00:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650354462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1rXTh1w/IO5tYBBT8DlyE4nNiMEK9W527S7i8QOYhdI=;
        b=XRwxh3siZefJRJiuVB/ZXTxxJXCwZt6nfmsXpsmERp13QftnwoWLt69b/9Ug1SdEvfpACJ
        rx5HHrqv9L+GPEPox2GtVLjHvOTHVbxEyz0XIcR0bWA9LljVcUB9O40MMRD7JthwksfVtO
        rAQj/cvweJN85oH4+vmFbZ3wAtEPB9c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-wuuHv3n0M_yVxlL9GR50Jw-1; Tue, 19 Apr 2022 03:47:36 -0400
X-MC-Unique: wuuHv3n0M_yVxlL9GR50Jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 224A238149A3;
        Tue, 19 Apr 2022 07:47:36 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C148940FF71A;
        Tue, 19 Apr 2022 07:47:31 +0000 (UTC)
Date:   Tue, 19 Apr 2022 15:47:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <Yl5pDrgglwv00caD@T590>
References: <20220415034703.2081695-1-ming.lei@redhat.com>
 <20220415051844.GA22762@lst.de>
 <YllQVT6n472eUB7+@T590>
 <20220416054913.GA7405@lst.de>
 <YlqGZ7W9rg0eNt9A@T590>
 <20220418051234.GA3559@lst.de>
 <Yl0e/YBPGydwVAE7@T590>
 <20220419053924.GA31720@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419053924.GA31720@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 07:39:24AM +0200, Christoph Hellwig wrote:
> On Mon, Apr 18, 2022 at 04:19:09PM +0800, Ming Lei wrote:
> > But there isn't any such users from module now. Maybe never, since sync
> > polled dio becomes legacy after io_uring is invented.
> 
> I thought about that a bit, but if we decided synchronous polled I/O
> is not in major user anymore (which I think) and we think it is enough
> of a burden to support (which I'm not sure of, but this patch points to)
> then it might be time to remove it.

I agree to remove it because it is legacy poll interface, and very likely
no one use it since the problem to be addressed can easily be exposed by
sync polled dio sanity test or 'blktests block/007'.

I'd suggest to switch sync polled dio into non-polled silently, just with
logging sort of 'sync polled io is obsolete, please use io_uring for io
polling', or any other idea?

> 
> > Do we have such potential use case in which explicit flush plug is
> > needed except for polled io in __blkdev_direct_IO_simple() and swap_readpage()?
> > 
> > If there is, I am happy to add one flag for bypassing plug in blk core
> > code.
> 
> I think the point is that we need to offer sensible APIs for I/O
> methods we want to support.
> 
> > > 
> > > > iomap is one good example to show this point, since it does flush the plug
> > > > before call bio_poll(), see __iomap_dio_rw().
> > > 
> > > iomap does not do a manual plug flush anywhere.
> > > 
> > > iomap does finish the plug before polling, which makes sense.
> > > 
> > > Now of course __blkdev_direct_IO_simple doesn't even use a plug
> > > to start with, so I'm wondering what plug this patch even tries
> > > to flush?
> >  
> > At least blkdev_write_iter(), and __swap_writepage() might call
> > into ->direct_IO with one plug too.
> > 
> > Not mention loop driver can call into ->direct_IO directly, and we
> > should have applied plug for batching submission in loop_process_work().
> 
> The loop driver still calls through the read/write iter method, and
> the swap code ->direct_IO path is not used for block devices (and
> completley broken right now, see the patch series from Neil).
> 
> But the loop driver is a good point, even for the iomap case as the
> blk_finish_plug would only flush the plug that is on-stack in
> __iomap_dio_rw, it would not help you with any plug holder by caller
> higher in the stack.

Right, good catch!


thanks,
Ming

