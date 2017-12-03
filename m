Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:26695
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752359AbdLCWmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 17:42:08 -0500
Date: Mon, 4 Dec 2017 09:42:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Internal error XFS_WANT_CORRUPTED_GOTO at line 3505 of file
 fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+0x35d/0x7a0 [xfs]
Message-ID: <20171203224205.GY5858@dastard>
References: <CAC=E7cXGoFiGc7GtCP3s9x9rfu9pssryVtB_FMUZaGhwHRPBYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC=E7cXGoFiGc7GtCP3s9x9rfu9pssryVtB_FMUZaGhwHRPBYw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chiluk <chiluk+linuxxfs@indeed.com>
Cc: connor+linuxxfs@indeed.com, linux-xfs@vger.kernel.org

On Fri, Dec 01, 2017 at 05:09:08PM -0600, Dave Chiluk wrote:
> We have now hit the below stack trace or a very similar stack trace roughly
> 6 times in our mesos clusters. My best guess given code analysis is that we
> are unable to allocate a new node in the allocation group btree free-list
> (*or something much weirder).  There is plenty of ram and "space" left on
> the filesystem at this point though.
> 
> vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvkernel:
> XFS (dm-4): Internal error XFS_WANT_CORRUPTED_GOTO at line 3505 of file
> fs/xfs/libxfs/xfs_btree.c. Caller xfs_free_ag_extent+0x35d/0x7a0 [xfs]
> kernel: CPU: 18 PID: 9896 Comm: mesos-slave Not tainted
> 4.10.10-1.el7.elrepo.x86_64 #1
> kernel: Hardware name: Supermicro PIO-618U-TR4T+-ST031/X10DRU-i+, BIOS 2.0
> 12/17/2015
> kernel: Call Trace:
> kernel: dump_stack+0x63/0x87
> kernel: xfs_error_report+0x3b/0x40 [xfs]
> kernel: ? xfs_free_ag_extent+0x35d/0x7a0 [xfs]
> kernel: xfs_btree_insert+0x1b0/0x1c0 [xfs]
> kernel: xfs_free_ag_extent+0x35d/0x7a0 [xfs]
> kernel: xfs_free_extent+0xbb/0x150 [xfs]
> kernel: xfs_trans_free_extent+0x4f/0x110 [xfs]
> kernel: ? xfs_trans_add_item+0x5d/0x90 [xfs]
> kernel: xfs_extent_free_finish_item+0x26/0x40 [xfs]
> kernel: xfs_defer_finish+0x149/0x410 [xfs]
> kernel: xfs_remove+0x281/0x330 [xfs]
> kernel: xfs_vn_unlink+0x55/0xa0 [xfs]
> kernel: vfs_rmdir+0xb6/0x130
> kernel: do_rmdir+0x1b3/0x1d0
> kernel: SyS_rmdir+0x16/0x20
> kernel: do_syscall_64+0x67/0x180
> kernel: entry_SYSCALL64_slow_path+0x25/0x25
> kernel: RIP: 0033:0x7f85d8d92397
> kernel: RSP: 002b:00007f85cef9b758 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000054
> kernel: RAX: ffffffffffffffda RBX: 00007f858c00b4c0 RCX: 00007f85d8d92397
> kernel: RDX: 00007f858c09ad70 RSI: 0000000000000000 RDI: 00007f858c09ad70
> kernel: RBP: 00007f85cef9bc30 R08: 0000000000000001 R09: 0000000000000002
> kernel: R10: 0000006f74656c67 R11: 0000000000000246 R12: 00007f85cef9c640
> kernel: R13: 00007f85cef9bc50 R14: 00007f85cef9bcc0 R15: 00007f85cef9bc40
> kernel: XFS (dm-4): xfs_do_force_shutdown(0x8) called from line 236 of file
> fs/xfs/libxfs/xfs_defer.c. Return address = 0xffffffffa028f087
> kernel: XFS (dm-4): Corruption of in-memory data detected. Shutting down
> filesystem
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Attempts to unmount and repair the filesystem also fail, but the error from
> the above trace was accidentally lost when the machine got re-installed.

Should unmount just fine, unless you still have apps running with
active references to the filesystems. Without xfs_repair output,
however, we have no idea whether this was caused by corruption or
some other problem.

> I found this thread
> https://www.centos.org/forums/viewtopic.php?t=15898#p75290 about someone
> hitting something similar. It was only similar in-so-much as it was an
> XFS_WANT_CORRUPTED_GOTO and he had a ton of allocation groups.  So I
> checked our allocation group count and discovered it to be 1729
> 
> vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
> $ xfs_info /dev/mapper/rootvg-var_lv
> meta-data=/dev/mapper/rootvg-var_lv isize=512 agcount=1729, agsize=163776
> blks

/me shakes his head.

That filesystem started as a 2.5GB image and was grown to 1TB on
deployment. What could possibly go wrong?

> = sectsz=512 attr=2, projid32bit=1
> = crc=1 finobt=0 spinodes=0
> data = bsize=4096 blocks=283115520, imaxpct=25
> = sunit=64 swidth=64 blks
> naming =version 2 bsize=4096 ascii-ci=0 ftype=1
> log =internal bsize=4096 blocks=2560, version=2
> = sectsz=512 sunit=64 blks, lazy-count=1
> realtime =none extsz=4096 blocks=0, rtextents=0
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This high agcount is due to the fact we deploy all of our nodes with a
> script, and then xfs_growfs the filesystem to the usable amount of space
> from there *(like pretty much every major automated deployment).  So my
> questions are.
> 1.  Has the above stack trace been seen before or solved?

If I had a dollar for every time I've seen this sort of error
report, I'd have retired years ago.....

> I could not find
> any commits to that effect

... because it's a general indicator of corruption, not necessarily
an implementation bug.

> 2.  Could this issue be the result our high number of allocation groups?

Maybe. Probably not, though. High numbers of tiny allocation groups
have other problems that really, really suck (like seeking you disks
to pieces, premature filesystem aging performance degradataion,
etc), but free space tree corruption is not one of them.

> 3.  What is the best way to deploy xfs when we know we will be immediately
> growing the filesystem?

Use xfs_copy to create, store and deploy filesystem images. That's
what it was designed for in the first place - to remove the disk
imaging bottleneck in hardware manufacturing lines 15-20 years ago.

xfs_copy gives you minimum space filesystem image storage because it
knows exactly what blocks in the filesystem contain data that needs
to be copied. It also does an efficient sparse copy onto the
destination device, and can image multiple devices with the same
golden image concurrently.

IOWs, make the golden image on a filesystem as large as you can and
image it with xfs_copy rather than making it as small as you can to
minimise the amount of empty space you have to copy with somethign
like "cp" or "dd". The difference in AG size will be substantially
larger in the xfs_copy based image and largely minimise the "grow
tiny to really large results in many AGs" vector.

I do find it kinda amusing these newfangled data center management
tools are rediscovering these well once-well-known "production line"
scale problems that were originally solved back in the 80s and 90s....

> 4.  If this is all due to the high number of allocation groups, shouldn't
> xfs_growfs at least warn when growing would result in a ridiculous number
> of allocation groups?

That doesn't stop people doing silly things, unfortunately. It just
conditions them to ignore warnings....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
