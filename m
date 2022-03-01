Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6CC4C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Mar 2022 03:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiCADLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Feb 2022 22:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiCADLh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Feb 2022 22:11:37 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2422647AC9
        for <linux-xfs@vger.kernel.org>; Mon, 28 Feb 2022 19:10:57 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5CF9710E0FD5;
        Tue,  1 Mar 2022 14:10:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nOsuc-00051j-N3; Tue, 01 Mar 2022 14:10:54 +1100
Date:   Tue, 1 Mar 2022 14:10:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 19/17] mkfs: increase default log size for new (aka
 bigtime) filesystems
Message-ID: <20220301031054.GU59715@dread.disaster.area>
References: <20220226213720.GQ59715@dread.disaster.area>
 <20220228232211.GA117732@magnolia>
 <20220301004249.GT59715@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301004249.GT59715@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=621d8ec0
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=UBWwm8E-oy0P-vv-LL4A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 11:42:49AM +1100, Dave Chinner wrote:
> On Mon, Feb 28, 2022 at 03:22:11PM -0800, Darrick J. Wong wrote:
> > On Sun, Feb 27, 2022 at 08:37:20AM +1100, Dave Chinner wrote:
> > > On Fri, Feb 25, 2022 at 06:54:50PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Recently, the upstream kernel maintainer has been taking a lot of heat on
> > > > account of writer threads encountering high latency when asking for log
> > > > grant space when the log is small.  The reported use case is a heavily
> > > > threaded indexing product logging trace information to a filesystem
> > > > ranging in size between 20 and 250GB.  The meetings that result from the
> > > > complaints about latency and stall warnings in dmesg both from this use
> > > > case and also a large well known cloud product are now consuming 25% of
> > > > the maintainer's weekly time and have been for months.
> > > 
> > > Is the transaction reservation space exhaustion caused by, as I
> > > pointed out in another thread yesterday, the unbound concurrency in
> > > IO completion?
> > 
> > No.  They're using synchronous directio writes to write trace data in 4k
> 
> synchronous as in O_(D)SYNC or as in "not using AIO"? Is is also
> append data, and is it one file per logging thread or multiple
> threads writing to a single file?
> 
> > chunks.  The number of files does not exceed the number of writer
> > threads, and the number of writer threads can be up to 10*NR_CPUS (~400
> > on the test system).  If I'm reading the iomap directio code correctly,
> > the writer threads block and do not issue more IO until the first IO
> > completes...
> 
> So, up to 400 threads concurrently issuing IO that does block
> allocation and performing unwritten extent conversion, so up to ~800
> concurrent running allocation related transactions at a time?

Let me put this a different way: optimal log size is determined by
workload transaction concurrency, not filesystem capacity.

I just did a quick check of the write reservation that unwritten
extent conversion uses, and it was 150kB on my test system. If there
are going to be 400 of these unwritten completions running at once,
then for them to not block on each other, there must be more than
60MB of free log space available at all times.

If we assume the AIL tail pushing is keeping up with incoming
changes, that means we are keeping 25% of the log space is free for
in-memory transaction reservations. That means for this IO
completion transaction workload, we need a log size of at least
240MB to ensure free log space keeps ahead of transaction
concurrency. So even for really small filesysetms, this workload
needs a large log size.

For default sizing, we use filesystem size as a proxy for
concurrency - the larger the filesystem, the more workload
concurrency it can support, so the more AGs and log space is
requires. We can't get this right for every single type of storage
or workload that is out there, and we've always known this.  This is
one of the reasons behind developing mkfs config file support.

That is, if you have an application that doesn't fit the
general case and has specific log size requirements, you can write
a mkfs recipe for it and ship that so that users don't need to know
the details, just mkfs using the specific config file for that
application. In this case, the workload specific mkfs config file
simply needs to have "logsize = 500MB" and it will work for all
installations regardless of the filesystem capacity it is running
on.

Hence I'm not sure that tying the default log size to "we have a
problematic workload where small filesystems need X concurrency" is
exactly the right way to proceed here. It's the messenger, but it
should not dictate a specific solution to a much more general
problem.

Instead, I think we should be looking at things like the rotational
flag on the storage device. If that's not set, we can substantially
increase the AG count and log size scaling rate because those
devices will support much more IO and transaction concurrency.

We should be looking at CPU count, and scaling log size and AG count
based on the number of CPUs. The more CPUs we have, the more likely
we are going to see large amounts of concurrency, and so AG count
and log size should be adjusted to suit.

These are generic scaling factors that will improve the situation
for the workload being described, as well as improve the situation
for any other workload that runs on hardware that has high
concurrency capability. We still use capacity as a proxy for
scalability, we just adjust the ramp up ratio based on the
capabilities of the system presented to us.

I know, this doesn't solve the crazy "start tiny, grow 1000x before
deploy" issues, but that's a separate problem that really needs to
be addressed with independent changes such as updating minimum log
and AG sizes to mitigate those sorts of growth issues.

> > > I also wonder if the right thing to do here is just set a minimum
> > > log size of 32MB? The worst of the long tail latencies are mitigated
> > > by this point, and so even small filesystems grown out to 200GB will
> > > have a log size that results in decent performance for this sort of
> > > workload.
> > 
> > Are you asking for a second patch where mkfs refuses to format a log
> > smaller than 32MB (e.g. 8GB with the x86 defaults)?  Or a second patch
> > that cranks the minimum log size up to 32MB, even if that leads to
> > absurd results (e.g. 66MB filesystems with 2 AGs and a 32MB log)?
> 
> I'm suggesting the latter.
> 
> Along with a refusal to make an XFS filesystem smaller than, say,
> 256MB, because allowing users to make tiny XFS filesystems seems to
> always just lead to future troubles.

When I say stuff like this, keep in mind that I'm trying to suggest
things that will stand for years, not just alleviate the immediate
concerns. Really small XFS filesystems are at the end of the scale
we really don't care about, so let's just stop with the make-beleive
that we'll support and optimise for them. Let's just set some new
limits that are appropriate for the sort of storage and minimum
sizes we actually see XFS used for.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
