Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36989 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753243AbdF0NBn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jun 2017 09:01:43 -0400
Date: Tue, 27 Jun 2017 15:01:19 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170627130118.GM28072@dhcp22.suse.cz>
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
Cc: Eryu Guan <eguan@redhat.com>, linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>

On Mon 26-06-17 22:39:50, Dave Chinner wrote:
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

Yes this makes a lot of sense. Maybe slab debugging can catch such a
corruption earlier?
-- 
Michal Hocko
SUSE Labs
