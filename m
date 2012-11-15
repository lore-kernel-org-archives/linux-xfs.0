Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAF5vt1k219130 for <xfs@oss.sgi.com>; Wed, 14 Nov 2012 23:57:55 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	egSQEz0tfNdTVjtA for <xfs@oss.sgi.com>;
	Wed, 14 Nov 2012 21:59:58 -0800 (PST)
Date: Thu, 15 Nov 2012 16:59:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/32] xfs: factor dir2 block read operations
Message-ID: <20121115055956.GB14281@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-20-git-send-email-david@fromorbit.com>
	<20121115030928.GA27055@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121115030928.GA27055@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 14, 2012 at 09:09:28PM -0600, Ben Myers wrote:
> On Mon, Nov 12, 2012 at 10:54:11PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In preparation for verifying dir2 block format buffers, factor
> > the read operations out of the block operations (lookup, addname,
> > getdents) and some of the additional logic to make it easier to
> > understand an dmodify the code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This was a difficult review.  I think you have at least three ideas in here
> which could be split up.  Please keep the reviewer in mind.

I do, but it's a trade-off.

If I split every patch upon fine grained "idea" boundaries, I'm
going to generate 5x the number of patches compared to what I'm
already posting.  Massively deep patch stacks that have top to
bottom dependencies (which these patch series have) are a nightmare
to maintain and develop, and I'm already at that limit given the
number of patches I already have on top of this series. If I can't
manage the series, then it doesn't matter whether it's easy to
review or not - the work simply won't get done because I'll be
spending all my time patch monkeying instead of writing and testing
code....

IOWs, I'm making the series as fine grained as possible, but there
are going to be some patches where splitting them up is just
make-work that provides zero gain whilst increasing management
overhead....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
