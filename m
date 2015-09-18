Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EB537F4E
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 06:06:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07854AC003
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 04:06:45 -0700 (PDT)
Received: from mail-yk0-f169.google.com (mail-yk0-f169.google.com
	[209.85.160.169]) by cuda.sgi.com with ESMTP id
	QEMVQBAosMBqkQGR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 18 Sep 2015 04:06:40 -0700 (PDT)
Received: by ykdu9 with SMTP id u9so43167660ykd.2
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 04:06:40 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Sep 2015 19:06:39 +0800
Message-ID: <CAPBX1xLUbxfSSK-SSKY-JtLyUpqZC7uB_iPY64ZuAEYD4KtM3w@mail.gmail.com>
Subject: How Can I Get Writeback Status When Running fs_mark
From: George Wang <xuw2015@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi, Dave,

I read the mail you post for "fs-writeback: drop wb->list_lock during
blk_finish_plug()",  and I
adore you very much.

I'm very curious that how you get the writeback status when running fs_mark.

I will appreciate very much if you can share the way you get writeback
status and iops, etc.
And maybe people in community can use this way to do the same tests as you.

The following is a part copy of the test result you got:

$ ~/tests/fsmark-10-4-test-xfs.sh
meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=131072, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

#  ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
/mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
/mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
/mnt/scratch/6  -d  /mnt/scratch/7
#       Version 3.3, 8 thread(s) starting at Thu Sep 17 08:08:36 2015
#       Sync method: NO SYNC: Test does not issue sync() or fsync() calls.
#       Directories:  Time based hash between directories across 10000
subdirectories with 180 seconds per subdirectory.
#       File names: 40 bytes long, (16 initial bytes of time stamp
with 24 random bytes at end of name)
#       Files info: size 4096 bytes, written with an IO size of 16384
bytes per write
#       App overhead is time in microseconds spent in the test not
doing file writing related system calls.

FSUse%        Count         Size    Files/sec     App Overhead
     0        80000         4096     106938.0           543310
     0       160000         4096     102922.7           476362
     0       240000         4096     107182.9           538206
     0       320000         4096     107871.7           619821
     0       400000         4096      99255.6           622021
     0       480000         4096     103217.8           609943
     0       560000         4096      96544.2           640988
     0       640000         4096     100347.3           676237
     0       720000         4096      87534.8           483495
     0       800000         4096      72577.5          2556920
     0       880000         4096      97569.0           646996

<RAM fills here, sustained performance is now dependent on writeback>

     0       960000         4096      80147.0           515679
     0      1040000         4096     100394.2           816979
     0      1120000         4096      91466.5           739009
     0      1200000         4096      85868.1           977506
     0      1280000         4096      89691.5           715207
     0      1360000         4096      52547.5           712810
     0      1440000         4096      47999.1           685282
     0      1520000         4096      47894.3           697261
     0      1600000         4096      47549.4           789977
     0      1680000         4096      40029.2           677885
     0      1760000         4096      16637.4         12804557
     0      1840000         4096      16883.6         24295975

thanks
George

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
