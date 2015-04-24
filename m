Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 794AB7F50
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 05:41:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB07CAC001
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2015 03:41:02 -0700 (PDT)
Received: from edge20.ethz.ch (edge20.ethz.ch [82.130.99.26]) by cuda.sgi.com
	with ESMTP id FA28BFyDiyzUW4aR (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Apr 2015 03:41:00 -0700 (PDT)
Message-ID: <553A1DBA.9050104@cscs.ch>
Date: Fri, 24 Apr 2015 12:40:58 +0200
From: Matteo Chesi <chesi@cscs.ch>
MIME-Version: 1.0
Subject: Kernel Trace at boot on fs/xfs/linux-2.6/xfs_aops.c:1008
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
To: xfs@oss.sgi.com

Hi,

I am Matteo Chesi,

I am sorry to bother you, it's the first time I have an issue with XFS
and I don't know if it's correct to send you this kind of support request.

My issue is that I receive a kernel trace like this at every boot of my
machine:

------------[ cut here ]------------
WARNING: at fs/xfs/linux-2.6/xfs_aops.c:1008
xfs_vm_writepage+0x537/0x590 [xfs]() (Not tainted)
Hardware name: Altos R380 F2
Modules linked in: mmfs26(U) mmfslinux(U) tracedev(U) mgc(U) lustre(U)
lov(U) mdc(U) lquota(U) osc(U) ko2iblnd(U) ptlrpc(U) obdclass(U) lvfs(U)
lnet(U) libcfs(U) 8021q garp stp llc limic(U) nfs lockd fscache
auth_rpcgss nfs_acl cpufreq_ondemand acpi_cpufreq freq_table mperf xfs
exportfs ext3 jbd ipmi_devintf ipmi_msghandler xprtrdma svcrdma sunrpc
ib_ipoib ib_umad rdma_ucm ib_uverbs rdma_cm ib_cm iw_cm mlx4_ib ib_sa
ib_mad ib_core ib_addr ipv6 mlx4_en mlx4_core iTCO_wdt
iTCO_vendor_support rfkill microcode sg igb dca i2c_algo_bit ptp
pps_core sb_edac edac_core i2c_i801 i2c_core lpc_ich mfd_core shpchp
ext4 jbd2 mbcache raid1 sd_mod crc_t10dif isci libsas scsi_transport_sas
ahci wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
scsi_wait_scan]
Pid: 7211, comm: mmfsd Not tainted 2.6.32-504.12.2.el6.x86_64 #1
Call Trace:
 [<ffffffff81074df7>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81074e4a>] ? warn_slowpath_null+0x1a/0x20
 [<ffffffffa04e00a7>] ? xfs_vm_writepage+0x537/0x590 [xfs]
 [<ffffffff81124d2a>] ? generic_file_buffered_write+0x1da/0x2e0
 [<ffffffff81123d80>] ? find_get_pages_tag+0x40/0x130
 [<ffffffff81138077>] ? __writepage+0x17/0x40
 [<ffffffff8113933d>] ? write_cache_pages+0x1fd/0x4c0
 [<ffffffffa04e4e54>] ? xfs_file_buffered_aio_write+0x144/0x1b0 [xfs]
 [<ffffffff81138060>] ? __writepage+0x0/0x40
 [<ffffffff8118ffdd>] ? __sb_end_write+0x3d/0x70
 [<ffffffffa04e501c>] ? xfs_file_aio_write+0x15c/0x190 [xfs]
 [<ffffffff81139624>] ? generic_writepages+0x24/0x30
 [<ffffffffa04df0ad>] ? xfs_vm_writepages+0x5d/0x80 [xfs]
 [<ffffffff81139651>] ? do_writepages+0x21/0x40
 [<ffffffff81124abb>] ? __filemap_fdatawrite_range+0x5b/0x60
 [<ffffffff81124b1a>] ? filemap_write_and_wait_range+0x5a/0x90
 [<ffffffff811c084e>] ? vfs_fsync_range+0x7e/0x100
 [<ffffffff811c093d>] ? vfs_fsync+0x1d/0x20
 [<ffffffff811c097e>] ? do_fsync+0x3e/0x60
 [<ffffffff811c09d0>] ? sys_fsync+0x10/0x20
 [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b
---[ end trace 20acc50915714a05 ]---

My kernel is: 2.6.32-504.16.2.el6.x86_64 (from a just updated Centos 6.6)

I would like to understand what it could be the issue.

Thanks In Advance for any answer,

Best Regards,
Matteo Chesi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
