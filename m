Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93F057F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:56:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BF9CAC004
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 13:56:24 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id n27fzuh13NvvWQo4 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 13:56:19 -0800 (PST)
Date: Tue, 25 Feb 2014 13:56:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/6] xfstests: Define fallocate flags locally in fsx
Message-ID: <20140225215616.GA29752@infradead.org>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
	<1393355728-12056-5-git-send-email-lczerner@redhat.com>
	<20140225203922.GC13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225203922.GC13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 26, 2014 at 07:39:22AM +1100, Dave Chinner wrote:
> > index b3c30db..331257e 100644
> > --- a/ltp/fsx.c
> > +++ b/ltp/fsx.c
> > @@ -35,8 +35,13 @@
> >  #endif
> >  #ifdef FALLOCATE
> >  #include <linux/falloc.h>
> > +#ifndef FALLOC_FL_PUNCH_HOLE
> > +#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
> > +#endif
> > +#ifndef FALLOC_FL_ZERO_RANGE
> > +#define FALLOC_FL_ZERO_RANGE    0x10 /* zeroes range */
> > +#endif
> >  #endif
> 
> This pattern is appearing all over the place in xfstests now.  I'd
> suggest that this should really be handled by autoconf,
> include/config.h and src/globals.h....

Can we handle this nicely using autoconf, especially in the case of O_
flags that might be different for different architectures?

Either way having a single header for the various flags that might not
be present in the system headers sounds like a good plan.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
