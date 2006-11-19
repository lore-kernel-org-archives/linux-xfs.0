Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Nov 2006 11:40:01 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAJJdqaG016791
	for <xfs@oss.sgi.com>; Sun, 19 Nov 2006 11:39:53 -0800
Message-ID: <4560AB84.9060200@sandeen.net>
Date: Sun, 19 Nov 2006 13:07:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: New CentOS4/RHEL4-compatible xfs module rpms
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: centos-devel@centos.org

http://sandeen.net/rhel4_xfs/kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm

rpmbuild --rebuild --target i686 
kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm

will build against the currently running kernel, or

rpmbuild --rebuild --target i686 --define "kernel_topdir 
/lib/modules/2.6.9-42.0.2.EL/build" 
kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm

will build against what is defined in kernel_topdir

you need matching kernel & kernel-devel rpms installed to build.

Changelog: mostly pulling in fixes sgi sent for sles9, plus specfile 
cleanups.

[root@sandeen rhel4_xfs]# rpm -qp --changelog 
kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm
* Mon Nov 13 2006 - sandeen-centos@sandeen.net

- removed xfs_direct_io_locking.patch, RHEL4U4 has the fix now.
- Update to xfs codebase from SLES9_SP3_BRANCH_20061107171129
- xfs-kern-26347a-fix-race-on-link: fix race on link
   (191713, SGI:PV953287).
- xfs-kern-26040a-do-not-dirty-inode-being-freed:
   Don't dirty the inode if it being freed in xfs_iunpin (179117,
   SGI:PV952967).
- xfs-kern-25687a-sles9sp3-iunpin-reclaim-fix: Fix
   an inode use-after-free during an unpin (SGI:PV946321, 142533).
- xfs-kern-930841-default_acl_enospc_fix:
   Default acl ENOSPC fix (133990, SGI:PV930841).
- xfs-kern-25238a-quota-trans-diag: quota trans diag
   (131262, SGI:PV931456).
- xfs-ftruncate-stale-data: XFS ftruncate() bug
   could expose stale data (151055).
- xfs-log-diag: log_runout_diagnostics (131262,
   SGI:PV947110).
- xfs-kern-202363a-fix-xfs_finish_reclaim_all-umount-deadlock:
   fix xfs_finish_reclaim_all umount deadlock (132358,
   SGI:PV943821).
- clean up specfile:
   default to building against running kernel
   try to match fedora conventions slightly better
   re-enable debuginfo pkg building, module stripping
   fix recognition of root on xfs, (grep -i XFS)
   remove unused -source subpackage

-Eric
