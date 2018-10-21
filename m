Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:47041 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727688AbeJUXV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 19:21:28 -0400
Date: Mon, 22 Oct 2018 02:06:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENSOPC on a 10% used disk
Message-ID: <20181021150648.GQ6311@dastard>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <20181019011526.GJ6311@dastard>
 <9f5b5009-8b6c-65a9-8e18-6620557f5abc@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f5b5009-8b6c-65a9-8e18-6620557f5abc@scylladb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Oct 21, 2018 at 12:21:33PM +0300, Avi Kivity wrote:
> 
> On 19/10/2018 04.15, Dave Chinner wrote:
> >On Thu, Oct 18, 2018 at 02:00:19PM +0300, Avi Kivity wrote:
> >>On 18/10/2018 13.05, Dave Chinner wrote:
> >>>On Thu, Oct 18, 2018 at 10:55:18AM +0300, Avi Kivity wrote:
> >>>>On 18/10/2018 04.37, Dave Chinner wrote:

> >>Looks like we should remove that 1MB
> >>hint since it's reducing allocation flexibility for XFS without a
> >>good return. On the other hand, I worry that because we bypass the
> >>page cache, XFS doesn't get to see the entire file at one time and
> >>so it will get fragmented.
> >Yes. Your other option is to use an extent size hint that is smaller
> >than the sunit. That should not align to 1MB because the initial
> >data allocation size is not large enough to trigger stripe
> >alignment.
> 
> 
> Wow, so we had so many  factors leading to this:
> 
> - 1-disk installations arranged as RAID0 even though not strictly needed
> 
> - having a default extent allocation hint, even for small files
> 
> - having that default hint be >= the stripe unit size
> 
> - the user not removing snapshots
> 
> - XFS not falling back to unaligned allocations

Everything but the last is true. XFS is definitely dropping the
alignment hint once there are no more aligned contiguous free space
extents.

> >>Suppose I write a 4k file with a 1MB hint. How is that trailing
> >>(1MB-4k) marked? Free extent, free extent with extra annotation, or
> >>allocated extent? We may need to deallocate those extents? (will
> >>FALLOC_FL_PUNCH_HOLE do the trick?)
> >It's an unwritten extent beyond EOF, and how that is treated when
> >the file is last closed depends on how that extent was allocated.
> >But, yes, punching the range beyond EOF will definitely free it.
> 
> I think we can conclude from the dump that the filesystem freed it?

*nod*

>  ext:    logical_offset:      physical_offset: length: expected: flags:
>   0:     0..    1eb2:    3928e00..   392acb2:   1eb3:
>   1:     1eb3..    3cb2:    3c91200..   3c92fff:   1e00: 392acb3:
>   2:     3cb3..    57b2:    3454100..   3455bff:   1b00: 3c93000:
>   3:     57b3..    6fb2:    34ecd00..   34ee4ff:   1800: 3455c00:
>   4:     6fb3..    85fe:    3386a00..   338804b:   164c: 34ee500:
>   5:     85ff..    9c0b:    2c85c00..   2c8720c:   160d: 338804c:
>   6:     9c0c..    b217:    3099900..   309af0b:   160c: 2c8720d:
>   7:     b218..    c823:    34fb300..   34fc90b:   160c: 309af0c:
>   8:     c824..    de2b:    315ef00..   3160507:   1608: 34fc90c:
>   9:     de2c..    f42f:    36adc00..   36af203:   1604: 3160508:
>   10:    f430..    10a30:    2cf4400..   2cf5a00:   1601: 36af204:
>   11:    10a31..   12030:    2e03300..   2e048ff:   1600: 2cf5a01:
>   12:    12031..   13630:    2ff5200..   2ff67ff:   1600: 2e04900:
>   13:    13631..   14c30:    3199e00..   319b3ff:   1600: 2ff6800:
>   14:    14c31..   16230:    32ed500..   32eeaff:   1600: 319b400:
>   15:    16231..   17830:    34a0b00..   34a20ff:   1600: 32eeb00:
>   16:    17831..   18e30:    354e700..   354fcff:   1600: 34a2100:
>   17:    18e31..   1a430:    362c400..   362d9ff:   1600: 354fd00:
>   18:    1a431..   1ba1d:    3192b00..   31940ec:   15ed: 362da00:
>   19:    1ba1e..   1d05c:    4228500..   4229b3e:   163f: 31940ed:
>   20:    1d05d..   1e692:    3f6c900..   3f6df35:   1636: 4229b3f:
>   21:    1e693..   1fcc0:    37d4400..   37d5a2d:   162e: 3f6df36:
>   22:    1fcc1..   212e4:    43f9c00..   43fb223:   1624: 37d5a2e:
>   23:    212e5..   22905:    4003500..   4004b20:   1621: 43fb224:
>   24:    22906..   23803:    1fdb900..   1fdc7fd:    efe: 4004b21: last,eof

filefrag? I find that utterly unreadable, an dwithout the command
line I don't know what the units are.  can you use 'xfs_bmap -vvp'
so that all the units are known and it automatically calculates
whethere extents are aligned or not?

> So, lengths are not always aligned, but physical_offset always is.
> So XFS relaxes the extent size hint but not alignment.

No, that is incorrect. 

Filesystems never do what people expect them to.

i.e. what you see above is because the filesystem could not find
large enough contiguous free spaces to align both the ends of the
allocation. i.e.


Freespace looks like:
	+----FF+FFFFFF+FFFFFF+FFFF-+------+

Alloc aligned w/ min len and max len

	+----FF+FFFFFF+FFFFFF+FFFF-+------+
               +WANT-THIS-BIT_HERE-+ 

But the nearest target free space extent returns:

	     fffffffffffffffffffff

So we trim the front
	       fffffffffffffffffff

if len < min len, fail (didn't happen)

if > max len, trim end (no trim, not long enough)

And so we end up allocating front aligned and short:

               +WANT-THIS-BIT_HER+ 

Leaving behind:

	+----FF+------+------+-----+------+

That's why it looks like there are aligned extents remaining, even
when there isn't.

The allocation logic is horrifically complex - it has 20-something
controlling parameters and a heap of logic, maths and fallback paths
around them. Unless you're intimately familiar with the code,
you're unlikely to infer the allocator decisions from an extent
list....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
