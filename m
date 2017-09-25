Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753094AbdIYBkJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 24 Sep 2017 21:40:09 -0400
Date: Mon, 25 Sep 2017 09:40:06 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: ffsb job does not exit on xfs 4.14-rc1+
Message-ID: <20170925014006.5tvdkjszrbj6uhgc@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

ffsb test won't exit like this on Linus tree 4.14-rc1+.
Latest commit cd4175b11685

This does not happen on v4.13

Thanks,

    1  1505  Ss   0   0:00 /usr/sbin/sshd -D
 1505  1752  Ss   0   0:00  \_ sshd: root [priv]
 1752  1762  S    0   0:00  |   \_ sshd: root@pts/0
 1762  1763  Ss   0   0:00  |       \_ -bash
 1763  8706  S+   0   0:00  |           \_ /bin/bash -x ./run.sh --daxoff ffsb
 8706 10044  S+   0   0:00  |               \_ /bin/bash -x ./ffsb.sh xfs /dev/pmem0 /daxmnt 8099
10044 10053  S+   0   0:00  |                   \_ make run
10053 10056  S+   0   0:00  |                       \_ /bin/bash -x ./runtest.sh
10056 10167  Sl+  0 21171969:20  |                           \_ ffsb large_file_creates_threads_192.ffsb
10056 10168  S+   0   0:00  |                           \_ tee large_file_creates_threads_192.ffsb.out
.... 

sh-4.4# xfs_info /daxmnt/
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

sh-4.4# uname -r
4.14.0-rc1-master-cd4175b11685+

sh-4.4# xfs_io -V
xfs_io version 4.10.0

sh-4.4# ffsb -V
FFSB version 6.0-RC2 started
-V: No such file or directory


# cat large_file_creates_threads_192.ffsb

# Large file creates
# Creating 1 GB files.

time=300
alignio=1
directio=0

[filesystem0]
	location=__SCRATCH_MNT__

	# All created files will be 1 GB.
	min_filesize=1GB
	max_filesize=1GB
[end0]

[threadgroup0]
	num_threads=192

	create_weight=1

	write_blocksize=4KB

	[stats]
		enable_stats=1
		enable_range=1

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]
