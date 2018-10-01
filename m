Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39140 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbeJAOdE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 10:33:04 -0400
Received: by mail-yw1-f65.google.com with SMTP id v1-v6so5104652ywv.6
        for <linux-xfs@vger.kernel.org>; Mon, 01 Oct 2018 00:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20180907015155.32559-1-david@fromorbit.com> <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard>
In-Reply-To: <20181001010931.GO31060@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 1 Oct 2018 10:56:25 +0300
Message-ID: <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 1, 2018 at 4:09 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sun, Sep 30, 2018 at 10:56:02AM +0300, Amir Goldstein wrote:
> > [CC Ted and Jan to see if there are lessons here that apply to ext2 ext4]
> >
> > On Fri, Sep 7, 2018 at 6:03 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > From: Dave Chinner <dchinner@redhat.com>
> > >
> > > We've had a few reports of lockdep tripping over memory reclaim
> > > context vs filesystem freeze "deadlocks". They all have looked
> > > to be false positives on analysis, but it seems that they are
> > > being tripped because we take freeze references before we run
> > > a GFP_KERNEL allocation for the struct xfs_trans.=====
> > >
> > > We can avoid this false positive vector just by re-ordering the
> > > operations in xfs_trans_alloc(). That is. we need allocate the
> > > structure before we take the freeze reference and enter the GFP_NOFS
> > > allocation context that follows the xfs_trans around. This prevents
> > > lockdep from seeing the GFP_KERNEL allocation inside the transaction
> > > context, and that prevents it from triggering the freeze level vs
> > > alloc context vs reclaim warnings.
> > >
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> >
[...]
> > I was getting the lockdep warning below reliably with the stress test
> > overlay/019 (over bas fs xfs with reflink) ever since kernel v4.18.
> > The warning is tripped on my system after 2 minutes of stress test.
> >
> > The possibly interesting part about this particular splat is that, unlike
> > previously reported traces [1][2], sb_internals is not taken by kswapd
> > from pagewrite path, which as you wrote is not possible during freeze
> > level internal. In my splats sb_internals is taken by kswapd from
> > dcache shrink path.
>
> Which is exactly the same case. i.e. a transaction is being run
> from kswapd's reclaim context. It doesn't matter if it's an extent
> allocation transaction in the direct page writeback path, or
> prune_dcache_sb() killing a dentry and dropping the last reference
> to an unlinked inode triggering a truncate, or indeed prune_icache_sb
> dropping an inode off the LRU and triggering a truncate of
> specualtively preallocated blocks beyond EOF.
>
> i.e. Lockdep is warning about a transaction being run in kswapd's
> reclaim context - this is something we are allowed to do (and need
> to do to make forwards progress) because the kswapd reclaim context
> is GFP_KERNEL....
>

I understand that, but I would still like to ask for a clarification on one
point. In response to one of the lockdep warning reports [1] you wrote:
"It's not a deadlock - for anything to deadlock in this path, we have
to be in the middle of a freeze and have frozen the transaction
subsystem. Which we cannot do until we've cleaned all the dirty
cached pages in the filesystem and frozen all new writes. Which means
kswapd cannot enter this direct writeback path because we can't have
dirty pages on the filesystem."

I don't see how this argument holds for the shrinker case.
That is, if filesystem is already past freezing the transaction subsystem
and then kswapd comes along and runs the shrinkers.

So while the statement "it's not a deadlock" may still be true, I am not
yet convinced that the claim that there are no dirty pages to write when
filesystem is frozen is sufficient to back that claim.

Are you sure there was no deadlock lurking in there while fs is past
SB_FREEZE_FS and kswapd shrinker races with another process
releasing the last reference to an(other) inode?

I appreciate your patience, I would really like to better understand
all the aspects of freezing (it is essential for ovl snapshots).

Thanks,
Amir.

[1] https://marc.info/?l=linux-xfs&m=153627727029090&w=2
