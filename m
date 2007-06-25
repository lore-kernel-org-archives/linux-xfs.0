Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 01:06:45 -0700 (PDT)
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P86bdo032264
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 01:06:38 -0700
Received: from [192.168.4.111] (unknown [192.168.4.111])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp22.sauce.co.nz (Postfix) with ESMTP id 2506028825B
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 12:59:57 +1200 (NZST)
Message-ID: <467F144F.3020804@sauce.co.nz>
Date: Mon, 25 Jun 2007 13:03:11 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: sunit-swidth parameters
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I am under the impression that mkfs.xfs is able to obtain details from 
the Linux md subsystem, such that it will automatically  create  the 
optimal sunit and swidth parameters, to suit an md RAID array on which 
the filesystem is being created.

Please correct me if I am wrong.

If this is the case, then I am a little confused by the following:

mkfs.xfs -f -l logdev=/dev/md1,size=10000b /dev/md5

meta-data=/dev/md5               isize=256    agcount=32, agsize=7630656 
blks
          =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=244179840, imaxpct=25
          =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096
log      =/dev/md1               bsize=4096   blocks=10000, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=524288 blocks=0, rtextents=0

This is the output where /dev/md5 is a 3 disk RAID5, with a chunk size 
of 128kB.

After reading the man page and looking at some examples in the mailing 
list archives, I would have thought that the best  sizes would have been 
sunit=32 and swidth=64, or am I wrong?

I ask, as I am about to resize this array by adding another drive and am 
trying to work out the new values for these parameters, to pass to mount 
- the values I have come up with are sunit=256 and swidth=768.

Thanks,

Richard
