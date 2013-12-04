Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD24829E12
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 17:32:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C12DD304093
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 15:32:51 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	fARBOrwETcuwsL52 for <xfs@oss.sgi.com>;
	Wed, 04 Dec 2013 15:32:47 -0800 (PST)
Date: Thu, 5 Dec 2013 10:32:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs v3.2.0-alpha2
Message-ID: <20131204233239.GF8803@dastard>
References: <5293A699.20908@sgi.com> <20131128104002.GC26927@infradead.org>
	<20131128211858.GR10988@dastard>
	<20131129080538.GA31310@infradead.org>
	<20131203221714.GY10988@dastard> <20131203224354.GR1935@sgi.com>
	<20131204110023.GA3263@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204110023.GA3263@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Rich Johnston <rjohnston@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Dec 04, 2013 at 03:00:23AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 03, 2013 at 04:43:54PM -0600, Ben Myers wrote:
> > IIRC last time we discussed this I expressed a preference for focussing
> > on the 3.2.0 release, but did not object to a 3.1.12 either.  I think
> > Eric followed up and asked if Christoph had specific concerns that
> > should prompt a 3.1.12 release.  Now I think it's probably just best to
> > focus on the xfs_repair bits for 3.2.0.
> 
> My concern is pretty simple: we have a big batch of minor and not so
> minor fixes that I want to get out to our users.  We've done releases
> about every 3 month for the last couple years, but we've not done any
> for 6 month by now.
> 
> I have to admit I'm a bit out of the loop on the v5 repair work, but if
> Dave feels confident that he can get it done soon we should aim for a
> 3.2.0 release after that.  If not it's more than time to get a 3.1.12
> out and I'd be happy to do the work for it.

There's a bit of mess involved in the repair stuff - basically
propagating CRC errors and other errors detected by the verifiers
is a bit nasty and touches a lot of the repair code (think
everywhere that reads a buffer). I'm trying to work out a sane way
to handle this, but I haven't managed to do it in a manner I
consider acceptable and maintainable in the long term yet. Once I
work out a method of doing that sanely, I'll mangle the code to
handle it.

However, this really needs changes to the verifier instructure to be
able to distinguish between CRC errors and structure corruption
errors, so there's kernel changes that need to be done there as
well. Eventually we need the same distinction in the kernel code,
so I need to work it all out in terms of what reapir needs, then do
the kernel mods, and then port them back to userspace....

In short, there's still a significant amount of work needed here.

Oh, and there's still the dir ftype validation that needs to be
done - that's a separate piece of work, so maybe someone else
would like to tackle that so it gets done sooner?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
