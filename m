Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84AC77F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 14:47:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6157E304067
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 12:47:52 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id sfM8GbWOA8wvEgg1 for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 12:47:50 -0800 (PST)
Date: Thu, 5 Mar 2015 15:47:49 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150305204749.GA17934@fieldses.org>
References: <20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
	<20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<20150305150138.GA15674@fieldses.org>
	<20150305170217.GC15674@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150305170217.GC15674@fieldses.org>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Mar 05, 2015 at 12:02:17PM -0500, J. Bruce Fields wrote:
> On Thu, Mar 05, 2015 at 10:01:38AM -0500, J. Bruce Fields wrote:
> > On Thu, Mar 05, 2015 at 02:17:31PM +0100, Christoph Hellwig wrote:
> > > On Wed, Mar 04, 2015 at 11:08:49PM -0500, J. Bruce Fields wrote:
> > > > Ah-hah:
> > > > 
> > > > 	static void
> > > > 	nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
> > > > 	{
> > > > 		...
> > > > 		nfsd4_cb_layout_fail(ls);
> > > > 
> > > > That'd do it!
> > > > 
> > > > Haven't tried to figure out why exactly that's getting called, and why
> > > > only rarely.  Some intermittent problem with the callback path, I guess.
> > > > 
> > > > Anyway, I think that solves most of the mystery....
> > > 
> > > Ooops, that was a nasty git merge error in the last rebase, see the fix
> > > below.
> > 
> > Thanks!
> 
> And with that fix things look good.
> 
> I'm still curious why the callbacks are failling.  It's also logging
> "nfsd: client 192.168.122.32 failed to respond to layout recall".

I spoke too soon, I'm still not getting through my usual test run--the most
recent run is hanging in generic/247 with the following in the server logs.

But I probably still won't get a chance to look at this any closer till after
vault.

--b.

nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
nfsd: fence failed for client 192.168.122.32: -2!
nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
nfsd: fence failed for client 192.168.122.32: -2!
receive_cb_reply: Got unrecognized reply: calldir 0x1 xpt_bc_xprt ffff88005639a000 xid c21abd62
kswapd0: page allocation failure: order:0, mode:0x120
CPU: 0 PID: 580 Comm: kswapd0 Not tainted 4.0.0-rc2-09922-g26cbcc7 #89
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140709_153950- 04/01/2014
 0000000000000000 ffff88007f803bc8 ffffffff81a92597 0000000080000101
 0000000000000120 ffff88007f803c58 ffffffff81155322 ffffffff822e9448
 0000000000000000 0000000000000000 0000000000000001 00000000ffffffff
Call Trace:
 <IRQ>  [<ffffffff81a92597>] dump_stack+0x4f/0x7b
 [<ffffffff81155322>] warn_alloc_failed+0xe2/0x130
 [<ffffffff81158503>] __alloc_pages_nodemask+0x5f3/0x860
 [<ffffffff8195b2ab>] skb_page_frag_refill+0xab/0xd0
 [<ffffffff817b5fba>] try_fill_recv+0x38a/0x7d0
 [<ffffffff817b6af2>] virtnet_receive+0x6f2/0x860
 [<ffffffff817b6c81>] virtnet_poll+0x21/0x90
 [<ffffffff8197344a>] net_rx_action+0x1aa/0x320
 [<ffffffff810796f2>] __do_softirq+0xf2/0x370
 [<ffffffff81079ad5>] irq_exit+0x65/0x70
 [<ffffffff81a9e124>] do_IRQ+0x64/0x100
 [<ffffffff811d56f2>] ? free_buffer_head+0x22/0x80
 [<ffffffff81a9c16f>] common_interrupt+0x6f/0x6f
 <EOI>  [<ffffffff81092224>] ? kernel_text_address+0x64/0x70
 [<ffffffff81197ff7>] ? kmem_cache_free+0xb7/0x230
 [<ffffffff811d56f2>] free_buffer_head+0x22/0x80
 [<ffffffff811d5b19>] try_to_free_buffers+0x79/0xc0
 [<ffffffff81394b1b>] xfs_vm_releasepage+0x6b/0x160
 [<ffffffff81184dc0>] ? __page_check_address+0x1f0/0x1f0
 [<ffffffff8114fcc5>] try_to_release_page+0x35/0x60
 [<ffffffff81162e02>] shrink_page_list+0x9c2/0xba0
 [<ffffffff810bba1d>] ? trace_hardirqs_on_caller+0x12d/0x1d0
 [<ffffffff811635df>] shrink_inactive_list+0x23f/0x520
 [<ffffffff81164155>] shrink_lruvec+0x595/0x6d0
 [<ffffffff81161a39>] ? shrink_slab.part.58.constprop.67+0x299/0x410
 [<ffffffff811642dd>] shrink_zone+0x4d/0xa0
 [<ffffffff81164c01>] kswapd+0x471/0xa30
 [<ffffffff81164790>] ? try_to_free_pages+0x460/0x460
 [<ffffffff81093a2f>] kthread+0xef/0x110
 [<ffffffff81093940>] ? kthread_create_on_node+0x220/0x220
 [<ffffffff81a9b5ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81093940>] ? kthread_create_on_node+0x220/0x220
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:  64
active_anon:7053 inactive_anon:2435 isolated_anon:0
 active_file:88743 inactive_file:89505 isolated_file:32
 unevictable:0 dirty:9786 writeback:0 unstable:0
 free:3571 slab_reclaimable:227807 slab_unreclaimable:75772
 mapped:21010 shmem:380 pagetables:1567 bounce:0
 free_cma:0
DMA free:7788kB min:44kB low:52kB high:64kB active_anon:204kB inactive_anon:260kB active_file:696kB inactive_file:1016kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:0kB dirty:32kB writeback:0kB mapped:924kB shmem:36kB slab_reclaimable:1832kB slab_unreclaimable:1632kB kernel_stack:48kB pagetables:80kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 1943 1943 1943
DMA32 free:6188kB min:5616kB low:7020kB high:8424kB active_anon:28008kB inactive_anon:9480kB active_file:354360kB inactive_file:357004kB unevictable:0kB isolated(anon):0kB isolated(file):128kB present:2080640kB managed:1990060kB mlocked:0kB dirty:39112kB writeback:0kB mapped:83116kB shmem:1484kB slab_reclaimable:909396kB slab_unreclaimable:301708kB kernel_stack:2608kB pagetables:6188kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 21*4kB (UEM) 11*8kB (UM) 10*16kB (UEM) 3*32kB (UM) 1*64kB (E) 1*128kB (E) 2*256kB (UM) 1*512kB (M) 2*1024kB (UM) 2*2048kB (ER) 0*4096kB = 7788kB
DMA32: 276*4kB (UM) 30*8kB (UM) 83*16kB (UM) 2*32kB (MR) 2*64kB (M) 2*128kB (R) 2*256kB (R) 1*512kB (R) 0*1024kB 1*2048kB (R) 0*4096kB = 6192kB
Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
178684 total pagecache pages
1 pages in swap cache
Swap cache stats: add 14, delete 13, find 0/0
Free swap  = 839620kB
Total swap = 839676kB
524158 pages RAM
0 pages HighMem/MovableOnly
22666 pages reserved
nfsd: client 192.168.122.32 failed to respond to layout recall.   Fencing..
nfsd: fence failed for client 192.168.122.32: -2!
receive_cb_reply: Got unrecognized reply: calldir 0x1 xpt_bc_xprt ffff880051dfc000 xid 8ff02aaf
INFO: task nfsd:17653 blocked for more than 120 seconds.
      Not tainted 4.0.0-rc2-09922-g26cbcc7 #89
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nfsd            D ffff8800753a7848 11720 17653      2 0x00000000
 ffff8800753a7848 0000000000000001 0000000000000001 ffffffff82210580
 ffff88004e9bcb50 0000000000000006 ffffffff8119d9f0 ffff8800753a7848
 ffff8800753a7fd8 ffff88002e5e3d70 0000000000000246 ffff88004e9bcb50
Call Trace:
 [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
 [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
 [<ffffffff81a95737>] schedule+0x37/0x90
 [<ffffffff81a95ac8>] schedule_preempt_disabled+0x18/0x30
 [<ffffffff81a97756>] mutex_lock_nested+0x156/0x400
 [<ffffffff813a0d5a>] ? xfs_file_buffered_aio_write.isra.9+0x6a/0x2a0
 [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
 [<ffffffff813a0d5a>] xfs_file_buffered_aio_write.isra.9+0x6a/0x2a0
 [<ffffffff8119d9f0>] ? new_sync_read+0xb0/0xb0
 [<ffffffff813a1016>] xfs_file_write_iter+0x86/0x130
 [<ffffffff8119db05>] do_iter_readv_writev+0x65/0xa0
 [<ffffffff8119f0b2>] do_readv_writev+0xe2/0x280
 [<ffffffff813a0f90>] ? xfs_file_buffered_aio_write.isra.9+0x2a0/0x2a0
 [<ffffffff813a0f90>] ? xfs_file_buffered_aio_write.isra.9+0x2a0/0x2a0
 [<ffffffff810bc15d>] ? __lock_acquire+0x37d/0x2040
 [<ffffffff810be759>] ? lock_release_non_nested+0xa9/0x340
 [<ffffffff81a9aaad>] ? _raw_spin_unlock_irqrestore+0x5d/0x80
 [<ffffffff810bba1d>] ? trace_hardirqs_on_caller+0x12d/0x1d0
 [<ffffffff810bbacd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff8119f2d9>] vfs_writev+0x39/0x50
 [<ffffffffa00ab861>] nfsd_vfs_write.isra.11+0xa1/0x350 [nfsd]
 [<ffffffffa00aecee>] nfsd_write+0x8e/0x100 [nfsd]
 [<ffffffffa00b95b5>] ? gen_boot_verifier+0x5/0xc0 [nfsd]
 [<ffffffffa00b97f5>] nfsd4_write+0x185/0x1e0 [nfsd]
 [<ffffffffa00bbe37>] nfsd4_proc_compound+0x3c7/0x6f0 [nfsd]
 [<ffffffffa00a7463>] nfsd_dispatch+0xc3/0x220 [nfsd]
 [<ffffffffa001314f>] svc_process_common+0x43f/0x650 [sunrpc]
 [<ffffffffa00134a3>] svc_process+0x143/0x260 [sunrpc]
 [<ffffffffa00a6cc7>] nfsd+0x167/0x1e0 [nfsd]
 [<ffffffffa00a6b65>] ? nfsd+0x5/0x1e0 [nfsd]
 [<ffffffffa00a6b60>] ? nfsd_destroy+0xe0/0xe0 [nfsd]
 [<ffffffff81093a2f>] kthread+0xef/0x110
 [<ffffffff81093940>] ? kthread_create_on_node+0x220/0x220
 [<ffffffff81a9b5ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81093940>] ? kthread_create_on_node+0x220/0x220
2 locks held by nfsd/17653:
 #0:  (sb_writers#11){.+.+.+}, at: [<ffffffff8119f208>] do_readv_writev+0x238/0x280
 #1:  (&sb->s_type->i_mutex_key#15){+.+.+.}, at: [<ffffffff813a0d5a>] xfs_file_buffered_aio_write.isra.9+0x6a/0x2a0
INFO: task nfsd:17655 blocked for more than 120 seconds.
...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
