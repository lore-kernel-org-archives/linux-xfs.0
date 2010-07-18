Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6I1WasK111449 for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 20:32:36 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF49715ED9C0
	for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 18:35:34 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 2bXQ6vsruiIVF9mH
	for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 18:35:34 -0700 (PDT)
Received: by vws15 with SMTP id 15so3653631vws.26
	for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 18:35:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100718012033.GA18888@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
Date: Sat, 17 Jul 2010 21:35:33 -0400
Message-ID: <AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Jul 17, 2010 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jul 17, 2010 at 12:01:11AM -0400, Ilia Mirkin wrote:
>> Hi XFS developers,
>>
>> I ended up getting this on a 2.6.33.3 kernel. I realize this is not
>> the latest, but I've only gotten this once, so it will not be possible
>> to easily determine whether this is gone in the latest release or not.
>>
>> The details of the situation is that there is an XFS filesystem on a
>> hardware RAID10 array (directly on the device, no partition table),
>> and it exclusively houses a mysql (5.0) database. The database gets
>> backed up nightly, which is basically a glorified tar'ing of most of
>> the partition. The non-mysql process you see there are related to a
>> mysql backup program (which coincidentally triggers WARN's in xfs
>> code, as per http://marc.info/?l=3Dlinux-xfs&m=3D127632333825584&w=3D2;
>> however it sounded like those WARN's were not warning about an
>> in-kernel problems; curiously, the last WARN's in the kernel log
>> appear to have been from the prior day's backup run, not the one that
>> triggered the hang). There's also a sync that I ran as a last-ditch
>> effort at saving the system. On reboot, everything came back up OK.
>
> <sigh>
>
> That WARN_ON() is not coincidental at all. =A0I=B4ll come back to this
> later.
>
>> While the system was stuck, vmstat did not report any block-in/out on
>> the device. I have rrd's of those if necessary. Let me know if I might
>> be able to provide any other useful info, or if you think that this
>> sort of thing should be fixed in the latest linux kernel release. I
>> saw that there have been a lot of XFS updates since 2.6.33, but none
>> stood out as addressing this type of situation.
>>
>> Here is the output of "echo w > /proc/sysrq-trigger":
>>
>> =A0SysRq : Show Blocked State
>> =A0 =A0task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PC stack =A0 =
pid father
>> =A0xfsdatad/7 =A0 =A0D ffff88123885d3e0 =A06792 =A0 772 =A0 =A0 =A02 0x0=
0000000
>> =A0 ffff88123887fd90 0000000000000046 0000000000000000 ffff88123887fd5c
>> =A0 0000000000000000 000000000000de78 ffff88123887ffd8 0000000000013c00
>> =A0 ffff88123887ffd8 0000000000013c00 ffff88123885d3e0 ffff881239d23d00
>> =A0Call Trace:
>> =A0 [<ffffffff81045f9c>] ? __mod_timer+0x13d/0x14f
>> =A0 [<ffffffff814eb81c>] schedule_timeout+0x98/0xbf
>> =A0 [<ffffffff81045b27>] ? process_timeout+0x0/0xb
>> =A0 [<ffffffff814eb85c>] schedule_timeout_uninterruptible+0x19/0x1b
>> =A0 [<ffffffff81206512>] xfs_end_io+0x7d/0x8c
>> =A0 [<ffffffff8104de65>] worker_thread+0x18d/0x222
>> =A0 [<ffffffff81206495>] ? xfs_end_io+0x0/0x8c
>> =A0 [<ffffffff810517ab>] ? autoremove_wake_function+0x0/0x38
>> =A0 [<ffffffff8104dcd8>] ? worker_thread+0x0/0x222
>> =A0 [<ffffffff81051336>] kthread+0x7d/0x85
>> =A0 [<ffffffff81003814>] kernel_thread_helper+0x4/0x10
>> =A0 [<ffffffff810512b9>] ? kthread+0x0/0x85
>> =A0 [<ffffffff81003810>] ? kernel_thread_helper+0x0/0x10
>
> Waiting on IO completion - this is probably getting EAGAIN due
> to not being able to take the inode ilock....
>
>> =A0mysqld =A0 =A0 =A0 =A0D ffff880938821380 =A04696 =A07750 =A0 =A0 =A01=
 0x00000000
>> =A0 ffff880650e01cb8 0000000000000082 00715f4f00000001 0000000000000000
>> =A0 ffff88090a0bd3e0 000000000000de78 ffff880650e01fd8 0000000000013c00
>> =A0 ffff880650e01fd8 0000000000013c00 ffff88090a0bd3e0 ffff88090a0bf260
>> =A0Call Trace:
>> =A0 [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
>> =A0 [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
>> =A0 [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
>> =A0 [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
>> =A0 [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
>> =A0 [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
>> =A0 [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
>> =A0 [<ffffffff810d8813>] vfs_read+0xa8/0x102
>> =A0 [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
>> =A0 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
>
> Waiting on i_mutex, no other locks held.
>
> ....
>
>> =A0mysqld =A0 =A0 =A0 =A0D ffff880938821380 =A04648 =A07763 =A0 =A0 =A01=
 0x00000000
>> =A0 ffff8801b4febbb8 0000000000000082 ffff8801b4febb58 ffff880937ea2df8
>> =A0 000000000000de78 000000000000de78 ffff8801b4febfd8 0000000000013c00
>> =A0 ffff8801b4febfd8 0000000000013c00 ffff880937ea6ac0 ffff8812116787a0
>> =A0Call Trace:
>> =A0 [<ffffffff81027beb>] ? activate_task+0x28/0x31
>> =A0 [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
>> =A0 [<ffffffff814ec6fe>] rwsem_down_write_failed+0x20/0x2a
>> =A0 [<ffffffff812504b3>] call_rwsem_down_write_failed+0x13/0x20
>> =A0 [<ffffffff814ec005>] ? down_write+0x2d/0x31
>> =A0 [<ffffffff811ebd14>] xfs_ilock+0x23/0x94
>> =A0 [<ffffffff8120d92f>] xfs_write+0x2c5/0x784
>> =A0 [<ffffffff81034825>] ? wake_up_state+0xb/0xd
>> =A0 [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
>> =A0 [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
>> =A0 [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
>> =A0 [<ffffffff810d8624>] vfs_write+0xab/0x105
>> =A0 [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
>> =A0 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
>
> waiting on ione of the xfs inode locks in exclusive mode here =A0-
> probably holds the i_mutex too. =A0Because it's an exclusive lock we're
> waiting on here that, IIRC, will hold out any new readers, too.
> Its probably stuck because the lock is already held in shared mode.
>
> .....
>
>> =A0mysqld =A0 =A0 =A0 =A0D 0000000000000002 =A04648 =A07765 =A0 =A0 =A01=
 0x00000000
>> =A0 ffff880287b4ba78 0000000000000082 0000000000000000 0000000000000001
>> =A0 0000000000000096 000000000000de78 ffff880287b4bfd8 0000000000013c00
>> =A0 ffff880287b4bfd8 0000000000013c00 ffff880937ea2dc0 ffff88123885d3e0
>> =A0Call Trace:
>> =A0 [<ffffffff8104e062>] ? insert_work+0x92/0x9e
>> =A0 [<ffffffff8105945a>] ? ktime_get_ts+0xb1/0xbe
>> =A0 [<ffffffff814eb4b9>] io_schedule+0x7b/0xc1
>> =A0 [<ffffffff8109fc02>] sync_page+0x41/0x45
>> =A0 [<ffffffff814eb8d9>] __wait_on_bit_lock+0x45/0x8c
>> =A0 [<ffffffff8109fbc1>] ? sync_page+0x0/0x45
>> =A0 [<ffffffff8109fb84>] __lock_page+0x63/0x6a
>> =A0 [<ffffffff810517e3>] ? wake_bit_function+0x0/0x2a
>> =A0 [<ffffffff810a82de>] lock_page+0x24/0x28
>> =A0 [<ffffffff810a8364>] invalidate_inode_pages2_range+0x82/0x2af
>> =A0 [<ffffffff8120646a>] ? xfs_vm_direct_IO+0x90/0xbb
>> =A0 [<ffffffff812066a8>] ? xfs_get_blocks_direct+0x0/0x17
>> =A0 [<ffffffff812062c8>] ? xfs_end_io_direct+0x0/0x4e
>> =A0 [<ffffffff810a085d>] generic_file_direct_write+0xf5/0x14b
>> =A0 [<ffffffff8120db02>] xfs_write+0x498/0x784
>> =A0 [<ffffffff81034825>] ? wake_up_state+0xb/0xd
>> =A0 [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
>> =A0 [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
>> =A0 [<ffffffff810d8624>] vfs_write+0xab/0x105
>> =A0 [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
>> =A0 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
>
> Direct IO write waiting on page cache invalidation which is blocked
> on a locked page. i.e. it's trying to flush pages cached during
> buffered IO. =A0Holds inode iolock here shared.
>
> Also, it does not hold the i_mutex but is invalidating the page cache.
> Remember that WARN_ON() condition that I'd say I'd come back to?
> Guess what is warns about:
>
> =A0 =A0 =A0 =A0if ((ioflags & IO_ISDIRECT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mapping->nrpages) {
>>>>>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(need_i_mutex =3D=3D 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D xfs_flushinval_p=
ages(xip,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0(pos & PAGE_CACHE_MASK),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0-1, FI_REMAPF_LOCKED);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (error)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_u=
nlock_internal;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> Right - it's warning about invalidating the page cache without the
> i_mutex held. And FWIW the comment in generic_file_direct_write()
> about this invalidation during direct IO:
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Finally, try again to invalidate clean pages which migh=
t have been
> =A0 =A0 =A0 =A0 * cached by non-direct readahead, or faulted in by get_us=
er_pages()
> =A0 =A0 =A0 =A0 * if the source of the write was an mmap'ed region of the=
 file
> =A0 =A0 =A0 =A0 * we're writing. =A0Either one is a pretty crazy thing to=
 do,
> =A0 =A0 =A0 =A0 * so we don't support it 100%. =A0If this invalidation
> =A0 =A0 =A0 =A0 * fails, tough, the write still worked...
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (mapping->nrpages) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0invalidate_inode_pages2_range(mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0pos >> PAGE_CACHE_SHIFT, end);
> =A0 =A0 =A0 =A0}
>
> So the generic page cache code does not handle mixed bufered/direct
> IO to the same file concurrently with a 100% coherency guarantee.
> IOWs, just because the WARN_ON() is not being triggered, it *does not
> mean that there is no problem*.
>
>
>> =A0tar4ibd =A0 =A0 =A0 D 0000000000000000 =A04552 =A06721 =A0 6720 0x000=
00004
>> =A0 ffff88016a7c3740 0000000000000086 0000000000000000 ffff88095fc13c00
>> =A0 0000000000000001 000000000000de78 ffff88016a7c3fd8 0000000000013c00
>> =A0 ffff88016a7c3fd8 0000000000013c00 ffff8806b39344a0 ffff881239d253e0
>> =A0Call Trace:
>> =A0 [<ffffffff81034837>] ? wake_up_process+0x10/0x12
>> =A0 [<ffffffff8124c328>] ? __rwsem_do_wake+0x80/0x152
>> =A0 [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
>> =A0 [<ffffffff81244595>] ? cfq_close_cooperator+0xd9/0x184
>> =A0 [<ffffffff814ec72e>] rwsem_down_read_failed+0x26/0x30
>> =A0 [<ffffffff81250484>] call_rwsem_down_read_failed+0x14/0x30
>> =A0 [<ffffffff814ec028>] ? down_read+0x1f/0x23
>> =A0 [<ffffffff811ebd4e>] xfs_ilock+0x5d/0x94
>> =A0 [<ffffffff811ebdae>] xfs_ilock_map_shared+0x29/0x2f
>> =A0 [<ffffffff811f231b>] xfs_iomap+0x9f/0x39c
>> =A0 [<ffffffff81239215>] ? __blk_run_queue+0x4a/0x70
>> =A0 [<ffffffff81247a91>] ? cpumask_next_and+0x2b/0x3c
>> =A0 [<ffffffff812065bd>] __xfs_get_blocks+0x71/0x15c
>> =A0 [<ffffffff812066d1>] xfs_get_blocks+0x12/0x14
>> =A0 [<ffffffff810fec23>] do_mpage_readpage+0x173/0x467
>> =A0 [<ffffffff810b2234>] ? __inc_zone_page_state+0x25/0x27
>> =A0 [<ffffffff8109fecc>] ? add_to_page_cache_locked+0x82/0xc6
>> =A0 [<ffffffff810ff04a>] mpage_readpages+0xd6/0x11c
>> =A0 [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
>> =A0 [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
>> =A0 [<ffffffff81207724>] xfs_vm_readpages+0x1a/0x1c
>> =A0 [<ffffffff810a72c4>] __do_page_cache_readahead+0x10c/0x1a2
>> =A0 [<ffffffff810a7376>] ra_submit+0x1c/0x20
>> =A0 [<ffffffff810a7606>] ondemand_readahead+0x1b2/0x1c5
>> =A0 [<ffffffff810a76f3>] page_cache_sync_readahead+0x38/0x3a
>> =A0 [<ffffffff810a0e0c>] generic_file_aio_read+0x229/0x582
>> =A0 [<ffffffff8120e262>] xfs_read+0x1a3/0x1f9
>> =A0 [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
>> =A0 [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
>> =A0 [<ffffffff81032879>] ? finish_task_switch+0x43/0xac
>> =A0 [<ffffffff810d8813>] vfs_read+0xa8/0x102
>> =A0 [<ffffffff810d8931>] sys_read+0x47/0x70
>> =A0 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
>
> And there's the backup program, doing buffered readahead, holding a
> page locked and stuck trying to get the xfs inode ilock. i.e. this
> trace shows your system has tripped over the exact case that the
> above code says is "a pretty crazy thing to do". IOWs, this is not
> an XFS specific problem.
>
> I can't find a thread that holds the XFS inode lock that everything
> is waiting on. I think it is the ILOCK, but none of the threads in
> this trace should be holding it where they are blocked. IOWs, the
> output does not give me enough information to get to the root cause.

In case this happens again, was there something more useful I could
have collected? Should I have grabbed all task states?

> So, back to the situation with the WARN_ON(). You're running
> applications that are doing something that:
>
> =A0 =A0 =A0 =A0a) is not supported;
> =A0 =A0 =A0 =A0b) compromises data integrity guarantees;
> =A0 =A0 =A0 =A0c) is not reliably reported; and
> =A0 =A0 =A0 =A0d) might be causing hangs
>
> Right now I'm not particularly inclined to dig into this further;
> it's obvious the applications are doing something that is not
> supported (by XFS or the generic page cache code), so this is the
> first thing you really need to care about getting fixed if you value
> your backups...

Thanks for the analysis. I will try to switch off O_DIRECT from mysql
-- it sounds like that should solve all of these problems. In the
earlier thread, it sounded like the WARN was harmless from an OS
standpoint, and the backups were checking out fine.

It's pretty obvious that allowing userspace to hang the FS is really
bad, but I appreciate that the app is doing something that the kernel
didn't expect.

Thanks again,

--
Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
