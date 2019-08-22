Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19F8C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 10:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B65206BB
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 10:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbfHVKUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 06:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfHVKUL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 06:20:11 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FAFA3082A6C;
        Thu, 22 Aug 2019 10:20:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 46B1460BF3;
        Thu, 22 Aug 2019 10:20:04 +0000 (UTC)
Date:   Thu, 22 Aug 2019 18:20:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Ming Lei <tom.leiming@gmail.com>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822101958.GA9632@ming.t460p>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
 <20190822044905.GU1119@dread.disaster.area>
 <20190822080852.GC31346@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822080852.GC31346@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 22 Aug 2019 10:20:11 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 01:08:52AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2019 at 02:49:05PM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2019 at 10:50:02AM +0800, Ming Lei wrote:
> > > It isn't correct to blk_rq_aligned() here because 'len' has to be logical block
> > > size aligned, instead of DMA aligned only.
> 
> Even if len would have to be a multiple of the sector size, that doesn't
> mean calling blk_rq_aligned would be incorrect, just possibly not
> catching all issues.

In theory, fs bio shouldn't care any DMA limits, which should have been done
on splitted bio for doing IO to device.

Also .dma_alignment isn't considered in blk_stack_limits(), so in case
of DM, MD or other stacking drivers, fs code won't know the accurate
.dma_alignment of underlying queues at all, and the stacking driver's
queue dma alignment is still 512.

Also suppose the check is added, I am a bit curious how fs code handles the
failure, so could you explain a bit about the failure handling?

Thanks, 
Ming
