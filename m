Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FB067F3F
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 19:54:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25490304075
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:54:34 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id lbLfT9hSeymjRq9D (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 17:54:33 -0800 (PST)
Date: Tue, 25 Feb 2014 17:54:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] libxfs: remove a couple of locks
Message-ID: <20140226015432.GC3616@infradead.org>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-9-git-send-email-david@fromorbit.com>
	<20140225200558.GC22351@infradead.org>
	<20140225234357.GJ13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140225234357.GJ13647@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 26, 2014 at 10:43:57AM +1100, Dave Chinner wrote:
> On Tue, Feb 25, 2014 at 12:05:58PM -0800, Christoph Hellwig wrote:
> > So what's protecting the cache hits statistics now?
> 
> Nothing. And I don't care because the statistic is meaningless from
> the point of view of tuning xfs_repair performance.

In that case I think it's better to just remove c_hits instead of
updating it in a racy way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
