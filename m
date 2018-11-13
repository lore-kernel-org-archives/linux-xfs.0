Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57344 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbeKMNFe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Nov 2018 08:05:34 -0500
Date: Tue, 13 Nov 2018 14:09:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
Message-ID: <20181113030926.GQ19305@dastard>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
 <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
 <20181112214515.GN19305@dastard>
 <bd3806ccc911989c7ef1fed9e8d26a4a5ad347a9.camel@perches.com>
 <20181113011804.GP19305@dastard>
 <20181113015410.GB30750@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113015410.GB30750@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Joe Perches <joe@perches.com>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, Nov 12, 2018 at 08:54:10PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Nov 13, 2018 at 12:18:05PM +1100, Dave Chinner wrote:
> > I'm not interested in making code fast if distro support engineers
> > can't debug problems on user systems easily. Optimising for
> > performance over debuggability is a horrible trade off for us to
> > make because it means users and distros end up much more reliant on
> > single points of expertise for debugging problems. And that means
> > the majority of the load of problem triage falls directly on very
> > limited resources - the core XFS development team. A little bit of
> > thought about how to make code easier to triage and debug goes a
> > long, long way....
> 
> So at least in my experience, if the kernels are compiled with
> CONFIG_DEBUG_INFO and/or CONFIG_DEBUG_INFO_REDUCED,
> scripts/decode_stracktrace.sh seems to do a very nice job with inlined

That doesn't help with kernel profiling and other such things that
are based on callgraphs...

> functions.  Now, ext4 generally only has about 3 or 4 nested inlines,
> and so I don't know how it works with 20 or 30 nested inlined
> functions, so perhaps this is not applicable for XFS.
> 
> But it perhaps toolchain technology has advanced since the Irix days
> such that it's no longer as necessary to force the non-inlining of
> functions for easing debugging?

Not that I've noticed.

Indeed, modern toolchains are moving the opposite direction - have
you ever tried to debug a binary with gdb that was compiled with LTO
enabled? Or maybe even just tried to profile it with perf?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
