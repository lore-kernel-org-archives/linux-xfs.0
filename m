Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Sep 2007 00:55:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L7t6gf002791
	for <linux-xfs@oss.sgi.com>; Fri, 21 Sep 2007 00:55:15 -0700
Date: Fri, 21 Sep 2007 17:54:59 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Questions about testing the Filestream feature
Message-ID: <20070921075459.GJ995458@sgi.com>
References: <12809900.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12809900.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Thu, Sep 20, 2007 at 08:10:31PM -0700, Hxsrmeng wrote:
> 
> Hi all,
> 
> I need to use the "Filestreams" feature. I wrote a script to write files to
> two directories concurrently.  When I check the file bitmap, I found
> sometimes the files written in the different directories still interleave
> extents on disk. I don't know whether there is something wrong with my
> script, or, I misunderstand something.
> 
> I am using Opensuse10.2, the kernel is linux-2.6.23-rc4 (source code was
> check out from cvs of oss.sgi.com). The filestreams feature is enabled with
> a "-o filestreams" mount option.
> Here is my script: 

<snip>

Very similar to xfsqa tests 170-174.

> Then I got the information of my xfs device first :  
> meta-data=/dev/hda5   isize=256      agcount=8, agsize=159895 blks
>          =            sectsz=512   attr=0
> data     =            bsize=4096   blocks=1279160,imaxpct=25

Ok, so an AG ~600MB in size, and your filesystem is about 5GB.

> First run, I wrote 3 "big" files, which are 768M, to each directories. The
> files in directory dira share AG 0,2,5,7 and files in directory dirb share
> AG 1, 3, 4, 6,  which I assume should be correct.

Yes, and 3*3*768 = 4GB ~= 80% full.

> But the files extents
> doesn't use contiguous blocks,

filestreams doesn't guarantee contiguous extents - it guarantees sets of files
separated by directories don't intertwine. Within the each set you can see
non-contiguous allocation, but the sets should not interleave in the same
AGs...

> and all files in the same directory put some
> of their extents in AG 0.

AG 0 is the "filestreams failure" allocation group. What you are seeing is
that at some point you've filled your AG's up and a stream write couldn't find
an unused AG that matched the stream association criteria and it gave up.

> I am not sure whether this is correct.  Here is
> part of file bitmap:
> "
> dira/0:
>  EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET          TOTAL
>    0: [0..7615]:          96..7711          0 (96..7711)          7616
>    1: [7616..7679]:       33312..33375      0 (33312..33375)        64
>    2: [7680..24063]:      33448..49831      0 (33448..49831)     16384
>    3: [24064..52999]:     60608..89543      0 (60608..89543)     28936
>    4: [53000..61191]:     95496..103687     0 (95496..103687)     8192
>    5: [61192..90791]:     119088..148687    0 (119088..148687)   29600
>    6: [90792..131751]:    170264..211223    0 (170264..211223)   40960
>    7: [131752..144223]:   219480..231951    0 (219480..231951)   12472
>    8: [144224..168799]:   240144..264719    0 (240144..264719)   24576

Ummm - that's a file stat started in AG 0....

>    ...
> dira/1:
>  EXT: FILE-OFFSET         BLOCK-RANGE      AG AG-OFFSET           TOTAL
>    0: [0..12791]:         7712..20503       0 (7712..20503)       12792
>    1: [12792..12863]:     33376..33447      0 (33376..33447)         72
>    2: [12864..13391]:     49832..50359      0 (49832..50359)        528
>    3: [13392..19575]:     112904..119087    0 (112904..119087)     6184
>    4: [19576..27767]:     148688..156879    0 (148688..156879)     8192
>    5: [27768..35959]:     211224..219415    0 (211224..219415)     8192
>    6: [35960..44151]:     231952..240143    0 (231952..240143)     8192
>    7: [44152..68727]:     264784..289359    0 (264784..289359)    24576
>    8: [68728..79047]:     309400..319719    0 (309400..319719)    10320

And so is that. Given that they are in the same directory, this is correct
behaviour.

How much memory in your test box? I suspect that you're getting writeback
from kswapd, not pdflush as you are doing buffered I/O and you're getting
LRU order writeback rather than nice sequential writeback. It's up to the
user/application to prevent intra-stream allocation/fragmentation
problems (e.g. preallocation, extent size hints, large direct I/O, etc)
and that is what your test application is lacking. filestreams only
prevents inter-stream interleaving.

Also, you are running close to filesystem full state. That is known to be
a no-no for deterministic performance from the filesystem, will cause
filesystem fragmentation, and is not the case that filestreams is
designed to optimise for.

however, I agree that the code is not working optimally. In test 171,
there is this comment:

# test large numbers of files, single I/O per file, 120s timeout
# Get close to filesystem full.
# 128 = ENOSPC
# 120 = 93.75% full, gets repeatable failures
# 112 = 87.5% full, should reliably succeed but doesn't *FIXME*
# 100 = 78.1% full, should reliably succeed

The test uses a 1GB filesystem to intentionally stress the allocator,
and at 78.1% full, we are getting intermittent failures. On
some machines (like my test boxes) it passes >95% of the time.
On other machines, it passes maybe 5% of the time. So the low
space behaviour is known to be less than optimal, but at production
sites it is known that they can't use the last 10-15% of the filesystem
because of fragmentation issues associated with stripe alignment.
Hence low space behaviour of the allocator is not considered something
critical because there are other, worse problems at low space
that filestreams can't do anything to prevent.

> Second run, I wrote 1024 "small" files, which are 1M, to each directories. 
> Files in directory dira use AG 0,1,3 and files in directory b use AG
> 2,1,5,6,7,4. So files written in directory dirb use the allocation group 1,
> which should be reserved for directory dira . And, sometimes even one file
> is written to two AGs. The following is part of file bitmap:

That's true only as long as a stream does not time out. An AG is
reserved only as long a the timeout since the last file in a
stream was created or allocated to.

IOWs, if you use buffered I/O, the 30s writeback delay could time
your stream out between file creation and write() syscall and
when pdflush writes it back. Then you have no stream association
and you will get interleaving. Test 172 tests this behaviour,
and we get intermittent failures on that test because the buffered
I/O case occasionally succeeds rather than fails like it is supposed
to....

What's your stream timeout (/proc/sys/fs/xfs/filestream_centisecs) set to?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
