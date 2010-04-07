Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o37HfMjc210006 for <xfs@oss.sgi.com>; Wed, 7 Apr 2010 12:41:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27E1F125539F
	for <xfs@oss.sgi.com>; Wed,  7 Apr 2010 10:43:11 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id FoSNViuJwFo4Y4fr for
	<xfs@oss.sgi.com>; Wed, 07 Apr 2010 10:43:11 -0700 (PDT)
Message-ID: <4BBCC42E.2000409@sandeen.net>
Date: Wed, 07 Apr 2010 12:43:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
	write load, 8k stack, x86-64
References: <4BBC6719.7080304@humyo.com> <20100407140523.GJ11036@dastard>
	<4BBCAB57.3000106@humyo.com>
In-Reply-To: <4BBCAB57.3000106@humyo.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Berthels <john@humyo.com>
Cc: Nick Gregory <nick@humyo.com>, Rob Sanderson <rob@humyo.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

John Berthels wrote:
> Dave Chinner wrote:
>> I'm not seeing stacks deeper than about 5.6k on XFS under heavy write
>> loads. That's nowhere near blowing an 8k stack, so there must be
>> something special about what you are doing. Can you post the stack
>> traces that are being generated for the deepest stack generated -
>> /sys/kernel/debug/tracing/stack_trace should contain it.
>>   
> Appended below. That doesn't seem to reach 8192 but the box it's from
> has logged:
> 
> [74649.579386] apache2 used greatest stack depth: 7024 bytes left

but that's -left- (out of 8k or is that from a THREAD_ORDER=2 box?)

I guess it must be out of 16k...

>        Depth    Size   Location    (47 entries)
>        -----    ----   --------
>  0)     7568      16   mempool_alloc_slab+0x16/0x20
>  1)     7552     144   mempool_alloc+0x65/0x140
>  2)     7408      96   get_request+0x124/0x370
>  3)     7312     144   get_request_wait+0x29/0x1b0
>  4)     7168      96   __make_request+0x9b/0x490
>  5)     7072     208   generic_make_request+0x3df/0x4d0
>  6)     6864      80   submit_bio+0x7c/0x100
>  7)     6784      96   _xfs_buf_ioapply+0x128/0x2c0 [xfs]
>  8)     6688      48   xfs_buf_iorequest+0x75/0xd0 [xfs]
>  9)     6640      32   _xfs_buf_read+0x36/0x70 [xfs]
> 10)     6608      48   xfs_buf_read+0xda/0x110 [xfs]
> 11)     6560      80   xfs_trans_read_buf+0x2a7/0x410 [xfs]
> 12)     6480      80   xfs_btree_read_buf_block+0x5d/0xb0 [xfs]
> 13)     6400      80   xfs_btree_lookup_get_block+0x84/0xf0 [xfs]
> 14)     6320     176   xfs_btree_lookup+0xd7/0x490 [xfs]
> 15)     6144      16   xfs_alloc_lookup_eq+0x19/0x20 [xfs]
> 16)     6128      96   xfs_alloc_fixup_trees+0xee/0x350 [xfs]
> 17)     6032     144   xfs_alloc_ag_vextent_near+0x916/0xb30 [xfs]
> 18)     5888      32   xfs_alloc_ag_vextent+0xe5/0x140 [xfs]
> 19)     5856      96   xfs_alloc_vextent+0x49f/0x630 [xfs]
> 20)     5760     160   xfs_bmbt_alloc_block+0xbe/0x1d0 [xfs]
> 21)     5600     208   xfs_btree_split+0xb3/0x6a0 [xfs]
> 22)     5392      96   xfs_btree_make_block_unfull+0x151/0x190 [xfs]
> 23)     5296     224   xfs_btree_insrec+0x39c/0x5b0 [xfs]
> 24)     5072     128   xfs_btree_insert+0x86/0x180 [xfs]
> 25)     4944     352   xfs_bmap_add_extent_delay_real+0x41e/0x1660 [xfs]
> 26)     4592     208   xfs_bmap_add_extent+0x41c/0x450 [xfs]
> 27)     4384     448   xfs_bmapi+0x982/0x1200 [xfs]

This one, I'm afraid, has always been big.

> 28)     3936     256   xfs_iomap_write_allocate+0x248/0x3c0 [xfs]
> 29)     3680     208   xfs_iomap+0x3d8/0x410 [xfs]
> 30)     3472      32   xfs_map_blocks+0x2c/0x30 [xfs]
> 31)     3440     256   xfs_page_state_convert+0x443/0x730 [xfs]
> 32)     3184      64   xfs_vm_writepage+0xab/0x160 [xfs]
> 33)     3120     384   shrink_page_list+0x65e/0x840
> 34)     2736     528   shrink_zone+0x63f/0xe10

that's a nice one  (actually the two together at > 900 bytes, ouch)

> 35)     2208     112   do_try_to_free_pages+0xc2/0x3c0
> 36)     2096     128   try_to_free_pages+0x77/0x80
> 37)     1968     240   __alloc_pages_nodemask+0x3e4/0x710
> 38)     1728      48   alloc_pages_current+0x8c/0xe0
> 39)     1680      16   __get_free_pages+0xe/0x50
> 40)     1664      48   __pollwait+0xca/0x110
> 41)     1616      32   unix_poll+0x28/0xc0
> 42)     1584      16   sock_poll+0x1d/0x20
> 43)     1568     912   do_select+0x3d6/0x700

912, ouch!

int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
{
        ktime_t expire, *to = NULL;
        struct poll_wqueues table;

(gdb) p sizeof(struct poll_wqueues)
$1 = 624

I guess that's been there forever, though.

> 44)      656     416   core_sys_select+0x18c/0x2c0

416 hurts too.

The xfs callchain is deep, no doubt, but the combination of the select path
and the shrink calls is almost 2k in just a few calls, and that doesn't
help much.

-Eric

> 45)      240     112   sys_select+0x4f/0x110
> 46)      128     128   system_call_fastpath+0x16/0x1b
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
