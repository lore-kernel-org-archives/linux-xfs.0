Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753762AbdFMQ3g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Jun 2017 12:29:36 -0400
Date: Tue, 13 Jun 2017 12:29:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170613162934.GC3259@bfoster.bfoster>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609234408.GE17542@dastard>
 <CALoZfD76r2ohmn=6CpPJ4DKrYVxNkP9LWmzDGm8dZRVZgBcgQA@mail.gmail.com>
 <20170612235002.GF17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170612235002.GF17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Sweet Tea Dorminy <sweettea@permabit.com>, linux-xfs@vger.kernel.org

On Tue, Jun 13, 2017 at 09:50:02AM +1000, Dave Chinner wrote:
> On Fri, Jun 09, 2017 at 10:06:26PM -0400, Sweet Tea Dorminy wrote:
> > >What is the xfs_info for this filesystem?
> >        meta-data=/dev/mapper/tracer-vdo0 isize=256    agcount=4,
> >        agsize=5242880 blks
> >                 =                       sectsz=512   attr=2, projid32bit=0
> >        data     =                       bsize=1024   blocks=20971520,
> >        imaxpct=25
> >                 =                       sunit=0      swidth=0 blks
> >        naming   =version 2              bsize=4096   ascii-ci=0
> >        log      =internal               bsize=1024   blocks=10240, version=2
> >                 =                       sectsz=512   sunit=0 blks,
> >        lazy-count=1
> >        realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > > What granularity are these A and B regions (sectors or larger)?
> > A is 1k, B is 3k.
> > 
> > >Are you running on some kind of special block device that reproduces this?
> > It's a device we are developing,
> > asynchronous, which we believe obeys FLUSH and FUA correctly but may
> > have missed some case;
> 
> So Occam's Razor applies here....
> 

This was my inclination as well. It may very well be that this block
device is broken in some way, but at the same time some (hacky)
experimentation suggests we are susceptible to the problem outlined
previously:

- Log tail is pinned and remains so long enough to push the head behind
  the tail.
- Once the log fills, suppose the gap from the head to tail is smaller
  than (logbsize * logbufs). Since the tail is pinned, the tail_lsn
  referenced by the last record successfully written to the log points
  into this gap.
- The tail unpins and several async iclog flushes occur. These all
  partially fail and happen to splatter garbage into the log (similar to
  the failure characteristic described in this thread). As a result, the
  filesystem shuts down on log I/O completion.
- Log recovery runs on the subsequent mount, correctly identifies the
  range of the log that contains garbage and walks back to the last
  successfully written record in the log.

Under normal circumstances, the log tail is not far behind the head,
this "previous tail" lsn points to log data that is still valid and
everything just works. Because the log was pinned, however, the tail_lsn
of that last record points into the area that the failed log flush
splattered garbage data. This essentially results in log record checksum
mismatches and/or worse.

I won't say I've been able to manufacture this exactly, but I think I
can emulate it well enough to demonstrate the problem by pinning the
log, intentionally dumping bad data to the log immediately followed by
shutting down the fs.

Note that this is not reproducible on default 4k fsb configs because log
reservations seem large enough to consistently leave a head->tail gap
larger than the 256k used by the log buffers. This can be reproduced on
such fs' if the logbsize is increased, however. This is also
reproducible on 1k fsb fs' with default logbsize because log
reservations are small enough to leave a sub-200k gap when the head
pushes behind the tail. In summary, this probably requires a combination
of a heavily loaded fs to push the log head behind the tail, a
non-default fsb and/or logbsize configuration, fairly strange failure
characteristics of the underlying device (to write parts of the log bufs
successfully and not others), and perhaps just some bad luck for N log
buffers to be flushed at the same time and fail before the fs ultimately
shuts down. Other than that, I think it's possible. ;)

ISTM that we need something that prevents an overwrite of the tail lsn
last written to the log. That might be a bit tricky because we can't
just push the ail before the associated overwrite, but rather must do
something like make sure the prior log buffer write to the one that
overwrites the tail is serialized against an ail push that moves the
tail lsn forward. :/ Thoughts?

Brian

> > we
> > encountered this issue when testing an XFS filesystem on it, and other
> > filesystems appear to work fine (although obviously we could have
> > merely gotten lucky).
> 
> XFS has quite sophisticated async IO dispatch and ordering
> mechanisms compared to other filesystems and so frequently exposes
> problems in the underlying storage layers that other filesystems
> don't exercise.
> 
> > Currently, when a flush returns from the device,
> > we guarantee the data from all bios completed before the flush was
> > issued is stably on disk;
> 
> Yup, that's according to
> Documentation/block/writeback_cache_control.txt, however....
> 
> > when a write+FUA bio returns from the
> > device, the data in that bio (only) is guaranteed to be stable on disk. The
> > device may, however, commit sequentially issued write+fua bios to disk in an
> > arbitrary order.
> 
> .... XFS issues log writes with REQ_PREFLUSH|REQ_FUA. This means
> sequentially issued log writes have clearly specified ordering
> constraints. i.e. the preflush completion order requirements means
> that the block device must commit preflush+write+fua bios to stable
> storage in the exact order they were issued by the filesystem....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
