Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D320C77B7C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 May 2023 01:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbjEKBeb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 May 2023 21:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236915AbjEKBe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 May 2023 21:34:29 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEE36A4C
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 18:34:15 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-51b661097bfso5593006a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2023 18:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683768855; x=1686360855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1C1zkxXVqI9voIz3ftPQG2KrfzL+vMG2ZrHgUaGs0A=;
        b=qtZOyEAD6j3wGvmN2qpvBp9MUBdWue0Rd1YP0WVMHO+tcomonObiABQzM7ssi65nrj
         SjaYsTFkm+06xeVBvUPhOv6U9FYkXrlsAOo7xOBC92LpGJN9PWrtrmV9LYBiStwRDMc7
         KX4Sy11MMoxbzWjQWlra0K3yL17pWP8m+0kY/niMK24bwJZbzKWAbPFfgKiw6rEw7+LS
         LvFTSbOH4EnsLmSLtPTBRZSdb7ktkBJHtgDYQiV6pnXWC0M/k4bppxVf4YLZWq8IXU5z
         rwRvjE5Qmzp0nsR7x+KJoPz09CGNb/DPHRU9M4Y3hg4HF8ri50wLHMCwFtJ/bZGZ0qG6
         kgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768855; x=1686360855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1C1zkxXVqI9voIz3ftPQG2KrfzL+vMG2ZrHgUaGs0A=;
        b=NIRA960GRtkgieotYw9/EGv81oKQ0Teu0YyGr9990C52TIc91s388a4ZszzQLN2iTD
         Q9ej3guaXA0mEyj0tUvBB0KxXrVGBi5EGXuWBPVT1DXqR8Ep6TnboqkuZlIw7BuQvVQ5
         AFWgXjY+PBupoNCAS4FDcVZL/GzjnT7pKqlfESu93oKeA7Al5HB3BcmoOM5fsmrU8+PO
         6FuoHrNPPsVmFhBbqD/CDBGRev1KgcqOrnTBouXcibviHPv+9nbWFL6pnYcVwMzEUyhJ
         xuR59nuHMackBHx62M5ONJFiq5nsCsIv1AR7ROxUgWHXQXdyqvSSFyAu2qySBYjU+ET1
         6img==
X-Gm-Message-State: AC+VfDwLoTRpcej0+77yAKa+xg1GoVg/AjJgS1BVSbYkz8Qgn+fjZxkf
        B7aVvnnfdX+F/g7JiBSQykpT7MRPZW3rORUpEzA=
X-Google-Smtp-Source: ACHHUZ5UD6DXLJ1CUA6U0k0PVCe5+fpKfUAg2JwDk1yHKMxfiuiorc0lb81QfsYT32ULYEG1ht98Cg==
X-Received: by 2002:a17:903:32c2:b0:1aa:e938:3ddf with SMTP id i2-20020a17090332c200b001aae9383ddfmr24909361plr.7.1683768854917;
        Wed, 10 May 2023 18:34:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902690a00b001ac7c6fd12asm4437541plk.104.2023.05.10.18.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:34:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwvC6-00DpaK-AU; Thu, 11 May 2023 11:34:10 +1000
Date:   Thu, 11 May 2023 11:34:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
Message-ID: <20230511013410.GY3223426@dread.disaster.area>
References: <20230510134648.ACDD.409509F4@e16-tech.com>
 <20230510072706.GX3223426@dread.disaster.area>
 <20230510165055.01D5.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510165055.01D5.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 10, 2023 at 04:50:56PM +0800, Wang Yugui wrote:
> Hi,
> 
> 
> > On Wed, May 10, 2023 at 01:46:49PM +0800, Wang Yugui wrote:
> > > > Ok, that is further back in time than I expected. In terms of XFS,
> > > > there are only two commits between 5.16..5.17 that might impact
> > > > performance:
> > > > 
> > > > ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")
> > > > 
> > > > and
> > > > 
> > > > 6795801366da ("xfs: Support large folios")
> > > > 
> > > > To test whether ebb7fb1557b1 is the cause, go to
> > > > fs/iomap/buffered-io.c and change:
> > > > 
> > > > -#define IOEND_BATCH_SIZE        4096
> > > > +#define IOEND_BATCH_SIZE        1048576
> > > > This will increase the IO submission chain lengths to at least 4GB
> > > > from the 16MB bound that was placed on 5.17 and newer kernels.
> > > > 
> > > > To test whether 6795801366da is the cause, go to fs/xfs/xfs_icache.c
> > > > and comment out both calls to mapping_set_large_folios(). This will
> > > > ensure the page cache only instantiates single page folios the same
> > > > as 5.16 would have.
> > > 
> > > 6.1.x with 'mapping_set_large_folios remove' and 'IOEND_BATCH_SIZE=1048576'
> > > 	fio WRITE: bw=6451MiB/s (6764MB/s)
> > > 
> > > still  performance regression when compare to linux 5.16.20
> > > 	fio WRITE: bw=7666MiB/s (8039MB/s),
> > > 
> > > but the performance regression is not too big, then difficult to bisect.
> > > We noticed samle level  performance regression  on btrfs too.
> > > so maby some problem of some code that is  used by both btrfs and xfs
> > > such as iomap and mm/folio.
> > 
> > Yup, that's quite possibly something like the multi-gen LRU changes,
> > but that's not the regression we need to find. :/
> > 
> > > 6.1.x  with 'mapping_set_large_folios remove' only'
> > > 	fio   WRITE: bw=2676MiB/s (2806MB/s)
> > > 
> > > 6.1.x with 'IOEND_BATCH_SIZE=1048576' only'
> > > 	fio WRITE: bw=5092MiB/s (5339MB/s),
> > > 	fio  WRITE: bw=6076MiB/s (6371MB/s)
> > > 
> > > maybe we need more fix or ' ebb7fb1557b1 ("xfs, iomap: limit
> > > individual ioend chain lengths in writeback")'.
> > 
> > OK, can you re-run the two 6.1.x kernels above (the slow and the
> > fast) and record the output of `iostat -dxm 1` whilst the
> > fio test is running? I want to see what the overall differences in
> > the IO load on the devices are between the two runs. This will tell
> > us how the IO sizes and queue depths change between the two kernels,
> > etc.
> 
> `iostat -dxm 1` result saved in attachment file.
> good.txt	good performance
> bad.txt		bad performance

Thanks!

What I see here is that neither the good or the bad config are able
to drive the hardware to 100% utilisation, but the way the IO stack
is behaving is identical. The only difference is that
the good config is driving much more IO to the devices, such that
the top level RAID0 stripe reports ~90% utilisation vs 50%
utilisation.

What this says to me is that the limitation in throughput is the
single threaded background IO submission (the bdi-flush thread) is
CPU bound in both cases, and that the difference is in how much CPU
each IO submission is consuming.

From some tests here at lower bandwidth (1-2GB/s) with a batch size
of 4096, I'm seeing the vast majority of submission CPU time being
spent in folio_start_writeback(), and the vast majority of CPU time
in IO completion being spent in folio_end_writeback. There's an
order of magnitude more CPU time in these functions than in any of
the XFS or iomap writeback functions.

A typical 5 second expanded snapshot profile (from `perf top -g -U`)
of the bdi-flusher thread looks like this:

   99.22%     3.68%  [kernel]  [k] write_cache_pages
   - 65.13% write_cache_pages
      - 46.84% iomap_do_writepage
         - 35.50% __folio_start_writeback
            - 7.94% _raw_spin_lock_irqsave
               - 11.35% do_raw_spin_lock
                    __pv_queued_spin_lock_slowpath
            - 5.37% _raw_spin_unlock_irqrestore
               - 5.32% do_raw_spin_unlock
                    __raw_callee_save___pv_queued_spin_unlock
               - 0.92% asm_common_interrupt
                    common_interrupt
                    __common_interrupt
                    handle_edge_irq
                    handle_irq_event
                    __handle_irq_event_percpu
                    vring_interrupt
                    virtblk_done
            - 4.18% __mod_lruvec_page_state
               - 2.18% __mod_lruvec_state
                    1.16% __mod_node_page_state
                    0.68% __mod_memcg_lruvec_state
                 0.90% __mod_memcg_lruvec_state
              2.88% xas_descend
              1.63% percpu_counter_add_batch
              1.63% mod_zone_page_state
              1.15% xas_load
              1.11% xas_start
              0.93% __rcu_read_unlock
            - 0.89% folio_memcg_lock
              0.63% asm_common_interrupt
                 common_interrupt
                 __common_interrupt
                 handle_edge_irq
                 handle_irq_event
                 __handle_irq_event_percpu
                 vring_interrupt
                 virtblk_done
                 virtblk_complete_batch
                 blk_mq_end_request_batch
                 bio_endio
                 iomap_writepage_end_bio
                 iomap_finish_ioend
         - 2.75% xfs_map_blocks
            - 1.55% __might_sleep
                 1.26% __might_resched
         - 1.90% bio_add_folio
              1.13% __bio_try_merge_page
         - 1.82% submit_bio
            - submit_bio_noacct
               - 1.82% submit_bio_noacct_nocheck
                  - __submit_bio
                       1.77% blk_mq_submit_bio
           1.27% inode_to_bdi
           1.19% xas_clear_mark
           0.65% xas_set_mark
           0.57% iomap_page_create.isra.0
      - 12.91% folio_clear_dirty_for_io
         - 2.72% __mod_lruvec_page_state
            - 1.84% __mod_lruvec_state
                 0.98% __mod_node_page_state
                 0.58% __mod_memcg_lruvec_state
           1.55% mod_zone_page_state
           1.49% percpu_counter_add_batch
         - 0.72% asm_common_interrupt
              common_interrupt
              __common_interrupt
              handle_edge_irq
              handle_irq_event
              __handle_irq_event_percpu
              vring_interrupt
              virtblk_done
              virtblk_complete_batch
              blk_mq_end_request_batch
              bio_endio
              iomap_writepage_end_bio
              iomap_finish_ioend
           0.55% folio_mkclean
      - 8.08% filemap_get_folios_tag
           1.84% xas_find_marked
      - 1.89% __pagevec_release
           1.87% release_pages
      - 1.65% __might_sleep
           1.33% __might_resched
        1.22% folio_unlock
   - 3.68% ret_from_fork
        kthread
        worker_thread
        process_one_work
        wb_workfn
        wb_writeback
        __writeback_inodes_wb
        writeback_sb_inodes
        __writeback_single_inode
        do_writepages
        xfs_vm_writepages
        iomap_writepages
        write_cache_pages

This indicates that 35% of writeback submission CPU is in
__folio_start_writeback(), 13% is in folio_clear_dirty_for_io(), 8%
is in filemap_get_folios_tag() and only ~8% of CPU time is in the
rest of the iomap/XFS code building and submitting bios from the
folios passed to it.  i.e.  it looks a lot like writeback is is
contending with the incoming write(), IO completion and memory
reclaim contexts for access to the page cache mapping and mm
accounting structures.

Unfortunately, I don't have access to hardware that I can use to
confirm this is the cause, but it doesn't look like it's directly an
XFS/iomap issue at this point. The larger batch sizes reduce both
memory reclaim and IO completion competition with submission, so it
kinda points in this direction.

I suspect we need to start using high order folios in the write path
where we have large user IOs for streaming writes, but I also wonder
if there isn't some sort of batched accounting/mapping tree updates
we could do for all the adjacent folios in a single bio....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
