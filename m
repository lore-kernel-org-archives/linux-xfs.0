Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 756857F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 17:36:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 59231304071
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 15:36:48 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cquXBUW1GHS6LlJy for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 15:36:45 -0800 (PST)
Date: Thu, 6 Mar 2014 10:35:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crash?
Message-ID: <20140305233551.GK6851@dastard>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Austin Schuh <austin@peloton-tech.com>
Cc: xfs@oss.sgi.com

On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
> Howdy,
> 
> I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
> and I'm seeing a couple lockups and crashes which I think are related
> to XFS.

I think they ar emore likely related to RT issues....

> After the first lockup, I booted into single user mode, mounted the
> filesystem readonly, and then ran xfs_repair -d.  When I rebooted
> again, I initiated a large copy to a USB drive (formated EXT3) and
> continued editing source files and compiling.  After a couple minutes,
> my laptop started locking up and after 2 minutes, the following showed
> up in the kernel.
> 
> Austin
> 
> $ uname -a
> Linux vpc5 3.10-3-rt-amd64 #5 SMP PREEMPT RT Debian 3.10.11-2
> (2013-09-10) x86_64 GNU/Linux
> 
> [ 1186.363397] usb 2-1: USB disconnect, device number 2
> [ 1200.895262] INFO: task kworker/u16:5:250 blocked for more than 120 seconds.
> [ 1200.895267] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1200.895270] kworker/u16:5   D ffff88040dc62cc0     0   250      2 0x00000000
> [ 1200.895281] Workqueue: writeback bdi_writeback_workfn (flush-8:0)
....
> [ 1200.895294] Call Trace:
> [ 1200.895301]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
> [ 1200.895304]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [ 1200.895307]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
> [ 1200.895310]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
> [ 1200.895313]  [<ffffffff81065cfd>] ? migrate_enable+0x1cd/0x1dd
> [ 1200.895317]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
> [ 1200.895319]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
> [ 1200.895322]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
> [ 1200.895356]  [<ffffffffa01a5032>] ? xfs_bmapi_allocate+0x92/0x9e [xfs]
> [ 1200.895371]  [<ffffffffa01a535d>] ? xfs_bmapi_write+0x31f/0x558 [xfs]
> [ 1200.895375]  [<ffffffff81109680>] ? kmem_cache_alloc+0x7c/0x17d
> [ 1200.895390]  [<ffffffffa01a2e6e>] ? __xfs_bmapi_allocate+0x22b/0x22b [xfs]
> [ 1200.895402]  [<ffffffffa018b899>] ? xfs_iomap_write_allocate+0x1bc/0x2c8 [xfs]
> [ 1200.895414]  [<ffffffffa017edc5>] ? xfs_map_blocks+0x125/0x1f5 [xfs]
> [ 1200.895424]  [<ffffffffa017fc87>] ? xfs_vm_writepage+0x266/0x48f [xfs]
> [ 1200.895428]  [<ffffffff810d3d14>] ? __writepage+0xd/0x2a
> [ 1200.895430]  [<ffffffff810d4790>] ? write_cache_pages+0x207/0x302
> [ 1200.895432]  [<ffffffff810d3d07>] ? page_index+0x14/0x14
> [ 1200.895435]  [<ffffffff810d48c6>] ? generic_writepages+0x3b/0x57
> [ 1200.895438]  [<ffffffff81134698>] ? __writeback_single_inode+0x72/0x225
> [ 1200.895441]  [<ffffffff8113550b>] ? writeback_sb_inodes+0x215/0x36d
> [ 1200.895444]  [<ffffffff811356cc>] ? __writeback_inodes_wb+0x69/0xab
> [ 1200.895446]  [<ffffffff81135844>] ? wb_writeback+0x136/0x2a7

That's waiting for allocation of blocks to complete during writeback
of dirty data via background writeback.

> [ 1200.895517] Workqueue: xfs-data/sda7 xfs_end_io [xfs]
....
> [ 1200.895526] Call Trace:
> [ 1200.895531]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [ 1200.895534]  [<ffffffff813a2438>] ? __rt_mutex_slowlock+0x7b/0xb4
> [ 1200.895537]  [<ffffffff813a2577>] ? rt_mutex_slowlock+0xe5/0x150
> [ 1200.895542]  [<ffffffff8100c02f>] ? load_TLS+0x7/0xa
> [ 1200.895552]  [<ffffffffa017eadb>] ? xfs_setfilesize+0x48/0x120 [xfs]
> [ 1200.895555]  [<ffffffff81063d25>] ? finish_task_switch+0x80/0xc6
> [ 1200.895565]  [<ffffffffa017f62f>] ? xfs_end_io+0x7a/0x8e [xfs]
> [ 1200.895568]  [<ffffffff81055a49>] ? process_one_work+0x19b/0x2b2
> [ 1200.895570]  [<ffffffff81055f41>] ? worker_thread+0x12b/0x1f6
> [ 1200.895572]  [<ffffffff81055e16>] ? rescuer_thread+0x28f/0x28f
> [ 1200.895574]  [<ffffffff8105a909>] ? kthread+0x81/0x89
> [ 1200.895576]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [ 1200.895579]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
> [ 1200.895581]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c

IO completion waiting on a lock. No idea what lock, because 
the rt code replaces various different types of locks with
"rt_mutexes".

> [ 1200.895630] BrowserBlocking D ffff88040dc62cc0     0  5547      1 0x00000000

fsync waiting for allocation completion during data writeback.

> [ 1200.895801] BrowserBlocking D ffff88040dde2cc0     0  5558      1 0x00000000

fsync waiting for IO completion of a data page during data
writeback.

> [ 1200.895876] BrowserBlocking D ffff88040dd62cc0     0  5575      1 0x00000000

ditto.

> [ 1200.895979] xterm           D ffff88040dc62cc0     0  6032      1 0x00000000

Blocked waiting on a workqueue flush. Completely unrealted to
filesystems and IO.

> [ 1200.896060] tup             D ffff88040dc62cc0     0 12846   7061 0x00000000

Blocked on an inode lock (rt_mutex, again) during timestamp updates
on a write(2) syscall.

> [ 1200.896162] ld              D ffff8802d3c4a180     0 12961      1 0x00000004

FUSE filesystem write blocked ?something? in it's IO path.

> [ 1200.896228] ld              D ffff88040dce2cc0     0 12970      1 0x00000006

FUSE filesystem write blocked ?something? in it's IO path after
recieving a signal in read(2) call.

> [ 1320.927338] khubd           D ffff88040dd62cc0     0   210      2 0x00000000

This is the smoking gun:

> [ 1320.927364]  [<ffffffff813a10ef>] ? console_conditional_schedule+0xf/0xf
> [ 1320.927367]  [<ffffffff813a1f93>] ? schedule+0x6b/0x7c
> [ 1320.927370]  [<ffffffff813a111b>] ? schedule_timeout+0x2c/0x123
> [ 1320.927374]  [<ffffffff8102c27b>] ? _flat_send_IPI_mask+0x68/0x78
> [ 1320.927378]  [<ffffffff810651ab>] ? get_parent_ip+0x9/0x1b
> [ 1320.927381]  [<ffffffff813a5c20>] ? add_preempt_count+0xb7/0xe0
> [ 1320.927382]  [<ffffffff813a188b>] ? __wait_for_common+0x78/0xd6
> [ 1320.927394]  [<ffffffff810549bb>] ? flush_work+0xf6/0x119
> [ 1320.927396]  [<ffffffff8105344b>] ? create_and_start_worker+0x5e/0x5e
> [ 1320.927400]  [<ffffffff810d7309>] ? __pagevec_release+0x20/0x20
> [ 1320.927402]  [<ffffffff810564cc>] ? schedule_on_each_cpu+0x9e/0xd5
> [ 1320.927422]  [<ffffffff8113f5a0>] ? invalidate_bdev+0x1d/0x2e
> [ 1320.927425]  [<ffffffff8113f5f4>] ? __invalidate_device+0x43/0x4b
> [ 1320.927427]  [<ffffffff811bf94d>] ? invalidate_partition+0x27/0x41
> [ 1320.927429]  [<ffffffff811c09f9>] ? del_gendisk+0x86/0x1bb
> [ 1320.927435]  [<ffffffffa00de643>] ? sd_remove+0x5f/0x98 [sd_mod]
> [ 1320.927443]  [<ffffffff8128d2a0>] ? __device_release_driver+0x7f/0xd5
> [ 1320.927444]  [<ffffffff8128d53a>] ? device_release_driver+0x1a/0x25
> [ 1320.927446]  [<ffffffff8128cee7>] ? bus_remove_device+0xe7/0xfc
> [ 1320.927448]  [<ffffffff8128ada0>] ? device_del+0x120/0x176
> [ 1320.927455]  [<ffffffffa0029a0f>] ? __scsi_remove_device+0x4d/0xaf [scsi_mod]
> [ 1320.927461]  [<ffffffffa002898c>] ? scsi_forget_host+0x48/0x68 [scsi_mod]
> [ 1320.927467]  [<ffffffffa002025c>] ? scsi_remove_host+0x85/0x101 [scsi_mod]
> [ 1320.927472]  [<ffffffffa00d1f7c>] ? usb_stor_disconnect+0x63/0xae
> [usb_storage]
> [ 1320.927479]  [<ffffffffa0071d31>] ? usb_unbind_interface+0x5e/0x135 [usbcore]
> [ 1320.927488]  [<ffffffff8128d2a0>] ? __device_release_driver+0x7f/0xd5
> [ 1320.927490]  [<ffffffff8128d53a>] ? device_release_driver+0x1a/0x25
> [ 1320.927491]  [<ffffffff8128cee7>] ? bus_remove_device+0xe7/0xfc
> [ 1320.927493]  [<ffffffff8128ada0>] ? device_del+0x120/0x176
> [ 1320.927501]  [<ffffffffa0070025>] ? usb_disable_device+0x6a/0x180 [usbcore]
> [ 1320.927509]  [<ffffffffa0069507>] ? usb_disconnect+0x79/0x151 [usbcore]
> [ 1320.927515]  [<ffffffffa006abee>] ? hub_thread+0x60d/0xea2 [usbcore]
> [ 1320.927518]  [<ffffffff8105b309>] ? abort_exclusive_wait+0x7f/0x7f
> [ 1320.927524]  [<ffffffffa006a5e1>] ? hub_port_debounce+0xcf/0xcf [usbcore]
> [ 1320.927526]  [<ffffffff8105a909>] ? kthread+0x81/0x89
> [ 1320.927528]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c
> [ 1320.927530]  [<ffffffff813a75fc>] ? ret_from_fork+0x7c/0xb0
> [ 1320.927532]  [<ffffffff8105a888>] ? __kthread_parkme+0x5c/0x5c

Your usb device has disconnected and gone down the device
removal/invalidate partition route. and it's trying to flush the
device, which is stuck on IO completion which is stuck waiting for
the device error handling to error them out.

So, this is a block device problem error handling problem caused by
device unplug getting stuck because it's decided to ask the
filesystem to complete operations that can't be completed until the
device error handling progress far enough to error out the IOs that
the filesystem is waiting for completion on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
