Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C810F29DFB
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 19:50:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B545D304059
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 17:50:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wBlsWtJmJj6IhyfH for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 17:49:59 -0700 (PDT)
Date: Thu, 15 Aug 2013 10:48:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
Message-ID: <20130815004823.GK6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
	<520A4AB7.1080207@sgi.com> <20130813214648.GC6023@dastard>
	<520AAC79.1030608@sgi.com> <20130814035738.GD6023@dastard>
	<520B857C.9050607@sgi.com> <520BC31D.2060603@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520BC31D.2060603@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 14, 2013 at 12:49:17PM -0500, Mark Tinguely wrote:
> On 08/14/13 08:26, Mark Tinguely wrote:
> >On 08/13/13 22:57, Dave Chinner wrote:
> >>On Tue, Aug 13, 2013 at 05:00:25PM -0500, Mark Tinguely wrote:
> >>>On 08/13/13 16:46, Dave Chinner wrote:
> >>>>On Tue, Aug 13, 2013 at 10:03:19AM -0500, Mark Tinguely wrote:
> >>>>>On 08/12/13 05:50, Dave Chinner wrote:
> >>>>>>From: Dave Chinner<dchinner@redhat.com>
> >>>>>>
> >>>>>>When a transaction is cancelled and the buffer log item is clean in
> >>>
> >>>...
> >>>
> >>>>>
> >>>>>why is a clean buffer on the AIL? Racing with a completion handler?
> >>>>
> >>>>"clean" means that it wasn't dirtied in the transaction - it can be
> >>>>in the AIL and holding a reference count that way.
> >>>
> >>>I am wondering because it should not have made it into the CIL if it
> >>>was not dirtied in a transaction - at least according to the the log
> >>>item descriptor flag at least.
> >>
> >>CIL != AIL. IOWs, the bli_refcount going to zero doesn't always
> >>mean the bli should be freed. All a zero value means is that it is
> >>not tracked by any transaction. If the item is not going to be
> >>placed in the AIL (or not already in the AIL) then it can be
> >>released (freed). Clean or aborted items are not going into the AIL,
> >>so they can be freed immeidately. Everything else needs to avoid
> >>freeing the item until the correct state is reached, even if the ref
> >>count goes to zero.
> >>
> >
> >yep.
> >
> >You are saying that the problem is releasing a buffer that is clean and
> >also in the AIL, I am just trying to figure out if you are fixing a
> >symptom or the problem.
> >
> >--Mark.
> 
> 
> Sorry for the noise - I was thinking wrong - the clean check is on
> the current transaction format map for some reason I had buffer maps
> on my mind - so I get to wear the pointy hat *again* today!

I think you are still misunderstanding it - the format map will
remain dirty even when the item is in the AIL. If the item is
relogged, then it has to log all the same regions as the AIL is
currently tracking again.

This is why a buffer that is clean *cannot* be in the AIL - it has
to be dirty in some way for it to have been committed to the log and
then placed in the AIL. And that dirty status is kept until the item
is removed from the AIL and freed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
