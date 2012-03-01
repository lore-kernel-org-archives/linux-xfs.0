Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q218I6Xs092815 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 02:18:06 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id bBF35Zkcbx0d9Yg1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 00:18:04 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B661580.133058965824549@bugs.debian.org>
MIME-Version: 1.0
From: Goswin von Brederlow <goswin-v-b@web.de>
Message-ID: <20120301081409.3103.43155.reportbug@frosties.localnet>
Date: Thu, 01 Mar 2012 09:14:09 +0100
Reply-To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
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
To: Debian Bug Tracking System <661580@bugs.debian.org>

Package: xfsprogs
Version: 3.1.7
Followup-For: Bug #661580

Hi again,

I've patched the NBD driver to set the physical sector size. Was way
easier than I imagined:

----------------------------------------------------------------------
--- linux/drivers/block/nbd.c~      2012-03-01 09:10:35.000000000 +0100
+++ linux/drivers/block/nbd.c       2012-03-01 08:57:49.000000000 +0100
@@ -413,6 +413,9 @@
                return ret;
        }
 
+       /* Set physical block size to blocksize */
+       blk_queue_physical_block_size(lo->disk->queue, lo->blksize);
+
        while ((req = nbd_read_stat(lo)) != NULL)
                nbd_end_request(req);
 
----------------------------------------------------------------------

And I can confirm that the sector size detection is still broken in
3.1.7.

root@frosties:~$ parted /dev/nbd0
GNU Parted 2.3
Using /dev/nbd0
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p                                                                
Model: Unknown (unknown)
Disk /dev/nbd0: 16.8MB
Sector size (logical/physical): 512B/4096B
Partition Table: loop

Number  Start  End     Size    File system  Flags
 1      0.00B  16.8MB  16.8MB  xfs

(parted) q                                                                
root@frosties:~$ mkfs.xfs -f /dev/nbd0 
meta-data=/dev/nbd0              isize=256    agcount=1, agsize=4096 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=4096, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

mrvn@frosties:~% tail /sys/block/nbd0/queue/*
==> /sys/block/nbd0/queue/add_random <==
1

==> /sys/block/nbd0/queue/discard_granularity <==
0

==> /sys/block/nbd0/queue/discard_max_bytes <==
0

==> /sys/block/nbd0/queue/discard_zeroes_data <==
0

==> /sys/block/nbd0/queue/hw_sector_size <==
512

==> /sys/block/nbd0/queue/iosched <==
tail: error reading `/sys/block/nbd0/queue/iosched': Is a directory

==> /sys/block/nbd0/queue/iostats <==
1

==> /sys/block/nbd0/queue/logical_block_size <==
512

==> /sys/block/nbd0/queue/max_hw_sectors_kb <==
127

==> /sys/block/nbd0/queue/max_integrity_segments <==
0

==> /sys/block/nbd0/queue/max_sectors_kb <==
127

==> /sys/block/nbd0/queue/max_segment_size <==
65536

==> /sys/block/nbd0/queue/max_segments <==
128

==> /sys/block/nbd0/queue/minimum_io_size <==
4096

==> /sys/block/nbd0/queue/nomerges <==
0

==> /sys/block/nbd0/queue/nr_requests <==
128

==> /sys/block/nbd0/queue/optimal_io_size <==
0

==> /sys/block/nbd0/queue/physical_block_size <==
4096

==> /sys/block/nbd0/queue/read_ahead_kb <==
128

==> /sys/block/nbd0/queue/rotational <==
0

==> /sys/block/nbd0/queue/rq_affinity <==
1

==> /sys/block/nbd0/queue/scheduler <==
noop deadline [cfq] 


MfG
	Goswin

-- System Information:
Debian Release: wheezy/sid
  APT prefers unstable
  APT policy: (500, 'unstable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.1.0-1-amd64 (SMP w/4 CPU cores)
Locale: LANG=C, LC_CTYPE=de_DE (charmap=ISO-8859-1)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1     2.20.1-1
ii  libc6         2.13-21 
ii  libreadline5  5.2-11  
ii  libuuid1      2.19.1-5

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl      2.2.51-4  
pn  attr     1:2.4.46-3
pn  quota    <none>    
pn  xfsdump  <none>    

-- no debconf information


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
