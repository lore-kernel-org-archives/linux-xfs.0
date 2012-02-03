Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13IlQgT153674 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 12:47:27 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id KHWCVnsR8gAhtJPu for
	<xfs@oss.sgi.com>; Fri, 03 Feb 2012 10:47:25 -0800 (PST)
Date: Fri, 3 Feb 2012 18:47:23 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Performance problem - reads slower than writes
Message-ID: <20120203184723.GA2261@nsrc.org>
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org> <20120131141604.GB46571@nsrc.org>
	<20120131202526.GJ9090@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120131202526.GJ9090@dastard>
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

On Wed, Feb 01, 2012 at 07:25:26AM +1100, Dave Chinner wrote:
> The only thing changing the inode size will have affected is the
> directory structure - maybe your directories are small enough to fit
> in line, or the inode is large enough to keep it in extent format
> rather than a full btree. In either case, though, the directory
> lookup will require less IO.

I've done a whole bunch of testing, which I won't describe in detail unless
you're interested, but I've finally found out what's causing the sudden
change in performance.

With defaults, the files in one directory are spread all over the
filesystem.  But with -i size=1024, the files in a directory are stored
adjacent to each other. Hence reading all the files in one directory
requires far less seeking across the disk, and runs about 3 times faster.

Here is the filesystem on a disk formatted with defaults:

root@storage1:~# find /data/sdc | head -20 | xargs xfs_bmap 
/data/sdc: no extents
/data/sdc/Bonnie.26384:
	0: [0..31]: 567088..567119
/data/sdc/Bonnie.26384/00000:
	0: [0..7]: 567120..567127
/data/sdc/Bonnie.26384/00000/0icoeTRPHKX0000000000:
	0: [0..1015]: 4411196808..4411197823
/data/sdc/Bonnie.26384/00000/Q0000000001:
	0: [0..1543]: 1466262056..1466263599
/data/sdc/Bonnie.26384/00000/JFXQyeq6diG0000000002:
	0: [0..1295]: 2936342144..2936343439
/data/sdc/Bonnie.26384/00000/TK7ciXkkj0000000003:
	0: [0..1519]: 4411197824..4411199343
/data/sdc/Bonnie.26384/00000/0000000004:
	0: [0..1207]: 1466263600..1466264807
/data/sdc/Bonnie.26384/00000/acJKZWAwEnu0000000005:
	0: [0..1223]: 2936343440..2936344663
/data/sdc/Bonnie.26384/00000/9wIgxPKeI4B0000000006:
	0: [0..1319]: 4411199344..4411200663
/data/sdc/Bonnie.26384/00000/C6QLFdND0000000007:
	0: [0..1111]: 1466264808..1466265919
/data/sdc/Bonnie.26384/00000/6xc1Wydh0000000008:
	0: [0..1223]: 2936344664..2936345887
/data/sdc/Bonnie.26384/00000/0000000009:
	0: [0..1167]: 4411200664..4411201831
/data/sdc/Bonnie.26384/00000/HdlN0000000000a:
	0: [0..1535]: 1466265920..1466267455
/data/sdc/Bonnie.26384/00000/52IabyC5pvis000000000b:
	0: [0..1287]: 2936345888..2936347175
/data/sdc/Bonnie.26384/00000/LvDhxcdLf000000000c:
	0: [0..1583]: 4411201832..4411203415
/data/sdc/Bonnie.26384/00000/08P3JAR000000000d:
	0: [0..1255]: 1466267456..1466268711
/data/sdc/Bonnie.26384/00000/000000000e:
	0: [0..1095]: 2936347176..2936348271
/data/sdc/Bonnie.26384/00000/s0gtPGPecXu000000000f:
	0: [0..1319]: 4411203416..4411204735
/data/sdc/Bonnie.26384/00000/HFLOcN0000000010:
	0: [0..1503]: 1466268712..1466270215

And here is the filesystem created with -i size=1024:

root@storage1:~# find /data/sdb | head -20 | xargs xfs_bmap 
/data/sdb: no extents
/data/sdb/Bonnie.26384:
	0: [0..7]: 243752..243759
	1: [8..15]: 5526920..5526927
	2: [16..23]: 7053272..7053279
	3: [24..31]: 24223832..24223839
/data/sdb/Bonnie.26384/00000:
	0: [0..7]: 1465133488..1465133495
/data/sdb/Bonnie.26384/00000/0icoeTRPHKX0000000000:
	0: [0..1015]: 1465134032..1465135047
/data/sdb/Bonnie.26384/00000/Q0000000001:
	0: [0..1543]: 1465135048..1465136591
/data/sdb/Bonnie.26384/00000/JFXQyeq6diG0000000002:
	0: [0..1295]: 1465136592..1465137887
/data/sdb/Bonnie.26384/00000/TK7ciXkkj0000000003:
	0: [0..1519]: 1465137888..1465139407
/data/sdb/Bonnie.26384/00000/0000000004:
	0: [0..1207]: 1465139408..1465140615
/data/sdb/Bonnie.26384/00000/acJKZWAwEnu0000000005:
	0: [0..1223]: 1465140616..1465141839
/data/sdb/Bonnie.26384/00000/9wIgxPKeI4B0000000006:
	0: [0..1319]: 1465141840..1465143159
/data/sdb/Bonnie.26384/00000/C6QLFdND0000000007:
	0: [0..1111]: 1465143160..1465144271
/data/sdb/Bonnie.26384/00000/6xc1Wydh0000000008:
	0: [0..1223]: 1465144272..1465145495
/data/sdb/Bonnie.26384/00000/0000000009:
	0: [0..1167]: 1465145496..1465146663
/data/sdb/Bonnie.26384/00000/HdlN0000000000a:
	0: [0..1535]: 1465146664..1465148199
/data/sdb/Bonnie.26384/00000/52IabyC5pvis000000000b:
	0: [0..1287]: 1465148200..1465149487
/data/sdb/Bonnie.26384/00000/LvDhxcdLf000000000c:
	0: [0..1583]: 1465149488..1465151071
/data/sdb/Bonnie.26384/00000/08P3JAR000000000d:
	0: [0..1255]: 1465151072..1465152327
/data/sdb/Bonnie.26384/00000/000000000e:
	0: [0..1095]: 1465152464..1465153559
/data/sdb/Bonnie.26384/00000/s0gtPGPecXu000000000f:
	0: [0..1319]: 1465153560..1465154879
/data/sdb/Bonnie.26384/00000/HFLOcN0000000010:
	0: [0..1503]: 1465154880..1465156383

All the files in one directory are close to that directory; when you get to
another directory the block offset jumps.

This is a highly desirable property when you want to copy all the files: for
example, using this filesystem I can tar it up and untar it onto another
filesystem at 73MB/s, as compared to about 25MB/sec on a default filesystem.

So now my questions now are:

(1) Is this a fluke? What is it about -i size=1024 which causes this to
happen?

(2) What is the intended behaviour for XFS: that files should be close to
their parent directory or spread across allocation groups?

I did some additional tests:

* -i size=512
Files spread around

* -n size=16384
Files spread around

* -i size=1024 -n size=16384
Files local to directory

* -i size=2048
Files local to directory

Any clues gratefully received. This usage pattern (dumping in a large
library of files, and then processing all those files sequentially) is an
important one for the system I'm working on.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
