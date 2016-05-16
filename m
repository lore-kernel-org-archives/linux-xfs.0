Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F13717CA7
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 10:04:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6F288F8054
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 08:04:34 -0700 (PDT)
Received: from mx0b-00196b01.pphosted.com (mx0b-00196b01.pphosted.com
	[67.231.157.166]) by cuda.sgi.com with ESMTP id
	tb7bW0fuf2T84r40 (version=TLSv1.2 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 May 2016 08:04:32 -0700 (PDT)
Received: from pps.filterd (m0072399.ppops.net [127.0.0.1])
	by mx0b-00196b01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id
	u4GF17Kf024787 for <xfs@oss.sgi.com>; Mon, 16 May 2016 11:04:31 -0400
Received: from plnomx1.netscout.com ([199.171.210.10])
	by mx0b-00196b01.pphosted.com with ESMTP id 22y9ua8d38-1
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Mon, 16 May 2016 11:04:30 -0400
From: "Rich, Jason" <Jason.Rich@netscout.com>
Subject: XFS kernel bug 3.16.7 assertion failed xfs_log_cil.c
Date: Mon, 16 May 2016 15:04:28 +0000
Message-ID: <ABDC3A0B513405428FC59C79FA0404073636E868@PLNOMB1.netscout.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Gents,

I've been seeing some very strange lockups on XFS recently in our deploymen=
t and I'm looking for some help directing me to either a workaround or solu=
tion.  =

When I say 'lockup':  the process that is trying to do I/O to the XFS volum=
e appears to be hung.  I have not had a chance to play with a system in thi=
s state yet, as the person who identified the issue just rebooted the machi=
ne instead of attempting to diagnose further.  So I'm not sure of the actua=
l process state when this occurs.

A little background on the environment first:
- We deploy a product running kernel 3.16.7 (debian 8's kernel), xfsprogs 4=
.3.0, and large storage arrays (40Tb x 14 raid volumes). =

- We have large data (PB) and high throughput (2+ GB/sec) using async IO to=
 several large volumes. =

- I think it is important to note that these servers (Dell R720s & R730s) a=
re actually net-booting and tend to be ungracefully power cycled at any tim=
e which we try to mitigate at all costs.  That said, the systems seem to ru=
n fine for days before hitting this issue.
- The below error occurred on two different machines about 1 day apart.  I =
only copy/pasted one of them here.  The system was recovered via reboot so =
I don't have all the debugging you might hope for.
- The volumes are configured in a raid 6 using NLSAS drives with 128k chunk=
 size.

The error:
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.788188] XFS: Assertion faile=
d: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 666
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.799247] ------------[ cut he=
re ]------------
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.804862] kernel BUG at fs/xfs=
/xfs_message.c:107!
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.810773] invalid opcode: 0000=
 [#1] PREEMPT SMP
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.816603] Modules linked in: m=
st_pciconf(O) mst_pci(O) tun ib_uverbs(O) fuse xfs libcrc32c mptctl mptbase=
 ipmi_poweroff mlx4_ib(O) mlx4_en(O) dm_round_robin ib_sa(O) ib_mad(O) ib_c=
ore(O) ib_addr(O) mlx4_core(O) mlx_compat(O) mpt2sas(O) ahci megaraid_sas l=
ibahci scsi_transport_sas bridge stp llc bonding igb(O) ptp pps_core usb_st=
orage dm_multipath dm_mod edd ipmi_devintf ipmi_si ipmi_msghandler
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.858837] CPU: 6 PID: 59124 Co=
mm: pio_writer_12 Tainted: G           O  3.16.7.TEK.V7.16.1.0.1b11 #1
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.870142] Hardware name: NETSC=
OUT SSU2000/04N3DF, BIOS 1.3.6 06/03/2015
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.878156] task: ffff882dd397e0=
00 ti: ffff882db3e50000 task.ti: ffff882db3e50000
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.887471] RIP: 0010:[<ffffffff=
a0497f56>]  [<ffffffffa0497f56>] assfail+0x22/0x28 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.897461] RSP: 0018:ffff882db3=
e53b38  EFLAGS: 00010292
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.903806] RAX: 000000000000005=
7 RBX: ffff883e1c7c9e00 RCX: 0000000000000000
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.912227] RDX: ffff882db3e5397=
8 RSI: ffff88407eece1c8 RDI: 0000000000000246
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.920659] RBP: ffff882db3e53b3=
8 R08: 0000000000000000 R09: 0000000000000cc7
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.929032] R10: 000000000000000=
0 R11: 0000000000000005 R12: ffff883ef69bd800
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.937439] R13: ffff883f768bea4=
0 R14: ffff883f768bea00 R15: ffff882db3e53ba0
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.945858] FS:  00007fffdec5170=
0(0000) GS:ffff88407eec0000(0000) knlGS:0000000000000000
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.955775] CS:  0010 DS: 0000 E=
S: 0000 CR0: 0000000080050033
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.962609] CR2: 000000001d59300=
0 CR3: 0000003f7cac3000 CR4: 00000000001407e0
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.971003] Stack:
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.973679]  ffff882db3e53b88 ff=
ffffffa04ea310 00000000b3e53b88 ffff883f768bea00
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.982930]  ffff883d3556b920 ff=
ff883e1c7c9e00 0000000000000041 ffff8840608be000
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4123.992164]  0000000000000000 00=
00000000000000 ffff882db3e53bd8 ffffffffa049ef7b
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.001348] Call Trace:
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.004576]  [<ffffffffa04ea310>=
] xfs_log_commit_cil+0xcd/0x145 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.012232]  [<ffffffffa049ef7b>=
] xfs_trans_commit+0xc3/0x1fd [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.019669]  [<ffffffffa0496bba>=
] xfs_vn_update_time+0x16f/0x181 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.027427]  [<ffffffff8114711c>=
] update_time+0x25/0xac
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.033763]  [<ffffffffa047e19a>=
] ? ftrace_raw_event_xfs_lock_class+0x64/0x73 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.043270]  [<ffffffff81147230>=
] file_update_time+0x8d/0xb0
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.050011]  [<ffffffffa048c441>=
] ? xfs_rw_ilock+0x2c/0x33 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.057178]  [<ffffffffa048c940>=
] xfs_file_aio_write_checks+0xae/0xcf [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.065414]  [<ffffffffa048ca9d>=
] xfs_file_dio_aio_write+0x116/0x270 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.073593]  [<ffffffffa048dae7>=
] ? xfs_file_buffered_aio_write+0x176/0x176 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.082804]  [<ffffffffa048db61>=
] xfs_file_write_iter+0x7a/0x105 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.090579]  [<ffffffff8116ac40>=
] aio_run_iocb+0x1dc/0x2dd
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.097151]  [<ffffffff8116af02>=
] io_submit_one+0x1c1/0x201
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.103812]  [<ffffffff8116b02c>=
] do_io_submit+0xea/0x13f
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.110326]  [<ffffffff8116b091>=
] SyS_io_submit+0x10/0x12
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.116775]  [<ffffffff815de6e9>=
] system_call_fastpath+0x16/0x1b
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.123899] Code: 45 c8 e8 4a fc=
 ff ff c9 c3 55 48 89 e5 0f 1f 44 00 00 31 c0 48 89 f1 41 89 d0 48 c7 c6 89=
 84 50 a0 48 89 fa 31 ff e8 89 ff ff ff <0f> 0b eb fe 90 90 55 48 89 e5 53 =
0f 1f 44 00 00 48 8b 8f c0 02
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.147242] RIP  [<ffffffffa0497=
f56>] assfail+0x22/0x28 [xfs]
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.154142]  RSP <ffff882db3e53b=
38>
2016 May 13 18:51:30 g512-ssu-1 kernel: [ 4124.161239] ---[ end trace dbd3b=
ab9608b5697 ]---

2016 May 14 17:31:17 g512-ssu-2 kernel: [85687.891368] XFS: Assertion faile=
d: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 666   <--- =
appropriate line number
2016 May 14 17:31:17 g512-ssu-2 kernel: [85687.902402] ------------[ cut he=
re ]------------

HOST INFO:
Proc info:
processor	: 47
vendor_id	: GenuineIntel
cpu family	: 6
model		: 63
model name	: Intel(R) Xeon(R) CPU E5-2658 v3 @ 2.20GHz

Meminfo:
root@g512-ssu2000-2: ~ # cat /proc/meminfo
MemTotal:       264516692 kB
MemFree:        181040604 kB
MemAvailable:   200066392 kB
Buffers:              32 kB
Cached:          3722024 kB
SwapCached:            0 kB
Active:         31687480 kB
Inactive:        3307212 kB
Active(anon):   31300740 kB
Inactive(anon):  2534776 kB
Active(file):     386740 kB
Inactive(file):   772436 kB
Unevictable:        5188 kB
Mlocked:            5188 kB
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:                 0 kB
Writeback:             0 kB
AnonPages:      31303028 kB
Mapped:          2647080 kB
Shmem:           2535460 kB
Slab:           19452480 kB
SReclaimable:   18120028 kB
SUnreclaim:      1332452 kB
KernelStack:       20704 kB
PageTables:        83504 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    125966888 kB
Committed_AS:   42757972 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     1263588 kB
VmallocChunk:   34358261760 kB
AnonHugePages:  28125184 kB
HugePages_Total:    6144
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       12080 kB
DirectMap2M:     1986560 kB
DirectMap1G:    268435456 kB

root@g512-ssu2000-2: ~ # cat /proc/mounts
rootfs / rootfs rw,size=3D132244472k,nr_inodes=3D33061118 0 0
mbc:/iris/opt/TEKplat/V7.16.1.0.1b11/x86_64_root / nfs ro,noatime,vers=3D3,=
rsize=3D4096,wsize=3D4096,namlen=3D255,acregmin=3D300,acregmax=3D300,acdirm=
in=3D300,acdirmax=3D300,hard,nolock,proto=3Dudp,port=3D200
none /mnt tmpfs rw,relatime 0 0
dev /dev tmpfs rw,relatime,size=3D10240k 0 0
none /tmp tmpfs rw,relatime 0 0
proc /proc proc rw,relatime 0 0
sys /sys sysfs rw,relatime 0 0
none /local-blade tmpfs rw,relatime 0 0
mbc:/iris /iris nfs ro,noatime,vers=3D3,rsize=3D4096,wsize=3D4096,namlen=3D=
255,acregmin=3D300,acregmax=3D300,acdirmin=3D300,acdirmax=3D300,hard,nolock=
,proto=3Dudp,port=3D2049,timeo=3D7,retrans=3D3,sec=3Dsys,local_0
none /mnt/initramfs tmpfs rw,relatime 0 0
tmpfs /lib/init/rw tmpfs rw,nosuid,relatime,mode=3D755 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
devpts /dev/pts devpts rw,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
tek.iris.mbc:/iris/scratch /local-blade/scratch nfs rw,relatime,vers=3D3,rs=
ize=3D1048576,wsize=3D1048576,namlen=3D255,soft,nolock,proto=3Dtcp,timeo=3D=
5,retrans=3D2,sec=3Dsys,mountaddr=3D192.168.0.1,mountve0
/dev/mapper/tek_ssu_sdb-SCRATCH /mnt/scratch xfs rw,relatime,attr2,inode64,=
noquota 0 0
none /proc/sys/fs/binfmt_misc binfmt_misc rw,relatime 0 0
nodev /local-blade/hugepages hugetlbfs rw,relatime,mode=3D1770,gid=3D1000,s=
ize=3D12G 0 0
/dev/mapper/3600c0ff0001deaddd676a45501000000 /mnt/storage07 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deaddc378a45501000000 /mnt/storage11 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf727774a45501000000 /mnt/storage02 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deadde175a45501000000 /mnt/storage05 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf723b7aa45501000000 /mnt/storage14 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf724878a45501000000 /mnt/storage10 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deaddfe73a45501000000 /mnt/storage01 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf724279a45501000000 /mnt/storage12 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deaddbd79a45501000000 /mnt/storage13 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf726875a45501000000 /mnt/storage04 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deaddcb77a45501000000 /mnt/storage09 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deadd9a73a45501000000 /mnt/index01 xfs rw,noatime,n=
odiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D1280=
,noquota 0 0
/dev/mapper/3600c0ff0001dcf72cd73a45501000000 /mnt/index02 xfs rw,noatime,n=
odiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D1280=
,noquota 0 0
/dev/mapper/3600c0ff0001dcf725c76a45501000000 /mnt/storage06 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001dcf724f77a45501000000 /mnt/storage08 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0
/dev/mapper/3600c0ff0001deaddee74a45501000000 /mnt/storage03 xfs rw,noatime=
,nodiratime,attr2,nobarrier,inode64,logbsize=3D128k,sunit=3D256,swidth=3D30=
72,noquota 0 0


I am not sure how to effectively reproduce the issue (and to be frank, am f=
ar from being knowledgable about the innerds of XFS) and would like to unde=
rstand the essence of the problem here.  While that rarely leads to root ca=
use, knowing what the failure is trying to tell me would be nice.

Jason Rich =A0|=A0 Senior Platform Engineer
NETSCOUT
O: 469.330.3678 =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
