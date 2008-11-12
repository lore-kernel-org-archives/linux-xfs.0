Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 23:42:47 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC7gen5016472
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:42:40 -0800
Received: from zero.voxel.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9B08154A720
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:42:39 -0800 (PST)
Received: from zero.voxel.net (zero.voxel.net [69.9.191.6]) by cuda.sgi.com with ESMTP id Ja5u822Hrd7JHbZS for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 23:42:39 -0800 (PST)
Received: from [192.168.1.25] (unknown [66.183.90.144])
	by zero.voxel.net (Postfix) with ESMTP id 128841BB003A
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 02:42:38 -0500 (EST)
Message-ID: <491A88F8.8040509@magoazul.com>
Date: Tue, 11 Nov 2008 23:42:48 -0800
From: Matthew Kent <mkent@magoazul.com>
MIME-Version: 1.0
Subject: centos and xfs filesystem shutdowns
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Desperately seeking advice :)

The setup:

* CentOS 5.2
* kmod-xfs-0.4-2 from centosplus repo
* nfs exporting -> xfs filesystem -> lvm volume -> iscsi target
* each filesystem is about 750GB and we mount 5 on each server.
* each filesystem contains 3-20 million small files.
* mount options are as follows
   _netdev,noatime,uqnoenforce,gqnoenforce,ihashsize=262139,rw

The crash:

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1561 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_alloc.c. 
Caller 0xffffffff883ff56b

Call Trace:
  [<ffffffff883fdc7e>] :xfs:xfs_free_ag_extent+0x19f/0x67f
  [<ffffffff883ff56b>] :xfs:xfs_free_extent+0xa9/0xc9
  [<ffffffff8840c2ad>] :xfs:xfs_bmap_finish+0xf0/0x169
  [<ffffffff88429e46>] :xfs:xfs_itruncate_finish+0x172/0x2b3
  [<ffffffff8843fe87>] :xfs:xfs_setattr+0x7fe/0xd63
  [<ffffffff8853e5ff>] :nfsd:exp_get_by_name+0x5b/0x71
  [<ffffffff8844a704>] :xfs:xfs_vn_setattr+0x11e/0x141
  [<ffffffff8002c9ac>] notify_change+0x145/0x2e0
  [<ffffffff8853c2a5>] :nfsd:nfsd_setattr+0x34f/0x3fa
  [<ffffffff88542620>] :nfsd:nfsd3_proc_setattr+0x98/0xa4
  [<ffffffff885381db>] :nfsd:nfsd_dispatch+0xd8/0x1d6
  [<ffffffff884c94fb>] :sunrpc:svc_process+0x454/0x71b
  [<ffffffff800645ec>] __down_read+0x12/0x92
  [<ffffffff885385a1>] :nfsd:nfsd+0x0/0x2cb
  [<ffffffff88538746>] :nfsd:nfsd+0x1a5/0x2cb
  [<ffffffff8005dfb1>] child_rip+0xa/0x11
  [<ffffffff885385a1>] :nfsd:nfsd+0x0/0x2cb
  [<ffffffff885385a1>] :nfsd:nfsd+0x0/0x2cb
  [<ffffffff8005dfa7>] child_rip+0x0/0x11

xfs_force_shutdown(dm-8,0x8) called from line 4267 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_bmap.c. 
Return address = 0xffffffff8840c2ea
Filesystem "dm-8": Corruption of in-memory data detected.  Shutting down 
filesystem: dm-8
Please umount the filesystem, and rectify the problem(s)

Subsequent recovery:

Filesystem "dm-9": Disabling barriers, not supported by the underlying 
device
XFS mounting filesystem dm-9
Starting XFS recovery on filesystem: dm-9 (logdev: internal)
XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1561 of file 
/home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_alloc.c. 
Caller 0xffffffff883fd56b

Call Trace:
  [<ffffffff883fbc7e>] :xfs:xfs_free_ag_extent+0x19f/0x67f
  [<ffffffff883fd56b>] :xfs:xfs_free_extent+0xa9/0xc9
  [<ffffffff884320e5>] :xfs:xlog_recover_finish+0x15a/0x244
  [<ffffffff88435b00>] :xfs:xfs_mountfs+0xa24/0xc30
  [<ffffffff8000c31a>] _atomic_dec_and_lock+0x39/0x57
  [<ffffffff8843b748>] :xfs:xfs_mount+0x762/0x83b
  [<ffffffff8844ac79>] :xfs:xfs_fs_fill_super+0x0/0x1e3
  [<ffffffff8844acf7>] :xfs:xfs_fs_fill_super+0x7e/0x1e3
  [<ffffffff80064553>] __down_write_nested+0x12/0x92
  [<ffffffff80122410>] selinux_sb_alloc_security+0x3e/0x82
  [<ffffffff800e29c1>] get_filesystem+0x12/0x3b
  [<ffffffff800da854>] sget+0x365/0x377
  [<ffffffff800da1a0>] set_bdev_super+0x0/0xf
  [<ffffffff800da1af>] test_bdev_super+0x0/0xd
  [<ffffffff800db163>] get_sb_bdev+0x10a/0x164
  [<ffffffff80122e04>] selinux_sb_copy_data+0x1a1/0x1c5
  [<ffffffff800dab00>] vfs_kern_mount+0x93/0x11a
  [<ffffffff800dabc9>] do_kern_mount+0x36/0x4d
  [<ffffffff800e42fb>] do_mount+0x6a7/0x717
  [<ffffffff8002cb60>] mntput_no_expire+0x19/0x89
  [<ffffffff8000e80b>] link_path_walk+0xd3/0xe5
  [<ffffffff8003c397>] do_unlinkat+0xe8/0x141
  [<ffffffff8002371c>] __user_walk_fd+0x41/0x4c
  [<ffffffff800c4edc>] zone_statistics+0x3e/0x6d
  [<ffffffff8000f095>] __alloc_pages+0x65/0x2ce
  [<ffffffff8003c397>] do_unlinkat+0xe8/0x141
  [<ffffffff8004bd19>] sys_mount+0x8a/0xcd
  [<ffffffff8005d116>] system_call+0x7e/0x83

Ending XFS recovery on filesystem: dm-9 (logdev: internal)

The story:

Been getting these corruptions for a while now over the span of 6 
different machines and a few months. It's gotten a tad crazy lately 
though with 2 crashes on 2 different filesystems and machines within the 
span of 3 days.

In looking up portions of the backtrace I found many recommendations to 
stress/memtest etc to ensure the hardware is solid, I'll of which we've 
been doing diligently. In fact we've used so many different machines and 
sticks of ecc memory at this point I can pretty confidently rule it out.

Since our iscsi storage takes nightly snapshots, I've used these and 
passed them through xfs_repair, xfs_check thinking there was some kind 
of issue and they always (in 3 repair/checks after 3 different crashes) 
  seem to come up perfectly clean. These file systems are relatively new 
as well, being created in March 2008.

The crash is always exactly the same across different machines. In fact 
the first 5 lines look very similar to 
http://oss.sgi.com/archives/xfs/2007-11/msg00041.html in that it always 
mentions setattr.

I noticed a newer xfs rpm in http://sandeen.net/rhel5_xfs/ is that worth 
a shot?

Any suggestions would be very much appreciated.
