Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62115 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752643AbdFMWQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jun 2017 18:16:51 -0400
Date: Wed, 14 Jun 2017 08:16:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170613221647.GG17542@dastard>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard>
 <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
 <20170612235002.GF17542@dastard>
 <CALoZfD4RXJUusr7-r8COsUY+8_D6z68LbCRkp+9VM1E2tUV1UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALoZfD4RXJUusr7-r8COsUY+8_D6z68LbCRkp+9VM1E2tUV1UA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2017 at 10:14:10AM -0400, Sweet Tea Dorminy wrote:
> Thank you! I'm glad that we've established it's a mismatch between our
> device's implementation and XFS expectations.
> 
> >.... XFS issues log writes with REQ_PREFLUSH|REQ_FUA. This means
> >sequentially issued log writes have clearly specified ordering
> >constraints. i.e. the preflush completion order requirements means
> >that the block device must commit preflush+write+fua bios to stable
> >storage in the exact order they were issued by the filesystem....
> 
> That is certainly what REQ_BARRIER did back in the day. But when
> REQ_BARRIER was replaced with separate REQ_FUA and REQ_FLUSH
> flags, and barrier.txt got replaced with writeback_cache_control.txt,
> the documentation seemed to imply the ordering requirement on *issued*
> IO had gone away (but maybe I'm missing something).

Yes, that's my understanding, too, but I also thought that multiple
outstanding flushes are ordered by the block layer. i.e. flushes can
be reordered against other operations, but not other flushes.  I
could very well be wrong, but flush-to-flush ordering was what I
thought the ordered pending flush list for PREFLUSH requests in
blk_flush_complete_seq() did.

Like I said, Christoph is the expert here - he'll correct me if I'm
wrong.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
