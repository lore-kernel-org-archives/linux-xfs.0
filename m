Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:61439 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727084AbfCTVKb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Mar 2019 17:10:31 -0400
Date: Thu, 21 Mar 2019 08:10:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190320211019.GS23020@dastard>
References: <20190315031302.GF4929@magnolia>
 <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
 <20190317224011.GO23020@dastard>
 <20190318124039.GA17956@bfoster>
 <20190318203506.GQ23020@dastard>
 <20190318215014.GA21231@bfoster>
 <20190319180249.GS4929@magnolia>
 <20190319202537.GR23020@dastard>
 <20190320120204.GA28268@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320120204.GA28268@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Mar 20, 2019 at 08:02:05AM -0400, Brian Foster wrote:
> On Wed, Mar 20, 2019 at 07:25:37AM +1100, Dave Chinner wrote:
> > > > The broader point is that by controlling writeback ordering, we can
> > > > explicitly demonstrate stale data exposure. If fixed properly, we should
> > > > never expect stale data exposure even in the event of out of order
> > > > writeback completion, regardless of the cause.
> > > 
> > > Agree.  Even if s_f_r is a giant trash fire, if we're exposing stale
> > > disk contents it's game over anyway and we ought to fix it.
> > 
> > Well, that's exactly the problem with SFR, isn't it? The dirty data
> > is outside the range the user asks to sync and the implementation
> > doesn't go anywhere near the filesystem so we can't actually do the
> > right thing here. So we are left to either hack fixes around a
> > shitty, broken interface and everyone pays the penalty, or we ignore
> > it. We've simply ignored it for the past 10+ years because it really
> > can't be used safely for it's intended purposes (as everyone who
> > tries to use it finds out eventually)...
> > 
> 
> Just to make this abundantly clear, there is nothing unique, magic or
> special required of sync_file_range() to reproduce this stale data
> exposure. See the following variation of a command sequence from the
> fstest I posted the other day:
> 
> ...
> # xfs_io -fc "pwrite 0 68k" -c fsync -c "pwrite 96k 4k" \
> 	-c "fpunch 96k 4k" <file>
> ...
> # hexdump <file>
> 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> *
> 0011000 abab abab abab abab abab abab abab abab
> *
> 0018000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0019000
> 
> Same problem, and it can be reproduced just as easily with a reflink or
> even an overlapping direct I/O.

How does overlapping direct IO cause stale data exposure given that
it uses unwritten extent allocation? That, of course, is ignoring
the fact that the result of overlapping concurent direct IO is, by
definition, undefined and an application bug if it occurs....

> I haven't confirmed, but I suspect with
> enough effort background writeback is susceptible to this problem as
> well.

Well, the similarity here is with the NULL files problems and using
XFS_ITRUNCATE case to avoid NULL files after truncating them down.
i.e.  if that flag is set, we do extra flushing where appropriate to
ensure ithe data at risk of being lost hits the disk before the loss
mechanism can be triggered.

i.e. this is the mirror equivalent of XFS_ITRUNCATE - it is the
truncate-up flushing case in that we need to wait for the zeroing to
hit the disk before we change the file size.

Eseentially, what this says to me is we need to track when we
extended the file via a write beyond EOF via an inode flag. Then if we need to
flush a data range from the file for integrity reasons (such as a
fpnuch) and this flag is set, we ignore the "start" parameter of the
range and flush from the start of the file instead. i.e. we
guarantee that any dirty zeroed pages between the start of the file
and the end of the range we are operating on gets written back. This
will capture all these "didn't flush regions zeroed on file
extension" problems in one go, without needing to change the way we
do allocation or EOF zeroing.

I suspect we could just use the XFS_ITRUNCATE flag for this - set it
in the EOF zeroing code, check it in xfs_flush_unmap_range() and
other places that do range based flushing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
