Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A66829DF9
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 18:58:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 56BE38F8078
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 16:58:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VVm4MY4oBYhFIZ9q for <xfs@oss.sgi.com>;
	Fri, 15 Aug 2014 16:58:56 -0700 (PDT)
Date: Sat, 16 Aug 2014 09:58:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: check xfs_buf_read_uncached returns correctly
Message-ID: <20140815235843.GA26465@dastard>
References: <1408084747-4540-1-git-send-email-david@fromorbit.com>
	<1408084747-4540-10-git-send-email-david@fromorbit.com>
	<20140815125608.GA27856@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140815125608.GA27856@infradead.org>
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
Cc: xfs@oss.sgi.com

On Fri, Aug 15, 2014 at 05:56:08AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 15, 2014 at 04:39:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_buf_read_uncached() has two failure modes. If can either return
> > NULL or bp->b_error != 0 depending on the type of failure, and not
> > all callers check for both. Fix it up.
> 
> I'd rather get rid of these annoying calling conventions.  Make it
> return and errno, and the bp in a pointer argument, with the bp
> never non-NULL in case of error.

Ok. I considered that, then just did the simple thing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
