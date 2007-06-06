Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Jun 2007 10:18:20 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l56HIGWt008456
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 10:18:17 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l56HHq9r012920
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 10:17:52 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l56HICDM007023
	for <xfs@oss.sgi.com>; Wed, 6 Jun 2007 10:18:12 -0700
Message-ID: <4666EC56.9000606@agami.com>
Date: Wed, 06 Jun 2007 10:18:14 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: Reducing memory requirements for high extent xfs files
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com> <20070606013601.GR86004887@sgi.com>
In-Reply-To: <20070606013601.GR86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

David Chinner wrote:

> On Tue, Jun 05, 2007 at 03:23:50PM -0700, Michael Nishimoto wrote:
> > David Chinner wrote:
> > >On Wed, May 30, 2007 at 09:49:38AM -0700, Michael Nishimoto wrote:
> > > > Hello,
> > > >
> > > > Has anyone done any work or had thoughts on changes required
> > > > to reduce the total memory footprint of high extent xfs files?
> .....
> > >Yes, it could, but that's a pretty major overhaul of the extent
> > >interface which currently assumes everywhere that the entire
> > >extent tree is in core.
> > >
> > >Can you describe the problem you are seeing that leads you to
> > >ask this question? What's the problem you need to solve?
> >
> > I realize that this work won't be trivial which is why I asked if anyone
> > has thought about all relevant issues.
> >
> > When using NFS over XFS, slowly growing files (can be ascii log files)
> > tend to fragment quite a bit.
>
> Oh, that problem.
>
> The issue is that allocation beyond EOF (the normal way we prevent
> fragmentation in this case) gets truncated off on file close.
>
> Even NFS request is processed by doing:
>
>         open
>         write
>         close
>
> And so XFS truncates the allocation beyond EOF on close. Hence
> the next write requires a new allocation and that results in
> a non-contiguous file because the adjacent blocks have already
> been used....
>
Yes, we diagnosed this same issue.

>
> Options:
>
>         1 NFS server open file cache to avoid the close.
>         2 add detection to XFS to determine if the called is
>           an NFS thread and don't truncate on close.
>         3 use preallocation.
>         4 preallocation on the file once will result in the
>           XFS_DIFLAG_PREALLOC being set on the inode and it
>           won't truncate on close.
>         5 append only flag will work in the same way as the
>           prealloc flag w.r.t preventing truncation on close.
>         6 run xfs_fsr
>
We have discussed doing number 1.  The problem with number 2,
3, 4, & 5 is that we ended up with a bunch of files which appeared
to leak space.  If the truncate isn't done at file close time, the extra
space sits around forever.

>
> Note - i don't think extent size hints alone will help as they
> don't prevent EOF truncation on close.
>
> > One system had several hundred files
> > which required more than one page to store the extents.
>
> I don't consider that a problem as such. We'll always get some
> level of fragmentation if we don't preallocate.
>
> > Quite a few
> > files had extent counts greater than 10k, and one file had 120k extents.
>
> you should run xfs_fsr occassionally....
>
> > Besides the memory consumption, latency to return the first byte of the
> > file can get noticeable.
>
> Yes, that too :/
>
> However, I think we should be trying to fix the root cause of this
> worst case fragmentation rather than trying to make the rest of the
> filesystem accommodate an extreme corner case efficiently.  i.e.
> let's look at the test cases and determine what piece of logic we
> need to add or remove to prevent this cause of fragmentation.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
I guess there are multiple ways to look at this problem.  I have been
going under the assumption that xfs' inability to handle a large number
of extents is the root cause.  When a filesystem is full, defragmentation
might not be possible.   Also, should we consider a file with 1MB extents as
fragmented?  A 100GB file with 1MB extents has 100k extents.  As disks
and, hence, filesystems get larger, it's possible to have a larger number
of such files in a filesystem.

I still think that trying to not fragment up front is required as well 
as running
xfs_fsr, but I don't think those alone can be a complete solution.

Getting back to the original question, has there ever been serious thought
in what it might take to handle large extent files?  What might be involved
with trying to page extent blocks?

I'm most concerned about the potential locking consequences and streaming
performance implications.

thanks,

  Michael
