Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:36202 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726733AbeJAHpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 03:45:05 -0400
Date: Mon, 1 Oct 2018 11:09:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Message-ID: <20181001010931.GO31060@dastard>
References: <20180907015155.32559-1-david@fromorbit.com>
 <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Sun, Sep 30, 2018 at 10:56:02AM +0300, Amir Goldstein wrote:
> [CC Ted and Jan to see if there are lessons here that apply to ext2 ext4]
> 
> On Fri, Sep 7, 2018 at 6:03 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > We've had a few reports of lockdep tripping over memory reclaim
> > context vs filesystem freeze "deadlocks". They all have looked
> > to be false positives on analysis, but it seems that they are
> > being tripped because we take freeze references before we run
> > a GFP_KERNEL allocation for the struct xfs_trans.=====
> >
> > We can avoid this false positive vector just by re-ordering the
> > operations in xfs_trans_alloc(). That is. we need allocate the
> > structure before we take the freeze reference and enter the GFP_NOFS
> > allocation context that follows the xfs_trans around. This prevents
> > lockdep from seeing the GFP_KERNEL allocation inside the transaction
> > context, and that prevents it from triggering the freeze level vs
> > alloc context vs reclaim warnings.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Dave,
> 
> First of all, you may add
> Tested-by: Amir Goldstein <amir73il@gmail.com>

Too late, already pushed.

> and I think attribution of Reported-by [2] to
> Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> is called for.

Not for multiply-reported bugs. i.e. this has been reported in RHEL,
by syzbot, by various users and several developers so giving
attribution to just one person is not the right thing to do. It's
either all or none, and given that the commit message is not for
tracking a list of people who hit the issue, I decided "none".

> I was getting the lockdep warning below reliably with the stress test
> overlay/019 (over bas fs xfs with reflink) ever since kernel v4.18.
> The warning is tripped on my system after 2 minutes of stress test.
> 
> The possibly interesting part about this particular splat is that, unlike
> previously reported traces [1][2], sb_internals is not taken by kswapd
> from pagewrite path, which as you wrote is not possible during freeze
> level internal. In my splats sb_internals is taken by kswapd from
> dcache shrink path.

Which is exactly the same case. i.e. a transaction is being run
from kswapd's reclaim context. It doesn't matter if it's an extent
allocation transaction in the direct page writeback path, or
prune_dcache_sb() killing a dentry and dropping the last reference
to an unlinked inode triggering a truncate, or indeed prune_icache_sb
dropping an inode off the LRU and triggering a truncate of
specualtively preallocated blocks beyond EOF.

i.e. Lockdep is warning about a transaction being run in kswapd's
reclaim context - this is something we are allowed to do (and need
to do to make forwards progress) because the kswapd reclaim context
is GFP_KERNEL....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
