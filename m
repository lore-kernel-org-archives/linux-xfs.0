Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E9A17F47
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 22:54:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2EDA6304051
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 20:54:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	f6NlMW2uX5poWqg5 for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 20:54:00 -0700 (PDT)
Date: Fri, 9 May 2014 13:53:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] repair: don't unlock prefetch tree to read discontig
	buffers
Message-ID: <20140509035356.GI26353@dastard>
References: <1399598222-4349-1-git-send-email-david@fromorbit.com>
	<1399598222-4349-2-git-send-email-david@fromorbit.com>
	<536C3A07.2050100@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536C3A07.2050100@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, May 08, 2014 at 09:14:31PM -0500, Eric Sandeen wrote:
> On 5/8/14, 8:17 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The way discontiguous buffers are currently handled in prefetch is
> > by unlocking the prefetch tree and reading them one at a time in
> > pf_read_discontig(), inside the normal loop of searching for buffers
> > to read in a more optimized fashion.
> > 
> > But by unlocking the tree, we allow other threads to come in and
> > find buffers which we've already stashed locally on our bplist[].
> > If 2 threads think they own the same set of buffers, they may both
> > try to delete them from the prefetch btree, and the second one to
> > arrive will not find it, resulting in:
> > 
> >         fatal error -- prefetch corruption
> > 
> > To fix this, simply abort the buffer gathering loop when we come
> > across a discontiguous buffer, process the gathered list as per
> > normal, and then after running the large optimised read, check to
> > see if the last buffer on the list is a discontiguous buffer.
> > If is is discontiguous, then issue the discontiguous buffer read
> > while the locks are not held. We only ever have one discontiguous
> > buffer per read loop, so it is safe just to check the last buffer in
> > the list.
> > 
> > The fix is loosely based on a a patch provided by Eric Sandeen, who
> > did all the hard work of finding the bug and demonstrating how to
> > fix it.
> 
> Ok, this makes sense to me.  The comment above the discontig read
> seems a bit confusing; you say it's safe to read while unlocked,
> but I wouldn't have expected it not to be - the lock is just for
> btree manipulation, and that's not being done.  So I think the
> comment adds a little confusion rather than clarification.

Ok, I'll just drop the bit about it being safe to read - the bit
about being the last buffer on the list is the important bit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
