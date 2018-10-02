Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:43720 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbeJBOPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 10:15:23 -0400
Received: by mail-io1-f67.google.com with SMTP id y10-v6so1310510ioa.10
        for <linux-xfs@vger.kernel.org>; Tue, 02 Oct 2018 00:33:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181002063952.GN18567@dastard>
References: <20180907015155.32559-1-david@fromorbit.com> <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
 <20181001010931.GO31060@dastard> <CAOQ4uxjo1nE38q=FL+EofoMz=1=D2eZYo9s3-TVBSEjbHH52kQ@mail.gmail.com>
 <20181001223244.GH18567@dastard> <CAOQ4uxhTJcEtUJkwO5UCyF1sCFQ=bPo0ragy5255aM30C9Z1Zw@mail.gmail.com>
 <20181002063952.GN18567@dastard>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 2 Oct 2018 09:33:30 +0200
Message-ID: <CAJfpegvcmKiaU-oPfXk0ub6tdBKhDRcUKTkLd5_rAagv05R-EA@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

On Tue, Oct 2, 2018 at 8:39 AM, Dave Chinner <david@fromorbit.com> wrote:

> Have a look at shrink_dcache_sb() and shrink_dcache_for_umount() and
> what they imply about the dentries that take references to an inode
> on a different superblock. Then look at generic_shutdown_super() -
> pay attention to what happens if there are still allocated inodes
> after all the superblock dentries have been pruned and inodes
> evicted. i.e. this will trigger if some other superblock holds
> references to them:
>
>                 if (!list_empty(&sb->s_inodes)) {
>                         printk("VFS: Busy inodes after unmount of %s. "
>                            "Self-destruct in 5 seconds.  Have a nice day...\n",
>                            sb->s_id);
>                 }
>

Overlay holds references to the underlying sb's (through a set of
internal mounts), so that's not going to happen.

> If overlay puts unlinked dentries on it's LRU where the superblock
> shrinker may clean them up and release the final reference to
> unlinked inodes, then whatever calls the shrinker will get blocked.
> If kswapd does the shrinking, then the whole system can lock up
> because kswapd can't make progress until the filesystem is unfrozen.
> And if the process that does that unfreezing needs memory....

Seems like freezing any of the layers if overlay itself is not frozen
is not a good idea.

Preventing unlink (or modification generally) on the underlying layers
if part of an overlay is also doable, but it would likely run into
such backward compat issues that no one would be happy.   So I don't
think that's now the way to go.   We could have done that initially,
but it turns out allowing modification of the underlying layers can be
useful at times.

> I can think of several other similar ways that we can probably be
> screwed by cross-superblock references and memory reclaim
> interactions. I can't think of any way to avoid them except for
> not getting into that mess in the first place.

The freezer interaction can be solved by letting the freezer know
about the dependencies of filesystems.   So if an underlying layer
needs to be frozen, then all stacks containing that underlying layer
would need to be frozen first.  I guess any of the other bad
interactions would be solvable in a similar manner.

Thanks,
Miklos

>
>> pardon my ignorance, but can't memory shrinker
>> trigger oom killer indirectly causing to release deleted inodes?
>> Not sure in which context those files/inodes get released?
>
> The oom killer doesn't free anything. It marks a process as being
> killed, then when that process context gets scehduled it exits,
> releasing all the open files it holds and so dropping the last
> reference to the dentries in task context, not the OOM kill context.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
