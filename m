Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 751207F3F
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 17:37:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63BA6304051
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2015 15:37:17 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jMbTNj1p8hyle5vo for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2015 15:37:15 -0800 (PST)
Date: Fri, 9 Jan 2015 10:15:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] xfs: move xfs_bmap_finish prototype
Message-ID: <20150108231503.GJ25000@dastard>
References: <1420666983-7275-1-git-send-email-david@fromorbit.com>
	<1420666983-7275-5-git-send-email-david@fromorbit.com>
	<20150108124627.GD3424@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150108124627.GD3424@infradead.org>
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

On Thu, Jan 08, 2015 at 04:46:27AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 08, 2015 at 08:43:03AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This function is used libxfs code, but is implemented separately in
> > userspace. Move the function prototype to xfs_bmap.h so that the
> > prototype is shared even if the implementations aren't.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Does this help you a lot?  Seems a little on the fringe to me, but
> if it helps I'm fine with it:

It's just another random difference. We define the other bmap
freelist prototypes in xfs_bmap.h (e.g. xfs_bmap_cancel) because
there is libxfs code that uses them, even though the implementations
are not in the shared libxfs code. So while it's a small change, it
makes everything consistent and makes the diff between kernel and
user space just a little smaller.

There's likely to be a few more small changes like this as I work
through all the remaining differences inthe code bases....

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
