Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49435 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbfEOCFy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 May 2019 22:05:54 -0400
Date: Wed, 15 May 2019 12:05:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: add extent count and file size histograms
Message-ID: <20190515020547.GT29573@dread.disaster.area>
References: <20190514185026.73788-1-jorgeguerra@gmail.com>
 <20190514233119.GS29573@dread.disaster.area>
 <f121a7d3-ef90-2777-3074-dee302a3ad28@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f121a7d3-ef90-2777-3074-dee302a3ad28@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jorge Guerra <jorge.guerra@gmail.com>, linux-xfs@vger.kernel.org, osandov@osandov.com, Jorge Guerra <jorgeguerra@fb.com>

On Tue, May 14, 2019 at 07:06:52PM -0500, Eric Sandeen wrote:
> On 5/14/19 6:31 PM, Dave Chinner wrote:
> > On Tue, May 14, 2019 at 11:50:26AM -0700, Jorge Guerra wrote:
> >> Maximum extents in a file 14
> >> Histogram of number of extents per file:
> >>     bucket =       count        % of total
> >> <=       1 =      350934        97.696 %
> >> <=       2 =        6231        1.735 %
> >> <=       4 =        1001        0.279 %
> >> <=       8 =         953        0.265 %
> >> <=      16 =          92        0.026 %
> >> Maximum file size 26.508 MB
> >> Histogram of file size:
> >>     bucket =    allocated           used        overhead(bytes)
> >> <=    4 KB =           0              62           314048512 0.13%
> >> <=    8 KB =           0          119911        127209263104 53.28%
> >> <=   16 KB =           0           14543         15350194176 6.43%
> >> <=   32 KB =         909           12330         11851161600 4.96%
> >> <=   64 KB =          92            6704          6828642304 2.86%
> >> <=  128 KB =           1            7132          6933372928 2.90%
> >> <=  256 KB =           0           10013          8753799168 3.67%
> >> <=  512 KB =           0           13616          9049227264 3.79%
> >> <=    1 MB =           1           15056          4774912000 2.00%
> >> <=    2 MB =      198662           17168          9690226688 4.06%
> >> <=    4 MB =       28639           21073         11806654464 4.94%
> >> <=    8 MB =       35169           29878         14200553472 5.95%
> >> <=   16 MB =       95667           91633         11939287040 5.00%
> >> <=   32 MB =          71              62            28471742 0.01%
> >> capacity used (bytes): 1097735533058 (1022.346 GB)
> >> capacity allocated (bytes): 1336497410048 (1.216 TB)
> >> block overhead (bytes): 238761885182 (21.750 %)
> > 
> > BTW, "bytes" as a display unit is stupidly verbose and largely
> > unnecessary. The byte count is /always/ going to be a multiple of
> > the filesystem block size, and the first thing anyone who wants to
> > use this for diagnosis is going to have to do is return the byte
> > count to filesystem blocks (which is what the filesystem itself
> > tracks everything in. ANd then when you have PB scale filesystems,
> > anything more than 3 significant digits is just impossible to read
> > and compare - that "overhead" column (what the "overhead" even
> > mean?) is largely impossible to read and determine what the actual
> > capacity used is without counting individual digits in each number.
> 
> But if the whole point is trying to figure out "internal fragmentation"
> then it's the only unit that makes sense, right?  This is the "15 bytes"
> of a 15 byte file (or extent) allocated into a 4k block.

Urk. I missed that - I saw "-s" and assumed that, like the other
extent histogram printing commands we have, it meant "print summary
information". i.e. the last 3 lines in the above output.

But the rest of it? It comes back to my comment "what does overhead
even mean"?  All it is a measure of how many bytes are allocated in
extents vs the file size. It assumes that if there is more bytes
allocated in extents than the file size, then the excess is "wasted
space".

This is not a measure of "internal fragmentation". It doesn't take
into account the fact we can (and do) allocate extents beyond EOF
that are there (temporarily or permanently) for the file to be
extended into without physically fragmenting the file. These can go
away at any time, so one scan might show massive "internal
fragmentation" and then a minute later after the EOF block scanner
runs there is none. i.e. without changing the file data, the layout
of the file within EOF, or file size, "internal fragmentation" can
just magically disappear.

It doesn't take into account sparse files. Well, it does by
ignoring them which is another flag that this isn't measuring
internal fragmentation because even sparse files can be internally
fragmented.

Which is another thing this doesn't take into account: the amount of
data actually written to the files. e.g. a preallocated, zero length
file is "internally fragmented" by this criteria, but the same empty
file with a file size that matches the preallocation is not
"internally fragmented". Yet an actual internally fragmented file
(e.g. preallocate 1MB, set size to 1MB, write 4k at 256k) will not
actually be noticed by this code....

IOWs, what is being reported here is exactly the same information
that "stat(blocks) vs stat(size)" will tell you, which makes me
wonder why the method of gathering it (full fs scan via xfs_db) is
being used when this could be done with a simple script based around
this:

$ find /mntpt -type f -exec stat -c "%s %b" {} \; | histogram_script

I have no problems with adding analysis and reporting functionality
to the filesystem tools, but they have to be done the right way, and
not duplicate functionality and information that can be trivially
obtained from userspace with a script and basic utilities. IMO,
there has to be some substantial benefit from implementing the
functionality using deep, dark filesystem gubbins that can't be
acheived in any other way for it be worth the additional code
maintenance burden....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
