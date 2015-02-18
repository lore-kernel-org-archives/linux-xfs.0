Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1BF857F6B
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 18:48:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A9E9304032
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 16:48:43 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VJ7h5ok0M8pqz3I1 for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 16:48:41 -0800 (PST)
Date: Wed, 18 Feb 2015 11:48:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
Message-ID: <20150218004838.GM4251@dastard>
References: <1423782857-11800-1-git-send-email-david@fromorbit.com>
	<54DE8B6D.8010401@sgi.com> <20150214232951.GW4251@dastard>
	<54E16667.1050200@gmail.com> <54E22A76.40106@sgi.com>
	<20150216231716.GB4251@dastard> <54E36016.20908@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54E36016.20908@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Tue, Feb 17, 2015 at 10:36:54AM -0500, Michael L. Semon wrote:
> On 02/16/15 18:17, Dave Chinner wrote:
> > On Mon, Feb 16, 2015 at 11:35:50AM -0600, Mark Tinguely wrote:
> >> Thanks Michael, you don't need to hold your test box for me. I do
> >> have a way to recreate these ABBA AGF buffer allocation deadlocks
> >> and understand the whys and hows very well. I don't have a community
> >> way to make a xfstest for it but I think your test is getting close.
> > 
> > If you know what is causing them, then please explain how it occurs
> > and how you think it needs to be fixed. Just telling us that you know
> > something that we don't doesn't help us solve the problem. :(
> > 
> > In general, the use of the args->firstblock is supposed to avoid the
> > ABBA locking order issues with multiple allocations in the one
> > transaction by preventing AG selection loops from looping back into
> > AGs with a lower index than the first allocation that was made.
> > 
> > So if you are seeing deadlocks, then it may be that we aren't
> > following this constraint correctly in all locations....
> 
> Will this be a classic deadlock that will cause problems when trying to
> kill processes and unmount filesystems?  If so, then I was unable to use
> generic/224 to trigger a deadlock.  If not, then I'll need a better way
> of looking at the problem.

Yes, it will hang the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
