Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 239327CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 10:50:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 03FDD8F8039
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 08:50:50 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id WuR0BcOrRA9cf2Zp for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 08:50:49 -0800 (PST)
Date: Wed, 3 Feb 2016 09:50:31 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: real-time device warning
Message-ID: <20160203165031.GB29275@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

I've been doing some more real-time device testing with XFS, and I was able to
get past the BUG I reported here:

http://www.spinics.net/lists/xfs/msg37445.html

by setting CONFIG_XFS_DEBUG=n as Dave suggested.

After that I/O seems to work, although it doesn't look like the DAX mount
option is applied to I/Os that go to the real-time device.

After the first I/O, though, the following warning is hit:

[  413.086897] XFS (ram1): _xfs_buf_ioapply: no ops on block 0xa0/0x8
[  413.091102] ffff8805038e8000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  413.093495] ffff8805038e8010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  413.095855] ffff8805038e8020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  413.098221] ffff8805038e8030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  413.100576] CPU: 0 PID: 1362 Comm: xfsaild/ram1 Not tainted 4.5.0-rc2 #20
[  413.102244] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[  413.104494]  0000000000000000 0000000004f1f04f ffff8800981abbe0 ffffffff8155d6b2
[  413.106378]  0000000000000001 ffff8800981abc98 ffffffff814780d2 ffffffff81a50737
[  413.108253]  ffffe8ffffa00c00 ffff8800981abc50 ffffffff810c1947 00000000001d12d0
[  413.110071] Call Trace:
[  413.110635]  [<ffffffff8155d6b2>] dump_stack+0x44/0x62
[  413.111807]  [<ffffffff814780d2>] _xfs_buf_ioapply+0x432/0x480
[  413.113106]  [<ffffffff81a50737>] ? _raw_spin_unlock+0x27/0x30
[  413.114406]  [<ffffffff810c1947>] ? __queue_work+0x167/0x3a0
[  413.115788]  [<ffffffff810f8a64>] ? lockdep_init_map+0x64/0x6b0
[  413.117116]  [<ffffffff810fbc7d>] ? trace_hardirqs_on+0xd/0x10
[  413.118421]  [<ffffffff810d6a20>] ? wake_up_q+0x70/0x70
[  413.119589]  [<ffffffff81479964>] ? __xfs_buf_delwri_submit+0x1f4/0x2e0
[  413.120984]  [<ffffffff81479683>] xfs_buf_submit+0x73/0x160
[  413.122175]  [<ffffffff81479964>] __xfs_buf_delwri_submit+0x1f4/0x2e0
[  413.123520]  [<ffffffff8147a7cf>] ? xfs_buf_delwri_submit_nowait+0x2f/0x50
[  413.124967]  [<ffffffff8147a7cf>] ? xfs_buf_delwri_submit_nowait+0x2f/0x50
[  413.126417]  [<ffffffff8147a7cf>] xfs_buf_delwri_submit_nowait+0x2f/0x50
[  413.127815]  [<ffffffff814a7734>] xfsaild+0x264/0x6c0
[  413.128871]  [<ffffffff814a74d0>] ? xfs_trans_ail_cursor_first+0x90/0x90
[  413.130222]  [<ffffffff814a74d0>] ? xfs_trans_ail_cursor_first+0x90/0x90
[  413.131529]  [<ffffffff810c99a6>] kthread+0xf6/0x110
[  413.132510]  [<ffffffff810fbbe9>] ? trace_hardirqs_on_caller+0x129/0x1b0
[  413.133805]  [<ffffffff810c98b0>] ? kthread_create_on_node+0x250/0x250
[  413.135036]  [<ffffffff81a514df>] ret_from_fork+0x3f/0x70
[  413.136084]  [<ffffffff810c98b0>] ? kthread_create_on_node+0x250/0x250

The steps to reproduce this are as follows:

# fdisk -l /dev/ram*
Disk /dev/ram0: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk /dev/ram1: 4 GiB, 4294967296 bytes, 8388608 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

# mkfs.xfs -f -r rtdev=/dev/ram0 /dev/ram1
meta-data=/dev/ram1              isize=512    agcount=4, agsize=262144 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=1048576, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =/dev/ram0              extsz=4096   blocks=1048576, rtextents=1048576

# mount -t xfs -o rtdev=/dev/ram0 /dev/ram1 /mnt

# mount | grep '/mnt'
/dev/ram1 on /mnt type xfs (rw,relatime,seclabel,attr2,inode64,rtdev=/dev/ram0,noquota)

# xfs_rtcp ~/data /mnt/
xfs_rtcp: /root/data is not a realtime file.

Thanks,
- Ross

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
