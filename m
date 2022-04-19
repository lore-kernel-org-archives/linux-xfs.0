Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837D2C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 08:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349882AbiDSISx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 04:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349957AbiDSISR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 04:18:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6335E2AC49;
        Tue, 19 Apr 2022 01:15:24 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D071868D06; Tue, 19 Apr 2022 10:15:18 +0200 (CEST)
Date:   Tue, 19 Apr 2022 10:15:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: avoid io timeout in case of sync polled dio
Message-ID: <20220419081517.GA6427@lst.de>
References: <20220415034703.2081695-1-ming.lei@redhat.com> <20220415051844.GA22762@lst.de> <YllQVT6n472eUB7+@T590> <20220416054913.GA7405@lst.de> <YlqGZ7W9rg0eNt9A@T590> <20220418051234.GA3559@lst.de> <Yl0e/YBPGydwVAE7@T590> <20220419053924.GA31720@lst.de> <Yl5pDrgglwv00caD@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl5pDrgglwv00caD@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 03:47:26PM +0800, Ming Lei wrote:
> I agree to remove it because it is legacy poll interface, and very likely
> no one use it since the problem to be addressed can easily be exposed by
> sync polled dio sanity test or 'blktests block/007'.
> 
> I'd suggest to switch sync polled dio into non-polled silently, just with
> logging sort of 'sync polled io is obsolete, please use io_uring for io
> polling', or any other idea?

We've carefully define RWF_HIPRI to just be a hint.  So I don't think
logging an error would be all that useful.
