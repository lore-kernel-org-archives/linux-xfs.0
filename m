Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73CdbWe153418 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 07:39:38 -0500
Date: Wed, 3 Aug 2011 08:39:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
Message-ID: <20110803123934.GA13447@infradead.org>
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org> <4E393AE3.70505@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E393AE3.70505@sgi.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Aug 03, 2011 at 07:11:15AM -0500, Bill Kendall wrote:
> Right. I wanted to submit the signal changes separately from the
> threading changes, as the changes were mostly independent except
> in a couple of areas like this.

Sounds fine - it's just something I noticed when looking over the code.

> The original code in ring_slave_entry() changed the (process-wide) signal
> dispositions. My patch converts these to just block the signals, so I
> think this is fine?

It probably is fine, but still not very nice code.  Let's hope we
can get this sorted out.

> >I don't think you'll get around splitting drive_init1, so that we can
> >first open the devices, then do the is pipe check and do the signal
> >setup based on that, then move on to the remaining drive setup.
> 
> I thought it might be possible to avoid treating the pipeline case
> separately. It's not obvious to me why xfsdump has to change its
> signal handling just because it's in a pipeline. This was something
> I was planning to look at.

Good to know.  Maybe the ptools history is able to explain something
about it?

> >Why yare all these sigaction calls needed?   As far as I can see
> >there is no way we'll ever use a different signal handler than
> >"sigaction" for any signal, so simply modifying the signal mask
> >should be enough.
> 
> There's actually 2 "sighandler" routines. One in main.c and one in
> dlog.c. So this does change the handler, it's just that they're
> poorly named. I'll rename the dlog version when I resubmit.

You're right.  But looking at the dlog handler I still don't
like the code there very much.  It just saves the caught signal
in a global variable.  What if we got more than one signal
in that section?    Moreover I don't really understand the point
of the code at all, maybe the lack of existance of the mlog lock
referred to in your comment in the current is part of that.

I suspect the problem is that the normal signal handler may acquite
that lock?  Given that pthread locking primitives are not allowed
to be called from signal handlers that means there is a bigger
problem to solve.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
