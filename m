Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfAHA0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 19:26:54 -0500
Date: Mon, 7 Jan 2019 16:26:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Broken dio refcounting leads to livelock?
Message-ID: <20190108002633.GL12689@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

Hi Christoph,

I have a question about refcounting in struct iomap_dio:

As I mentioned late last year, I've been seeing a livelock since the
early 4.20-rcX era in iomap_dio_rw when running generic/323.  The
relevant part of the function starts around line 1910:

	blk_finish_plug(&plug);

	if (ret < 0)
		iomap_dio_set_error(dio, ret);

	/*
	 * If all the writes we issued were FUA, we don't need to flush the
	 * cache on IO completion. Clear the sync flag for this case.
	 */
	if (dio->flags & IOMAP_DIO_WRITE_FUA)
		dio->flags &= ~IOMAP_DIO_NEED_SYNC;

	if (!atomic_dec_and_test(&dio->ref)) {
		int clang = 0;

		if (!dio->wait_for_completion)
			return -EIOCBQUEUED;

		for (;;) {
			set_current_state(TASK_UNINTERRUPTIBLE);
			if (!READ_ONCE(dio->submit.waiter))
				break;

			if (!(iocb->ki_flags & IOCB_HIPRI) ||
			    !dio->submit.last_queue ||
			    !blk_poll(dio->submit.last_queue,
					 dio->submit.cookie, true))
				io_schedule(); <--------- here
		}
		__set_current_state(TASK_RUNNING);
	}

	ret = iomap_dio_complete(dio);

I finally had time to look into this, and I noticed garbage values for
dio->submit.waiter in *dio right before we call io_schedule.  I suspect
this is a use-after-free, so I altered iomap_dio_complete to memset the
entire structure to 0x5C just prior to kfreeing the *dio, and sure
enough I saw 0x5C in all the dio fields right before the io_schedule
call.

Next I instrumented all the places where we access dio->ref to see
what's going on, and observed the following sequence:

 1. ref == 2 just before the blk_finish_plug call.
    dio->wait_for_completion == false.
 2. ref == 2 just before the "if (!atomic_dec_and_test(...))"
 3. ref == 1 just after the "if (!atomic_dec_and_test(...))"

Next we apparently end up in iomap_dio_bio_end_io:

 4. ref == 1 just before the "if (atomic_dec_and_test(...))"
 5. ref == 0 just after the "if (atomic_dec_and_test(...))"
 6. iomap_dio_bio_end_io calls iomap_dio_complete, frees the dio after
    poisoning it with 0x5C as described above.

Then we jump back to iomap_dio_rw, and:

 7. ref = 0x5c5c5c5c just before the "if (!(iocb->ki_flags & IOCB_HIPRI)...)"
    However, dio->wait_for_completion is 0x5c5c5c5c so we incorrectly
    call io_schedule and never wake up.

KASAN confirms this diagnosis.  I noticed that only ~100us elapse
between the unplug and the bio endio function being called; I've found
that I can reproduce this in a qemu vm with a virtio-scsi device backed
by a tmpfs file on the host.  My guess is that with slower scsi device
the dispatch would take long enough that iomap_dio_rw would have
returned -EIOCBQUEUED long before the bio end_io function gets called
and frees the dio?

Anyhow, I'm not sure how to fix this.  It's clear that iomap_dio_rw
can't drop its ref to the dio until it's done using the dio fields.
It's tempting to change the if (!atomic_dec_and_test()) to a if
(atomic_read() > 1) and only drop the ref just before returning
-EIOCBQUEUED or just before calling iomap_dio_complete... but that just
pushes the livelock to kill_ioctx.

Brain scrambled, kicking to the list to see if anyone has something
smarter to say. ;)

--D

==================================================================
BUG: KASAN: use-after-free in iomap_dio_rw+0x1197/0x1200
Read of size 1 at addr ffff88807780e0ec by task aio-last-ref-he/2527

CPU: 2 PID: 2527 Comm: aio-last-ref-he Not tainted 5.0.0-rc1-xfsx #rc1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x7c/0xc0
 print_address_description+0x6c/0x23c
 ? iomap_dio_rw+0x1197/0x1200
 kasan_report.cold.3+0x1c/0x3a
 ? iomap_dio_rw+0x1197/0x1200
 ? iomap_dio_rw+0x1197/0x1200
 iomap_dio_rw+0x1197/0x1200
 ? iomap_seek_data+0x130/0x130
 ? lock_contended+0xd70/0xd70
 ? lock_acquire+0x102/0x2f0
 ? xfs_ilock+0x137/0x3e0 [xfs]
 ? xfs_file_dio_aio_read+0x10f/0x360 [xfs]
 ? down_read_nested+0x78/0xc0
 ? xfs_file_dio_aio_read+0x123/0x360 [xfs]
 xfs_file_dio_aio_read+0x123/0x360 [xfs]
 ? __lock_acquire+0x645/0x44c0
 xfs_file_read_iter+0x41a/0x7a0 [xfs]
 ? aio_setup_rw+0xb4/0x170
 aio_read+0x29f/0x3d0
 ? mark_held_locks+0x130/0x130
 ? aio_prep_rw+0x960/0x960
 ? kvm_clock_read+0x14/0x30
 ? kvm_clock_read+0x14/0x30
 ? kvm_sched_clock_read+0x5/0x10
 ? sched_clock+0x5/0x10
 ? sched_clock_cpu+0x18/0x1b0
 ? find_held_lock+0x33/0x1c0
 ? lock_acquire+0x102/0x2f0
 ? lock_downgrade+0x590/0x590
 io_submit_one+0xf4e/0x17e0
 ? __x64_sys_io_setup+0x2f0/0x2f0
 ? sched_clock_cpu+0x18/0x1b0
 ? find_held_lock+0x33/0x1c0
 ? lock_downgrade+0x590/0x590
 ? __x64_sys_io_submit+0x199/0x430
 __x64_sys_io_submit+0x199/0x430
 ? __ia32_compat_sys_io_submit+0x410/0x410
 ? trace_hardirqs_on_thunk+0x1a/0x1c
 ? do_syscall_64+0x8f/0x3c0
 do_syscall_64+0x8f/0x3c0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f3589847687
Code: 00 00 00 49 83 38 00 75 ed 49 83 78 08 00 75 e6 8b 47 0c 39 47 08 75 de 31 c0 c3 0f 1f 84 00 00 00 00 00 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00
RSP: 002b:00007f356d7f9818 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f3589847687
RDX: 00007f356d7f98c0 RSI: 0000000000000001 RDI: 00007f3589b50000
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007f356d7f98c0
R13: 0000000000000002 R14: 00007f356d7f9d40 R15: 00000000000a0000

Allocated by task 2527:
 kasan_kmalloc+0xc6/0xd0
 iomap_dio_rw+0x261/0x1200
 xfs_file_dio_aio_read+0x123/0x360 [xfs]
 xfs_file_read_iter+0x41a/0x7a0 [xfs]
 aio_read+0x29f/0x3d0
 io_submit_one+0xf4e/0x17e0
 __x64_sys_io_submit+0x199/0x430
 do_syscall_64+0x8f/0x3c0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2519:
 __kasan_slab_free+0x133/0x180
 kfree+0xe4/0x2d0
 iomap_dio_complete+0x37b/0x6e0
 iomap_dio_complete_work+0x52/0x80
 iomap_dio_bio_end_io+0x50e/0x7a0
 blk_update_request+0x234/0x8b0
 scsi_end_request+0x7f/0x6b0
 scsi_io_completion+0x18c/0x14a0
 blk_done_softirq+0x258/0x390
 __do_softirq+0x228/0x8de

The buggy address belongs to the object at ffff88807780e0c0
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 44 bytes inside of
 128-byte region [ffff88807780e0c0, ffff88807780e140)
The buggy address belongs to the page:
page:ffffea0001de0380 count:1 mapcount:0 mapping:ffff88802dc03500 index:0x0
flags: 0x4fff80000000200(slab)
raw: 04fff80000000200 dead000000000100 dead000000000200 ffff88802dc03500
raw: 0000000000000000 0000000080150015 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88807780df80: fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
 ffff88807780e000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807780e080: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                          ^
 ffff88807780e100: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88807780e180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint
