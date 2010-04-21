Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3L8cBOh099070 for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 03:38:12 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C53C4148E1BD
	for <xfs@oss.sgi.com>; Wed, 21 Apr 2010 01:40:10 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id DaE0vyKmeTDlzAhq for <xfs@oss.sgi.com>;
	Wed, 21 Apr 2010 01:40:10 -0700 (PDT)
Date: Wed, 21 Apr 2010 18:40:04 +1000
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100421084004.GS5683@laptop>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop> <20100420103216.GK15130@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420103216.GK15130@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Tue, Apr 20, 2010 at 08:32:16PM +1000, Dave Chinner wrote:
> On Tue, Apr 20, 2010 at 06:38:40PM +1000, Nick Piggin wrote:
> > On Tue, Apr 20, 2010 at 10:41:49AM +1000, Dave Chinner wrote:
> > > And if this is enough of a problem to disallow context based cache
> > > shrinkers, then lets fix the interface so that we encode the
> > > dependencies explicitly in the registration interface rather than
> > > doing it implicitly.
> > > 
> > > IOWs, I don't think this is a valid reason for not allowing a
> > > context to be passed with a shrinker because it is easily fixed.
> > 
> > Well yeah you could do all that maybe. I think it would definitely be
> > required if we were to do context shrinkers like this. But AFAIKS there
> > is simply no need at all. Definitely it is not preventing XFS from
> > following more like the existing shrinker implementations.
> 
> So you're basically saying that we shouldn't improve the shrinker
> interface because you don't think that anyone should be doing
> anything different to what is already there.

I'm saying that dynamic registration is no good, if we don't have a
way to order the shrinkers.

 
> If a change of interface means that we end up with shorter call
> chains, less global state, more flexibilty, better batching and IO
> patterns, less duplication of code and algorithms and it doesn't
> cause any regressions, then where's the problem?

Yep that would all be great but I don't see how the interface change
enables any of that at all. It seems to me that the advantage goes
the other way because it doesn't put as much crap into your mount
structure and you end up with an useful traversable list of mounts as
a side-effect.
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
