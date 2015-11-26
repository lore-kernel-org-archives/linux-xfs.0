Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FEB97F37
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 04:22:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EE5C30405F
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 02:22:08 -0800 (PST)
Received: from smtpo65.poczta.onet.pl (smtpo33.poczta.onet.pl
	[213.180.142.164]) by cuda.sgi.com with ESMTP id
	N9tBRlMXodoVdHgR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2015 02:22:02 -0800 (PST)
Received: from [192.168.176.22] (host8514118246.static.open-e.3s.pl
	[85.14.118.246]) (Authenticated sender: aluno3@poczta.onet.pl)
	by smtp.poczta.onet.pl (Onet) with ESMTPA id 3p5w9y1ZvFzT1pb5r
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2015 11:21:57 +0100 (CET)
From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Subject: Which xfsprogs version to which kernel version
Message-ID: <5656DD39.8060403@poczta.onet.pl>
Date: Thu, 26 Nov 2015 11:21:45 +0100
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

Hello,

I am using kernel 3.10 and would like to update xfsprogs (currently I
have 3.1.5).

When I tried to use the newest version of xfsprogs 4.3.0 I get the call
trace about detected version 5 of superblock when mounting volume which
was formatted using mkfs.xfs from 4.3.0.

[ 606.853643] XFS (zd32): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
Use of these features in this kernel is at your own risk!
[ 606.853649] XFS (zd32): Superblock has unknown read-only compatible features (0x1) enabled.
[ 606.853651] XFS (zd32): Attempted to mount read-only compatible filesystem read-write.
Filesystem can only be safely mounted read only.
[ 606.853654] ffff880067a71000: 58 46 53 42 00 00 10 00 00 00 00 00 01 90 00 00 XFSB............
[ 606.853657] ffff880067a71010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[ 606.853658] ffff880067a71020: 63 d1 24 9f 21 3d 44 a0 8c 51 5b 4e 31 1a 70 1e c.$.!=D..Q[N1.p.
[ 606.853660] ffff880067a71030: 00 00 00 00 01 00 00 05 00 00 00 00 00 00 00 60 ...............`
[ 606.853663] XFS (zd32): Internal error xfs_sb_read_verify at line 730 of file fs/xfs/xfs_mount.c. Caller 0xffffffff81256c7d

[ 606.853667] CPU: 0 PID: 200 Comm: kworker/0:1H Tainted: P O 3.10.92-oe64-ge331686 #15
[ 606.853668] Hardware name: System manufacturer System Product Name/P5WDG2 WS Pro, BIOS 0905 03/06/2008
[ 606.853675] Workqueue: xfslogd xfs_buf_iodone_work
[ 606.853677] ffffffff81692f75 ffffffff81258c5d ffffffff81256c7d ffffffff818a39e3
[ 606.853680] ffff88005dcab200 0000000000000016 ffff880052c11800 0000000000000200
[ 606.853683] ffff88007ea17800 ffffffff812a32ac ffffffff81256c7d 000000007ea11a40
[ 606.853686] Call Trace:
[ 606.853692] [<ffffffff81692f75>] ? dump_stack+0xc/0x15
[ 606.853695] [<ffffffff81258c5d>] ? xfs_corruption_error+0x8d/0x90
[ 606.853698] [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
[ 606.853703] [<ffffffff812a32ac>] ? xfs_sb_read_verify+0xfc/0x120
[ 606.853705] [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
[ 606.853708] [<ffffffff81256c7d>] ? xfs_buf_iodone_work+0x6d/0x90
[ 606.853712] [<ffffffff8105ce4d>] ? process_one_work+0x13d/0x3b0
[ 606.853715] [<ffffffff8105d7b1>] ? worker_thread+0x121/0x3d0
[ 606.853717] [<ffffffff8105d690>] ? manage_workers.isra.26+0x280/0x280
[ 606.853721] [<ffffffff81062e92>] ? kthread+0xc2/0xd0
[ 606.853725] [<ffffffff81070000>] ? sched_clock_cpu+0x30/0x100
[ 606.853728] [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x110
[ 606.853731] [<ffffffff8169db98>] ? ret_from_fork+0x58/0x90
[ 606.853734] [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x110
[ 606.853736] XFS (zd32): Corruption detected. Unmount and run xfs_repair
[ 606.853742] XFS (zd32): SB validate failed with error 22.

Dave in thread http://oss.sgi.com/archives/xfs/2015-08/msg00528.html
advises to disable crc and finobt:

mkfs.xfs -m crc=0,finobt=0

but it does not work with 4.X version of xfsprogs. Call trace also
occurred so I tried to use 3.2.4 family with crc=0,finobt=0 and volume
mounted successfully.

Dave also noticed:

i.e. if Gentoo are shipping xfsprogs 3.2.4 w/ kernel 3.14.51, then
Gentoo has a quality control problem - they have failed to verify
that the packages they are shipping work correctly before shipping
them to users...


that using 3.2.4 with kernel 3.14.51 is not good idea so are you able to
advise which version of xfsprogs is the best for kernel 3.10? Please
note that update the kernel in my environment is not possible in easy
way so I need to stay with 3.10.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
