Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BC5C77B75
	for <linux-xfs@archiver.kernel.org>; Tue,  9 May 2023 22:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjEIWOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 May 2023 18:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjEIWOQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 May 2023 18:14:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9223A87
        for <linux-xfs@vger.kernel.org>; Tue,  9 May 2023 15:14:15 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64115e652eeso45971738b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 May 2023 15:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683670455; x=1686262455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWxbKeHypG+qauPzJTN1zoPkQnY6wHVBSUfbBcuj26Q=;
        b=iBQfnyP5E0ZsljR4hwVG6wirIZPqRCVEYcMy0d2FeYpd9oGEJvw2Q/IU5d3JhLo+sC
         g3jOdR+VEDl6GdpjIO9k17TqbjttyY4SEe4nm4vqWcHDXOJ+EHsOEJAK/J0Dn4vvWeKt
         pj4jqjXeFmHN5o3YUc7CKQQsfjQWZnQi+ac2WBcGD0oFIENz9ASfzV3E+gvArfBevt08
         KrFbBoqOJ5gX/JR0RklczCg7nUOfRdNoc4yGIp2wc1a/TtBy+Wgwy8IIZ/d94+aOcSGf
         ioGqd+8xBOw+z0BgxB/+AOrBorWhD6WE2lnW4AKe+/du7WGp0p3JlVWUs8s9wSeqTsJJ
         z9iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670455; x=1686262455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GWxbKeHypG+qauPzJTN1zoPkQnY6wHVBSUfbBcuj26Q=;
        b=S9fcLRLjlSpVYOQKYBTQXmR0JgMHBxsF0NOZ22FQ/3VO3FlgJ7hJl/Cf5ba3+Iz6sG
         fkecYSK7zXSe3lwGS7GKMCJJB9J5I3TYFsTSfW4qFi0LsXnc5fRNnxeIhXFvoG4WnrSu
         PZxHfsBXTir+tHRTwrju1xR4hQpESO+FHa9jW8Jbg5XaxIShjRPDK20QgSq7iaTSRBA4
         lnV28ecPb8n7fTSkE5oGrJdY0+kZoVXe9qFK0IiPTtm+6lcThGDg1egPoSWK4dlncA6n
         5hvP212S2ZH5ZSuZqPn+1Ni3dtaFUEShjTNAV+DiUj4NoWmRgFXq1ul/guCAUdUa16Dr
         RidA==
X-Gm-Message-State: AC+VfDzzRQb/E3GL+ksKOJA0dyU5nVNhnLbfV11o/9kwwpTY4L/W5CSz
        Q7Qlwbdrvzq0N3oOBcaRMpNOf3cBxX/tjOQZxbU=
X-Google-Smtp-Source: ACHHUZ6ahaV1GPDvwft/0VpD0L54bQllwFjycbxMxPk7T5EQCkQLeb/4eSugHhDQxGFQ/o0M1JwQcw==
X-Received: by 2002:a17:902:e80b:b0:1a9:57b4:9d5a with SMTP id u11-20020a170902e80b00b001a957b49d5amr21604459plg.31.1683670454946;
        Tue, 09 May 2023 15:14:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id g15-20020a170902868f00b001a943c41c37sm2150809plo.7.2023.05.09.15.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:14:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pwVb1-00DNgJ-J8; Wed, 10 May 2023 08:14:11 +1000
Date:   Wed, 10 May 2023 08:14:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
Message-ID: <20230509221411.GU3223426@dread.disaster.area>
References: <20230509072552.7E8B.409509F4@e16-tech.com>
 <20230509013625.GS3223426@dread.disaster.area>
 <20230509203751.E6D2.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509203751.E6D2.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 09, 2023 at 08:37:52PM +0800, Wang Yugui wrote:
> > On Tue, May 09, 2023 at 07:25:53AM +0800, Wang Yugui wrote:
> > > > On Mon, May 08, 2023 at 10:46:12PM +0800, Wang Yugui wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I noticed a performance regression of xfs 6.1.27/6.1.23,
> > > > > > with the compare to xfs 5.15.110.
> > > > > > 
> > > > > > It is yet not clear whether  it is a problem of xfs or lvm2.
> > > > > > 
> > > > > > any guide to troubleshoot it?
> > > > > > 
> > > > > > test case:
> > > > > >   disk: NVMe PCIe3 SSD *4 
> > > > > >   LVM: raid0 default strip size 64K.
> > > > > >   fio -name write-bandwidth -rw=write -bs=1024Ki -size=32Gi -runtime=30
> > > > > >    -iodepth 1 -ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=4
> > > > > >    -directory=/mnt/test
.....
> > > > Because you are testing buffered IO, you need to run perf across all
> > > > CPUs and tasks, not just the fio process so that it captures the
> > > > profile of memory reclaim and writeback that is being performed by
> > > > the kernel.
> > > 
> > > 'perf report' of all CPU.
> > > Samples: 211K of event 'cycles', Event count (approx.): 56590727219
> > > Overhead  Command          Shared Object            Symbol
> > >   16.29%  fio              [kernel.kallsyms]        [k] rep_movs_alternative
> > >    3.38%  kworker/u98:1+f  [kernel.kallsyms]        [k] native_queued_spin_lock_slowpath
> > >    3.11%  fio              [kernel.kallsyms]        [k] native_queued_spin_lock_slowpath
> > >    3.05%  swapper          [kernel.kallsyms]        [k] intel_idle
> > >    2.63%  fio              [kernel.kallsyms]        [k] get_page_from_freelist
> > >    2.33%  fio              [kernel.kallsyms]        [k] asm_exc_nmi
> > >    2.26%  kworker/u98:1+f  [kernel.kallsyms]        [k] __folio_start_writeback
> > >    1.40%  fio              [kernel.kallsyms]        [k] __filemap_add_folio
> > >    1.37%  fio              [kernel.kallsyms]        [k] lru_add_fn
> > >    1.35%  fio              [kernel.kallsyms]        [k] xas_load
> > >    1.33%  fio              [kernel.kallsyms]        [k] iomap_write_begin
> > >    1.31%  fio              [kernel.kallsyms]        [k] xas_descend
> > >    1.19%  kworker/u98:1+f  [kernel.kallsyms]        [k] folio_clear_dirty_for_io
> > >    1.07%  fio              [kernel.kallsyms]        [k] folio_add_lru
> > >    1.01%  fio              [kernel.kallsyms]        [k] __folio_mark_dirty
> > >    1.00%  kworker/u98:1+f  [kernel.kallsyms]        [k] _raw_spin_lock_irqsave
> > > 
> > > and 'top' show that 'kworker/u98:1' have over 80% CPU usage.
> > 
> > Can you provide an expanded callgraph profile for both the good and
> > bad kernels showing the CPU used in the fio write() path and the
> > kworker-based writeback path?
> 
> I'm sorry that some detail guide for info gather of this test please.

'perf record -g' and 'perf report -g' should enable callgraph
profiling and reporting. See the perf-record man page for
'--callgraph' to make sure you have the right kernel config for this
to work efficiently.

You can do quick snapshots in time via 'perf top -U -g' and then
after a few seconds type 'E' then immediately type 'P' and the fully
expanded callgraph profile will get written to a perf.hist.N file in
the current working directory...

> > > I tested 6.4.0-rc1. the performance become a little worse.
> > 
> > Thanks, that's as I expected.
> > 
> > WHich means that the interesting kernel versions to check now are a
> > 6.0.x kernel, and then if it has the same perf as 5.15.x, then the
> > commit before the multi-gen LRU was introduced vs the commit after
> > the multi-gen LRU was introduced to see if that is the functionality
> > that introduced the regression....
> 
> more performance test result:
> 
> linux 6.0.18
> 	fio WRITE: bw=2565MiB/s (2689MB/s)
> linux 5.17.0
> 	fio WRITE: bw=2602MiB/s (2729MB/s) 
> linux 5.16.20
> 	fio WRITE: bw=7666MiB/s (8039MB/s),
> 
> so it is a problem between 5.16.20 and 5.17.0?

Ok, that is further back in time than I expected. In terms of XFS,
there are only two commits between 5.16..5.17 that might impact
performance:

ebb7fb1557b1 ("xfs, iomap: limit individual ioend chain lengths in writeback")

and

6795801366da ("xfs: Support large folios")

To test whether ebb7fb1557b1 is the cause, go to
fs/iomap/buffered-io.c and change:

-#define IOEND_BATCH_SIZE        4096
+#define IOEND_BATCH_SIZE        1048576

This will increase the IO submission chain lengths to at least 4GB
from the 16MB bound that was placed on 5.17 and newer kernels.

To test whether 6795801366da is the cause, go to fs/xfs/xfs_icache.c
and comment out both calls to mapping_set_large_folios(). This will
ensure the page cache only instantiates single page folios the same
as 5.16 would have.

If neither of them change behaviour, then I think you're going to
need to do a bisect between 5.16..5.17 to find the commit that
introduced the regression. I know kernel bisects are slow and
painful, but it's exactly what I'd be doing right now if my
performance test machine wasn't broken....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
