Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BLfBrW243674 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 16:41:11 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oFqt1ESLXPvaHGTR for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 14:42:42 -0700 (PDT)
Date: Fri, 12 Oct 2012 08:42:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/19] xfs: buffer read verifier infrastructure
Message-ID: <20121011214241.GF2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<5076B6DF.3090308@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5076B6DF.3090308@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 07:09:03AM -0500, Mark Tinguely wrote:
> On 10/08/12 22:50, Dave Chinner wrote:
> >Hi folks,
> >
> >This is the next step along the road to metadata CRC checking. What
> >the series does is add an iodone callback to most metadata buffer
> >read operations that is only executed when the buffer is physically
> >read from disk.  Read operations that hit the cache do no trigger a
> >verification, as CRCs only protect the on-disk metadata and the
> >in-memory buffer can be changed at any time after it is read without
> >recalculating the CRC of the buffer.
.....
> >Comments, flames and rants about how to do this better are welcome :)
> 
> "Don't shoot me, I am only the piano player" -Joe Walsh
> 
> I put in the series on top of the previous worker mover series.
> I know this is sketchy in details. I get one of the below on xfstest
> 076:
> 
>  1) XFS: Assertion failed: atomic_read(&bp->b_hold) > 0
>     from [PATCH 02/14] xfs: rationalise xfs_mount_wq users

I doubt that is related - the patch series does not touch the bufer
locking or reference counting at all, and we know that there is an
existing problem w.r.t. shutdowns and buffer reference counting, so
that's a more likely cause...

>  2) filesystem hang. One process is in inode reclaim waiting on
>     the superblock buffer lock, and the umount doing the same.

What's inode reclaim doing trying to get the superblock buffer?
A stack trace might help explain that...

But, again, I doubt that has anything to do with this patch series,
because it does not change the way buffers are accessed/used by
reclaim or unmount.

As it is, I have a v2 just about ready to go - there's quite a few
fixes and additional functionality added to the series....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
