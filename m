Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbdIVDoW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Sep 2017 23:44:22 -0400
Date: Fri, 22 Sep 2017 11:44:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] iomap_dio_rw: Allocate AIO completion queue before
 submitting dio
Message-ID: <20170922034420.GA8034@eguan.usersys.redhat.com>
References: <20170921095234.12401-1-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921095234.12401-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org

On Thu, Sep 21, 2017 at 03:22:34PM +0530, Chandan Rajendra wrote:
> Executing xfs/104 test in a loop on Linux-v4.13 kernel on a ppc64
> machine can cause the following NULL pointer dereference,
> 
> Unable to handle kernel paging request for data at address 0x00000100
> Faulting instruction address: 0xc0000000000fece8
> Oops: Kernel access of bad area, sig: 11 [#1]
> SMP NR_CPUS=2048
> DEBUG_PAGEALLOC
> NUMA
> pSeries
> Modules linked in:
> CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.13.0 #1
> task: c00000063849c200 task.stack: c0000006384f0000
> NIP: c0000000000fece8 LR: c0000000000ff2cc CTR: c000000000383380
> REGS: c00000063ffdb400 TRAP: 0300   Not tainted  (4.13.0)
> MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>
>   CR: 28002222  XER: 20000000
> CFAR: c0000000000227a4 DAR: 0000000000000100 DSISR: 40000000 SOFTE: 0
> GPR00: c0000000000ff2cc c00000063ffdb680 c000000001252e00 0000000000000800
> GPR04: 0000000000000000 c0000006387b8730 c000000633d5db70 0000000fffffffe1
> GPR08: c0000003aa89ed68 0000000000000000 0000000000000000 c000000633d5db70
> GPR12: 0000000028002422 c00000000fd80a00 c0000006384f3f90 c00000063ffd8000
> GPR16: 0000000000000000 c0000006387b8730 c0000000012475e0 c0000000012475e0
> GPR20: 0000000000000002 0000000000000000 0000000000000001 0000000000000002
> GPR24: 0000000000000010 c00000063e155800 0000000000000800 0000000000000800
> GPR28: 0000000000000000 c000000633d5db00 0000000000000000 0000000000000000
> NIP [c0000000000fece8] .__queue_work+0x68/0x600
> LR [c0000000000ff2cc] .queue_work_on+0x4c/0x80
> Call Trace:
> [c00000063ffdb680] [c00000063ffdb720] 0xc00000063ffdb720 (unreliable)
> [c00000063ffdb770] [c0000000000ff2cc] .queue_work_on+0x4c/0x80
> [c00000063ffdb7f0] [c00000000038343c] .iomap_dio_bio_end_io+0xbc/0x1f0
> [c00000063ffdb880] [c0000000006cdc18] .bio_endio+0x118/0x1f0
> [c00000063ffdb910] [c0000000006d9e30] .blk_update_request+0xd0/0x470
> [c00000063ffdb9b0] [c0000000006e8284] .blk_mq_end_request+0x24/0xc0
> [c00000063ffdba30] [c00000000082ba50] .lo_complete_rq+0x40/0xe0
> [c00000063ffdbab0] [c0000000006e5e48] .__blk_mq_complete_request_remote+0x28/0x40
> [c00000063ffdbb20] [c00000000018e674] .flush_smp_call_function_queue+0xc4/0x1e0
> [c00000063ffdbbb0] [c00000000003f94c] .smp_ipi_demux_relaxed+0x8c/0x100
> [c00000063ffdbc40] [c000000000081054] .icp_hv_ipi_action+0x54/0xa0
> [c00000063ffdbcc0] [c0000000001505a4] .__handle_irq_event_percpu+0x84/0x2c0
> [c00000063ffdbd90] [c000000000150808] .handle_irq_event_percpu+0x28/0x80
> [c00000063ffdbe20] [c000000000156858] .handle_percpu_irq+0x78/0xc0
> [c00000063ffdbea0] [c00000000014ee70] .generic_handle_irq+0x40/0x70
> [c00000063ffdbf10] [c000000000015a88] .__do_irq+0x88/0x200
> [c00000063ffdbf90] [c000000000027a70] .call_do_irq+0x14/0x24
> [c0000006384f3810] [c000000000015c84] .do_IRQ+0x84/0x130
> 
> This occurs due to the following sequence of events,
> 
> 1. Allocate dio for Direct I/O write.
> 2. Invoke iomap_apply() until iov_iter_count() bytes have been submitted.
>    - Assume that we have submitted atleast one bio. Hence iomap_dio->ref value
>      will be >= 2.
>    - If during the second iteration, iomap_apply() ends up returning -ENOSPC, we would
>      break out of the loop and since the 'ret' value is a negative number we
>      end up not allocating memory for super_block->s_dio_done_wq.
> 3. Meanwhile, iomap_dio_bio_end_io() is invoked for bios that have been
>    submitted and here the code ends up dereferencing the NULL pointer stored
>    at super_block->s_dio_done_wq.
> 
> This commit fixes the bug by allocating memory for
> super_block->s_dio_done_wq before iomap_apply() is invoked.
> 
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

I tested this patch on x86_64 host. Without the patch, I could crash the
host by running xfs/104 within 50 iterations, and host survived 500
iterations of xfs/104 run with this patch applied. So

Tested-by: Eryu Guan <eguan@redhat.com>

Thanks!
Eryu
