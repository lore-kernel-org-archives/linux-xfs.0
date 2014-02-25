Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96A527F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:44:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 37C32AC005
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:44:03 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4r1gUPKq1kou00Fn for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 15:44:00 -0800 (PST)
Date: Wed, 26 Feb 2014 10:43:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] libxfs: remove a couple of locks
Message-ID: <20140225234357.GJ13647@dastard>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-9-git-send-email-david@fromorbit.com>
	<20140225200558.GC22351@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225200558.GC22351@infradead.org>
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

On Tue, Feb 25, 2014 at 12:05:58PM -0800, Christoph Hellwig wrote:
> So what's protecting the cache hits statistics now?

Nothing. And I don't care because the statistic is meaningless from
the point of view of tuning xfs_repair performance.

> Longer term it might make sense to just port the XFS buffercache from
> the kernel to libxfs..

*nod*

We badly need to separate the buffer cache into per-AG caches
because most of the per-thread operations are isolated to a single
AG and so a global hash simply doesn't scale from a lock contention
or a table sizing point of view....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
