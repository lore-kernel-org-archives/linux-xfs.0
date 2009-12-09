Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB92unmm201760
	for <linux-xfs@oss.sgi.com>; Tue, 8 Dec 2009 20:56:49 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 396FD1762A56
	for <linux-xfs@oss.sgi.com>; Tue,  8 Dec 2009 18:57:22 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id wQv172tvWkD4uhD7 for
	<linux-xfs@oss.sgi.com>; Tue, 08 Dec 2009 18:57:22 -0800 (PST)
Message-ID: <4B1F1211.90607@sandeen.net>
Date: Tue, 08 Dec 2009 20:57:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [BUG report]xfs_btree_make_block_unfull generated an OOPS
References: <389deec70912081758x5af751b8pe3189aee6cb98e97@mail.gmail.com>
In-Reply-To: <389deec70912081758x5af751b8pe3189aee6cb98e97@mail.gmail.com>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-xfs@oss.sgi.com

hank peng wrote:
> Hi, all:
> I think it is a BUG, so I report it here.
> root@1234dahua:~# uname -a
> Linux 1234dahua 2.6.31.6 #14 Tue Dec 8 16:48:40 CST 2009 ppc unknown
> 
> Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc019ea28
> Oops: Kernel access of bad area, sig: 11 [#1]
> MPC85xx CDS
> Modules linked in:
> NIP: c019ea28 LR: c019ea00 CTR: 00000000
> REGS: e233baf0 TRAP: 0300   Not tainted  (2.6.31.6)
> MSR: 00029000 <EE,ME,CE>  CR: 22008484  XER: 00000000
> DEAR: 00000000, ESR: 00800000
> TASK = e8add2c0[21249] 'SS_Server' THREAD: e233a000
> GPR00: 000001a4 e233bba0 e8add2c0 00000000 00000000 00000000 00000001 00000000
> GPR08: c0e22478 e20137b8 c0e2247c 000001a4 22008422 1016d410 3fff5400 100a0000
> GPR16: 100ce108 00000000 006398bb e20137b8 c019c58c 00029000 e233bc5c c0186bd0
> GPR24: c019c568 00000000 22008424 e233bc08 00000000 e233bc58 00000000 e20137b8
> NIP [c019ea28] xfs_btree_make_block_unfull+0xc4/0x1b0

huh, I don't think I've ever seen an oops here, nor has kerneloops.org.

I wonder how you managed this ... :)

> LR [c019ea00] xfs_btree_make_block_unfull+0x9c/0x1b0
> Call Trace:
> [e233bba0] [c019ea00] xfs_btree_make_block_unfull+0x9c/0x1b0 (unreliable)
> [e233bbe0] [c019ee88] xfs_btree_insrec+0x374/0x4b0
> [e233bc50] [c019f040] xfs_btree_insert+0x7c/0x1c0
> [e233bcb0] [c0185ad0] xfs_free_ag_extent+0x34c/0x810

so this is freeing blocks and adding them to the freespace btrees;
it needs to move entries out of a block to make room for the new one.
Not a terribly unusual operation, I think.

> [e233bd20] [c0186668] xfs_free_extent+0xdc/0x104
> [e233bdb0] [c018f350] xfs_bmap_finish+0x154/0x1a0
> [e233bde0] [c01b5e34] xfs_itruncate_finish+0x254/0x3b8
> [e233be60] [c01d033c] xfs_free_eofblocks+0x254/0x29c
> [e233bee0] [c01d9ba8] xfs_file_release+0x14/0x28
> [e233bef0] [c009574c] __fput+0xe8/0x1dc
> [e233bf10] [c0092048] filp_close+0x70/0xb0
> [e233bf30] [c009211c] sys_close+0x94/0xc0
> [e233bf40] [c000f784] ret_from_syscall+0x0/0x3c
> Instruction dump:
> 7fa5eb78 4bffdf59 7c7c1b79 40a2ffd4 801d0000 2f800000 419e0064 57c9103a
> 7f83e378 7d29fa14 80090050 90170000 <90190000> 80010044 bae1001c 38210040
> ---[ end trace 069fbb7d042289d2 ]---
> 
> According to the above call trace, I checked the source code and found
> that it may be invoked by xfs_btree_make_block_unfull function in
> fs/xfs/xfs_btree.c:
> 
> 2641
> 2642         if (*stat) {
> 2643                 *oindex = *index = cur->bc_ptrs[level];
> 2644                 return 0;
> 2645         }
> 
> here, oindex is NULL so OOPs occured. I am not a xfs hacker, I hope
> someone can help me fix this BUG, if you need more information, let me
> know.

Is the above from gdb?  You're quite certain that this is the case,
or is this a guess?

It seems a little unlikely because in the calling function:

        int                     optr;   /* old key/record index */
        int                     ptr;    /* key/record index */

// .... code code code ...

        if (numrecs == cur->bc_ops->get_maxrecs(cur, level)) {
                error = xfs_btree_make_block_unfull(cur, level, numrecs,
                                        &optr, &ptr, &nptr, &ncur, &nrec, stat);

We're just sending in the addresses of these local variables;
I don't see how these pointers could be NULL.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
