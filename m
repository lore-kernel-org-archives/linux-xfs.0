Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D4F27CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:54:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A982304039
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 15:54:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	olQXsmHD0oT0PHV9 for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 15:54:36 -0700 (PDT)
Date: Thu, 20 Jun 2013 08:54:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/60] xfs: patch queue for 3.11
Message-ID: <20130619225404.GJ29338@dastard>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<20130619143537.GN20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130619143537.GN20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 19, 2013 at 09:35:37AM -0500, Ben Myers wrote:
> Dave,
> 
> On Wed, Jun 19, 2013 at 02:50:08PM +1000, Dave Chinner wrote:
> > This is my patch queue for 3.11 as it stands right now.
> 
> Getting all of this in for 3.11 does not strike me as being
> realistic.

Why not? We've done more complex changes in the past...

> You need to think about how this can be split up.

Sure - the first 27 patches at the necessary ones for 3.11.

> I
> see that you have rebased Jeff's log size validation patch set
> after your rearrangement.  I'd rather you'd taken Jeff's series
> first and then made your changes.  Now we can't pull in Jeff's
> work without pulling in a bunch of rearrangement that hasn't been
> fully discussed.

Sure, but Jeff's work hadn't been reviewed or QA'd by anyone else,
so what's the problem? If the Maintainers had their job that a month
ago when Jeff posted the patches, then this wouldn't be an issue as
my patchset would now be based on top of it.

You're welcome to go review, test and integrate Jeff's patchset
before mine - I'll just have to rebase my patchset.

> You have also crowded out Chandra's quota work.  We had an
> agreement with him to go for 3.11 with that work which you have broken.

You're blaming me for the fact the Maintainers haven't reviewed and
integrated Chandra's latest quota patchset that was posted 6 weeks
ago?

Feel free to get Chandra to repost the patchset and review and
integrate it before taking any of my changes. I'll just rebase my
patchset on top of whatever ends up in the XFS tree....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
