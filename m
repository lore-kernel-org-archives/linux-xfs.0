Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41F5wQS180939 for <xfs@oss.sgi.com>; Sun, 1 May 2011 10:05:58 -0500
Received: from hermes2.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DDB5424694
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 08:09:32 -0700 (PDT)
Received: from hermes2.dur.ac.uk (hermes2.dur.ac.uk [129.234.248.2]) by
	cuda.sgi.com with ESMTP id HWlIbNG5lzFEuUj1 for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 08:09:32 -0700 (PDT)
Received: from smtphost1.dur.ac.uk (smtphost1.dur.ac.uk [129.234.252.1])
	by hermes2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41F9BSl032682
	for <xfs@oss.sgi.com>; Sun, 1 May 2011 16:09:15 +0100
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p41F8ufd031719
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 1 May 2011 16:08:56 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QGYGP-0004k4-Su
	for <xfs@oss.sgi.com>; Sun, 01 May 2011 16:08:50 +0100
MIME-Version: 1.0
Message-ID: <19901.30588.512362.651640@tree.ty.sabi.co.UK>
Date: Sun, 1 May 2011 16:08:44 +0100
Subject: Re: xfs performance problem
In-Reply-To: <19901.28769.553575.864887@tree.ty.sabi.co.UK>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
	<19898.53907.842827.480883@tree.ty.sabi.co.UK>
	<20110501084919.GE13542@dastard>
	<19901.28769.553575.864887@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>> [ ... Extracting a kernel 'tar' with GNU tar on 'ext3': ]
>>> real    0m21.769s
>> [ ... Extracting a kernel 'tar' with GNU tar on XFS: ]
>>> real    2m20.522s

>>> [ ... ] in most cases the wrong number is the one for 'ext3'
>>> on RAID1 (way too small). Even the number for XFS and RAID0
>>> 'delaylog' is a wrong number (somewhat small) in many cases.

[ ... ]

>   % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
>   % time sh -c 'cd /mnt/sdb; star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
>   star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

>   real    12m49.610s
>   user    0m0.990s
>   sys     0m8.610s

[ ... ]

> In this discussion it is rather comical to make an argument
> based on the speed of IO using what is in effect EatMyData as
> described here:

>   http://talk.maemo.org/showthread.php?t=67901

Just for confirmation here is the fantastic "performance" of
'ext3' with EatMyData:

  % mount -t ext3 -o relatime /dev/sdb /mnt/sdb
  % time sh -c 'cd /mnt/sdb; eatmydata star -x -b 2048 -f /tmp/linux-2.6.38.tar; cd /; umount /mnt/sdb'
  /bin/star: 420 blocks + 81920 bytes (total of 440483840 bytes = 430160.00k).

  real    0m28.917s
  user    0m0.310s
  sys     0m2.410s

Surprise surprise :-) the duration is much the same as GNU tar
or 'star' with '-no-fsync'.

Well, 'ext3' can do a rate a bit over 1,300 on a 100IOPS sort of
drive, but only in the EatMyData (plus 'umount') world not the
real world. That is where the 38,100 files are run in effect as
a single large commit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
