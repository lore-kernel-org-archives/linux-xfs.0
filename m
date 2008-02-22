Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Feb 2008 05:11:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1MDBB4h025204
	for <linux-xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:11:12 -0800
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0E22606F9E
	for <linux-xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:11:36 -0800 (PST)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.238]) by cuda.sgi.com with ESMTP id 46sUHlCJxpcOyKvd for <linux-xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:11:36 -0800 (PST)
Received: by wr-out-0506.google.com with SMTP id 50so740498wra.18
        for <linux-xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:11:36 -0800 (PST)
Message-ID: <5d96567b0802220511y72c04e21ve8508d1754cf8dfe@mail.gmail.com>
Date: Fri, 22 Feb 2008 15:11:35 +0200
From: Raz <raziebe@gmail.com>
Subject: Is the bellow panic is a XFS bug ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I am getting a kernel panic( see (1). What i do is streaming ( IO reading
) and ingesting ( IO writing ) at the same time to and from an XFS file
system.
The streaming is done by a video server and ingesting is done
by a FTP server. I am streaming 2 Gbps and ingesting 150 Mbs.
for xfs_info  see (2) . is it over raid50 ( see (3) ).  machine is
TYAN dual core with 2 processors ,Opteron. RAM is 4 GRAM.
see (4) and (5).
Is it an XFS bug ?


(1)

 [ 6392.736526] general protection fault: 0000 [1] PREEMPT SMP

[ 6392.747775] last sysfs file: /devices/platform/i2c-9191/9191-0290/temp2_input

[ 6392.762044] CPU 0

[ 6392.766103] Modules linked in: streamer bonding e1000 tg3 lm85
i2c_dev raid456 xor raid0 w83627hf hwmon_vid i2c_isa sunrpc xfs e100
i2c_nforce2 sata_nv i2c_core libata eepro100 stex raid1

[ 6392.800251] Pid: 255, comm: kswapd0 Not tainted 2.6.18-8-opteron #1

[ 6392.812789] RIP: 0010:[<ffffffff880df4f0>]  [<ffffffff880df4f0>]
:xfs:xfs_count_page_state+0x30/0x90

[ 6392.831114] RSP: 0018:ffff81013fed3b28  EFLAGS: 00010216

[ 6392.841737] RAX: 000000007839a106 RBX: ffff8100015230b0 RCX: ffff81013fed3b74

[ 6392.856000] RDX: ffff81013fed3b78 RSI: ffff81013fed3b7c RDI: ffff81001c0e2190

[ 6392.870257] RBP: ffff8100015230d8 R08: b8e5a8a4024c259b R09: 0000000000000000

[ 6392.884515] R10: 000000000000000b R11: ffffffff880e0a00 R12: 00000000000000d0

[ 6392.898776] R13: ffff81000e0540b0 R14: ffff81013fed3d80 R15: ffff81000e0541d8

[ 6392.913034] FS:  0000000040e22940(0000) GS:ffffffff8038b000(0000)
knlGS:00000000f7ff56c0

[ 6392.929212] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b

[ 6392.940699] CR2: 00002aab8643d000 CR3: 0000000000201000 CR4: 00000000000006e0

[ 6392.954962] Process kswapd0 (pid: 255, threadinfo ffff81013fed2000,
task ffff81013f592300)

[ 6392.971485] Stack:  ffffffff880e0a62 0000000000000000
0000000000000001 0000000000000000

[ 6392.987657]  0000000000000001 0000000000000000 0000000000000000
0000000000000000

[ 6393.002592]  0000000000000000 00000000015d1898 0000000000000000
ffff8100015230d8

[ 6393.017129] Call Trace:

[ 6393.022435]  [<ffffffff880e0a62>] :xfs:xfs_vm_releasepage+0x62/0xd0

[ 6393.034972]  [<ffffffff80072f1d>] shrink_inactive_list+0x52d/0x8e0

[ 6393.047347]  [<ffffffff800733b4>] shrink_zone+0xe4/0x110

[ 6393.057974]  [<ffffffff80073a23>] kswapd+0x393/0x4f0

[ 6393.067902]  [<ffffffff8004cca0>] autoremove_wake_function+0x0/0x30

[ 6393.080431]  [<ffffffff8004c820>] keventd_create_kthread+0x0/0x70

[ 6393.092608]  [<ffffffff80073690>] kswapd+0x0/0x4f0

[ 6393.102185]  [<ffffffff8004c820>] keventd_create_kthread+0x0/0x70

[ 6393.114368]  [<ffffffff8004c969>] kthread+0xd9/0x120

[ 6393.124293]  [<ffffffff80030fb0>] schedule_tail+0x40/0xc0

[ 6393.135089]  [<ffffffff8000aeb1>] child_rip+0xa/0x11

[ 6393.145015]  [<ffffffff8004c820>] keventd_create_kthread+0x0/0x70

[ 6393.157198]  [<ffffffff8004c890>] kthread+0x0/0x120

[ 6393.166948]  [<ffffffff8000aea7>] child_rip+0x0/0x11

[ 6393.176873]

[ 6393.179863]

[ 6393.179864] Code: 41 8b 00 a8 01 74 0f 41 8b 00 a8 20 75 08 c7 02
01 00 00 00

[ 6393.198036] RIP  [<ffffffff880df4f0>] :xfs:xfs_count_page_state+0x30/0x90

[ 6393.211662]  RSP <ffff81013fed3b28>

[ 6393.218783]  <0>Kernel panic - not syncing: Fatal exception

[ 6393.248171]  <0>Rebooting in 1000 seconds..

(2)
meta-data=/dev/md7               isize=256    agcount=33, agsize=76991488 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2463773696, imaxpct=25
         =                       sunit=3584   swidth=3584 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32256, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=2097152 blocks=0, rtextents=0

(3)
md8 : active raid1 md2[0] md3[1]
      225037760 blocks [2/2] [UU]

md7 : active raid0 md4[0] md5[1]
      9855094784 blocks 1024k chunks

md6 : active raid1 md0[0] md1[1]
      4047296 blocks [2/2] [UU]

md5 : active raid5 sdi3[0] sdp3[7] sdo3[6] sdn3[5] sdm3[4] sdl3[3]
sdk3[2] sdj3[1]
      4927548416 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]

md4 : active raid5 sda3[0] sdc3[7] sdh3[6] sdg3[5] sdf3[4] sde3[3]
sdd3[2] sdb3[1]
      4927548416 blocks level 5, 1024k chunk, algorithm 2 [8/8] [UUUUUUUU]

md3 : active raid0 sdi2[0] sdp2[7] sdo2[6] sdn2[5] sdm2[4] sdl2[3]
sdk2[2] sdj2[1]
      225037824 blocks 64k chunks

md2 : active raid0 sda2[0] sdh2[7] sdg2[6] sdf2[5] sde2[4] sdd2[3]
sdc2[2] sdb2[1]
      225037824 blocks 64k chunks

md1 : active raid0 sdi1[0] sdp1[7] sdo1[6] sdn1[5] sdm1[4] sdl1[3]
sdk1[2] sdj1[1]
      4047360 blocks 4k chunks

md0 : active raid0 sda1[0] sdc1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3]
sdd1[2] sdb1[1]
      4047360 blocks 4k chunks

(4)
MemTotal:      4045220 kB
MemFree:        411260 kB
Buffers:         17900 kB
Cached:         131156 kB
SwapCached:          0 kB
Active:        3492900 kB
Inactive:        55592 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:      4045220 kB
LowFree:        411260 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              16 kB
Writeback:           0 kB
AnonPages:     3399588 kB
Mapped:          33404 kB
Slab:            34332 kB
PageTables:       9240 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2022608 kB
Committed_AS:  3446400 kB
VmallocTotal: 34359738367 kB
VmallocUsed:      2988 kB
VmallocChunk: 34359734419 kB

(5)  Dual Core AMD Opteron(tm) Processor 265


-- 
Raz
