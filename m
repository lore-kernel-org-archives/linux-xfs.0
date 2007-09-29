Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 10:08:51 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TH8k2d031926
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 10:08:47 -0700
Date: Sat, 29 Sep 2007 13:08:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Bonnie++ with 1024k stripe SW/RAID5 causes kernel to goto D-state
Message-ID: <Pine.LNX.4.64.0709291306320.4569@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

Kernel: 2.6.23-rc8 (older kernels do this as well)

When running the following command:
/usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 16:100000:16:64

It hangs unless I increase various parameters md/raid such as the 
stripe_cache_size etc..

# ps auxww | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       276  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
root       277  0.0  0.0      0     0 ?        D    12:14   0:00 [pdflush]
root      1639  0.0  0.0      0     0 ?        D<   12:14   0:00 [xfsbufd]
root      1767  0.0  0.0   8100   420 ?        Ds   12:14   0:00 
root      2895  0.0  0.0   5916   632 ?        Ds   12:15   0:00 /sbin/syslogd -r

See the bottom for more details.

Is this normal?  Does md only work without tuning up to a certain stripe 
size? I use a RAID 5 with 1024k stripe which works fine with many 
optimizations, but if I just boot the system and run bonnie++ on it 
without applying the optimizations, it will hang in d-state.  When I run 
the optimizations, then it exits out of D-state, pretty weird?

(again, without this, bonnie++ will hang in d-state.. until this is run)

Optimization script:

#!/bin/bash

# source profile
. /etc/profile

# Tell user what's going on.
echo "Optimizing RAID Arrays..."

# Define DISKS.
cd /sys/block
DISKS=$(/bin/ls -1d sd[a-z])

# This step must come first.
# See: http://www.3ware.com/KB/article.aspx?id=11050
echo "Setting max_sectors_kb to 128 KiB"
for i in $DISKS
do
   echo "Setting /dev/$i to 128 KiB..."
   echo 128 > /sys/block/"$i"/queue/max_sectors_kb
done

# This step comes next.
echo "Setting nr_requests to 512 KiB"
for i in $DISKS
do
   echo "Setting /dev/$i to 512K KiB"
   echo 512 > /sys/block/"$i"/queue/nr_requests
done

# Set read-ahead.
echo "Setting read-ahead to 64 MiB for /dev/md3"
blockdev --setra 65536 /dev/md3

# Set stripe-cache_size for RAID5.
echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

# Set minimum and maximum raid rebuild speed to 30MB/s.
echo "Setting minimum and maximum resync speed to 30 MiB/s..."
echo 30000 > /sys/block/md0/md/sync_speed_min
echo 30000 > /sys/block/md0/md/sync_speed_max
echo 30000 > /sys/block/md1/md/sync_speed_min
echo 30000 > /sys/block/md1/md/sync_speed_max
echo 30000 > /sys/block/md2/md/sync_speed_min
echo 30000 > /sys/block/md2/md/sync_speed_max
echo 30000 > /sys/block/md3/md/sync_speed_min
echo 30000 > /sys/block/md3/md/sync_speed_max

# Disable NCQ on all disks.
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done

--

Once this runs, everything works fine again.

--

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Wed Aug 22 10:38:53 2007
      Raid Level : raid5
      Array Size : 1318680576 (1257.59 GiB 1350.33 GB)
   Used Dev Size : 146520064 (139.73 GiB 150.04 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sat Sep 29 13:05:15 2007
           State : active, resyncing
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 1024K

  Rebuild Status : 8% complete

            UUID : e37a12d1:1b0b989a:083fb634:68e9eb49 (local to host p34.internal.lan)
          Events : 0.4211

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       8       81        3      active sync   /dev/sdf1
        4       8       97        4      active sync   /dev/sdg1
        5       8      113        5      active sync   /dev/sdh1
        6       8      129        6      active sync   /dev/sdi1
        7       8      145        7      active sync   /dev/sdj1
        8       8      161        8      active sync   /dev/sdk1
        9       8      177        9      active sync   /dev/sdl1

--

NOTE: This bug is reproducible every time:

Example:

$ /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 
16:100000:16:64
Writing with putc()...

It writes for 4-5 minutes and then...... SILENCE + D-STATE, I was too late 
this time :(

$ ps auxww | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       276  1.2  0.0      0     0 ?        D    12:50   0:03 [pdflush]
root      2901  0.0  0.0   5916   632 ?        Ds   12:50   0:00 /sbin/syslogd -
r
user       4571 48.0  0.0  11644  1084 pts/1    D+   12:51   1:55 /usr/sbin/bonn
ie++ -d /x/test -s 16384 -m p34 -n 16:100000:16:64
root      4612  1.0  0.0      0     0 ?        D    12:52   0:01 [pdflush]
root      4624  5.0  0.0  40964  7436 ?        D    12:55   0:00 /usr/bin/perl -
w /app/rrd-cputemp/bin/rrd_cputemp.pl
root      4684  0.0  0.0  31968  1416 ?        D    12:55   0:00 /usr/bin/rateup
  /var/www/monitor/mrtg/ eth0 1191084902 -Z u 265975 843609 125000000 c #00cc00 #
0000ff #006600 #ff00ff k 1000 i /var/www/monitor/mrtg/eth0-day.png -125000000 -1
25000000 400 100 1 1 1 300 0 4 1 %Y-%m-%d %H:%M 0 i /var/www/monitor/mrtg/eth0-w
eek.png -125000000 -125000000 400 100 1 1 1 1800 0 4 1 %Y-%m-%d %H:%M 0 i /var/w
ww/monitor/mrtg/eth0-month.png -125000000 -125000000 400 100 1 1 1 7200 0 4 1 %Y
-%m-%d %H:%M 0
root      4686  0.0  0.0   4420   932 ?        D    12:55   0:00 /usr/sbin/hddte
mp -n /dev/sdf
user       4688  0.0  0.0   4232   800 pts/5    S+   12:55   0:00 grep --color D
$

If you are not logged as root already, it is sometimes too late to su to root
and run the optimizations:

$ su -
Password: 
<hang forever>

Justin.
