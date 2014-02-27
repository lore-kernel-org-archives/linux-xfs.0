Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4825A7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:24:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 251308F8052
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:24:10 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	dEfHVGKDem1Dn8mC for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:24:08 -0800 (PST)
Date: Fri, 28 Feb 2014 07:24:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] repair: prefetch runs too far ahead
Message-ID: <20140227202405.GE30131@dastard>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
	<1393494675-30194-10-git-send-email-david@fromorbit.com>
	<20140227140846.GB62463@bfoster.bfoster>
	<20140227200150.GD30131@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140227200150.GD30131@dastard>
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

On Fri, Feb 28, 2014 at 07:01:50AM +1100, Dave Chinner wrote:
> On Thu, Feb 27, 2014 at 09:08:46AM -0500, Brian Foster wrote:
> > On Thu, Feb 27, 2014 at 08:51:14PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > 
> > Hmm, I replied to this one in the previous thread, but now I notice that
> > it apparently never made it to the list. Dave, did you happen to see
> > that in your inbox? Anyways, I had a couple minor comments/questions
> > that I'll duplicate here (which probably don't require another
> > repost)...
> 
> No, I didn't.
> 
> [snip typos that need fixing]
> 
> > > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > > index aee6342..7d3efde 100644
> > > --- a/repair/prefetch.c
> > > +++ b/repair/prefetch.c
> > > @@ -866,6 +866,48 @@ start_inode_prefetch(
> > >  	return args;
> > >  }
> > >  
> > 
> > A brief comment before the prefetch_ag_range bits that explain the
> > implicit design constraints (e.g., throttle prefetch based on
> > processing) would be nice. :)
> 
> Can do.

Added this:

/*
 * prefetch_ag_range runs a prefetch-and-process loop across a range of AGs. It
 * begins with @start+ag, and finishes with @end_ag - 1 (i.e. does not prefetch
 * or process @end_ag). The function starts prefetch on the first AG, then loops
 * starting prefetch on the next AG and then blocks processing the current AG as
 * the prefetch queue brings inodes into the processing queue.
 *
 * There is only one prefetch taking place at a time, so the prefetch on the
 * next AG only starts once the current AG has been completely prefetched. Hence
 * the prefetch of the next AG will start some time before the processing of the
 * current AG finishes, ensuring that when we iterate an start processing the
 * next AG there is already a significant queue of inodes to process.
 *
 * Prefetch is done this way to prevent it from running too far ahead of the
 * processing. Allowing it to do so can cause cache thrashing, where new
 * prefetch causes previously prefetched buffers to be reclaimed before the
 * processing thread uses them. This results in reading all the inodes and
 * metadata twice per phase and it greatly slows down the processing. Hence we
 * have to carefully control how far ahead we prefetch...
 */

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
