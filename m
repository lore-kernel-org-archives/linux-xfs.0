Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VEGL01018853 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 08:16:22 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id XCE32GK4YjaPLFZ2 for
	<xfs@oss.sgi.com>; Tue, 31 Jan 2012 06:16:20 -0800 (PST)
Date: Tue, 31 Jan 2012 14:16:04 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120131141604.GB46571@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131103126.GA46170@nsrc.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Updates:

(1) The bug in bonnie++ is to do with memory allocation, and you can work
around it by putting '-n' before '-s' on the command line and using the same
custom chunk size before both (or by using '-n' with '-s 0')

# time bonnie++ -d /data/sdc -n 98:800k:500k:1000:32k -s 16384k:32k -u root

Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine   Size:chnk K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
storage1    16G:32k  2061  91 101801   3 49405   4  5054  97 126748   6 130.9   3
Latency             15446us     222ms     412ms   23149us   83913us     452ms
Version  1.96       ------Sequential Create------ --------Random Create--------
storage1            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
98:819200:512000/1000   128   3    37   1 10550  25   108   3    38   1  8290  33
Latency              6874ms   99117us   45394us    4462ms   12582ms    4027ms
1.96,1.96,storage1,1,1328002525,16G,32k,2061,91,101801,3,49405,4,5054,97,126748,6,130.9,3,98,819200,512000,,1000,128,3,37,1,10550,25,108,3,38,1,8290,33,15446us,222ms,412ms,23149us,83913us,452ms,6874ms,99117us,45394us,4462ms,12582ms,4027ms

This shows that using 32k transfers instead of 8k doesn't really help; I'm
still only seeing 37-38 reads per second, either sequential or random.


(2) In case extents aren't being kept in the inode, I decided to build a
filesystem with '-i size=1024'

# time bonnie++ -d /data/sdb -n 98:800k:500k:1000:32k -s0 -u root

Version  1.96       ------Sequential Create------ --------Random Create--------
storage1            -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
98:819200:512000/1000   110   3   131   5  3410  10   110   3    33   1   387   1
Latency              6038ms   92092us   87730us    5202ms     117ms    7653ms
1.96,1.96,storage1,1,1328003901,,,,,,,,,,,,,,98,819200,512000,,1000,110,3,131,5,3410,10,110,3,33,1,387,1,,,,,,,6038ms,92092us,87730us,5202ms,117ms,7653ms

Wow! The sequential read just blows away the previous results. What's even
more amazing is the number of transactions per second reported by iostat
while bonnie++ was sequentially stat()ing and read()ing the files:

# iostat 5
...
sdb             820.80     86558.40         0.00     432792          0
                  !!

820 tps on a bog-standard hard-drive is unbelievable, although the total
throughput of 86MB/sec is.  It could be that either NCQ or drive read-ahead
is scoring big-time here.

However during random stat()+read() the performance drops:

# iostat 5
...
sdb             225.40     21632.00         0.00     108160          0

Here we appear to be limited by real seeks. 225 seeks/sec is still very good
for a hard drive, but it means the filesystem is generating about 7 seeks
for every file (stat+open+read+close).  Indeed the random read performance
appears to be a bit worse than the default (-i size=256) filesystem, where
I was getting 25MB/sec on iostat, and 38 files per second instead of 33.

There are only 1000 directories in this test, and I would expect those to
become cached quickly.

According to Wikipedia, XFS has variable-length extents. I think that as
long as the file data is contiguous then each file should only be taking a
single extent, and this is what xfs_bmap seems to be telling me:

# xfs_bmap -n1 -l -v /data/sdc/Bonnie.25448/00449/* | head
/data/sdc/Bonnie.25448/00449/000000b125mpBap4gg7U:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL
   0: [0..1559]:       4446598752..4446600311  3 (51198864..51200423)  1560
/data/sdc/Bonnie.25448/00449/000000b1262hBudG6gV:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL
   0: [0..1551]:       1484870256..1484871807  1 (19736960..19738511)  1552
/data/sdc/Bonnie.25448/00449/000000b127fM:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL
   0: [0..1111]:       2954889944..2954891055  2 (24623352..24624463)  1112
/data/sdc/Bonnie.25448/00449/000000b128:

It looks like I need to get familiar with xfs_db and
http://oss.sgi.com/projects/xfs/papers/xfs_filesystem_structure.pdf
to find out what's going on.

(These filesystems are mounted with noatime,nodiratime incidentally)

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
