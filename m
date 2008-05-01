Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 14:20:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m41LJgcQ031745
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 14:19:46 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 585F41B909B1
	for <xfs@oss.sgi.com>; Thu,  1 May 2008 14:20:25 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id daGWTbSASZdDklYW for <xfs@oss.sgi.com>; Thu, 01 May 2008 14:20:24 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m41LKIF3000405
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 23:20:18 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m41LKID2000403
	for xfs@oss.sgi.com; Thu, 1 May 2008 23:20:18 +0200
Date: Thu, 1 May 2008 23:20:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: xfsqa 173 failure
Message-ID: <20080501212018.GA32213@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

With current cvs on a 32bit kvm virtual machine:

173	[  101.464812] XFS mounting filesystem hdd
[  101.481588] Ending clean XFS mount for filesystem: hdd
[  187.511174] XFS mounting filesystem hdd
[  188.022185] Ending clean XFS mount for filesystem: hdd
[  294.381897] XFS mounting filesystem hdd
[  294.449374] Ending clean XFS mount for filesystem: hdd
[  377.352911] Assertion failed: vn_count(vp) == 0, file: fs/xfs/xfs_inode.c, line: 3552
[  377.354531] ------------[ cut here ]------------
[  377.355178] kernel BUG at fs/xfs/support/debug.c:81!
[  377.355178] invalid opcode: 0000 [#1] SMP 
[  377.355178] Modules linked in: xfs binfmt_misc nfsd auth_rpcgss exportfs af_packet nfs lockd nfs_acl sunrpc loop psmouse pcspkr serio_raw evdev
[  377.355178] 
[  377.355178] Pid: 15732, comm: umount Not tainted (2.6.25-rc3 #29)
[  377.355178] EIP: 0060:[<f0a0464e>] EFLAGS: 00010282 CPU: 0
[  377.355178] EIP is at assfail+0x1e/0x30 [xfs]
[  377.355178] EAX: 0000005c EBX: eca66348 ECX: c011b400 EDX: edf1a000
[  377.355178] ESI: ec62ca08 EDI: ec62cb7c EBP: dc417e54 ESP: dc417e44
[  377.355178]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  377.355178] Process umount (pid: 15732, ti=dc416000 task=edf1a000 task.ti=dc416000)
[  377.355178] Stack: f0a17740 f0a08601 f0a0851a 00000de0 dc417e68 f09cc64a ec62ca08 00000000 
[  377.355178]        ef709040 dc417e88 f09e54d3 00000003 ef751928 ec62ca08 dc417e88 00000000 
[  377.355178]        ec62ca08 dc417ed8 f09ef15a f0a0253f f09ee077 00000002 00000046 c0411820 
[  377.355178] Call Trace:
[  377.355178]  [<f09cc64a>] ? xfs_iflush_all+0x4a/0x80 [xfs]
[  377.355178]  [<f09e54d3>] ? xfs_unmountfs+0x23/0x150 [xfs]
[  377.355178]  [<f09ef15a>] ? xfs_unmount+0x14a/0x200 [xfs]
[  377.355179]  [<f0a0253f>] ? xfs_fs_put_super+0x2f/0x50 [xfs]
[  377.355179]  [<f09ee077>] ? xfs_syncsub+0xe7/0x2b0 [xfs]
[  377.355179]  [<f0a0253f>] ? xfs_fs_put_super+0x2f/0x50 [xfs]
[  377.355179]  [<c032767b>] ? lock_kernel+0x2b/0x50
[  377.355179]  [<c017ec44>] ? generic_shutdown_super+0x54/0xd0
[  377.355179]  [<c017eccf>] ? kill_block_super+0xf/0x20
[  377.355179]  [<c017edb2>] ? deactivate_super+0x72/0x90
[  377.355179]  [<c0192974>] ? mntput_no_expire+0x44/0x70
[  377.355179]  [<c0192f14>] ? sys_umount+0x44/0x230
[  377.355179]  [<c01804a4>] ? sys_stat64+0x14/0x30
[  377.355179]  [<c016a36c>] ? do_munmap+0x18c/0x1f0
[  377.355179]  [<c0193119>] ? sys_oldumount+0x19/0x20
[  377.355179]  [<c0103ec6>] ? syscall_call+0x7/0xb
[  377.355179]  =======================
[  377.355179] Code: 00 e8 57 b0 80 cf c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 40 77 a1 f0 e8 12 e0 71 cf <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 
