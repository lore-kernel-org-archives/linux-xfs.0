Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O8LOUh117686 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 03:21:24 -0500
Date: Fri, 24 Jul 2009 04:22:03 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1301281514.948741248423723710.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1983390176.948321248423442558.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Eddy Zhao <eddy.y.zhao@gmail.com>
Cc: xfs@oss.sgi.com

Hi Eddy,

CC'ing this to the xfs list.

----- "Eddy Zhao" <eddy.y.zhao@gmail.com> wrote:

> Hello Felix, Lachlan:
> 
> I find your names in 2.6.30 Changlog as XFS maintainer. Can you kindly
> take a look at the problem we are facing.
> 
> Follow the sequence below to reproduce the problem
> - write data on 2.6.28 system
> - unplug usb disk while writing
I don't recommend you pull the usb disk out while the filesystem is still
mounted (if you can avoid it).

> - plug usb disk to 2.6.10 system
> - mount filesystem. mount failed!! (refer error info at mail end)
> - repair filesystem. repair failed!! (refer to error info at mail end)
> - unplug usb disk, then plug usb disk to 2.6.28 system
> - mount filesystem. mount success
Okay good.  Looks like whatever the problem is it has been fixed.

> - unplug usb disk, then plug usb disk to 2.6.10 system
> - mount filesystem. mount success
> 
> We are hitting this because our products need to migrate data between
> them. And they are using either 2.6.28 or 2.6.10 kernel.
> 
> You can easily reproduce the problem follow the sequence above.
> 
> Is it XFS log "forward" compatible? Where's the problem? How can I fix
> it?
I would start by looking through the change history for fs/xfs/xfs_log_recover.c
and paying particular attention to anything to do with inode transactions.  Or
try some intermediate kernels and see if you can narrow the fix down to a set of
changes.

> 
> Thanks
> Eddy
> 
> 
> ---------------------------
> Error info on 2.6.10 system
> 
> 
> # mount /dev/sda1 /mnt/
> UDF-fs: No VRS found
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (dev: sda1)
> Filesystem "sda1": xfs_inode_recover: Bad inode magic number, dino ptr
> = 0xc8266700, dino bp = 0xc8281b40, ino = 0
Here we have log replay processing an inode and it's checking that what
is on disk (at the location where we are going to write the inode) is
actually an inode.  In this case what we read from the filesystem did
not have the magic number for an inode.  Hmm that 'ino = 0' doesn't seem
right either.

> Filesystem "sda1": XFS internal error xlog_recover_do_inode_trans(1)
> at line 2366 of file fs/xfs/xfs_log_recover.c. Caller 0xc01677c0
> [<c016532c>] (xlog_recover_process_data+0x0/0x1904) from [<c01677c0>]
> (xlog_do_recovery_pass+0x328/0x900)
> [<c0167498>] (xlog_do_recovery_pass+0x0/0x900) from [<c0167e8c>]
> (xlog_recover+0xf4/0x22c)
> [<c0167d98>] (xlog_recover+0x0/0x22c) from [<c0160cc8>]
> (xfs_log_mount+0x444/0x4bc)
> r9 = 00000004 r8 = C8295000 r7 = C8278000 r6 = 00000000
> r5 = C8BCAD80 r4 = C8C74DE0
> [<c0160884>] (xfs_log_mount+0x0/0x4bc) from [<c0169fd8>]
> (xfs_mountfs+0x7f0/0xac0)
> [<c01697e8>] (xfs_mountfs+0x0/0xac0) from [<c0170588>]
> (xfs_mount+0x618/0x6c4)
> [<c016ff70>] (xfs_mount+0x0/0x6c4) from [<c01830ac>]
> (vfs_mount+0x34/0x38)
> [<c0183078>] (vfs_mount+0x0/0x38) from [<c0182e60>]
> (linvfs_fill_super+0xa4/0x294)
> [<c0182dbc>] (linvfs_fill_super+0x0/0x294) from [<c00869b8>]
> (get_sb_bdev+0x128/0x184)
> r8 = C8239000 r7 = 00008000 r6 = C800C6C0 r5 = C8C57200
> r4 = C800C6DC
> [<c0086890>] (get_sb_bdev+0x0/0x184) from [<c018306c>]
> (linvfs_get_sb+0x1c/0x28)
> r8 = 00008000 r7 = C8238000 r6 = C032344C r5 = FFFFFFF4
> r4 = C8007960
> [<c0183050>] (linvfs_get_sb+0x0/0x28) from [<c0086bf8>]
> (do_kern_mount+0x5c/0xf4)
> [<c0086b9c>] (do_kern_mount+0x0/0xf4) from [<c009ecc0>]
> (do_mount+0x624/0x658)
> [<c009e69c>] (do_mount+0x0/0x658) from [<c009f144>]
> (sys_mount+0xa8/0xf4)
> [<c009f09c>] (sys_mount+0x0/0xf4) from [<c00299c0>]
> (ret_fast_syscall+0x0/0x2c)
> r7 = 00000015 r6 = 001CCBD8 r5 = BEFFFF8C r4 = 001CC308
> XFS: log mount/recovery failed: error 990
> XFS: log mount failed
> yaffs: dev is 8388609 name is "sda1"
> yaffs: Attempting MTD mount on 8.1, "sda1"
> yaffs: dev is 8388609 name is "sda1"
> yaffs: Attempting MTD mount on 8.1, "sda1"
> mount: mounting /dev/sda1 on /mnt/ failed: Invalid argument
> #
> #
> #
> #
> # xfs_repair /dev/sda1
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
> - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which
> needs to
> be replayed. Mount the filesystem to replay the log, and unmount it
> before
> re-running xfs_repair. If you are unable to mount the filesystem, then
> use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount
> of the filesystem before doing this.
> # mount
> rootfs on / type rootfs (rw)
> /dev/root on / type nfs
> (rw,v2,rsize=4096,wsize=4096,hard,udp,nolock,addr=7.7.7.1)
> none on /proc type proc (rw,nodiratime)
> none on /sys type sysfs (rw)
> none on /dev/pts type devpts (rw)
> none on /proc/bus/usb type usbfs (rw)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
