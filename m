Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:24857 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731067AbeKVN1s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Nov 2018 08:27:48 -0500
Date: Thu, 22 Nov 2018 13:29:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: enums don't work with __print_symbolic
Message-ID: <20181122022939.GU19305@dastard>
References: <20181121225958.30947-1-david@fromorbit.com>
 <20181121234253.GU6792@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121234253.GU6792@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 21, 2018 at 03:42:53PM -0800, Darrick J. Wong wrote:
> On Thu, Nov 22, 2018 at 09:59:55AM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > When trying to read traces from fsx failurs, I kept coming across
> > fields in the traces that had no output what-so-ever. The common
> > theme was that they all were tables that were parsed by
> > __print_symbolic() and the value definitions were enums.
> > 
> > Unfortunately, __print_symbolic() does some crazy stuff involving
> > stringification of the table that is passed to it, which means
> > the enums are turned into strings and so their never get treated as
> > enums after pre-processing. The result is a format string that looks
> > like:
> > 
> > # cat /sys/kernel/debug/tracing/events/xfs/xfs_iomap_alloc/format
> > .....
> > print fmt: ..... __print_symbolic(REC->type, { XFS_IO_INVALID, "invalid" }, { XFS_IO_DELALLOC, "delalloc" }, { XFS_IO_UNWRITTEN, "unwritten" }, { XFS_IO_OVERWRITE, "overwrite" }, { XFS_IO_COW, "CoW" }, { XFS_IO_HOLE, "hole" }), ....
> > #
> > 
> > And, well, XFS_IO_OVERWRITE is a string, not an integer value of 3.
> > Hence __print_symbolic never prints out the correct value.
> > 
> > The way to fix this is to turn all the enums into defined macros,
> > that way the preprocessor still substitutes the value for the
> > stringified table as the it does string matches. The result is:
> > 
> > __print_symbolic(REC->type, { 0, "hole" }, { 1, "delalloc" }, { 2, "unwritten" }, { 3, "overwrite" }, { 4, "CoW" })
> > 
> > And the trace events now print the type correctly in the trace.
> > 
> > This series fixes the cases I noticed by removing the various enums
> > that end up in trace format tables.
> 
> According to the documentation provided in
> samples/trace_events/trace-events-sample.h, you're supposed to wrap all
> the enum members in the trace header file so that they're encoded in the
> trace output:
> 
> TRACE_DEFINE_ENUM(XFS_IO_HOLE);
> TRACE_DEFINE_ENUM(XFS_IO_DELALLOC);
> TRACE_DEFINE_ENUM(XFS_IO_UNWRITTEN);
> TRACE_DEFINE_ENUM(XFS_IO_OVERWRITE);
> TRACE_DEFINE_ENUM(XFS_IO_COW);

That's horrible. Essentially, we have to declare all enums twice,
and they can't be in the same place?

> I'd rather add that weird and unexpectedly documented kludge to
> xfs_trace.h than go changing things treewide.  Frankly, why not just
> move XFS_IO_TYPES to xfs_trace.h?

Well, we originally put all these type arrays next to the place
where there are defined so it's easy to remind ourselves that
whenever we add a new enum/type we have to update the tracing output
array, too....

> ((Seriously, why are key ftrace calls documented only in the sample
> code??))

Code is all the docmentation you need, right? :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
