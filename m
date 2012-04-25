Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3P87dOG166099 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 03:07:39 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	Lu1ksZ1x0mmIalNW (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Apr 2012 01:07:38 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so1738094ghb.26
	for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 01:07:37 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 10:07:37 +0200
Message-ID: <CAAxjCEzh3+doupD=LmgqSbCeYWzn9Ru-vE4T8tOJmoud+28FDQ@mail.gmail.com>
Subject: A little RAID experiment
From: Stefan Ring <stefanrin@gmail.com>
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

This grew out of the discussion in my other thread ("Abysmal write
performance because of excessive seeking (allocation groups to
blame?)") -- that should in fact have been called "Free space
fragmentation causes excessive seeks".

Could someone with a good hardware RAID (5 or 6, but also mirrored
setups would be interesting) please conduct a little experiment for
me?

I've put up a modified sysbench here:
<https://github.com/Ringdingcoder/sysbench>. This tries to simulate
the write pattern I've seen with XFS. It would be really interesting
to know how different RAID controllers cope with this.

- Checkout (or download tarball):
https://github.com/Ringdingcoder/sysbench/tarball/master
- ./configure --without-mysql && make
- fallocate -l 8g test_file.0
- ./sysbench/sysbench --test=fileio --max-time=15
--max-requests=10000000 --file-num=1 --file-extra-flags=direct
--file-total-size=8G --file-block-size=8192 --file-fsync-all=off
--file-fsync-freq=0 --file-fsync-mode=fdatasync --num-threads=1
--file-test-mode=ag4 run

If you don't have fallocate, you can also use the last line with "run"
replaced by "prepare" to create the file. Run the benchmark a few
times to check if the numbers are somewhat stable. When doing a few
runs in direct succession, the first one will likely be faster because
the cache has not been loaded up yet. The interesting part of the
output is this:

Read 0b  Written 64.516Mb  Total transferred 64.516Mb  (4.301Mb/sec)
  550.53 Requests/sec executed

That's a measurement from my troubled RAID 6 volume (SmartArray P400,
6x 10k disks).

>From the other controller in this machine (RAID 1, SmartArray P410i,
2x 15k disks), I get:

Read 0b  Written 276.85Mb  Total transferred 276.85Mb  (18.447Mb/sec)
 2361.21 Requests/sec executed

The better result might be caused by the better controller or the RAID
1, with the latter reason being more likely.

Regards,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
