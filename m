Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751596AbdFIRay (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jun 2017 13:30:54 -0400
Date: Fri, 9 Jun 2017 13:30:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170609173049.GC10685@bfoster.bfoster>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
 <20170609123829.GA10685@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170609123829.GA10685@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2017 at 08:38:32AM -0400, Brian Foster wrote:
> On Thu, Jun 08, 2017 at 11:42:11AM -0400, Sweet Tea Dorminy wrote:
> > Greetings;
> > 
> > When using XFS with a 1k block size atop our device, we regularly get
> > "log record CRC mismatch"es when mounting XFS after a crash, and we
> > are attempting to understand why. We are using RHEL7.3 with its kernel
> > 3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.
> > 
> > Tracing indicates the following situation occurs:
> >        Some pair of consecutive locations contains data A1 and B1, respectively.
> >        The XFS journal issues new writes to those locations,
> > containing data A2 and B2.
> >        The write of B' finishes, but A' is still outstanding at the
> > time of the crash.
> >        Crash occurs. The data on disk is A1 and B2, respectively.
> >        XFS fails to mount, complaining that the checksum mismatches.
> > 
> > Does XFS expect sequentially issued journal IO to be committed to disk
> > in the order of issuance due to the use of FUA?
> > 
> 
> Hmm, I don't believe there is any such sequential I/O ordering
> constraint, but the log is complex and I could be missing something. We
> do have higher level ordering rules in various places. For example,
> commit records are written to the in-core logs in order. It also looks
> like in-core log I/O completion takes explicit measures to process
> callbacks in order in the event that the associated I/Os do not complete
> in order. That tends to imply there is no explicit log I/O submission
> ordering in place.
> 
> Of course, that also implies that log recovery should be able to handle
> this situation just the same. I'm not quite sure what the expected log
> recovery behavior is off the top of my head, but my initial guess would
> be that the log LSN stamping could help us identify the valid part of
> the log during head/tail discovery.
> 

After digging a bit more into the log recovery code, this does actually
appear to be the case. The process of finding the head of the log at
mount time starts with a rough approximation of the head location based
on cycle numbers which are stamped into the first bytes of every sector
written to the log. From there, it searches a previous number of blocks
based on the maximum log buffer concurrency allowed by the fs to
determine whether any such "holes" exist in that range. If so, the head
is walked back to the first instance of such a "hole," effectively
working around out of order buffer completion at the time of a
filesystem crash.

This basically means that such ranges are not part of the active log to
be recovered and thus should not lead to CRC errors. So if the
granularity of the ranges noted above is something like the size of a
log buffer and resides towards the end of the active log, it seems more
likely this could be expected behavior and not the source of the
problem. If the granularity is something smaller (i.e., a sector) it
seems more likely something is wrong beneath the filesystem, or if the
range is larger but much farther behind the head, then the problem could
be something else entirely.

(When looking through some of this, I also noticed that log recovery
leaks memory for partial transactions. Thanks! :P).

Brian

> Anyways, I think more information is required to try and understand what
> is happening in your situation. What is the xfs_info for this
> filesystem? What granularity are these A and B regions (sectors or
> larger)? Are you running on some kind of special block device that
> reproduces this? Do you have a consistent reproducer and/or have you
> reproduced on an upstream kernel? Could you provide an xfs_metadump
> image of the filesystem that fails log recovery with CRC errors?
> 
> Brian
> 
> > Thanks!
> > 
> > Sweet Tea Dorminy
> > Permabit Technology Corporation
> > Cambridge, MA
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
