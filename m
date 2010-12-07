Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7Bm4nq142847 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 05:48:04 -0600
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E38A21420CC4
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 03:49:49 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id 4YfOpZ4QxrDUPZdy for
	<xfs@oss.sgi.com>; Tue, 07 Dec 2010 03:49:49 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1PPw3J-0000DU-CT
	for xfs@oss.sgi.com; Tue, 07 Dec 2010 03:49:49 -0800
Message-ID: <30395558.post@talk.nabble.com>
Date: Tue, 7 Dec 2010 03:49:49 -0800 (PST)
From: blacknred <leo1783@hotmail.co.uk>
Subject: possible xfs corruption
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi...

I'm stuck with a storage issue on reboot. Initially doubted the storage, but
dmesg throws these errors. Now wondering whether this is a fs issue? Any
thoughts as to whats going on here?


XFS: failed to locate log tail
XFS: log mount/recovery failed: error 117
XFS: log mount failed
XFS mounting filesystem cciss/c0d0
Filesystem "cciss/c0d0": XFS internal error xlog_clear_stale_blocks(2) at
line 1237 of file
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_log_recover.c. 
Caller 0xf8aa7892
 [<f8aa774e>] xlog_find_tail+0x91b/0xa4a [xfs]
 [<f8aa7892>] xlog_recover+0x15/0x20b [xfs]
 [<f8aa7892>] xlog_recover+0x15/0x20b [xfs]
 [<f8ab9000>] xfs_buf_get_empty+0x2a/0x33 [xfs]
 [<f8aa36e5>] xfs_log_mount+0x467/0x4ab [xfs]
 [<f8ab702d>] kmem_zalloc+0xd/0x34 [xfs]
 [<f8aa9d8a>] xfs_mountfs+0x9f5/0xdfb [xfs]
 [<f8a92287>] xfs_fs_vcmn_err+0x5f/0x83 [xfs]
 [<f8abeea5>] xfs_mountfs_check_barriers+0xb8/0xd0 [xfs]
 [<f8ab02d2>] xfs_mount+0x75e/0x82a [xfs]
 [<f8aafb74>] xfs_mount+0x0/0x82a [xfs]
 [<f8abf57f>] vfs_mount+0x17/0x1a [xfs]
 [<f8abf42b>] xfs_fs_fill_super+0x68/0x1a5 [xfs]
 [<c04ef1a0>] snprintf+0x1c/0x1f
 [<c04a9b23>] disk_name+0x56/0x60
 [<c047b131>] get_sb_bdev+0xc6/0x113
 [<f8abe9d3>] xfs_fs_get_sb+0x12/0x16 [xfs]
 [<f8abf3c3>] xfs_fs_fill_super+0x0/0x1a5 [xfs]
 [<c047abf6>] vfs_kern_mount+0x7d/0xf2
 [<c047ac9d>] do_kern_mount+0x25/0x36
 [<c048e6aa>] do_mount+0x5fb/0x66b
 [<c04c63ab>] avc_has_perm+0x3c/0x46
 [<c04c63ab>] avc_has_perm+0x3c/0x46
 [<c04c7c1e>] selinux_inode_alloc_security+0x50/0x7b
 [<c04c7619>] inode_doinit_with_dentry+0x8a/0x495
 [<c045ad0a>] get_page_from_freelist+0x96/0x370
 [<c045b04d>] __alloc_pages+0x69/0x2cf
 [<c048d597>] copy_mount_options+0x26/0x109
 [<c048e787>] sys_mount+0x6d/0xa5
 [<c0404ead>] sysenter_past_esp+0x56/0x79

Thanks in advance
David

-- 
View this message in context: http://old.nabble.com/possible-xfs-corruption-tp30395558p30395558.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
