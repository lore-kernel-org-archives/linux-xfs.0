Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2998769AbdDZK4E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 06:56:04 -0400
Date: Wed, 26 Apr 2017 12:55:56 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Reviewing determinism of xfs_reclaim_inodes_ag()
Message-ID: <20170426105556.GA24825@quack2.suse.cz>
References: <20170425082503.GN28800@wotan.suse.de>
 <20170426000426.GK12369@dastard>
 <20170426091206.GA28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426091206.GA28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>, Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.com>

On Wed 26-04-17 11:12:06, Luis R. Rodriguez wrote:
> On Wed, Apr 26, 2017 at 10:04:26AM +1000, Dave Chinner wrote:
> > On Tue, Apr 25, 2017 at 10:25:03AM +0200, Luis R. Rodriguez wrote:
> > > I checked with Jan Kara and he believes the current code is correct but that
> > > its the comment that that may be misleading. As per Jan the race is between
> > > getting an inode reclaimed and grabbing it. Ie, XFS frees the inodes by RCU.
> > > However it doesn't actually *reuse* the inode until RCU period passes
> > > (unlike inodes allocated from slab with SLAB_RCU can be). So it can happen
> > 
> > ..... I initially tried using SLAB_DESTROY_BY_RCU which meant the
> > RCU grace period did not prevent reallocation of inodes that had
> > been freed. Hence this check was (once) necessary to prevent the
> > reclaim index going whacky on a reallocated inode.
> 
> Alright this helps, but why does *having* the RCU grace period prevent
> such type of race ? I can see it helping but removing completely such
> a race as a possibility ?

Well, if the inode is freed only after RCU period expires and we are doing
xfs_reclaim_inode_grab() under rcu_read_lock - which we are - then this
surely prevents us from seeing inode reallocated. What are you missing?

> Also, just so I understand I am following, this then implicates our
> reclaim rate is directly linked to the RCU grace period ?

Yes, as for any RCU-freed object...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
