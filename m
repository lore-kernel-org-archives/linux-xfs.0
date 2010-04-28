Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S3aqTu198874 for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 22:36:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DB822F86F7
	for <xfs@oss.sgi.com>; Tue, 27 Apr 2010 20:38:50 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	o71T3CC2kvPRTMMM for <xfs@oss.sgi.com>;
	Tue, 27 Apr 2010 20:38:50 -0700 (PDT)
Date: Wed, 28 Apr 2010 13:38:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100428033829.GE9783@dastard>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop> <20100420103216.GK15130@dastard>
	<20100421084004.GS5683@laptop>
	<20100422163211.GA2478@infradead.org>
	<20100422163801.GZ5683@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422163801.GZ5683@laptop>
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
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Fri, Apr 23, 2010 at 02:38:01AM +1000, Nick Piggin wrote:
> On Thu, Apr 22, 2010 at 12:32:11PM -0400, Christoph Hellwig wrote:
> > On Wed, Apr 21, 2010 at 06:40:04PM +1000, Nick Piggin wrote:
> > > I'm saying that dynamic registration is no good, if we don't have a
> > > way to order the shrinkers.
> > 
> > We can happily throw in a priority field into the shrinker structure,
> > but at this stage in the release process I'd rather have an as simple
> > as possible fix for the regression.  And just adding the context pointer
> > which is a no-op for all existing shrinkers fits that scheme very well.
> > 
> > If it makes you happier I can queue up a patch to add the priorities
> > for 2.6.35.  I think figuring out any meaningful priorities will be
> > much harder than that, though.
> 
> I don't understand, it should be implemented like just all the other
> shrinkers AFAIKS. Like the dcache one that has to shrink multiple
> superblocks. There is absolutely no requirement for this API change
> to implement it in XFS.

Well, I've gone and done this global shrinker because I need a fix
for the problem before .34 releases, not because I like it.

Now my problem is that the accepted method of using global shrinkers
(i.e. split nr_to-scan into portions based on per-fs usage) is
causing a regression compared to not having a shrinker at all. The
context based shrinker did not cause this regression, either.

The regression is oom-killer panics with "no killable tasks" - it
kills my 1GB RAM VM dead.  Without a shrinker or with the context
based shrinkers I will see one or two dd processes getting
OOM-killed maybe once every 10 or so runs on this VM, but the machine
continues to stay up. The global shrinker is turning this into a
panic, and it is happening about twice as often.

To fix this I've had to remove all the code that proportions the
reclaim across all the XFS filesystems in the system. Basically it
now walks from the first filesystem in the list to the last every
time and effectively it only reclaims from the first filesystem it
finds with reclaimable inodes.

This is exactly the behaviour the context based shrinkers give me,
without the need for adding global lists, additional locking and
traverses. Also, context based shrinkers won't re-traverse all the
filesystems, avoiding the potential for starving some filesystems of
shrinker based reclaim if filesystems earlier in the list are
putting more inodes into reclaim concurrently.

Given that this behaviour matches pretty closely to the reasons I've
already given for preferring context based per-fs shrinkers than a
global shrinker and list, can we please move forward with this API
change, Nick?

As it is, I'm going to cross my fingers and ship this global
shrinker because of time limitations, but I certainly hoping that
for .35 we can move to context based shrinking....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
