Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:52717 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbeIUGJt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Sep 2018 02:09:49 -0400
Date: Fri, 21 Sep 2018 10:23:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange behavior with log IO fake-completions
Message-ID: <20180921002336.GO27618@dastard>
References: <CA+1E3r+crZ6suDtTheOysm_dzZ2FeU=z4R-aQQw7etk1yuxOLQ@mail.gmail.com>
 <20180910235827.GD5631@dastard>
 <CA+1E3r+Lggw9JJymdhoyzkqQfqGETZE=R=WG09s7FOhY3Snb5g@mail.gmail.com>
 <20180912004259.GJ5631@dastard>
 <CA+1E3r+gd57nOv=S0gjrbU8df2qXa67njPP=KK1oPqLmsO5thQ@mail.gmail.com>
 <20180917025601.GE16550@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917025601.GE16550@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joshi <joshiiitr@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 12:56:01PM +1000, Dave Chinner wrote:
> On Fri, Sep 14, 2018 at 05:21:43PM +0530, Joshi wrote:
> > > Now, your other "unexpected" result - lets use affinity to confine
> > > everything to one CPU:
> > >
> > > fsync proc              CIL             IO-complete     log
> > > xfs_log_force_lsn
> > >   <wait for CIL>
> > >                         xlog_write()
> > >                         <queue to log>
> > >                         wake CIL waiters
> > >                                                         xlog_iodone()
> > >                                                         wake iclogbug waiters
> > > log force done
> > >
> > > Note the difference? The log work can't start until the CIL work has
> > > completed because it's constrained to the same CPU, so it doesn't
> > > cause any contention with the finalising of the CIL push and waking
> > > waiters.
> > 
> > "Log work can't start" part does not sound very good either. It needed
> > to be done anyway before task waiting for fsync is woken.
> 
> I'm beginning to think you don't really understand how logging in
> XFS works.  If you want to improve the logging subsystem, it would
> be a good idea for you to read and understand this document so you
> have some idea of how the data that is written to the log gets
> there and what happens to it after it's in the log.
> 
> Documentation/filesystems/xfs-delayed-logging-design.txt

It occurred to me yesterday that looking at the journal in a
different way might help explain how it all works.

Instead of looking at it as an IO engine, think of how an
out-of-order CPU is designed to be made up of multiple stages in a
pipeline - each stage does a small piece of work that it passes on
to the next stage to process. Individual operation progresses serially
through the pipeline, but, each stage of the pipeline can be
operating on a different operation. Hence we can have multiple
operations in flight at once, and the operations can also be run
out of order as dynamical stage completion scheduling dictates.
However, from a high level everything appears to complete in order
because of re-ordering stages put everythign in order once the
indiivdual operations have been executed.

Similarly, the XFS journalling subsystem is an out of order,
multi-stage pipeline with a post-IO re-ordering stage to ensure the
end result is that individual operations always appear to complete
in order.  Indeed, what ends up on disk in the journal is not in
order, so one of the things that log recovery does is rebuild the
state necessarily to reorder operations correctly before replay so
that, again, it appears like everything occurred in the order that
the transactions were committed to the journal.

So perhaps looking at it as a multi-stage pipeline might also help
explain why fake-completion changes the behaviour in unpredictable
ways. i.e. it basically chops out stages of the pipeline, changing
the length of the pipeline and the order in which stages of the
pipleine are executed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
