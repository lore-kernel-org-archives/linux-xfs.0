Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0V25DRw175611 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 20:05:13 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eqJrkPl0EiinNbZB for <xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 18:05:10 -0800 (PST)
Date: Tue, 31 Jan 2012 13:05:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131020508.GF9090@dastard>
References: <20120130220019.GA45782@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120130220019.GA45782@nsrc.org>
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
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 30, 2012 at 10:00:19PM +0000, Brian Candler wrote:
> I am doing some performance testing of XFS. I am using Ubuntu 11.10 amd64
> (server), on an i3-2130 (3.4GHz) with 8GB RAM.
> 
> This will eventually run with a bunch of Hitachi 3TB Deskstar drives, but
> the performance issue can be shown with just one.
> 
> Writing and reading large files using dd is fine. Performance is close to
> what I get if I dd to the drive itself (which is 125MB/sec near the start of
> the disk, down to 60MB/sec near the end of the disk, both reading and
> writing).
> 
> However I'm getting something strange when I try using bonnie++ to write and
> read a bunch of individual files - in this case 100,000 files with sizes
> between 500k and 800k, spread over 1000 directories.

Write order is different to read order, and read performance is
sensitive to cache hit rates and IO latency. When you working set is
larger than memory (which is definitely true here), read performance
will almost always be determined by read IO latency.

> # time bonnie++ -d /data/sdb -s 16384k -n 98:800k:500k:1000 -u root
> ...
> Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
> storage1        16G  1900  93 97299   3 49909   4  4899  96 139565   5 270.7   4
> Latency              5251us     222ms     394ms   10705us   94111us     347ms
> Version  1.96       ------Sequential Create------ --------Random Create--------
> storage1            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
> 98:819200:512000/1000   112   3    37   2 12659  32   106   3    39   2  8148  31
> Latency              6791ms     134ms   56383us    5161ms     459ms    3664ms
> 1.96,1.96,storage1,1,1327926367,16G,,1900,93,97299,3,49909,4,4899,96,139565,5,270.7,4,98,819200,512000,,1000,112,3,37,2,12659,32,106,3,39,2,8148,31,5251us,222ms,394ms,10705us,94111us,347ms,6791ms,134ms,56383us,5161ms,459ms,3664ms
> 
> real	129m3.450s
> user	0m6.684s
> sys	3m22.421s
> 
> Writing is fine: it writes about 110 files per second, and iostat shows
> about 75MB/sec of write data throughput during that phase.
>
> However when bonnie++ gets to the reading stage it reads only ~38 files per
> second, and iostat shows only about 22MB/sec of data being read from the
> disk.  There are about 270 disk operations per second seen at the time, so
> the drive is clearly saturated with seeks.  It seems to be doing about 7
> seeks for each stat+read. 

It's actually reading bits of the files, too, as your strace shows,
which is where most of the IO comes from.

So my desktop which is similar to yours except for the storage. It
has a pair of $150 SSDs in RAID-0.

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
disappointment  16G  1904  98 511102  26 182616  21  4623  99 348043  22  8367 201
Latency             10601us     283ms     250ms    5491us     156ms    8502us
Version  1.96       ------Sequential Create------ --------Random Create--------
disappointment      -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
98:819200:512000/1000   698  29   378  21 17257  89   699  29   370  21 13532  86
Latency              1421ms     278ms     145ms    1520ms     242ms     159ms
1.96,1.96,disappointment,1,1327963543,16G,,1904,98,511102,26,182616,21,4623,99,348043,22,8367,201,98,819200,512000,,1000,698,29,378,21,17257,89,699,29,370,21,13532,86,10601us,283ms,250ms,5491us,156ms,8502us,1421ms,278ms,145ms,1520ms,242ms,159ms

real    16m55.664s
user    0m6.708s
sys     4m8.468s

So, sequential write is 500MB/s read is 350MB/s, single threaded
seeks are ~10k/s and cpu bound. Creates are 700/s, read is 380/s and
deletes are 17,000/s. Random create/read/delete is roughly the same.

So as you can see, the read performance of your storage makes a big,
big difference to the results. The write performance is 5x faster
than your SATA drive, the read is only 3x faster, but the seeks are
40x faster. The result is that the seek intensive workload runs 10x
faster, and the overall benchmark run completes in only 10% of your
current runtime.

The big question is whether this bonnie++ workload reflects your
real workload? If not, then find a benchmark that is more closely
related to your application. If so, and the read performance is what
you really need maximised then you need to optimise your storage
architecture for minimising read latency, not write speed. That
means either lots of spindles, or high RPM drives or SSDs or some
combination of all three. There's nothing the filesystem can really
do to make it any faster than it already is...

> The filesystem was created like this:
> 
> # mkfs.xfs -i attr=2,maxpct=1 /dev/sdb

attr=2 is the default, and maxpct is a soft limit so the only reason
you would have to change it is if you need more indoes in teh
filesystem than it can support by default. Indeed, that's somewhere
around 200 million inodes per TB of disk space...

> P.S. When dd'ing large files ontp XFS I found that bs=8k gave a lower
> performance than bs=16k or larger.  So I wanted to rerun bonnie++ with
> larger chunk sizes.  Unfortunately that causes it to crash (and fairly
> consistently) - see below.

No surprise - twice as many syscalls, twice the overhead.

> Is the 8k block size likely to be the performance culprit here?
> 
> # time bonnie++ -d /data/sdb -s 16384k:32k -n 98:800k:500k:1000:32k -u root
> Using uid:0, gid:0.
> Writing a byte at a time...done
> Writing intelligently...done
> Rewriting...done
> Reading a byte at a time...done
> Reading intelligently...
> done
> start 'em...done...done...done...done...done...
> *** glibc detected *** bonnie++: double free or corruption (out): 0x00000000024430a0 ***
> ======= Backtrace: =========
> /lib/x86_64-linux-gnu/libc.so.6(+0x78a96)[0x7f42a0317a96]
> /lib/x86_64-linux-gnu/libc.so.6(cfree+0x6c)[0x7f42a031bd7c]

That's a bug in bonnie. I'd take that up with the benchmark maintainer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
