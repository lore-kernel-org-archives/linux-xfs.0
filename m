Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48572 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbeKMLuM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Nov 2018 06:50:12 -0500
Date: Mon, 12 Nov 2018 20:54:10 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] xfs: Remove noinline from #define STATIC
Message-ID: <20181113015410.GB30750@thunk.org>
References: <7302f4a13c1cbf62b07f636878ce25fcca84b6c4.camel@perches.com>
 <6420cf91-89c8-a876-7a0d-25ab8ba428b8@sandeen.net>
 <20181112214515.GN19305@dastard>
 <bd3806ccc911989c7ef1fed9e8d26a4a5ad347a9.camel@perches.com>
 <20181113011804.GP19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113011804.GP19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Joe Perches <joe@perches.com>, Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Tue, Nov 13, 2018 at 12:18:05PM +1100, Dave Chinner wrote:
> I'm not interested in making code fast if distro support engineers
> can't debug problems on user systems easily. Optimising for
> performance over debuggability is a horrible trade off for us to
> make because it means users and distros end up much more reliant on
> single points of expertise for debugging problems. And that means
> the majority of the load of problem triage falls directly on very
> limited resources - the core XFS development team. A little bit of
> thought about how to make code easier to triage and debug goes a
> long, long way....

So at least in my experience, if the kernels are compiled with
CONFIG_DEBUG_INFO and/or CONFIG_DEBUG_INFO_REDUCED,
scripts/decode_stracktrace.sh seems to do a very nice job with inlined
functions.  Now, ext4 generally only has about 3 or 4 nested inlines,
and so I don't know how it works with 20 or 30 nested inlined
functions, so perhaps this is not applicable for XFS.

But it perhaps toolchain technology has advanced since the Irix days
such that it's no longer as necessary to force the non-inlining of
functions for easing debugging?

					- Ted
