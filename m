Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37869 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbeI3O2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Sep 2018 10:28:12 -0400
Received: by mail-yb1-f194.google.com with SMTP id h1-v6so2269020ybm.4
        for <linux-xfs@vger.kernel.org>; Sun, 30 Sep 2018 00:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <20180907015155.32559-1-david@fromorbit.com>
In-Reply-To: <20180907015155.32559-1-david@fromorbit.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 30 Sep 2018 10:56:02 +0300
Message-ID: <CAOQ4uxjaAJ9WSo-rtvBq7bFsV4QXHhwqjFyCFO030U4qZ7ALKg@mail.gmail.com>
Subject: Re: [PATCH] xfs: avoid lockdep false positives in xfs_trans_alloc
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>, Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[CC Ted and Jan to see if there are lessons here that apply to ext2 ext4]

On Fri, Sep 7, 2018 at 6:03 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> We've had a few reports of lockdep tripping over memory reclaim
> context vs filesystem freeze "deadlocks". They all have looked
> to be false positives on analysis, but it seems that they are
> being tripped because we take freeze references before we run
> a GFP_KERNEL allocation for the struct xfs_trans.=====
>
> We can avoid this false positive vector just by re-ordering the
> operations in xfs_trans_alloc(). That is. we need allocate the
> structure before we take the freeze reference and enter the GFP_NOFS
> allocation context that follows the xfs_trans around. This prevents
> lockdep from seeing the GFP_KERNEL allocation inside the transaction
> context, and that prevents it from triggering the freeze level vs
> alloc context vs reclaim warnings.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Dave,

First of all, you may add
Tested-by: Amir Goldstein <amir73il@gmail.com>
and I think attribution of Reported-by [2] to
Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
is called for.

I was getting the lockdep warning below reliably with the stress test
overlay/019 (over bas fs xfs with reflink) ever since kernel v4.18.
The warning is tripped on my system after 2 minutes of stress test.

The possibly interesting part about this particular splat is that, unlike
previously reported traces [1][2], sb_internals is not taken by kswapd
from pagewrite path, which as you wrote is not possible during freeze
level internal. In my splats sb_internals is taken by kswapd from
dcache shrink path.

It's true that overlayfs adds some quirks to the equation and this
specific stress test (by Ted) is especially evil for making changes
on overlay lower layer. This could results for example with unlinked
xfs inode with elevated reference from an overlay dentry, which
wasn't informed about this underlying unlink.

However, the case of an unlinked inode reference being held by an
open file or by inotify event doesn't seem so unlikely during frozen
filesystem, so I am not really sure that the "false positive" claim holds
water. If you agree with this argument, you might want to tone down
the "false positive" language from commit message and you may
name overlay/19 as a reliable reproducer if you see fit.

Thanks,
Amir.

>8->8->8->8 extracted only the interesting snip >8->8->8->8
 -> #0 (sb_internal#2){.+.+}:
        lock_acquire+0x150/0x182
        __sb_start_write+0x93/0x164
        xfs_trans_alloc+0x3c/0x1ca
        xfs_inactive_truncate+0x3d/0x122
        xfs_inactive+0x15a/0x1f4
        xfs_fs_destroy_inode+0x160/0x246
        __dentry_kill+0xdd/0x159
        dentry_kill+0x138/0x173
        dput+0x230/0x23d
        ovl_destroy_inode+0x15/0x69
        __dentry_kill+0xdd/0x159
        shrink_dentry_list+0x286/0x2c5
        prune_dcache_sb+0x5a/0x78
        super_cache_scan+0xfe/0x17b
        shrink_slab.constprop.31+0x27a/0x438
        shrink_node+0x74/0x251
        kswapd+0x502/0x62f

[1] https://marc.info/?l=linux-xfs&m=152954339303385&w=2
[2] https://marc.info/?l=linux-xfs&m=153627727029090&w=2
