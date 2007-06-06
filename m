Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 18:36:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l561a7Wt014049
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 18:36:09 -0700
Date: Wed, 6 Jun 2007 11:36:01 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reducing memory requirements for high extent xfs files
Message-ID: <20070606013601.GR86004887@sgi.com>
References: <200705301649.l4UGnckA027406@oss.sgi.com> <20070530225516.GB85884050@sgi.com> <4665E276.9020406@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4665E276.9020406@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, Michael Nishimoto <miken@stanfordalumni.org>, xfs@oss.sgi.com

On Tue, Jun 05, 2007 at 03:23:50PM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Wed, May 30, 2007 at 09:49:38AM -0700, Michael Nishimoto wrote:
> > > Hello,
> > >
> > > Has anyone done any work or had thoughts on changes required
> > > to reduce the total memory footprint of high extent xfs files?
.....
> >Yes, it could, but that's a pretty major overhaul of the extent
> >interface which currently assumes everywhere that the entire
> >extent tree is in core.
> >
> >Can you describe the problem you are seeing that leads you to
> >ask this question? What's the problem you need to solve?
> 
> I realize that this work won't be trivial which is why I asked if anyone
> has thought about all relevant issues.
> 
> When using NFS over XFS, slowly growing files (can be ascii log files)
> tend to fragment quite a bit.

Oh, that problem.

The issue is that allocation beyond EOF (the normal way we prevent
fragmentation in this case) gets truncated off on file close.

Even NFS request is processed by doing:

	open
	write
	close

And so XFS truncates the allocation beyond EOF on close. Hence
the next write requires a new allocation and that results in
a non-contiguous file because the adjacent blocks have already
been used....

Options:

	- NFS server open file cache to avoid the close.
	- add detection to XFS to determine if the called is
	  an NFS thread and don't truncate on close.
	- use preallocation.
	- preallocation on the file once will result in the
	  XFS_DIFLAG_PREALLOC being set on the inode and it
	  won't truncate on close.
	- append only flag will work in the same way as the
	  prealloc flag w.r.t preventing truncation on close.
	- run xfs_fsr

Note - i don't think extent size hints alone will help as they
don't prevent EOF truncation on close.

> One system had several hundred files
> which required more than one page to store the extents.

I don't consider that a problem as such. We'll always get some
level of fragmentation if we don't preallocate.

> Quite a few
> files had extent counts greater than 10k, and one file had 120k extents.

you should run xfs_fsr occassionally....

> Besides the memory consumption, latency to return the first byte of the
> file can get noticeable.

Yes, that too :/

However, I think we should be trying to fix the root cause of this
worst case fragmentation rather than trying to make the rest of the
filesystem accommodate an extreme corner case efficiently.  i.e.
let's look at the test cases and determine what piece of logic we
need to add or remove to prevent this cause of fragmentation.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
