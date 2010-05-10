Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AEpnw3008158 for <xfs@oss.sgi.com>; Mon, 10 May 2010 09:51:50 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2201B3291F4
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 07:54:01 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id G6WGz4EFDLvqIAYX for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 07:54:01 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1OBUMq-0005Il-Tv
	for xfs@oss.sgi.com; Mon, 10 May 2010 07:54:00 -0700
Message-ID: <28512276.post@talk.nabble.com>
Date: Mon, 10 May 2010 07:54:00 -0700 (PDT)
From: stress_buster <leo1783@yahoo.com>
Subject: bad primary superblock - bad magic number !!!
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


my hp proliant DL185 server hangs/crashes and sometimes do not boot
correctly...

[root@localhost dev]# xfs_repair -n /dev/cciss/c0d0p1
Phase 1 - find and verify superblock...
bad primary superblock - bad magic number !!!

attempting to find secondary superblock...
.....................................................................................Sorry,
could not find valid secondary superblock
Exiting now.

[root@localhost dev]# xfs_repair -n /dev/cciss/c0d2
Phase 1 - find and verify superblock...
superblock read failed, offset 0, size 524288, ag 0, rval -1

fatal error -- Input/output error


[root@localhost dev]# xfs_db /dev/cciss/c0d0p1
xfs_db: /dev/cciss/c0d0p1 is not a valid XFS filesystem (unexpected SB magic
number 0x00000000)

The next time, server didnt even boot up alright

i've managed to capture the msgs & traces dumped to console. See below


end_request: I/O error, dev cciss/c0d2, sector 0
end_request: I/O error, dev cciss/c0d2, sector 0
end_request: I/O error, dev cciss/c0d2, sector 1
Quote:
ciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
end_request: I/O error, dev cciss/c0d3, sector 0
cciss: cmd f6c00000 has CHECK CONDITION sense key = 0x4
end_request: I/O error, dev cciss/c0d3, sector 0

backtrace from SysRq -w

SysRq : Show Blocked State
f7ad1e40 00203082 f7853b90 e54af7f0 e54af948 cba30e00 00000001 00000020
e5ad2250 00000000 000000ff e5ad2250 00000000 00000000 00000000 7fffffff
e55afe00 e55afd44 e55afe04 c05ab1c5 256e2000 00000000 e56e2000 00000000
Call Trace:
[<c05ab1c5>] schedule_timeout+0x13/0x86
[<c05ab095>] wait_for_common+0xb9/0x103
[<c021a4b6>] default_wake_function+0x0/0x8
[<c0409473>] cciss_ioctl+0x6fb/0xd1e
[<c0207852>] read_tsc+0x6/0x22
[<c02335a6>] getnstimeofday+0x4a/0xca
[<c023618a>] tick_dev_program_event+0x1e/0x8c
[<c026c316>] dput+0x31/0xf7
[<c026570c>] __link_path_walk+0x9fd/0xb2b
[<c038442f>] blkdev_driver_ioctl+0x4b/0x5b
[<c054420b>] igmp_rcv+0x38f/0x496
[<c0384ad6>] blkdev_ioctl+0x697/0x6e5
[<c054420b>] igmp_rcv+0x38f/0x496
[<c054420b>] igmp_rcv+0x38f/0x496
[<c027e02d>] do_open+0x1d9/0x258
[<c027e21a>] blkdev_open+0x0/0x4d
[<c027e23f>] blkdev_open+0x25/0x4d
[<c025c3a5>] __dentry_open+0x13b/0x212
[<c025c498>] nameidata_to_filp+0x1c/0x2c
[<c02667c3>] do_filp_open+0x350/0x64d
[<c023786c>] do_futex+0x8a/0x6ee
[<c024feaa>] handle_mm_fault+0x4e0/0x4ea
[<c054420b>] igmp_rcv+0x38f/0x496
[<c027d871>] block_ioctl+0x13/0x16
[<c027d85e>] block_ioctl+0x0/0x16
[<c026744c>] vfs_ioctl+0x1c/0x5d
[<c02676c6>] do_vfs_ioctl+0x239/0x247
[<c025c203>] do_sys_open+0xae/0xb6
[<c0267715>] sys_ioctl+0x41/0x58
[<c0203759>] sysenter_do_call+0x12/0x25
[<c054420b>] igmp_rcv+0x38f/0x496

Plz help.....

Thanks in advance,
David
ub007 is offline   	Click here to find out more!
-- 
View this message in context: http://old.nabble.com/bad-primary-superblock---bad-magic-number-%21%21%21-tp28512276p28512276.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
