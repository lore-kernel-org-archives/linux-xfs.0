Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 708357F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 07:17:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDF3BAC004
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 05:17:48 -0700 (PDT)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id n8AKyZdDKiE23yi8
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Oct 2013 05:17:46 -0700 (PDT)
Received: by mail-pb0-f46.google.com with SMTP id rq2so745109pbb.33
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 05:17:46 -0700 (PDT)
Message-ID: <525E83E4.9090803@gmail.com>
Date: Wed, 16 Oct 2013 21:17:40 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
	<20131016110146.GH4446@dastard>
In-Reply-To: <20131016110146.GH4446@dastard>
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
To: david@fromorbit.com
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ruby.wktk@gmail.com, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com

Dave

> XFS shuts down because you've returned EIO to a log IO. That's a
> fatal error. If you do the same to an ext4 journal write, it will do
> the equivalent of shut down (e.g. complain and turn read-only).
You mean block device should not return -EIO anyway if
it doesn't want XFS to suddenly shut down?
As Mikulas said, connection failure often be the cause of
I/O error from the underlying devices.

That ext4 and XFS are both determine shutting down in
erroneous journal writes is also due to the limitation of journal write?
or just a compromise in implementation? This is just for my curiosity.

>> [  180.560040] device-mapper: writeboost: err@recorder_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
>> [  180.561179] device-mapper: writeboost: err@sync_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
> 
> What's with the 35s delay between these writeboost messages? Have
> you only done a partial shutdown of the block device and it takes
> This length of time for it to completely block IO?
Strange.
These daemons should stop in few seconds on the current configuration.
Yes, partial in a sense. Not all the daemons stop immediately but
for the client the logical device is seen as being blocked up
returning -EIO on every I/O. I don't think this behavior harms the
upper layer.

Currently, sync_proc is like this.
It sleeps for few seconds, wakes up and
meets wait_on_blockup() to dump that message and halts itself.
recorder_proc is implemented in the same way.

int sync_proc(void *data)
{
        int r;
        struct wb_cache *cache = data;
        struct wb_device *wb = cache->wb;
        unsigned long intvl;

        while (!kthread_should_stop()) {

                wait_on_blockup();

                /* sec -> ms */
                intvl = ACCESS_ONCE(cache->sync_interval) * 1000;

                if (!intvl) {
                        schedule_timeout_interruptible(msecs_to_jiffies(1000));
                        continue;
                }

                flush_current_buffer(cache);

                RETRY(blkdev_issue_flush(cache->device->bdev, GFP_NOIO, NULL));

                schedule_timeout_interruptible(msecs_to_jiffies(intvl));
        }
        return 0;
}

XFS shuts down, go crazy and it disturbs the kthread to wake up?

> These should be emitting a stack trace. Can you turn up the logging
> level you are using so that they emit a full stack trace? The
> messages are useless without the stack dump....
I turned the level up to 7. Here is the one.

Connected to domain Hercules
Escape character is ^]
[   54.683482] device-mapper: writeboost: err@audit_cache_device() superblock header: magic number invalid
[   54.809262] bio: create slab <bio-2> at 2
[   68.812800] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   68.825016] XFS (dm-3): Mounting Filesystem
[   68.847027] XFS (dm-3): Ending clean mount
[   72.100112] device-mapper: writeboost: err@dm_safe_io_internal() system is blocked up on I/O error. set blockup to 0 after checkup.
[   72.109702] device-mapper: writeboost: err@migrate_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[   72.812097] device-mapper: writeboost: err@modulator_proc() system is blocked up on I/O error. set blockup to 0 after checkup.
[   73.894429] Buffer I/O error on device dm-3, logical block 98354
[   73.895824] lost page write due to I/O error on dm-3
[   73.897042] Buffer I/O error on device dm-3, logical block 98355
[   73.897209] Buffer I/O error on device dm-3, logical block 196641
[   73.897210] lost page write due to I/O error on dm-3
[   73.897263] Buffer I/O error on device dm-3, logical block 196688
[   73.897264] lost page write due to I/O error on dm-3
[   73.897266] Buffer I/O error on device dm-3, logical block 196689
[   73.897267] lost page write due to I/O error on dm-3
[   73.897268] Buffer I/O error on device dm-3, logical block 196690
[   73.897269] lost page write due to I/O error on dm-3
[   73.897270] Buffer I/O error on device dm-3, logical block 196691
[   73.897271] lost page write due to I/O error on dm-3
[   73.897272] Buffer I/O error on device dm-3, logical block 196692
[   73.897273] lost page write due to I/O error on dm-3
[   73.897307] Buffer I/O error on device dm-3, logical block 294955
[   73.897308] lost page write due to I/O error on dm-3
[   73.897335] Buffer I/O error on device dm-3, logical block 294956
[   73.897335] lost page write due to I/O error on dm-3
[   73.914261] lost page write due to I/O error on dm-3
[   73.930022] XFS (dm-3): metadata I/O error: block 0x40 ("xfs_buf_iodone_callbacks") error 5 numblks 16
[   74.036759] XFS (dm-3): metadata I/O error: block 0x300c7f ("xlog_iodone") error 5 numblks 64
[   74.043456] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.047556] XFS (dm-3): Log I/O Error Detected.  Shutting down filesystem
[   74.049893] XFS (dm-3): Please umount the filesystem and rectify the problem(s)
[   74.051467] XFS (dm-3): metadata I/O error: block 0x300cbf ("xlog_iodone") error 5 numblks 64
[   74.053190] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.055435] XFS (dm-3): metadata I/O error: block 0x300cff ("xlog_iodone") error 5 numblks 64
[   74.057162] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.059402] XFS (dm-3): metadata I/O error: block 0x300d3f ("xlog_iodone") error 5 numblks 64
[   74.061136] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.063561] XFS (dm-3): metadata I/O error: block 0x300d7f ("xlog_iodone") error 5 numblks 64
[   74.065667] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.068215] XFS (dm-3): metadata I/O error: block 0x300dbf ("xlog_iodone") error 5 numblks 64
[   74.069920] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[   74.072325] XFS (dm-3): metadata I/O error: block 0x300dff ("xlog_iodone") error 5 numblks 64
[   74.074118] XFS (dm-3): xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03a6417
[  100.052005] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/0:1H:215]
[  100.052005] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.052005] CPU: 0 PID: 215 Comm: kworker/0:1H Tainted: G           O 3.12.0-rc1 #8
[  100.052005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.052005] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  100.052005] task: ffff880216eb67b0 ti: ffff8801f9c7c000 task.ti: ffff8801f9c7c000
[  100.052005] RIP: 0010:[<ffffffff8108146a>]  [<ffffffff8108146a>] do_raw_spin_lock+0x1d/0x23
[  100.052005] RSP: 0018:ffff8801f9c7dde0  EFLAGS: 00000206
[  100.052005] RAX: 000000000116011c RBX: ffff880216eb6818 RCX: 0000000000000001
[  100.052005] RDX: 0000000000000116 RSI: ffff8801fa389218 RDI: ffff880205c69e80
[  100.052005] RBP: ffff880205c69e40 R08: ffff88021fc12ad8 R09: 0000000000000001
[  100.052005] R10: 0000000000000001 R11: ffff88002f36e3c0 R12: ffffffff810605a8
[  100.052005] R13: ffff880216eb6818 R14: ffff88021fc12ef0 R15: ffff880216eb6818
[  100.052005] FS:  0000000000000000(0000) GS:ffff88021fc00000(0000) knlGS:0000000000000000
[  100.052005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.052005] CR2: ffffe8ffffc00520 CR3: 000000002ef57000 CR4: 00000000000006f0
[  100.052005] Stack:
[  100.052005]  ffffffffa03aa836 ffff88002f36e418 ffff88021fc12ac0 ffffe8ffffc00400
[  100.052005]  ffff88002f36e3c0 ffff88002f36e460 ffffffffa03a99c2 ffff88002f36e3c0
[  100.052005]  ffffffffa03a9bd2 ffff8801faf95bc0 ffff88002f36e460 ffff88021fc12ac0
[  100.052005] Call Trace:
[  100.052005]  [<ffffffffa03aa836>] ? xfs_buf_iodone+0x1b/0x49 [xfs]
[  100.052005]  [<ffffffffa03a99c2>] ? xfs_buf_do_callbacks+0x22/0x30 [xfs]
[  100.052005]  [<ffffffffa03a9bd2>] ? xfs_buf_iodone_callbacks+0x16b/0x1c4 [xfs]
[  100.052005]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
[  100.052005]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
[  100.052005]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
[  100.052005]  [<ffffffff81050641>] ? kthread+0x81/0x89
[  100.052005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.052005]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
[  100.052005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.052005] Code: 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 66 39 d0 74 04 f3 90 <eb> f4 c3 90 90 90 83 c8 ff 0f b7 ca 66 ff c2 89 c2 0f 45 d1 0f 
[  100.244006] BUG: soft lockup - CPU#2 stuck for 22s! [xfsaild/dm-3:3167]
[  100.244006] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.244006] CPU: 2 PID: 3167 Comm: xfsaild/dm-3 Tainted: G           O 3.12.0-rc1 #8
[  100.244006] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.244006] task: ffff88002fef2100 ti: ffff88002b384000 task.ti: ffff88002b384000
[  100.244006] RIP: 0010:[<ffffffff8108146a>]  [<ffffffff8108146a>] do_raw_spin_lock+0x1d/0x23
[  100.244006] RSP: 0018:ffff88002b385b00  EFLAGS: 00000206
[  100.244006] RAX: 000000000117011c RBX: ffffffff8105e684 RCX: 0000000000000002
[  100.244006] RDX: 0000000000000117 RSI: ffff8802166d7200 RDI: ffff880205c69e80
[  100.244006] RBP: ffff8801fa2e2670 R08: 0000000000000005 R09: 0000000000000000
[  100.244006] R10: 000000000000a944 R11: 0000000000000000 R12: ffff88002f181674
[  100.244006] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88002fef2100
[  100.244006] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
[  100.244006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.244006] CR2: ffffe8ffffc80400 CR3: 00000001fae7c000 CR4: 00000000000006e0
[  100.244006] Stack:
[  100.244006]  ffffffffa0372e3d ffff88021682a830 ffffffffa036050e 0000000000012e80
[  100.244006]  ffff88002b385fd8 ffff88002b385fd8 000000022fef2100 0000000000300e3f
[  100.244006]  ffff88002f071500 0000000000000292 ffffffff81050e94 0000000000000000
[  100.244006] Call Trace:
[  100.244006]  [<ffffffffa0372e3d>] ? xfs_trans_committed_bulk+0x2f/0x19d [xfs]
[  100.244006]  [<ffffffffa036050e>] ? _xfs_buf_ioapply+0x271/0x29c [xfs]
[  100.244006]  [<ffffffff81050e94>] ? remove_wait_queue+0xe/0x48
[  100.244006]  [<ffffffffa03a5b85>] ? xlog_wait+0x62/0x6b [xfs]
[  100.244006]  [<ffffffff8105bbfb>] ? try_to_wake_up+0x190/0x190
[  100.244006]  [<ffffffffa03a78e6>] ? xlog_state_get_iclog_space+0x5a/0x1fb [xfs]
[  100.244006]  [<ffffffff810fa1c3>] ? __cache_free.isra.46+0x178/0x187
[  100.244006]  [<ffffffffa03a8e0b>] ? xlog_cil_committed+0x2f/0xe6 [xfs]
[  100.244006]  [<ffffffffa03a926c>] ? xlog_cil_push+0x2f6/0x311 [xfs]
[  100.244006]  [<ffffffff81058701>] ? mmdrop+0xd/0x1c
[  100.244006]  [<ffffffffa03a9780>] ? xlog_cil_force_lsn+0x71/0xdd [xfs]
[  100.244006]  [<ffffffffa03a8162>] ? _xfs_log_force+0x55/0x1a0 [xfs]
[  100.244006]  [<ffffffffa03a82cc>] ? xfs_log_force+0x1f/0x4e [xfs]
[  100.244006]  [<ffffffffa03aba15>] ? xfsaild+0x144/0x4cd [xfs]
[  100.244006]  [<ffffffff810592dc>] ? finish_task_switch+0x7f/0xaa
[  100.244006]  [<ffffffffa03ab8d1>] ? xfs_trans_ail_cursor_first+0x76/0x76 [xfs]
[  100.244006]  [<ffffffffa03ab8d1>] ? xfs_trans_ail_cursor_first+0x76/0x76 [xfs]
[  100.244006]  [<ffffffff81050641>] ? kthread+0x81/0x89
[  100.244006]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.244006]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
[  100.244006]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.244006] Code: 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 66 39 d0 74 04 f3 90 <eb> f4 c3 90 90 90 83 c8 ff 0f b7 ca 66 ff c2 89 c2 0f 45 d1 0f 
[  100.340005] BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1H:207]
[  100.340005] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.340005] CPU: 3 PID: 207 Comm: kworker/3:1H Tainted: G           O 3.12.0-rc1 #8
[  100.340005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.340005] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  100.340005] task: ffff8801f9cc5870 ti: ffff8801f9c06000 task.ti: ffff8801f9c06000
[  100.340005] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
[  100.340005] RSP: 0018:ffff8801f9c07de0  EFLAGS: 00000202
[  100.340005] RAX: 000000000118011c RBX: ffffe8ffffcc0400 RCX: 0000000000000001
[  100.340005] RDX: 0000000000000118 RSI: ffff8801fa389218 RDI: ffff880205c69e80
[  100.340005] RBP: ffff880205c69e40 R08: ffff88021fcd2ad8 R09: 0000000000000001
[  100.340005] R10: 0000000000000001 R11: ffff88002f36e540 R12: ffff88002f36e674
[  100.340005] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[  100.340005] FS:  0000000000000000(0000) GS:ffff88021fcc0000(0000) knlGS:0000000000000000
[  100.340005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.340005] CR2: 00007f15636c7e50 CR3: 000000000160b000 CR4: 00000000000006e0
[  100.340005] Stack:
[  100.340005]  ffffffffa03aa836 ffff88002f36e598 ffff88021fcd2ac0 ffffe8ffffcc0400
[  100.340005]  ffff88002f36e540 ffff88002f36e5e0 ffffffffa03a99c2 ffff88002f36e540
[  100.340005]  ffffffffa03a9bd2 ffff8801f9d16f40 ffff88002f36e5e0 ffff88021fcd2ac0
[  100.340005] Call Trace:
[  100.340005]  [<ffffffffa03aa836>] ? xfs_buf_iodone+0x1b/0x49 [xfs]
[  100.340005]  [<ffffffffa03a99c2>] ? xfs_buf_do_callbacks+0x22/0x30 [xfs]
[  100.340005]  [<ffffffffa03a9bd2>] ? xfs_buf_iodone_callbacks+0x16b/0x1c4 [xfs]
[  100.340005]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
[  100.340005]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
[  100.340005]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
[  100.340005]  [<ffffffff81050641>] ? kthread+0x81/0x89
[  100.340005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.340005]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
[  100.340005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.340005] Code: 81 ff 98 a2 37 81 72 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 <66> 39 d0 74 04 f3 90 eb f4 c3 90 90 90 83 c8 ff 0f b7 ca 66 ff 
[  100.436010] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/4:2:537]
[  100.436010] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.436010] CPU: 4 PID: 537 Comm: kworker/4:2 Tainted: G           O 3.12.0-rc1 #8
[  100.436010] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.436010] Workqueue: xfs-reclaim/dm-3 xfs_reclaim_worker [xfs]
[  100.436010] task: ffff8801fade6040 ti: ffff88002edaa000 task.ti: ffff88002edaa000
[  100.436010] RIP: 0010:[<ffffffff81081460>]  [<ffffffff81081460>] do_raw_spin_lock+0x13/0x23
[  100.436010] RSP: 0018:ffff88002edabc20  EFLAGS: 00000202
[  100.436010] RAX: 00000000011b011c RBX: ffff88002f693870 RCX: 0000000000000000
[  100.436010] RDX: 000000000000011b RSI: 0000000000000000 RDI: ffff880205c69e80
[  100.436010] RBP: ffff88002a15c000 R08: 0000000000000000 R09: 0000000000000006
[  100.436010] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  100.436010] R13: ffff880216e79ec0 R14: ffff88002edabc24 R15: 0000000000012e80
[  100.436010] FS:  0000000000000000(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
[  100.436010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.436010] CR2: 00007f7e9b394f30 CR3: 000000000160b000 CR4: 00000000000006e0
[  100.436010] Stack:
[  100.436010]  ffffffffa03ab5f3 0000000000000001 ffff8801fa383710 ffff88002a15c000
[  100.436010]  0000000000000445 0000000000000002 ffff8801fa3836c0 0000000000000002
[  100.436010]  ffffffffa03667a3 0000000000000444 0000000000000000 ffff8801fa3836c0
[  100.436010] Call Trace:
[  100.436010]  [<ffffffffa03ab5f3>] ? xfs_iflush_abort+0x35/0x9a [xfs]
[  100.436010]  [<ffffffffa03667a3>] ? xfs_reclaim_inode+0x85/0x246 [xfs]
[  100.436010]  [<ffffffffa0366aab>] ? xfs_reclaim_inodes_ag+0x147/0x1fc [xfs]
[  100.436010]  [<ffffffff8105bbfb>] ? try_to_wake_up+0x190/0x190
[  100.436010]  [<ffffffff81056927>] ? __wake_up_common+0x42/0x78
[  100.436010]  [<ffffffff810d5a18>] ? fold_diff+0x22/0x2e
[  100.436010]  [<ffffffff810408d8>] ? lock_timer_base.isra.35+0x23/0x48
[  100.436010]  [<ffffffff81040750>] ? internal_add_timer+0xd/0x28
[  100.436010]  [<ffffffff8104125b>] ? __mod_timer+0xfa/0x10c
[  100.436010]  [<ffffffffa0367382>] ? xfs_reclaim_inodes+0x16/0x1b [xfs]
[  100.436010]  [<ffffffffa036739c>] ? xfs_reclaim_worker+0x15/0x1e [xfs]
[  100.436010]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
[  100.436010]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
[  100.436010]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
[  100.436010]  [<ffffffff81050641>] ? kthread+0x81/0x89
[  100.436010]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.436010]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
[  100.436010]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.436010] Code: 31 c0 48 81 ff 98 a2 37 81 72 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c <66> 8b 07 66 39 d0 74 04 f3 90 eb f4 c3 90 90 90 83 c8 ff 0f b7 
[  100.628005] BUG: soft lockup - CPU#6 stuck for 22s! [script:3151]
[  100.628005] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.628005] CPU: 6 PID: 3151 Comm: script Tainted: G           O 3.12.0-rc1 #8
[  100.628005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.628005] task: ffff88002fc3d870 ti: ffff88002fda4000 task.ti: ffff88002fda4000
[  100.628005] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
[  100.628005] RSP: 0018:ffff88002fda5d10  EFLAGS: 00000202
[  100.628005] RAX: 00000000011a011c RBX: ffffffff81119902 RCX: 00000000000004e2
[  100.628005] RDX: 000000000000011a RSI: ffff88002f64e200 RDI: ffff880205c69e80
[  100.628005] RBP: ffff88002fda5e58 R08: ffffffffa03bec40 R09: 0000000000000000
[  100.628005] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002fda5cf0
[  100.628005] R13: 0000000000000001 R14: ffff8801facfea10 R15: 0000000000000000
[  100.628005] FS:  00007f599f046700(0000) GS:ffff88021fd80000(0000) knlGS:0000000000000000
[  100.628005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.628005] CR2: 000000000234c698 CR3: 000000002f62e000 CR4: 00000000000006e0
[  100.628005] Stack:
[  100.628005]  ffffffffa03abe25 ffff8801facfe800 ffff88002fda5e58 ffff88002ffcb000
[  100.628005]  ffffffffa03673bf ffff88002fda5d38 000000002fda5d38 0000000000001036
[  100.628005]  ffffffff8110875e 0000000000000000 0000000000000000 ffff88002ffcb360
[  100.628005] Call Trace:
[  100.628005]  [<ffffffffa03abe25>] ? xfs_ail_push_all+0x13/0x4f [xfs]
[  100.628005]  [<ffffffffa03673bf>] ? xfs_reclaim_inodes_nr+0x1a/0x34 [xfs]
[  100.628005]  [<ffffffff8110875e>] ? super_cache_scan+0x121/0x13e
[  100.628005]  [<ffffffff810cdb7a>] ? shrink_slab+0x1e3/0x2f9
[  100.628005]  [<ffffffff81119526>] ? iput+0x34/0x13d
[  100.628005]  [<ffffffff81148d14>] ? do_coredump+0xbc3/0xbc3
[  100.628005]  [<ffffffff81148e3f>] ? drop_caches_sysctl_handler+0x65/0x76
[  100.628005]  [<ffffffff81157b7c>] ? proc_sys_call_handler+0x98/0xbf
[  100.628005]  [<ffffffff81105eca>] ? vfs_write+0x9e/0x104
[  100.628005]  [<ffffffff811061c1>] ? SyS_write+0x51/0x85
[  100.628005]  [<ffffffff8137f592>] ? system_call_fastpath+0x16/0x1b
[  100.628005] Code: 81 ff 98 a2 37 81 72 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 <66> 39 d0 74 04 f3 90 eb f4 c3 90 90 90 83 c8 ff 0f b7 ca 66 ff 
[  100.724004] BUG: soft lockup - CPU#7 stuck for 22s! [kworker/7:1H:211]
[  100.724005] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm psmouse microcode pcspkr serio_raw processor i2c_piix4 i2c_core evdev joydev virtio_balloon snd_page_alloc snd_timer snd soundcore thermal_sys button ext4 crc16 jbd2 mbcache dm_mod hid_generic usbhid hid sg sr_mod cdrom ata_generic virtio_net virtio_blk ata_piix uhci_hcd ehci_hcd libata usbcore scsi_mod virtio_pci virtio_ring usb_common virtio floppy
[  100.724005] CPU: 7 PID: 211 Comm: kworker/7:1H Tainted: G           O 3.12.0-rc1 #8
[  100.724005] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  100.724005] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  100.724005] task: ffff88002f7de830 ti: ffff8801fa100000 task.ti: ffff8801fa100000
[  100.724005] RIP: 0010:[<ffffffff81081463>]  [<ffffffff81081463>] do_raw_spin_lock+0x16/0x23
[  100.724005] RSP: 0018:ffff8801fa101de0  EFLAGS: 00000206
[  100.724005] RAX: 000000000119011c RBX: ffff8801fa7ad0c0 RCX: 0000000000000001
[  100.724005] RDX: 0000000000000119 RSI: ffff8801fac4a398 RDI: ffff880205c69e80
[  100.724005] RBP: ffff880205c69e40 R08: ffff88021fdd2ad8 R09: ffff88002f181500
[  100.724005] R10: ffff88002f181500 R11: ffff88002f2670c0 R12: ffff8801fa7ad0c0
[  100.724005] R13: ffff88021658a360 R14: ffffffffa03c3e75 R15: ffffe8ffffdc0400
[  100.724005] FS:  0000000000000000(0000) GS:ffff88021fdc0000(0000) knlGS:0000000000000000
[  100.724005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  100.724005] CR2: 000000000131b724 CR3: 00000001fae7c000 CR4: 00000000000006e0
[  100.724005] Stack:
[  100.724005]  ffffffffa03aa836 ffff88002f267118 ffff88021fdd2ac0 ffffe8ffffdc0400
[  100.724005]  ffff88002f2670c0 ffff88002f267160 ffffffffa03a99c2 ffff88002f2670c0
[  100.724005]  ffffffffa03a9bd2 ffff880216eb42c0 ffff88002f267160 ffff88021fdd2ac0
[  100.724005] Call Trace:
[  100.724005]  [<ffffffffa03aa836>] ? xfs_buf_iodone+0x1b/0x49 [xfs]
[  100.724005]  [<ffffffffa03a99c2>] ? xfs_buf_do_callbacks+0x22/0x30 [xfs]
[  100.724005]  [<ffffffffa03a9bd2>] ? xfs_buf_iodone_callbacks+0x16b/0x1c4 [xfs]
[  100.724005]  [<ffffffff8104b7ab>] ? process_one_work+0x191/0x294
[  100.724005]  [<ffffffff8104bc5d>] ? worker_thread+0x121/0x1e7
[  100.724005]  [<ffffffff8104bb3c>] ? rescuer_thread+0x269/0x269
[  100.724005]  [<ffffffff81050641>] ? kthread+0x81/0x89
[  100.724005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.724005]  [<ffffffff8137f4ec>] ? ret_from_fork+0x7c/0xb0
[  100.724005]  [<ffffffff810505c0>] ? __kthread_parkme+0x5d/0x5d
[  100.724005] Code: 81 ff 98 a2 37 81 72 0c 31 c0 48 81 ff 18 a6 37 81 0f 92 c0 c3 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 c2 74 0c 66 8b 07 <66> 39 d0 74 04 f3 90 eb f4 c3 90 90 90 83 c8 ff 0f b7 ca 66 ff 

Akira

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
