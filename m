Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59827 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728483AbfHEX3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 19:29:37 -0400
Date: Tue, 6 Aug 2019 09:28:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 14/24] xfs: tail updates only need to occur when LSN
 changes
Message-ID: <20190805232826.GZ7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-15-david@fromorbit.com>
 <20190805175325.GD14760@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805175325.GD14760@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 05, 2019 at 01:53:26PM -0400, Brian Foster wrote:
> On Thu, Aug 01, 2019 at 12:17:42PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently wake anything waiting on the log tail to move whenever
> > the log item at the tail of the log is removed. Historically this
> > was fine behaviour because there were very few items at any given
> > LSN. But with delayed logging, there may be thousands of items at
> > any given LSN, and we can't move the tail until they are all gone.
> > 
> > Hence if we are removing them in near tail-first order, we might be
> > waking up processes waiting on the tail LSN to change (e.g. log
> > space waiters) repeatedly without them being able to make progress.
> > This also occurs with the new sync push waiters, and can result in
> > thousands of spurious wakeups every second when under heavy direct
> > reclaim pressure.
> > 
> > To fix this, check that the tail LSN has actually changed on the
> > AIL before triggering wakeups. This will reduce the number of
> > spurious wakeups when doing bulk AIL removal and make this code much
> > more efficient.
> > 
> > XXX: occasionally get a temporary hang in xfs_ail_push_sync() with
> > this change - log force from log worker gets things moving again.
> > Only happens under extreme memory pressure - possibly push racing
> > with a tail update on an empty log. Needs further investigation.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Ok, this addresses the wakeup granularity issue mentioned in the
> previous patch. Note that I was kind of wondering why we wouldn't base
> this on the l_tail_lsn update in xlog_assign_tail_lsn_locked() as
> opposed to the current approach.

Because I didn't think of it? :)

There's so much other stuff in this patch set I didn't spend a
lot of time thinking about other alternatives. this was a simple
code transformation that did what I wanted, and I went on to burning
brain cells on other more complex issues that needs to be solved...

> For example, xlog_assign_tail_lsn_locked() could simply check the
> current min item against the current l_tail_lsn before it does the
> assignment and use that to trigger tail change events. If we wanted to
> also filter out the other wakeups (as this patch does) then we could
> just pass a bool pointer or something that returns whether the tail
> actually changed.

Yeah, I'll have a look at this - I might rework it as additional
patches now the code is looking at decisions based on LSN rather
than if the tail log item changed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
