Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Nov 2008 22:06:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA4663TK002414
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 22:06:03 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 619CCB3DBEA
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2008 22:06:02 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id rGza602q6I3dRaFU for <xfs@oss.sgi.com>; Mon, 03 Nov 2008 22:06:02 -0800 (PST)
Date: Tue, 4 Nov 2008 17:05:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Stale XFS mount for Kernel 2.6.25.14
Message-ID: <20081104060558.GA24242@disturbed>
References: <8604545CB7815D419F5FF108D3E434BA017C6427@emss04m05.us.lmco.com> <20081020230802.GA18495@disturbed> <8604545CB7815D419F5FF108D3E434BA01D4939D@emss04m05.us.lmco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8604545CB7815D419F5FF108D3E434BA01D4939D@emss04m05.us.lmco.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Ngo, Andrew" <andrew.ngo@lmco.com>
Cc: v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com, "Johnson, Je" <je.johnson@lmco.com>

On Mon, Nov 03, 2008 at 03:49:55PM -0500, Ngo, Andrew wrote:
> Hi, Dave,
> 
> Here is the captured /var/log/messages when the system is hung by the
> mount command on a xfs file system and I issued the 'echo w >
> /proc/sysrq-trigger` command.
> 
> Note that I may have run multiple times of the above command, and that I
> was also issuing the xfs_freeze commands while the mount is hung.  I
> hope that these commands does not corrupt the /var/log/message that you
> want to examine.

Summary:

It appears you have a hung NFS exported ext3 filesystem that
pdflush is stuck on holding while a superblock lock and then
sync, remount and freeze all get stuck on.

pdflush:

Nov  3 18:27:24 4003a6 kernel: pdflush       D ffffffffffffffff     0   498      2
Nov  3 18:27:24 4003a6 kernel:  ffff810246037dc0 0000000000000046 00000000ffffffff ffffffff8024413b
Nov  3 18:27:24 4003a6 kernel:  0000000000000004 ffff810247326440 ffff8102472342c0 ffff8102473267a0
Nov  3 18:27:24 4003a6 kernel:  0000000646037d60 ffffffff80226c12 0000000000000000 ffffffff80226a88
Nov  3 18:27:24 4003a6 kernel: Call Trace:
Nov  3 18:27:24 4003a6 kernel:  [<ffffffff8024413b>] bit_waitqueue+0x10/0xa3
Nov  3 18:27:24 4003a6 kernel:  [<ffffffff80226c12>] dequeue_entity+0x1b/0xd3
Nov  3 18:27:24 4003a6 kernel:  [<ffffffff80226a88>] __dequeue_entity+0x25/0x69
Nov  3 18:27:24 4003a6 kernel:  [<ffffffff80226aef>] set_next_entity+0x23/0x73
Nov  3 18:27:24 4003a6 kernel:  [<ffffffff804c4be3>] __down_read+0x71/0x8b
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8028d68e>] sync_supers+0x39/0xa4
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026ad66>] pdflush+0x0/0x1f7
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026a969>] wb_kupdate+0x2d/0x112
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026ad66>] pdflush+0x0/0x1f7
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026aeb7>] pdflush+0x151/0x1f7
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026a93c>] wb_kupdate+0x0/0x112
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802440ea>] kthread+0x47/0x75
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8022e2e4>] schedule_tail+0x28/0x5d
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8020cac8>] child_rip+0xa/0x12
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802440a3>] kthread+0x0/0x75
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8020cabe>] child_rip+0x0/0x12

Is stuck in sync_supers() here:

408         list_for_each_entry(sb, &super_blocks, s_list) {
409                 if (sb->s_dirt) {
410                         sb->s_count++;
411                         spin_unlock(&sb_lock);
412    >>>>>>>>             down_read(&sb->s_umount);
413                         write_super(sb);
414                         up_read(&sb->s_umount);


The xfs_io (freeze) command:

Nov  3 18:27:25 4003a6 kernel: xfs_io        D ffff810446c1ad80     0 30903  30883
Nov  3 18:27:25 4003a6 kernel:  ffff810178c8ddb8 0000000000000082 0000000100792e1c 00007fca13fad000
Nov  3 18:27:25 4003a6 kernel:  ffff81042ac01740 ffff81023483f660 ffff810150566c70 ffff81023483f9c0
Nov  3 18:27:25 4003a6 kernel:  0000000503c19970 ffff810301a2a1e8 00007fca13fad000 0000000000000002
Nov  3 18:27:25 4003a6 kernel: Call Trace:
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026efc7>] zone_statistics+0x3f/0x93
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026436f>] find_lock_page+0x1f/0x7f
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff804c4be3>] __down_read+0x71/0x8b
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8028d837>] get_super+0x44/0x8d
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802aa347>] freeze_bdev+0x28/0x80
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff80226a88>] __dequeue_entity+0x25/0x69
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff80337363>] xfs_ioctl+0x5a1/0x656
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff80273044>] handle_mm_fault+0x360/0x728
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff803359c8>] xfs_file_ioctl+0x28/0x58
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff80296dcd>] vfs_ioctl+0x21/0x6b
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8029705f>] do_vfs_ioctl+0x248/0x261
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802970c9>] sys_ioctl+0x51/0x70
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8020bc9b>] system_call_after_swapgs+0x7b/0x80

is stuck here:

493         list_for_each_entry(sb, &super_blocks, s_list) {
494                 if (sb->s_bdev == bdev) {
495                         sb->s_count++;
496                         spin_unlock(&sb_lock);
497   >>>>>>                down_read(&sb->s_umount);
498                         if (sb->s_root)
499                                 return sb;
500                         up_read(&sb->s_umount);

Which is probably the same place as pdflush.

The mount command:

Nov  3 18:27:25 4003a6 kernel: mount         D ffff8104460f7c00     0  8431   4967
Nov  3 18:27:25 4003a6 kernel:  ffff810283a5fdc8 0000000000000082 ffff810447045480 ffff810446c1ad80
Nov  3 18:27:25 4003a6 kernel:  ffff810447045480 ffff810441872b30 ffff8103a97869f0 ffff810441872e90
Nov  3 18:27:25 4003a6 kernel:  0000000683a5fe68 ffffffff80294ad0 000000090505097a ffff81031edc1008
Nov  3 18:27:25 4003a6 kernel: Call Trace:
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff80294ad0>] __link_path_walk+0xc45/0xd64
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8026436f>] find_lock_page+0x1f/0x7f
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff804c4b51>] __down_write_nested+0x71/0x8b
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802a05aa>] do_remount+0x6f/0xca
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802a1127>] do_mount+0x14b/0x1db
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff802a1241>] sys_mount+0x8a/0xcd
Nov  3 18:27:25 4003a6 kernel:  [<ffffffff8020bc9b>] system_call_after_swapgs+0x7b/0x80

is stuck on a down_write here:

1548 >>>>>   down_write(&sb->s_umount);
1549         if (flags & MS_BIND)
1550                 err = change_mount_flags(nd->path.mnt, flags);
1551         else
1552                 err = do_remount_sb(sb, flags, data, 0);
1553         if (!err)
1554                 nd->path.mnt->mnt_flags = mnt_flags;
1555         up_write(&sb->s_umount);

Which implies that the s_umount semaphore has leaked as none of the
blocked threads are holding that semaphore. Hmmm - later on it appears
that some nfsds get stuck doing write_inode_now on an I_SYNC flag:

Nov  3 18:28:18 4003a6 kernel: nfsd          D ffff810246cbdb70     0  5370      2
Nov  3 18:28:18 4003a6 kernel:  ffff8104345d3c80 0000000000000046 ffff8104345d3c30 ffff8104345d3d90
Nov  3 18:28:18 4003a6 kernel:  0000000000000000 ffff810434bd8180 ffff8104411e5320 ffff810434bd84e0
Nov  3 18:28:18 4003a6 kernel:  0000000000000001 ffffffff8026a133 ffff810246cbdb70 ffff8100754192a0
Nov  3 18:28:18 4003a6 kernel: Call Trace:
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8026a133>] write_cache_pages+0x261/0x2b6
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8023addd>] lock_timer_base+0x26/0x4b
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8023af22>] __mod_timer+0xb0/0xbf
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff804c3e0e>] schedule_timeout+0x8a/0xad
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8023aca4>] process_timeout+0x0/0x5
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88031426>] :jbd:journal_stop+0x92/0x18d
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff802a5b83>] __writeback_single_inode+0x17f/0x274
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff802a5cf1>] write_inode_now+0x79/0xbd
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c4b982>] :nfsd:nfsd_setattr+0x3df/0x40c
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c5202f>] :nfsd:nfsd3_proc_setattr+0x8d/0x99
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c47245>] :nfsd:nfsd_dispatch+0xde/0x1b6
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88b8d145>] :sunrpc:svc_process+0x3fe/0x6f1
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff804c4b84>] __down_read+0x12/0x8b
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c4767c>] :nfsd:nfsd+0x0/0x2b4
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c47819>] :nfsd:nfsd+0x19d/0x2b4
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8022e2e4>] schedule_tail+0x28/0x5d
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff8020cac8>] child_rip+0xa/0x12
Nov  3 18:28:18 4003a6 kernel:  [<ffffffff88c4767c>] :nfsd:nfsd+0x0/0x2b4

That makes me think there's already a process doing writeback
holding the s_umount semaphore, but rather than being stuck asleep
is spinning so is not showing up in the "blocked thread" traces. If
there a CPU running at 100% once this problem has triggered?

Also, whatever it is might show up in an all-process stack dump
rather than just block processes.  Can you issue a 'echo t >
/proc/sysrq-trigger" to show all the processes in the machine

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
