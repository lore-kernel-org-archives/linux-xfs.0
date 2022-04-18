Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE20BC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Apr 2022 05:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbiDRFPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Apr 2022 01:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiDRFPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Apr 2022 01:15:15 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFB0DF06;
        Sun, 17 Apr 2022 22:12:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B7A468AA6; Mon, 18 Apr 2022 07:12:34 +0200 (CEST)
Date:   Mon, 18 Apr 2022 07:12:34 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220418051234.GA3559@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com> <20220415051844.GA22762@lst.de> <YllQVT6n472eUB7+@T590> <20220416054913.GA7405@lst.de> <YlqGZ7W9rg0eNt9A@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YlqGZ7W9rg0eNt9A@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 16, 2022 at 05:03:35PM +0800, Ming Lei wrote:
> > Yes.  But not doing this automatically also means you keep easily
> > forgetting callsites.  For example iomap still does not flush the plug
> > in your patch.
> 
> It is reasonable for flush user(usually submission) to be responsible
> for finishing/flushing plug.

Well, I very much disagree here.  blk_flush_plug is not a publіc,
exported API, and that is for a reason.  A bio submission interface
that requires flushing the plug to be useful is rather broken.

> iomap is one good example to show this point, since it does flush the plug
> before call bio_poll(), see __iomap_dio_rw().

iomap does not do a manual plug flush anywhere.

iomap does finish the plug before polling, which makes sense.

Now of course __blkdev_direct_IO_simple doesn't even use a plug
to start with, so I'm wondering what plug this patch even tries
to flush?
