Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC0DC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 13:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjEQNHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 09:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjEQNHt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 09:07:49 -0400
Received: from out28-84.mail.aliyun.com (out28-84.mail.aliyun.com [115.124.28.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAC4E63
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 06:07:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04479525|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0230618-0.000205422-0.976733;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.T4mXh.s_1684328860;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.T4mXh.s_1684328860)
          by smtp.aliyun-inc.com;
          Wed, 17 May 2023 21:07:41 +0800
Date:   Wed, 17 May 2023 21:07:41 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: performance regression between 6.1.x and 5.15.x
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20230511013410.GY3223426@dread.disaster.area>
References: <20230510165055.01D5.409509F4@e16-tech.com> <20230511013410.GY3223426@dread.disaster.area>
Message-Id: <20230517210740.6464.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> On Wed, May 10, 2023 at 04:50:56PM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > 
> > > On Wed, May 10, 2023 at 01:46:49PM +0800, Wang Yugui wrote:
> > > > > Ok, that is further back in time than I expected. In terms of XFS,
> > > > > there are only two commits between 5.16..5.17 that might impact
> > > > > performance:
> > > > > 
> > > > > ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")
> > > > > 
> > > > > and
> > > > > 
> > > > > 6795801366da ("xfs: Support large folios")
> > > > > 
> > > > > To test whether ebb7fb1557b1 is the cause, go to
> > > > > fs/iomap/buffered-io.c and change:
> > > > > 
> > > > > -#define IOEND_BATCH_SIZE        4096
> > > > > +#define IOEND_BATCH_SIZE        1048576
> > > > > This will increase the IO submission chain lengths to at least 4GB
> > > > > from the 16MB bound that was placed on 5.17 and newer kernels.
> > > > > 
> > > > > To test whether 6795801366da is the cause, go to fs/xfs/xfs_icache.c
> > > > > and comment out both calls to mapping_set_large_folios(). This will
> > > > > ensure the page cache only instantiates single page folios the same
> > > > > as 5.16 would have.
> > > > 
> > > > 6.1.x with 'mapping_set_large_folios remove' and 'IOEND_BATCH_SIZE=1048576'
> > > > 	fio WRITE: bw=6451MiB/s (6764MB/s)
> > > > 
> > > > still  performance regression when compare to linux 5.16.20
> > > > 	fio WRITE: bw=7666MiB/s (8039MB/s),
> > > > 
> > > > but the performance regression is not too big, then difficult to bisect.
> > > > We noticed samle level  performance regression  on btrfs too.
> > > > so maby some problem of some code that is  used by both btrfs and xfs
> > > > such as iomap and mm/folio.
> > > 
> > > Yup, that's quite possibly something like the multi-gen LRU changes,
> > > but that's not the regression we need to find. :/
> > > 
> > > > 6.1.x  with 'mapping_set_large_folios remove' only'
> > > > 	fio   WRITE: bw=2676MiB/s (2806MB/s)
> > > > 
> > > > 6.1.x with 'IOEND_BATCH_SIZE=1048576' only'
> > > > 	fio WRITE: bw=5092MiB/s (5339MB/s),
> > > > 	fio  WRITE: bw=6076MiB/s (6371MB/s)
> > > > 
> > > > maybe we need more fix or ' ebb7fb1557b1 ("xfs, iomap: limit
> > > > individual ioend chain lengths in writeback")'.
> > > 
> > > OK, can you re-run the two 6.1.x kernels above (the slow and the
> > > fast) and record the output of `iostat -dxm 1` whilst the
> > > fio test is running? I want to see what the overall differences in
> > > the IO load on the devices are between the two runs. This will tell
> > > us how the IO sizes and queue depths change between the two kernels,
> > > etc.
> > 
> > `iostat -dxm 1` result saved in attachment file.
> > good.txt	good performance
> > bad.txt		bad performance
> 
> Thanks!
> 
> What I see here is that neither the good or the bad config are able
> to drive the hardware to 100% utilisation, but the way the IO stack
> is behaving is identical. The only difference is that
> the good config is driving much more IO to the devices, such that
> the top level RAID0 stripe reports ~90% utilisation vs 50%
> utilisation.
> 
> What this says to me is that the limitation in throughput is the
> single threaded background IO submission (the bdi-flush thread) is
> CPU bound in both cases, and that the difference is in how much CPU
> each IO submission is consuming.
> 
> From some tests here at lower bandwidth (1-2GB/s) with a batch size
> of 4096, I'm seeing the vast majority of submission CPU time being
> spent in folio_start_writeback(), and the vast majority of CPU time
> in IO completion being spent in folio_end_writeback. There's an
> order of magnitude more CPU time in these functions than in any of
> the XFS or iomap writeback functions.
> 
> A typical 5 second expanded snapshot profile (from `perf top -g -U`)
> of the bdi-flusher thread looks like this:
> 
>    99.22%     3.68%  [kernel]  [k] write_cache_pages
>    - 65.13% write_cache_pages
>       - 46.84% iomap_do_writepage
>          - 35.50% __folio_start_writeback
>             - 7.94% _raw_spin_lock_irqsave
>                - 11.35% do_raw_spin_lock
>                     __pv_queued_spin_lock_slowpath
>             - 5.37% _raw_spin_unlock_irqrestore
>                - 5.32% do_raw_spin_unlock
>                     __raw_callee_save___pv_queued_spin_unlock
>                - 0.92% asm_common_interrupt
>                     common_interrupt
>                     __common_interrupt
>                     handle_edge_irq
>                     handle_irq_event
>                     __handle_irq_event_percpu
>                     vring_interrupt
>                     virtblk_done
>             - 4.18% __mod_lruvec_page_state
>                - 2.18% __mod_lruvec_state
>                     1.16% __mod_node_page_state
>                     0.68% __mod_memcg_lruvec_state
>                  0.90% __mod_memcg_lruvec_state
>               2.88% xas_descend
>               1.63% percpu_counter_add_batch
>               1.63% mod_zone_page_state
>               1.15% xas_load
>               1.11% xas_start
>               0.93% __rcu_read_unlock
>             - 0.89% folio_memcg_lock
>               0.63% asm_common_interrupt
>                  common_interrupt
>                  __common_interrupt
>                  handle_edge_irq
>                  handle_irq_event
>                  __handle_irq_event_percpu
>                  vring_interrupt
>                  virtblk_done
>                  virtblk_complete_batch
>                  blk_mq_end_request_batch
>                  bio_endio
>                  iomap_writepage_end_bio
>                  iomap_finish_ioend
>          - 2.75% xfs_map_blocks
>             - 1.55% __might_sleep
>                  1.26% __might_resched
>          - 1.90% bio_add_folio
>               1.13% __bio_try_merge_page
>          - 1.82% submit_bio
>             - submit_bio_noacct
>                - 1.82% submit_bio_noacct_nocheck
>                   - __submit_bio
>                        1.77% blk_mq_submit_bio
>            1.27% inode_to_bdi
>            1.19% xas_clear_mark
>            0.65% xas_set_mark
>            0.57% iomap_page_create.isra.0
>       - 12.91% folio_clear_dirty_for_io
>          - 2.72% __mod_lruvec_page_state
>             - 1.84% __mod_lruvec_state
>                  0.98% __mod_node_page_state
>                  0.58% __mod_memcg_lruvec_state
>            1.55% mod_zone_page_state
>            1.49% percpu_counter_add_batch
>          - 0.72% asm_common_interrupt
>               common_interrupt
>               __common_interrupt
>               handle_edge_irq
>               handle_irq_event
>               __handle_irq_event_percpu
>               vring_interrupt
>               virtblk_done
>               virtblk_complete_batch
>               blk_mq_end_request_batch
>               bio_endio
>               iomap_writepage_end_bio
>               iomap_finish_ioend
>            0.55% folio_mkclean
>       - 8.08% filemap_get_folios_tag
>            1.84% xas_find_marked
>       - 1.89% __pagevec_release
>            1.87% release_pages
>       - 1.65% __might_sleep
>            1.33% __might_resched
>         1.22% folio_unlock
>    - 3.68% ret_from_fork
>         kthread
>         worker_thread
>         process_one_work
>         wb_workfn
>         wb_writeback
>         __writeback_inodes_wb
>         writeback_sb_inodes
>         __writeback_single_inode
>         do_writepages
>         xfs_vm_writepages
>         iomap_writepages
>         write_cache_pages
> 
> This indicates that 35% of writeback submission CPU is in
> __folio_start_writeback(), 13% is in folio_clear_dirty_for_io(), 8%
> is in filemap_get_folios_tag() and only ~8% of CPU time is in the
> rest of the iomap/XFS code building and submitting bios from the
> folios passed to it.  i.e.  it looks a lot like writeback is is
> contending with the incoming write(), IO completion and memory
> reclaim contexts for access to the page cache mapping and mm
> accounting structures.
> 
> Unfortunately, I don't have access to hardware that I can use to
> confirm this is the cause, but it doesn't look like it's directly an
> XFS/iomap issue at this point. The larger batch sizes reduce both
> memory reclaim and IO completion competition with submission, so it
> kinda points in this direction.
> 
> I suspect we need to start using high order folios in the write path
> where we have large user IOs for streaming writes, but I also wonder
> if there isn't some sort of batched accounting/mapping tree updates
> we could do for all the adjacent folios in a single bio....


Is there some comment from Matthew Wilcox?
since it seems a folios problem?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/05/17


