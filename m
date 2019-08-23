Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816A6C3A5A1
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57227233A0
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732687AbfHWBTd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:19:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732598AbfHWBTd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 21:19:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F00A307D868;
        Fri, 23 Aug 2019 01:19:33 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 955985D9E5;
        Fri, 23 Aug 2019 01:19:27 +0000 (UTC)
Date:   Fri, 23 Aug 2019 09:19:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Ming Lei <tom.leiming@gmail.com>,
        "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190823011921.GB16810@ming.t460p>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <CACVXFVN93h7QrFvZNVQQwYZg_n0wGXwn=XZztMJrNbdjzzSpKQ@mail.gmail.com>
 <20190822044905.GU1119@dread.disaster.area>
 <20190822080852.GC31346@infradead.org>
 <20190822101958.GA9632@ming.t460p>
 <20190823001440.GA32209@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823001440.GA32209@infradead.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 23 Aug 2019 01:19:33 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 05:14:40PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2019 at 06:20:00PM +0800, Ming Lei wrote:
> > In theory, fs bio shouldn't care any DMA limits, which should have been done
> > on splitted bio for doing IO to device.
> > 
> > Also .dma_alignment isn't considered in blk_stack_limits(), so in case
> > of DM, MD or other stacking drivers, fs code won't know the accurate
> > .dma_alignment of underlying queues at all, and the stacking driver's
> > queue dma alignment is still 512.
> 
> Trying to handling alignment lower down means bounce buffering, so I
> don't think trying to hndle it is a sane idea.  I'd be much happier to
> say non-passthrough bios need 512 byte alignment, period.  That should
> cover all the sane cases and we can easily check for it.  The occasional
> device that would need larger alignment just needs to deal with it.

Yeah, I agree we need to avoid bounce buffer, and it is fine to check
512 simply.

Also we should consider the interface/protocol between fs and block layer,
it could make both sides happy to always align offset & length with logical
block size. And that is reasonable for fs bio.


Thanks,
Ming
