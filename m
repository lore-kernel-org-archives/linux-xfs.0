Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBEFuDPI158301 for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 09:56:13 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF814F36C6
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2009 07:56:50 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id eTzKaXEeoasMpCdZ for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2009 07:56:50 -0800 (PST)
Message-ID: <4B26604B.3060901@sandeen.net>
Date: Mon, 14 Dec 2009 09:56:59 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [BUG report]xfs_btree_make_block_unfull generated an OOPS
References: <389deec70912081758x5af751b8pe3189aee6cb98e97@mail.gmail.com>	
	<4B1F1211.90607@sandeen.net>	
	<389deec70912081918v24ccc5abi90c8fc7546c741d7@mail.gmail.com>	
	<4B1F18C4.3060704@sandeen.net>	
	<389deec70912082053v4310057dg479f6d4b6c4b46f7@mail.gmail.com>	
	<4B1F31FD.3020705@sandeen.net>	
	<389deec70912082220pcb3b5d1q516ac197d31502c5@mail.gmail.com>	
	<389deec70912082230g38987576pc48d7699f23844c5@mail.gmail.com>
	<389deec70912140119q40ed91cao62fe9c9ebdf13601@mail.gmail.com>
In-Reply-To: <389deec70912140119q40ed91cao62fe9c9ebdf13601@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>, xfs-oss <xfs@oss.sgi.com>

hank peng wrote:
> Hi,Eric:
> I think I have found the reason to this problem, but I need you a little help.
> We have tested it again, and the same OOPS occured again:

Ok, let's keep this on the list please ...

> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc019f4b8
> Oops: Kernel access of bad area, sig: 11 [#1]
> MPC85xx CDS
> Modules linked in:
> NIP: c019f4b8 LR: c019f490 CTR: 00000000
> REGS: ef965af0 TRAP: 0300   Not tainted  (2.6.31.6-svn40)
> MSR: 00029000 <EE,ME,CE>  CR: 22008284  XER: 00000000
> DEAR: 00000000, ESR: 00800000
> TASK = e8a56580[3450] 'SS_Server' THREAD: ef964000
> GPR00: 000001fd ef965ba0 e8a56580 00000000 00000000 00000001 00000001 00000001
> GPR08: e8fa10e8 e8fa1a18 e8fa10f0 000001fd 22008222 1016d410 3fff5400 100a0000
> GPR16: 100d2408 00000000 00000000 d42b12f8 c019d01c 00029000 ef965c5c c0187660
> GPR24: c019cff8 00000000 22008224 ef965c08 00000000 ef965c58 00000000 e8fa1a18
> NIP [c019f4b8] xfs_btree_make_block_unfull+0xc4/0x1b0
> LR [c019f490] xfs_btree_make_block_unfull+0x9c/0x1b0
> Call Trace:
> [ef965ba0] [c019f490] xfs_btree_make_block_unfull+0x9c/0x1b0 (unreliable)
> [ef965be0] [c019f918] xfs_btree_insrec+0x374/0x4b0
> [ef965c50] [c019fad0] xfs_btree_insert+0x7c/0x1c0
> [ef965cb0] [c018661c] xfs_free_ag_extent+0x408/0x810
> [ef965d20] [c01870f8] xfs_free_extent+0xdc/0x104
> [ef965db0] [c018fde0] xfs_bmap_finish+0x154/0x1a0
> [ef965de0] [c01b68c4] xfs_itruncate_finish+0x254/0x3b8
> [ef965e60] [c01d0dcc] xfs_free_eofblocks+0x254/0x29c
> [ef965ee0] [c01da638] xfs_file_release+0x14/0x28
> [ef965ef0] [c009574c] __fput+0xe8/0x1dc
> [ef965f10] [c0092048] filp_close+0x70/0xb0
> [ef965f30] [c009211c] sys_close+0x94/0xc0
> [ef965f40] [c000f784] ret_from_syscall+0x0/0x3c
> Instruction dump:
> 7fa5eb78 4bffdf59 7c7c1b79 40a2ffd4 801d0000 2f800000 419e0064 57c9103a
> 7f83e378 7d29fa14 80090050 90170000 <90190000> 80010044 bae1001c 38210040
> ---[ end trace 356726176eeecd9c ]---
> Oops: Exception in kernel mode, sig: 4 [#2]
> MPC85xx CDS
> Modules linked in:
> NIP: c0187660 LR: c019b26c CTR: c0187660
> REGS: d42076a0 TRAP: 0700   Tainted: G      D     (2.6.31.6-svn40)
> MSR: 00029000 <EE,ME,CE>  CR: 22222082  XER: 00000000
> TASK = e08a6ee0[8533] 'pdflush' THREAD: d4206000
> GPR00: 00000004 d4207750 e08a6ee0 d42b1098 00000001 00000001 e8e97d80 00000003
> GPR08: c2c65300 c0187660 41425443 41425443 00001000 1001a1c4 c01842f8 00000001
> GPR16: d4207880 d42077e0 00000002 d42077d8 d42077e0 d42077e8 d42b10ec 00000001
> GPR24: c0486be0 00000000 d42b1098 09c40000 c019b4f0 00000011 e88bf000 d4207750
> NIP [c0187660] xfs_allocbt_get_maxrecs+0x0/0x20
> LR [c019b26c] xfs_btree_check_sblock+0xb0/0xf8
> Call Trace:
> [d4207770] [c019b4f0] xfs_btree_read_buf_block+0x8c/0xb8
> [d42077a0] [c019b5a8] xfs_btree_lookup_get_block+0x8c/0xfc
> [d42077d0] [c019c638] xfs_btree_lookup+0x124/0x3fc
> [d4207850] [c01842f8] xfs_alloc_lookup_ge+0x20/0x30
> [d4207860] [c0185828] xfs_alloc_ag_vextent_near+0x60/0xa4c
> [d42078e0] [c0186af4] xfs_alloc_ag_vextent+0xd0/0x168
> [d4207900] [c01873f0] xfs_alloc_vextent+0x2d0/0x524
> [d4207940] [c01940fc] xfs_bmap_btalloc+0x274/0xa60
> [d4207a00] [c01988bc] xfs_bmapi+0xb30/0x10dc
> [d4207b40] [c01bb190] xfs_iomap_write_allocate+0x11c/0x450
> [d4207c00] [c01bc2e8] xfs_iomap+0x320/0x35c
> [d4207c80] [c01d5d5c] xfs_map_blocks+0x2c/0x40
> [d4207ca0] [c01d6dc0] xfs_page_state_convert+0x2e8/0x744
> [d4207d60] [c01d7384] xfs_vm_writepage+0x7c/0x128
> [d4207d90] [c006d740] __writepage+0x24/0x80
> [d4207da0] [c006db44] write_cache_pages+0x1e4/0x3a0
> [d4207e50] [c01d5e14] xfs_vm_writepages+0x24/0x34
> [d4207e60] [c006dd70] do_writepages+0x48/0x7c
> [d4207e70] [c00b2120] writeback_single_inode+0xf8/0x2e4
> [d4207ec0] [c00b2788] generic_sync_sb_inodes+0x280/0x398
> [d4207ef0] [c00b295c] writeback_inodes+0xb8/0xd4
> [d4207f10] [c006ece0] wb_kupdate+0xd4/0x154
> [d4207f70] [c006f3bc] pdflush+0xd4/0x1c4
> [d4207fc0] [c004c750] kthread+0x78/0x7c
> <...>
> 
> 
> There were another OOPS which followed the first one. 

After the first oops I think the rest is not interesting, things
are in bad shape by now.

> Please note that
> in the second OOPS, a SIGILL has been invoked and address of illegal
> instrucion is 0xc0187660.
> In the first OOPS, look at the following registers:
> 
> GPR00: 000001fd ef965ba0 e8a56580 00000000 00000000 00000001 00000001 00000001
> GPR08: e8fa10e8 e8fa1a18 e8fa10f0 000001fd 22008222 1016d410 3fff5400 100a0000
> GPR16: 100d2408 00000000 00000000 d42b12f8 c019d01c 00029000 ef965c5c c0187660
> GPR24: c019cff8 00000000 22008224 ef965c08 00000000 ef965c58 00000000 e8fa1a18
> 
> I noticed that the value of r23 is also 0xc0187660. I have a little
> powerpc assembly code knowledge, if I am not wrong,
> *oindex = *index = cur->bc_ptrs[level];' in fs/xfs/xfs_btree.c was
> built into the following asm code which I send it to you ealier:
> 80 09 00 50     lwz     r0,80(r9)
> 90 17 00 00     stw     r0,0(r23)
> 90 19 00 00     stw     r0,0(r25)              <OOPs occured here>
> 
> So, r23 should have pointed to address of index and never had a chace
> to point to a code adress, but it did. What's worse, the code at
> 0xc0187660 had been changed and the second OOPS happened imediately.
> 
> Could you correct my analysis if I am wrong?
> In addition, I think the problem may be caused by stack overflow, what
> is your comments?
> 
> 
Perhaps, but if this is the 2nd oops I think it is not worth investigating;
we need to figure out why the first one happened, and from that stack trace
I don't think you are close to overflowing...

-eric

> 
> 2009/12/9 hank peng <pengxihan@gmail.com>:
>> 2009/12/9 hank peng <pengxihan@gmail.com>:
>>> 2009/12/9 Eric Sandeen <sandeen@sandeen.net>:
>>>> hank peng wrote:
>>>>> 2009/12/9 Eric Sandeen <sandeen@sandeen.net>:
>>>>>> hank peng wrote:
>>>>>>
>>>>>>> Thanks for your replay.
>>>>>>>
>>>>>>> I made this conclusion from assembly code, correct me if I am wrong.
>>>>>>> #powerpc-linux-gnuspe-objdump vmlinux | less
>>>>>>> <snip>
>>>>>> (off list; if this works maybe you can reply on-list?)
>>>>>>
>>>>>> Could you use gdb to look?  Maybe:
>>>>>>
>>>>>> (gdb) list *xfs_btree_make_block_unfull+0xc4
>>>>>>
>>>>> I use gdb on my PC and get this:
>>>>>
>>>>> [root@localhost linux-2.6.31.6]# gdb vmlinux
>>>>> GNU gdb Red Hat Linux (6.5-37.el5rh)
>>>>> Copyright (C) 2006 Free Software Foundation, Inc.
>>>>> GDB is free software, covered by the GNU General Public License, and you are
>>>>> welcome to change it and/or distribute copies of it under certain conditions.
>>>>> Type "show copying" to see the conditions.
>>>>> There is absolutely no warranty for GDB.  Type "show warranty" for details.
>>>>> This GDB was configured as "i386-redhat-linux-gnu"...Using host
>>>>> libthread_db library "/lib/libthread_db.so.1".
>>>>>
>>>>> (gdb) list *xfs_btree_make_block_unfull+0xc4
>>>>> No source file for address 0xc019ea28.
>>>>> (gdb)
>>>>>
>>>>>> -Eric
>>>> so I guess it is not built with debugging symbols perhaps?
>>>>
>>>> Try rebuilding it with CONFIG_DEBUG_INFO on maybe?
>>>>
>>> yes, you are right, now I get the result:
>>> (gdb) l *xfs_btree_make_block_unfull+0xc4
>>> 0xc019ea30 is in xfs_btree_make_block_unfull (fs/xfs/xfs_btree.c:2643).
>>> 2638            error = xfs_btree_lshift(cur, level, stat);
>>> 2639            if (error)
>>> 2640                    return error;
>>> 2641
>>> 2642            if (*stat) {
>>> 2643                    *oindex = *index = cur->bc_ptrs[level];
>>> 2644                    return 0;
>>> 2645            }
>>> 2646
>>> 2647            /*
>>>
>>> It indeed points to "*oindex = *index = cur->bc_ptrs[level];"
>>>
>> Very strange, as you said, xfs_btree_insrec passes address local
>> variable to xfs_btree_make_block_unfull, so it is impossible for
>> oindex to be NULL.
>> Do you think it may be an memory corrupt?
>>>> -Eric
>>>>
>>>
>>>
>>> --
>>> The simplest is not all best but the best is surely the simplest!
>>>
>>
>>
>> --
>> The simplest is not all best but the best is surely the simplest!
>>
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
