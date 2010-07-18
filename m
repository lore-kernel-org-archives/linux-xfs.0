Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6I1HfvL110880 for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 20:17:41 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1F0B119987C
	for <xfs@oss.sgi.com>; Sat, 17 Jul 2010 18:27:06 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	DDvtrO4Z02Wb3dE7 for <xfs@oss.sgi.com>;
	Sat, 17 Jul 2010 18:27:06 -0700 (PDT)
Date: Sun, 18 Jul 2010 11:20:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
Message-ID: <20100718012033.GA18888@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
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
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: xfs@oss.sgi.com

On Sat, Jul 17, 2010 at 12:01:11AM -0400, Ilia Mirkin wrote:
> Hi XFS developers,
> =

> I ended up getting this on a 2.6.33.3 kernel. I realize this is not
> the latest, but I've only gotten this once, so it will not be possible
> to easily determine whether this is gone in the latest release or not.
> =

> The details of the situation is that there is an XFS filesystem on a
> hardware RAID10 array (directly on the device, no partition table),
> and it exclusively houses a mysql (5.0) database. The database gets
> backed up nightly, which is basically a glorified tar'ing of most of
> the partition. The non-mysql process you see there are related to a
> mysql backup program (which coincidentally triggers WARN's in xfs
> code, as per http://marc.info/?l=3Dlinux-xfs&m=3D127632333825584&w=3D2;
> however it sounded like those WARN's were not warning about an
> in-kernel problems; curiously, the last WARN's in the kernel log
> appear to have been from the prior day's backup run, not the one that
> triggered the hang). There's also a sync that I ran as a last-ditch
> effort at saving the system. On reboot, everything came back up OK.

<sigh>

That WARN_ON() is not coincidental at all.  I=B4ll come back to this
later.

> While the system was stuck, vmstat did not report any block-in/out on
> the device. I have rrd's of those if necessary. Let me know if I might
> be able to provide any other useful info, or if you think that this
> sort of thing should be fixed in the latest linux kernel release. I
> saw that there have been a lot of XFS updates since 2.6.33, but none
> stood out as addressing this type of situation.
> =

> Here is the output of "echo w > /proc/sysrq-trigger":
> =

>  SysRq : Show Blocked State
>    task                        PC stack   pid father
>  xfsdatad/7    D ffff88123885d3e0  6792   772      2 0x00000000
>   ffff88123887fd90 0000000000000046 0000000000000000 ffff88123887fd5c
>   0000000000000000 000000000000de78 ffff88123887ffd8 0000000000013c00
>   ffff88123887ffd8 0000000000013c00 ffff88123885d3e0 ffff881239d23d00
>  Call Trace:
>   [<ffffffff81045f9c>] ? __mod_timer+0x13d/0x14f
>   [<ffffffff814eb81c>] schedule_timeout+0x98/0xbf
>   [<ffffffff81045b27>] ? process_timeout+0x0/0xb
>   [<ffffffff814eb85c>] schedule_timeout_uninterruptible+0x19/0x1b
>   [<ffffffff81206512>] xfs_end_io+0x7d/0x8c
>   [<ffffffff8104de65>] worker_thread+0x18d/0x222
>   [<ffffffff81206495>] ? xfs_end_io+0x0/0x8c
>   [<ffffffff810517ab>] ? autoremove_wake_function+0x0/0x38
>   [<ffffffff8104dcd8>] ? worker_thread+0x0/0x222
>   [<ffffffff81051336>] kthread+0x7d/0x85
>   [<ffffffff81003814>] kernel_thread_helper+0x4/0x10
>   [<ffffffff810512b9>] ? kthread+0x0/0x85
>   [<ffffffff81003810>] ? kernel_thread_helper+0x0/0x10

Waiting on IO completion - this is probably getting EAGAIN due
to not being able to take the inode ilock....

>  mysqld        D ffff880938821380  4696  7750      1 0x00000000
>   ffff880650e01cb8 0000000000000082 00715f4f00000001 0000000000000000
>   ffff88090a0bd3e0 000000000000de78 ffff880650e01fd8 0000000000013c00
>   ffff880650e01fd8 0000000000013c00 ffff88090a0bd3e0 ffff88090a0bf260
>  Call Trace:
>   [<ffffffff814ebc5a>] __mutex_lock_common+0x139/0x1a2
>   [<ffffffff814ebcd7>] __mutex_lock_slowpath+0x14/0x16
>   [<ffffffff814ebda5>] mutex_lock+0x1e/0x35
>   [<ffffffff8120e1bf>] xfs_read+0x100/0x1f9
>   [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
>   [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
>   [<ffffffff8102832b>] ? pick_next_task+0x22/0x3e
>   [<ffffffff810d8813>] vfs_read+0xa8/0x102
>   [<ffffffff810d88c9>] sys_pread64+0x5c/0x7d
>   [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b

Waiting on i_mutex, no other locks held.

....

>  mysqld        D ffff880938821380  4648  7763      1 0x00000000
>   ffff8801b4febbb8 0000000000000082 ffff8801b4febb58 ffff880937ea2df8
>   000000000000de78 000000000000de78 ffff8801b4febfd8 0000000000013c00
>   ffff8801b4febfd8 0000000000013c00 ffff880937ea6ac0 ffff8812116787a0
>  Call Trace:
>   [<ffffffff81027beb>] ? activate_task+0x28/0x31
>   [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
>   [<ffffffff814ec6fe>] rwsem_down_write_failed+0x20/0x2a
>   [<ffffffff812504b3>] call_rwsem_down_write_failed+0x13/0x20
>   [<ffffffff814ec005>] ? down_write+0x2d/0x31
>   [<ffffffff811ebd14>] xfs_ilock+0x23/0x94
>   [<ffffffff8120d92f>] xfs_write+0x2c5/0x784
>   [<ffffffff81034825>] ? wake_up_state+0xb/0xd
>   [<ffffffff814ecb8e>] ? common_interrupt+0xe/0x13
>   [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
>   [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
>   [<ffffffff810d8624>] vfs_write+0xab/0x105
>   [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
>   [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b

waiting on ione of the xfs inode locks in exclusive mode here  -
probably holds the i_mutex too.  Because it's an exclusive lock we're
waiting on here that, IIRC, will hold out any new readers, too.
Its probably stuck because the lock is already held in shared mode.

.....

>  mysqld        D 0000000000000002  4648  7765      1 0x00000000
>   ffff880287b4ba78 0000000000000082 0000000000000000 0000000000000001
>   0000000000000096 000000000000de78 ffff880287b4bfd8 0000000000013c00
>   ffff880287b4bfd8 0000000000013c00 ffff880937ea2dc0 ffff88123885d3e0
>  Call Trace:
>   [<ffffffff8104e062>] ? insert_work+0x92/0x9e
>   [<ffffffff8105945a>] ? ktime_get_ts+0xb1/0xbe
>   [<ffffffff814eb4b9>] io_schedule+0x7b/0xc1
>   [<ffffffff8109fc02>] sync_page+0x41/0x45
>   [<ffffffff814eb8d9>] __wait_on_bit_lock+0x45/0x8c
>   [<ffffffff8109fbc1>] ? sync_page+0x0/0x45
>   [<ffffffff8109fb84>] __lock_page+0x63/0x6a
>   [<ffffffff810517e3>] ? wake_bit_function+0x0/0x2a
>   [<ffffffff810a82de>] lock_page+0x24/0x28
>   [<ffffffff810a8364>] invalidate_inode_pages2_range+0x82/0x2af
>   [<ffffffff8120646a>] ? xfs_vm_direct_IO+0x90/0xbb
>   [<ffffffff812066a8>] ? xfs_get_blocks_direct+0x0/0x17
>   [<ffffffff812062c8>] ? xfs_end_io_direct+0x0/0x4e
>   [<ffffffff810a085d>] generic_file_direct_write+0xf5/0x14b
>   [<ffffffff8120db02>] xfs_write+0x498/0x784
>   [<ffffffff81034825>] ? wake_up_state+0xb/0xd
>   [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
>   [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
>   [<ffffffff810d8624>] vfs_write+0xab/0x105
>   [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
>   [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b

Direct IO write waiting on page cache invalidation which is blocked
on a locked page. i.e. it's trying to flush pages cached during
buffered IO.  Holds inode iolock here shared.

Also, it does not hold the i_mutex but is invalidating the page cache.
Remember that WARN_ON() condition that I'd say I'd come back to?
Guess what is warns about:

        if ((ioflags & IO_ISDIRECT)) {
                if (mapping->nrpages) {
>>>>>>>                 WARN_ON(need_i_mutex =3D=3D 0);
                        error =3D xfs_flushinval_pages(xip,
                                        (pos & PAGE_CACHE_MASK),
                                        -1, FI_REMAPF_LOCKED);
                        if (error)
                                goto out_unlock_internal;
                }

Right - it's warning about invalidating the page cache without the
i_mutex held. And FWIW the comment in generic_file_direct_write()
about this invalidation during direct IO:

        /*
         * Finally, try again to invalidate clean pages which might have be=
en
         * cached by non-direct readahead, or faulted in by get_user_pages()
         * if the source of the write was an mmap'ed region of the file
         * we're writing.  Either one is a pretty crazy thing to do,
         * so we don't support it 100%.  If this invalidation
         * fails, tough, the write still worked...
         */
        if (mapping->nrpages) {
                invalidate_inode_pages2_range(mapping,
                                              pos >> PAGE_CACHE_SHIFT, end);
        }

So the generic page cache code does not handle mixed bufered/direct
IO to the same file concurrently with a 100% coherency guarantee.
IOWs, just because the WARN_ON() is not being triggered, it *does not
mean that there is no problem*.


>  tar4ibd       D 0000000000000000  4552  6721   6720 0x00000004
>   ffff88016a7c3740 0000000000000086 0000000000000000 ffff88095fc13c00
>   0000000000000001 000000000000de78 ffff88016a7c3fd8 0000000000013c00
>   ffff88016a7c3fd8 0000000000013c00 ffff8806b39344a0 ffff881239d253e0
>  Call Trace:
>   [<ffffffff81034837>] ? wake_up_process+0x10/0x12
>   [<ffffffff8124c328>] ? __rwsem_do_wake+0x80/0x152
>   [<ffffffff814ec6ac>] rwsem_down_failed_common+0x96/0xc8
>   [<ffffffff81244595>] ? cfq_close_cooperator+0xd9/0x184
>   [<ffffffff814ec72e>] rwsem_down_read_failed+0x26/0x30
>   [<ffffffff81250484>] call_rwsem_down_read_failed+0x14/0x30
>   [<ffffffff814ec028>] ? down_read+0x1f/0x23
>   [<ffffffff811ebd4e>] xfs_ilock+0x5d/0x94
>   [<ffffffff811ebdae>] xfs_ilock_map_shared+0x29/0x2f
>   [<ffffffff811f231b>] xfs_iomap+0x9f/0x39c
>   [<ffffffff81239215>] ? __blk_run_queue+0x4a/0x70
>   [<ffffffff81247a91>] ? cpumask_next_and+0x2b/0x3c
>   [<ffffffff812065bd>] __xfs_get_blocks+0x71/0x15c
>   [<ffffffff812066d1>] xfs_get_blocks+0x12/0x14
>   [<ffffffff810fec23>] do_mpage_readpage+0x173/0x467
>   [<ffffffff810b2234>] ? __inc_zone_page_state+0x25/0x27
>   [<ffffffff8109fecc>] ? add_to_page_cache_locked+0x82/0xc6
>   [<ffffffff810ff04a>] mpage_readpages+0xd6/0x11c
>   [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
>   [<ffffffff812066bf>] ? xfs_get_blocks+0x0/0x14
>   [<ffffffff81207724>] xfs_vm_readpages+0x1a/0x1c
>   [<ffffffff810a72c4>] __do_page_cache_readahead+0x10c/0x1a2
>   [<ffffffff810a7376>] ra_submit+0x1c/0x20
>   [<ffffffff810a7606>] ondemand_readahead+0x1b2/0x1c5
>   [<ffffffff810a76f3>] page_cache_sync_readahead+0x38/0x3a
>   [<ffffffff810a0e0c>] generic_file_aio_read+0x229/0x582
>   [<ffffffff8120e262>] xfs_read+0x1a3/0x1f9
>   [<ffffffff8120a574>] xfs_file_aio_read+0x58/0x5c
>   [<ffffffff810d7dc4>] do_sync_read+0xc0/0x106
>   [<ffffffff81032879>] ? finish_task_switch+0x43/0xac
>   [<ffffffff810d8813>] vfs_read+0xa8/0x102
>   [<ffffffff810d8931>] sys_read+0x47/0x70
>   [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b

And there's the backup program, doing buffered readahead, holding a
page locked and stuck trying to get the xfs inode ilock. i.e. this
trace shows your system has tripped over the exact case that the
above code says is "a pretty crazy thing to do". IOWs, this is not
an XFS specific problem.

I can't find a thread that holds the XFS inode lock that everything
is waiting on. I think it is the ILOCK, but none of the threads in
this trace should be holding it where they are blocked. IOWs, the
output does not give me enough information to get to the root cause.

So, back to the situation with the WARN_ON(). You're running
applications that are doing something that:

	a) is not supported;
	b) compromises data integrity guarantees;
	c) is not reliably reported; and
	d) might be causing hangs

Right now I'm not particularly inclined to dig into this further;
it's obvious the applications are doing something that is not
supported (by XFS or the generic page cache code), so this is the
first thing you really need to care about getting fixed if you value
your backups...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
