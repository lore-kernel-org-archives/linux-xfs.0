Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:54249 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbdKAEnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 00:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <20171101030536.GN5858@dastard>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
 <20171031003358.GD5858@dastard> <CAM_iQpUD5ffaKS7TQ5n9A67TWqrVm8AVKf6ERz3pSFu7rL2rbg@mail.gmail.com>
 <20171101030536.GN5858@dastard>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 31 Oct 2017 21:43:03 -0700
Message-ID: <CAM_iQpVOmNj6aDNr-Z5owAxS0o0+1j7P3=qzzUWci0f2wVnvaw@mail.gmail.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Oct 31, 2017 at 8:05 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Oct 31, 2017 at 06:51:08PM -0700, Cong Wang wrote:
>> On Mon, Oct 30, 2017 at 5:33 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Oct 30, 2017 at 02:55:43PM -0700, Cong Wang wrote:
>> >> Hello,
>> >>
>> >> We triggered a list corruption (double add) warning below on our 4.9
>> >> kernel (the 4.9 kernel we use is based on -stable release, with only a
>> >> few unrelated networking backports):
> ...
>> >> 4.9.34.el7.x86_64 #1
>> >> Hardware name: TYAN S5512/S5512, BIOS V8.B13 03/20/2014
>> >>  ffffb0d48a0abb30 ffffffff8e389f47 ffffb0d48a0abb80 0000000000000000
>> >>  ffffb0d48a0abb70 ffffffff8e08989b 0000002400000000 ffff8d9d691e0aa0
>> >>  ffff8d9d7a716608 ffff8d9d691e0aa0 0000000000004000 ffff8d9d7de6d800
>> >> Call Trace:
>> >>  [<ffffffff8e389f47>] dump_stack+0x4d/0x66
>> >>  [<ffffffff8e08989b>] __warn+0xcb/0xf0
>> >>  [<ffffffff8e08991f>] warn_slowpath_fmt+0x5f/0x80
>> >>  [<ffffffff8e3a979c>] __list_add+0xac/0xb0
>> >>  [<ffffffff8e2355bb>] inode_sb_list_add+0x3b/0x50
>> >>  [<ffffffffc040157c>] xfs_setup_inode+0x2c/0x170 [xfs]
>> >>  [<ffffffffc0402097>] xfs_ialloc+0x317/0x5c0 [xfs]
>> >>  [<ffffffffc0404347>] xfs_dir_ialloc+0x77/0x220 [xfs]
>> >
>> > Inode allocation, so should be a new inode straight from the slab
>> > cache. THat implies memory corruption of some kind. Please turn on
>> > slab poisoning and try to reproduce.
>>
>> Are you sure? xfs_iget() seems searching in a cache before allocating
>> a new one:
>
> /me sighs
>
> You started with "I don't know the XFS code very well", so I omitted
> the complexity of describing about 10 different corner cases where
> we /could/ find the unlinked inode still in the cache via the
> lookup. But they aren't common cases - the common case in the real
> world is allocation of cache cold inodes. IOWs: "so should be a new
> inode straight from the slab cache".
>
> So, yes, we could find the old unlinked inode still cached in the
> XFS inode cache, but I don't have the time to explain how RCU lookup
> code works to everyone who reports a bug.

Oh, sorry about it. I understand it now.


>
> All you need to understand is that all of this happens below the VFS
> and so inodes being reclaimed or newly allocated the in-cache inode
> should never, ever be on the VFS sb inode list.
>

OK.


>> >>  [<ffffffff8e74cf32>] ? down_write+0x12/0x40
>> >>  [<ffffffffc0404972>] xfs_create+0x482/0x760 [xfs]
>> >>  [<ffffffffc04019ae>] xfs_generic_create+0x21e/0x2c0 [xfs]
>> >>  [<ffffffffc0401a84>] xfs_vn_mknod+0x14/0x20 [xfs]
>> >>  [<ffffffffc0401aa6>] xfs_vn_mkdir+0x16/0x20 [xfs]
>> >>  [<ffffffff8e226698>] vfs_mkdir+0xe8/0x140
>> >>  [<ffffffff8e22aa4a>] SyS_mkdir+0x7a/0xf0
>> >>  [<ffffffff8e74f8e0>] entry_SYSCALL_64_fastpath+0x13/0x94
>> >>
>> >> _Without_ looking deeper, it seems this warning could be shut up by:
>> >>
>> >> --- a/fs/xfs/xfs_icache.c
>> >> +++ b/fs/xfs/xfs_icache.c
>> >> @@ -1138,6 +1138,8 @@ xfs_reclaim_inode(
>> >>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> >>
>> >>         XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
>> >> +
>> >> +       inode_sb_list_del(VFS_I(ip));
>> >>
>> >> with properly exporting inode_sb_list_del(). Does this make any sense?
>> >
>> > No, because by this stage the inode has already been removed from
>> > the superblock indoe list. Doing this sort of thing here would just
>> > paper over whatever the underlying problem might be.
>>
>>
>> For me, it looks like the inode in the cache pag->pag_ici_root
>> is not removed from sb list before removing from cache.
>
> Sure, we have list corruption. Where we detect that corruption
> implies nothing about the cause of the list corruption. The two
> events are not connected in any way. Clearing that VFS list here
> does nothing to fix the problem causing the list corruption to
> occur.

OK.

>
>> >> Please let me know if I can provide any other information.
>> >
>> > How do you reproduce the problem?
>>
>> The warning is reported via ABRT email, we don't know what was
>> happening at the time of crash.
>
> Which makes it even harder to track down. Perhaps you should
> configure the box to crashdump on such a failure and then we
> can do some post-failure forensic analysis...

Yeah.

We are trying to make kdump working, but even if kdump works
we still can't turn on panic_on_warn since this is production machine.


Thanks!
