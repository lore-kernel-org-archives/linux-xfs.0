Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q03NG99K088739 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 17:16:09 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YlMVVUILCsz05CvP for <xfs@oss.sgi.com>;
	Tue, 03 Jan 2012 15:16:06 -0800 (PST)
Date: Wed, 4 Jan 2012 10:16:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore: incorrect restore if file becomes a dir
Message-ID: <20120103231604.GT23662@dastard>
References: <20111226201856.GA3909@davidb.org> <4F036FF6.2080501@sgi.com>
	<20120103213147.GS23662@dastard> <4F0384A4.6000505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F0384A4.6000505@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: David Brown <davidb@davidb.org>, xfs@oss.sgi.com

On Tue, Jan 03, 2012 at 04:43:48PM -0600, Bill Kendall wrote:
> On 01/03/2012 03:31 PM, Dave Chinner wrote:
> >On Tue, Jan 03, 2012 at 03:15:34PM -0600, Bill Kendall wrote:
> >>On 12/26/2011 02:18 PM, David Brown wrote:
> >>>http://oss.sgi.com/bugzilla/show_bug.cgi?id=915
> >>>
> >>>I've had this happen again. It appears to be the case if between
> >>>incremental dumps, a file is deleted and a directory is created that
> >>>gets the same inode number. The restore leaves a file in place of the
> >>>directory. If the new directory has any contents, xfsrestore prints a
> >>>warning, and doesn't restore the subdirectory contents.
> >>>
> >>>Given the sparseness of inodes, this doesn't seem to occur all that
> >>>frequently, but I do have a couple of backups that exhibit the
> >>>behavior. If no one has any ideas, I'll start digging through
> >>>xfsrestore to see if I can figure out what is happening.
> >>
> >>I haven't looked at the relevant code, but it sounds like the inode
> >>generation number would also have to be the same in order for this
> >>to happen. Two inodes from separate backups are only considered to
> >>be the same file or directory if the inode number and the lower 12
> >>bits of the inode generation number are the same.
> >
> >Why does dump only use the lower twelve bits? The on-disk generation
> >number is 32 bits and we use all of it (by way of random numbers) to
> >distinguish between different inode generations. That sounds like
> >something that needs to be fixed....
> 
> I don't know the history there, but it dates back to when the generation
> number was not randomly initialized. So an inode had to be reused 4,096
> times for a collision to occur.

That's kind of what I thought. But even so, with the way XFS reuses
inodes (especially for short term temporary files), those 12 bits
can eaily be burnt through in under a second....

> With the current scheme (initially
> random, then incremented) there would be cases where a collision
> happens more frequently. I agree, it should be changed.

Is that difficult to do?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
