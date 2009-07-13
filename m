Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6D6Bijg029333 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 01:11:45 -0500
Received: from ey-out-2122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD362A45F78
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 23:19:44 -0700 (PDT)
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.25])
	by cuda.sgi.com with ESMTP id VoAv8Dn9OJ8pv8wV for
	<xfs@oss.sgi.com>; Sun, 12 Jul 2009 23:19:44 -0700 (PDT)
Received: by ey-out-2122.google.com with SMTP id 22so431072eye.57
	for <xfs@oss.sgi.com>; Sun, 12 Jul 2009 23:12:20 -0700 (PDT)
MIME-Version: 1.0
From: Lance Reed <lreed@brightcove.com>
Date: Mon, 13 Jul 2009 02:12:00 -0400
Message-ID: <5770aa2a0907122312n18db5784x8b5c8f6743c75136@mail.gmail.com>
Subject: XFS internal error XFS_WANT_CORRUPTED_GOTO error
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
To: xfs@oss.sgi.com, syseng <syseng@brightcove.com>

Hello,

We currently have a problem with a running XFS file system.

Specifically the XFS internal error XFS_WANT_CORRUPTED_GOTO errors showed up.

The Filesystem is 4.6 TB (LVM) and was originally created and mounted
on a 32 bit Linux system.
Do to problems with earlier versions of XFS, the HEAD node was
upgraded to a 64 bit system with the following attributes:

CentOS release 5.3 (Final)
2.6.18-128.1.10.el5   x86_64

XFS:
xfsdump-2.2.46-1.el5.centos
xfsprogs-2.9.4-1.el5.centos
kmod-xfs-0.4-2
lvm2-2.02.40-6.el5


Running NFS server with LINUX HA
heartbeat-2.1.3-3.el5.centos
heartbeat-pils-2.1.3-3.el5.centos
heartbeat-stonith-2.1.3-3.el5.centos

I am posting to see if there is any updated info on the process to
recover form the XFS_WANT_CORRUPTED_GOT.
Similar posts seem to indicate that there is a possibility that every
file can wind up in lost+found if not careful when running a
xfs_repair.  I would like to confirm if there are any XFS prog updates
or changes that might work better with the kernel version etc we are
running.  This system is in use but is also a testing ground for a
production system so any updates on version issues etc. would be
greatly appreciated.

We have the following error in logs.

Jul 11 04:01:36 qanfs2 kernel: svc: unknown version (0 for prog 100003 nfsd)
Jul 11 04:04:12 qanfs2 kernel: XFS internal error
XFS_WANT_CORRUPTED_GOTO at line 872 of file
/home/buildsvn/rpmbuild/BUILD/xf
s-kmod-0.4/_kmod_build_/xfs_ialloc.c.  Caller 0xffffffff88503944
Jul 11 04:04:12 qanfs2 kernel:
Jul 11 04:04:12 qanfs2 kernel: Call Trace:
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff884fc888>]
:xfs:xfs_dialloc+0xfe9/0x11ba
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8000e3ed>]
__block_prepare_write+0x1b6/0x4a6
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8851d248>] :xfs:xfs_get_blocks+0x0/0xe
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8000e7a3>]
__set_page_dirty_nobuffers+0xc6/0xd1
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff88503944>] :xfs:xfs_ialloc+0x51/0x47a
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff88514a08>]
:xfs:xfs_dir_ialloc+0x86/0x2c6
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8006465c>]
__down_write_nested+0x12/0x92
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8851b5f2>] :xfs:xfs_mkdir+0x2d9/0x5d7
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff884ddb52>] :xfs:xfs_attr_get+0xbf/0xd2
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8852302a>]
:xfs:xfs_vn_mknod+0x1e1/0x3bb
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff80021b1c>] __up_read+0x19/0x7f
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff884ff4e4>] :xfs:xfs_iunlock+0x57/0x79
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8002a8c0>] iput+0x4b/0x84
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff800e63f0>] d_alloc_anon+0x1c/0xf8
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff885207e8>]
:xfs:xfs_fs_get_dentry+0x38/0x59
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff885603a8>]
:exportfs:find_exported_dentry+0x85/0x47b
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856d71e>]
:nfsd:nfsd_acceptable+0x0/0xd8
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff885715e3>]
:nfsd:exp_get_by_name+0x5b/0x71
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff88571bd2>]
:nfsd:exp_find_key+0x89/0x9c
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff80021b1c>] __up_read+0x19/0x7f
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff800e2b97>] vfs_mkdir+0xe1/0x150
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff885700c7>]
:nfsd:nfsd_create+0x2c6/0x3ac
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff88576517>]
:nfsd:nfsd3_proc_mkdir+0xd9/0xea
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856b1db>]
:nfsd:nfsd_dispatch+0xd8/0x1d6
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8838b48b>]
:sunrpc:svc_process+0x454/0x71b
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff800646f5>] __down_read+0x12/0x92
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856b746>] :nfsd:nfsd+0x1a5/0x2cb
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:12 qanfs2 kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Jul 11 04:04:12 qanfs2 kernel:
Jul 11 04:04:12 qanfs2 kernel: nfsd: non-standard errno: -117
Jul 11 04:04:14 qanfs2 kernel: Filesystem "dm-5": XFS internal error
xfs_trans_cancel at line 1138 of file /home/buildsvn/rpmb
uild/BUILD/xfs-kmod-0.4/_kmod_build_/xfs_trans.c.  Caller 0xffffffff8851ab40
Jul 11 04:04:14 qanfs2 kernel:
Jul 11 04:04:14 qanfs2 kernel: Call Trace:
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff88512923>]
:xfs:xfs_trans_cancel+0x5b/0xfe
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8851ab40>] :xfs:xfs_create+0x55c/0x5a5
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff88522fff>]
:xfs:xfs_vn_mknod+0x1b6/0x3bb
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8003d630>] ifind_fast+0x47/0x83
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff800646f5>] __down_read+0x12/0x92
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff80022cd2>] iget_locked+0x59/0x149
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff88500261>] :xfs:xfs_iget+0x682/0x6d2
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff80089e4d>] enqueue_task+0x41/0x56
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff80021b1c>] __up_read+0x19/0x7f
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff884ff4e4>] :xfs:xfs_iunlock+0x57/0x79
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8002a8c0>] iput+0x4b/0x84
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff800e63f0>] d_alloc_anon+0x1c/0xf8
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff885207e8>]
:xfs:xfs_fs_get_dentry+0x38/0x59
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff885603a8>]
:exportfs:find_exported_dentry+0x85/0x47b
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856d71e>]
:nfsd:nfsd_acceptable+0x0/0xd8
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff80021b1c>] __up_read+0x19/0x7f
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8003a051>] vfs_create+0xe6/0x158
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff88570a07>]
:nfsd:nfsd_create_v3+0x2c9/0x412
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8857642d>]
:nfsd:nfsd3_proc_create+0x12f/0x140
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856b1db>]
:nfsd:nfsd_dispatch+0xd8/0x1d6
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8838b48b>]
:sunrpc:svc_process+0x454/0x71b
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff800646f5>] __down_read+0x12/0x92
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856b746>] :nfsd:nfsd+0x1a5/0x2cb
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8856b5a1>] :nfsd:nfsd+0x0/0x2cb
Jul 11 04:04:14 qanfs2 kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Jul 11 04:04:15 qanfs2 kernel:
Jul 11 04:04:15 qanfs2 kernel: xfs_force_shutdown(dm-5,0x8) called
from line 1139 of file /home/buildsvn/rpmbuild/BUILD/xfs-km
od-0.4/_kmod_build_/xfs_trans.c.  Return address = 0xffffffff88512941
Jul 11 04:04:15 qanfs2 kernel: Filesystem "dm-5": Corruption of
in-memory data detected.  Shutting down filesystem: dm-5
Jul 11 04:04:15 qanfs2 kernel: Please umount the filesystem, and
rectify the problem(s)
Jul 11 04:04:15 qanfs2 kernel: nfsd: non-standard errno: -117
Jul 11 04:05:09 qanfs2 mountd[869]: couldn't open /var/lib/nfs/etab
Jul 11 04:06:36 qanfs2 kernel: svc: unknown version (0 for prog 100003 nfsd)

The closest post I could find on the problem was:
http://www.opensubscriber.com/message/xfs@oss.sgi.com/8729803.html

I don't think I am hitting the  directory corruption in Linux 2.6.17
since the kernel version is 2.6.18-128.1.10.el5, but maybe there is
something else?

The course of action I plan to take with confirmation is from the above post:

> > > To be on the safe side, either make an entire copy of your drive to
> > > another device, or run "xfs_metadump -o /dev/sda1" to capture
> > > a metadata (no file data) of your filesystem.
> > >
> > > Then run xfs_repair (mount/unmount maybe required if the log is dirty).

I can't make a copy of the data since it is 4+TB.   Can someone give
me an idea on the size of the file output from the xfs_metadump
command?

Also, If everything does wind up in lost+found after running
xfs_repair, is there an efficient way to put the files back in there
correct locations if the Filesystem can repaired?

We did have a split brain problem earlier in the week with heartbeat,
however, mounting of the disk after restart did not show any problems
at the time.

Thanks very much in advance for any assistance to correct this problem.

Thanks,

Lance

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
