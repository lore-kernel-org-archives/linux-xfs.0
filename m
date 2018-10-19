Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:23429 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726340AbeJSP4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Oct 2018 11:56:13 -0400
Date: Fri, 19 Oct 2018 18:51:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181019075109.GM6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <85530ca3-22ef-21e5-a4da-1f924a6e2d7e@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85530ca3-22ef-21e5-a4da-1f924a6e2d7e@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 18, 2018 at 04:36:42PM +0300, Avi Kivity wrote:
> On 18/10/2018 14.00, Avi Kivity wrote:
> >>Can I get access to the metadump to dig around in the filesystem
> >>directly so I can see how everything has ended up laid out? that
> >>will help me work out what is actually occurring and determine if
> >>mkfs/mount options can address the problem or whether deeper
> >>allocator algorithm changes may be necessary....
> >
> >I will ask permission to share the dump.
> 
> I'll send you a link privately.

Thanks - I've started looking at this - the information here is
just layout stuff - I'm omitted filenames and anything else that
might be identifying from the output.

Looking at a commit log file:

stat.size = 33554432
stat.blocks = 34720
fsxattr.xflags = 0x800 [----------e-----]
fsxattr.projid = 0
fsxattr.extsize = 33554432
fsxattr.cowextsize = 0
fsxattr.nextents = 14


and the layout:

EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
  0: [0..4079]:       2646677520..2646681599 22 (95606800..95610879)  4080 001010
  1: [4080..8159]:    2643130384..2643134463 22 (92059664..92063743)  4080 001010
  2: [8160..12239]:   2642124816..2642128895 22 (91054096..91058175)  4080 001010
  3: [12240..16319]:  2640666640..2640670719 22 (89595920..89599999)  4080 001010
  4: [16320..18367]:  2640523264..2640525311 22 (89452544..89454591)  2048 000000
  5: [18368..20415]:  2640119808..2640121855 22 (89049088..89051135)  2048 000000
  6: [20416..21287]:  2639874064..2639874935 22 (88803344..88804215)   872 001111
  7: [21288..21295]:  2639874936..2639874943 22 (88804216..88804223)     8 011111
  8: [21296..24495]:  2639874944..2639878143 22 (88804224..88807423)  3200 001010
  9: [24496..26543]:  2639427584..2639429631 22 (88356864..88358911)  2048 000000
 10: [26544..28591]:  2638981120..2638983167 22 (87910400..87912447)  2048 000000
 11: [28592..30639]:  2638770176..2638772223 22 (87699456..87701503)  2048 000000
 12: [30640..31279]:  2638247952..2638248591 22 (87177232..87177871)   640 001111
 13: [31280..34719]:  2638248592..2638252031 22 (87177872..87181311)  3440 011010
 14: [34720..65535]:  hole                                           30816

The first thing I note is the initial allocations are just short of
2MB and so the extent size hint is, indeed, being truncated here
according to contiguous free space limitations. I had thought that
should occur from reading the code, but it's complex and I wasn't
100% certain what minimum allocation length would be used.

Looking at the system batchlog files, I'm guessing the filesystem
ran out of contiguous 32MB free space extents some time around
September 25. The *Data.db files from 24 Sep and earlier then are
all nice 32MB extents, from 25 sep onwards they never make the full
32MB (30-31MB max). eg, good:

 EXT: FILE-OFFSET       BLOCK-RANGE          AG AG-OFFSET            TOTAL FLAGS
   0: [0..65535]:       350524552..350590087  3 (2651272..2716807)   65536 001111
   1: [65536..131071]:  353378024..353443559  3 (5504744..5570279)   65536 001111
   2: [131072..196607]: 355147016..355212551  3 (7273736..7339271)   65536 001111
   3: [196608..262143]: 360029416..360094951  3 (12156136..12221671) 65536 001111
   4: [262144..327679]: 362244144..362309679  3 (14370864..14436399) 65536 001111
   5: [327680..343415]: 365809456..365825191  3 (17936176..17951911) 15736 001111

bad:

EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET            TOTAL FLAGS
  0: [0..64127]:       512855496..512919623  4 (49024456..49088583) 64128 001111
  1: [64128..128247]:  266567048..266631167  2 (34651528..34715647) 64120 001010
  2: [128248..142327]: 264401888..264415967  2 (32486368..32500447) 14080 001111
 
Hmmm - there's 2 million files in this filesystem. that is quite a
lot...

Ok... I see where all the files are - there's a db that was
snapshotted every half hour going back to December 19 2017. There's
55GB of snapshot data there 14362 snapshots holding in 1.8million
files.

Ok, now I understand how the filesystem got into this mess. It has
nothing really to do with the filesystem allocator, geometry, extent
size hints, etc. It isn't really even an XFS specific problem - I
think most filesystems would be in trouble if you did this to them.

First, let me demonstrate that the freespace fragmentation is caused
by these snapshots by removing them all:

before:
   from      to extents  blocks    pct
      1       1    5916    5916   0.00
      2       3   10235   22678   0.01
      4       7   12251   66829   0.02
      8      15    5521   59556   0.01
     16      31    5703  132031   0.03
     32      63    9754  463825   0.11
     64     127   16742 1590339   0.37
    128     255 1550511 390108625  89.87
    256     511   71516 29178504   6.72
    512    1023      19   15355   0.00
   1024    2047     287  461824   0.11
   2048    4095     528 1611413   0.37
   4096    8191    1537 10352304   2.38
   8192   16383       2   19015   0.00

Run a delete:

for d in snapshots/*; do
	rm -rf $d &
done

<cranking along at ~12,000 write iops>

# uptime
17:41:08 up 22:07,  1 user,  load average: 14293.17, 13840.37, 9517.14
#

500,000 files removed:
   from      to extents  blocks    pct
     64     127   22564 2054234   0.47
    128     255  900480 226428059  51.43
    256     511  189904 91033237  20.68
    512    1023   68304 54958788  12.48
   1024    2047   25187 38284024   8.70
   2048    4095    5508 15204528   3.45
   4096    8191    1665 10999789   2.50
   8192   16383      15  139424   0.03

1m files removed:
  from      to extents  blocks    pct
     64     127   21940 1991685   0.45
    128     255  536985 134731402  30.35
    256     511  152092 73465972  16.55
    512    1023  100471 82971130  18.69
   1024    2047   48519 74016490  16.67
   2048    4095   17272 49209538  11.09
   4096    8191    4307 25135374   5.66
   8192   16383     135 1254037   0.28

1.5m files removed:
  from      to extents  blocks    pct
     64     127    9851  924782   0.20
    128     255  227945 57079302  12.32
    256     511   38723 18129086   3.91
    512    1023   33547 28027554   6.05
   1024    2047   31904 50171699  10.83
   2048    4095   25263 75381887  16.27
   4096    8191   16885 102836365  22.19
   8192   16383    6367 68809645  14.85
  16384   32767    1862 40183775   8.67
  32768   65535     385 16228869   3.50
  65536  131071      51 4213237   0.91
 131072  262143       6  958528   0.21

after:
  from      to extents  blocks    pct
    128     255  154063 38785829   8.64
    256     511   11037 4942114   1.10
    512    1023    8576 6930035   1.54
   1024    2047    8496 13464298   3.00
   2048    4095    7664 23034455   5.13
   4096    8191    8497 55217061  12.31
   8192   16383    4233 45867691  10.22
  16384   32767    1533 33488995   7.46
  32768   65535     520 23924895   5.33
  65536  131071     305 28675646   6.39
 131072  262143     230 42411732   9.45
 262144  524287      98 37213190   8.29
 524288 1048575      41 29163579   6.50
1048576 2097151      27 40502889   9.03
2097152 4194303       5 14576157   3.25
4194304 8388607       2 10005670   2.23

Ok, so the results is not perfect, but there are now huge contiguous
free space extents available again - ~70% of the free space is now
contiguous extents >=32MB in length. There's every chance that the
fs would confinue to help reform large contiguous free spaces as the
database files come and go now, as long as the snapshot problem is
dealt with. 

So, what's the problem? Well, it's simply that the workload is
mixing data with vastly different temporal characteristics in the
same physical locality. Every half an hour, a set of ~100 smallish
files are written into a new directory which lands them at the low
endof the largest free space extent in that AG. Each new snapshot
directory ends up in a different AG, so it slowly spreads the
snapshots across all the AGs in the filesystem.

Each snapshot effective appends to the current working area in the
AG, chopping it out of the largest contiguous free space. By the
time the next snapshot in that AG comes around, there's other new
short term data between the old snapshot and the new one. The new
snapshot chops up the largest freespace, and on goes the cycle.

Eventually the short term data between the snapshots gets removed,
but this doesn't reform large contiguous free spaces because the
snapshot data is in the way. And so this cycle continues with the
snapshot data chopping up the largest freespace extents in the
filesystem until there's not more large free space extents to be
found.

The solution is to manage the snapshot data better. We need to keep
all the long term data physically isolated from the short term data
so they don't fragment free space. A short term application level
solution would require migrating the snapshot data out of the
filesystem to somewhere else and point to it with symlinks.

>From the filesystem POV, I'm not sure that there is much we can do
about this directly - we have no idea what the lifetime of the data
is going to be....

<ding>

Hold on....

<rummage in code>

....we already have an interface so setting those sorts of hints.

fcntl(F_SET_RW_HINT, rw_hint)

/*
 * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
 * used to clear any hints previously set.
 */
#define RWF_WRITE_LIFE_NOT_SET  0
#define RWH_WRITE_LIFE_NONE     1
#define RWH_WRITE_LIFE_SHORT    2
#define RWH_WRITE_LIFE_MEDIUM   3
#define RWH_WRITE_LIFE_LONG     4
#define RWH_WRITE_LIFE_EXTREME  5

Avi, does this sound like something that you could use to
classify the different types of data the data base writes out?

I'll need to have a think about how to apply this to the allocator
policy algorithms before going any further, but I suspect making use
of this hint interface will allow us prevent interleaving of short
and long term data so avoid the freespace fragmentation it is
causing here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
