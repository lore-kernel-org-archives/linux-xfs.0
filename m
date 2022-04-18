Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC55C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 08:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiDRIWS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 04:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiDRIWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 04:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAFE5167D8
        for <linux-xfs@vger.kernel.org>; Mon, 18 Apr 2022 01:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650269978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbSlwIMBsmUQ2btaZklk9txorHfyUp9hbUvmVQpF0EI=;
        b=c0Gg5X/mcjo5gFcE2QY0rNPgPgJChzfjMSHTKGhrDb46RkZKtVbIMh48aORcOVCMmGe9nX
        ROHc295XGHw+kz1v1yrDgHZgG5fYtn4JfjTGOGHjKWhynHZfhPuZ1Q/I/f9DZ+Ijbz8NBx
        h5pvldHE6sMZw+5K6ZIglyy0Ui8pU1o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-UmfjE_gIMMiENiNezl8JNw-1; Mon, 18 Apr 2022 04:19:27 -0400
X-MC-Unique: UmfjE_gIMMiENiNezl8JNw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1B8C1C05AA6;
        Mon, 18 Apr 2022 08:19:26 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FC417C28;
        Mon, 18 Apr 2022 08:19:14 +0000 (UTC)
Date:   Mon, 18 Apr 2022 16:19:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <Yl0e/YBPGydwVAE7@T590>
References: <20220415034703.2081695-1-ming.lei@redhat.com>
 <20220415051844.GA22762@lst.de>
 <YllQVT6n472eUB7+@T590>
 <20220416054913.GA7405@lst.de>
 <YlqGZ7W9rg0eNt9A@T590>
 <20220418051234.GA3559@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220418051234.GA3559@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 18, 2022 at 07:12:34AM +0200, Christoph Hellwig wrote:
> On Sat, Apr 16, 2022 at 05:03:35PM +0800, Ming Lei wrote:
> > > Yes.  But not doing this automatically also means you keep easily
> > > forgetting callsites.  For example iomap still does not flush the plug
> > > in your patch.
> > 
> > It is reasonable for flush user(usually submission) to be responsible
> > for finishing/flushing plug.
> 
> Well, I very much disagree here.  blk_flush_plug is not a publіc,
> exported API, and that is for a reason.  A bio submission interface
> that requires flushing the plug to be useful is rather broken.

But there isn't any such users from module now. Maybe never, since sync
polled dio becomes legacy after io_uring is invented.

Do we have such potential use case in which explicit flush plug is
needed except for polled io in __blkdev_direct_IO_simple() and swap_readpage()?

If there is, I am happy to add one flag for bypassing plug in blk core
code.

> 
> > iomap is one good example to show this point, since it does flush the plug
> > before call bio_poll(), see __iomap_dio_rw().
> 
> iomap does not do a manual plug flush anywhere.
> 
> iomap does finish the plug before polling, which makes sense.
> 
> Now of course __blkdev_direct_IO_simple doesn't even use a plug
> to start with, so I'm wondering what plug this patch even tries
> to flush?
 
At least blkdev_write_iter(), and __swap_writepage() might call
into ->direct_IO with one plug too.

Not mention loop driver can call into ->direct_IO directly, and we
should have applied plug for batching submission in loop_process_work().


Thanks,
Ming

