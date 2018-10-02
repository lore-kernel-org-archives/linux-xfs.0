Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35295 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbeJBKn3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 06:43:29 -0400
Received: by mail-yw1-f68.google.com with SMTP id y76-v6so248142ywd.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Oct 2018 21:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180907015155.32559-1-david@fromorbit.com> <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard> <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard>
In-Reply-To: <20181001223244.GH18567@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 2 Oct 2018 07:02:08 +0300
Message-ID: <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Oct 2, 2018 at 1:32 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Oct 01, 2018 at 10:56:25AM +0300, Amir Goldstein wrote:
[...]
> > So while the statement "it's not a deadlock" may still be true, I am not
> > yet convinced that the claim that there are no dirty pages to write when
> > filesystem is frozen is sufficient to back that claim.
> >
> > Are you sure there was no deadlock lurking in there while fs is past
> > SB_FREEZE_FS and kswapd shrinker races with another process
> > releasing the last reference to an(other) inode?
>
> The inodes being released by the shrinkers should be clean, and
> hence releasing them does not require post-release transactions to
> be run.
>
> It does concern me that the overlay dcache shrinker is dropping the
> last reference to an XFS inode and it does not get put on the LRU
> for the correct superblock inode cache shrinker to free it. That
> implies that the overlay dcache shrinker is dropping the last
> reference to an unlinked inode.
>

Yes, there is nothing that prevents overlayfs (or ecryptfs) to end up
with the last reference on an underlying unlinked inode.
It will require an action of unlink from underlying layer, which is not
normal user behavior, but it is possible.

> AFAIA, the dcache shrinker should never be freeing the last
> reference to an unlinked inode - it should always be done from the
> context that unlinked the inode or the context that closed the final
> fd on that inode. i.e. a task context, not a shrinker or kswapd. Can
> you confirm what the state of the inode being dropped in that
> lockdep trace is?
>

Given that the stress tests runs fsstress in parallel (same seed) on
overlay and underlying lower fs, I would say that it is very likely to
trip on shrinker putting an overlay dentry/inode holding the last reference
to an unlinked underlying fs inode.

How concerned are you about this? Is it inherently hard to deal with
this situation in XFS? pardon my ignorance, but can't memory shrinker
trigger oom killer indirectly causing to release deleted inodes?
Not sure in which context those files/inodes get released?

Thanks,
Amir.
