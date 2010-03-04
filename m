Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24A9Cc0158306 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 04:09:12 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A839913F39CF
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 02:10:38 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id HdfvpB2JqNtSb80t
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 02:10:38 -0800 (PST)
Received: from cl-840.mbx-01.si.sixxs.net ([2001:15c0:65ff:347::2])
	by firestarter.dermichi.com with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.71)
	(envelope-from <mw@dermichi.com>) id 1Nn80q-0002So-Kn
	for xfs@oss.sgi.com; Thu, 04 Mar 2010 11:10:36 +0100
Message-ID: <4B8F871C.60802@dermichi.com>
Date: Thu, 04 Mar 2010 11:10:36 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: XFS hang during xfs_fsr run
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi XFS-List!
We recently had two hangs on one of our servers, which seem to be 
related to XFS. We managed to capture the dmesg output before 
hard-resetting the machine. It seems that those hangs are caused by 
xfs_fsr which was running at that time. This is a mail server with 
millions of files. The underlying file system was already checked with 
xfs_repair without finding errors.
Is there anything i could try to rectify or at least narrow down this 
problem?

******** Trace 1 start ********
[169342.414517] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018
[169342.414646] IP: [<ffffffff811abd75>] 0xffffffff811abd75
[169342.414651] PGD 26fba0067 PUD 2935aa067 PMD 0
[169342.414655] Oops: 0000 [#1] SMP
[169342.414658] last sysfs file: 
/sys/devices/pci0000:00/0000:00:02.0/0000:06:00.0/0000:07:00.0/0000:08:00.0/0000:09:00.0/irq
[169342.414663] CPU 2
[169342.414668] Pid: 23782, comm: xfs_fsr Not tainted 2.6.33 #1 
0JR815/PowerEdge 2950
[169342.414671] RIP: 0010:[<ffffffff811abd75>]  [<ffffffff811abd75>] 
0xffffffff811abd75
[169342.414675] RSP: 0018:ffff88001eb2db78  EFLAGS: 00010296
[169342.414678] RAX: 0000000000000008 RBX: ffff880044c46bc0 RCX: 
ffff88001eb2dd54
[169342.414681] RDX: 0000000000000005 RSI: 0000000000000000 RDI: 
ffff880044c46bc0
[169342.414684] RBP: ffff88001eb2dba8 R08: 0000000000000000 R09: 
ffff88032fb3ec00
[169342.414687] R10: ffff88001eb2d9e8 R11: ffffffff811eebc1 R12: 
ffff88008d17a400
[169342.414690] R13: 0000000000000005 R14: 0000000000000000 R15: 
ffff88008d17a438
[169342.414694] FS:  00007f760bcd66f0(0000) GS:ffff880028280000(0000) 
knlGS:0000000000000000
[169342.414697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[169342.414700] CR2: 0000000000000018 CR3: 000000029347c000 CR4: 
00000000000006e0
[169342.414703] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[169342.414706] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[169342.414709] Process xfs_fsr (pid: 23782, threadinfo 
ffff88001eb2c000, task ffff88032de43cc0)
[169342.414711] Stack:
[169342.414713]  ffff88001eb2dba8 ffffffff811abc98 ffff88008d17a400 
0000000000000000
[169342.414717] <0> ffff88008d17a400 ffffffffffffffff ffff88001eb2dce8 
ffffffff8117ec2c
[169342.414721] <0> ffff88001eb2dca8 0000000000000000 ffff880100000000 
ffff880300000000
[169342.414726] Call Trace:
[169342.414731]  [<ffffffff811abc98>] ? 0xffffffff811abc98
[169342.414734]  [<ffffffff8117ec2c>] 0xffffffff8117ec2c
[169342.414738]  [<ffffffff81198b2b>] 0xffffffff81198b2b
[169342.414741]  [<ffffffff811af419>] 0xffffffff811af419
[169342.414743]  [<ffffffff813629e8>] ? 0xffffffff813629e8
[169342.414746]  [<ffffffff811b976e>] 0xffffffff811b976e
[169342.414749]  [<ffffffff810dd9ea>] 0xffffffff810dd9ea
[169342.414751]  [<ffffffff810de158>] 0xffffffff810de158
[169342.414754]  [<ffffffff810de1e4>] 0xffffffff810de1e4
[169342.414757]  [<ffffffff810dd22e>] 0xffffffff810dd22e
[169342.414759]  [<ffffffff810da685>] 0xffffffff810da685
[169342.414762]  [<ffffffff810da76f>] 0xffffffff810da76f
[169342.414765]  [<ffffffff810daebf>] 0xffffffff810daebf
[169342.414767]  [<ffffffff810cc1b6>] 0xffffffff810cc1b6
[169342.414770]  [<ffffffff810cc1f3>] 0xffffffff810cc1f3
[169342.414773]  [<ffffffff810c9396>] 0xffffffff810c9396
[169342.414775]  [<ffffffff810c943a>] 0xffffffff810c943a
[169342.414778]  [<ffffffff810029ab>] 0xffffffff810029ab
[169342.414780] Code: 89 c4 85 c0 75 13 48 85 db 74 0e 44 89 ea 49 8b 36 
48 89 df e8 5f ff ff ff 5a 44 89 e0 59 5b 41 5c 41 5d 41 5e c9 c3 90 90 
90 55 <48> 8b 46 18 48 89 e5 c9 c3 55 31 ff 8a 56 0b 48 89 e5 0f b6 c2
[169342.414805] RIP  [<ffffffff811abd75>] 0xffffffff811abd75
[169342.414808]  RSP <ffff88001eb2db78>
[169342.414810] CR2: 0000000000000018
[169342.414813] ---[ end trace 5e5d73a1b2a79389 ]---
[169434.738237] ------------[ cut here ]------------
[169434.738315] kernel BUG at fs/xfs/xfs_iget.c:295!
[169434.738387] invalid opcode: 0000 [#2] SMP
[169434.738553] last sysfs file: 
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[169434.738644] CPU 2
[169434.738761] Pid: 23899, comm: mktemp Tainted: G      D    2.6.33 #1 
0JR815/PowerEdge 2950
[169434.738854] RIP: 0010:[<ffffffff81196309>]  [<ffffffff81196309>] 
0xffffffff81196309
[169434.738994] RSP: 0018:ffff88014ac5da18  EFLAGS: 00010246
[169434.739068] RAX: 0000000000000000 RBX: ffff880044c46260 RCX: 
ffffffff811f2d94
[169434.739127] RDX: 0000000000000000 RSI: 0000000000000202 RDI: 
ffff88008d17a4e4
[169434.739127] RBP: ffff88014ac5dab8 R08: ffff88002828fe10 R09: 
ffff88014ac5d8e8
[169434.739127] R10: ffff88014ac5d948 R11: ffff88008d17a458 R12: 
ffff88008d17a458
[169434.739127] R13: 0000000000000002 R14: ffff88032dac6ba8 R15: 
0000000000000017
[169434.739127] FS:  00007fc88a5266f0(0000) GS:ffff880028280000(0000) 
knlGS:0000000000000000
[169434.739127] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
******** Trace 1 end ********

******** Trace 2 start ********
[40146.682000] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018
[40146.682192] IP: [<ffffffff811abd75>] 0xffffffff811abd75
[40146.682314] PGD 236381067 PUD 2883d3067 PMD 0
[40146.682528] Oops: 0000 [#1] SMP
[40146.682692] last sysfs file: 
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[40146.682784] CPU 3
[40146.682901] Pid: 19417, comm: xfs_fsr Not tainted 2.6.33 #1 
0JR815/PowerEdge 2950
[40146.682901] RIP: 0010:[<ffffffff811abd75>]  [<ffffffff811abd75>] 
0xffffffff811abd75
[40146.682901] RSP: 0018:ffff88025c721b78  EFLAGS: 00010296
[40146.682901] RAX: 0000000000000008 RBX: ffff8802686d4320 RCX: 
ffff88025c721d54
[40146.682901] RDX: 0000000000000005 RSI: 0000000000000000 RDI: 
ffff8802686d4320
[40146.682901] RBP: ffff88025c721ba8 R08: 000000000000007c R09: 
ffff88032fb1ac00
[40146.682901] R10: ffff88025c721a28 R11: 0000000000000296 R12: 
ffff88022ac2c400
[40146.682901] R13: 0000000000000005 R14: 0000000000000000 R15: 
ffff88022ac2c438
[40146.682901] FS:  00007f5a735786f0(0000) GS:ffff8800282c0000(0000) 
knlGS:0000000000000000
[40146.682901] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40146.682901] CR2: 0000000000000018 CR3: 000000029b82e000 CR4: 
00000000000006e0
[40146.682901] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[40146.682901] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[40146.682901] Process xfs_fsr (pid: 19417, threadinfo ffff88025c720000, 
task ffff88032d2b0000)
[40146.682901] Stack:
[40146.682901]  ffff88025c721ba8 ffffffff811abc98 ffff88022ac2c400 
0000000000000000
[40146.682901] <0> ffff88022ac2c400 ffffffffffffffff ffff88025c721ce8 
ffffffff8117ec2c
[40146.682901] <0> ffff88025c721ca8 0000000000000000 ffff880200000000 
0000000700000000
[40146.682901] Call Trace:
[40146.682901]  [<ffffffff811abc98>] ? 0xffffffff811abc98
[40146.682901]  [<ffffffff8117ec2c>] 0xffffffff8117ec2c
[40146.682901]  [<ffffffff81198b2b>] 0xffffffff81198b2b
[40146.682901]  [<ffffffff811af419>] 0xffffffff811af419
[40146.682901]  [<ffffffff813629e8>] ? 0xffffffff813629e8
[40146.682901]  [<ffffffff811b976e>] 0xffffffff811b976e
[40146.682901]  [<ffffffff810dd9ea>] 0xffffffff810dd9ea
[40146.682901]  [<ffffffff810de158>] 0xffffffff810de158
[40146.682901]  [<ffffffff810de1e4>] 0xffffffff810de1e4
[40146.682901]  [<ffffffff810dd22e>] 0xffffffff810dd22e
[40146.682901]  [<ffffffff810da685>] 0xffffffff810da685
[40146.682901]  [<ffffffff810da76f>] 0xffffffff810da76f
[40146.682901]  [<ffffffff810daebf>] 0xffffffff810daebf
[40146.682901]  [<ffffffff810cc1b6>] 0xffffffff810cc1b6
[40146.682901]  [<ffffffff810cc1f3>] 0xffffffff810cc1f3
[40146.682901]  [<ffffffff810c9396>] 0xffffffff810c9396
[40146.682901]  [<ffffffff810c943a>] 0xffffffff810c943a
[40146.682901]  [<ffffffff810029ab>] 0xffffffff810029ab
[40146.682901] Code: 89 c4 85 c0 75 13 48 85 db 74 0e 44 89 ea 49 8b 36 
48 89 df e8 5f ff ff ff 5a 44 89 e0 59 5b 41 5c 41 5d 41 5e c9 c3 90 90 
90 55 <48> 8b 46 18 48 89 e5 c9 c3 55 31 ff 8a 56 0b 48 89 e5 0f b6 c2
[40146.682901] RIP  [<ffffffff811abd75>] 0xffffffff811abd75
[40146.682901]  RSP <ffff88025c721b78>
[40146.682901] CR2: 0000000000000018
[40146.689961] ---[ end trace 53b9544a53a60243 ]---
******** Trace 2 end ********

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
