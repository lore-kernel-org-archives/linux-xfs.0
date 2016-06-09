Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CA237CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 18:33:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01F6D8F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 16:33:49 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wdExOUKWcL6TeqB6 for <xfs@oss.sgi.com>;
	Thu, 09 Jun 2016 16:33:47 -0700 (PDT)
Date: Fri, 10 Jun 2016 09:33:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160609233344.GA26977@dastard>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard> <20160608071130.GB24663@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160608071130.GB24663@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com, darrick.wong@oracle.com

On Wed, Jun 08, 2016 at 09:11:30AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> > On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > > I've had some vocal user requests to allow enabling reflinks at run time,
> > > which happens to be a mostly trivial feature.  The only caveat is that we
> > > need a large enough log size to support the reflink requirements, but for
> > > typical large file systems that's not an issue.
> > 
> > Hmmm - how does this interact with all the rmap code? I was not
> > planning on enabling reflink without rmap and vice versa simply
> > because it makes the validation and testing matrix vastly more
> > complex.
> 
> Uh.  So far I've only been testing pure reflink code, mostly because
> rmap really doesn't buy much for the use case I'm working on.
> Enabling rmap post-mkfs is defintively a different ballpark, and probably
> not worth it even if it would be doable.

Wasn't expecting rmap to ever be dynamically enabled ;)

So ignoring the testing side of things, and looking more at the
implementation of the enabling, I'm not sure I really like the idea
of doing this via a mount option. Because we've got to make
significant additions to the on disk format in each AG, this seems
more like a "growfs style" operation than anything. i.e. lock out
allocation, add all the structures to the AG headers and allocate
all the blocks needed, re-initialise the per-ag structures with all
the necessary info, then switch on the feature bit and commit the
change.

It's probably a little more intricate than doing it at mount time,
but it gets around the fact that users have to add a mount option
and bounce the filesystem to turn on reflinks.
I can see this being much easier than a mount option in some
situations, (e.g. for the root filesystem), and I don't think it's
much harder to test than the mount option (e.g. the way growfs is
tested under stress by xfs/104)...

Your thoughts, Christoph?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
