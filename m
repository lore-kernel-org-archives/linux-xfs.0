Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Apr 2008 03:48:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3OAlqV3009451
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 03:47:57 -0700
Received: from kernel.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 221C610AB035
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 03:48:31 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [87.55.233.238]) by cuda.sgi.com with ESMTP id CGycpfr89ldyQMAf for <xfs@oss.sgi.com>; Thu, 24 Apr 2008 03:48:31 -0700 (PDT)
Date: Thu, 24 Apr 2008 12:48:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: call trace after >page allocation failure. order:0, mode:0x10000<
Message-ID: <20080424104818.GT12774@kernel.dk>
References: <480DADD2.7060408@ipax.at> <20080423223541.GQ103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423223541.GQ103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>, xfs@oss.sgi.com

On Thu, Apr 24 2008, David Chinner wrote:
> Raoul,
> 
> You've exhausted the bio mempool. That is not supposed to happen.
> 
> This is a block layer or configuration issue, not an XFS problem.
> 
> Jens, have you heard of anything like this recently?

Nope, haven't heard of anything like this. But I don't think your
analysis is quite right - if you call into mempool_alloc(), it may
rightfully try to allocate outside of the pool only to fallback to
pre-allocated entries. So the page allocation failure message isn't a
bug as such, just the vm running complete OOM.

Now, if mempool_alloc() returned NULL with __GFP_WAIT set, THAT would be
a bug.

> 
> Cheers,
> 
> Dave.
> 
> On Tue, Apr 22, 2008 at 11:20:18AM +0200, Raoul Bhatia [IPAX] wrote:
> > hi,
> > 
> > is the following calltrace related to xfs or something else?
> > it happended during "stress --hdd 20 --hdd-bytes 2g" on a
> > raid10 volume:
> > 
> > > # cat /proc/mdstat 
> > > Personalities : [raid1] [raid10] 
> > > md0 : active raid10 sdd5[3] sdc5[2] sdb5[1] sda5[0]
> > >       39069824 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> > 
> > maybe this is xfs' way to tell "out of diskspace"? :)
> >
> > > db-ipax-164:~# uname -a
> > > Linux db-ipax-164.travian.info 2.6.25-rc8 #2 SMP Mon Apr 7 14:50:22 CEST 2008 x86_64 GNU/Linux
> > 
> > * debian etch 64bit
> > * libc6 2.3.6.ds1-13etch5
> > * xfsprogs 2.8.11-1
> > 
> > cheers,
> > raoul
> > 
> > 
> > > stress: page allocation failure. order:0, mode:0x10000
> > > Pid: 12386, comm: stress Not tainted 2.6.25-rc8 #2
> > > 
> > > Call Trace:
> > >  [<ffffffff80261b48>] __alloc_pages+0x2ea/0x306
> > >  [<ffffffff8027bc46>] kmem_getpages+0xc6/0x194
> > >  [<ffffffff8027bc46>] kmem_getpages+0xc6/0x194
> > >  [<ffffffff8027c226>] fallback_alloc+0x11a/0x18f
> > >  [<ffffffff8027bea7>] kmem_cache_alloc_node+0xf1/0x122
> > >  [<ffffffff8027bfd5>] cache_grow+0xd5/0x20c
> > >  [<ffffffff8027c265>] fallback_alloc+0x159/0x18f
> > >  [<ffffffff8027c81b>] kmem_cache_alloc+0xad/0xdc
> > >  [<ffffffff8025e3d4>] mempool_alloc+0x24/0xda
> > >  [<ffffffff882292b1>] :xfs:xfs_cluster_write+0xcd/0xf8
> > >  [<ffffffff802a28d4>] bio_alloc_bioset+0x89/0xd9
> > >  [<ffffffff802a2971>] bio_alloc+0x10/0x20
> > >  [<ffffffff8822867a>] :xfs:xfs_alloc_ioend_bio+0x22/0x4e
> > >  [<ffffffff88228ace>] :xfs:xfs_submit_ioend+0x4d/0xc6
> > >  [<ffffffff8822997b>] :xfs:xfs_page_state_convert+0x516/0x565
> > >  [<ffffffff88229b29>] :xfs:xfs_vm_writepage+0xb4/0xeb
> > >  [<ffffffff80261ba3>] __writepage+0xa/0x23
> > >  [<ffffffff80262017>] write_cache_pages+0x182/0x2b7
> > >  [<ffffffff80261b99>] __writepage+0x0/0x23
> > >  [<ffffffff80262188>] do_writepages+0x20/0x2d
> > >  [<ffffffff8029b5ca>] __writeback_single_inode+0x144/0x29d
> > >  [<ffffffff8029ba8e>] sync_sb_inodes+0x1b1/0x285
> > >  [<ffffffff88228d17>] :xfs:xfs_get_blocks+0x0/0xe
> > >  [<ffffffff8029beae>] writeback_inodes+0x62/0xb3
> > >  [<ffffffff802625d6>] balance_dirty_pages_ratelimited_nr+0x155/0x2b3
> > >  [<ffffffff8025cf35>] generic_file_buffered_write+0x206/0x633
> > >  [<ffffffff80417285>] thread_return+0x3e/0x9d
> > >  [<ffffffff80235bc4>] current_fs_time+0x1e/0x24
> > >  [<ffffffff8822f7cd>] :xfs:xfs_write+0x52f/0x75a
> > >  [<ffffffff802d4e73>] dummy_file_permission+0x0/0x3
> > >  [<ffffffff80281147>] do_sync_write+0xc9/0x10c
> > >  [<ffffffff80242c64>] autoremove_wake_function+0x0/0x2e
> > >  [<ffffffff80227362>] set_next_entity+0x18/0x3a
> > >  [<ffffffff802818a8>] vfs_write+0xad/0x136
> > >  [<ffffffff80281de5>] sys_write+0x45/0x6e
> > >  [<ffffffff8020bd2b>] system_call_after_swapgs+0x7b/0x80
> > > 
> > > Mem-info:
> > > Node 0 DMA per-cpu:
> > > CPU    0: hi:    0, btch:   1 usd:   0
> > > CPU    1: hi:    0, btch:   1 usd:   0
> > > CPU    2: hi:    0, btch:   1 usd:   0
> > > CPU    3: hi:    0, btch:   1 usd:   0
> > > Node 0 DMA32 per-cpu:
> > > CPU    0: hi:  186, btch:  31 usd: 153
> > > CPU    1: hi:  186, btch:  31 usd: 185
> > > CPU    2: hi:  186, btch:  31 usd: 141
> > > CPU    3: hi:  186, btch:  31 usd: 190
> > > Node 0 Normal per-cpu:
> > > CPU    0: hi:  186, btch:  31 usd: 169
> > > CPU    1: hi:  186, btch:  31 usd: 185
> > > CPU    2: hi:  186, btch:  31 usd:  44
> > > CPU    3: hi:  186, btch:  31 usd: 116
> > > Node 1 Normal per-cpu:
> > > CPU    0: hi:  186, btch:  31 usd: 175
> > > CPU    1: hi:  186, btch:  31 usd: 156
> > > CPU    2: hi:  186, btch:  31 usd:  33
> > > CPU    3: hi:  186, btch:  31 usd: 160
> > > Active:35627 inactive:1900080 dirty:48667 writeback:147697 unstable:0
> > >  free:8797 slab:112757 mapped:1726 pagetables:391 bounce:0
> > > Node 0 DMA free:11996kB min:12kB low:12kB high:16kB active:0kB inactive:0kB present:11452kB pages_scanned:0 all_unreclaimable? yes
> > > lowmem_reserve[]: 0 3000 4010 4010
> > > Node 0 DMA32 free:12336kB min:4276kB low:5344kB high:6412kB active:1592kB inactive:2834572kB present:3072160kB pages_scanned:0 all_unreclaimable? no
> > > lowmem_reserve[]: 0 0 1010 1010
> > > Node 0 Normal free:2320kB min:1436kB low:1792kB high:2152kB active:14336kB inactive:973540kB present:1034240kB pages_scanned:0 all_unreclaimable? no
> > > lowmem_reserve[]: 0 0 0 0
> > > Node 1 Normal free:8984kB min:5756kB low:7192kB high:8632kB active:126580kB inactive:3791952kB present:4136960kB pages_scanned:0 all_unreclaimable? no
> > > lowmem_reserve[]: 0 0 0 0
> > > Node 0 DMA: 5*4kB 5*8kB 2*16kB 4*32kB 4*64kB 4*128kB 3*256kB 2*512kB 1*1024kB 0*2048kB 2*4096kB = 11996kB
> > > Node 0 DMA32: 1301*4kB 17*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 1*4096kB = 12236kB
> > > Node 0 Normal: 311*4kB 0*8kB 1*16kB 3*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 2060kB
> > > Node 1 Normal: 1210*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 2*256kB 1*512kB 1*1024kB 1*2048kB 0*4096kB = 9128kB
> > > 1901879 total pagecache pages
> > > Swap cache: add 526500, delete 526485, find 153749/161350
> > > Free swap  = 1999532kB
> > > Total swap = 2000084kB
> > > Free swap:       1999532kB
> > > 2097152 pages of RAM
> > > 29989 reserved pages
> > > 1902596 pages shared
> > > 15 pages swap cached
> > 
> > -- 
> > ____________________________________________________________________
> > DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
> > Technischer Leiter
> > 
> > IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
> > Barawitzkagasse 10/2/2/11           email.            office@ipax.at
> > 1190 Wien                           tel.               +43 1 3670030
> > FN 277995t HG Wien                  fax.            +43 1 3670030 15
> > ____________________________________________________________________
> > 
> 
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group

-- 
Jens Axboe
