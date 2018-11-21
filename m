Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387923AbeKVKTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 05:19:31 -0500
Date: Wed, 21 Nov 2018 15:42:53 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3] xfs: enums don't work with __print_symbolic
Message-ID: <20181121234253.GU6792@magnolia>
References: <20181121225958.30947-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121225958.30947-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 22, 2018 at 09:59:55AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> When trying to read traces from fsx failurs, I kept coming across
> fields in the traces that had no output what-so-ever. The common
> theme was that they all were tables that were parsed by
> __print_symbolic() and the value definitions were enums.
> 
> Unfortunately, __print_symbolic() does some crazy stuff involving
> stringification of the table that is passed to it, which means
> the enums are turned into strings and so their never get treated as
> enums after pre-processing. The result is a format string that looks
> like:
> 
> # cat /sys/kernel/debug/tracing/events/xfs/xfs_iomap_alloc/format
> .....
> print fmt: ..... __print_symbolic(REC->type, { XFS_IO_INVALID, "invalid" }, { XFS_IO_DELALLOC, "delalloc" }, { XFS_IO_UNWRITTEN, "unwritten" }, { XFS_IO_OVERWRITE, "overwrite" }, { XFS_IO_COW, "CoW" }, { XFS_IO_HOLE, "hole" }), ....
> #
> 
> And, well, XFS_IO_OVERWRITE is a string, not an integer value of 3.
> Hence __print_symbolic never prints out the correct value.
> 
> The way to fix this is to turn all the enums into defined macros,
> that way the preprocessor still substitutes the value for the
> stringified table as the it does string matches. The result is:
> 
> __print_symbolic(REC->type, { 0, "hole" }, { 1, "delalloc" }, { 2, "unwritten" }, { 3, "overwrite" }, { 4, "CoW" })
> 
> And the trace events now print the type correctly in the trace.
> 
> This series fixes the cases I noticed by removing the various enums
> that end up in trace format tables.

According to the documentation provided in
samples/trace_events/trace-events-sample.h, you're supposed to wrap all
the enum members in the trace header file so that they're encoded in the
trace output:

TRACE_DEFINE_ENUM(XFS_IO_HOLE);
TRACE_DEFINE_ENUM(XFS_IO_DELALLOC);
TRACE_DEFINE_ENUM(XFS_IO_UNWRITTEN);
TRACE_DEFINE_ENUM(XFS_IO_OVERWRITE);
TRACE_DEFINE_ENUM(XFS_IO_COW);

And then the trace output is decoded properly:

$ grep fmt /sys/kernel/debug/tracing/events/xfs/xfs_iomap_alloc/format
print fmt: "dev %d:%d ino 0x%llx size 0x%llx offset 0x%llx count %zd
  type %s startoff 0x%llx startblock %lld blockcount 0x%llx", ((unsigned
  int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) -
  1))), REC->ino, REC->size, REC->offset, REC->count,

  __print_symbolic(REC->type, { 0, "hole" }, { 1, "delalloc" },
  { 2, "unwritten" }, { 3, "overwrite" }, { 4, "CoW" }),

  REC->startoff, (int64_t)REC->startblock, REC->blockcount

(I added the line wrapping and extra newlines to make it obvious).

I'd rather add that weird and unexpectedly documented kludge to
xfs_trace.h than go changing things treewide.  Frankly, why not just
move XFS_IO_TYPES to xfs_trace.h?

(Maybe I'll do that and add enum prettyprinting back to the scrub
tracepoints.)

--D

((Seriously, why are key ftrace calls documented only in the sample
code??))

> 
> Cheers,
> 
> Dave.
> 
