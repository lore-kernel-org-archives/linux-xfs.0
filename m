Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 14:05:04 -0700 (PDT)
Received: from smtp2.linux-foundation.org (smtp2.linux-foundation.org [207.189.120.14])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5DL4wWt000628
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 14:04:59 -0700
Date: Wed, 13 Jun 2007 14:04:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on
 raid6)
In-Reply-To: <466FD214.9070603@dgreaves.com>
Message-ID: <alpine.LFD.0.98.0706131344550.14121@woody.linux-foundation.org>
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com>
 <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org>
 <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>
 <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com>
 <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com>
 <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com>
 <4669A965.20403@dgreaves.com> <alpine.LFD.0.98.0706121123550.14121@woody.linux-foundation.org>
 <466FD214.9070603@dgreaves.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>



On Wed, 13 Jun 2007, David Greaves wrote:
> 
> git-bisect bad
> 9666f4009c22f6520ac3fb8a19c9e32ab973e828 is first bad commit
> commit 9666f4009c22f6520ac3fb8a19c9e32ab973e828
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Fri May 4 21:27:47 2007 +0200
> 
>     libata: reimplement suspend/resume support using sdev->manage_start_stop
> 
> Good.

Ok, good. So the bug is apparently in the generic SCSI layer start/stop
handling. I'm not entirely surprised, most people would never have 
triggered it (I _think_ it's disabled by default for all devices, and that 
the libata-scsi.c change was literally the first thing to ever enable it 
by default for anything!)

> So here's a sysrq-t from a failed resume. Ask if you'd like anything else...

I'm not seeing anything really obvious. The traces would probably look 
better if you enabled CONFIG_FRAME_POINTER, though. That should cut down 
on some of the noise and make the traces a bit more readable.

"hibernate" is definitely stuck on the new code: it's in the 
"sd_start_stop_device()" call-chain, but I note that ata_aux at the same 
time is also doing some sd_spinup_disk logic as part of rescanning. Maybe 
that's part of the confusion: trying to rescan the bus at the same time 
upper layers (who already *know* the disks that are there) are trying to 
spin up the devices.

Tejun? Jeff?

		Linus

--- some per-thread commentary ---

There's the worrisome thing we've seen before, with the "events" thread 
apparently busy-looping:

> events/0      R running     0     5      2 (L-TLB)

but the more fundamental problem would seem to be ata_aux being in some 
long (infinite?) disk wait:

> ata_aux       D F65F09A4     0   122      2 (L-TLB)
>        c19dfd20 00000046 f786c800 f65f09a4 f7ea23b8 c02bcdef ce2e3b9f 4d64703f
>        ffffcfff f7ea23b8 00000082 f7ea2418 0005eb1d 00000082 f7c9f0b0 c196913c
>        f786c800 000003d4 605db977 00000009 f7ea23b8 c19dfe08 f65f09a4 c19dfd3c
> Call Trace:
>  [<c02bcdef>] scsi_prep_fn+0x8f/0x130
>  [<c0369a24>] wait_for_completion+0x64/0xa0
>  [<c01175e0>] default_wake_function+0x0/0x10
>  [<c021f85b>] __generic_unplug_device+0x2b/0x30
>  [<c01175e0>] default_wake_function+0x0/0x10
>  [<c02207a7>] blk_execute_rq+0xa7/0xe0
>  [<c0220970>] blk_end_sync_rq+0x0/0x30
>  [<c0146a8f>] buffered_rmqueue+0x9f/0x100
>  [<c0146c50>] get_page_from_freelist+0x80/0xc0
>  [<c02bbd48>] scsi_execute+0xb8/0x110
>  [<c02bbe0b>] scsi_execute_req+0x6b/0x90
>  [<c02c22f6>] sd_spinup_disk+0x76/0x440
>  [<c02c36fe>] sd_revalidate_disk+0x6e/0x160
>  [<c02c17a4>] __scsi_disk_get+0x34/0x40
>  [<c02c200d>] sd_rescan+0x1d/0x40
>  [<c02bf350>] scsi_rescan_device+0x40/0x50
>  [<c02ce39c>] ata_scsi_dev_rescan+0x5c/0x70
>  [<c02ce340>] ata_scsi_dev_rescan+0x0/0x70
>  [<c0127f2a>] run_workqueue+0x4a/0xf0
>  [<c01280dd>] worker_thread+0xcd/0xf0
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c0128010>] worker_thread+0x0/0xf0
>  [<c012b20a>] kthread+0x6a/0x70
>  [<c012b1a0>] kthread+0x0/0x70
>  [<c0104a0b>] kernel_thread_helper+0x7/0x3c


And scsi_eh_4/5 seems to be potentially doing something too:

> scsi_eh_4     S F786C800     0   803      2 (L-TLB)
>        f7fc3fc0 00000046 f786c800 f786c800 f7ea23b8 c02bd166 f7964044 f7ea23b8
>        00000292 c021f7f2 6154d436 00000009 002f304e 00000000 c1932550 f7d0915c
>        0000006e 000ec1d6 6154d436 00000009 00000000 f7964000 c02bb740 fffffffc
> Call Trace:
>  [<c02bd166>] scsi_request_fn+0x196/0x280
>  [<c021f7f2>] blk_remove_plug+0x32/0x70
>  [<c02bb740>] scsi_error_handler+0x0/0xa0
>  [<c02bb781>] scsi_error_handler+0x41/0xa0
>  [<c02bb740>] scsi_error_handler+0x0/0xa0
>  [<c012b20a>] kthread+0x6a/0x70
>  [<c012b1a0>] kthread+0x0/0x70
>  [<c0104a0b>] kernel_thread_helper+0x7/0x3c
>  =======================
> scsi_eh_5     S F786C400     0   805      2 (L-TLB)
>        f7e3ffc0 00000046 f786c400 f786c400 f7ea2730 c02bd166 f786cc44 f7ea2730
>        00000292 c021f7f2 67583eed 00000009 002f0e42 00000000 c19615d0 f7c9f1bc
>        0000006e 000ec010 67583eed 00000009 00000000 f786cc00 c02bb740 fffffffc
> Call Trace:
>  [<c02bd166>] scsi_request_fn+0x196/0x280
>  [<c021f7f2>] blk_remove_plug+0x32/0x70
>  [<c02bb740>] scsi_error_handler+0x0/0xa0
>  [<c02bb781>] scsi_error_handler+0x41/0xa0
>  [<c02bb740>] scsi_error_handler+0x0/0xa0
>  [<c012b20a>] kthread+0x6a/0x70
>  [<c012b1a0>] kthread+0x0/0x70
>  [<c0104a0b>] kernel_thread_helper+0x7/0x3c

.. and here it's starting to get interesting: what is md_raid5 hung on?

> md0_raid5     D 1D3836C7     0   836      2 (L-TLB)
>        f7cbfdf0 00000046 f7ea3888 1d3836c7 00000008 c0221036 06a47600 00011210
>        c191ede0 c01454ba 5324bddc 00000009 0002fb08 00000000 f7d09050 f7e2c6bc
>        0000006e 0000320f 532bcd0b 00000009 f7ea3888 c1a4f000 f7cbfe18 c1a4f13c
> Call Trace:
>  [<c0221036>] generic_make_request+0x146/0x1d0
>  [<c01454ba>] mempool_alloc+0x2a/0xc0
>  [<c02f639e>] md_super_wait+0x7e/0xc0
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c017eff1>] bio_clone+0x31/0x40
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c02fe880>] write_sb_page+0x50/0x80
>  [<c02fe9c2>] write_page+0x112/0x120
>  [<c02f8247>] sync_sbs+0x77/0xe0
>  [<c02fed09>] bitmap_update_sb+0x69/0xa0
>  [<c02f83e8>] md_update_sb+0x138/0x2c0
>  [<c0369725>] schedule+0x2e5/0x580
>  [<c02fe2dd>] md_check_recovery+0x2dd/0x360
>  [<c02f11e0>] raid5d+0x10/0xe0
>  [<c02fc7c5>] md_thread+0x55/0x110
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c012b5e0>] autoremove_wake_function+0x0/0x50
>  [<c02fc770>] md_thread+0x0/0x110
>  [<c012b20a>] kthread+0x6a/0x70
>  [<c012b1a0>] kthread+0x0/0x70
>  [<c0104a0b>] kernel_thread_helper+0x7/0x3c

and here's the hibernate damon itself, doing the "sd_start_stop_device()" 
that is supposed to get the ball rolling, but it seems to be another 
infinite wait:

> hibernate     D F65F0C64     0  3907   2761 (NOTLB)
>        f67a5cd0 00000082 f786c800 f65f0c64 f7ea23b8 c02bcdef f7ea2040 c1ad1180
>        f78b3400 f7ea23b8 5b7f815f 00000009 00003442 00000000 c19615d0 f73a5b5c
>        0000006e 0005cef4 5b7f815f 00000009 f7ea23b8 f67a5db8 f65f0c64 f67a5cec
> Call Trace:
>  [<c02bcdef>] scsi_prep_fn+0x8f/0x130
>  [<c0369a24>] wait_for_completion+0x64/0xa0
>  [<c01175e0>] default_wake_function+0x0/0x10
>  [<c021f85b>] __generic_unplug_device+0x2b/0x30
>  [<c01175e0>] default_wake_function+0x0/0x10
>  [<c02207a7>] blk_execute_rq+0xa7/0xe0
>  [<c0220970>] blk_end_sync_rq+0x0/0x30
>  [<c011ece2>] irq_exit+0x42/0x70
>  [<c0111b80>] smp_apic_timer_interrupt+0x30/0x40
>  [<c01048b8>] apic_timer_interrupt+0x28/0x30
>  [<c02bbd48>] scsi_execute+0xb8/0x110
>  [<c02bbe0b>] scsi_execute_req+0x6b/0x90
>  [<c02c3cc0>] sd_start_stop_device+0x70/0x120
>  [<c011ae17>] printk+0x17/0x20
>  [<c02c4045>] sd_resume+0x55/0xa0
>  [<c02c022f>] scsi_bus_resume+0x6f/0x80
>  [<c029da36>] resume_device+0x136/0x190
>  [<c022aaf5>] kobject_get+0x15/0x20
>  [<c0297ad1>] get_device+0x11/0x20
>  [<c029dbad>] dpm_resume+0xbd/0xc0
>  [<c029dbcb>] device_resume+0x1b/0x40
>  [<c013c043>] hibernate+0x103/0x1a0
>  [<c013b205>] state_store+0xc5/0x100
>  [<c013b140>] state_store+0x0/0x100
>  [<c0194080>] sysfs_write_file+0x0/0x80
>  [<c0193e7f>] subsys_attr_store+0x3f/0x50
>  [<c019406e>] flush_write_buffer+0x2e/0x40
>  [<c01940e5>] sysfs_write_file+0x65/0x80
>  [<c015ec39>] vfs_write+0x89/0x110
>  [<c015ed87>] sys_write+0x47/0x80
>  [<c0168c9b>] sys_dup2+0x9b/0xd0
>  [<c0103ef0>] syscall_call+0x7/0xb
>  =======================
> 
