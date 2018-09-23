Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38539 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbeIWPvu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Sep 2018 11:51:50 -0400
Received: by mail-lf1-f68.google.com with SMTP id z186-v6so14330990lfa.5
        for <linux-xfs@vger.kernel.org>; Sun, 23 Sep 2018 02:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAMp4zn_YQy+Naggwfu5-aKigyx6rJJ27F7fdL=tRponn8Kug=A@mail.gmail.com>
 <20171001224904.GG3666@dastard> <CAOQ4uxgqjhnn8FOfkZAruigQcewNFewhGZ_jnj24RG4mNu5MZQ@mail.gmail.com>
 <20171007225449.GW3666@dastard>
In-Reply-To: <20171007225449.GW3666@dastard>
From: =?UTF-8?B?5byg5pys6b6Z?= <zbl.lkml@gmail.com>
Date: Sun, 23 Sep 2018 17:54:38 +0800
Message-ID: <CAJDdQW1pLDgPjBpx8RGmT-n4uq+2tP94zmABTN7oBKUEnd7A5A@mail.gmail.com>
Subject: Re: XFS AIL lockup
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: amir73il@gmail.com, sargun@sargun.me, linux-xfs@vger.kernel.org

Hi Dave,

May I ask if the problem has been fixed? It's encountered on our
3.10.0-514.16.1.el7.x86_64 production environment too.

INFO: task fps_producer:25329 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
fps_producer    D 0000000000000000     0 25329  16863 0x00000104
 ffff883a8579f720 0000000000000082 ffff882fb3d88fb0 ffff883a8579ffd8
 ffff883a8579ffd8 ffff883a8579ffd8 ffff882fb3d88fb0 ffff88003693c1b0
 7fffffffffffffff ffff882fb3d88fb0 0000000000000002 0000000000000000
Call Trace:
 [<ffffffff8168c169>] schedule+0x29/0x70
 [<ffffffff81689bc9>] schedule_timeout+0x239/0x2c0
 [<ffffffff810d060c>] ? enqueue_entity+0x26c/0xb60
 [<ffffffff810c1128>] ? resched_task+0xb8/0xd0
 [<ffffffff810cbff9>] ? wakeup_gran.isra.53+0x29/0x30
 [<ffffffff810cf5b8>] ? check_preempt_wakeup+0x148/0x250
 [<ffffffff8168b438>] __down_common+0x108/0x154
 [<ffffffffa046eba6>] ? _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffff8168b4a1>] __down+0x1d/0x1f
 [<ffffffff810b6971>] down+0x41/0x50
 [<ffffffffa046e99c>] xfs_buf_lock+0x3c/0xd0 [xfs]
 [<ffffffffa046eba6>] _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffffa046ed9a>] xfs_buf_get_map+0x2a/0x240 [xfs]
 [<ffffffffa046f910>] xfs_buf_read_map+0x30/0x160 [xfs]
 [<ffffffffa049f1f1>] xfs_trans_read_buf_map+0x211/0x400 [xfs]
 [<ffffffffa045f35d>] xfs_read_agi+0x9d/0x110 [xfs]
 [<ffffffffa047f99b>] xfs_iunlink_remove+0x5b/0x3c0 [xfs]
 [<ffffffff8119f8da>] ? kvfree+0x2a/0x40
 [<ffffffff8108dc82>] ? current_fs_time+0x12/0x60
 [<ffffffffa049fabe>] ? xfs_trans_ichgtime+0x1e/0xa0 [xfs]
 [<ffffffffa048413f>] xfs_rename+0x5ff/0x900 [xfs]
 [<ffffffff815b4c90>] ? ip_copy_metadata+0x170/0x170
 [<ffffffffa047df50>] xfs_vn_rename+0xb0/0xf0 [xfs]
 [<ffffffff8120ee31>] vfs_rename+0x621/0x860
 [<ffffffffa047dea0>] ? xfs_vn_follow_link+0xa0/0xa0 [xfs]
 [<ffffffffa03d7c9b>] ovl_do_rename+0x3b/0xa0 [overlay]
 [<ffffffffa03d8d91>] ovl_rename2+0x651/0x7e0 [overlay]
 [<ffffffff8120ee31>] vfs_rename+0x621/0x860
 [<ffffffffa03d8740>] ? ovl_check_empty_and_clear+0x90/0x90 [overlay]
 [<ffffffff8120ff73>] SYSC_renameat2+0x4d3/0x570
 [<ffffffff81588485>] ? sk_run_filter+0x2c5/0x760
 [<ffffffff810f808e>] ? do_futex+0xfe/0x5b0
 [<ffffffff81137033>] ? __secure_computing+0x73/0x240
 [<ffffffff810392ed>] ? syscall_trace_enter+0x17d/0x220
 [<ffffffff81210dce>] SyS_renameat2+0xe/0x10
 [<ffffffff81210de1>] SyS_renameat+0x11/0x20

INFO: task bff:22499 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
bff             D 0000000000000000     0 22499  19300 0x00000104
 ffff882a13b1b0a0 0000000000000086 ffff881590a80000 ffff882a13b1bfd8
 ffff882a13b1bfd8 ffff882a13b1bfd8 ffff881590a80000 ffff883ff76acdb0
 7fffffffffffffff ffff881590a80000 0000000000000002 0000000000000000
Call Trace:
 [<ffffffff8168c169>] schedule+0x29/0x70
 [<ffffffff81689bc9>] schedule_timeout+0x239/0x2c0
 [<ffffffff8168b438>] __down_common+0x108/0x154
 [<ffffffffa046eba6>] ? _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffff8168b4a1>] __down+0x1d/0x1f
 [<ffffffff810b6971>] down+0x41/0x50
 [<ffffffffa046e99c>] xfs_buf_lock+0x3c/0xd0 [xfs]
 [<ffffffffa046eba6>] _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffffa046ed9a>] xfs_buf_get_map+0x2a/0x240 [xfs]
 [<ffffffffa046f910>] xfs_buf_read_map+0x30/0x160 [xfs]
 [<ffffffffa049f1f1>] xfs_trans_read_buf_map+0x211/0x400 [xfs]
 [<ffffffffa0430783>] xfs_read_agf+0x93/0x110 [xfs]
 [<ffffffffa043084b>] xfs_alloc_read_agf+0x4b/0x110 [xfs]
 [<ffffffffa0430c5b>] xfs_alloc_fix_freelist+0x34b/0x410 [xfs]
 [<ffffffff810ce3e1>] ? update_curr+0x71/0x190
 [<ffffffff8131e8dd>] ? radix_tree_lookup+0xd/0x10
 [<ffffffffa046450a>] ? xfs_perag_get+0x2a/0xb0 [xfs]
 [<ffffffff8131e8dd>] ? radix_tree_lookup+0xd/0x10
 [<ffffffffa046450a>] ? xfs_perag_get+0x2a/0xb0 [xfs]
 [<ffffffffa0430f83>] xfs_alloc_vextent+0x203/0x5f0 [xfs]
 [<ffffffffa0441603>] xfs_bmap_btalloc+0x3f3/0x780 [xfs]
 [<ffffffffa044199e>] xfs_bmap_alloc+0xe/0x10 [xfs]
 [<ffffffffa04423d9>] xfs_bmapi_write+0x499/0xab0 [xfs]
 [<ffffffffa044d86a>] xfs_da_grow_inode_int+0xba/0x300 [xfs]
 [<ffffffffa04512b8>] xfs_dir2_grow_inode+0x68/0x130 [xfs]
 [<ffffffffa04535be>] xfs_dir2_sf_to_block+0xae/0x5f0 [xfs]
 [<ffffffffa047f524>] ? xfs_setup_inode+0x134/0x2f0 [xfs]
 [<ffffffffa045b25a>] xfs_dir2_sf_addname+0xca/0x590 [xfs]
 [<ffffffffa048e877>] ? kmem_alloc+0x97/0x130 [xfs]
 [<ffffffffa0451608>] xfs_dir_createname+0x198/0x1f0 [xfs]
 [<ffffffffa0482024>] xfs_create+0x2f4/0x6e0 [xfs]
 [<ffffffffa047e5fb>] xfs_vn_mknod+0xbb/0x250 [xfs]
 [<ffffffffa047e7c3>] xfs_vn_create+0x13/0x20 [xfs]
 [<ffffffff8120b1ad>] vfs_create+0xcd/0x130
 [<ffffffffa03d8233>] ovl_create_real+0xb3/0x250 [overlay]
 [<ffffffffa03d9bbc>] ovl_create_or_link.part.4+0xfc/0x290 [overlay]
 [<ffffffffa03d9e54>] ovl_create_object+0x104/0x120 [overlay]
 [<ffffffffa03d9f23>] ovl_create+0x23/0x30 [overlay]
 [<ffffffff8120b1ad>] vfs_create+0xcd/0x130
 [<ffffffff8120db7f>] do_last+0xbef/0x12a0
 [<ffffffff8120e2f2>] path_openat+0xc2/0x490
 [<ffffffff815545ef>] ? sock_destroy_inode+0x2f/0x40
 [<ffffffff8121046b>] do_filp_open+0x4b/0xb0
 [<ffffffff8121d0e7>] ? __alloc_fd+0xa7/0x130
 [<ffffffff811fd973>] do_sys_open+0xf3/0x1f0
 [<ffffffff810392ed>] ? syscall_trace_enter+0x17d/0x220
 [<ffffffff811fdaa4>] SyS_openat+0x14/0x20
 [<ffffffff81697392>] tracesys+0xdd/0xe2

And once the rename agf->agi and create agi->agf has locked up, other
processes start to pile on agi too.

INFO: task dispatch:26819 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dispatch        D 0000000000000000     0 26819  16778 0x00000104
 ffff883562f5f560 0000000000000082 ffff8828fc2e0000 ffff883562f5ffd8
 ffff883562f5ffd8 ffff883562f5ffd8 ffff8828fc2e0000 ffff881ffaed1230
 7fffffffffffffff ffff8828fc2e0000 0000000000000002 0000000000000000
Call Trace:
 [<ffffffff8168c169>] schedule+0x29/0x70
 [<ffffffff81689bc9>] schedule_timeout+0x239/0x2c0
 [<ffffffff810ce3e1>] ? update_curr+0x71/0x190
 [<ffffffff810ce7f9>] ? update_cfs_shares+0xa9/0xf0
 [<ffffffff810ce3e1>] ? update_curr+0x71/0x190
 [<ffffffff8168b438>] __down_common+0x108/0x154
 [<ffffffffa046eba6>] ? _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffff8168b4a1>] __down+0x1d/0x1f
 [<ffffffff810b6971>] down+0x41/0x50
 [<ffffffffa046e99c>] xfs_buf_lock+0x3c/0xd0 [xfs]
 [<ffffffffa046eba6>] _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffffa046ed9a>] xfs_buf_get_map+0x2a/0x240 [xfs]
 [<ffffffff810c9ba8>] ? __enqueue_entity+0x78/0x80
 [<ffffffffa046f910>] xfs_buf_read_map+0x30/0x160 [xfs]
 [<ffffffffa049f1f1>] xfs_trans_read_buf_map+0x211/0x400 [xfs]
 [<ffffffffa045f35d>] xfs_read_agi+0x9d/0x110 [xfs]
 [<ffffffffa045f404>] xfs_ialloc_read_agi+0x34/0xd0 [xfs]
 [<ffffffffa045fe58>] xfs_dialloc+0xe8/0x280 [xfs]
 [<ffffffffa0481611>] xfs_ialloc+0x71/0x550 [xfs]
 [<ffffffffa0481b63>] xfs_dir_ialloc+0x73/0x1f0 [xfs]
 [<ffffffffa048325e>] xfs_create_tmpfile+0x26e/0x380 [xfs]
 [<ffffffffa0483ea3>] xfs_rename+0x363/0x900 [xfs]
 [<ffffffffa0480624>] ? xfs_iunlock+0x104/0x130 [xfs]
 [<ffffffff81216872>] ? __d_instantiate+0x92/0x100
 [<ffffffff81114b32>] ? from_kgid+0x12/0x20
 [<ffffffff812a8a78>] ? security_capable+0x18/0x20
 [<ffffffff81114b32>] ? from_kgid+0x12/0x20
 [<ffffffff810937ef>] ? capable_wrt_inode_uidgid+0x5f/0x70
 [<ffffffffa047df50>] xfs_vn_rename+0xb0/0xf0 [xfs]
 [<ffffffff8120ee31>] vfs_rename+0x621/0x860
 [<ffffffffa047dea0>] ? xfs_vn_follow_link+0xa0/0xa0 [xfs]
 [<ffffffffa03d7c9b>] ovl_do_rename+0x3b/0xa0 [overlay]
 [<ffffffffa03d8d91>] ovl_rename2+0x651/0x7e0 [overlay]
 [<ffffffff8120ee31>] vfs_rename+0x621/0x860

INFO: task redis-server:21536 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
redis-server    D 0000000000000000     0 21536  24452 0x00000104
 ffff881ab6fd3550 0000000000000086 ffff8825a2738000 ffff881ab6fd3fd8
 ffff881ab6fd3fd8 ffff881ab6fd3fd8 ffff8825a2738000 ffff883fddbbe730
 7fffffffffffffff ffff8825a2738000 0000000000000002 0000000000000000
Call Trace:
 [<ffffffff8168c169>] schedule+0x29/0x70
 [<ffffffff81689bc9>] schedule_timeout+0x239/0x2c0
 [<ffffffff8168b438>] __down_common+0x108/0x154
 [<ffffffffa046eba6>] ? _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffff8168b4a1>] __down+0x1d/0x1f
 [<ffffffff810b6971>] down+0x41/0x50
 [<ffffffffa046e99c>] xfs_buf_lock+0x3c/0xd0 [xfs]
 [<ffffffffa046eba6>] _xfs_buf_find+0x176/0x340 [xfs]
 [<ffffffffa046ed9a>] xfs_buf_get_map+0x2a/0x240 [xfs]
 [<ffffffffa046f910>] xfs_buf_read_map+0x30/0x160 [xfs]
 [<ffffffffa049f1f1>] xfs_trans_read_buf_map+0x211/0x400 [xfs]
 [<ffffffffa045f35d>] xfs_read_agi+0x9d/0x110 [xfs]
systemd-journald[726]: /dev/kmsg buffer overrun, some messages lost.
 [<ffffffffa045f404>] xfs_ialloc_read_agi+0x34/0xd0 [xfs]
 [<ffffffffa045fe58>] xfs_dialloc+0xe8/0x280 [xfs]
 [<ffffffffa0481611>] xfs_ialloc+0x71/0x550 [xfs]
 [<ffffffffa0481b63>] xfs_dir_ialloc+0x73/0x1f0 [xfs]
 [<ffffffffa0481fab>] xfs_create+0x27b/0x6e0 [xfs]
 [<ffffffffa047e5fb>] xfs_vn_mknod+0xbb/0x250 [xfs]
 [<ffffffffa047e7c3>] xfs_vn_create+0x13/0x20 [xfs]
 [<ffffffff8120b1ad>] vfs_create+0xcd/0x130
 [<ffffffffa03d8233>] ovl_create_real+0xb3/0x250 [overlay]
 [<ffffffffa03d9bbc>] ovl_create_or_link.part.4+0xfc/0x290 [overlay]
 [<ffffffffa03d9e54>] ovl_create_object+0x104/0x120 [overlay]
 [<ffffffffa03d9f23>] ovl_create+0x23/0x30 [overlay]
 [<ffffffff8120b1ad>] vfs_create+0xcd/0x130
 [<ffffffff8120db7f>] do_last+0xbef/0x12a0
systemd-journald[726]: /dev/kmsg buffer overrun, some messages lost.
 [<ffffffff8120e2f2>] path_openat+0xc2/0x490
 [<ffffffff81180b9b>] ? unlock_page+0x2b/0x30
 [<ffffffff8121046b>] do_filp_open+0x4b/0xb0
 [<ffffffff8121d0e7>] ? __alloc_fd+0xa7/0x130
 [<ffffffff811fd973>] do_sys_open+0xf3/0x1f0
 [<ffffffff810392ed>] ? syscall_trace_enter+0x17d/0x220
 [<ffffffff811fda8e>] SyS_open+0x1e/0x20

Cannot find info other places so just wanna confirm.

Thanks,
Benlong
Dave Chinner <david@fromorbit.com> =E4=BA=8E2017=E5=B9=B410=E6=9C=888=E6=97=
=A5=E5=91=A8=E6=97=A5 =E4=B8=8A=E5=8D=886:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Oct 06, 2017 at 03:29:01PM +0300, Amir Goldstein wrote:
> > On Mon, Oct 2, 2017 at 1:49 AM, Dave Chinner <david@fromorbit.com> wrot=
e:
> > > On Sun, Oct 01, 2017 at 03:10:03PM -0700, Sargun Dhillon wrote:
> > >> I'm running into an issue where xfs aild is locking up. This is on
> > >> kernel version 4.9.34. It's an SMP system with 32 cores, and ~250G o=
f
> > >> RAM (AWS R4.8XL) and an XFS filesystem with 1 SSD with project ID
> > >> quotas in use. It's the only XFS filesystem on the host. The root
> > >> partition is running EXT4, and isn't involved in this.
> > >>
> > >> There are containers that use overlayfs atop this filesystem. It loo=
ks
> > >> like one of the processes (10090, or 11504) has gotten into a state
> > >> where it's holding a lock on a xfs_buf, and they're trying to lock
> > >> xfs_buf's which are currently on the xfs ail list.
> > >>
> > ...
> > > Ok, this is a RENAME_WHITEOUT case, and that points to the issue.
> > > The whiteout inode is allocated as a temporary inode, which means
> > > it remains on the unlinked list so that if we crash part way through
> > > the update log recovery will free it again.
> > >
> > > Once all the dirent updates and other rename work is done, we remove
> > > the whiteout inode from the unlinked list, and that requires
> > > grabbing the AGI lock. That's what we are stuck on here.
> > >
> > ...
> > >
> > > Because this is the deadlock - we're trying to lock the AGF with an
> > > AGI already locked. That means the above RENAME_WHITEOUT has either
> > > allocated or freed extents in manipulating the dirents during
> > > rename, and so holds an AGF locked. It's a classic ABBA deadlock.
> > >
> > > That's the problem, not sure what the solution is yet - there's no
> > > obvious or simple way around this RENAME_WHITEOUT behaviour (which
> > > only affects overlay, fwiw). I'll have a think about it.
> > >
> >
> > Dave,
> >
> > Could you explain why the RENAME_WHITEOUT case is different locking
> > order wise from linking an O_TEMPFILE?
>
> RENAME_WHITEOUT creates an O_TMPFILE inode in the form or a whiteout
> device node in an initial separate transaction, which is fine as
> this uses the normal AGI->AGF lock order. This is so if we crash
> while doing the rename, log recovery will free the (now unused)
> whiteout device node.
>
> We then use the O_TMPFILE inode in the rename, which does all the
> directory mods, which take the AGF lock to allocate directory
> blocks. Then it removes the O_TMPFILE inode from the unlinked list
> because it's now referenced by a directory which takes the AGI lock.
>
>
> > Is it because xfs_iunlink_remove() is called before xfs_dir_createname(=
)
> > in xfs_link()?
>
> Yes, and gives the lock order AGI->AGF.
>
> > Also, in xfs_rename(), before removing whiteout inode from unlinked lis=
t,
> > the comment says: "If we fail here after bumping the link
> >          * count, we're shutting down the filesystem so we'll never see=
 the
> >          * intermediate state on disk.",
> > but I am not actually seeing where that shutdown takes place, or maybe
> > I don't know what to look for.
>
> Say, for example, the journal commit fails. That'll shut down the
> filesystem.
>
> The reason for doing the xfs_iunlink_remove() call last is that
> if we get a failure to modify a directory entry (e.g. we're at
> ENOSPC) before we've dirtied anything in the directories, we'll end
> up cancelling a dirty transaction and that will shut down the
> filesystem. On failures that should just return an error, we have
> to put the inode back on the unlinked list so we can commit the
> dirty transaction and return the error. It quickly becomes very
> nasty trying to work out all the different error paths and exactly
> which ones are fatal (i.e. trigger a shutdown) and those that need
> to (and can) put the inode back on the unlinked list successfully
> and commit the transaction so things can proceed.
>
> Ideally we need to make the unlinked list removal a deferred op
> (i.e. log an intent and then do it after the RENAME_WHITEOUT
> transaction has committed). That would leave the error handling
> simple and get rid of the lock order problem because it would move
> the unlinked list removal to it's own transaction....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
