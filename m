Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FCD529E14
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 22:57:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 154ED304039
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 20:57:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ERxR3cSyXLR2hXAf for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 20:57:48 -0700 (PDT)
Date: Wed, 14 Aug 2013 13:57:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 50/50] xfs: use reference counts to free clean buffer items
Message-ID: <20130814035738.GD6023@dastard>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-51-git-send-email-david@fromorbit.com>
	<520A4AB7.1080207@sgi.com> <20130813214648.GC6023@dastard>
	<520AAC79.1030608@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520AAC79.1030608@sgi.com>
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

On Tue, Aug 13, 2013 at 05:00:25PM -0500, Mark Tinguely wrote:
> On 08/13/13 16:46, Dave Chinner wrote:
> >On Tue, Aug 13, 2013 at 10:03:19AM -0500, Mark Tinguely wrote:
> >>On 08/12/13 05:50, Dave Chinner wrote:
> >>>From: Dave Chinner<dchinner@redhat.com>
> >>>
> >>>When a transaction is cancelled and the buffer log item is clean in
> 
> ...
> 
> >>
> >>why is a clean buffer on the AIL? Racing with a completion handler?
> >
> >"clean" means that it wasn't dirtied in the transaction - it can be
> >in the AIL and holding a reference count that way.
> 
> I am wondering because it should not have made it into the CIL if it
> was not dirtied in a transaction - at least according to the the log
> item descriptor flag at least.

CIL != AIL. IOWs, the bli_refcount going to zero doesn't always
mean the bli should be freed. All a zero value means is that it is
not tracked by any transaction. If the item is not going to be
placed in the AIL (or not already in the AIL) then it can be
released (freed). Clean or aborted items are not going into the AIL,
so they can be freed immeidately. Everything else needs to avoid
freeing the item until the correct state is reached, even if the ref
count goes to zero.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
