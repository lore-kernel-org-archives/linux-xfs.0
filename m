Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A64367F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 16:51:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 606FB304039
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 14:51:32 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nRXrIVuZMgubwySl for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 14:51:29 -0700 (PDT)
Date: Tue, 1 Sep 2015 07:51:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: timestamp updates cause excessive fdatasync log
	traffic
Message-ID: <20150831215127.GH26895@dastard>
References: <1440724990-25073-1-git-send-email-david@fromorbit.com>
	<20150828043253.GB26895@dastard>
	<alpine.DEB.2.00.1508280804040.13116@cobra.newdream.net>
	<20150828220454.GC26895@dastard> <20150831022155.GE26895@dastard>
	<20150831084814.GG26895@dastard>
	<alpine.DEB.2.00.1508310529170.13116@cobra.newdream.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1508310529170.13116@cobra.newdream.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sage Weil <sage@newdream.net>
Cc: xfs@oss.sgi.com

On Mon, Aug 31, 2015 at 05:40:04AM -0700, Sage Weil wrote:
> On Mon, 31 Aug 2015, Dave Chinner wrote:
> > After taking a tangent to find a tracepoint regression that was
> > getting in my way, I found that there was a significant pause
> > between the inode locking calls within xfs_file_fsync and the inode
> > locking calls on the buffered write. Roughly 8ms, in fact, on almost
> > every call. After adding a couple more test trace points into the
> > XFS fsync code, it turns out that a hardware cache flush is causing
> > the delay. That is, because we aren't doing log writes that trigger
> > cache flushes and FUA writes, we have to issue a
> > blkdev_issue_flush() call from xfs_file_fsync and that is taking 8ms
> > to complete.
> 
> This is where my understanding of block layer flushing really breaks down, 
> but in both cases we're issues flush requests to the hardware, right? Is 
> the difference that the log write is a FUA flush request with data, and 
> blkdev_issue_flush() issues a flush request without associated data?

Pretty much, though th elog write also does a cache flush before the
FUA write. i.e.  The log writes consist of a bio with data issued via:

	submit_bio(REQ_FUA | REQ_FLUSH | WRITE_SYNC, bio);

blkdev_issue_flush consists of an empty bio issued via:

	submit_bio(REQ_FLUSH | WRITE_SYNC, bio);

So from a block layer and filesystem point of view there is little
difference, and the only difference at the SCSI layer is the WRITE
w/ FUA that is issued after the cache flush in the log write case
(see https://lwn.net/Articles/400541/ fo a bit more background).

I haven't looked any deeper than this so far - I don't have time
right now to do so...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
