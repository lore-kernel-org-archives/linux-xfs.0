Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662D2C3A59D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 10:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434D1233FD
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 10:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbfHVKSN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 06:18:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33056 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731865AbfHVKSN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 06:18:13 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F115E43DB5C;
        Thu, 22 Aug 2019 20:18:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0k9P-0008Vs-0n; Thu, 22 Aug 2019 20:17:03 +1000
Date:   Thu, 22 Aug 2019 20:17:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822101702.GZ1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
 <20190822003745.GS1119@dread.disaster.area>
 <20190822080312.GB31346@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822080312.GB31346@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=bebQB_2F4QBTV_OL05sA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 01:03:12AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2019 at 10:37:45AM +1000, Dave Chinner wrote:
> > > I know Jens disagree, but with the amount of bugs we've been hitting
> > > thangs to slub (and I'm pretty sure we have a more hiding outside of
> > > XFS) I think we need to add the blk_rq_aligned check to bio_add_page.
> > 
> > ... I'm not prepared to fight this battle to get this initial fix
> > into the code. Get the fix merged, then we can 
> 
> Well, the initial fix are the first two patches.  This patch really
> just adds a safety belt.  I'll happily take over the effort to get
> sensible checks in the block code if you give me a couple weeks,
> in the meantime I'd prefer if we could skip this third patch for now.

Fine by me. I'll just repost the current versions of the first two
patches (now three) in the morning.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
