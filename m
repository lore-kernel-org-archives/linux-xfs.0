Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AF5C7F5D
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 01:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ACE03AC002
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 23:43:31 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id BiIAGWuNzUkff2Zj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 01 Dec 2015 23:43:29 -0800 (PST)
From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: BUG: unable to handle kernel paging request at ffffffff82200000
	(xlog_recover_buffer_pass2)
Message-ID: <565EA0DF.609@oracle.com>
Date: Wed, 2 Dec 2015 08:42:23 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020909090304020500060304"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020909090304020500060304
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Mounting the attached XFS image (fuzzed) gives me the following invalid
memory dereference on latest linus/master:

XFS (vda): Mounting V4 Filesystem
XFS (vda): Starting recovery (logdev: internal)
XFS (vda): log record CRC mismatch: found 0x9f534964, expected 0xd46d59ce.
ffffc90000442000: 00 00 00 01 00 00 00 00 69 01 00 00 e6 33 18 19 
........i....3..
ffffc90000442010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00 
....i...NART*...
XFS (vda): log record CRC mismatch: found 0xedba28e, expected 0x9f019b73.
ffffc90000442000: 00 00 00 01 00 00 00 00 69 01 00 00 5c 47 88 1e 
........i...\G..
ffffc90000442010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00 
....i...NART*...
XFS (vda): log record CRC mismatch: found 0x9f534964, expected 0xd46d59ce.
ffffc9000044a000: 00 00 00 01 00 00 00 00 69 01 00 00 e6 33 18 19 
........i....3..
ffffc9000044a010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00 
....i...NART*...
BUG: unable to handle kernel paging request at ffffffff82200000
IP: [<ffffffff81475616>] memcpy_erms+0x6/0x10
PGD 1e10067 PUD 1e11063 PMD 0
Oops: 0000 [#1] SMP KASAN
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.4.0-rc3+ #245
task: ffff880016e28000 ti: ffff880016e30000 task.ti: ffff880016e30000
RIP: 0010:[<ffffffff81475616>]  [<ffffffff81475616>] memcpy_erms+0x6/0x10
RSP: 0000:ffff880016e377b8  EFLAGS: 00010287
RAX: ffff88001494e380 RBX: 0000000000000027 RCX: ffffffff80285761
RDX: ffffffff81150400 RSI: ffffffff82200000 RDI: ffff88001581901f
RBP: ffff880016e37808 R08: ffff880016429ba8 R09: 0000000000000018
R10: 0000000000000000 R11: 0000000000000000 R12: ffff880016429b90
R13: 0000000000000002 R14: 00000000ff022a08 R15: ffffffff81335361
FS:  0000000000000000(0000) GS:ffff880017200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff82200000 CR3: 0000000001e0f000 CR4: 00000000001406b0
Stack:
  ffffffff8133eb74 ffff880000079b80 ffff880015bf6e40 ffff880016429ba4
  ffff880000108470 ffff880016429b90 ffff880014c26290 ffff880015bf6e40
  ffff880000108450 ffff880000079b80 ffff880016e37870 ffffffff8133f02a
Call Trace:
  [<ffffffff8133eb74>] ? xlog_recover_do_reg_buffer.isra.23+0x124/0x1b0
  [<ffffffff8133f02a>] xlog_recover_buffer_pass2+0x35a/0x450
  [<ffffffff81340c09>] xlog_recover_commit_pass2+0xe9/0x160
  [<ffffffff81340cbc>] xlog_recover_items_pass2+0x3c/0x60
  [<ffffffff81340ee6>] xlog_recover_commit_trans+0x206/0x230
  [<ffffffff81340f8a>] xlog_recovery_process_trans+0x7a/0xb0
  [<ffffffff8134101e>] xlog_recover_process_ophdr+0x5e/0xc0
  [<ffffffff8134111a>] xlog_recover_process_data+0x9a/0xc0
  [<ffffffff81341580>] xlog_do_recovery_pass+0x440/0x540
  [<ffffffff8115384f>] ? kasan_poison_shadow+0x2f/0x40
  [<ffffffff813416f9>] xlog_do_log_recovery+0x79/0xc0
  [<ffffffff81341751>] xlog_do_recover+0x11/0xe0
  [<ffffffff81342553>] xlog_recover+0xa3/0x140
  [<ffffffff8133718e>] xfs_log_mount+0x24e/0x2c0
  [<ffffffff8132f209>] xfs_mountfs+0x499/0x7d0
  [<ffffffff8132ff91>] ? xfs_mru_cache_create+0x121/0x180
  [<ffffffff81331e2d>] xfs_fs_fill_super+0x38d/0x4a0
  [<ffffffff8115deb5>] mount_bdev+0x185/0x1c0
  [<ffffffff81331aa0>] ? xfs_parseargs+0xaa0/0xaa0
  [<ffffffff81330580>] xfs_fs_mount+0x10/0x20
  [<ffffffff8115e0e4>] mount_fs+0x34/0x160
  [<ffffffff811240b0>] ? __alloc_percpu+0x10/0x20
  [<ffffffff81178a22>] vfs_kern_mount+0x62/0x110
  [<ffffffff81179e6b>] do_mount+0x21b/0xdd0

$ addr2line -e vmlinux -i ffffffff81475616 # memcpy_erms+0x6/0x10
arch/x86/lib/memcpy_64.S:50

$ addr2line -e vmlinux -i ffffffff8133eb74 # 
xlog_recover_do_reg_buffer.isra.23+0x124/0x1b0
fs/xfs/xfs_log_recover.c:2238

$ addr2line -e vmlinux -i ffffffff8133f02a # 
xlog_recover_buffer_pass2+0x35a/0x450
fs/xfs/xfs_log_recover.c:2397

which is this bit:

     memcpy(xfs_buf_offset(bp,
             (uint)bit << XFS_BLF_SHIFT),    /* dest */
             item->ri_buf[i].i_addr,         /* source */
             nbits<<XFS_BLF_SHIFT);          /* length */

Because of the memory corruption the bug manifests in different ways,
but the stacktrace above is by far the most common.

I can test patches. Thanks,


Vegard

--------------020909090304020500060304
Content-Type: application/x-bzip;
 name="xfs.0.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xfs.0.bz2"

QlpoOTFBWSZTWbxlpU0C+gT/////////////////////////////////////////////4B7f
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
K9/iCjViUYSRAYBOGGSBYkJow3Tdpu7tl27u7u7ubO7u7toWiOyTi0mywKoyEh9hgTfMIHs0
3EPAtijIghIKHoUgUBcMWGGFmGfDDDDDDDDRmWQkFPgsJA+GwgcEgEvvvvvxX3333333333m
ZgAApAAFAABQAAUAAFAABQAAUAAFAABQAAUCSZ0CAUQAAUAAFAABQAAUBJNtgBRkJOXTryEA
LsV2xdiuuuuuuuuuuuMzBESKqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq
qqqqqqqqqqqq8DSiqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqrw9KKqqq
qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqiJdddddZdddddddddd1yZgyI
FrAhO7ISb5J9dkONQ5JCxkIcqwCgJCYYYYYYsMNvDDDDDDHTbygWJISeUYc2yQJxTCHRWwvv
vvvsz33336L7r8e2ZZIHJoQh/NhAC22223Fkttttttttx25USCyQiRRm0MCgMCAskkPuJDby
6LKtGizJo0aMujRo0Y82XQAAAAikzISghIZ0JJOGZA7QgFaAFttmO3Fly222222248k20JDq
LAgUZOZYABbbbbbiyW2220pSk+Crklh7ElKUpLq7ElJcpYkpJNtu3W2223O8lKUpSlf4VmxJ
CVpWbAlasKxashcqAACd4khSJSlLIyZSlKUpSj0XS+b7LW/x3aSSWBJJJKPatD97N1e30Hee
20DNVq1rWuGta1rWtY6r2/IdPz+rCSxklgSSSSj0E4ee93cAAAvAAAAR0GnwXbsMm5C5jNdb
wjND6/VfCJMScBJMycJ93o3dXxSSSWNJJJKfLdlvPfaDbbeRtttud6/tdEXc1/L6WjTQrcrW
ta1w1rWta1rGbM0J8ZzMwLoAvAAAAR7Dhd5sukpSlKUy6UpSlKUjVul7bdbLlySSb5JJJMf8
bPmfWd5Rtt5G22257vid7/BCSSWNJJJKau7vW7PvFt9wwwwwzc7DDDDDDDCfS+u24kkm8kkk
meA0Lve9hwTbbeRtttuc+2Va1rZtrWta1rTtm79qSSTeSSSTPadqSSSbySSSZ7bt+q6PpIht
tvI2223PB+sui6IiIiIjhySSbySSSZ028gAASAAABOmxb1yHS7Q223nN57bbl9v3hJJN5JJJ
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
tKmg
--------------020909090304020500060304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020909090304020500060304--
