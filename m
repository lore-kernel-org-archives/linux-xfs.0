Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 94B887F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 23:53:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 796188F8073
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:53:37 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TEy1zocI56Ji2APm for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 21:53:35 -0800 (PST)
Date: Wed, 26 Feb 2014 16:53:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] libxfs: remove a couple of locks
Message-ID: <20140226055333.GR13647@dastard>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-9-git-send-email-david@fromorbit.com>
	<20140225200558.GC22351@infradead.org>
	<20140225234357.GJ13647@dastard>
	<20140226015432.GC3616@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140226015432.GC3616@infradead.org>
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

On Tue, Feb 25, 2014 at 05:54:32PM -0800, Christoph Hellwig wrote:
> On Wed, Feb 26, 2014 at 10:43:57AM +1100, Dave Chinner wrote:
> > On Tue, Feb 25, 2014 at 12:05:58PM -0800, Christoph Hellwig wrote:
> > > So what's protecting the cache hits statistics now?
> > 
> > Nothing. And I don't care because the statistic is meaningless from
> > the point of view of tuning xfs_repair performance.
> 
> In that case I think it's better to just remove c_hits instead of
> updating it in a racy way.

I didn't say it's completely meaningless - it's handy for debugging,
just not useful to end users and so accuracy isn't important enough
to use a global lock on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
