Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:52390 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751441AbdFZMkY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jun 2017 08:40:24 -0400
Date: Mon, 26 Jun 2017 22:39:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170626123949.GP17542@dastard>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170623072656.GI23360@eguan.usersys.redhat.com>
 <20170623074334.GE5308@dhcp22.suse.cz>
 <20170623075156.GF5308@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170623075156.GF5308@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Eryu Guan <eguan@redhat.com>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>

On Fri, Jun 23, 2017 at 09:51:56AM +0200, Michal Hocko wrote:
> On Fri 23-06-17 09:43:34, Michal Hocko wrote:
> > [Let's add Jack and keep the full email for reference]
> > 
> > On Fri 23-06-17 15:26:56, Eryu Guan wrote:
> [...]
> > > Then I did further confirmation tests:
> > > 1. switch to a new branch with that jbd2 patch as HEAD and compile
> > > kernel, run test with both ext4 and XFS exported on this newly compiled
> > > kernel, it crashed within 5 iterations.
> > > 
> > > 2. revert that jbd2 patch (when it was HEAD), run test with both ext4
> > > and XFS exported, kernel survived 20 iterations of full fstests run.
> > > 
> > > 3. kernel from step 1 survived 20 iterations of full fstests run, if I
> > > export XFS only (create XFS on /dev/sda4 and mount it at /export/test).
> > > 
> > > 4. 4.12-rc1 kernel survived the same test if I export ext4 only (both
> > > /export/test and /export/scratch were mounted as ext4, and this was done
> > > on another test host because I don't have another spare test partition)
> > > 
> > > 
> > > All these facts seem to confirm that commit 81378da64de6 really is the
> > > culprit, I just don't see how..
> 
> AFAIR, no follow up patches to remove GFP_NOFS have been merged into
> ext4 so we are currently only with 81378da64de6 and all it does is that
> _all_ allocations from the transaction context are implicitly GFP_NOFS.
> I can imagine that if there is a GFP_KERNEL allocation in this context
> (which would be incorrect AFAIU) some shrinkers will not be called as a
> result and that might lead to an observable behavior change. But this
> sounds like a wild speculation. The mere fact that xfs oopses and there
> is no ext code in the backtrace is suspicious on its own. Does this oops
> sound familiar to xfs guys?

Nope, but if it's in write_cache_pages() then it's not actually
crashing in XFS code, but in generic page cache and radix tree
traversal code. Which means objects that are allocated from slabs
and pools that are shared by both XFS and ext4.

We've had problems in the past where use after free of bufferheads
in reiserfs was discovered by corruption of bufferheads in XFS code,
so maybe there's a similar issue being exposed by the ext4
GFP_NOFS changes? i.e. try debugging this by treating it as memory
corruption until we know more...

> > > > [88901.418500]  write_cache_pages+0x26f/0x510

Knowing what line of code is failing would help identify what object
is problematic....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
