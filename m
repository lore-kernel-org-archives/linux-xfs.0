Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3EE517CA0
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 19:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13014304043
	for <xfs@oss.sgi.com>; Sat, 16 Jul 2016 17:00:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	H9h3IFk1zzoNqNMo for <xfs@oss.sgi.com>;
	Sat, 16 Jul 2016 17:00:06 -0700 (PDT)
Date: Sun, 17 Jul 2016 10:00:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] Slab corruption during XFS writeback under memory pressure
Message-ID: <20160717000003.GW1922@dastard>
References: <28f77d74-5ab4-d913-2921-df90da53f393@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <28f77d74-5ab4-d913-2921-df90da53f393@fb.com>
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
To: Calvin Owens <calvinowens@fb.com>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 15, 2016 at 05:18:02PM -0700, Calvin Owens wrote:
> Hello all,
> 
> I've found a nasty source of slab corruption. Based on seeing similar symptoms
> on boxes at Facebook, I suspect it's been around since at least 3.10.
> 
> It only reproduces under memory pressure so far as I can tell: the issue seems
> to be that XFS reclaims pages from buffers that are still in use by
> scsi/block. I'm not sure which side the bug lies on, but I've only observed it
> with XFS.
> 
> [67203.776421] ==================================================================
> [67203.792521] BUG: KASAN: use-after-free in xfs_destroy_ioend+0x3bf/0x4c0 at addr ffff8804cf466288
> [67203.812036] Read of size 8 by task python2.7/22913
> [67203.822713] =============================================================================
> [67203.840917] BUG buffer_head (Not tainted): kasan: bad access detected
> [67203.855253] -----------------------------------------------------------------------------
> [67203.855253]
> [67203.876727] Disabling lock debugging due to kernel taint
> [67203.888575] INFO: Allocated in 0xffff8804cf465d40 age=18437180719206552994 cpu=2191548261 pid=-1
> [67203.908139] 	alloc_buffer_head+0x22/0xd0
> [67203.916903] 	___slab_alloc+0x4e0/0x520
> [67203.925286] 	__slab_alloc+0x43/0x70
> [67203.933087] 	kmem_cache_alloc+0x228/0x2c0
> [67203.942042] 	alloc_buffer_head+0x22/0xd0
> [67203.950782] 	alloc_page_buffers+0xa9/0x1f0
> [67203.959936] 	create_empty_buffers+0x30/0x420
> [67203.969495] 	create_page_buffers+0x120/0x1b0
> [67203.979029] 	__block_write_begin+0x16b/0x1010
> [67203.988756] 	xfs_vm_write_begin+0x55/0x1b0
> [67203.997884] 	generic_perform_write+0x288/0x510
> [67204.007771] 	xfs_file_buffered_aio_write+0x316/0x780
> [67204.018811] 	xfs_file_write_iter+0x26f/0x6c0
> [67204.028313] 	__vfs_write+0x2a0/0x620
> [67204.036276] 	vfs_write+0x159/0x4c0
> [67204.043855] 	SyS_write+0xd2/0x1b0
> [67204.051245] INFO: Freed in 0x103fc80ec age=18446651500051355200 cpu=2165122683 pid=-1
> [67204.068634] 	free_buffer_head+0x41/0x90
> [67204.077175] 	__slab_free+0x1ed/0x340
> [67204.085138] 	kmem_cache_free+0x270/0x300
> [67204.093867] 	free_buffer_head+0x41/0x90
> [67204.102422] 	try_to_free_buffers+0x171/0x240
> [67204.111925] 	xfs_vm_releasepage+0xcb/0x3b0
> [67204.121101] 	try_to_release_page+0x106/0x190
> [67204.130602] 	shrink_page_list+0x118e/0x1a10
> [67204.139910] 	shrink_inactive_list+0x42c/0xdf0
> [67204.149600] 	shrink_zone_memcg+0xa09/0xfa0
> [67204.158715] 	shrink_zone+0x2c3/0xbc0
> [67204.166679] 	do_try_to_free_pages+0x42a/0x12f0
> [67204.176562] 	try_to_free_pages+0x1a3/0x5d0
> [67204.185709] 	__alloc_pages_nodemask+0xbeb/0x20d0
> [67204.195979] 	alloc_pages_vma+0x11b/0x5e0
> [67204.204709] 	handle_mm_fault+0x2c27/0x47d0
> [67204.213823] INFO: Slab 0xffffea00133d1900 objects=37 used=14 fp=0xffff8804cf464530 flags=0x2000000000004080
> [67204.235439] INFO: Object 0xffff8804cf466260 @offset=8800 fp=0xbbbbbbbbbbbbbbbb

Hmmm - can only get there with a clean page, so this should be fine.

> [67204.455817] CPU: 1 PID: 22913 Comm: python2.7 Tainted: G    B           4.7.0-rc7-calvinowens-1468357363-00001-gcaa3dc6 #1
> [67204.480313] Hardware name: Wiwynn   HoneyBadger/PantherPlus, BIOS HBM6.71 02/03/2016
> [67204.497509]  ffff88075e99f480 ffff88075ec87a30 ffffffff81e8b8e4 ffff8804cf464000
> [67204.514224]  ffff8804cf466260 ffff88075ec87a60 ffffffff8153a995 ffff88075e99f480
> [67204.530924]  ffffea00133d1900 ffff8804cf466260 dffffc0000000000 ffff88075ec87a88
> [67204.547624] Call Trace:
> [67204.553086]  <IRQ>  [<ffffffff81e8b8e4>] dump_stack+0x68/0x94
> [67204.565946]  [<ffffffff8153a995>] print_trailer+0x115/0x1a0
> [67204.578334]  [<ffffffff81541174>] object_err+0x34/0x40
> [67204.589762]  [<ffffffff815436e7>] kasan_report_error+0x217/0x530
> [67204.616847]  [<ffffffff81543b33>] __asan_report_load8_noabort+0x43/0x50
> [67204.645085]  [<ffffffff819d651f>] xfs_destroy_ioend+0x3bf/0x4c0
> [67204.658243]  [<ffffffff819d69d4>] xfs_end_bio+0x154/0x220
> [67204.685362]  [<ffffffff81de0c58>] bio_endio+0x158/0x1b0
> [67204.696983]  [<ffffffff81dff61b>] blk_update_request+0x18b/0xb80
> [67204.710334]  [<ffffffff821baf57>] scsi_end_request+0x97/0x5a0
> [67204.723108]  [<ffffffff821c5558>] scsi_io_completion+0x438/0x1690
> [67204.807293]  [<ffffffff821a8d95>] scsi_finish_command+0x375/0x4e0
> [67204.820838]  [<ffffffff821c3940>] scsi_softirq_done+0x280/0x340
> [67204.848884]  [<ffffffff81e1e13f>] blk_done_softirq+0x1ff/0x360
> [67204.875074]  [<ffffffff82a08cad>] __do_softirq+0x22d/0x8d7
> [67204.887270]  [<ffffffff8113d42c>] irq_exit+0x15c/0x190
> [67204.898697]  [<ffffffff82a085e3>] smp_apic_timer_interrupt+0x83/0xa0
> [67204.912815]  [<ffffffff82a06b29>] apic_timer_interrupt+0x89/0x90
> [67205.029113] ==================================================================

But this indicates that the page is under writeback at this point,
so that tends to indicate that the above freeing was incorrect.

Hmmm - it's clear we've got direct reclaim involved here, and the
suspicion of a dirty page that has had it's bufferheads cleared.
Are there any other warnings in the log from XFS prior to kasan
throwing the error?

> Is there anything else I can send that might be helpful?

full console/dmesg output from a crashed machine, plus:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> --
> /*
>  * Run as "./repro outfile 1000", where "outfile" sits on an XFS filesystem.
>  */
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <signal.h>
> #include <unistd.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <sys/mman.h>
> 
> #define CHUNK (32768)
> 
> static const char crap[CHUNK];
> 
> int main(int argc, char **argv)
> {
> 	int r, fd, i;
> 	size_t allocsize, count;
> 	void *p;
> 
> 	if (argc != 3) {
> 		printf("Usage: %s filename count\n", argv[0]);
> 		return 1;
> 	}
> 
> 	fd = open(argv[1], O_RDWR|O_CREAT, 0644);
> 	if (fd == -1) {
> 		perror("Can't open");
> 		return 1;
> 	}
> 
> 	if (!fork()) {
> 		count = atol(argv[2]);
> 
> 		while (1) {
> 			for (i = 0; i < count; i++)
> 				if (write(fd, crap, CHUNK) != CHUNK)
> 					perror("Eh?");
> 
> 			fsync(fd);
> 			ftruncate(fd, 0);
> 		}

Hmmmm. Truncate is used, but only after fsync. If the truncate
is removed, does the problem go away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
