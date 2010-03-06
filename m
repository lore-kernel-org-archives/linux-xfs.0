Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26LJEIE122678 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 15:19:15 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D01213FFE37
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 13:20:42 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id 1qMR0rtEr0XqcbSC
	for <xfs@oss.sgi.com>; Sat, 06 Mar 2010 13:20:42 -0800 (PST)
Message-ID: <4B92C71C.5010003@dermichi.com>
Date: Sat, 06 Mar 2010 22:20:28 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>	<20100304112018.GG14317@discord.disaster>	<4B8FA2CD.6010904@dermichi.com>	<20100304131511.GH14317@discord.disaster>	<20100304134641.GA26871@infradead.org>	<4B8FC1B7.3070505@dermichi.com>
	<20100304222611.GK14317@discord.disaster>
In-Reply-To: <20100304222611.GK14317@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

> If xfs_fsr hung before it checked the nodefrag flag, then there's
> only a few things it could get stuck on:
> 
> 	1. fsync() of the file
> 	2. file lock checks
> 	3. statvfs64()
> 	4. ioctl(XFS_IOC_FSGETXATTR)
> 
> A trace would tell us which one it was....
> 
Got another one, this time with ksyms enabled:
[192115.749003] BUG: unable to handle kernel NULL pointer dereference at
0000000000000018
[192115.749197] IP: [<ffffffff811ad69d>] xfs_trans_find_item+0x1/0xa
[192115.749259] PGD 2f0dec067 PUD 1b1ab9067 PMD 0
[192115.749264] Oops: 0000 [#1] SMP
[192115.749267] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[192115.749271] CPU 3
[192115.749276] Pid: 1671, comm: xfs_fsr Not tainted 2.6.33 #1
0JR815/PowerEdge 2950
[192115.749279] RIP: 0010:[<ffffffff811ad69d>]  [<ffffffff811ad69d>]
xfs_trans_find_item+0x1/0xa
[192115.749284] RSP: 0018:ffff8800aec13b78  EFLAGS: 00010296
[192115.749287] RAX: 0000000000000008 RBX: ffff8800ad600320 RCX:
ffff8800aec13d54
[192115.749289] RDX: 0000000000000005 RSI: 0000000000000000 RDI:
ffff8800ad600320
[192115.749292] RBP: ffff8800aec13ba8 R08: 000000000000007c R09:
ffff88032fb0b600
[192115.749295] R10: 00000000ffffffff R11: ffff8800282cde60 R12:
ffff8802d3f12c00
[192115.749298] R13: 0000000000000005 R14: 0000000000000000 R15:
ffff8802d3f12c38
[192115.749302] FS:  00007f8f3cc5a6f0(0000) GS:ffff8800282c0000(0000)
knlGS:0000000000000000
[192115.749305] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[192115.749307] CR2: 0000000000000018 CR3: 000000014904b000 CR4:
00000000000006e0
[192115.749310] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[192115.749313] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[192115.749316] Process xfs_fsr (pid: 1671, threadinfo ffff8800aec12000,
task ffff88032e77b600)
[192115.749318] Stack:
[192115.749320]  ffff8800aec13ba8 ffffffff811ad5c0 ffff8802d3f12c00
0000000000000000
[192115.749324] <0> ffff8802d3f12c00 ffffffffffffffff ffff8800aec13ce8
ffffffff81180554
[192115.749328] <0> ffff8800aec13ca8 0000000000000000 ffff880000000000
ffff880300000000
[192115.749332] Call Trace:
[192115.749338]  [<ffffffff811ad5c0>] ? xfs_trans_log_inode+0x22/0x4c
[192115.749344]  [<ffffffff81180554>] xfs_bunmapi+0x9ec/0xa36
[192115.749350]  [<ffffffff8119a452>] xfs_itruncate_finish+0x188/0x2db
[192115.749355]  [<ffffffff811b0d41>] xfs_inactive+0x218/0x435
[192115.749360]  [<ffffffff81364338>] ? __mutex_lock_slowpath+0x22d/0x23c
[192115.749365]  [<ffffffff811bb096>] xfs_fs_clear_inode+0xb3/0xb8
[192115.749371]  [<ffffffff810df28a>] clear_inode+0x78/0xd1
[192115.749375]  [<ffffffff810df9f8>] generic_delete_inode+0xf6/0x16b
[192115.749379]  [<ffffffff810dfa84>] generic_drop_inode+0x17/0x62
[192115.749382]  [<ffffffff810deace>] iput+0x61/0x65
[192115.749386]  [<ffffffff810dbf25>] dentry_iput+0xb5/0xc5
[192115.749389]  [<ffffffff810dc00f>] d_kill+0x43/0x63
[192115.749393]  [<ffffffff810dc75f>] dput+0x148/0x155
[192115.749398]  [<ffffffff810cda56>] __fput+0x196/0x1bb
[192115.749401]  [<ffffffff810cda93>] fput+0x18/0x1a
[192115.749405]  [<ffffffff810cac36>] filp_close+0x67/0x72
[192115.749409]  [<ffffffff810cacda>] sys_close+0x99/0xd2
[192115.749415]  [<ffffffff810029ab>] system_call_fastpath+0x16/0x1b
[192115.749417] Code: 89 c4 85 c0 75 13 48 85 db 74 0e 44 89 ea 49 8b 36
48 89 df e8 5f ff ff ff 5a 44 89 e0 59 5b 41 5c 41 5d 41 5e c9 c3 90 90
90 55 <48> 8b 46 18 48 89 e5 c9 c3 55 31 ff 8a 56 0b 48 89 e5 0f b6 c2
[192115.749441] RIP  [<ffffffff811ad69d>] xfs_trans_find_item+0x1/0xa
[192115.749445]  RSP <ffff8800aec13b78>
[192115.749447] CR2: 0000000000000018
[192115.749458] ---[ end trace b5b512ceb91c24c7 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
