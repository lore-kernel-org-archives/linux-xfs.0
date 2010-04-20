Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KAUTMH026511 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 05:30:30 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B36D2DC056
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 03:32:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	BWxoo2YVxDk69KDF for <xfs@oss.sgi.com>;
	Tue, 20 Apr 2010 03:32:26 -0700 (PDT)
Date: Tue, 20 Apr 2010 20:32:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
Message-ID: <20100420103216.GK15130@dastard>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
	<20100418001514.GA26575@infradead.org>
	<20100419140039.GQ5683@laptop> <20100420004149.GA14744@dastard>
	<20100420083840.GR5683@laptop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420083840.GR5683@laptop>
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

On Tue, Apr 20, 2010 at 06:38:40PM +1000, Nick Piggin wrote:
> On Tue, Apr 20, 2010 at 10:41:49AM +1000, Dave Chinner wrote:
> > And if this is enough of a problem to disallow context based cache
> > shrinkers, then lets fix the interface so that we encode the
> > dependencies explicitly in the registration interface rather than
> > doing it implicitly.
> > 
> > IOWs, I don't think this is a valid reason for not allowing a
> > context to be passed with a shrinker because it is easily fixed.
> 
> Well yeah you could do all that maybe. I think it would definitely be
> required if we were to do context shrinkers like this. But AFAIKS there
> is simply no need at all. Definitely it is not preventing XFS from
> following more like the existing shrinker implementations.

So you're basically saying that we shouldn't improve the shrinker
interface because you don't think that anyone should be doing
anything different to what is already there.

If a change of interface means that we end up with shorter call
chains, less global state, more flexibilty, better batching and IO
patterns, less duplication of code and algorithms and it doesn't
cause any regressions, then where's the problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
