Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL1PP6q202506 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 19:25:25 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D395146F966
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 17:27:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	40Saz56HWwNgLTvP for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 17:27:20 -0800 (PST)
Date: Tue, 21 Dec 2010 12:27:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/12] xfs: convert l_tail_lsn to an atomic variable.
Message-ID: <20101221012717.GP5193@dastard>
References: <1292215483-18224-1-git-send-email-david@fromorbit.com>
	<1292215483-18224-9-git-send-email-david@fromorbit.com>
	<20101220120634.GA3582@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101220120634.GA3582@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Dec 20, 2010 at 07:06:34AM -0500, Christoph Hellwig wrote:
> On Mon, Dec 13, 2010 at 03:44:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > log->l_tail_lsn is currently protected by the log grant lock. The
> > lock is only needed for serialising readers against writers, so we
> > don't really need the lock if we make the l_tail_lsn variable an
> > atomic. Converting the l_tail_lsn variable to an atomic64_t means we
> > can start to peel back the grant lock from various operations.
> > 
> > Also, provide functions to safely crack an atomic LSN variable into
> > it's component pieces and to recombined the components into an
> > atomic variable. Use them where appropriate.
> > 
> > This also removes the need for explicitly holding a spinlock to read
> > the l_tail_lsn on 32 bit platforms.
> 
> I know I suggested this, but I think the atomic read of l_tail_lsn
> in xlog_space_left might be problemetic for the call from
> xlog_grant_push_ail, where we read it twice now.  Maybe split
> xlog_space_left into a __xlog_space_left that gets the already cracked
> values, and xlog_space_left as a wrapper around it?

I'd convinced myself that it wouldn't be a problem. That is,
once we have a value for the tail_lsn in xlog_grant_push_ail(), the
threshold that we will push to is effectively fixed. The only thing
that will change is the amount of log space currently available,
which can only increase if the tail moves.

Hence we'll either get:

	a) not enough log space and have to push, in which case the
	   value of the tail lsn seen in xlog_space_left() is
	   irrelevant to the threshold lsn we calculate, or

	b) we'll have enough log space and not need to push in which
	   case we don't need to use the tail_lsn at all because we
	   don't need to push.

So it seems to me that the double sample of the tail_lsn doesn't
matter at all for this code. Is there a hole in my logic here?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
