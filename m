Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D98BF7F53
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:26:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AAE8AC001
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:26:15 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mRbCgBgtOYaPYg3u for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:26:13 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:25:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] xfs: rework xfs_buf_bio_endio error handling
Message-ID: <20140815232559.GV26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-4-git-send-email-david@fromorbit.com>
	<20140815131836.GC4096@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815131836.GC4096@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 15, 2014 at 09:18:37AM -0400, Brian Foster wrote:
> On Fri, Aug 15, 2014 at 04:39:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently the report of a bio error from completion
> > immediately marks the buffer with an error. The issue is that this
> > is racy w.r.t. synchronous IO - the submitter can see b_error being
> > set before the IO is complete, and hence we cannot differentiate
> > between submission failures and completion failures.
> > 
> > Add an internal b_io_error field protected by the b_lock to catch IO
> > completion errors, and only propagate that to the buffer during
> > final IO completion handling. Hence we can tell in xfs_buf_iorequest
> > if we've had a submission failure bey checking bp->b_error before
> > dropping our b_io_remaining reference - that reference will prevent
> > b_io_error values from being propagated to b_error in the event that
> > completion races with submission.
> > 
> > In doing so, allow xfs_buf_iorequest to return an error. That way,
> > the caller can check for submission errors safely if required, and
> > easily distinguish them from completion errors that come from
> > xfs_buf_iowait().
> > 
> 
> I don't see any changes to xfs_buf_iorequest() at all in this one.  That
> aside, it looks fine. It's not how I was thinking about it, but a clear
> separation of submission error regardless.

Apart from adding a zeroing of b_io_error, no, it doesn't change.
What I meant to describe was the new capability this adds.  I'll
rewrite the paragraph to say:

 In doing so, xfs_buf_iorequest now has the capability to
 distinguish between submission and completion errors, and hence if
 we need to we can return submission errors directly and allow
 callers to gather completion errors from xfs_buf_iowait().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
