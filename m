Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7HDfWA6049999 for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 08:41:32 -0500
Received: from out.rilinfo.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 19ECB32BC
	for <xfs@oss.sgi.com>; Tue, 17 Aug 2010 06:41:58 -0700 (PDT)
Received: from out.rilinfo.net (out41.rilinfo.net [202.138.96.41]) by
	cuda.sgi.com with ESMTP id wLYFqxWQA3FKmYvJ for
	<xfs@oss.sgi.com>; Tue, 17 Aug 2010 06:41:58 -0700 (PDT)
Date: Tue, 17 Aug 2010 19:12:12 +0530 (IST)
From: Nohez <nohez@cmie.com>
Subject: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Message-ID: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
MIME-Version: 1.0
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


Hi,

I had a kernel bug today when running xfs on CentOS v5.5. I moved to
xfs from ext3 today.

The only application accessing the xfs filesystem is Sybase ASE v15.x.
Database has been configured to use directio with native kernel
asynchronous disk i/o enabled.

Let me know if there is any other information I can provide to help
with debugging.

Thanks
Nohez


# uname -a
Linux xxxxxx 2.6.18-194.11.1.el5 #1 SMP Tue Aug 10 19:05:06 EDT 2010 x86_64 x86_64 x86_64 GNU/Linux

# modinfo xfs
filename:       /lib/modules/2.6.18-194.11.1.el5/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
author:         Silicon Graphics, Inc.
srcversion:     5380928C58CAF3C9D7FF438
depends:
vermagic:       2.6.18-194.11.1.el5 SMP mod_unload gcc-4.1
module_sig:     883f3504c61e211db40e56c3525288511247550a0d2737921213759cfcfebb5d4b9c7349defb86f4f0a0c1199fc66696cad525fb805585a3d05072b47923

# grep xfs /proc/mounts
/dev/mapper/xxxxxx_syb_vol_6130p1 /sybase xfs rw,noatime,nodiratime,nobarrier,logbufs=8,logbsize=32k,noquota 0 0



<begin /var/log/messages>

Aug 17 14:26:02 xxxxxx kernel: XFS mounting filesystem dm-1
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: Call Trace:
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: Call Trace:
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: Call Trace:
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: Call Trace:
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: Call Trace:
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:09 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:09 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:09 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:10 xxxxxx kernel: 
Aug 17 15:20:10 xxxxxx kernel: Call Trace:
Aug 17 15:20:10 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:11 xxxxxx kernel: 
Aug 17 15:20:11 xxxxxx kernel: BUG: warning at fs/xfs/linux-2.6/xfs_lrw.c:718/xfs_write() (Tainted: G     )
Aug 17 15:20:11 xxxxxx kernel: 
Aug 17 15:20:11 xxxxxx kernel: Call Trace:
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff88683d59>] :xfs:xfs_write+0x39f/0x69e
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800e9226>] core_sys_select+0x1f9/0x265
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff886805a0>] :xfs:xfs_file_aio_write+0x65/0x6a
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800ef2b6>] aio_pwrite+0x2c/0x75
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800efd77>] aio_run_iocb+0xef/0x18a
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800f08e1>] io_submit_one+0x396/0x499
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff800f0ef8>] sys_io_submit+0xbe/0x1a4
Aug 17 15:20:11 xxxxxx kernel:  [<ffffffff8005d28d>] tracesys+0xd5/0xe0
Aug 17 15:20:11 xxxxxx kernel:

<end /var/log/messages>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
