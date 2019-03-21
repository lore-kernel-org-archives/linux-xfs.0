Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfCUM1n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Mar 2019 08:27:43 -0400
Date: Thu, 21 Mar 2019 08:27:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: force writes to delalloc regions to unwritten
Message-ID: <20190321122740.GB33001@bfoster>
References: <20190315034038.GK23020@dastard>
 <20190315122939.GB5182@bfoster>
 <20190317224011.GO23020@dastard>
 <20190318124039.GA17956@bfoster>
 <20190318203506.GQ23020@dastard>
 <20190318215014.GA21231@bfoster>
 <20190319180249.GS4929@magnolia>
 <20190319202537.GR23020@dastard>
 <20190320120204.GA28268@bfoster>
 <20190320211019.GS23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320211019.GS23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Mar 21, 2019 at 08:10:19AM +1100, Dave Chinner wrote:
> On Wed, Mar 20, 2019 at 08:02:05AM -0400, Brian Foster wrote:
> > On Wed, Mar 20, 2019 at 07:25:37AM +1100, Dave Chinner wrote:
> > > > > The broader point is that by controlling writeback ordering, we can
> > > > > explicitly demonstrate stale data exposure. If fixed properly, we should
> > > > > never expect stale data exposure even in the event of out of order
> > > > > writeback completion, regardless of the cause.
> > > > 
> > > > Agree.  Even if s_f_r is a giant trash fire, if we're exposing stale
> > > > disk contents it's game over anyway and we ought to fix it.
> > > 
> > > Well, that's exactly the problem with SFR, isn't it? The dirty data
> > > is outside the range the user asks to sync and the implementation
> > > doesn't go anywhere near the filesystem so we can't actually do the
> > > right thing here. So we are left to either hack fixes around a
> > > shitty, broken interface and everyone pays the penalty, or we ignore
> > > it. We've simply ignored it for the past 10+ years because it really
> > > can't be used safely for it's intended purposes (as everyone who
> > > tries to use it finds out eventually)...
> > > 
> > 
> > Just to make this abundantly clear, there is nothing unique, magic or
> > special required of sync_file_range() to reproduce this stale data
> > exposure. See the following variation of a command sequence from the
> > fstest I posted the other day:
> > 
> > ...
> > # xfs_io -fc "pwrite 0 68k" -c fsync -c "pwrite 96k 4k" \
> > 	-c "fpunch 96k 4k" <file>
> > ...
> > # hexdump <file>
> > 0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> > *
> > 0011000 abab abab abab abab abab abab abab abab
> > *
> > 0018000 0000 0000 0000 0000 0000 0000 0000 0000
> > *
> > 0019000
> > 
> > Same problem, and it can be reproduced just as easily with a reflink or
> > even an overlapping direct I/O.
> 
> How does overlapping direct IO cause stale data exposure given that
> it uses unwritten extent allocation? That, of course, is ignoring
> the fact that the result of overlapping concurent direct IO is, by
> definition, undefined and an application bug if it occurs....
> 

It's overlapping a buffered write and so starts with a flush instead of
an unwritten allocation (so even a dio read is sufficient). Also, the
target of the dio isn't where stale data is exposed, so even if there
was an existing underlying unwritten block before the initial buffered
write it wouldn't change anything.

Yes, this is technically usage with undefined behavior, but that still
misses the forest from the trees. I'm not claiming this is good or
supported practice just as I'm not not claiming sync_file_range() should
be used for anything in practice. I'm just pointing out it's one of
several possible, obvious data exposure vectors. I suspect there are
others; these were just the easy variants to reproduce. If you prefer to
reason about reproducer patterns that don't use operations with quirks
or undefined behaviors, that's fine, just use the reflink or hole punch
example posted above that produce the same behavior.

> > I haven't confirmed, but I suspect with
> > enough effort background writeback is susceptible to this problem as
> > well.
> 
> Well, the similarity here is with the NULL files problems and using
> XFS_ITRUNCATE case to avoid NULL files after truncating them down.
> i.e.  if that flag is set, we do extra flushing where appropriate to
> ensure ithe data at risk of being lost hits the disk before the loss
> mechanism can be triggered.
> 
> i.e. this is the mirror equivalent of XFS_ITRUNCATE - it is the
> truncate-up flushing case in that we need to wait for the zeroing to
> hit the disk before we change the file size.
> 
> Eseentially, what this says to me is we need to track when we
> extended the file via a write beyond EOF via an inode flag. Then if we need to
> flush a data range from the file for integrity reasons (such as a
> fpnuch) and this flag is set, we ignore the "start" parameter of the
> range and flush from the start of the file instead. i.e. we
> guarantee that any dirty zeroed pages between the start of the file
> and the end of the range we are operating on gets written back. This
> will capture all these "didn't flush regions zeroed on file
> extension" problems in one go, without needing to change the way we
> do allocation or EOF zeroing.
> 

I don't think that would prevent the problem outside of the common write
extension case. If the file is sparse (i.e. truncated up ahead of time)
such that the file size is on disk, then any flush sequence and block
allocation within EOF is susceptible to stale data exposure in the
window between when the extent is allocated and writeback completes over
the entire extent. This variant is reproducible even with a plain old
fsync() call, it's just hard enough to reproduce to require
instrumentation (as opposed to the test sequences I've posted in this
thread so far).

It may be possible to selectively (i.e. as an optimization) use an
XFS_ITRUNCATED like algorithm as you propose here to always force in
order writeback in the cases where writeback extends the on-disk isize
(and thus isize protects from stale exposure), but I think we'd still
need something tied to extent allocation one way or another in addition
(like Darrick's original unwritten extent patch or your proposed
intent/done idea in the previous reply) to address the fundamental
problem. The question is what is the ideal solution..

Brian

> I suspect we could just use the XFS_ITRUNCATE flag for this - set it
> in the EOF zeroing code, check it in xfs_flush_unmap_range() and
> other places that do range based flushing....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
