Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CCD307CAF
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 07:27:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4628BAC002
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 05:27:40 -0700 (PDT)
Received: from mcgraw.st-andrews.ac.uk (mcgraw.st-andrews.ac.uk
	[138.251.8.95]) by cuda.sgi.com with ESMTP id JfZO0qHUgyzfzvoA
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 05:27:36 -0700 (PDT)
Received: from wallace.st-andrews.ac.uk (wallace.st-andrews.ac.uk
	[138.251.9.23])
	by mcgraw.st-andrews.ac.uk (8.14.9/8.14.9/Debian-4~bpo0+uos) with ESMTP
	id u6ECRULC032528
	(version=TLSv1/SSLv3 cipher=ADH-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 12:27:32 GMT
Received: from [138.251.201.65] (becks.mcs.st-and.ac.uk [138.251.201.65])
	(authenticated bits=0)
	by wallace.st-andrews.ac.uk (8.14.9/8.14.9/Debian-4~bpo0+uos) with
	ESMTP id u6ECRMMa020425
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 12:27:23 GMT
From: Steve Brooks <sjb14@st-andrews.ac.uk>
Subject: Advice needed with file system corruption
Message-ID: <5787852A.7030900@st-andrews.ac.uk>
Date: Thu, 14 Jul 2016 13:27:22 +0100
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi All,

We have a RAID system with file system issues as follows,

50 TB in RAID 6 hosted on an Adaptec 71605 controller using WD4000FYYZ 
drives.

Centos 6.7  2.6.32-642.el6.x86_64   :   xfsprogs-3.1.1-16.el6

While rebuilding a replaced disk, with the file system online and in 
use, the system logs showed multiple entries of;

XFS (sde): Corruption detected. Unmount and run xfs_repair.

[See also at the end of post for a section of XFS related errors in the log]

I unmounted the filesystem and waited for the controller to finish 
rebuilding the array. I then moved the most important data to another 
RAID array on a different server. The data is generated from HPC 
simulations and is not backed up but can be regenerated in needed.

The default el6 "xfs_repair" is in "xfsprogs-3.1.1-16.el6". I notice 
that the "elrepo_testing" repository has a much later version of 
"xfsprogs" namely

  xfsprogs.x86_64 4.3.0-1.el6.elrepo

As far as I understand the user based tools are backwards compatible so 
would it be better to use the "4.3" release of "xfsprogs"instead of the 
default "3.1.1" included in the installation of el6?

I ran an "xfs_repair -nv /dev/sde" for both "3.1.1" and "4.3" and both 
completed successfully showing the repairs that would have taken place. 
I can post these if requested.

The "3.1.1"  version of "xfs_repair -n" ran in 1 minute, 32 seconds

The "4.3"     version of "xfs_repair -n" ran in 50 seconds


So my questions are

[1] Which version of "xfs_repair" should I use to make the repair?

[2] Is there anything I should have done differently?


Many thanks for any advice given it is much appreciated.

Thanks,  Steve



Many blocks (about 20) of code similar to this were repeated in the logs.

Jul  8 18:40:17 sraid1v kernel: ffff880dca95b000: 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00  ................
Jul  8 18:40:17 sraid1v kernel: XFS (sde): Internal error 
xfs_da_do_buf(2) at line 2136 of file fs/xfs/xfs_da_btree.c. Caller 
0xffffffffa0e6e81a
Jul  8 18:40:17 sraid1v kernel:
Jul  8 18:40:17 sraid1v kernel: Pid: 8844, comm: idl Tainted: 
P           -- ------------    2.6.32-642.el6.x86_64 #1
Jul  8 18:40:17 sraid1v kernel: Call Trace:
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e7b68f>] ? 
xfs_error_report+0x3f/0x50 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ? 
xfs_da_read_buf+0x2a/0x30 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e7b6fe>] ? 
xfs_corruption_error+0x5e/0x90 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e6fc>] ? 
xfs_da_do_buf+0x6cc/0x770 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ? 
xfs_da_read_buf+0x2a/0x30 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffff810154e3>] ? 
native_sched_clock+0x13/0x80
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e6e81a>] ? 
xfs_da_read_buf+0x2a/0x30 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74a21>] ? 
xfs_dir2_leaf_lookup_int+0x61/0x2c0 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74a21>] ? 
xfs_dir2_leaf_lookup_int+0x61/0x2c0 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e74e05>] ? 
xfs_dir2_leaf_lookup+0x35/0xf0 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e71306>] ? 
xfs_dir2_isleaf+0x26/0x60 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e71ce4>] ? 
xfs_dir_lookup+0x174/0x190 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e9ea47>] ? 
xfs_lookup+0x87/0x110 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0eabd74>] ? 
xfs_vn_lookup+0x54/0xa0 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811a9ca5>] ? do_lookup+0x1a5/0x230
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811aa823>] ? 
__link_path_walk+0x763/0x1060
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ab3da>] ? path_walk+0x6a/0xe0
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ab5eb>] ? 
filename_lookup+0x6b/0xc0
Jul  8 18:40:17 sraid1v kernel: [<ffffffff8123ac46>] ? 
security_file_alloc+0x16/0x20
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811acac4>] ? 
do_filp_open+0x104/0xd20
Jul  8 18:40:17 sraid1v kernel: [<ffffffffa0e9a4fc>] ? 
_xfs_trans_commit+0x25c/0x310 [xfs]
Jul  8 18:40:17 sraid1v kernel: [<ffffffff812a749a>] ? 
strncpy_from_user+0x4a/0x90
Jul  8 18:40:17 sraid1v kernel: [<ffffffff811ba252>] ? alloc_fd+0x92/0x160
Jul  8 18:40:17 sraid1v kernel: [<ffffffff81196bd7>] ? 
do_sys_open+0x67/0x130
Jul  8 18:40:17 sraid1v kernel: [<ffffffff81196ce0>] ? sys_open+0x20/0x30
Jul  8 18:40:17 sraid1v kernel: [<ffffffff8100b0d2>] ? 
system_call_fastpath+0x16/0x1b
Jul  8 18:40:17 sraid1v kernel: XFS (sde): Corruption detected. Unmount 
and run xfs_repair
Jul  8 18:40:17 sraid1v kernel: ffff880dca95b000: 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00  ................
Jul  8 18:40:17 sraid1v kernel: XFS (sde): Internal error 
xfs_da_do_buf(2) at line 2136 of file fs/xfs/xfs_da_btree.c. Caller 
0xffffffffa0e6e81a
Jul  8 18:40:17 sraid1v kernel:
Jul  8 18:40:17 sraid1v kernel: Pid: 8844, comm: idl Tainted: 
P           -- ------------    2.6.32-642.el6.x86_64 #1







_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
