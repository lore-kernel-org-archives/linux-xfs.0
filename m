Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B513C7EE22
	for <linux-xfs@archiver.kernel.org>; Wed, 10 May 2023 05:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjEJFq6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 01:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjEJFq5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 01:46:57 -0400
Received: from out28-56.mail.aliyun.com (out28-56.mail.aliyun.com [115.124.28.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F31172B
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 22:46:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0443644|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.345932-0.000879024-0.653189;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.SdEPOEX_1683697609;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.SdEPOEX_1683697609)
          by smtp.aliyun-inc.com;
          Wed, 10 May 2023 13:46:49 +0800
Date:   Wed, 10 May 2023 13:46:49 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: performance regression between 6.1.x and 5.15.x
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20230509221411.GU3223426@dread.disaster.area>
References: <20230509203751.E6D2.409509F4@e16-tech.com> <20230509221411.GU3223426@dread.disaster.area>
Message-Id: <20230510134648.ACDD.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> 'perf record -g' and 'perf report -g' should enable callgraph
> profiling and reporting. See the perf-record man page for
> '--callgraph' to make sure you have the right kernel config for this
> to work efficiently.
> 
> You can do quick snapshots in time via 'perf top -U -g' and then
> after a few seconds type 'E' then immediately type 'P' and the fully
> expanded callgraph profile will get written to a perf.hist.N file in
> the current working directory...

'perf report -g ' of BAD kernel 6.1.y

Samples: 439K of event 'cycles', Event count (approx.): 148701386235
  Children      Self  Command          Shared Object            Symbol
+   61.82%     0.01%  fio              [kernel.kallsyms]        [k] entry_SYSCALL_64_after_hwfra
+   61.81%     0.01%  fio              [kernel.kallsyms]        [k] do_syscall_64
+   61.71%     0.00%  fio              libpthread-2.17.so       [.] 0x00007f4e7a40e6fd
+   61.66%     0.00%  fio              [kernel.kallsyms]        [k] ksys_write
+   61.64%     0.02%  fio              [kernel.kallsyms]        [k] vfs_write
+   61.60%     0.02%  fio              [kernel.kallsyms]        [k] xfs_file_buffered_write
+   61.20%     0.56%  fio              [kernel.kallsyms]        [k] iomap_file_buffered_write
+   25.25%     1.44%  fio              [kernel.kallsyms]        [k] iomap_write_begin
+   23.19%     0.75%  fio              [kernel.kallsyms]        [k] __filemap_get_folio
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] ret_from_fork
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] kthread
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] worker_thread
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] process_one_work
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] wb_workfn
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] wb_writeback
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] __writeback_inodes_wb
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] writeback_sb_inodes
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] __writeback_single_inode
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] do_writepages
+   21.57%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] xfs_vm_writepages
+   21.55%     0.00%  kworker/u98:4+f  [kernel.kallsyms]        [k] iomap_writepages
+   21.55%     0.85%  kworker/u98:4+f  [kernel.kallsyms]        [k] write_cache_pages
+   20.23%     0.22%  fio              [kernel.kallsyms]        [k] copy_page_from_iter_atomic
+   19.99%     0.04%  fio              [kernel.kallsyms]        [k] copyin
+   19.94%    19.77%  fio              [kernel.kallsyms]        [k] copy_user_enhanced_fast_stri
+   16.47%     0.00%  fio              [unknown]                [k] 0x00000000024803f0
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480440
+   16.47%     0.00%  fio              [unknown]                [k] 0x00000000024804b0
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480520
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480590
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480670
+   16.47%     0.00%  fio              [unknown]                [k] 0x00000000024806e0
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480750
+   16.47%     0.00%  fio              [unknown]                [k] 0x00000000024807c0
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480830
+   16.47%     0.00%  fio              [unknown]                [k] 0x00000000024808a0
+   16.47%     0.00%  fio              [unknown]                [k] 0x0000000002480910
+   16.47%     0.00%  fio              [unknown]                [k] 0x00007f4e21070430
+   15.73%     0.00%  fio              [unknown]                [k] 0x0000000002480290
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247f790
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247fdf0
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247fe60
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247fed0
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247ff40
+   15.73%     0.00%  fio              [unknown]                [k] 0x000000000247ffb0
+   15.73%     0.00%  fio              [unknown]                [k] 0x0000000002480020
+   15.73%     0.00%  fio              [unknown]                [k] 0x0000000002480090
+   15.73%     0.00%  fio              [unknown]                [k] 0x0000000002480180
+   15.73%     0.00%  fio              [unknown]                [k] 0x00000000024801b0
+   15.73%     0.00%  fio              [unknown]                [k] 0x0000000002480220
+   15.73%     0.00%  fio              [unknown]                [k] 0x00007f4e2102ba18
+   15.07%     0.74%  kworker/u98:4+f  [kernel.kallsyms]        [k] iomap_writepage_map
+   15.01%     0.00%  fio              [unknown]                [k] 0x0000000002480a70


'perf report -g ' of GOOD kernel 5.15.y

Samples: 335K of event 'cycles', Event count (approx.): 229260446285
  Children      Self  Command          Shared Object                    Symbol
+   66.35%     0.01%  fio              [kernel.kallsyms]                [k] entry_SYSCALL_64_aft
+   66.34%     0.01%  fio              [kernel.kallsyms]                [k] do_syscall_64
+   65.49%     0.00%  fio              libpthread-2.17.so               [.] 0x00007ff968de56fd
+   65.45%     0.00%  fio              [kernel.kallsyms]                [k] ksys_write
+   65.44%     0.02%  fio              [kernel.kallsyms]                [k] vfs_write
+   65.41%     0.00%  fio              [kernel.kallsyms]                [k] new_sync_write
+   65.40%     0.03%  fio              [kernel.kallsyms]                [k] xfs_file_buffered_wr
+   65.13%     0.53%  fio              [kernel.kallsyms]                [k] iomap_file_buffered_
+   27.17%     0.36%  fio              [kernel.kallsyms]                [k] copy_page_from_iter_
+   26.76%     0.05%  fio              [kernel.kallsyms]                [k] copyin
+   26.73%    26.52%  fio              [kernel.kallsyms]                [k] copy_user_enhanced_f
+   23.12%     1.05%  fio              [kernel.kallsyms]                [k] iomap_write_begin
+   21.59%     0.34%  fio              [kernel.kallsyms]                [k] grab_cache_page_writ
+   21.13%     0.65%  fio              [kernel.kallsyms]                [k] pagecache_get_page
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] ret_from_fork
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] kthread
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] worker_thread
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] process_one_work
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] wb_workfn
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] wb_writeback
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] __writeback_inodes_w
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] writeback_sb_inodes
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] __writeback_single_i
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] do_writepages
+   18.73%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] xfs_vm_writepages
+   18.66%     0.00%  kworker/u97:11+  [kernel.kallsyms]                [k] iomap_writepages
+   18.66%     0.48%  kworker/u97:11+  [kernel.kallsyms]                [k] write_cache_pages
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e613f0
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61440
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e614b0
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61520
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61590
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61670
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e616e0
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61750
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e617c0
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61830
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e618a0
+   16.75%     0.00%  fio              [unknown]                        [k] 0x0000000001e61910
+   16.75%     0.00%  fio              [unknown]                        [k] 0x00007ff9151e0430
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60790
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60df0
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60e60
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60ed0
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60f40
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e60fb0
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e61020
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e61090
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e61180
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e611b0
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e61220
+   16.70%     0.00%  fio              [unknown]                        [k] 0x0000000001e61290
+   16.70%     0.00%  fio              [unknown]                        [k] 0x00007ff91519ba18


> Ok, that is further back in time than I expected. In terms of XFS,
> there are only two commits between 5.16..5.17 that might impact
> performance:
> 
> ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")
> 
> and
> 
> 6795801366da ("xfs: Support large folios")
> 
> To test whether ebb7fb1557b1 is the cause, go to
> fs/iomap/buffered-io.c and change:
> 
> -#define IOEND_BATCH_SIZE        4096
> +#define IOEND_BATCH_SIZE        1048576
> This will increase the IO submission chain lengths to at least 4GB
> from the 16MB bound that was placed on 5.17 and newer kernels.
> 
> To test whether 6795801366da is the cause, go to fs/xfs/xfs_icache.c
> and comment out both calls to mapping_set_large_folios(). This will
> ensure the page cache only instantiates single page folios the same
> as 5.16 would have.

6.1.x with 'mapping_set_large_folios remove' and 'IOEND_BATCH_SIZE=1048576'
	fio WRITE: bw=6451MiB/s (6764MB/s)

still  performance regression when compare to linux 5.16.20
	fio WRITE: bw=7666MiB/s (8039MB/s),

but the performance regression is not too big, then difficult to bisect.
We noticed samle level  performance regression  on btrfs too.
so maby some problem of some code that is  used by both btrfs and xfs
such as iomap and mm/folio.

6.1.x  with 'mapping_set_large_folios remove' only'
	fio   WRITE: bw=2676MiB/s (2806MB/s)

6.1.x with 'IOEND_BATCH_SIZE=1048576' only'
	fio WRITE: bw=5092MiB/s (5339MB/s),
	fio  WRITE: bw=6076MiB/s (6371MB/s)

maybe we need more fix or ' ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")'.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/10


> 
> If neither of them change behaviour, then I think you're going to
> need to do a bisect between 5.16..5.17 to find the commit that
> introduced the regression. I know kernel bisects are slow and
> painful, but it's exactly what I'd be doing right now if my
> performance test machine wasn't broken....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com


