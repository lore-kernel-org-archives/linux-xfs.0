Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32123 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751221AbcJIVwU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2016 17:52:20 -0400
Date: Mon, 10 Oct 2016 08:51:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
Message-ID: <20161009215146.GL9806@dastard>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com>
 <20161005153014.GC26977@htj.duckdns.org>
 <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com>
 <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com>
 <20161005200522.GE19539@ZenIV.linux.org.uk>
 <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
 <1860793605.807021.1475756759147.JavaMail.zimbra@redhat.com>
 <20161007070838.GA16260@quack2.suse.cz>
 <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1720038662.1062048.1475851398433.JavaMail.zimbra@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: CAI Qian <caiqian@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>, tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Dave Jones <davej@codemonkey.org.uk>

On Fri, Oct 07, 2016 at 10:43:18AM -0400, CAI Qian wrote:
> Hmm, this round of trinity triggered a different hang.
> 
> [ 2094.487964]  [<ffffffff813e27b7>] call_rwsem_down_write_failed+0x17/0x30
> [ 2094.495450]  [<ffffffff817d1bff>] down_write+0x5f/0x80
> [ 2094.508284]  [<ffffffff8127e301>] chown_common.isra.12+0x131/0x1e0
> [ 2094.553784] 2 locks held by trinity-c0/3126:
> [ 2094.558552]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 2094.568240]  #1:  (&sb->s_type->i_mutex_key#17){++++++}, at: [<ffffffff8127e301>] chown_common.isra.12+0x131/0x1e0

Waiting on i_mutex.

> [ 2094.643597]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2094.665119]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2094.691133]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2094.721844] 1 lock held by trinity-c1/3127:
> [ 2094.726515]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]

Waiting on i_ilock.

> [ 2094.808078]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2094.820715]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
> [ 2094.826544]  [<ffffffff81297f53>] SyS_getdents+0x83/0x140
> [ 2094.856682]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50

concurrent readdir on the same directory fd, blocked on fd.

> [ 2094.936885]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2094.956620]  [<ffffffff812a5313>] __fdget_pos+0x43/0x50
> [ 2094.962454]  [<ffffffff81298091>] SyS_getdents64+0x81/0x130
> [ 2094.988204] 1 lock held by trinity-c3/3129:
> [ 2094.992872]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50

Same.

> [ 2095.073118]  [<ffffffff817cf4df>] mutex_lock_nested+0x19f/0x450
> [ 2095.091589]  [<ffffffff812811dd>] SyS_lseek+0x1d/0xb0
> [ 2095.097229]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.110547] 1 lock held by trinity-c4/3130:
> [ 2095.115216]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff812a5313>] __fdget_pos+0x43/0x50

Concurrent lseek on directory fd, blocked on fd.


> [ 2095.188230]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.223558]  [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]
> [ 2095.229894]  [<ffffffffa03337d4>] xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
> [ 2095.237682]  [<ffffffffa02ccfaf>] xfs_attr_get+0xdf/0x1b0 [xfs]
> [ 2095.244312]  [<ffffffffa0341bfc>] xfs_xattr_get+0x4c/0x70 [xfs]
> [ 2095.250924]  [<ffffffff812ad269>] generic_getxattr+0x59/0x70
> [ 2095.257244]  [<ffffffff812acf9b>] vfs_getxattr+0x8b/0xb0
> [ 2095.263177]  [<ffffffffa0435bd6>] ovl_xattr_get+0x46/0x60 [overlay]
> [ 2095.270176]  [<ffffffffa04331aa>] ovl_other_xattr_get+0x1a/0x20 [overlay]
> [ 2095.277756]  [<ffffffff812ad269>] generic_getxattr+0x59/0x70
> [ 2095.284079]  [<ffffffff81345e9e>] cap_inode_need_killpriv+0x2e/0x40
> [ 2095.291078]  [<ffffffff81349a33>] security_inode_need_killpriv+0x33/0x50
> [ 2095.298560]  [<ffffffff812a2fb0>] dentry_needs_remove_privs+0x30/0x50
> [ 2095.305743]  [<ffffffff8127ea21>] do_truncate+0x51/0xc0
> [ 2095.311581]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
> [ 2095.318094]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
> [ 2095.324609]  [<ffffffff8127edde>] do_sys_ftruncate.constprop.15+0xfe/0x160
> [ 2095.332286]  [<ffffffff8127ee7e>] SyS_ftruncate+0xe/0x10
> [ 2095.338225]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
> [ 2095.344339]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25
> [ 2095.351531] 2 locks held by trinity-c5/3131:
> [ 2095.356297]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 2095.365983]  #1:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]

truncate on overlay, removing xattrs from XFS file, blocked on
i_ilock.

> [ 2095.440372]  [<ffffffff817d2782>] rwsem_down_write_failed+0x242/0x4b0
> [ 2095.474300]  [<ffffffff8127e413>] chmod_common+0x63/0x150
> [ 2095.513452] 2 locks held by trinity-c6/3132:
> [ 2095.518217]  #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff81284be1>] __sb_start_write+0xd1/0xf0
> [ 2095.527895]  #1:  (&sb->s_type->i_mutex_key#17){++++++}, at: [<ffffffff8127e413>] chmod_common+0x63/0x150

chmod, blocked on i_mutex.

> [ 2095.602379]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.616490]  [<ffffffff813e2788>] call_rwsem_down_read_failed+0x18/0x30
> [ 2095.623877]  [<ffffffff810f8b0b>] down_read_nested+0x5b/0x80
> [ 2095.649889]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2095.680610] 1 lock held by trinity-c7/3133:
> [ 2095.685281]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]

fsync on file, blocked on i_ilock.

> [ 2095.759662]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.807155]  [<ffffffff812bdbbd>] vfs_fsync_range+0x3d/0xb0
> [ 2095.813377]  [<ffffffff812bdc8d>] do_fsync+0x3d/0x70
> [ 2095.818921]  [<ffffffff812bdf63>] SyS_fdatasync+0x13/0x20
> [ 2095.838261] 1 lock held by trinity-c8/3135:
> [ 2095.842930]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]

ditto.

> [ 2095.917305]  [<ffffffff817d24b7>] rwsem_down_read_failed+0x107/0x190
> [ 2095.958968]  [<ffffffffa0333790>] xfs_ilock_data_map_shared+0x30/0x40 [xfs]
> [ 2095.966752]  [<ffffffffa03128c6>] __xfs_get_blocks+0x96/0x9d0 [xfs]
> [ 2095.989413]  [<ffffffffa0313214>] xfs_get_blocks+0x14/0x20 [xfs]
> [ 2095.996122]  [<ffffffff812cca44>] do_mpage_readpage+0x474/0x800
> [ 2096.029678]  [<ffffffff812ccf0d>] mpage_readpages+0x13d/0x1b0
> [ 2096.050724]  [<ffffffffa0311f14>] xfs_vm_readpages+0x54/0x170 [xfs]
> [ 2096.057724]  [<ffffffff811f1a1d>] __do_page_cache_readahead+0x2ad/0x370
> [ 2096.079787]  [<ffffffff811f2014>] force_page_cache_readahead+0x94/0xf0
> [ 2096.087077]  [<ffffffff811f2168>] SyS_readahead+0xa8/0xc0
> [ 2096.106427] 1 lock held by trinity-c9/3136:
> [ 2096.111097]  #0:  (&xfs_nondir_ilock_class){++++..}, at: [<ffffffffa03335fa>] xfs_ilock+0xfa/0x260 [xfs]

readhead blocking in i_ilock before reading in extents.

Nothing here indicates a deadlock. Everything is waiting for locks,
but nothing is holding locks in a way that indicates that progress
is not being made. This sort of thing can happen when slow storage
is massively overloaded - sysrq-w is really the only way to get a
better picutre of what is happening here, but so far there's no
concrete evidence of a hang from this output.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
