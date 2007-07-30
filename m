Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 07:29:27 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6UETKbm006758
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 07:29:24 -0700
Date: Mon, 30 Jul 2007 10:29:23 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
 software raid 5
Message-ID: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org

CONFIG:

Software RAID 5 (400GB x 6): Default mkfs parameters for all filesystems.
Kernel was 2.6.21 or 2.6.22, did these awhile ago.
Hardware was SATA with PCI-e only, nothing on the PCI bus.

ZFS was userspace+fuse of course.
Reiser was V3.
EXT4 was created using the recommended options on its project page.

RAW:

ext2,7760M,56728,96.3333,180505,51,85484,17.3333,50946.7,80.3333,235541,21.3333,373.667,0,16:100000:16/64,2354,27,0,0,8455.67,14.6667,2211.67,26.3333,0,0,9724,22.3333
ext3,7760M,52702.7,94.3333,165005,60,82294.7,20.6667,52664,83.6667,258788,33.3333,335.8,0,16:100000:16/64,858.333,10.6667,10250.3,28.6667,4084,15,897,12.6667,4024.33,12.3333,2754,11.3333
ext4,7760M,53129.7,95,164515,59.3333,101678,31.6667,62194.3,98.6667,266716,22.3333,405.767,0,16:100000:16/64,1963.67,23.6667,0,0,20859,73.6667,1731,21.3333,9022,23.6667,16410,65.6667
jfs,7760M,54606,92,191997,52,112764,33.6667,63585.3,99,274921,22.3333,383.8,0,16:100000:16/64,344,1,0,0,539.667,0,297.667,1,0,0,340,0
reiserfs,7760M,51056.7,96,180607,67,106907,38.3333,61231.3,97.6667,275339,29.3333,441.167,0,16:100000:16/64,2516,60.6667,19174.3,60.6667,8194.33,54.3333,2011,42.6667,6963.67,19.6667,9168.33,68.6667
xfs,7760M,52985.7,93,158342,45,79682,14,60547.3,98,239101,20.3333,359.667,0,16:100000:16/64,415,4,0,0,1774.67,10.6667,454,4.66667,14526.3,40,1572,12.6667
zfs,7760M,25601,43.3333,32198.7,4,13266.3,2,44145.3,68.6667,129278,9,245.167,0,16:100000:16/64,218.333,2,2698.33,11.6667,7434.67,14.3333,244,2,2191.33,11.6667,5613.33,13.3333

HTML

http://home.comcast.net/~jpiszcz/benchmark/allfs.html

THOUGHTS

Overall JFS seems the fastest but reviewing the mailing list for JFS it 
seems like there a lot of problems, especially when people who use JFS > 1 
year, their speed goes to 5 MiB/s over time and the defragfs tool has been 
removed(?) from the source/Makefile and on Google it says not to use it 
due to corruption.

Justin.
