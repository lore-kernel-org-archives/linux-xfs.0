Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932333AbdJRMF2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Oct 2017 08:05:28 -0400
Date: Wed, 18 Oct 2017 08:05:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug Report]: generic/085 trigger a XFS panic on kernel 4.14-rc2
Message-ID: <20171018120526.GA4362@bfoster.bfoster>
References: <20170930032857.GQ21475@dhcp12-143.nay.redhat.com>
 <20171002135618.GA32279@bfoster.bfoster>
 <20171013132935.GE21475@dhcp12-143.nay.redhat.com>
 <20171013181605.GA46787@bfoster.bfoster>
 <20171013195334.GB46787@bfoster.bfoster>
 <20171014223447.GC15067@dastard>
 <20171016100904.GA58994@bfoster.bfoster>
 <20171016191147.GC4703@magnolia>
 <20171016222604.GJ15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171016222604.GJ15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Oct 17, 2017 at 09:26:04AM +1100, Dave Chinner wrote:
...
> 
> For the cases I came across. I haven't solved the root problem in
> mkfs yet, so this could still occur. FYI, there was some interesting
> and unexpected interactions with log stripe units that triggered it,
> and I note the above filesystem has a log stripe unit set. So it's
> likely I haven't solved all the issues yet.
> 

Ok.

> The problem most likely is based in confusion around these
> definitions for log size (in xfs_fs.h):
> 
> /*
>  * Minimum and maximum sizes need for growth checks.
>  *
>  * Block counts are in units of filesystem blocks, not basic blocks.
>  */
> #define XFS_MIN_AG_BLOCKS       64
> #define XFS_MIN_LOG_BLOCKS      512ULL
> #define XFS_MAX_LOG_BLOCKS      (1024 * 1024ULL)
> #define XFS_MIN_LOG_BYTES       (10 * 1024 * 1024ULL)
> 
> The log size limits need to be rationalised and moved to
> xfs_log_format.h, and mkfs needs to be made to enforce them
> consistently regardless of block size.
> 
> > > I have a couple patches laying around that fix up the
> > > calculation and add some error checks to prevent the kernel crash, but
> > > this has me wondering whether we should fail to mount the fs due to the
> > > geometry. Thoughts?
> 
> Unfortunately, I don't think that's an option - there will be
> filesysetms out there that the geometry checks fail and refuse to
> mount with a new kernel, despite it working without problems for
> years....
> 

That's kind of what I was afraid of. :P

> > Failing the mount sounds ok to me, but do we have any other options to
> > deal with undersized logs?  Is there a scenario where we /could/ mount
> > an undersized log and not blow up, either immediately or later on?
> 
> In this case, I think the problem is the 2MB window we consider to
> be the worst case "partially written" window at the head of the log.
> i.e.  8x256k log buffers.  We assume that this is always the worst
> case, because the previous mount could have been using that.
> 
> This assumption has always been used for simplicity. i.e. worst case
> is assumed in place of detecting the previous mount's log buffer
> size from the log records written to the log. If we read the log and
> determine the maximum record size, we know exactly what the worst
> case dirty region is going to be.
> 

So from doing a quick, high-level rundown of the log recovery
algorithm...

- We read the blocks at the start and end of the physical log to
  determine the current cycle. We then essentially bisect the log to try
  and locate the last block in the current cycle (or more specifically,
  the first block in the previous cycle that has not yet been
  overwritten). IOW, this is where the prospective log head appears to
  be based on an initial cycle value bisection/estimation.
- From there, we scan backwards XLOG_TOTAL_REC_SHIFT() blocks (which is
  the 2MB window referenced above) looking for earlier instances of the
  "previous" cycle. I.e., this is essentially a finer tuned cycle-based
  search for the appropriate head, using the maximum possible partial or
  out of order write window based on the max iclog count/size. (This is
  where we explode.)
- Next, we potentially fine tune the head again based on the last valid
  log record header in the log. This uses XLOG_REC_SHIFT(), which is the
  max size of a single record (256k) and so I don't think should post a
  risk.

It isn't until this step that we actually have a reference to
potentially valid log record content.

- We return the head block and xlog_find_tail() seeks backwards for the
  last valid log record header, using it to look up the tail block.
- We check for an unmount record to determine whether the log is clean.
- If not, we move on to the higher level head/tail validation that has
  been added more recently (torn write detection, tail overwrite
  detection).
  
At this point, it looks like scanning associated with the higher-level
verification is mostly based on max iclog count (i.e., scan windows are
based on a certain number of record headers within the head/tail) rather
than a fixed size window such as the 2MB window used during the cycle
search.

> I think the kernel side defense needs to be some combination of these
> three things:
> 
> 	1. check what the log record sizes we see during the tail
> 	search and trim the "dirty head" window to suit.
> 

The reason I wrote up the above is because I'm not quite following what
you mean here. The first few steps noted above that use the 2MB window
don't actually have log record data to reference, because this is the
early part of the process of locating a valid record.

Am I missing something or just misreading..? Could you elaborate on
where in the above sequence we could tighten up a fixed 2MB window..?

> 	2. If the dirty window is larger than the log, then trim
> 	it to search the entire log rather than overrun into
> 	negative block offsets like we do now.
> 

Otherwise, this is basically the fix I have so far and I think it covers
the immediate underflow problem.

> 	3. in the case of tiny logs, we shouldn't even be allowing
> 	users to mount with logbsize * logbufs > log size / 2.  Then
> 	we can size the initial dirty window appropiately based on
> 	the log size....
> 

Ok, I'll look into this. Should this be a generic restriction or only
associated with logs under a particular size threshold? For example, I
can currently create a small, 512b blocksize fs with a 4800 block
(~2.3MB) log and mount it with '-o logbufs=8,logbsize=256k' without a
problem.

Either way, what is the (log size / 2) metric based on? Thanks.

Brian

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
