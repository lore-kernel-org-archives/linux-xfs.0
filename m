Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5770B7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:24:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E85D8AC002
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:24:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OIMRciW2WQE2zdSn for <xfs@oss.sgi.com>;
	Thu, 24 Oct 2013 14:24:51 -0700 (PDT)
Date: Fri, 25 Oct 2013 08:24:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent stack overflows from page cache allocation
Message-ID: <20131024212448.GW2797@dastard>
References: <1382585110-1796-1-git-send-email-david@fromorbit.com>
	<20131024084803.GA28144@infradead.org>
	<20131024103751.GS2797@dastard>
	<20131024154220.GA19055@infradead.org>
	<20131024164115.GU1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024164115.GU1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 24, 2013 at 11:41:15AM -0500, Ben Myers wrote:
> Hey,
> 
> On Thu, Oct 24, 2013 at 08:42:20AM -0700, Christoph Hellwig wrote:
> > On Thu, Oct 24, 2013 at 09:37:51PM +1100, Dave Chinner wrote:
> > > Sure, if you want to. But doing that shouldn't prevent this fix from
> > > being committed in the mean time, especially as other filesystems
> > > already use this method for avoiding these problems.
> > 
> > I'd much prefer aiming for the proper fix first.  If for some reason we
> > can't get it done in time the workaround can be applied.
> 
> Dave probably has a customer waiting on this.

Obviously. And being a kernel where we have a fixed ABI, we can't
backport any fix that changes core code.

> If pulling this in will make a
> proper fix more difficult to do I can understand keeping the patch out.

It doesn't make a proper fix any harder - removing 2 lines of code
is trivial.

> Otherwise, can't we just remove this along with the other filesystems'
> equivalent code when the proper fix is committed?

Yes, we can.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
