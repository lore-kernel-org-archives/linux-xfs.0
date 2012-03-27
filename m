Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RLgSpq172733 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 16:42:28 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	u5adxjVxwROrSGYO for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 14:42:26 -0700 (PDT)
Date: Wed, 28 Mar 2012 08:42:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 7/8] xfs: fix fstrim offset calculations
Message-ID: <20120327214215.GE5091@dastard>
References: <1332393313-1955-1-git-send-email-david@fromorbit.com>
	<1332393313-1955-8-git-send-email-david@fromorbit.com>
	<20120327204825.GB7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327204825.GB7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 27, 2012 at 03:48:25PM -0500, Ben Myers wrote:
> On Thu, Mar 22, 2012 at 04:15:12PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_ioc_fstrim() doesn't treat the incoming offset and length
> > correctly. It treats them as a filesystem block address, rather than
> > a disk address. This is wrong because the range passed in is a
> > linear representation , while the filesystem block address notiation
> > is a sparse representation. Hence we cannot convert the range direct
> > to filesystem block units and then use that for calculating the
> > range to trim.
> > 
> > While this sounds dangerous, the problem is limited to calculting
> > what AGs need to be trimmed. The code that calcuates the actual
> > ranges to trim gets the right result (i.e. only ever discards free
> > space), even though it uses the wrong ranges to limit what is
> > trimmed. Hence this is not a bug that endangers user data.
> 
> Yep, I can see that the calculation of what we pass to blkdev_issue_discard()
> is correct and always a free extent.  I am having a hard time seeing the
> problem related to calculating which AGs to trim.  Can you give an example?

I don't have the debug traces anymore, but the problem is this
sort of thing. Take a 80MB filesystem with 4 AGs, each AG is 20MB,
which is ~5000 filesystem blocks. That means we need 13 bits to
store the block count per AG. i.e. agblklogi = 13. Now, the FSB
addressing format is sparse, and the calculation is this:

  FSBNO = (AGNO << agblklog) | AGBNO

Note the terminology? FSBNO != FSB. FSB is just a range converted to
filesystem block units. FSBNO is the filesystem block number, an
address.

         offset                                  offset + length
            +-------------------------------------------+
  range:    0                                           80MB
  daddr:    0                                          160k
  FSB:      0                                           20k

  AG:       +----------+----------+----------+----------+
                 0          1          2          3
  AGBNO:    0         5k
                       0         5k
		                  0         5k
				             0         5k
  FSBNO:   0          5k
                       8k       13k
                                  16k      21k
				             24k       29k

IOWs, the FSBNO range looks like this:

            +----------+   +----------+   +----------+   +----------+
            0         5k   8k       13k   16k      21k   24k      29k

And there are regions that are simple invalid (the empty, sparse
bits). This is done to make all the mathematics easy within each AG
as you can convert from the FSBNO straight to the AGBNO (and vice
versa) without needing to know the address of the first block of the
AG. It means it is easy for AGs to manage their own space without
needing to care about where they exist in the larger disk address
space - that is complete abstracted away from the internal freespace
and inode management as they all use AGBNO notation ot reference
blocks within the AG.

As a result, the FSBNO range of the filesystem is quite a bit larger
than the FSB range of the filesystem. So, if we trim a byte range of
0 to 80MB, but treat that as a FSBNO and then convert it to an AGNO,
80MB = 20k FSBs = AG 2.

Hence rather than trimming the entire range of AGs (0-3), we trim
0-2. Hence we need to convert the byte range to a daddr range, and
from there extract the AGNO according to FSBNO encoding.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
