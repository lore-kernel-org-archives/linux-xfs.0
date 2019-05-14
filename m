Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49624 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726571AbfENXb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 May 2019 19:31:26 -0400
Date: Wed, 15 May 2019 09:31:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
Message-ID: <20190514233119.GS29573@dread.disaster.area>
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514185026.73788-1-jorgeguerra@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jorge Guerra <jorge.guerra@gmail.com>
Cc: linux-xfs@vger.kernel.org, osandov@osandov.com, Jorge Guerra <jorgeguerra@fb.com>

On Tue, May 14, 2019 at 11:50:26AM -0700, Jorge Guerra wrote:
> From: Jorge Guerra <jorgeguerra@fb.com>
> 
> In this change we add two feature to the xfs_db 'frag' command:
> 
> 1) Extent count histogram [-e]: This option enables tracking the
>    number of extents per inode (file) as the we traverse the file
>    system.  The end result is a histogram of the number of extents per
>    file in power of 2 buckets.
> 
> 2) File size histogram and file system internal fragmentation stats
>    [-s]: This option enables tracking file sizes both in terms of what
>    has been physically allocated and how much has been written to the
>    file.  In addition, we track the amount of internal fragmentation
>    seen per file.  This is particularly useful in the case of real
>    time devices where space is allocated in units of fixed sized
>    extents.

I can see the usefulness of having such information, but xfs_db is
the wrong tool/interface for generating such usage reports.

> The man page for xfs_db has been updated to reflect these new command
> line arguments.
> 
> Tests:
> 
> We tested this change on several XFS file systems with different
> configurations:
> 
> 1) regular XFS:
> 
> [root@m1 ~]# xfs_info /mnt/d0
> meta-data=/dev/sdb1              isize=256    agcount=10, agsize=268435455 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=2441608704, imaxpct=100
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> [root@m1 ~]# echo "frag -e -s" | xfs_db -r /dev/sdb1
> xfs_db> actual 494393, ideal 489246, fragmentation factor 1.04%

For example, xfs_db is not the right tool for probing online, active
filesystems. It is not coherent with the active kernel filesystem,
and is quite capable of walking off into la-la land as a result of
mis-parsing the inconsistent filesystem that is on disk underneath
active mounted filesystems. This does not make for a robust, usable
tool, let alone one that can make use of things like rmap for
querying usage and ownership information really quickly.

To solve this problem, we now have the xfs_spaceman tool and the
GETFSMAP ioctl for running usage queries on mounted filesystems.
That avoids all the coherency and crash problems, and for rmap
enabled filesystems it does not require scanning the entire
filesystem to work out this information (i.e. it can all be derived
from the contents of the rmap tree).

So I'd much prefer that new online filesystem queries go into
xfs-spaceman and use GETFSMAP so they can be accelerated on rmap
configured filesystems rather than hoping xfs_db will parse the
entire mounted filesystem correctly while it is being actively
changed...

> Maximum extents in a file 14
> Histogram of number of extents per file:
>     bucket =       count        % of total
> <=       1 =      350934        97.696 %
> <=       2 =        6231        1.735 %
> <=       4 =        1001        0.279 %
> <=       8 =         953        0.265 %
> <=      16 =          92        0.026 %
> Maximum file size 26.508 MB
> Histogram of file size:
>     bucket =    allocated           used        overhead(bytes)
> <=    4 KB =           0              62           314048512 0.13%
> <=    8 KB =           0          119911        127209263104 53.28%
> <=   16 KB =           0           14543         15350194176 6.43%
> <=   32 KB =         909           12330         11851161600 4.96%
> <=   64 KB =          92            6704          6828642304 2.86%
> <=  128 KB =           1            7132          6933372928 2.90%
> <=  256 KB =           0           10013          8753799168 3.67%
> <=  512 KB =           0           13616          9049227264 3.79%
> <=    1 MB =           1           15056          4774912000 2.00%
> <=    2 MB =      198662           17168          9690226688 4.06%
> <=    4 MB =       28639           21073         11806654464 4.94%
> <=    8 MB =       35169           29878         14200553472 5.95%
> <=   16 MB =       95667           91633         11939287040 5.00%
> <=   32 MB =          71              62            28471742 0.01%
> capacity used (bytes): 1097735533058 (1022.346 GB)
> capacity allocated (bytes): 1336497410048 (1.216 TB)
> block overhead (bytes): 238761885182 (21.750 %)

BTW, "bytes" as a display unit is stupidly verbose and largely
unnecessary. The byte count is /always/ going to be a multiple of
the filesystem block size, and the first thing anyone who wants to
use this for diagnosis is going to have to do is return the byte
count to filesystem blocks (which is what the filesystem itself
tracks everything in. ANd then when you have PB scale filesystems,
anything more than 3 significant digits is just impossible to read
and compare - that "overhead" column (what the "overhead" even
mean?) is largely impossible to read and determine what the actual
capacity used is without counting individual digits in each number.

FWIW, we already have extent histogram code in xfs_spaceman
(in spaceman/freesp.c) and in xfs_db (db/freesp.c) so we really
don't need re-implementation of the same functionality we already
have duplicate copies of. I'd suggest that the histogram code should
be factored and moved to libfrog/ and then enhanced if new histogram
functionality is required...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
