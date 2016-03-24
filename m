Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79C1E7CA0
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 17:00:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F82DAC009
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 15:00:25 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9gsuq5Fwzawnv8pz for <xfs@oss.sgi.com>;
	Thu, 24 Mar 2016 15:00:22 -0700 (PDT)
Date: Fri, 25 Mar 2016 09:00:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failing XFS memory allocation
Message-ID: <20160324220021.GF11812@dastard>
References: <56F26CCE.6010502@kyup.com>
	<20160323124312.GB43073@bfoster.bfoster> <56F29279.70600@kyup.com>
	<20160323131059.GC43073@bfoster.bfoster>
	<20160323230002.GY30721@dastard>
	<20160324093127.GA4204@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160324093127.GA4204@infradead.org>
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
Cc: Brian Foster <bfoster@redhat.com>, Nikolay Borisov <kernel@kyup.com>, xfs@oss.sgi.com

On Thu, Mar 24, 2016 at 02:31:27AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 24, 2016 at 10:00:02AM +1100, Dave Chinner wrote:
> > I'm working on prototype patches to convert it to an in-memory btree
> > but they are far from ready at this point. This isn't straight
> > forward because all the extent management code assumes extents are
> > kept in a linear array and can be directly indexed by array offset
> > rather than file offset. I also want to make sure we can demand page
> > the extent list if necessary, and that also complicates things like
> > locking, as we currently assume the extent list is either completely
> > in memory or not in memory at all.
> 
> FYI, I did patches to get rid almost all direct extent array access
> a while ago, but I never bothered to post it as it seemed to much
> churn.  Have you started that work yet or would it be useful
> to dust those up again?

I've done bits of it, but haven't completed it - send me the patches
and I'll see which approch makes the most sense...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
