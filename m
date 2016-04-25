Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5ACC27CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 16:57:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22C83304032
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 14:57:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id huyey747fS6TO4e6 for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 14:57:15 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 677F5545
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 16:57:12 -0500 (CDT)
Subject: Re: Metadata corruption detected at
	xfs_attr3_leaf_write_verify+0xe5/0x100
References: <88e4a059c1428cb1f944b7e786cf8ed9@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <571E92B7.3010608@sandeen.net>
Date: Mon, 25 Apr 2016 16:57:11 -0500
MIME-Version: 1.0
In-Reply-To: <88e4a059c1428cb1f944b7e786cf8ed9@mail.gmail.com>
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
To: xfs@oss.sgi.com



On 4/25/16 11:51 AM, Shyam Kaushik wrote:
> Hi Dave et al,
> 
> We are periodically hitting the below metadata corruption with XFS over a
> raw disk running several file copies with xattr operations on kernel
> 3.18.19. Unmounting & running xfs_repair doesn't report any corruption. I
> see that this was last reported here
> http://oss.sgi.com/archives/xfs/2015-12/msg00224.html
> 
> Unfortunately we dont have a reproducer, but this issue happens
> periodically. We can add more debug prints & allow this issue to happen
> again. Can you pls suggest any options to debug this further? Thanks

Is this a non-crc filesystem?

> Apr 20 21:58:03 node1 kernel: [16736.286370] XFS (dm-26): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x19c5c728
> Apr 20 21:58:03 node1 kernel: [16736.289084] XFS (dm-26): Unmount and run xfs_repair
> Apr 20 21:58:03 node1 kernel: [16736.290257] XFS (dm-26): First 64 bytes of corrupted metadata buffer:
> Apr 20 21:58:03 node1 kernel: [16736.291797] ffff880123668000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................

XFS_ATTR_LEAF_MAGIC is ok (if it's a non-crc filesystem)

Looks the same as the other report, tripping on:

        if (ichdr.count == 0)
                return false;

A reproducer would be super here.  At least maybe a description of the
workload that hits it?

Count is manipulated in things like attr leaf compaction...
Any other messages prior to this?

How often do you hit it?

You could also turn on xfs_attr_* tracepoints, maybe.

-Eric

> Apr 20 21:58:03 node1 kernel: [16736.293823] ffff880123668010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
> Apr 20 21:58:03 node1 kernel: [16736.297504] ffff880123668020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Apr 20 21:58:03 node1 kernel: [16736.299343] ffff880123668030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> Apr 20 21:58:03 node1 kernel: [16736.301465] XFS (dm-26): xfs_do_force_shutdown(0x8) called from line 1244 of file fs/xfs/xfs_buf.c. Return address = 0xffffffffc095cee0
> Apr 20 21:58:03 node1 kernel: [16736.301469] ------------[ cut here ]------------
> Apr 20 21:58:03 node1 kernel: [16736.301551] XFS(dm-26): SHUTDOWN!!! old_flags=0x0 new_flags=0x8
> Apr 20 21:58:03 node1 kernel: [16736.301703] CPU: 1 PID: 7857 Comm: xfsaild/dm-26 Tainted: G           OE  3.18.19 #1
> Apr 20 21:58:03 node1 kernel: [16736.301705] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Apr 20 21:58:03 node1 kernel: [16736.301707]  0000000000000009 ffff88020c5ffb38 ffffffff81710c85 0000000000000000
> Apr 20 21:58:03 node1 kernel: [16736.301711]  ffff88020c5ffb88 ffff88020c5ffb78 ffffffff81072df1 2e2e202030302030
> Apr 20 21:58:03 node1 kernel: [16736.301715]  0000000000000000 0000000000000008 ffff88020c127000 0000000000000000
> Apr 20 21:58:03 node1 kernel: [16736.301718] Call Trace:
> Apr 20 21:58:03 node1 kernel: [16736.301769]  [<ffffffff81710c85>] dump_stack+0x4e/0x71
> Apr 20 21:58:03 node1 kernel: [16736.301780]  [<ffffffff81072df1>] warn_slowpath_common+0x81/0xa0
> Apr 20 21:58:03 node1 kernel: [16736.301784]  [<ffffffff81072e56>] warn_slowpath_fmt+0x46/0x50
> Apr 20 21:58:03 node1 kernel: [16736.301860]  [<ffffffffc09693f3>] xfs_do_force_shutdown+0x33/0x170 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.301921]  [<ffffffffc095cee0>] ? _xfs_buf_ioapply+0xa0/0x430 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.301951]  [<ffffffffc095ee4b>] ? __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302066]  [<ffffffffc095cee0>] _xfs_buf_ioapply+0xa0/0x430 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302137]  [<ffffffff8109e260>] ? wake_up_state+0x20/0x20
> Apr 20 21:58:03 node1 kernel: [16736.302162]  [<ffffffffc095ee4b>] ? __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302183]  [<ffffffffc095ea78>] xfs_buf_submit+0x68/0x210 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302241]  [<ffffffffc095ee4b>] __xfs_buf_delwri_submit+0x22b/0x290 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302267]  [<ffffffffc095fc60>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302291]  [<ffffffffc098f440>] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302308]  [<ffffffffc095fc60>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302333]  [<ffffffffc098f66b>] xfsaild+0x22b/0x630 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302513]  [<ffffffffc098f440>] ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> Apr 20 21:58:03 node1 kernel: [16736.302518]  [<ffffffff810911b9>] kthread+0xc9/0xe0
> Apr 20 21:58:03 node1 kernel: [16736.302522]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
> Apr 20 21:58:03 node1 kernel: [16736.302530]  [<ffffffff81717918>] ret_from_fork+0x58/0x90
> Apr 20 21:58:03 node1 kernel: [16736.302549]  [<ffffffff810910f0>] ? kthread_create_on_node+0x180/0x180
> Apr 20 21:58:03 node1 kernel: [16736.302551] ---[ end trace
> 0bb81b88fdd6a298 ]---
> 
> --Shyam
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
