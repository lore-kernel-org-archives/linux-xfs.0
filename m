Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B256B7F37
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 00:07:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9041E304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 22:07:38 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Y3fdGfns61MNmT8U for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 22:07:36 -0800 (PST)
Date: Wed, 26 Feb 2014 17:07:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Message-ID: <20140226060733.GT13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-5-git-send-email-lczerner@redhat.com>
	<20140225203922.GC13647@dastard>
	<20140225215616.GA29752@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225215616.GA29752@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 01:56:16PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 26, 2014 at 07:39:22AM +1100, Dave Chinner wrote:
> > > index b3c30db..331257e 100644
> > > --- a/ltp/fsx.c
> > > +++ b/ltp/fsx.c
> > > @@ -35,8 +35,13 @@
> > >  #endif
> > >  #ifdef FALLOCATE
> > >  #include <linux/falloc.h>
> > > +#ifndef FALLOC_FL_PUNCH_HOLE
> > > +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> > > +#endif
> > > +#ifndef FALLOC_FL_ZERO_RANGE
> > > +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> > > +#endif
> > >  #endif
> > 
> > This pattern is appearing all over the place in xfstests now.  I'd
> > suggest that this should really be handled by autoconf,
> > include/config.h and src/globals.h....
> 
> Can we handle this nicely using autoconf, especially in the case of O_
> flags that might be different for different architectures?

I think so, because config.h is generated from config.h.in and
ends up looking like:

#define HAVE_SOME_FUNCTION 1

src/globals.h is controlled directly by us, and ends up looking
like:

#ifdef HAVE_SOME_FUNCTION
#include <header_for_some_function.h>
#endif

If we add all the defines that may be missing that same ifdef
section, and make sure that all code includes globals.h, then
all the code will have the "HAVE_SOME_FUNCTION" defines and the
appropriate header files and definitions included.

> Either way having a single header for the various flags that might not
> be present in the system headers sounds like a good plan.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
