Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7348 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbeKMPXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 10:23:19 -0500
Date: Tue, 13 Nov 2018 16:26:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
Message-ID: <20181113052651.GR19305@dastard>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
 <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
 <20181112214515.GN19305@dastard>
 <bd3806ccc911989c7ef1fed9e8d26a4a5ad347a9.camel@perches.com>
 <20181113011804.GP19305@dastard>
 <20181113015410.GB30750@thunk.org>
 <20181113030926.GQ19305@dastard>
 <b03fda08ee4ca4b488c6f67e64bfc94f49be4e83.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b03fda08ee4ca4b488c6f67e64bfc94f49be4e83.camel@perches.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Joe Perches <joe@perches.com>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Nov 12, 2018 at 08:23:42PM -0800, Joe Perches wrote:
> On Tue, 2018-11-13 at 14:09 +1100, Dave Chinner wrote:
> > On Mon, Nov 12, 2018 at 08:54:10PM -0500, Theodore Y. Ts'o wrote:
> > > On Tue, Nov 13, 2018 at 12:18:05PM +1100, Dave Chinner wrote:
> > > > I'm not interested in making code fast if distro support engineers
> > > > can't debug problems on user systems easily. Optimising for
> > > > performance over debuggability is a horrible trade off for us to
> > > > make because it means users and distros end up much more reliant on
> > > > single points of expertise for debugging problems. And that means
> > > > the majority of the load of problem triage falls directly on very
> > > > limited resources - the core XFS development team. A little bit of
> > > > thought about how to make code easier to triage and debug goes a
> > > > long, long way....
> > > 
> > > So at least in my experience, if the kernels are compiled with
> > > CONFIG_DEBUG_INFO and/or CONFIG_DEBUG_INFO_REDUCED,
> > > scripts/decode_stracktrace.sh seems to do a very nice job with inlined
> > 
> > That doesn't help with kernel profiling and other such things that
> > are based on callgraphs...
> 
> If that's really the case:
> 
> I rather suspect the xfs static v STATIC function marking is not
> particularly curated and the marking is somewhat arbitrary.

That's a common opinion for an outsider to form when they come
across something unfamiliar they don't really understand. "I don't
understand this, so I must rewrite it" is an unfortunate habit that
programmers have.

> So perhaps given the large number of static, but not STATIC
> functions, perhaps a sed of s/static/STATIC/ should be done
> when it's not inline for all xfs functions.

That's just as bad as removing them all, if not worse.

If you are writing new code or reworking existing code, then we'll
consider the usage of STATIC/static in the context of that work.
Otherwise, we leave it alone.

It if ain't broke, don't fix it. And it sure as hell isn't broken
right now. We've got more than enough bugs to fix without having to
deal with drive-by bikeshed painting...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
