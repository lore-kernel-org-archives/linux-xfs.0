Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753374AbdF1C6p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 22:58:45 -0400
Date: Wed, 28 Jun 2017 10:58:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170628025842.GZ23360@eguan.usersys.redhat.com>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170623072656.GI23360@eguan.usersys.redhat.com>
 <20170623074334.GE5308@dhcp22.suse.cz>
 <20170623075156.GF5308@dhcp22.suse.cz>
 <20170626123949.GP17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170626123949.GP17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>

On Mon, Jun 26, 2017 at 10:39:50PM +1000, Dave Chinner wrote:
> On Fri, Jun 23, 2017 at 09:51:56AM +0200, Michal Hocko wrote:
> > On Fri 23-06-17 09:43:34, Michal Hocko wrote:
> > > [Let's add Jack and keep the full email for reference]
> > > 
> > > On Fri 23-06-17 15:26:56, Eryu Guan wrote:
> > [...]
> > > > Then I did further confirmation tests:
> > > > 1. switch to a new branch with that jbd2 patch as HEAD and compile
> > > > kernel, run test with both ext4 and XFS exported on this newly compiled
> > > > kernel, it crashed within 5 iterations.
> > > > 
> > > > 2. revert that jbd2 patch (when it was HEAD), run test with both ext4
> > > > and XFS exported, kernel survived 20 iterations of full fstests run.
> > > > 
> > > > 3. kernel from step 1 survived 20 iterations of full fstests run, if I
> > > > export XFS only (create XFS on /dev/sda4 and mount it at /export/test).
> > > > 
> > > > 4. 4.12-rc1 kernel survived the same test if I export ext4 only (both
> > > > /export/test and /export/scratch were mounted as ext4, and this was done
> > > > on another test host because I don't have another spare test partition)
> > > > 
> > > > 
> > > > All these facts seem to confirm that commit 81378da64de6 really is the
> > > > culprit, I just don't see how..
> > 
> > AFAIR, no follow up patches to remove GFP_NOFS have been merged into
> > ext4 so we are currently only with 81378da64de6 and all it does is that
> > _all_ allocations from the transaction context are implicitly GFP_NOFS.
> > I can imagine that if there is a GFP_KERNEL allocation in this context
> > (which would be incorrect AFAIU) some shrinkers will not be called as a
> > result and that might lead to an observable behavior change. But this
> > sounds like a wild speculation. The mere fact that xfs oopses and there
> > is no ext code in the backtrace is suspicious on its own. Does this oops
> > sound familiar to xfs guys?
> 
> Nope, but if it's in write_cache_pages() then it's not actually
> crashing in XFS code, but in generic page cache and radix tree
> traversal code. Which means objects that are allocated from slabs
> and pools that are shared by both XFS and ext4.
> 
> We've had problems in the past where use after free of bufferheads
> in reiserfs was discovered by corruption of bufferheads in XFS code,
> so maybe there's a similar issue being exposed by the ext4
> GFP_NOFS changes? i.e. try debugging this by treating it as memory
> corruption until we know more...
> 
> > > > > [88901.418500]  write_cache_pages+0x26f/0x510
> 
> Knowing what line of code is failing would help identify what object
> is problematic....

This was what I replied to Darrick when he first asked for the same
information:

"
I managed to reproduce again with 4.12-rc4 kernel, call trace is

[  704.811107] Call Trace:
[  704.811107]  do_trap+0x16a/0x190
[  704.811107]  do_error_trap+0x89/0x110
[  704.811107]  ? xfs_do_writepage+0x6c7/0x6d0 [xfs]
[  704.811107]  ? check_preempt_curr+0x7d/0x90
[  704.811107]  ? ttwu_do_wakeup+0x1e/0x150
[  704.811107]  do_invalid_op+0x20/0x30
[  704.811107]  invalid_op+0x1e/0x30

and xfs_do_writepage+0x6c7 is

(gdb) l *(xfs_do_writepage+0x6c7)
0x679e7 is in xfs_do_writepage (fs/xfs/xfs_aops.c:850).
845             int                     error = 0;
846             int                     count = 0;
847             int                     uptodate = 1;
848             unsigned int            new_type;
849
850             bh = head = page_buffers(page);
851             offset = page_offset(page);
852             do {
853                     if (offset >= end_offset)
854                             break;
"

Later on, I did the same several times, and it ended up in different
lines of the code, I can't remember the exact line number now, but it
always involved in dealing with buffer heads.

Thanks,
Eryu

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
