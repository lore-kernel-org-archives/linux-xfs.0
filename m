Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BC2C77B7C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 12:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbjEIMh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 May 2023 08:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbjEIMh5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2023 08:37:57 -0400
Received: from out28-59.mail.aliyun.com (out28-59.mail.aliyun.com [115.124.28.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D516D468A
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 05:37:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04471734|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.128835-0.00386567-0.867299;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.ScbgzMr_1683635871;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.ScbgzMr_1683635871)
          by smtp.aliyun-inc.com;
          Tue, 09 May 2023 20:37:51 +0800
Date:   Tue, 09 May 2023 20:37:52 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: performance regression between 6.1.x and 5.15.x
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20230509013625.GS3223426@dread.disaster.area>
References: <20230509072552.7E8B.409509F4@e16-tech.com> <20230509013625.GS3223426@dread.disaster.area>
Message-Id: <20230509203751.E6D2.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> On Tue, May 09, 2023 at 07:25:53AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > On Mon, May 08, 2023 at 10:46:12PM +0800, Wang Yugui wrote:
> > > > Hi,
> > > > 
> > > > > Hi,
> > > > > 
> > > > > I noticed a performance regression of xfs 6.1.27/6.1.23,
> > > > > with the compare to xfs 5.15.110.
> > > > > 
> > > > > It is yet not clear whether  it is a problem of xfs or lvm2.
> > > > > 
> > > > > any guide to troubleshoot it?
> > > > > 
> > > > > test case:
> > > > >   disk: NVMe PCIe3 SSD *4 
> > > > >   LVM: raid0 default strip size 64K.
> > > > >   fio -name write-bandwidth -rw=write -bs=1024Ki -size=32Gi -runtime=30
> > > > >    -iodepth 1 -ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=4
> > > > >    -directory=/mnt/test
> > > > > 
> > > > > 
> > > > > 6.1.27/6.1.23
> > > > > fio bw=2623MiB/s (2750MB/s)
> > > > > perf report:
> > > > > Samples: 330K of event 'cycles', Event count (approx.): 120739812790
> > > > > Overhead  Command  Shared Object        Symbol
> > > > >   31.07%  fio      [kernel.kallsyms]    [k] copy_user_enhanced_fast_string
> > > > >    5.11%  fio      [kernel.kallsyms]    [k] iomap_set_range_uptodate.part.24
> > > > >    3.36%  fio      [kernel.kallsyms]    [k] asm_exc_nmi
> > > > >    3.29%  fio      [kernel.kallsyms]    [k] native_queued_spin_lock_slowpath
> > > > >    2.27%  fio      [kernel.kallsyms]    [k] iomap_write_begin
> > > > >    2.18%  fio      [kernel.kallsyms]    [k] get_page_from_freelist
> > > > >    2.11%  fio      [kernel.kallsyms]    [k] xas_load
> > > > >    2.10%  fio      [kernel.kallsyms]    [k] xas_descend
> > > > > 
> > > > > 5.15.110
> > > > > fio bw=6796MiB/s (7126MB/s)
> > > > > perf report:
> > > > > Samples: 267K of event 'cycles', Event count (approx.): 186688803871
> > > > > Overhead  Command  Shared Object       Symbol
> > > > >   38.09%  fio      [kernel.kallsyms]   [k] copy_user_enhanced_fast_string
> > > > >    6.76%  fio      [kernel.kallsyms]   [k] iomap_set_range_uptodate
> > > > >    4.40%  fio      [kernel.kallsyms]   [k] xas_load
> > > > >    3.94%  fio      [kernel.kallsyms]   [k] get_page_from_freelist
> > > > >    3.04%  fio      [kernel.kallsyms]   [k] asm_exc_nmi
> > > > >    1.97%  fio      [kernel.kallsyms]   [k] native_queued_spin_lock_slowpath
> > > > >    1.88%  fio      [kernel.kallsyms]   [k] __pagevec_lru_add
> > > > >    1.53%  fio      [kernel.kallsyms]   [k] iomap_write_begin
> > > > >    1.53%  fio      [kernel.kallsyms]   [k] __add_to_page_cache_locked
> > > > >    1.41%  fio      [kernel.kallsyms]   [k] xas_start
> > > 
> > > Because you are testing buffered IO, you need to run perf across all
> > > CPUs and tasks, not just the fio process so that it captures the
> > > profile of memory reclaim and writeback that is being performed by
> > > the kernel.
> > 
> > 'perf report' of all CPU.
> > Samples: 211K of event 'cycles', Event count (approx.): 56590727219
> > Overhead  Command          Shared Object            Symbol
> >   16.29%  fio              [kernel.kallsyms]        [k] rep_movs_alternative
> >    3.38%  kworker/u98:1+f  [kernel.kallsyms]        [k] native_queued_spin_lock_slowpath
> >    3.11%  fio              [kernel.kallsyms]        [k] native_queued_spin_lock_slowpath
> >    3.05%  swapper          [kernel.kallsyms]        [k] intel_idle
> >    2.63%  fio              [kernel.kallsyms]        [k] get_page_from_freelist
> >    2.33%  fio              [kernel.kallsyms]        [k] asm_exc_nmi
> >    2.26%  kworker/u98:1+f  [kernel.kallsyms]        [k] __folio_start_writeback
> >    1.40%  fio              [kernel.kallsyms]        [k] __filemap_add_folio
> >    1.37%  fio              [kernel.kallsyms]        [k] lru_add_fn
> >    1.35%  fio              [kernel.kallsyms]        [k] xas_load
> >    1.33%  fio              [kernel.kallsyms]        [k] iomap_write_begin
> >    1.31%  fio              [kernel.kallsyms]        [k] xas_descend
> >    1.19%  kworker/u98:1+f  [kernel.kallsyms]        [k] folio_clear_dirty_for_io
> >    1.07%  fio              [kernel.kallsyms]        [k] folio_add_lru
> >    1.01%  fio              [kernel.kallsyms]        [k] __folio_mark_dirty
> >    1.00%  kworker/u98:1+f  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave
> > 
> > and 'top' show that 'kworker/u98:1' have over 80% CPU usage.
> 
> Can you provide an expanded callgraph profile for both the good and
> bad kernels showing the CPU used in the fio write() path and the
> kworker-based writeback path?

I'm sorry that some detail guide for info gather of this test please.

the test machine here is already reserved.

> [ The test machine I have that I could reproduce this sort of
> performance anomoly went bad a month ago, so I have no hardware
> available to me right now to reproduce this behaviour locally.
> Hence I'll need you to do the profiling I need to understand the
> regression for me. ]
> 
> > > I suspect that the likely culprit is mm-level changes - the
> > > page reclaim algorithm was completely replaced in 6.1 with a
> > > multi-generation LRU that will have different cache footprint
> > > behaviour in exactly this sort of "repeatedly over-write same files
> > > in a set that are significantly larger than memory" micro-benchmark.
> > > 
> > > i.e. these commits:
> > > 
> > > 07017acb0601 mm: multi-gen LRU: admin guide
> > > d6c3af7d8a2b mm: multi-gen LRU: debugfs interface
> > > 1332a809d95a mm: multi-gen LRU: thrashing prevention
> > > 354ed5974429 mm: multi-gen LRU: kill switch
> > > f76c83378851 mm: multi-gen LRU: optimize multiple memcgs
> > > bd74fdaea146 mm: multi-gen LRU: support page table walks
> > > 018ee47f1489 mm: multi-gen LRU: exploit locality in rmap
> > > ac35a4902374 mm: multi-gen LRU: minimal implementation
> > > ec1c86b25f4b mm: multi-gen LRU: groundwork
> > > 
> > > If that's the case, I'd expect kernels up to 6.0 to demonstrate the
> > > same behaviour as 5.15, and 6.1+ to demonstrate the same behaviour
> > > as you've reported.
> > I tested 6.4.0-rc1. the performance become a little worse.
> 
> Thanks, that's as I expected.
> 
> WHich means that the interesting kernel versions to check now are a
> 6.0.x kernel, and then if it has the same perf as 5.15.x, then the
> commit before the multi-gen LRU was introduced vs the commit after
> the multi-gen LRU was introduced to see if that is the functionality
> that introduced the regression....

more performance test result:

linux 6.0.18
	fio WRITE: bw=2565MiB/s (2689MB/s)
linux 5.17.0
	fio WRITE: bw=2602MiB/s (2729MB/s) 
linux 5.16.20
	fio WRITE: bw=7666MiB/s (8039MB/s),

so it is a problem between 5.16.20 and 5.17.0?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/09


