Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:52161 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbfGYMaM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 08:30:12 -0400
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725105350.GA5221@bfoster>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <0f507f3d-eed0-f6b8-48fe-acc9fd872d6b@i-love.sakura.ne.jp>
Date: Thu, 25 Jul 2019 21:30:01 +0900
MIME-Version: 1.0
In-Reply-To: <20190725105350.GA5221@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 2019/07/25 19:53, Brian Foster wrote:
> This is a known problem. XFS delayed allocation has a window between
> delalloc to real block conversion and writeback completion where stale
> data exposure is possible if the writeback doesn't complete (i.e., due
> to crash, I/O error, etc.). See fstests generic/536 for another
> reference.  We've batted around potential solutions like using unwritten
> extents for delalloc allocations, but IIRC we haven't been able to come
> up with something with suitable performance to this point.
> 
> I'm curious why your OOM test results in writeback errors in the first
> place. Is that generally expected? Does dmesg show any other XFS related
> events, such as filesystem shutdown for example? I gave it a quick try
> on a 4GB swapless VM and it doesn't trigger OOM. What's your memory
> configuration and what does the /tmp filesystem look like ('xfs_info
> /tmp')?

Writeback errors should not happen by just close-to-OOM situation.
And there is no other XFS related events.

----------
[  828.600750][ T5241] oom-torture invoked oom-killer: gfp_mask=0x100dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO), order=0, oom_score_adj=0
[  828.608041][ T5241] CPU: 1 PID: 5241 Comm: oom-torture Not tainted 5.3.0-rc1+ #626
[  828.612160][ T5241] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
[  828.617700][ T5241] Call Trace:
[  828.619616][ T5241]  dump_stack+0x67/0x95
[  828.621791][ T5241]  dump_header+0x4d/0x3e0
[  828.624026][ T5241]  oom_kill_process+0x193/0x220
[  828.626412][ T5241]  out_of_memory+0x105/0x360
[  828.628797][ T5241]  ? out_of_memory+0x1ab/0x360
[  828.631133][ T5241]  __alloc_pages_slowpath+0x937/0xbce
[  828.633676][ T5241]  __alloc_pages_nodemask+0x372/0x3b0
[  828.636181][ T5241]  do_anonymous_page+0xe0/0x5e0
[  828.638542][ T5241]  __handle_mm_fault+0x8d6/0xbe0
[  828.640926][ T5241]  handle_mm_fault+0x179/0x380
[  828.643228][ T5241]  ? handle_mm_fault+0x46/0x380
[  828.645546][ T5241]  __do_page_fault+0x255/0x4d0
[  828.647753][ T5241]  do_page_fault+0x27/0x1e0
[  828.649859][ T5241]  page_fault+0x34/0x40
[  828.651820][ T5241] RIP: 0033:0x40082f
[  828.653687][ T5241] Code: 31 e4 e8 54 ff ff ff 31 c0 48 85 db 75 15 eb 3c 0f 1f 00 49 8d 84 24 00 10 00 00 48 39 c3 76 2c 49 89 c4 80 3d 91 18 20 00 00 <c6> 44 05 00 00 74 e2 31 f6 31 ff ba 0a 00 00 00 e8 ec fe ff ff 49
[  828.661900][ T5241] RSP: 002b:00007ffc18ab7fe0 EFLAGS: 00010202
[  828.664423][ T5241] RAX: 00000000c43f9000 RBX: 0000000100000000 RCX: 00007ff8e4083370
[  828.667648][ T5241] RDX: 000000000000000a RSI: 0000000000000000 RDI: 0000000000000000
[  828.670833][ T5241] RBP: 00007ff6e4184010 R08: 00007ffc18ab7f10 R09: 00007ffc18ab7d50
[  828.674029][ T5241] R10: 00007ffc18ab7a60 R11: 0000000000000246 R12: 00000000c43f9000
[  828.677236][ T5241] R13: 00007ff6e4184010 R14: 0000000000000000 R15: 0000000000000000
[  828.685651][ T5241] Mem-Info:
[  828.690368][ T5241] active_anon:808378 inactive_anon:3716 isolated_anon:0
[  828.690368][ T5241]  active_file:434 inactive_file:583 isolated_file:0
[  828.690368][ T5241]  unevictable:0 dirty:85 writeback:108 unstable:0
[  828.690368][ T5241]  slab_reclaimable:8616 slab_unreclaimable:28454
[  828.690368][ T5241]  mapped:2428 shmem:4221 pagetables:5031 bounce:0
[  828.690368][ T5241]  free:25443 free_pcp:646 free_cma:0
[  828.713486][ T5241] Node 0 active_anon:3233512kB inactive_anon:14864kB active_file:1784kB inactive_file:2744kB unevictable:0kB isolated(anon):0kB isolated(file):0kB mapped:9712kB dirty:324kB writeback:532kB shmem:16884kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 2826240kB writeback_tmp:0kB unstable:0kB all_unreclaimable? no
[  828.730876][ T5241] DMA free:14272kB min:296kB low:368kB high:440kB active_anon:1632kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB present:15988kB managed:15904kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  828.743754][ T5241] lowmem_reserve[]: 0 2679 3495 3495
[  828.752288][ T5241] DMA32 free:54488kB min:51572kB low:64464kB high:77356kB active_anon:2682892kB inactive_anon:0kB active_file:0kB inactive_file:544kB unevictable:0kB writepending:0kB present:3129216kB managed:2743640kB mlocked:0kB kernel_stack:2064kB pagetables:28kB bounce:0kB free_pcp:96kB local_pcp:0kB free_cma:0kB
[  828.765008][ T5241] lowmem_reserve[]: 0 0 816 816
[  828.770282][ T5241] Normal free:33040kB min:15712kB low:19640kB high:23568kB active_anon:548988kB inactive_anon:14864kB active_file:1608kB inactive_file:2660kB unevictable:0kB writepending:76kB present:1048576kB managed:835884kB mlocked:0kB kernel_stack:17396kB pagetables:20096kB bounce:0kB free_pcp:2348kB local_pcp:152kB free_cma:0kB
[  828.783430][ T5241] lowmem_reserve[]: 0 0 0 0
[  828.791481][ T5241] DMA: 2*4kB (M) 1*8kB (M) 1*16kB (M) 1*32kB (U) 2*64kB (U) 2*128kB (UM) 2*256kB (UM) 0*512kB 1*1024kB (U) 0*2048kB 3*4096kB (M) = 14272kB
[  828.802502][ T5241] DMA32: 4*4kB (UM) 7*8kB (UM) 34*16kB (UM) 90*32kB (UME) 54*64kB (UME) 30*128kB (UME) 10*256kB (UE) 26*512kB (UM) 27*1024kB (ME) 0*2048kB 0*4096kB = 54312kB
[  828.810562][ T5241] Normal: 856*4kB (UM) 750*8kB (UME) 589*16kB (UME) 348*32kB (UM) 3*64kB (U) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 30176kB
[  828.818691][ T5241] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[  828.825729][ T5241] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  828.837586][ T5241] 5941 total pagecache pages
[  828.842234][ T5241] 0 pages in swap cache
[  828.845175][ T5241] Swap cache stats: add 0, delete 0, find 0/0
[  828.848688][ T5241] Free swap  = 0kB
[  828.851230][ T5241] Total swap = 0kB
[  828.853768][ T5241] 1048445 pages RAM
[  828.856735][ T5241] 0 pages HighMem/MovableOnly
[  828.859683][ T5241] 149588 pages reserved
[  828.862394][ T5241] 0 pages cma reserved
[  828.865161][ T5241] oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),global_oom,task_memcg=/,task=oom-torture,pid=5701,uid=0
[  828.871540][ T5241] Out of memory: Killed process 5701 (oom-torture) total-vm:4220kB, anon-rss:84kB, file-rss:0kB, shmem-rss:0kB
[  828.877783][   T35] oom_reaper: reaped process 5701 (oom-torture), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB
[  829.475335][ T5301] XFS (sda1): writeback error on sector 90663248
[  829.475618][ T5622] XFS (sda1): writeback error on sector 92712224
[  829.476211][ T5557] XFS (sda1): writeback error on sector 370398432
[  829.476801][ T5309] XFS (sda1): writeback error on sector 494252360
[  829.477005][ T5468] XFS (sda1): writeback error on sector 493980928
[  829.727478][ T5241] oom-torture invoked oom-killer: gfp_mask=0x100dca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO), order=0, oom_score_adj=0
[  829.734776][ T5241] CPU: 2 PID: 5241 Comm: oom-torture Not tainted 5.3.0-rc1+ #626
----------

Kernel config is http://I-love.SAKURA.ne.jp/tmp/config-5.3-rc1 .

Below result is from a different VM which shows the same problem.

# xfs_info /tmp
meta-data=/dev/sda1              isize=256    agcount=4, agsize=16383936 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=65535744, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=31999, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
	
