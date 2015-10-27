Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E94397F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 07:10:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD164304039
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 05:10:13 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[194.177.153.153]) by cuda.sgi.com with ESMTP id
	UgqJuEw9hBw7GHKI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Oct 2015 05:10:10 -0700 (PDT)
Received: from noclinksys.net4you.net ([194.177.153.180] helo=[127.0.0.1])
	by firestarter.dermichi.com with esmtpsa
	(TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128) (Exim)
	(envelope-from <mw@dermichi.com>) id 1Zr34q-0005NW-UD
	for xfs@oss.sgi.com; Tue, 27 Oct 2015 13:10:08 +0100
From: Michael Weissenbacher <mw@dermichi.com>
Subject: Speeding up xfs_repair on filesystem with millions of inodes
Message-ID: <562F699E.2050002@dermichi.com>
Date: Tue, 27 Oct 2015 13:10:06 +0100
MIME-Version: 1.0
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

Hi List!
I have an xfs filesystem which probably suffered a corruption due to a
bad UPS (even though the RAID controller has a good BBU). At the time
the power loss occurred the filesystem was mounted with the "nobarrier"
option.

We noticed the problem several weeks later, when some rsync-based backup
jobs started to hang for days without progress when doing a simple "rm".
This was accompanied by some messages in dmesg like this one:
Oct 15 21:53:14 mojave kernel: [4976164.170021] INFO: task kswapd0:38
blocked for more than 120 seconds.
Oct 15 21:53:14 mojave kernel: [4976164.170100] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 15 21:53:14 mojave kernel: [4976164.170180] kswapd0         D
ffffffff8180bea0     0    38      2 0x00000000
Oct 15 21:53:14 mojave kernel: [4976164.170185]  ffff880225f73968
0000000000000046 ffff880225c42e20 0000000000013180
Oct 15 21:53:14 mojave kernel: [4976164.170188]  ffff880225f73fd8
ffff880225f72010 0000000000013180 0000000000013180
Oct 15 21:53:14 mojave kernel: [4976164.170191]  ffff880225f73fd8
0000000000013180 ffff880225c42e20 ffff88022611dc40
Oct 15 21:53:14 mojave kernel: [4976164.170194] Call Trace:
Oct 15 21:53:14 mojave kernel: [4976164.170204]  [<ffffffff8166a8e9>]
schedule+0x29/0x70
Oct 15 21:53:14 mojave kernel: [4976164.170207]  [<ffffffff8166a9bc>]
io_schedule+0x8c/0xd0
Oct 15 21:53:14 mojave kernel: [4976164.170211]  [<ffffffff8126c5ef>]
__xfs_iflock+0xdf/0x110
Oct 15 21:53:14 mojave kernel: [4976164.170216]  [<ffffffff8106b070>] ?
autoremove_wake_function+0x40/0x40
Oct 15 21:53:14 mojave kernel: [4976164.170219]  [<ffffffff812273b4>]
xfs_reclaim_inode+0xc4/0x330
Oct 15 21:53:14 mojave kernel: [4976164.170222]  [<ffffffff81227816>]
xfs_reclaim_inodes_ag+0x1f6/0x330
Oct 15 21:53:14 mojave kernel: [4976164.170225]  [<ffffffff81227983>]
xfs_reclaim_inodes_nr+0x33/0x40
Oct 15 21:53:14 mojave kernel: [4976164.170228]  [<ffffffff81230085>]
xfs_fs_free_cached_objects+0x15/0x20
Oct 15 21:53:14 mojave kernel: [4976164.170233]  [<ffffffff8117943e>]
prune_super+0x11e/0x1a0
Oct 15 21:53:14 mojave kernel: [4976164.170237]  [<ffffffff8112903f>]
shrink_slab+0x19f/0x2d0
Oct 15 21:53:14 mojave kernel: [4976164.170240]  [<ffffffff8112c3c8>]
kswapd+0x698/0xae0
Oct 15 21:53:14 mojave kernel: [4976164.170243]  [<ffffffff8106b030>] ?
wake_up_bit+0x40/0x40
Oct 15 21:53:14 mojave kernel: [4976164.170246]  [<ffffffff8112bd30>] ?
zone_reclaim+0x410/0x410
Oct 15 21:53:14 mojave kernel: [4976164.170249]  [<ffffffff8106a97e>]
kthread+0xce/0xe0
Oct 15 21:53:14 mojave kernel: [4976164.170252]  [<ffffffff8106a8b0>] ?
kthread_freezable_should_stop+0x70/0x70
Oct 15 21:53:14 mojave kernel: [4976164.170256]  [<ffffffff8167475c>]
ret_from_fork+0x7c/0xb0
Oct 15 21:53:14 mojave kernel: [4976164.170258]  [<ffffffff8106a8b0>] ?
kthread_freezable_should_stop+0x70/0x70

So i decided to unmount the fs and run xfs_repair on it. Unfortunately,
after almost a week, this hasn't finished yet. It seems to do so much
swapping that it hardly makes any progress. Currently it has been in
Phase 6 (traversing filesystem) for several days.

I found a thread suggesting to add an ssd as swap drive, which i did
yesterday. I also added the "-P" option to xfs_repair since it helped in
some cases similar in the past.

I am using the latest xfs_repair version 3.2.4, compiled myself.

The filesystem is 16TB in size and contains about 150 million inodes.
The machine has 8GB of RAM available.

The kernel version at the time of the power loss was 3.10.44 and was
upgraded to 3.10.90 afterwards.

My questions are the following:
- Is there anything else i could try to speed up the progress besides
beefing up the RAM of the machine? Currently it has 8GB which is not
very much for the task i suppose. I read about the "-m" option and about
"-o bhash=" but i am unsure if they could help in this case.
- Are there any rough guidelines on how much RAM is needed for
xfs_repair on a given filesystem? How does it depend on the number of
inodes or on the size of the file system?
- How long could the quota check on mount take when the repair is
finished (the filesystem is mounted with usrquota, grpquota).

thanks in advance,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
