Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51150 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753820AbdEKO6u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 10:58:50 -0400
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <208b91b4-9f5e-b204-52d7-4b7706bdc8fe@sandeen.net>
Date: Thu, 11 May 2017 09:58:49 -0500
MIME-Version: 1.0
In-Reply-To: <591493D00200007800158EA3@prv-mh.provo.novell.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Beulich <JBeulich@suse.com>, linux-xfs@vger.kernel.org

On 5/11/17 9:39 AM, Jan Beulich wrote:
> Hello,
> 
> It is now on two systems that I'm getting
> 
> XFS (sda1): corrupt dinode 576254627, has realtime flag set.
> ffff88042ea63300: 49 4e 81 a4 02 02 00 00 00 00 03 e8 00 00 00 64  IN.............d
> ffff88042ea63310: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff88042ea63320: 59 14 0e 9f 0f a7 7c 2f 59 14 0e 9f 18 f3 db 2f  Y.....|/Y....../
> ffff88042ea63330: 59 14 0e 9f 18 f3 db 2f 00 00 00 00 00 00 80 80  Y....../........
> XFS (sda1): Internal error xfs_iformat(realtime) at line 133 of file .../fs/xfs/xfs_inode_fork.c.  Caller xfs_iread+0xea/0x2e0 [xfs]
> CPU: 10 PID: 4418 Comm: smbd Not tainted 3.12.73-sp1-2017-04-26-jb #2

Well, pretty old... oh, ok but you think it came about after a
4.11 crash?

> Hardware name: AMD Dinar/Dinar, BIOS RDN1506A 08/31/2014
>  0000000000000001 ffffffff81354083 ffffffffa03ea40a ffffffffa03a0952
>  0000000000000000 0000000000000075 ffff88042ea63300 ffff88042f508000
>  ffff88022efe7000 ffff88042f508028 0000000000000000 ffffffffa03e9b06
> Call Trace:
>  [<ffffffff81004e3b>] dump_trace+0x7b/0x310
>  [<ffffffff81004ad6>] show_stack_log_lvl+0xe6/0x150
>  [<ffffffff81005ddc>] show_stack+0x1c/0x50
>  [<ffffffff81354083>] dump_stack+0x6f/0x84
>  [<ffffffffa03a0952>] xfs_corruption_error+0x62/0xa0 [xfs]
>  [<ffffffffa03e9b06>] xfs_iformat_fork+0x3b6/0x530 [xfs]
>  [<ffffffffa03ea40a>] xfs_iread+0xea/0x2e0 [xfs]
>  [<ffffffffa03a6538>] xfs_iget_cache_miss+0x58/0x1d0 [xfs]
>  [<ffffffffa03a67c3>] xfs_iget+0x113/0x190 [xfs]
>  [<ffffffffa03e5be8>] xfs_lookup+0xb8/0xd0 [xfs]
>  [<ffffffffa03aaddd>] xfs_vn_lookup+0x4d/0x90 [xfs]
>  [<ffffffff8110539d>] lookup_real+0x1d/0x60
>  [<ffffffff811064d2>] __lookup_hash+0x32/0x50
>  [<ffffffff8110a2a4>] path_lookupat+0x7f4/0x8b0
>  [<ffffffff8110a38e>] filename_lookup+0x2e/0x90
>  [<ffffffff8110abef>] user_path_at_empty+0x9f/0xd0
>  [<ffffffff81100678>] vfs_fstatat+0x48/0xa0
>  [<ffffffff8110081f>] SyS_newstat+0x1f/0x50
>  [<ffffffff81358d42>] system_call_fastpath+0x16/0x1b
>  [<00007f141f4f0d35>] 0x7f141f4f0d34
> XFS (sda1): Corruption detected. Unmount and run xfs_repair
> 
> after a crash with a 4.11-based kernel.

Oh, hm.  What caused that crash, do you have logs prior to it?

> I didn't try xfs_repair-ing
> the volume in this second instance, as the result from doing so in
> the first instance was only permanent re-occurrence (and
> apparently spreading) of the problem. It may be interesting that
> xfs_check finds only this one corrupted inode, while the kernel
> also finds at least one more:

xfs_repair -n would be safe, what does it say?  (mount/unmount
first, to clear the log)

> XFS (sda1): corrupt dinode 104812066, has realtime flag set.
> ffff88042e88f200: 49 4e 41 ed 02 01 00 00 00 00 03 e8 00 00 00 64  INA............d
> ffff88042e88f210: 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00  ................
> ffff88042e88f220: 59 01 c7 96 00 16 1e 50 59 14 0e a2 15 60 54 2f  Y......PY....`T/
> ffff88042e88f230: 59 14 0e a2 15 60 54 2f 00 00 00 00 00 00 00 8e  Y....`T/........
> XFS (sda1): Internal error xfs_iformat(realtime) at line 133 of file .../fs/xfs/xfs_inode_fork.c.  Caller xfs_iread+0xea/0x2e0 [xfs]
> 
> The kernel used after the crash doesn't appear to matter, all report
> the same issues, but I've experienced similar crashes in the past
> without ever having seen such corruption before.
> 
> In any event I think there are two problems: The corruption itself
> (possibly an issue with recent enough upstream kernels only) and
> the fact that running xfs_repair doesn't help in these cases. I'm
> attaching xfs_check and xfs_metadump warning output for both
> affected volumes in this second instance. The full files
> xfs_metadump -agow produced can be provided upon request
> (500Mb and 80Mb uncompressed respectively).

can you provide one or both compressed xfs_metadumps offline?
(No need to post URL to the list)

Thanks,
-Eric

> Thanks for any advice / fix,
> Jan
> 
