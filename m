Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32071 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758078AbcJaDI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2016 23:08:59 -0400
Date: Mon, 31 Oct 2016 14:08:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161031030853.GK22126@dastard>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028160218.1af40906@roar.ozlabs.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Oct 28, 2016 at 04:02:18PM +1100, Nicholas Piggin wrote:
> Okay, the XFS crc sizes indeed don't look too so bad, so it's more the
> crc implementation I suppose. I was seeing a lot of small calls to crc,
> but as a fraction of the total number of bytes, it's not as significant
> as I thought. That said, there is some improvement you may be able to
> get even from x86 implementation.
> 
> I took an ilog2 histogram of frequency and total bytes going to XFS

Which means ilog2 = 3 is 8-15 bytes and 9 is 512-1023 bytes? 

> checksum, with total, head, and tail lengths. I'll give as percentages
> of total for easier comparison (total calls were around 1 million and
> 500MB of data):

Does this table match the profile you showed with all the overhead
being through the fsync->log write path?

Decode table - these are the offsets of crc fields in XFS structures.
('pahole fs/xfs/xfs.o |grep crc' and cleaned up)

	AGF header                 agf_crc;              /*   216     4 */
	short btree                bb_crc;               /*    44     4 */
	long btree                 bb_crc;               /*    56     4 */
	log buffer header          h_crc;                /*    32     4 */
	AG Free list               agfl_crc;             /*    32     4 */
	dir/attr leaf/node block   crc;                  /*    12     4 */
	remote attribute           rm_crc;               /*    12     4 */
	directory data block       crc;                  /*     4     4 */
	dquot                      dd_crc;               /*   108     4 */
	AGI header                 agi_crc;              /*   312     4 */
	inode                      di_crc;               /*   100     4 */
	superblock                 sb_crc;               /*   224     4 */
	symlink                    sl_crc;               /*    12     4 */

> 
>                 frequency                   bytes
> ilog2   total   | head | tail       total | head | tail
>   3         0     1.51      0           0   0.01      0

Directory data blocks.

>   4         0        0      0           0      0      0
>   5         0        0      0           0      0      0
>   6         0    22.35      0           0   1.36      0

log buffer headers, short/long btree blocks

>   7         0    76.10      0           0  14.40      0

Inodes.

>   8         0     0.04     ~0           0   0.02     ~0
>   9     22.25       ~0  98.39       13.81     ~0  71.07

Inode, log buffer header tails.

>  10     76.14        0      0       73.77      0      0

Full sector, no head, no tail (i.e. external crc store)? I think
only log buffers (the extended header sector CRCs) can do that.
That implies a large log buffer (e.g. 256k) is configured and
(possibly) log stripe unit padding is being done. What is the
xfs_info and mount options from the test filesystem?

>  11         0        0      0           0      0      0
>  12         0        0   1.60           0      0  12.39

Directory data block tails.

>  13      1.60        0      0       12.42      0      0

Larger than 4k? Probably only log buffers.

> Keep in mind you have to sum the number of bytes for head and tail to
> get ~100%.
> 
> Now for x86-64, you need to be at 9-10 (depending on configuration) or
> greater to exceed the breakeven point for their fastest implementation.
> Split crc implementation will use the fast algorithm for about 85% of
> bytes in the best case, 12% at worst. Combined gets there for 85% at
> worst, and 100% at best. The slower x86 implementation still uses a
> hardware instruction, so it doesn't do too badly.
> 
> For powerpc, the breakeven is at 512 + 16 bytes (9ish), but it falls
> back to generic implementation for bytes below that.

Which means for the most common objects we won't be able to reach
breakeven easily simply because of the size of the objects we are
running CRCs on. e.g. sectors and inodes/dquots by default are all
512 bytes or smaller. THere's only so much that can be optimised
here...

> I think we can
> reduce the break even point on powerpc slightly and capture most of
> the rest, so it's not so bad.
> 
> Anyway at least that's a data point to consider. Small improvement is
> possible.

Yup, but there's no huge gain to be made here - these numbers say to
me that the problem may not be the CRC overhead, but instead is the
amount of CRC work being done. Hence my request for mount options
+ xfs_info to determine if what you are seeing is simply a bad fs
configuration for optimal small log write performance. CRC overhead
may just be a symptom of a filesystem config issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
