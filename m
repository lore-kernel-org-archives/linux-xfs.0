Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40911 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752468AbdEFRlM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 May 2017 13:41:12 -0400
Date: Sat, 6 May 2017 19:41:10 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Reviewing determinism of xfs_reclaim_inodes_ag()
Message-ID: <20170506174110.GC28800@wotan.suse.de>
References: <20170425082503.GN28800@wotan.suse.de>
 <20170426000426.GK12369@dastard>
 <20170426091206.GA28800@wotan.suse.de>
 <20170426105556.GA24825@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170426105556.GA24825@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, Michal Hocko <mhocko@suse.com>

On Wed, Apr 26, 2017 at 12:55:56PM +0200, Jan Kara wrote:
> On Wed 26-04-17 11:12:06, Luis R. Rodriguez wrote:
> > On Wed, Apr 26, 2017 at 10:04:26AM +1000, Dave Chinner wrote:
> > > On Tue, Apr 25, 2017 at 10:25:03AM +0200, Luis R. Rodriguez wrote:
> > > > I checked with Jan Kara and he believes the current code is correct but that
> > > > its the comment that that may be misleading. As per Jan the race is between
> > > > getting an inode reclaimed and grabbing it. Ie, XFS frees the inodes by RCU.
> > > > However it doesn't actually *reuse* the inode until RCU period passes
> > > > (unlike inodes allocated from slab with SLAB_RCU can be). So it can happen
> > > 
> > > ..... I initially tried using SLAB_DESTROY_BY_RCU which meant the
> > > RCU grace period did not prevent reallocation of inodes that had
> > > been freed. Hence this check was (once) necessary to prevent the
> > > reclaim index going whacky on a reallocated inode.
> > 
> > Alright this helps, but why does *having* the RCU grace period prevent
> > such type of race ? I can see it helping but removing completely such
> > a race as a possibility ?
> 
> Well, if the inode is freed only after RCU period expires and we are doing
> xfs_reclaim_inode_grab() under rcu_read_lock - which we are - then this
> surely prevents us from seeing inode reallocated. What are you missing?

Right, OK fair, its just simple RCU by definition.

> > Also, just so I understand I am following, this then implicates our
> > reclaim rate is directly linked to the RCU grace period ?
> 
> Yes, as for any RCU-freed object...

Right.. I see, this is also by definition.

But also by definition the RCU grace period should be long that "any readers
accessing the item being deleted have since dropped their references".  What
are the implications if during xfs reclaim this is not true *often* ? Not sure
what types of situations could implicate this, perhaps a full rsync without
first suspending work and heavy IO ? Lets call these contended xfs inodes.
Could in theory we not reach:

∑ contended xfs inodes > free xfs inodes

If this situation is dire, what counter measures are / should be in place for
it ? If this is all expected and gravy then I suspect there is no issue and
the non-determinism of the above is fair game.

  Luis
