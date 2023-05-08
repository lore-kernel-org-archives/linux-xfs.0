Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A20C7EE22
	for <linux-xfs@archiver.kernel.org>; Mon,  8 May 2023 22:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjEHWdH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 May 2023 18:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjEHWdG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2023 18:33:06 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C6E7ECB
        for <linux-xfs@vger.kernel.org>; Mon,  8 May 2023 15:32:48 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-518d325b8a2so4647620a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 08 May 2023 15:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683585168; x=1686177168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g/FduiiHUSyBu4PuljufaCrMTa6cJutZMeH3iKglZ7s=;
        b=UQ4diTcN2xFuzdMsI9b1zGce+jHcRqf05tQHOXz5oob8pnuIFjeO4OCCloOqHs22MX
         wmQJ+lHj3lZAtos/00JjJidsDCo8NJ9kyNghHBmESjh7cFKVuROTDKo9qD/bWzra3Ak/
         xUaE7X34swQ2Mnpx89Q1XOyDeshFv/zI2GWE69d6rGx0W6tPlxmveJeUCOPxgEK2ytGa
         Pp920IxPvRB2P6CWVq1RcbNIXvy/Tw/K2pbhOOLzxjF1UYfofTdPU2j+3LyeP+wH021S
         aJQ5jJ1GadPYImDLggi5vwlbD3vPudaAZUVhoapgg+tv3tJw5+KpxquZ5/JzxrdZ5Ds9
         qATg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683585168; x=1686177168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/FduiiHUSyBu4PuljufaCrMTa6cJutZMeH3iKglZ7s=;
        b=TlHCGW65WA1c14N5ygdxX065VuY263py2cdGE7/IFlnnO7M8479Qfd18elb42XETWE
         Bh5VTX5zibDHa3pXt+3JOJ9T/wTJlnFzD7OeXNUsw7dIHVLK5JNLiJJaY7R0b17IRsWH
         pXN3l3wwu+e6UVWnGwdQ8vSGe7na2b/+WiS/foFP1iXxr1eSZSAYof4rP5kMiE0p769A
         J1H+2asGOjelqiAFwDuteRqR2OW5R/wzSU3hUKz5yPAtWp6k7WdA0/ZoHcvd8FypZ70N
         bQGpSuz2kysHSN9nLPvwhLaPPi55TETDSB1AExwEEx1y7wwYUKypsEYsDoMokfjOmDuY
         xkcg==
X-Gm-Message-State: AC+VfDxEvrsAokqyXPp2CrtME2Iug3BjaZ+xOSKKEzObIeha0JNT86N2
        xLZ4VVnUOvBqCSSi8j4x1ETi9OibIfAZluaYMqI=
X-Google-Smtp-Source: ACHHUZ5CKYOhxj4++rF7piey8TM7Kg6N6Ne73bzuy7baxKkxJvYPWlyGSlrPBmi31Lr+zmUBcwCk2Q==
X-Received: by 2002:a05:6a20:8e1d:b0:101:47d8:ff86 with SMTP id y29-20020a056a208e1d00b0010147d8ff86mr113023pzj.34.1683585167859;
        Mon, 08 May 2023 15:32:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id pi5-20020a17090b1e4500b0024744818bc5sm2499656pjb.9.2023.05.08.15.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 15:32:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pw9PP-00Czaf-U3; Tue, 09 May 2023 08:32:43 +1000
Date:   Tue, 9 May 2023 08:32:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: performance regression between 6.1.x and 5.15.x
Message-ID: <20230508223243.GR3223426@dread.disaster.area>
References: <20230508172406.1CF3.409509F4@e16-tech.com>
 <20230508224611.0651.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508224611.0651.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 08, 2023 at 10:46:12PM +0800, Wang Yugui wrote:
> Hi,
> 
> > Hi,
> > 
> > I noticed a performance regression of xfs 6.1.27/6.1.23,
> > with the compare to xfs 5.15.110.
> > 
> > It is yet not clear whether  it is a problem of xfs or lvm2.
> > 
> > any guide to troubleshoot it?
> > 
> > test case:
> >   disk: NVMe PCIe3 SSD *4 
> >   LVM: raid0 default strip size 64K.
> >   fio -name write-bandwidth -rw=write -bs=1024Ki -size=32Gi -runtime=30
> >    -iodepth 1 -ioengine sync -zero_buffers=1 -direct=0 -end_fsync=1 -numjobs=4
> >    -directory=/mnt/test
> > 
> > 
> > 6.1.27/6.1.23
> > fio bw=2623MiB/s (2750MB/s)
> > perf report:
> > Samples: 330K of event 'cycles', Event count (approx.): 120739812790
> > Overhead  Command  Shared Object        Symbol
> >   31.07%  fio      [kernel.kallsyms]    [k] copy_user_enhanced_fast_string
> >    5.11%  fio      [kernel.kallsyms]    [k] iomap_set_range_uptodate.part.24
> >    3.36%  fio      [kernel.kallsyms]    [k] asm_exc_nmi
> >    3.29%  fio      [kernel.kallsyms]    [k] native_queued_spin_lock_slowpath
> >    2.27%  fio      [kernel.kallsyms]    [k] iomap_write_begin
> >    2.18%  fio      [kernel.kallsyms]    [k] get_page_from_freelist
> >    2.11%  fio      [kernel.kallsyms]    [k] xas_load
> >    2.10%  fio      [kernel.kallsyms]    [k] xas_descend
> > 
> > 5.15.110
> > fio bw=6796MiB/s (7126MB/s)
> > perf report:
> > Samples: 267K of event 'cycles', Event count (approx.): 186688803871
> > Overhead  Command  Shared Object       Symbol
> >   38.09%  fio      [kernel.kallsyms]   [k] copy_user_enhanced_fast_string
> >    6.76%  fio      [kernel.kallsyms]   [k] iomap_set_range_uptodate
> >    4.40%  fio      [kernel.kallsyms]   [k] xas_load
> >    3.94%  fio      [kernel.kallsyms]   [k] get_page_from_freelist
> >    3.04%  fio      [kernel.kallsyms]   [k] asm_exc_nmi
> >    1.97%  fio      [kernel.kallsyms]   [k] native_queued_spin_lock_slowpath
> >    1.88%  fio      [kernel.kallsyms]   [k] __pagevec_lru_add
> >    1.53%  fio      [kernel.kallsyms]   [k] iomap_write_begin
> >    1.53%  fio      [kernel.kallsyms]   [k] __add_to_page_cache_locked
> >    1.41%  fio      [kernel.kallsyms]   [k] xas_start

Because you are testing buffered IO, you need to run perf across all
CPUs and tasks, not just the fio process so that it captures the
profile of memory reclaim and writeback that is being performed by
the kernel.

> more info:
> 
> 1, 6.2.14 have same performance as 6.1.x
> 
> 2,  6.1.x fio performance detail:
> Jobs: 4 (f=4): [W(4)][16.7%][w=10.2GiB/s][w=10.4k IOPS][eta 00m:15s]
> Jobs: 4 (f=4): [W(4)][25.0%][w=9949MiB/s][w=9949 IOPS][eta 00m:12s] 
> Jobs: 4 (f=4): [W(4)][31.2%][w=9618MiB/s][w=9618 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][37.5%][w=7970MiB/s][w=7970 IOPS][eta 00m:10s]
> Jobs: 4 (f=4): [W(4)][41.2%][w=5048MiB/s][w=5047 IOPS][eta 00m:10s]
> Jobs: 4 (f=4): [W(4)][42.1%][w=2489MiB/s][w=2488 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][42.9%][w=3227MiB/s][w=3226 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][45.5%][w=3622MiB/s][w=3622 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][47.8%][w=3651MiB/s][w=3650 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][52.2%][w=3435MiB/s][w=3435 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][52.0%][w=2464MiB/s][w=2463 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][53.8%][w=2438MiB/s][w=2438 IOPS][eta 00m:12s]

Looks like it's throttled on dirty pages at this point.

How much memory does your test system have, and what does changing
the writeback throttling thresholds do? What's the numa layout?


Watching the stats in /proc/meminfo would be useful. I tend to use
Performance Co-Pilot (PCP) to collect these sorts of stats and plot
them in real time so I can see how the state of the machine is
changing as the test is running....


> Jobs: 4 (f=4): [W(4)][55.6%][w=2435MiB/s][w=2434 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][57.1%][w=2449MiB/s][w=2448 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][60.7%][w=2422MiB/s][w=2421 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][62.1%][w=2457MiB/s][w=2457 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][63.3%][w=2436MiB/s][w=2436 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][64.5%][w=2432MiB/s][w=2431 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][67.7%][w=2440MiB/s][w=2440 IOPS][eta 00m:10s]
> Jobs: 4 (f=4): [W(4)][71.0%][w=2437MiB/s][w=2437 IOPS][eta 00m:09s]
> Jobs: 4 (f=4): [W(4)][74.2%][w=2442MiB/s][w=2442 IOPS][eta 00m:08s]
> Jobs: 4 (f=4): [W(4)][77.4%][w=2425MiB/s][w=2424 IOPS][eta 00m:07s]
> Jobs: 4 (f=4): [W(4)][80.6%][w=2459MiB/s][w=2459 IOPS][eta 00m:06s]
> Jobs: 4 (f=4): [W(4)][86.7%][w=2428MiB/s][w=2427 IOPS][eta 00m:04s]
> Jobs: 4 (f=4): [W(4)][90.0%][w=2441MiB/s][w=2440 IOPS][eta 00m:03s]
> Jobs: 4 (f=4): [W(4)][93.3%][w=2438MiB/s][w=2437 IOPS][eta 00m:02s]
> Jobs: 4 (f=4): [W(4)][96.7%][w=2450MiB/s][w=2449 IOPS][eta 00m:01s]
> Jobs: 4 (f=4): [W(4)][100.0%][w=2430MiB/s][w=2430 IOPS][eta 00m:00s]
> Jobs: 4 (f=4): [F(4)][100.0%][w=2372MiB/s][w=2372 IOPS][eta 00m:00s]

fsync at the end is instant, which indicates that writing into the
kernel is almost certainly being throttled.

> 5.15 fio performance detail:
> Jobs: 4 (f=4): [W(4)][14.3%][w=8563MiB/s][w=8563 IOPS][eta 00m:18s]
> Jobs: 4 (f=4): [W(4)][18.2%][w=6376MiB/s][w=6375 IOPS][eta 00m:18s]
> Jobs: 4 (f=4): [W(4)][20.8%][w=4566MiB/s][w=4565 IOPS][eta 00m:19s]
> Jobs: 4 (f=4): [W(4)][23.1%][w=3947MiB/s][w=3947 IOPS][eta 00m:20s]

So throttling starts and perf drops...

> Jobs: 4 (f=4): [W(4)][25.9%][w=4601MiB/s][w=4601 IOPS][eta 00m:20s]
> Jobs: 4 (f=4): [W(4)][28.6%][w=5797MiB/s][w=5796 IOPS][eta 00m:20s]
> Jobs: 4 (f=4): [W(4)][32.1%][w=6802MiB/s][w=6801 IOPS][eta 00m:19s]
> Jobs: 4 (f=4): [W(4)][35.7%][w=7411MiB/s][w=7411 IOPS][eta 00m:18s]
> Jobs: 4 (f=4): [W(4)][40.7%][w=8445MiB/s][w=8444 IOPS][eta 00m:16s]

.... and then it picks back up....

> Jobs: 4 (f=4): [W(4)][46.2%][w=7992MiB/s][w=7992 IOPS][eta 00m:14s]
> Jobs: 4 (f=4): [W(4)][52.0%][w=8118MiB/s][w=8117 IOPS][eta 00m:12s]
> Jobs: 4 (f=4): [W(4)][56.0%][w=7742MiB/s][w=7741 IOPS][eta 00m:11s]
> Jobs: 4 (f=4): [W(4)][62.5%][w=7497MiB/s][w=7496 IOPS][eta 00m:09s]
> Jobs: 4 (f=4): [W(4)][66.7%][w=7248MiB/s][w=7248 IOPS][eta 00m:08s]
> Jobs: 4 (f=4): [W(4)][70.8%][w=7461MiB/s][w=7460 IOPS][eta 00m:07s]
> Jobs: 4 (f=4): [W(4)][75.0%][w=7959MiB/s][w=7959 IOPS][eta 00m:06s]
> Jobs: 4 (f=4): [W(3),F(1)][79.2%][w=6982MiB/s][w=6982 IOPS][eta 00m:05s]
> Jobs: 1 (f=1): [_(2),W(1),_(1)][87.0%][w=2809MiB/s][w=2808 IOPS][eta 00m:03s]
> Jobs: 1 (f=1): [_(2),W(1),_(1)][95.5%][w=2669MiB/s][w=2668 IOPS][eta 00m:01s]
> Jobs: 1 (f=1): [_(2),F(1),_(1)][100.0%][w=2552MiB/s][w=2552 IOPS][eta 00m:00s]

I suspect that the likely culprit is mm-level changes - the
page reclaim algorithm was completely replaced in 6.1 with a
multi-generation LRU that will have different cache footprint
behaviour in exactly this sort of "repeatedly over-write same files
in a set that are significantly larger than memory" micro-benchmark.

i.e. these commits:

07017acb0601 mm: multi-gen LRU: admin guide
d6c3af7d8a2b mm: multi-gen LRU: debugfs interface
1332a809d95a mm: multi-gen LRU: thrashing prevention
354ed5974429 mm: multi-gen LRU: kill switch
f76c83378851 mm: multi-gen LRU: optimize multiple memcgs
bd74fdaea146 mm: multi-gen LRU: support page table walks
018ee47f1489 mm: multi-gen LRU: exploit locality in rmap
ac35a4902374 mm: multi-gen LRU: minimal implementation
ec1c86b25f4b mm: multi-gen LRU: groundwork

If that's the case, I'd expect kernels up to 6.0 to demonstrate the
same behaviour as 5.15, and 6.1+ to demonstrate the same behaviour
as you've reported.

So I'm thinking that the best thing to do is confirm that the change
of behaviour is a result of the multi-gen LRU changes. If it is,
then it's up to the multi-gen LRU developers to determine how to fix
it.  If it's not the multi-gen LRU, we'll have to kep digging.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
