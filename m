Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1305X6l081847 for <xfs@oss.sgi.com>; Wed, 2 Feb 2011 18:05:34 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1AC7C1BC83FA
	for <xfs@oss.sgi.com>; Wed,  2 Feb 2011 16:08:01 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Ms3Z17OeEDhZNpOa for <xfs@oss.sgi.com>;
	Wed, 02 Feb 2011 16:08:01 -0800 (PST)
Date: Thu, 3 Feb 2011 11:07:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] XFS update for 2.6.38-rc3
Message-ID: <20110203000757.GT11040@dastard>
References: <201101311642.p0VGgXTS018851@stout.americas.sgi.com>
	<4D482E21.5040803@teksavvy.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D482E21.5040803@teksavvy.com>
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
To: Mark Lord <kernel@teksavvy.com>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Tue, Feb 01, 2011 at 11:00:33AM -0500, Mark Lord wrote:
> On 11-01-31 11:42 AM, Alex Elder wrote:
> > Linus, please accept the following updates for XFS, for 2.6.38-rc3
> > (if it's not too late) or 2.6.38-rc4.
> > 
> > They are all fixes for bugs that have some pretty undesirable
> > consequences.  They address:
> > - One spot in which a hang can occur due to neglecting to drop a
> >   lock
> > - A bug which in some cases a bogus block number can be recorded in
> >   a block map btree, resulting in a subsequent BUG_ON().
> > - Two memory leaks
> > - Three places in which extent sizes are allowed to exceed various
> >   size limits
> > - One place where code depends on behavior that is not well-defined
> >   by the C standard
> > - One problem in handling transaction commit errors
> 
> 
> Are these bugs all new in 2.6.38, or should some of these fixes
> also go out to -stable for earlier revisions?
> 
> 
> > Dave Chinner (8):
> >       xfs: fix log ticket leak on forced shutdown.
> >       xfs: fix efi item leak on forced shutdown

Been there for years, extremely hard to hit, so no.

> >       xfs: speculative delayed allocation uses rounddown_power_of_2 badly

-38-rc1 regression, so no.

> >       xfs: limit extent length for allocation to AG size
> >       xfs: prevent extsize alignment from exceeding maximum extent size
> >       xfs: limit extsize to size of AGs and/or MAXEXTLEN

Been there for years in little used functionality, so no.

> >       xfs: handle CIl transaction commit failures correctly

Introduced with new code in 2.6.35, hard to hit, only results in
small memory leaks, so no.

> >       xfs: fix dquot shaker deadlock

That's a regression, so maybe.

> > bpm@sgi.com (1):
> >       xfs: xfs_bmap_add_extent_delay_real should init br_startblock

Been there for years, no evidence ATM that this code path can be
exercised with a mainline kernel, so no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
