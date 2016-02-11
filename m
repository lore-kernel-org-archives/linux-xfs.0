Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E2B317CA8
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 14:59:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C306F8F8050
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:59:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wQOQFesTED42SsaI for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 12:59:17 -0800 (PST)
Date: Fri, 12 Feb 2016 07:59:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/8] xfs: remove xfs_cancel_ioend
Message-ID: <20160211205916.GK19486@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-3-git-send-email-david@fromorbit.com>
	<20160210112800.GA15221@infradead.org>
	<20160211002137.GR14668@dastard>
	<20160211151425.GB13515@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160211151425.GB13515@infradead.org>
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

On Thu, Feb 11, 2016 at 07:14:25AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 11, 2016 at 11:21:37AM +1100, Dave Chinner wrote:
> > I'll propagate it through where it makes sense. If we alrady have an
> > error, then we aren't going to call xfs_setfilesize_trans_alloc()
> > anyway, so checking the return value only matters in the non-error
> > cases.
> 
> Oh, I missed that we don't care about the failure case.  Maybe we
> should just call xfs_setfilesize_trans_alloc instead, and just move
> the conditionals to it so that it's a no-op if no transaction is needed?

OK, but let's make cleanups like this at the start of the next
batch of work we are already working on for this code so this can be
finalised and made available for wider testing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
