Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36016 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728262AbfAJRJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jan 2019 12:09:47 -0500
Date: Thu, 10 Jan 2019 09:09:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: BUG: iomap_dio_rw() accesses freed memory
Message-ID: <20190110170935.GY12689@magnolia>
References: <2762504.H5M01fycxG@localhost.localdomain>
 <20190110142552.GA9661@lst.de>
 <1829543.H1xe2kokQy@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1829543.H1xe2kokQy@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Jan 10, 2019 at 10:19:26PM +0530, Chandan Rajendra wrote:
> On Thursday, January 10, 2019 7:55:52 PM IST Christoph Hellwig wrote:
> > On Thu, Jan 10, 2019 at 03:47:09PM +0530, Chandan Rajendra wrote:
> > > The following call trace is observed on next-20190110, when generic/323 test
> > > is executed on a 4k block sized XFS filesystem on ppc64le machine,
> > > 
> > > [ T7710] BUG: Unable to handle kernel data access at 0x6b6b6b6b6b6b6be3
> > > [ T7710] Faulting instruction address: 0xc00000000090372c
> > > [ T7710] Oops: Kernel access of bad area, sig: 11 [#12]
> > > [ T7710] LE SMP NR_CPUS=2048 DEBUG_PAGEALLOC NUMA pSeries
> > > [ T7710] Modules linked in:
> > > [ T7710] CPU: 7 PID: 7710 Comm: aio-last-ref-he Tainted: G      D           5.0.0-rc1-next-20190110 #36
> > > [ T7710] NIP:  c00000000090372c LR: c0000000004bf75c CTR: c00000000091cfe0
> > > [ T7710] REGS: c00000062fc67730 TRAP: 0380   Tainted: G      D            (5.0.0-rc1-next-20190110)
> > > [ T7710] MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 44428224  XER: 20000000
> > > [ T7710] CFAR: c0000000004bf758 IRQMASK: 0 
> > > [ T7710] GPR00: c0000000004bf75c c00000062fc679c0 c0000000017f4b00 6b6b6b6b6b6b6b6b 
> > > [ T7710] GPR04: 000000006b6b6b6b 0000000000000001 0000000000000000 0000000000000001 
> > > [ T7710] GPR08: 0000000000000000 6b6b6b6b6b6b6b6b 0000000000000000 0000000000000000 
> > > [ T7710] GPR12: 0000000044428224 c00000003ff93700 00000000000f0000 0000000105611a30 
> > > [ T7710] GPR16: 00007fff52fde088 00000001056119e8 00007fff52fde288 00000001056119c8 
> > > [ T7710] GPR20: 0000000000000010 c000000634258bb8 00000000000effff c000000627e94918 
> > > [ T7710] GPR24: c000000000fb3290 c000000627e94700 fffffffffffffdef 00000000000f0000 
> > > [ T7710] GPR28: 0000000000000000 0000000000000002 c0000006247ae180 c000000634258b98 
> > > [ T7710] NIP [c00000000090372c] blk_poll+0x2c/0x3d0
> > > [ T7710] LR [c0000000004bf75c] iomap_dio_rw+0x45c/0x4f0
> > > [ T7710] Call Trace:
> > > [ T7710] [c00000062fc67a60] [c0000000004bf7b8] iomap_dio_rw+0x4b8/0x4f0
> > > [ T7710] [c00000062fc67b20] [c0000000006ed3a4] xfs_file_dio_aio_read+0xb4/0x250
> > > [ T7710] [c00000062fc67b80] [c0000000006edbc4] xfs_file_read_iter+0x114/0x160
> > > [ T7710] [c00000062fc67bc0] [c00000000049476c] aio_read+0x12c/0x1d0
> > > [ T7710] [c00000062fc67cc0] [c000000000495094] io_submit_one+0x634/0xbd0
> > > [ T7710] [c00000062fc67d90] [c0000000004956f0] sys_io_submit+0xc0/0x380
> > > [ T7710] [c00000062fc67e20] [c00000000000bae4] system_call+0x5c/0x70
> > > [ T7710] Instruction dump:
> > > [ T7710] 60000000 3c4c00ef 38421400 7c0802a6 60000000 7d800026 2f84ffff fb81ffe0 
> > > [ T7710] 3b800000 91810008 f821ff61 419e01a4 <e9230078> 793c6fe3 41820198 7c0802a6 
> > > [ T7710] ---[ end trace b14f7219ccf85a08 ]---
> > > [ T7710]
> > > 
> > > 
> > > The is happening due to the following sequence of events,
> > > 
> > > 1. iomap_dio_rw() allocates a 'struct iomap_dio'. Ref count is set to 1.
> > > 2. iomap_dio_bio_actor increments ref count to 2 and submits a bio.
> > > 3. iomap_dio_rw() decrements ref count. Since dio->ref is non-zero,
> > >    !atomic_dec_and_test(&dio->ref) would evaluate to true.
> > > 4. Meanwhile the bio submitted in step 2 completes I/O. iomap_dio_bio_end_io()
> > >    decrements dio->ref to the value of 0. This would inturn call
> > >    iomap_dio_complete() which frees the iomap_dio structure.
> > 
> > If iomap_dio_bio_end_io completes the dio this should be an AIO request.
> > 
> > > 5. iomap_dio_rw() can now deference a freed structure via either
> > >    "!dio->submit.last_queue" or "!blk_poll(dio->submit.last_queue,
> > >    dio->submit.cookie, true)" 
> > 
> > But then again this code is only executed for the wait_for_completion
> > case.  So I wonder how you manage to hit this.
> 
> A call to printk() right after " if (!atomic_dec_and_test(&dio->ref)) { " in
> iomap_dio_rw() gave,
> 
> iomap_dio_rw: dio = 00000000540abd3d; dio->submit.last_queue = 000000000788c132; dio->wait_for_completion = 107
> 
> This is most probably because the freed dio's memory is already being written
> to by its owning code.

generic/323 on a very fast scsi device reproduces (and hangs) easily.
The UAF happens (on my machine, anyway) because the bio endio function
gets called before the submitting process even reaches blk_finish_plug.

This is the exact same issue being discussed in "Broken dio refcounting
leads to livelock?"  I think Dave Chinner was working on a less gross
fix than the one we'd come up with in that other thread.

--D

> -- 
> chandan
> 
> 
> 
