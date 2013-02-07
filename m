Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BAA47F4C
	for <xfs@oss.sgi.com>; Thu,  7 Feb 2013 09:44:38 -0600 (CST)
Date: Thu, 7 Feb 2013 09:44:37 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] xfs: memory barrier before wake_up_bit()
Message-ID: <20130207154436.GC22182@sgi.com>
References: <510FDDE5.4050103@inktank.com> <510FDE17.9020207@inktank.com>
	<20130204230634.GN2667@dastard> <511061CD.8070206@inktank.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <511061CD.8070206@inktank.com>
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
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 04, 2013 at 07:35:09PM -0600, Alex Elder wrote:
> On 02/04/2013 05:06 PM, Dave Chinner wrote:
> > On Mon, Feb 04, 2013 at 10:13:11AM -0600, Alex Elder wrote:
> >> In xfs_ifunlock() there is a call to wake_up_bit() after clearing
> >> the flush lock on the xfs inode.  This is not guaranteed to be safe,
> >> as noted in the comments above wake_up_bit() beginning with:
> >>
> >>     In order for this to function properly, as it uses
> >>     waitqueue_active() internally, some kind of memory
> >>     barrier must be done prior to calling this.
> >>
> >> I claim no mastery of the details and subtlety of memory barrier
> >> use, but I believe the issue is that the call to waitqueue_active()
> >> in __wake_up_bit(), could be operating on a value of "wq" that is
> >> out of date.  This patch fixes this by inserting a call to smp_mb()
> >> in xfs_iunlock before calling wake_up_bit(), along the lines of
> >> what's done in unlock_new_inode().  A litte more explanation
> >> follows.
> >>
> >>
> >> In __xfs_iflock(), prepare_to_wait_exclusive() adds a wait queue
> >> entry to the end of a bit wait queue before setting the current task
> >> state to UNINTERRUPTIBLE.  And although setting the task state
> >> issues a full smp_mb() (which ensures changes made are visible to
> >> the rest of the system at that point) that alone does not guarantee
> >> that other CPUs will instantly avail themselves of the updated
> >> value.  A separate CPU needs to issue at least a read barrier in
> >> order to ensure the wq value it uses to determine whether there are
> >> waiters is up-to-date, and waitqueue_active() does not do that.
> > 
> > You can probably trim most of this and simply point at the comment
> > describing wake_up_bit()....
> 
> Yeah, I know.  I just wanted to sort of say what I was
> thinking to get confirmation (or correction).  I now
> have a much better understanding of barriers than I did
> before, but there are still corners I haven't wrapped
> my head around.
> 
> Ben, please feel free do trim off this stuff as you
> see fit.

Applied.

Thanks Alex!

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
