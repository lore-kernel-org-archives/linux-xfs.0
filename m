Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFFCD7F3F
	for <xfs@oss.sgi.com>; Sat, 19 Oct 2013 06:00:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A06098F8064
	for <xfs@oss.sgi.com>; Sat, 19 Oct 2013 04:00:05 -0700 (PDT)
Received: from mail-pa0-f41.google.com (mail-pa0-f41.google.com
	[209.85.220.41]) by cuda.sgi.com with ESMTP id KfGI8NxGJbiA16LR
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Oct 2013 04:00:04 -0700 (PDT)
Received: by mail-pa0-f41.google.com with SMTP id bj1so5818039pad.0
	for <xfs@oss.sgi.com>; Sat, 19 Oct 2013 04:00:03 -0700 (PDT)
Message-ID: <5262662B.9010807@gmail.com>
Date: Sat, 19 Oct 2013 19:59:55 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: Re: A review of dm-writeboost
References: <alpine.LRH.2.02.1310031719340.24440@file01.intranet.prod.int.rdu2.redhat.com>
	<52550841.5030001@gmail.com> <525BAB32.5050901@gmail.com>
	<alpine.LRH.2.02.1310151950530.4664@file01.intranet.prod.int.rdu2.redhat.com>
	<20131016060750.GE4446@dastard> <525E6BBE.40004@gmail.com>
	<20131016110146.GH4446@dastard> <525E83E4.9090803@gmail.com>
	<20131016214200.GI4446@dastard>
In-Reply-To: <20131016214200.GI4446@dastard>
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
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, snitzer@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, tj@kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com

Dave,

# -EIO retuned corrupts XFS
I turned up
lockdep, frame pointer, xfs debug
and also changed to 3.12.0-rc5 from rc1.

What's changed is that
the problem we discussed in previous mails
*never* reproduce.

However, if I turn off the lockdep only
it hangs up by setting blockup to 1 and then to 0 after that.
The underlying device once became dead revives
may confuse the filesystem but
this looks not related to locking things.
This problem may be producible using dm-flakey.

This behavior is not reproducible with ext4.

--------------------------------------------
root@Lyle:/home/akira# virsh console Hercules
Connected to domain Hercules
Escape character is ^]
[  143.042980] device-mapper: writeboost: info@modulator_proc() reactivated after blockup
[  143.042999] device-mapper: writeboost: info@dm_safe_io_internal() reactivated after blockup
[  143.043006] device-mapper: writeboost: info@migrate_proc() reactivated after blockup
[  143.045328] XFS: metadata I/O error: block 0x300d0f ("xlog_iodone") error 5 numblks 64
[  143.045333] XFS: xfs_do_force_shutdown(0x2) called from line 1161 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa0430f9c
[  143.045335] XFS: Log I/O Error Detected.  Shutting down filesystem
[  143.045335] XFS: Please umount the filesystem and rectify the problem(s)
[  143.045338] XFS: Assertion failed: atomic_read(&iclog->ic_refcnt) == 0, file: fs/xfs/xfs_log.c, line: 2751
[  143.045392] ------------[ cut here ]------------
[  143.045393] kernel BUG at fs/xfs/xfs_message.c:108!
[  143.045396] invalid opcode: 0000 [#1] SMP 
[  143.045429] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm joydev hid_generic usbhid processor snd_page_alloc i2c_piix4 i2c_core snd_timer snd soundcore psmouse serio_raw evdev virtio_balloon pcspkr hid thermal_sys microcode button ext4 crc16 jbd2 mbcache dm_mod sg sr_mod cdrom ata_generic virtio_blk virtio_net floppy uhci_hcd ehci_hcd ata_piix usbcore libata usb_common scsi_mod virtio_pci virtio_ring virtio
[  143.045433] CPU: 2 PID: 216 Comm: kworker/2:1H Tainted: G           O 3.12.0-rc5 #11
[  143.045434] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  143.045465] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  143.045466] task: ffff88002fe7e0c0 ti: ffff88002ff66000 task.ti: ffff88002ff66000
[  143.045493] RIP: 0010:[<ffffffffa03e72f3>]  [<ffffffffa03e72f3>] assfail+0x1d/0x1f [xfs]
[  143.045494] RSP: 0000:ffff88002ff67d98  EFLAGS: 00010292
[  143.045495] RAX: 000000000000005e RBX: ffff88020de3c280 RCX: 0000000000000c8a
[  143.045496] RDX: 0000000000000000 RSI: ffffffff819c3f2c RDI: ffffffff818356e0
[  143.045497] RBP: ffff88002ff67d98 R08: 0000000000000000 R09: ffffffff819c3ecc
[  143.045498] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801fa583d28
[  143.045499] R13: ffff8801fa583c00 R14: 0000000000000002 R15: 0000000000000000
[  143.045501] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
[  143.045502] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.045505] CR2: 00007f6e7680db67 CR3: 000000000180b000 CR4: 00000000000006e0
[  143.045511] Stack:
[  143.045514]  ffff88002ff67dc8 ffffffffa0430ed1 ffff8801fb124e40 0000000000000002
[  143.045517]  ffff88020de3c280 ffffe8ffffc80500 ffff88002ff67df8 ffffffffa0431018
[  143.045519]  ffff8801fb124ee0 ffff8801fb124ee0 ffff8801fb124e40 ffff88021fc92a00
[  143.045520] Call Trace:
[  143.045558]  [<ffffffffa0430ed1>] xlog_state_done_syncing+0x6d/0xe4 [xfs]
[  143.045590]  [<ffffffffa0431018>] xlog_iodone+0xd0/0xd9 [xfs]
[  143.045609]  [<ffffffffa03d834f>] xfs_buf_iodone_work+0x57/0xa2 [xfs]
[  143.045627]  [<ffffffff8104f21a>] process_one_work+0x18b/0x297
[  143.045631]  [<ffffffff8104f6e6>] worker_thread+0x12e/0x1fb
[  143.045634]  [<ffffffff8104f5b8>] ? rescuer_thread+0x268/0x268
[  143.045638]  [<ffffffff81054507>] kthread+0x88/0x90
[  143.045641]  [<ffffffff8105447f>] ? __kthread_parkme+0x60/0x60
[  143.045646]  [<ffffffff813a707c>] ret_from_fork+0x7c/0xb0
[  143.045649]  [<ffffffff8105447f>] ? __kthread_parkme+0x60/0x60
[  143.045670] Code: 48 c7 c7 6b 26 45 a0 e8 a4 2a c5 e0 5d c3 55 48 89 f1 41 89 d0 48 c7 c6 80 26 45 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 aa fc ff ff <0f> 0b 55 48 63 f6 49 89 f9 41 b8 01 00 00 00 b9 10 00 00 00 ba 
[  143.045694] RIP  [<ffffffffa03e72f3>] assfail+0x1d/0x1f [xfs]
[  143.045695]  RSP <ffff88002ff67d98>
[  143.045697] ---[ end trace e4f1a3c306353178 ]---
[  143.045741] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  143.045745] IP: [<ffffffff810548fd>] kthread_data+0xb/0x11
[  143.045747] PGD 180c067 PUD 180e067 PMD 0 
[  143.045749] Oops: 0000 [#2] SMP 
[  143.045774] Modules linked in: xfs crc32c libcrc32c dm_writeboost(O) fuse nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_hda_intel snd_hda_codec snd_hwdep snd_pcm joydev hid_generic usbhid processor snd_page_alloc i2c_piix4 i2c_core snd_timer snd soundcore psmouse serio_raw evdev virtio_balloon pcspkr hid thermal_sys microcode button ext4 crc16 jbd2 mbcache dm_mod sg sr_mod cdrom ata_generic virtio_blk virtio_net floppy uhci_hcd ehci_hcd ata_piix usbcore libata usb_common scsi_mod virtio_pci virtio_ring virtio
[  143.045777] CPU: 2 PID: 216 Comm: kworker/2:1H Tainted: G      D    O 3.12.0-rc5 #11
[  143.045778] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  143.045795] task: ffff88002fe7e0c0 ti: ffff88002ff66000 task.ti: ffff88002ff66000
[  143.045798] RIP: 0010:[<ffffffff810548fd>]  [<ffffffff810548fd>] kthread_data+0xb/0x11
[  143.045802] RSP: 0000:ffff88002ff67a38  EFLAGS: 00010002
[  143.045804] RAX: 0000000000000000 RBX: ffff88021fc92e80 RCX: ffff88021fc92ef0
[  143.045805] RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffff88002fe7e0c0
[  143.045805] RBP: ffff88002ff67a38 R08: ffffffff819b6640 R09: 000000000000bfcf
[  143.045806] R10: dead000000200200 R11: 0000000000000000 R12: 0000000000000002
[  143.045807] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88002fe7e0b0
[  143.045809] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
[  143.045810] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  143.045813] CR2: 0000000000000028 CR3: 000000000180b000 CR4: 00000000000006e0
[  143.045818] Stack:
[  143.045821]  ffff88002ff67a58 ffffffff8104faa5 ffff88021fc92e80 ffff88002fe7e408
[  143.045824]  ffff88002ff67ad8 ffffffff813a0860 0000000000000000 ffff88002f53b6e0
[  143.045826]  ffff88002f53b6f0 ffff88002fe7e0c0 ffff88002ff67fd8 ffff88002ff67fd8
[  143.045827] Call Trace:
[  143.045831]  [<ffffffff8104faa5>] wq_worker_sleeping+0xf/0x87
[  143.045836]  [<ffffffff813a0860>] __schedule+0x142/0x548
[  143.045839]  [<ffffffff813a0f4d>] schedule+0x60/0x62
[  143.045842]  [<ffffffff8103c014>] do_exit+0x8f8/0x90f
[  143.045846]  [<ffffffff8139b740>] ? printk+0x48/0x4a
[  143.045848]  [<ffffffff813a2b8d>] oops_end+0xa9/0xb1
[  143.045854]  [<ffffffff81004e5c>] die+0x55/0x61
[  143.045858]  [<ffffffff813a25e0>] do_trap+0x69/0x135
[  143.045861]  [<ffffffff813a4ec8>] ? __atomic_notifier_call_chain+0xd/0xf
[  143.045865]  [<ffffffff81002ae1>] do_invalid_op+0x93/0x9c
[  143.045889]  [<ffffffffa03e72f3>] ? assfail+0x1d/0x1f [xfs]
[  143.045893]  [<ffffffff8139b740>] ? printk+0x48/0x4a
[  143.045896]  [<ffffffff813a8608>] invalid_op+0x18/0x20
[  143.045919]  [<ffffffffa03e72f3>] ? assfail+0x1d/0x1f [xfs]
[  143.045940]  [<ffffffffa03e72f3>] ? assfail+0x1d/0x1f [xfs]
[  143.045973]  [<ffffffffa0430ed1>] xlog_state_done_syncing+0x6d/0xe4 [xfs]
[  143.046003]  [<ffffffffa0431018>] xlog_iodone+0xd0/0xd9 [xfs]
[  143.046023]  [<ffffffffa03d834f>] xfs_buf_iodone_work+0x57/0xa2 [xfs]
[  143.046027]  [<ffffffff8104f21a>] process_one_work+0x18b/0x297
[  143.046030]  [<ffffffff8104f6e6>] worker_thread+0x12e/0x1fb
[  143.046033]  [<ffffffff8104f5b8>] ? rescuer_thread+0x268/0x268
[  143.046036]  [<ffffffff81054507>] kthread+0x88/0x90
[  143.046039]  [<ffffffff8105447f>] ? __kthread_parkme+0x60/0x60
[  143.046042]  [<ffffffff813a707c>] ret_from_fork+0x7c/0xb0
[  143.046045]  [<ffffffff8105447f>] ? __kthread_parkme+0x60/0x60
[  143.046066] Code: 65 48 8b 04 25 80 b9 00 00 48 8b 80 f0 02 00 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 48 8b 87 f0 02 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 55 ba 08 00 00 00 48 89 e5 48 83 ec 10 48 8b 
[  143.046069] RIP  [<ffffffff810548fd>] kthread_data+0xb/0x11
[  143.046069]  RSP <ffff88002ff67a38>
[  143.046070] CR2: ffffffffffffffd8
[  143.046071] ---[ end trace e4f1a3c306353179 ]---
[  143.046072] Fixing recursive fault but reboot is needed!
--------------------------------------------



# Design in failure
> Yes. EIO means an IO error has occurred. That causes failure paths
> to be triggered in the upper layers.
> 
> I really don't understand what you are trying to achieve with this
> "blockup" thing. If something goes wrong with the device, then you
> *cannot recover* by sending EIO to any new IOs and then continuing
> on at a later time as though nothing has happened. The moment a
> filesystem gets EIO from a metadata write, it is likely to be
> corrupted and if you continue onwards after that you simply
> propagate the corruption.
> 
>> As Mikulas said, connection failure often be the cause of
>> I/O error from the underlying devices.
> 
> Connection failure is *rarely* the cause of IO errors, except in
> environments where SANs are in use. Even then multipathing makes
> fatal connection failure a rare occurrence. Broken hardware is a
> much more common cause of problems at the storage layers.
Yes. Connection error happens in SAN due to loose cabling
and multi-pathing may resolve the problem and
hardware problem can also be resolve by RAID.

My Idea:
- If something problematic happens in underlying devices
  writeboost device returns -EIO on any requests and
  stop all the daemons

- I will not remove `blockup`.
  Yes. If the problem is in hardware it is very difficult
  to recover.
  However, leaving a chance for recovering the device is
  at least better than just shutdown the device
  if it doesn't pollute the code so much.
  So, I will leave this option.

- As Mikulas pointed out, the current design asking the admin
  to turn off the `blockup` variable when the system is checked up
  is not reliable
  since the admin may not be able to log in the system due
  to memory starvation.
  More sophisticated way to recover the device is
  something like autonomously checking the underlying
  devices came back. But, I think this is
  too much for the reasons listed below:
  - redundancy technique is really sophisticated and -EIO returned
    means something really serious that definitely *can not* recover.
  - The example admin can't log in the system goes extreme.
    At the beginning, admin should be logged in beforehand.

BTW, what do you mean by the word "fatal"?
> Simple rule: Don't complete IOs with EIO if you haven't had a fatal
> IO error.

There are two choices for writeboost in I/O failure.
1) Returns -EIO
2) Just blocks all the in-coming processes.
writeboost doesn't corrupt in either of these two
ways of handling error. Maybe, this is because of the
nature of log-structured caching.
My question is "which is better behavior of
underlying device for the upper layer software?".
Pros for 2) is that upper layer may go on its operation
without restarting from shutdown.
Cons for 2) is that blocking the in-coming processes means all the
write barrier requests sent are not returned for a long time
and the upper layer can't tell whether the device is dead or not.
I guess you like to simply propagate the error to the parent.
But, I want to find the better way for the upper layer
, particularly for the filesystems.

# Misc
> Ugh. You should be using workqueue with timed work for this.
How is it? I don't see the implementation.
All I want to do is repeating in every interval
and as far as I know current code is the simplest.

> BTW, you're missing the handling needed by these kernel threads
> for suspend-to-disk/ram....
I didn't implement suspend/resume yet.
Maybe, I should stop all the daemons and need no
further codes for the kernel threads.

Akira

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
