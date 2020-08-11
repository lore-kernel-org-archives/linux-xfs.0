Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB2DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 22:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C211F20786
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 22:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgHKWJe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Aug 2020 18:09:34 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42610 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgHKWJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Aug 2020 18:09:34 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8619BD5BAC7;
        Wed, 12 Aug 2020 08:09:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k5cSX-0007sF-DO; Wed, 12 Aug 2020 08:09:29 +1000
Date:   Wed, 12 Aug 2020 08:09:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, bugzilla-daemon@bugzilla.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200811220929.GQ2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
 <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
 <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
 <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Hj0MKOKctUptJfUDAO0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 11, 2020 at 04:56:37PM -0400, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > So it seems to me like the file state is consistent, at least after the
> > run, and that this seems more likely to be a fio issue with short
> > read handling.
> 
> Any idea why there was a short read, though?

Yes. See:

https://lore.kernel.org/linux-xfs/20200807024211.GG2114@dread.disaster.area/T/#maf3bd9325fb3ac0773089ca58609a2cea0386ddf

It's a race between the readahead io completion marking pages
uptodate and unlocking them, and the io_uring worker function
getting woken on the first page being unlocked and running the
buffered read before the entire readahead IO completion has unlocked
all the pages in the IO.

Basically, io_uring is re-running the IOCB_NOWAIT|IOCB_WAITQ IO when
there are still pages locked under IO. This will happen much more
frequently the larger the buffered read (these are only 64kB) and
the readahead windows are opened.

Essentially, the io_uring buffered read needs to wait until _all_
pages in the IO are marked up to date and unlocked, not just the
first one. And not just the last one, either - readahead can be
broken into multiple bios (because it spans extents) and there is no
guarantee of order of completion of the readahead bios given by the
readahead code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
