Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33697 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750904AbdEIKlw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 06:41:52 -0400
Date: Tue, 9 May 2017 12:41:50 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Reviewing determinism of xfs_reclaim_inodes_ag()
Message-ID: <20170509104150.GB21467@quack2.suse.cz>
References: <20170425082503.GN28800@wotan.suse.de>
 <20170426000426.GK12369@dastard>
 <20170426091206.GA28800@wotan.suse.de>
 <20170426105556.GA24825@quack2.suse.cz>
 <20170506174110.GC28800@wotan.suse.de>
 <20170506175212.GD28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170506175212.GD28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, Michal Hocko <mhocko@suse.com>

On Sat 06-05-17 19:52:12, Luis R. Rodriguez wrote:
> On Sat, May 06, 2017 at 07:41:10PM +0200, Luis R. Rodriguez wrote:
> > On Wed, Apr 26, 2017 at 12:55:56PM +0200, Jan Kara wrote:
> > > On Wed 26-04-17 11:12:06, Luis R. Rodriguez wrote:
> > > > On Wed, Apr 26, 2017 at 10:04:26AM +1000, Dave Chinner wrote:
> > > > > On Tue, Apr 25, 2017 at 10:25:03AM +0200, Luis R. Rodriguez wrote:
> > > > > > I checked with Jan Kara and he believes the current code is correct but that
> > > > > > its the comment that that may be misleading. As per Jan the race is between
> > > > > > getting an inode reclaimed and grabbing it. Ie, XFS frees the inodes by RCU.
> > > > > > However it doesn't actually *reuse* the inode until RCU period passes
> > > > > > (unlike inodes allocated from slab with SLAB_RCU can be). So it can happen
> > > > > 
> > > > > ..... I initially tried using SLAB_DESTROY_BY_RCU which meant the
> > > > > RCU grace period did not prevent reallocation of inodes that had
> > > > > been freed. Hence this check was (once) necessary to prevent the
> > > > > reclaim index going whacky on a reallocated inode.
> > > > 
> > > > Alright this helps, but why does *having* the RCU grace period prevent
> > > > such type of race ? I can see it helping but removing completely such
> > > > a race as a possibility ?
> > > 
> > > Well, if the inode is freed only after RCU period expires and we are doing
> > > xfs_reclaim_inode_grab() under rcu_read_lock - which we are - then this
> > > surely prevents us from seeing inode reallocated. What are you missing?
> > 
> > Right, OK fair, its just simple RCU by definition.
> > 
> > > > Also, just so I understand I am following, this then implicates our
> > > > reclaim rate is directly linked to the RCU grace period ?
> > > 
> > > Yes, as for any RCU-freed object...
> > 
> > Right.. I see, this is also by definition.
> > 
> > But also by definition the RCU grace period should be long that "any readers
> > accessing the item being deleted have since dropped their references".  What
> > are the implications if during xfs reclaim this is not true *often* ? Not sure
> > what types of situations could implicate this, perhaps a full rsync without
> > first suspending work and heavy IO ? Lets call these contended xfs inodes.
> > Could in theory we not reach:
> > 
> > ∑ contended xfs inodes > free xfs inodes
> > 
> > If this situation is dire, what counter measures are / should be in place for
> > it ? If this is all expected and gravy then I suspect there is no issue and
> > the non-determinism of the above is fair game.
> 
> Lets also recall that:
> 
> ====
> 	Just as with spinlocks, RCU readers are not permitted to
> 	block, switch to user-mode execution, or enter the idle loop.
> 	Therefore, as soon as a CPU is seen passing through any of these
> 	three states, we know that that CPU has exited any previous RCU
> 	read-side critical sections.  So, if we remove an item from a
> 	linked list, and then wait until all CPUs have switched context,
> 	executed in user mode, or executed in the idle loop, we can
> 	safely free up that item.
> ====
> 
> So any "contended xfs inodes" should also be really busying out the CPU,
> and if we only have X CPUs, well that gives us an upper limit before
> we busy the hell out ?

Well, the RCU grace period is a system global thing - all rcu_read_lock()
users in the kernel block the grace period from finishing. You can read
more about RCU in Documentation/RCU/ or on LWN. Anyway since holders of
rcu_read_lock() are not allowed to sleep the expected length of the grace
period is in milliseconds at most. So inodes freed by xfs_inode_free() will
be released to the slab cache with that delay.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
