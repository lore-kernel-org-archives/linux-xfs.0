Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC0797F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 19:38:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6C7E6AC003
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 17:38:55 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mVaDPHCw1HRjtEX5 for <xfs@oss.sgi.com>;
	Wed, 29 May 2013 17:38:53 -0700 (PDT)
Date: Thu, 30 May 2013 10:38:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130530003849.GC29466@dastard>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
	<20130520170710.GA2591@luxor.wired.org>
	<20130521000208.GF24543@dastard>
	<20130523143456.GB19815@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130523143456.GB19815@luxor.wired.org>
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
To: Paolo Pisati <p.pisati@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, May 23, 2013 at 04:34:56PM +0200, Paolo Pisati wrote:
> On Tue, May 21, 2013 at 10:02:09AM +1000, Dave Chinner wrote:
> > 
> > And that fix I mentioned will be useless if you don't apply the
> > patch that avoids the vmap allocation problem....
> 
> 
> ok, so i recompiled a kernel+aforementioend fix, i repartitioned my disk and i
> ran the swift-bench for 2 days in a row until i got this:
> 
> dmesg:
> ...
> [163596.605253] updatedb.mlocat: page allocation failure: order:0, mode:0x20
> [163596.605299] [<c00164cc>] (unwind_backtrace+0x0/0x104) from [<c04edb20>] (dump_stack+0x20/0x24)
> [163596.605320] [<c04edb20>] (dump_stack+0x20/0x24) from [<c00e7780>] (warn_alloc_failed+0xd8/0x118)
> [163596.605335] [<c00e7780>] (warn_alloc_failed+0xd8/0x118) from [<c00e9b88>] (__alloc_pages_nodemask+0x524/0x708)
> [163596.605354] [<c00e9b88>] (__alloc_pages_nodemask+0x524/0x708) from [<c011b798>] (new_slab+0x22c/0x248)
> [163596.605370] [<c011b798>] (new_slab+0x22c/0x248) from [<c04f04f8>] (__slab_alloc.constprop.46+0x1a4/0x4c8)
> [163596.605383] [<c04f04f8>] (__slab_alloc.constprop.46+0x1a4/0x4c8) from [<c011ced4>] (kmem_cache_alloc+0x158/0x190)
> [163596.605402] [<c011ced4>] (kmem_cache_alloc+0x158/0x190) from [<c0332be0>] (scsi_pool_alloc_command+0x30/0x74)
> [163596.605417] [<c0332be0>] (scsi_pool_alloc_command+0x30/0x74) from [<c0332c80>] (scsi_host_alloc_command+0x24/0x78)
> [163596.605428] [<c0332c80>] (scsi_host_alloc_command+0x24/0x78) from [<c0332cf0>] (__scsi_get_command+0x1c/0xa0)
> [163596.605439] [<c0332cf0>] (__scsi_get_command+0x1c/0xa0) from [<c0332db0>] (scsi_get_command+0x3c/0xb0)
> [163596.605453] [<c0332db0>] (scsi_get_command+0x3c/0xb0) from [<c0338d44>] (scsi_get_cmd_from_req+0x50/0x60)
> [163596.605466] [<c0338d44>] (scsi_get_cmd_from_req+0x50/0x60) from [<c0339fd8>] (scsi_setup_fs_cmnd+0x4c/0xac)

ENOMEM deep in the SCSI stack for an order 0 GFP_ATOMIC allocation.
That's not an XFS problem - that's a SCSI stack issue. You should
probably report that to the scsi list...

> [163596.608574] active_anon:26367 inactive_anon:29153 isolated_anon:0
> [163596.608574]  active_file:396338 inactive_file:397959 isolated_file:0
> [163596.608574]  unevictable:0 dirty:0 writeback:5 unstable:0
> [163596.608574]  free:5145 slab_reclaimable:57625 slab_unreclaimable:7729
> [163596.608574]  mapped:1703 shmem:10 pagetables:581 bounce:0
> [163596.608602] Normal free:15256kB min:3508kB low:4384kB high:5260kB active_anon:0kB inactive_anon:8kB active_file:848kB inactive_file:1560kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:772160kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:230500kB slab_unreclaimable:30916kB kernel_stack:2208kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [163596.608607] lowmem_reserve[]: 0 26423 26423
> [163596.608628] HighMem free:5324kB min:512kB low:4352kB high:8192kB active_anon:105468kB inactive_anon:116604kB active_file:1584504kB inactive_file:1590276kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3382264kB mlocked:0kB dirty:0kB writeback:20kB mapped:6812kB shmem:40kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:2324kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> [163596.608634] lowmem_reserve[]: 0 0 0
> [163596.608643] Normal: 216*4kB 215*8kB 216*16kB 216*32kB 36*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15256kB
> [163596.608668] HighMem: 233*4kB 67*8kB 141*16kB 22*32kB 8*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5324kB

Though this says there is plenty  of free order 0 pages in both low
and high memory....

> [163596.608692] 794329 total pagecache pages
> [163596.608697] 12 pages in swap cache
> [163596.608703] Swap cache stats: add 79, delete 67, find 9/11
> [163596.608708] Free swap  = 8378092kB
> [163596.608712] Total swap = 8378364kB
> [163596.670667] 1046784 pages of RAM
> [163596.670674] 6801 free pages
> [163596.670679] 12533 reserved pages
> [163596.670683] 36489 slab pages
> [163596.670687] 631668 pages shared
> [163596.670692] 12 pages swap cached
> [163596.670701] SLUB: Unable to allocate memory on node -1 (gfp=0x8020)
> [163596.670710]   cache: kmalloc-192, object size: 192, buffer size: 192, default order: 0, min order: 0
> [163596.670718]   node 0: slabs: 2733, objs: 57393, free: 0

And it was slub that was unable to find a page when it should have
been able to, so perhaps this is a VM problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
