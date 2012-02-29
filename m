Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1TIKTUe037715 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 12:20:30 -0600
Received: from mx0.pronet.com.pl (mx0.pronet.com.pl [193.108.35.26]) by
	cuda.sgi.com with ESMTP id ZciSN8TvNY2gf5og for
	<xfs@oss.sgi.com>; Wed, 29 Feb 2012 10:20:27 -0800 (PST)
Received: from user115-194.centrum.gliwice.pl ([188.123.194.115]:48964
	helo=[10.53.14.101])
	by smtp.pronet.com.pl with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim) (envelope-from <kupson@kupson.net>) id 1S2o8X-00088y-Fi
	for xfs@oss.sgi.com; Wed, 29 Feb 2012 19:20:25 +0100
Subject: XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file:
	fs/xfs/xfs_buf.c, line: 598
From: =?UTF-8?Q?Rafa=C5=82?= Kupka <kupson@kupson.net>
Date: Wed, 29 Feb 2012 19:20:26 +0100
Message-ID: <1330539626.7615.73.camel@utemp.mieszkanie>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

Hello,

Spotted on two different machines (one is a KVM guest) during xfs_dump
and some filesystem load.

I can reproduce it by doing
while : ; do xfsdump -f /dev/null -l0 -p1 -J -L "test" -M "test" /; done
simultaneously with some postmark benchmarks (any read/write load would
trigger it).
 
Bad kernels:
deb 3.2.4-1~bpo60+1 Debian/squeeze with backports
linus git tree - 164974a8f2a482f1abcb027c6d1a89dd79b14297 (post v3.3-rc5)

Good kernel:
2.6.32 (deb ver 2.6.32-41) Debian/squeeze (both amd64/i686)
linus git tree - v2.6.38

Backtrace (from kernel 164974a8f2a482f1abcb027c6d1a89dd79b14297):
Feb 29 17:01:37 goscie kernel: [  265.409709] XFS: Assertion failed: bp->b_bn != XFS_BUF_DADDR_NULL, file: fs/xfs/xfs_buf.c, line: 598
Feb 29 17:01:37 goscie kernel: [  265.410412] ------------[ cut here ]------------
Feb 29 17:01:37 goscie kernel: [  265.410749] kernel BUG at fs/xfs/xfs_message.c:101!
Feb 29 17:01:37 goscie kernel: [  265.411124] invalid opcode: 0000 [#1] SMP 
Feb 29 17:01:37 goscie kernel: [  265.411535] CPU 0 
Feb 29 17:01:37 goscie kernel: [  265.411625] Modules linked in: loop processor i2c_piix4 button i2c_core psmouse serio_raw tpm_tis tpm tpm_bios evdev pcspkr thermal_sys xfs sg ata_generic ata_piix libata scsi_mod virtio_net [last unloaded: scsi_wait_scan]
Feb 29 17:01:37 goscie kernel: [  265.412034] 
Feb 29 17:01:37 goscie kernel: [  265.412034] Pid: 1465, comm: xfsdump Not tainted 3.3.0-rc5xfsdump1+ #1 Bochs Bochs
Feb 29 17:01:37 goscie kernel: [  265.412034] RIP: 0010:[<ffffffffa00913aa>]  [<ffffffffa00913aa>] assfail+0x1d/0x23 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034] RSP: 0018:ffff880009ee5938  EFLAGS: 00010296
Feb 29 17:01:37 goscie kernel: [  265.412034] RAX: 000000000000006e RBX: ffff8800063ec980 RCX: 00000000099b099b
Feb 29 17:01:37 goscie kernel: [  265.412034] RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000246
Feb 29 17:01:37 goscie kernel: [  265.412034] RBP: 0000000000028001 R08: 0000000000000000 R09: ffff88001780d000
Feb 29 17:01:37 goscie kernel: [  265.412034] R10: 0000000000000000 R11: ffff88001780d000 R12: 0000000000000000
Feb 29 17:01:37 goscie kernel: [  265.412034] R13: ffffffffa00dff34 R14: ffff880009ee5a10 R15: ffff88001202b980
Feb 29 17:01:37 goscie kernel: [  265.412034] FS:  0000000000000000(0000) GS:ffff880017c00000(0063) knlGS:00000000f7639700
Feb 29 17:01:37 goscie kernel: [  265.412034] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Feb 29 17:01:37 goscie kernel: [  265.412034] CR2: 00000000f73a5000 CR3: 0000000014724000 CR4: 00000000000006f0
Feb 29 17:01:37 goscie kernel: [  265.412034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Feb 29 17:01:37 goscie kernel: [  265.412034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 29 17:01:37 goscie kernel: [  265.412034] Process xfsdump (pid: 1465, threadinfo ffff880009ee4000, task ffff88000329f120)
Feb 29 17:01:37 goscie kernel: [  265.412034] Stack:
Feb 29 17:01:37 goscie kernel: [  265.412034]  0000000000028001 ffffffffa0085a82 0000000000008000 ffff8800063ec980
Feb 29 17:01:37 goscie kernel: [  265.412034]  0000000000028001 ffffffffa00860d6 0000025c00000000 0000000000000000
Feb 29 17:01:37 goscie kernel: [  265.412034]  ffff880012084800 0000000000000000 0000000000008000 ffffffffa00dff34
Feb 29 17:01:37 goscie kernel: [  265.412034] Call Trace:
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa0085a82>] ? _xfs_buf_read+0x4b/0x86 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00860d6>] ? xfs_buf_read+0x8a/0xc0 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00dff34>] ? xfs_trans_read_buf+0x4b/0x537 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00cab65>] ? xfs_imap_to_bp+0x47/0x209 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00ccdf3>] ? xfs_iread+0x59/0x194 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa008ba2a>] ? xfs_iget+0x408/0x5ea [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa0099015>] ? kmem_zone_zalloc+0x13/0x2e [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa0090c2b>] ? xfs_bulkstat_one_int+0x9a/0x319 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00eafec>] ? xfs_bstime_store_compat+0x4d/0x4d [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00eb790>] ? xfs_bulkstat_one_compat+0x17/0x1c [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00909e0>] ? xfs_bulkstat+0x58c/0x73d [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00eb779>] ? xfs_compat_fssetdm_by_handle+0xc7/0xc7 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00ebc99>] ? xfs_compat_ioc_bulkstat+0x162/0x1cf [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00ec0b2>] ? xfs_file_compat_ioctl+0x3ac/0x486 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa00a7981>] ? xfs_bmapi_read+0x1ad/0x31a [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa0088d5f>] ? xfs_file_aio_read+0x24c/0x263 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa008b323>] ? xfs_iunlock+0xea/0x146 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffffa009600b>] ? xfs_free_eofblocks+0xa5/0x217 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffff81142259>] ? compat_sys_ioctl+0x1a5/0xe28
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffff81071d1e>] ? timekeeping_get_ns+0xd/0x2a
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffff81072986>] ? getnstimeofday+0x4d/0x80
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffff81072a06>] ? do_gettimeofday+0x10/0x2f
Feb 29 17:01:37 goscie kernel: [  265.412034]  [<ffffffff813615b6>] ? cstar_dispatch+0x7/0x21
Feb 29 17:01:37 goscie kernel: [  265.412034] Code: 89 64 24 28 e8 86 fc ff ff 48 83 c4 68 c3 48 89 f1 41 89 d0 48 83 ec 08 48 89 fa 48 c7 c6 8d 7e 0f a0 31 ff 31 c0 e8 8d ff ff ff <0f> 0b eb fe 90 90 45 31 c0 31 c0 48 83 7f 38 00 75 67 e9 bd 00 
Feb 29 17:01:37 goscie kernel: [  265.412034] RIP  [<ffffffffa00913aa>] assfail+0x1d/0x23 [xfs]
Feb 29 17:01:37 goscie kernel: [  265.412034]  RSP <ffff880009ee5938>
Feb 29 17:01:37 goscie kernel: [  265.445134] ---[ end trace 1e67152b46e37c22 ]---

I'm trying to bisect but it would take a while.

root@goscie:~# xfs_info /
meta-data=/dev/disk/by-uuid/07910403-cd4b-4388-bab2-df7372aa7227 isize=256    agcount=9, agsize=114816 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=983552, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@goscie:~# grep xfs /proc/mounts 
/dev/disk/by-uuid/07910403-cd4b-4388-bab2-df7372aa7227 / xfs rw,noatime,attr2,noquota 0 0

Regards,
Kupson
PS: Please do CC: me. I'm not subscribed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
