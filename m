Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8O7sdWu114914 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 02:54:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	262TFSLHBAGqJxFS for <xfs@oss.sgi.com>;
	Mon, 24 Sep 2012 00:55:54 -0700 (PDT)
Date: Mon, 24 Sep 2012 17:55:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair deleting realtime files.
Message-ID: <20120924075551.GF20960@dastard>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <505BF45D.5050909@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Anand Tiwari <tiwarikanand@gmail.com>, xfs@oss.sgi.com

On Fri, Sep 21, 2012 at 12:00:13AM -0500, Eric Sandeen wrote:
> On 9/20/12 7:40 PM, Anand Tiwari wrote:
> > Hi All,
> > 
> > I have been looking into an issue with xfs_repair with realtime sub volume. some times while running xfs_repair I see following errors
> > 
> > ----------------------------
> > data fork in rt inode 134 claims used rt block 19607
> > bad data fork in inode 134
> > would have cleared inode 134
> > data fork in rt inode 135 claims used rt block 29607
> > bad data fork in inode 135
> > would have cleared inode 135
.....
> > xfs_db> inode 135
> > xfs_db> bmap
> > data offset 0 startblock 13062144 (12/479232) count 2097000 flag 0
> > data offset 2097000 startblock 15159144 (14/479080) count 2097000 flag 0
> > data offset 4194000 startblock 17256144 (16/478928) count 2097000 flag 0
> > data offset 6291000 startblock 19353144 (18/478776) count 2097000 flag 0
> > data offset 8388000 startblock 21450144 (20/478624) count 2097000 flag 0
> > data offset 10485000 startblock 23547144 (22/478472) count 2097000 flag 0
> > data offset 12582000 startblock 25644144 (24/478320) count 2097000 flag 0
> > data offset 14679000 startblock 27741144 (26/478168) count 2097000 flag 0
> > data offset 16776000 startblock 29838144 (28/478016) count 2097000 flag 0
> > data offset 18873000 startblock 31935144 (30/477864) count 1607000 flag 0
> > xfs_db> inode 134
> > xfs_db> bmap
> > data offset 0 startblock 7942144 (7/602112) count 2097000 flag 0
> > data offset 2097000 startblock 10039144 (9/601960) count 2097000 flag 0
> > data offset 4194000 startblock 12136144 (11/601808) count 926000 flag 0
> 
> It's been a while since I thought about realtime, but -
> 
> That all seems fine, I don't see anything overlapping there, they are
> all perfectly adjacent, though of interesting size.

Yeah, the size is the problem.

....
> Every extent above is length 2097000 blocks, and they are adjacent.
> But you say your realtime extent size is 512 blocks ... which doesn't go
> into 2097000 evenly.   So that's odd, at least.

Once you realise that the bmapbt is recording multiples of FSB (4k)
rather than rtextsz (2MB), it becomes more obvious what the problem
is: rounding of the extent size at MAXEXTLEN - 2097000 is only 152
blocks short of 2^21 (2097152).

I haven't looked at the kernel code yet to work out why it is
rounding to a non-rtextsz multiple, but that is the source of the
problem.

The repair code is detecting that extents are not of the
correct granularity, but the error message indicates that this was
only ever expected for duplicate blocks occurring rather than a
kernel bug. So "fixing repair" is not what is needd here - finding
and fixing the kernel bug is what you shoul be looking at.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
