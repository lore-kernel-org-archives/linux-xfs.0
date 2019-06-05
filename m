Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfFEPr2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 11:47:28 -0400
Date: Wed, 5 Jun 2019 11:47:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190605154724.GB15671@bfoster>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-7-hch@lst.de>
 <20190604161240.GA44563@bfoster>
 <20190604224544.GB29573@dread.disaster.area>
 <20190605105112.GA49049@bfoster>
 <20190605151451.GC14846@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605151451.GC14846@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Jun 05, 2019 at 05:14:51PM +0200, Christoph Hellwig wrote:
> On Wed, Jun 05, 2019 at 06:51:12AM -0400, Brian Foster wrote:
> > Yep. Another thing that briefly crossed my mind is whether we could in
> > theory optimize flushes out if the tail hasn't moved since the last
> > flush. We'd still have to FUA the log records, but we haven't introduced
> > any such integrity/ordering requirements if the tail hasn't changed,
> > right?
> > 
> > It's debatable whether that would provide any value, but it might at
> > least apply to certain scenarios like if the tail happens to be pinned
> > by a single object across several iclog writes, or if fsyncs or some
> > other pattern result in smaller/frequent checkpoints relative to
> > metadata writeback, etc.
> 
> Well, for the fsync we require the data device to be flushed for
> the fsync semantics anyway.  So we'd now need to treat that special,
> simiar to that old log_flushed return parameter hack.

Yeah, good point. It looks like the current fsync code already relies on
the flush associated with the log force if the log and data devices are
the same (otherwise we explicitly flush the data dev between data
writeback and the log force). Any optimization there probably wouldn't
buy anything for fsync callers that have to write file data. It would
just shift responsibility of the flush to the fsync and perhaps
complicate that current log_flushed thing since it also kind of assumes
an unconditional flush based on iclog state.

Brian
